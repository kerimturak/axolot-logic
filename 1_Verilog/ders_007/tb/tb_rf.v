`timescale 1ns / 1ps
module tb_rf;

  reg         clk_i;
  reg         rst_ni;
  reg         rw_en_i;  //
  reg  [ 4:0] r1_addr_i;
  reg  [ 4:0] r2_addr_i;
  reg  [ 4:0] waddr_i;
  reg  [31:0] wdata_i;
  wire [31:0] r1_data_o;
  wire [31:0] r2_data_o;

  reg_file dut (
      clk_i,
      rst_ni,
      rw_en_i,
      r1_addr_i,
      r2_addr_i,
      waddr_i,
      wdata_i,
      r1_data_o,
      r2_data_o
  );

  initial begin
    clk_i = 0;
    forever begin
      #5;
      clk_i = ~clk_i;
    end
  end

  initial begin
    rst_ni    = 1;
    rw_en_i   = 0;
    r1_addr_i = 0;
    r2_addr_i = 0;
    waddr_i   = 0;
    wdata_i   = 0;
    #10;

    // Reset at
    rst_ni = 0;

    #10;
    rst_ni    = 1;


    // yazma
    rw_en_i   = 1;
    r1_addr_i = 0;
    r2_addr_i = 0;
    waddr_i   = 5;
    wdata_i   = 7;

    #10;
    // okuma
    rw_en_i   = 0;
    r1_addr_i = 0;
    r2_addr_i = 5;
    waddr_i   = 0;
    wdata_i   = 0;

    #10;
    // yazma
    rw_en_i   = 1;
    r1_addr_i = 0;
    r2_addr_i = 0;
    waddr_i   = 0;
    wdata_i   = 3;

    #10;
    // okuma
    rw_en_i   = 0;
    r1_addr_i = 5;
    r2_addr_i = 0;
    waddr_i   = 0;
    wdata_i   = 0;
  end
endmodule
