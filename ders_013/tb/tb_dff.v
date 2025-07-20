
module tb_dff;

    reg          clk = 0;
    reg          rst;
    reg [3:0]    d;
    wire  [3:0]  q;

    dff dut (
        clk,
        rst,
        d,
        q
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_dff);
        /*
$random	                    Returns a 32-bit signed pseudo-random int	r = $random;
$urandom	                Returns 32-bit unsigned random number	    r = $urandom;
$urandom_range(min, max)	Bounded unsigned random	                    r = $urandom_range(0, 15);
        */
        rst <= 0;
        d   <= $random;
        @(posedge clk);

        rst <= 1;
        @(posedge clk);

        rst <= 0;
        d   <= $urandom;
        @(posedge clk);

        d   <= $urandom_range(0, 15);
        @(posedge clk);

        // VCD = value change dumb
        // simulasyon sırasında üretilen  standart waveform dosya türüdür.
        // zamanla gerçekleşen sinyal değişimlerini kaydeder, waveform viewer toolarında
        // gösterimlemek için

        $stop;
    end
endmodule
