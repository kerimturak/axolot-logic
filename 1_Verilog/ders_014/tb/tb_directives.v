// module tb_directives;
`timescale 1ns / 1ps
`default_nettype none

`define WIDTH 8
`define RESET_VAL 0
`define PRINT_SIGNAL(sig) \
  $display("Signal %s = %b", `"sig`", sig)

module tb_directives;

    reg [`WIDTH-1:0] my_reg = 8'hA5;

    initial begin
        `ifdef DEBUG
            $display("Debugging Enabled");
        `endif

        `PRINT_SIGNAL(my_reg);
        #10 $finish;
    end

endmodule

`undef WIDTH
`resetall
