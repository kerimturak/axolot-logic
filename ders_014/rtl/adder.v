
`define WIDTH 8
`define SUM
`include "adder.vh"

module adder (
  input  [`WIDTH-1:0] a, b,
  output reg [`WIDTH-1:0] y
);

    reg [`WIDTH-1:0] temp;

    `my_always(temp, a, b, y)
endmodule
