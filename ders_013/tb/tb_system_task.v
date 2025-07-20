module tb_system_tasks;

    reg [7:0] r1, r2;
    reg [3:0] index;
    reg signed [15:0] s_val = -10;
    reg [15:0] u_val;

    initial begin
        // Randomization
        r1 = $urandom;
        r2 = $urandom_range(0, 15);
        $display("Random r1 = %0d, r2 (0-15) = %0d", r1, r2);

        // Math & conversion
        index = $clog2(10);  // = 4
        $display("clog2(10) = %0d", index);

        u_val = $unsigned(s_val);
        $display("s_val = %0d, u_val = %0d", s_val, u_val);

        // Simulation control
        #20 $finish;
    end

endmodule
