module adder (
    input logic clk,
    input logic rst,
    input logic [3:0] a,
    input logic [3:0] b,
    output logic [4:0] c
);

  logic [4:0] temp;
  always_comb begin
    if (b inside {3, 5}) begin
      c = temp;
    end else begin
      c = 0;
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      temp <= 0;
    end else begin
      if (a inside {1, 2, 3}) begin
        temp <= 2 * a + b;
      end else begin
        temp <= a + b;
      end
    end
  end
endmodule
