`timescale 1ns / 1ps

module tb_static_arrays;

  // SystemVerilog herhangi bir türü array olarak tanımlamanıza izin verir.
  // Verilogta standart arrayler unpack
  //  - index isimden sonra tanımlanır
  //  - elemanlar ayrı depolanır

  // Unpack
  // - her eleman ayrı depolanır
  // - birden fazla  elemana aynı anda erişim yada işlem yapma mümkün değil
  // - isimden sonra boyut tanımlanır
  //
  //  Pattern assigment array birden boyutlarına erişim için en kolay yoldur.
  //  - Anahtar (key) olarak eleman indeksi kullanılabilir.
  //  - default anahtar kelimesi kullanılarak, atanmadık diğer tüm elemanlara aynı değer verilebilir.

  // Unpack multi-dimensional
  bit             arr2d                [1:0] [4];

  // packed multi-dimensional
  // Sadece tek bit değişken türleri pack array oluştur. bit, logic
  // index isimden önce belirtilir
  bit [ 1:0][3:0] arr2d_pack1;  // 8bit
  bit [ 7:0]      arr2d_pack2;

  // Mix
  bit [31:0]      mem                  [7:0];
  // packed word'lerin unpack array'i

  initial begin
    // pattern assigment
    //arr2d = '{'{1, 2, 5, 7}, '{3, 5, 7, 5}};

    // Nested ordered
    //arr2d[0][0] = 1;
    //arr2d[0][1] = 2;
    //arr2d[0][2] = 3;
    //arr2d[0][3] = 4;
    //arr2d[1][0] = 5;
    //arr2d[1][1] = 3;
    //arr2d[1][2] = 6;
    //arr2d[1][3] = 9;

    // Keyed
    arr2d = '{default: 0};
    foreach (arr2d[i]) begin
      $display("%0d : %0p", i, arr2d[i]);
    end

    #10ns;

    arr2d_pack1[0] = 4'd3;
    arr2d_pack1[1] = 4'd1;

    foreach (arr2d_pack1[i]) begin
      $display("array1 : %0d : %0d", i, arr2d_pack1[i]);
    end

    arr2d_pack2 = arr2d_pack1;

    foreach (arr2d_pack2[i]) begin
      $display("array2 : %0d : %0d", i, arr2d_pack2[i]);
    end

    $display("dimensions: %0d", $dimensions(arr2d));
    $display("dimensions: %0d", $dimensions(arr2d_pack1));
    $display("dimensions: %0d", $dimensions(arr2d_pack2));
    $display("dimensions: %0d", $dimensions(mem));


    $display("unpacked_dimensions: %0d", $unpacked_dimensions(arr2d));
    $display("unpacked_dimensions: %0d", $unpacked_dimensions(arr2d_pack1));
    $display("unpacked_dimensions: %0d", $unpacked_dimensions(arr2d_pack2));
    $display("unpacked_dimensions: %0d", $unpacked_dimensions(mem));


    $display("size: %0d", $size(arr2d));
    $display("size: %0d", $size(arr2d_pack1));
    $display("size: %0d", $size(arr2d_pack2));
    $display("size: %0d", $size(mem));

    $display("size: %0d", $bits(arr2d));
    $display("size: %0d", $bits(arr2d_pack1));
    $display("size: %0d", $bits(arr2d_pack2));
    $display("size: %0d", $bits(mem));
  end

  // Packed
  // - elemanlar tek bir eleman gibi depolanır
  // - birden fazla  elemana aynı anda erişim yada işlem yapma mümkündür


endmodule
