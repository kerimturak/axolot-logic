
module tb_dff;

  reg        clk = 0;
  reg        rst;
  reg  [3:0] d;
  wire [3:0] q;

  dff dut (
      clk,
      rst,
      d,
      q
  );

  always #5 clk = ~clk;

  initial begin
    // Reset
    rst = 0;
    d   = 0;
    #10;
    rst = 1;
    #10;
    rst = 0;

    #10;
    d = 3;

    #10;
    $display("q: %d", tb_dff.dut.q);
    #10;

    d = 1;
    @(posedge clk);
    force tb_dff.dut.q = 2;
    $display("q: %d", tb_dff.dut.q);
    #10;

    release tb_dff.dut.q;
    #1;
    d = 1;
    @(posedge clk);
    $display("q: %d", tb_dff.dut.q);

    $stop;
  end
endmodule
