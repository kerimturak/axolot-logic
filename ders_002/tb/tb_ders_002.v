


module tb_ders_002;


    // tek satırlık yorum



    /*
        birden fazla
        satır yorum
    */


    //-------------------- Veri Türleri

    // Net - kablo
    wire w0;    // z - unsigned

    // Reg - variable
    reg r0;     // x - unsigned

    // tam sayı integer
    integer i; // x - signed

    //real - float
    real ondalik; // 0.10


    // time- simülasyon süresini atamak için kullanılan
    time t0;

    // a-z ya da _

    wire _wire;

    wire wire;



    // Logic Seviyeleri
    /*
    0 - logic low
    1 - logic high
    x - çakışma veya değeri bilinmiyor
    z - high impedance
    */


    // Sayı sistemleri
    /*
        binray
        decimal
        hexadecimal
        octal

        <size>'<base><number>
    */



    wire w1;
    reg r1;


    wire [1:0] w2;
    reg  [1:0] r2;




    // Initial

    initial begin
        r2 = 2'b01;
        
    end
endmodule

