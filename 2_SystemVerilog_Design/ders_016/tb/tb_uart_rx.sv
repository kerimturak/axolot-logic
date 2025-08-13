`timescale 1ns / 1ps

module tb_uart_rx;

  // Testbench Parametreleri
  // ---
  parameter DATA_WIDTH = 8;
  parameter FIFO_DEPTH = 16;
  parameter CLK_PERIOD = 10;  // 100MHz clock (10ns period)
  parameter BAUD_DIV = 104;  // 9600 baud rate için
  parameter BAUD_CLK_HALF_PERIOD = (CLK_PERIOD * BAUD_DIV) / 2;
  parameter BAUD_CLK_PERIOD = (CLK_PERIOD * BAUD_DIV);


  // Test Sinyalleri
  // ---
  logic        clk_i = 0;
  logic        rst_ni;
  logic [15:0] baud_div_i;
  logic        rx_re_i;
  logic        rx_en_i;
  logic        rx_bit_i;
  logic [ 7:0] dout_o;
  logic        full_o;
  logic        empty_o;

  // Test Verileri
  // ---
  // Gönderilecek test verisi dizisi
  logic [ 7:0] test_data_arr_tx [] = {'h41, 'h42, 'h43, 'h0A};  // "ABC\n"

  // Alınan veriyi karşılaştırmak için kullanılacak FIFO
  logic [ 7:0] golden_model_fifo[$                                        ];


  // Doğrulama İçin Kullanılacak Sinyaller
  // ---
  int          tx_data_index;
  int          rx_data_index;

  // DUT (Device Under Test)
  // ---
  uart_rx #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) dut (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .baud_div_i(baud_div_i),
      .rx_re_i   (rx_re_i),
      .rx_en_i   (rx_en_i),
      .rx_bit_i  (rx_bit_i),
      .dout_o    (dout_o),
      .full_o    (full_o),
      .empty_o   (empty_o)
  );

  // Saat Sinyali Üretimi
  // ---
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Gönderim Fonksiyonları (Simüle Edilmiş TX)
  // ---
  // Tek bir byte'ı UART protokolüne göre gönderir
  task send_byte(input logic [7:0] data);
    $strobe("Sending byte 'h%0h = 'b%0b...", data, data);

    // Start bit (0)
    rx_bit_i = 1'b0;
    #BAUD_CLK_PERIOD;

    // Veri bitleri (LSB önce)
    for (int i = 0; i < DATA_WIDTH; i++) begin
      rx_bit_i = data[i];
      #BAUD_CLK_PERIOD;
    end

    // Stop bit (1)
    rx_bit_i = 1'b1;
    #BAUD_CLK_PERIOD;
  endtask

  // FIFO'dan tek bir byte okumak ve doğrulamak için görev
  task read_and_verify_fifo();
    logic [7:0] received_data;
    logic [7:0] expected_data;

    rx_re_i = 1'b1;
    @(posedge clk_i);
    rx_re_i = 1'b0;

    // FIFO çıkışının güncellenmesini bekle
    @(posedge clk_i);
    received_data = dout_o;

    expected_data = golden_model_fifo.pop_front();

    if (received_data !== expected_data) begin
      $display("ERROR: Data mismatch! Received 'h%0h, but expected 'h%0h.", received_data, expected_data);
      $finish;
    end else begin
      $display("INFO: Data received successfully: 'h%0h", received_data);
    end
  endtask

  // Test Senaryosu
  // ---
  initial begin
    $display("INFO: Starting UART RX testbench...");

    // Başlangıç değerleri
    baud_div_i <= BAUD_DIV;
    rx_re_i    <= 0;
    rx_en_i    <= 0;
    rx_bit_i   <= 1'b1; // Hattı IDLE durumuna getir

    // Reset
    rst_ni <= 0;
    repeat (2) @(posedge clk_i);
    rst_ni  <= 1;

    // RX alımını başlat
    rx_en_i <= 1;

    // TX'ten test verilerini gönder ve golden model FIFO'ya kaydet
    $display("INFO: Sending test data via simulated TX...");
    for (tx_data_index = 0; tx_data_index < test_data_arr_tx.size(); tx_data_index++) begin
      // Veriyi golden model FIFO'ya ekle
      golden_model_fifo.push_back(test_data_arr_tx[tx_data_index]);
      // UART bitlerini gönder
      send_byte(test_data_arr_tx[tx_data_index]);
    end

    $display("INFO: All data sent. Waiting for DUT to receive...");

    // DUT'nin tüm verileri almasını bekle
    wait (empty_o == 0);  // FIFO'da en az bir veri olana kadar bekle

    // FIFO boşalana kadar okuma ve doğrulama yap
    while (golden_model_fifo.size() > 0) begin
      read_and_verify_fifo();
      @(posedge clk_i);
    end

    $display("INFO: All data received and verified. FIFO is empty.");

    // Boş bir transfer yapıldığında da IDLE'a dönüp dönmediğini kontrol et
    $display("INFO: Sending one more byte to test the end-to-end logic.");
    send_byte('h5A);
    golden_model_fifo.push_back('h5A);

    wait (empty_o == 0);
    @(posedge clk_i);

    read_and_verify_fifo();

    // Son bir süre bekleme
    #100ns;

    $display("INFO: Test finished successfully!");
    $finish;
  end
endmodule
