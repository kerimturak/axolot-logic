module tb_data_types;

  // Veri tipi tanımlamaları
  bit         b;          // 2 durumlu, sadece 0 veya 1
  logic       l;          // 4 durumlu, 0/1/X/Z olabilir
  reg         r;          // Eski stil 4 durumlu kayıt
  wire        w;          // Net tipi, bir kaynak tarafından sürülmeli
  byte        bt;         // 8 bit signed
  shortint    si;         // 16 bit signed
  int         i;          // 32 bit signed
  longint     li;         // 64 bit signed
  integer     old_i;      // Eski stil signed integer (en az 32 bit)
  time        t;          // Simülasyon zamanı (64 bit)
  real        real_val;   // 64 bit kayan nokta (float)
  shortreal   sreal_val;  // 32 bit kısa float
  string      str;        // Dinamik uzunluklu karakter dizisi

  assign w = r; // wire tipi bir kaynak tarafından sürülmelidir

  initial begin
    // Başlangıç varsayılan değerleri
    //$display("----- [Başlangıç Varsayılan Değerleri] -----");
    $display("----- [Baslangic Varsayilan Degerleri] -----");
    $display("bit         = %b", b);
    $display("logic       = %b", l);
    $display("reg         = %b", r);
    $display("wire        = %b", w);
    $display("byte        = %0d", bt);
    $display("shortint    = %0d", si);
    $display("int         = %0d", i);
    $display("longint     = %0d", li);
    $display("integer     = %0d", old_i);
    $display("time        = %0t", t);
    $display("real        = %0f", real_val);
    $display("shortreal   = %0f", sreal_val);
    $display("string      = \"%s\" (uzunluk = %0d)", str, str.len());

    #5; // 5 zaman birimi bekle

    // Signed (işaretli) değerleri ata
    b         = -1'b1;
    l         = -1'b1;
    r         = -1'b1;
    bt        = -8'sd100;
    si        = -16'sd30000;
    i         = -32'sd12345678;
    li        = -64'sd1234567890123456;
    old_i     = -42;
    t         = -64'd500;
    real_val  = -3.141592;
    sreal_val = -2.71;
    str       = "SystemVerilog";

    $display("\n----- [Atanmis Signed Degerler] / Signed ise negatif olmalidir -----");
    $display("bit         = %b", b);
    $display("logic       = %b", l);
    $display("reg         = %b", r);
    $display("wire        = %b", w);
    $display("byte        = %0d", bt);
    $display("shortint    = %0d", si);
    $display("int         = %0d", i);
    $display("longint     = %0d", li);
    $display("integer     = %0d", old_i);
    $display("time        = %0t", t);
    $display("real        = %0f", real_val);
    $display("shortreal   = %0f", sreal_val);
    $display("string      = \"%s\" (uzunluk = %0d)", str, str.len());

    // $bits() ile bit genişliklerini göster
    $display("\n----- [$bits() ile Bit Genislikleri] -----");
    $display("$bits(bit)         = %0d", $bits(b));
    $display("$bits(logic)       = %0d", $bits(l));
    $display("$bits(reg)         = %0d", $bits(r));
    $display("$bits(byte)        = %0d", $bits(bt));
    $display("$bits(shortint)    = %0d", $bits(si));
    $display("$bits(int)         = %0d", $bits(i));
    $display("$bits(longint)     = %0d", $bits(li));
    $display("$bits(integer)     = %0d", $bits(old_i));
    $display("$bits(time)        = %0d", $bits(t));
    $display("$bits(real)        = %0d", $bits(real_val));
    $display("$bits(shortreal)   = %0d", $bits(sreal_val));
    $display("string             = \"%0d\" (uzunluk = %0d)", $bits(str), str.len());
    // Not: $bits() 'real', 'shortreal' için geçerli değildir
  end

endmodule
