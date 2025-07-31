/*
SystemVerilog’ta bir struct, farklı veri türlerini tek bir mantıksal
grup altında birleştiren bileşik bir veri türüdür. C/C++ dilindeki
struct yapısına benzer şekilde, ilişkili değişkenleri tek bir isim
altında organize etmeye olanak tanır.
*/
module tb_typedef;



  /*
  SystemVerilog, typedef anahtar kelimesiyle kullanıcıların kendi özel veri türlerini tanımlamasına izin verir.
  */
  logic [31:0] arr;

  typedef logic [31:0] l32_t;

  typedef struct packed {
    int    age;
    bit    [15:0] id ;
  } employee_t;

  typedef union packed {
    bit [31:0] full;
    bit [31:0] fbyte;
  } instr_t;

  typedef enum bit [4:0] {
    IDLE  = 2,
    COUNT = 7,
    LAST  = 11
  } fsm_e;

  l32_t      arr2;

  employee_t employee;
  instr_t    instr;

  initial begin
    arr2 = 32'hDEAD_BEAF;
    $display("arr2 : %0h", arr2);

    #5;
    instr.full = 32'hDEAD_BEAF;
    $display("Full : %0h, First_byte : %0h", instr.full, instr.fbyte);

    #5;
    instr.fbyte = 8'hAA;
    $display("Full : %0h, First_byte : %0h", instr.full, instr.fbyte);
    #5;

    //employee.name = "Ahmet";
    employee.age = 33;
    employee.id  = 9548;

    $display("Iscinin bilgileri:  age : %0d, id: %0d", employee.age, employee.id);

  end
endmodule
