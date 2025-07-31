/*
SystemVerilog’da enum, birden fazla sabit değeri
isimlendirerek gruplayan bir veri türüdür. Kodun
okunabilirliğini artırır, hata riskini azaltır ve debug işlemlerini kolaylaştırır.
*/
module tb_enum_types;

  enum bit [4:0] {IDLE = 2, COUNT = 7, LAST = 11} fsm_e; // anonymous int

  initial begin
   fsm_e = 2;

    repeat(fsm_e.num()) begin
      $display("STATE : %0d", fsm_e);
      fsm_e = fsm_e.next();
    end
  end

endmodule
