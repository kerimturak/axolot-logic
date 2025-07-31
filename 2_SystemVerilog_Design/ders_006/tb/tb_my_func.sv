module tb_my_func ();

  // Inputs (4-bit genişlik eklendi)
  logic [3:0] a, b;
  logic       sel;

  // Output (4-bit genişlik)
  logic [3:0] y;

  // Fonksiyon:
  function logic [3:0] my_func(input logic flag, input logic [3:0] a_in, input logic [3:0] b_in);
    if (flag) return a_in + b_in;
    else return a_in - b_in;
  endfunction

  always @(*) begin
    y = my_func(sel, a, b);
  end

  initial begin
    $display("time\t a b sel | y");
    $monitor("%0t\t %0d %0d  %b  | %0d", $time, a, b, sel, y);

    a   = 4;
    b   = 2;
    sel = 1;
    #10;
    sel = 0;
    #10;
    a   = 7;
    b   = 3;
    sel = 1;
    #10;
    sel = 0;
    #10;

    $finish;
  end

endmodule
