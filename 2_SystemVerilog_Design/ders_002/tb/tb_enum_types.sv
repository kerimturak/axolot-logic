/*
SystemVerilog’da enum, birden fazla sabit değeri
isimlendirerek gruplayan bir veri türüdür. Kodun
okunabilirliğini artırır, hata riskini azaltır ve debug işlemlerini kolaylaştırır.
*/
module tb_enum_types;


  typedef struct packed {
    int age;
    bit [3:0] id;
  } employee_t;

  employee_t employee;

  typedef union {
    bit [31:0] data;
    bit [7:0]  fbyte;
  } data_u_t;

  data_u_t data_u;

  initial begin
    data_u.data = 32'hDEAD_BEAF;
    #1;
    data_u.fbyte = 8'hCC;

    $display("Data: %0h", data_u.data);

    $display("Fbyte: %0h", data_u.fbyte);



    ////employee.name = "ahmet";
    //employee = '{
    //  id : 123,
    //  default: 5
    //};

    //$display("age: %0d, id: %0d", employee.age, employee.id);
  end












  /*
  //enum {red, yellow, green} ligth1, ligth2; // anonymous int
  typedef enum bit [4:0] {red[4:0]} ligth_t;

  ligth_t ligth1, ligth2;
  bit [4:0] my_b;

  initial begin

    repeat(ligth1.num()) begin
      $display("Name : %0s", ligth1.name());
      ligth1 = ligth1.next();
    end

    $display("Enum = %0d", ligth1);
    
    if (ligth1 == 0) begin
      $display("Enum = 0");
    end

    my_b = ligth1.next() + 5;
    $display("my_b = %0d", my_b);

    ligth1 = ligth_t'(3);
    $display("Enum = %0d", ligth1);
  end
*/
endmodule
