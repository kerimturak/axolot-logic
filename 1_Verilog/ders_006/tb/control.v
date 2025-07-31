`timescale 1ns / 1ps

/*
    Kontrol Akısı İfadeleri, always, initial, ya da generate blokları
    içinde karar verme ve yineleme mantığını tanımlar.
    RTL veya Testbench mantığı yazmak için gereklidir.
*/

module tb_control_flow;

  reg [3:0] a, b;
  integer i;

  initial begin
    a = 5;
    b = 7;

    // =====================================================
    // Koşullu Dallanma  :  if-else
    // =====================================================
    #5;
    if (a == b) begin
      $display("a == b");
    end else if (a < b) begin
      $display("a < b");
    end else begin
      $display(" buyuk degil");
    end

    // =====================================================
    // Çok Yönlü Seçim : case
    // =====================================================
    #5;
    case (a)
      4'd0: begin
        $display("a = 0");
      end
      4'd5:    $display("a = 5");
      4'd7:    $display("a = 7");
      default: $display("a bilinmeyen bir değer");
    endcase


    // =====================================================
    // Döngü yapıları
    // =====================================================

    // for Loop
    // Başlatma veya dizi erişimi için kullanılır.
    for (i = 0; i < 4; i = i + 1) begin
      $display("for: i = %0d", i);
    end

    // while Loop
    // Bir koşul yanlış hale gelene kadar döngüler. Genellikle testbench'te kullanılır.
    i = 0;
    while (i < 3) begin
      $display("while: i = %0d", i);
      i = i + 1;
    end


    // repeat Loop
    // Bir bloğu sabit sayıda tekrarlayın.
    repeat (2) begin
      $display("repeat: tekrarlandi");
    end
  end

  //reg clk;
  //initial begin
  //  clk = 0;
  //  forever begin
  //      #5; clk = ~clk;
  //  end
  //end



  reg [3:0] expr;
  initial begin
    #20;
    $display("\n=== case, casez, casex Karsilastirmasi ===");

    // expr'e x (bilinmeyen) bit içeren bir değer atanıyor
    expr = 4'b1011;

    // case ifadesi: tüm bitlerin birebir eslesmesini ister.
    // expr içindeki x, eslesmeye engel olur.
    $display("\n[expr = %b] --- CASE kullanimi", expr);
    case (expr)
      4'b10x1: $display("case: 4'b10x1 eslesti");
      default: $display("case: eslesmedi");
    endcase

    // casez ifadesi: yalnizca sabit taraftaki z bitlerini joker (wildcard) olarak kabul eder.
    // expr'deki x değeri eslesmeyi engeller.
    $display("\n[expr = %b] --- CASEZ kullanimi", expr);
    casez (expr)
      4'b10x1: $display("casez: 4'b10z1 eslesti");
      default: $display("casez: eslesmedi");
    endcase

    // casex ifadesi: hem expr içindeki hem sabit taraftaki x ve z bitlerini joker kabul eder.
    // Bu nedenle eslesme gerçeklesir.
    $display("\n[expr = %b] --- CASEX kullanimi", expr);
    casex (expr)
      4'b10z1: $display("casex: 4'b10x1 eslesti");
      default: $display("casex: eslesmedi");
    endcase
  end
endmodule
