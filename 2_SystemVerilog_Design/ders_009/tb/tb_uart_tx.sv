`timescale 1ns / 1ps

module tb_uart_tx;

  // Testbench parametreleri
  // ---

  parameter FIFO_DEPTH = 8;
  parameter DATA_WIDTH = 16;
  parameter CLK_PERIOD = 10;
  parameter BAUD_DIV = 104;
  parameter BAUD_CLK_PERIOD = BAUD_DIV * CLK_PERIOD;  // Divisor = Clock_Freq / (16 * Baud_Rate)

  // Test sinyalleri
  // ---
  logic        clk_i = 0;
  logic        rst_ni;
  logic [15:0] baud_div_i;
  logic        tx_we_i;
  logic        tx_en_i;
  logic [ 7:0] din_i;
  logic        empty_o;
  logic        full_o;
  logic        tx_bit_o;

  // Test Verileri
  // ---
  // Test için gönderilecek veri dizisi
  logic [ 7:0] test_data_arr  [] = {'h41, 'h42, 'h43, 'h0A};  // "ABC\n"

  // Doğrulama İçin Kullanılacak Sinyaller
  // ---
  logic [ 3:0] bit_counter;
  logic [ 9:0] expected_frame;

  // DUT (Device Under Test)
  uart_tx #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) dut (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .baud_div_i(baud_div_i),
      .tx_we_i   (tx_we_i),
      .tx_en_i   (tx_en_i),
      .din_i     (din_i),
      .empty_o   (empty_o),
      .full_o    (full_o),
      .tx_bit_o  (tx_bit_o)
  );

  // Saat sinyali üreteci
  // ---
  always #CLK_PERIOD clk_i = ~clk_i;

  // Gönderim fonksiyonşarı
  // ---
  // FIFO'ya tek bir byte yazmak için

  task write_fifo(input logic [7:0] data);
    $strobe("Writing data:%0h to FIFO...", data);
    tx_we_i = 1;
    din_i   = data;
    @(posedge clk_i);
    tx_we_i = 0;
    @(posedge clk_i);
  endtask

  // UART bitlerini okumak ve doğrulamak için bir görev
  task verify_tx_bit(input logic expected_bit, input int bit_index);
    @(negedge clk_i);
    #1;
    if (expected_bit !== tx_bit_o) begin
      $display("ERROR: TX bit verification failed! At bit %0d, expected: %0b, but got: %0b", bit_index, expected_bit, tx_bit_o);
    end else begin
      $display("INFO: TX bit verification successful. : Bit %0d is %b", bit_index, tx_bit_o);
    end
  endtask

  // Test seneryasu
  // ---

  initial begin
    $display("INFO: Starting UART TX Testbench...");

    // Başlangıç değerleri
    tx_en_i <= 0;
    tx_we_i <= 0;
    din_i <= 0;
    baud_div_i <= 0;

    // Reset
    rst_ni <= 0;
    repeat (2) @(posedge clk_i);
    rst_ni <= 1;

    // FIFO'ya tüm test verilerini yaz
    $display("INFO: Writing test data to FIFO...");
    for (int i = 0; i < test_data_arr.size(); i++) begin
      write_fifo(test_data_arr[i]);
    end

    // Gönderimi başlat
    $display("INFO: Enabling TX and starting transmission...");
    tx_en_i <= 1;

    for (int i = 0; i < test_data_arr.size(); i++) begin
      @(posedge clk_i);
      expected_frame = {1'b1, test_data_arr[i], 1'b0};

      $display("INFO: Verifying start bit...");
      verify_tx_bit(expected_frame[0], 0);


      for (bit_counter = 1; bit_counter < 8; bit_counter++) begin
        #BAUD_CLK_PERIOD;
        verify_tx_bit(expected_frame[bit_counter], bit_counter);
      end

      #BAUD_CLK_PERIOD;
      $display("INFO: Verifying stop bit...");
      verify_tx_bit(expected_frame[9], 9);

      #BAUD_CLK_PERIOD;
    end

    $display("INFO: All data transmitted. Waiting for final state...");
    wait (empty_o && bit_counter == 9);
    #100ns;

    $display("INFO: Test finished successfully!");
    $finish;

  end
endmodule
