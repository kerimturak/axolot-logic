module tb_general;

  // always, always_ff, always_comb, always_latch

  //logic [3:0] a;
  //
  //logic       clk = 0;
  //always #5 clk = ~clk;

  // bu blocklar içerisinde atanan bir değişken başka blokta atanamaz
  // Sentez tool'u sizi eğer ff üretilmiyorsa uyarabilir.
  // edge sensitive depolama elemanı üretmek için kullanılır

  //always_ff @(posedge clk) begin
  //  a <= 5;
  //end

  // 0 anında bir kez çalıştırılır
  // Tool sizi uyarabilir eğer kombinasyonel devre üretmezse
  //always_comb begin
  //  a = 5;
  //end

  // 0 zamanında always ve initial blocklarından sonra bir kez çalıştırılır.
  //always_latch begin
  //  a <= 5;
  //end
  //
  //initial begin
  //  #100ns;
  //  $stop;
  //end



  //------------------------------------------------------

  // Sized literal
  // <size>'<base><value>
  logic [7:0] data;
  int         count;

  initial begin
    data = 8'b10001011;

    repeat (8) begin
      data = {data[6:0], data[7]};
      $display("data:%0b ", data);
      if (data[7]) break;
    end

    foreach (data[i]) begin
      if (data[i]) continue;
      count = count + 1;
    end
    $display("count:%0d ", count);

    #100ns;
    $stop;
  end

endmodule
