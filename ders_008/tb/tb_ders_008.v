
module tb_ders_008();

    // Concatenation & Replication
    wire [3:0]  wire_4bit;
    wire [7:0]  wire_8bit;
    wire [11:0] wire_12bit;
    wire [15:0] wire_16bit;

    assign wire_4bit = 4'b0010;     // veri etiketi
    assign wire_8bit = 8'b1111_1010;// veri sırası
    assign wire_12bit = {wire_8bit, wire_4bit};
    assign wire_16bit = {wire_8bit, {2{wire_4bit}}};

    initial begin : con_rep
        #5;
        $display("12-bit : %b", wire_12bit);
        $display("16-bit : %b", wire_16bit);
    end

    // Sized & Unsized
    reg [31:0] data_r;

    initial begin : sized
        data_r = 32'h0000_0001;
        #1;
        $display("data_r: %b", data_r);
    end
endmodule