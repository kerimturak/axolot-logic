`timescale 1ns / 1ps

module tb_ha ();

  reg a, b;
  wire sum, cout;

  ha dut (
      .a   (a),
      .b   (b),
      .sum (sum),
      .cout(cout)
  );

  initial begin
    $monitor("num1 : %b  num2: %b   sum: %b  cout: %b", a, b, sum, cout);
    #5;
    a = 0;
    b = 0;
    #5;
    a = 0;
    b = 1;
    #5;
    a = 1;
    b = 0;
    #5;
    a = 1;
    b = 1;
  end
endmodule
