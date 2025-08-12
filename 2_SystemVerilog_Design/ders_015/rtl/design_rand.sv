module design_rand (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] c
);

  assign c = a ^ b;

endmodule
