module tb_task_function;




  logic [3:0] a, b;
  integer result, diff;
  integer tb_int = 5;

  initial begin
    a = '0;
    b = '0;
    #10ns;

    a = 5;
    b = 3;
    adder_task(.tb_int(tb_int), .a(a), .b(a), .result(result));
    #10ns;


    a = 5;
    b = 3;
    diff = adder_func0(a, b, result);
    #10ns;

    a = 5;
    b = 3;
    adder_func1(.a(), .b(), .result(result));
    #10ns;
    #100ns;
    $stop;
  end

  /*
    - İstenilen sayı kadar input, output, inout portunu destekler
    ANSI-C olabilir
    - Timing içerebilir (@, wait, #10)
*/
  task automatic adder_task(ref integer tb_int, input [3:0] a, input [3:0] b, output integer result);
    //input a, input b, output sum, output carry
    begin

      result = a + b + tb_int;

      $display("A: %0d, B: %0d, Result: %0d", a, b, result);
    end
  endtask

  /*
    - İstenilen sayı kadar input sadece ANSI-C stili
    - Timing içeremez
    - Fonksiyon 0 zaman da tamamlanmalı
    - Tek bir değer return edebilir. Vektor, integer ya da real
    - Output ya da inout portuna sahip fonksiyonu sadece procedural blockta çağırabilirsiniz
    continuous assignment yapamazsınız
*/
  function integer adder_func0([3:0] a, [3:0] b, output integer result);
    //input a, input b, output sum, output carry
    begin
      result = a + b;
      $display("A: %0d, B: %0d, Result: %0d, Diff:%0d", a, b, result, a - b);
      adder_func0 = a - b;
    end
  endfunction

  function void adder_func1(integer a = 0, b = 1, output integer result);
    result = a + b;
    $display("A: %0d, B: %0d, Result: %0d", a, b, result);
  endfunction
endmodule
