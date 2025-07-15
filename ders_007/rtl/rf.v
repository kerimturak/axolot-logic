module rf(
  input clk_i,
  input rst_ni,
  input rw_en_i,
  input [4:0] r1_addr_i,
  input [4:0] r2_addr_i,
  input [4:0] waddr_i,
  input [31:0] wdata_i,
  output reg [31:0] r1_data_o,
  output reg [31:0] r2_data_o
);


  reg [31:0] registers [31:0];
  integer i;

  always @(*) begin
    r1_data_o = registers[r1_addr_i];
    r2_data_o = registers[r2_addr_i];
  end

  always @(posedge clk_i) begin
    if (!rst_ni) begin
      for (i=0; i<32; i = i+1) begin
        registers[i] <= 0;
      end
    end else if (rw_en_i && waddr_i != 0) begin
      registers[waddr_i] <= wdata_i;
    end
  end


endmodule