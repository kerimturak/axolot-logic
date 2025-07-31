`timescale 1ns / 1ps

module tb_fa ();

  reg a, b, cin;
  wire sum, cout;

  fa dut (
      .a   (a),
      .b   (b),
      .cin (cin),
      .sum (sum),
      .cout(cout)
  );

  initial begin
    $monitor("num1 : %b  num2: %b  cin: %b sum: %b  cout: %b", a, b, cin, sum, cout);
    #5;
    a   = 0;
    b   = 0;
    cin = 0;
    #5;
    a   = 0;
    b   = 0;
    cin = 1;
    #5;
    a   = 0;
    b   = 1;
    cin = 0;
    #5;
    a   = 0;
    b   = 1;
    cin = 1;
    #5;
    a   = 1;
    b   = 0;
    cin = 0;
    #5;
    a   = 1;
    b   = 0;
    cin = 1;
    #5;
    a   = 1;
    b   = 1;
    cin = 0;
    #5;
    a   = 1;
    b   = 1;
    cin = 1;
  end
endmodule
