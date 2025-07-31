/*
    ders2'nin
    kodunu yazıyorum
*/

module ders_002 (
    input  wire [3:0] a,  // wire
    input  wire [3:0] b,
    output wire [3:0] y
);

  assign y = a & b;

endmodule
