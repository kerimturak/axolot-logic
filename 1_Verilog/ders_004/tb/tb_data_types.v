module tb_data_types ();
  parameter reg [3:0] SIZE = 8;
  localparam reg [4:0] WIDTH = 16;

  wire             single_wire;
  wire [ SIZE-1:0] wire_8bit;
  wire [WIDTH-1:0] wire_16bit;

  reg              single_reg;
  reg  [ SIZE-1:0] reg_8bit;
  reg  [WIDTH-1:0] reg_16bit;

  assign single_wire = single_reg;
  assign wire_8bit   = reg_8bit;
  assign wire_16bit  = reg_16bit;


  real           point;
  time           current_time;

  integer        i;

  reg     [15:0] string_;
  // Başlangıç değerlerini, başlangıç boyutu, signed mı unsigned
  initial begin
    $display("=== VERILOG VERI TURLERI VE OZELLIKLERI ===");

    // Wire
    #5;
    $display("\nWire baslangic degeri: %b", single_wire);
    #5;
    single_reg = 1'b0;
    #5;
    $display("Atanan deger: %b", single_wire);

    #5;
    $display("\nWire baslangic degeri: %b", wire_8bit);
    #5;
    reg_8bit = -10;
    #5;
    $display("Atanan deger: %d", reg_8bit);

    // wire başlangıç durumu 'z', bir reg bağlı ise 'x', default unsigned

    // Reg
    #5;
    $display("\nReg baslangic degeri: %b", reg_16bit);
    #5;
    reg_16bit = -10;
    #5;
    $display("Atanan deger: %d", reg_16bit);
    // reg başlangıç durumu 'x',  default unsigned

    // Real
    #5;
    $display("\nReal baslangic degeri: %h", point);
    #5;
    point = -0.5;
    #5;
    $display("Atanan deger: %f", point);
    // real başlangıç durumu '0',  default signed, boyutu benim sistemimde 32 bit


    // Time
    #5;
    $display("\nTime baslangic degeri: %h", current_time);
    #5;
    current_time = $time;
    #5;
    $display("Atanan deger: %t", current_time);
    // Time başlangıç değer 'x', default signed,

    // Integer
    #5;
    $display("\nInteger baslangic degeri: %h", i);
    #5;
    i = -10;
    #5;
    $display("Atanan deger: %d", i);
    // Integer başlangıç değer 'x', default signed, default boyutu 32 bit

    string_ = "KT";
    $display("\nStrign: %s", string_);

    #5;
    // Wire
    #5;
    $display("Wire    size: %0b", single_wire);
    $display("Reg     size: %0b", single_reg);
    $display("Real    size: %0b", point);
    $display("Time    size: %0b", current_time);
    $display("Integer size: %0b", i);

  end
endmodule
