
module rca #(parameter SIZE = 4, parameter MY_SUM = 0) (
    input [SIZE-1:0] a,
    input [SIZE-1:0] b,
    output [SIZE-1:0] sum,
    output cout
);

    /*
        1111
        1111
       +____
       11110
    */

    wire [SIZE:0] cin;
    assign cin[0] = 4'b0;

    genvar i;
    generate
        if(MY_SUM) begin
            for (i=0; i<SIZE; i=i+1) begin : full_adder
                fa fa0(
                    .a    (a[i])  ,
                    .b    (b[i])  ,
                    .cin  (cin[i])  ,
                    .cout (cin[i+1]),
                    .sum  (sum[i])
                );
            end
            assign cout = cin[SIZE];
        end else begin
            assign  {cout, sum}= a +b;
        end
    endgenerate


endmodule