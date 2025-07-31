

module tb_ders_002;

  reg  [3:0] a;
  reg  [3:0] b;
  wire [3:0] y;
  wire       temp;

  ders_002 dut (
      .a(a),
      .b(b),
      .y(y)
  );

  initial begin

    #10;

    a = 4'b0101;  // default 32- bit
    b = 4'd10;
    #5;
    a = 4'hC;
    b = 0;

    $display("Out\n");
    $display("a:%d b:%b y:%h", a, b, y);
  end
endmodule
