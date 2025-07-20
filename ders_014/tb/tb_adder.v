`define WIDTH 8
module tb_adder;

  reg  [`WIDTH-1:0] a, b;
  wire [`WIDTH-1:0] y;

  adder dut(a, b, y);

  initial begin
    a <= 0 ;
    b <= 0 ;

    #10;

    a <= 1 ;
    b <= 0 ;
    #10;

    $finish;
  end
endmodule
