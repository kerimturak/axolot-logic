`timescale 1ns / 1ps
import uart_pkg::*;

module tb_uart_tx;


  // Test Sinyalleri
  // ---
  // Interface'i örnekle
  logic clk_i;

  uart_if #(BAUD_DIV) uart_if (.clk_i(clk_i));

  // Test Verileri
  // ---
  // Test için gönderilecek veri dizisi
  logic [7:0] test_data_arr  [] = {'h41, 'h42, 'h43, 'h0A};  // "ABC\n"

  // Doğrulama İçin Kullanılacak Sinyaller
  // ---
  logic [9:0] expected_frame;
  logic [3:0] bit_counter;

  // DUT (Device Under Test)
  // ---
  uart_tx dut (
      .clk_i     (clk_i),
      .uart_tx_if(uart_if.slave)  // pass as a port bus
  );

  // Saat Sinyali Üretimi
  // ---

  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  initial begin
    clk_i = 0;
  end
  // Gönderim Fonksiyonları
  // ---
  // FIFO'ya tek bir byte yazmak için görev
  task write_fifo(input logic [7:0] data);
    $strobe("Writing data 'h%0h = 'b%0b to FIFO...", data, data);
    uart_if.tx_we_i = 1;
    uart_if.din_i   = data;
    @(posedge clk_i);
    uart_if.tx_we_i = 0;
    @(posedge clk_i);  // İşlem için bir bekleme
  endtask

  // UART bitlerini okumak ve doğrulamak için görev
  task verify_tx_bit(input logic expected_bit, input int bit_index);
    @(posedge clk_i);
    if (uart_if.tx_bit_o !== expected_bit) begin
      $display("ERROR: TX bit verification failed! At bit %0d, expected %b, but got %b", bit_index, expected_bit, uart_if.tx_bit_o);
    end else begin
      $display("INFO: TX bit verification successful: Bit %0d is %b", bit_index, uart_if.tx_bit_o);
    end
  endtask

  // Test Senaryosu
  // ---
  initial begin

    $display("INFO: Starting UART TX testbench...");

    // Başlangıç değerleri
    uart_if.rst_signals();
    repeat (2) @(posedge clk_i);
    uart_if.rst_ni <= 1;

    // FIFO'ya tüm test verilerini yaz
    $display("INFO: Writing test data to FIFO...");
    for (int i = 0; i < test_data_arr.size(); i++) begin
      write_fifo(test_data_arr[i]);
      // FIFO'nun dolup dolmadığını kontrol etmek için bir bekleme ekleyebilirsiniz.
      // @(posedge empty_o); // FIFO boşalana kadar bekleme gibi
    end

    // Gönderimi başlat
    $display("INFO: Enabling TX and starting transmission...");
    uart_if.tx_en_i <= 1;

    // Her bir veri byte'ı için döngü
    for (int i = 0; i < test_data_arr.size(); i++) begin
      // Yeni bir transferin başlamasını bekle
      // Bu, DUT'nin yeni veriyi okuyup START bitini göndermeye başladığı andır.
      // Bu, 'IDLE' durumundan 'SENDING_START' durumuna geçişe denk gelir.
      @(posedge clk_i);

      // Beklenen frame'i oluştur: [Stop, Data, Start]
      expected_frame = {1'b1, test_data_arr[i], 1'b0};

      // Start bitini (0) doğrula
      $display("INFO: Verifying start bit...");
      verify_tx_bit(expected_frame[0], 0);

      // 8 adet veri bitini doğrula
      for (bit_counter = 1; bit_counter <= 8; bit_counter++) begin
        #BAUD_CLK_PERIOD;
        verify_tx_bit(expected_frame[bit_counter], bit_counter);
      end

      // Stop bitini (1) doğrula
      $display("INFO: Verifying stop bit...");
      #BAUD_CLK_PERIOD;
      verify_tx_bit(expected_frame[9], 9);

      #BAUD_CLK_PERIOD;

    end

    // Transfer bittikten sonra bekle

    $display("INFO: All data transmitted. Waiting for final state...");
    wait (bit_counter == 9 && uart_if.empty_o);
    #100ns;

    $display("INFO: Test finished successfully!");
    $finish;
  end
endmodule
