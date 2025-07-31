
module tb_scalar_vs_vector;

  wire          wire_scalar;
  reg           reg_scalar;

  // Packed vs Unpacked

  // Packed
  // Veri tanımlayıcısı isminden önce boyutunu belirle
  // Tek bitlik veri türlerinden herhangi biri olabilir
  // Tek boyutlu packed dizilere ayrıca vektörde denir
  // Paketlenmiş bir dizi hafızada bitişik bit seti olarak temsil edilir.
  wire    [7:0] wire_vector;
  reg     [7:0] reg_vector = 8'b0001_1010;

  // Unpacked
  // Veri tanımlayısı isminden sonra ki boyut tanımlamalarına atıfta bulunuyoruz
  // Herhangi bir veri türü olabilir

  reg           reg_upkd                  [1:0];
  wire          wire_upkd                 [1:0];
  integer       integer_upkd              [1:0];
  real          real_upkd                 [1:0];
  time          time_upkd                 [1:0];


  initial begin
    // Vecktor part select
    reg_vector[3:1] = 3'b000;
    $display("\n7. bit : %b", reg_vector[7]);
    $display("3-1 bitler : %b", reg_vector[3:1]);
  end

  initial begin
    #5;
    integer_upkd[1] = -10;
    integer_upkd[0] = -5;
    $display("\nsatır 1 : %d", integer_upkd[1]);
    $display("satır 0 : %d", integer_upkd[0]);
  end


  // assignment ve truncation

  reg [7:0] a;
  reg [3:0] b;

  initial begin
    // Zero padding
    #10;
    b = 4'b1101;
    a = b;

    $display("\na : %b", a);

    // Truncation
    #10;
    a = 8'b1010_0000;
    b = a;
    $display("b : %b", b);

  end



  reg [7:0] image0[63:0] [63:0];
  reg [0:7] image1[0:63] [0:63];
  //  3.[]           1.[] 2.[]
  //image0[0][1][2]

  // Bellekler Memory
  reg [7:0] mem   [ 1:0];

  initial begin
    #15;
    $readmemb("mem.txt", mem);
    $display("mem[0] : %b", mem[0]);
    $display("mem[1] : %b", mem[1]);
  end
endmodule
