
module tb_delay;

    reg [2:0] a;
    reg [5:0] b;
    reg [5:0] c;

    reg clk = 0;
    always #5 clk = ~clk;

    initial begin
        #10;    //
        a = 3;  // 2- active region , assign, display
        b = 0;  // 2- active region , assign, display
        c = 0;  // 2- active region , assign, display
        /*
        $display("time :%0t, a : %0d",$time,  a);

        @(posedge clk); // 1-proponed
        $display("time :%0t, posedge",$time);
        c <= b*a;   // 4. Nonblocking Assign Update Region
        b <= 2*a;
        $display("time :%0t, b : %d, c: %d",$time, b, c); // 2- active region , assign, display
        $monitor("time :%0t, b : %d, c: %d",$time, b, c); // 4- posponed
        */

        a <= 0;
        b <= 0;
        @(posedge clk);
        #10;
        $stop;
    end
endmodule
