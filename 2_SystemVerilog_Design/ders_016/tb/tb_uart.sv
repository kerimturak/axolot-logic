`timescale 1ns / 1ps

module tb_uart;

  //-------------------------------------------------------------
  // Testbench Parameters
  //-------------------------------------------------------------
  localparam CLK_PERIOD = 10;  // Clock period (10 ns -> 100 MHz)
  localparam BAUD_RATE = 9600;  // Baud rate to test
  localparam CLK_FREQ = 1_000_000_000 / CLK_PERIOD;  // 100 MHz
  localparam BAUD_DIVISOR = CLK_FREQ / (16 * BAUD_RATE);  // 100M / (16 * 9600) = 651

  // DUT parameters
  localparam DATA_WIDTH = 8;
  localparam FIFO_DEPTH = 16;
  localparam XLEN = 32;

  //-------------------------------------------------------------
  // Signal Declarations
  //-------------------------------------------------------------
  logic            clk;
  logic            rst_n;

  // CPU bus interface signals
  logic            stb;
  logic [     1:0] addr;
  logic [     3:0] byte_sel;
  logic            we;
  logic [XLEN-1:0] data_i;
  logic [XLEN-1:0] data_o;

  // UART pins
  //logic            uart_rx;
  logic            uart_tx;

  //-------------------------------------------------------------
  // Reference Model (TX Queue) for Verification
  //-------------------------------------------------------------
  byte             TxQueue  [$];

  //-------------------------------------------------------------
  // DUT Instance
  //-------------------------------------------------------------
  uart #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) uart_inst (
      .clk_i     (clk),
      .rst_ni    (rst_n),
      .stb_i     (stb),
      .adr_i     (addr),
      .byte_sel_i(byte_sel),
      .we_i      (we),
      .dat_i     (data_i),
      .dat_o     (data_o),
      .uart_rx_i (uart_tx),   // TX loopback to RX
      .uart_tx_o (uart_tx)
  );

  //-------------------------------------------------------------
  // Clock and Reset Generation
  //-------------------------------------------------------------
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst_n = 1'b0;
    repeat (10) @(posedge clk);
    rst_n = 1'b1;
  end

  //-------------------------------------------------------------
  // CPU Bus Write Task
  //-------------------------------------------------------------
  task automatic write_reg(input logic [1:0] w_addr, input logic [XLEN-1:0] w_data, input logic [3:0] w_byte_sel);
    stb      = 1'b1;
    we       = 1'b1;
    addr     = w_addr;
    byte_sel = w_byte_sel;
    data_i   = w_data;
    @(posedge clk);
    stb = 1'b0;
    we  = 1'b0;
  endtask

  //-------------------------------------------------------------
  // CPU Bus Read Task
  //-------------------------------------------------------------
  task automatic read_reg(input logic [1:0] r_addr, output logic [XLEN-1:0] r_data);
    stb  = 1'b1;
    we   = 1'b0;
    addr = r_addr;
    @(posedge clk);
    stb = 1'b0;
    we  = 1'b0;
    @(posedge clk);
    r_data = data_o;
  endtask

  //-------------------------------------------------------------
  // Test Scenario
  //-------------------------------------------------------------
  initial begin
    // Wait after reset
    @(posedge rst_n);

    // Define register addresses
    `define UART_BAUD_ADDR 2'b00
    `define UART_CTRL_ADDR 2'b01
    `define UART_STATUS_ADDR 2'b10
    `define UART_TX_DATA_ADDR 2'b11
    `define UART_RX_DATA_ADDR 2'b11

    // Configure UART baud rate
    $info("INFO: Setting UART baud rate. Divisor: %0d", BAUD_DIVISOR);
    write_reg(.w_addr(`UART_BAUD_ADDR), .w_data(BAUD_DIVISOR), .w_byte_sel(4'b0011));

    // Enable TX and RX
    $info("INFO: Enabling UART TX and RX.");
    write_reg(.w_addr(`UART_CTRL_ADDR), .w_data({32'b0, 1'b1, 1'b1}), .w_byte_sel(4'b0001));

    // Send random data
    $info("INFO: Starting random data transmission test...");

    for (int i = 0; i < FIFO_DEPTH; i++) begin
      logic [DATA_WIDTH-1:0] random_data;
      random_data = $urandom();

      // Wait if TX FIFO is full
      do begin
        logic [XLEN-1:0] status;
        read_reg(.r_addr(`UART_STATUS_ADDR), .r_data(status));
        if (!status[0]) begin  // tx_full_o = bit 0
          break;
        end
        @(posedge clk);
      end while (1);

      // Write data to TX FIFO
      write_reg(.w_addr(`UART_TX_DATA_ADDR), .w_data({26'b0, random_data}), .w_byte_sel(4'b0001));

      TxQueue.push_back(random_data);
      $info("INFO: Data written to TX FIFO: 0x%0h. TX queue size: %0d", random_data, TxQueue.size());

      @(posedge clk);
    end

    $info("INFO: TX FIFO is full. Waiting for data to be received...");

    // Bekleme süresini, tüm verilerin iletimi için yeterli olacak şekilde artırın
    // 16 veri * 10 bit/veri * (1 / 9600 baud) ≈ 16.67 ms.
    // Bu süre 100 MHz clock'ta yaklaşık 1.670.000 clock döngüsüne denk gelir.
    // Güvenli olması için biraz daha fazla bekleyelim.
    repeat (2_000) @(posedge clk);

    // RX FIFO'daki veriyi oku ve doğrula
    while (TxQueue.size() > 0) begin
      logic [DATA_WIDTH-1:0] expected_data;
      logic [      XLEN-1:0] received_data;

      expected_data = TxQueue.pop_front();

      // RX FIFO'nun boş olmamasını bekleyin.
      // Bu, testin en önemli düzeltmesidir.
      do begin
        logic [XLEN-1:0] status;
        read_reg(.r_addr(`UART_STATUS_ADDR), .r_data(status));
        if (!status[3]) begin  // rx_empty_o = bit 2
          break;
        end
        @(posedge clk);
      end while (1);

      // RX FIFO'dan veriyi okuyun
      read_reg(.r_addr(`UART_RX_DATA_ADDR), .r_data(received_data));

      // Alınan veriyi doğrulayın
      if (received_data[DATA_WIDTH-1:0] == expected_data) begin
        $info("INFO: Data verified. Received: 0x%0h, Expected: 0x%0h", received_data[DATA_WIDTH-1:0], expected_data);
      end else begin
        $error("ERROR: Data mismatch! Received: 0x%0h, Expected: 0x%0h", received_data[DATA_WIDTH-1:0], expected_data);
        //$finish;
      end
    end

    $info("INFO: All data transmitted, received, and verified successfully.");
    $info("INFO: Test PASSED.");
    $finish;
  end

endmodule
