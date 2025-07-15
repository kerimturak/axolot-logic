module fa(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    //assign sum = a ^ b ^ cin;
    //assign cout = (a & b) | (b & cin) | (a & cin);

    wire ha0_sum;
    wire ha0_cout;
    wire ha1_cout;

    ha ha0(.a(a), .b(b), .cout(ha0_cout), .sum(ha0_sum));
    ha ha1(.a(ha0_sum), .b(cin), .cout(ha1_cout), .sum(sum));

    or(cout, ha0_cout, ha1_cout);
endmodule