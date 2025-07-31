module dff (
    input clk,
    input rst,
    input [3:0] d,
    output reg [3:0] q
);

  always @(posedge clk) begin
    if (rst) begin
      q <= 0;
    end else begin
      q <= d;
    end
  end

endmodule
