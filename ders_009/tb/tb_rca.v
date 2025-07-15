
module tb_rca;

    localparam  PROC_SIZE = 16;

    reg [PROC_SIZE-1:0] a;
    reg [PROC_SIZE-1:0] b;
    wire [PROC_SIZE-1:0] sum;
    wire cout;

    wire [PROC_SIZE:0] com;
    assign com = {cout, sum};

    rca #(PROC_SIZE) dut
    (
        a,
        b,
        sum,
        cout
    );

    initial begin
        a = 16'b0000;
        b = 16'b0000;
        #10;

        a = 16'b0001;
        b = 16'b0010;
        #10;

        a = 16'b1001;
        b = 16'b1010;
        #10;

        a = 16'b1111;
        b = 16'b1111;
        #10;
    end
endmodule