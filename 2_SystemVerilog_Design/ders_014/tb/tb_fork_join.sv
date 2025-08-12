`timescale 1ns / 1ps

module tb_fork_join;

  initial begin
    $display("--------------------------------------------------");
    $display("Baslangic: %0t ns", $time);

    // fork...join_any ornegi
    // Bu blok, icindeki sureclerden SADECE ILK BITENI bekler.
    // Digerleri sonlandirilir.
    $display("--------------------------------------------------");
    $display(">>> fork...join_any <<<");
    fork
      #5ns $display("Islem 1 (join_any): %0t ns", $time);
      #3ns $display("Islem 2 (join_any): %0t ns", $time);
    join_any
    $display("join_any bitti: %0t ns", $time);

    // fork...join ornegi
    // Bu blok, icindeki TUM sureclerin bitmesini bekler.
    $display("--------------------------------------------------");
    $display(">>> fork...join <<<");
    fork
      #5ns $display("Islem 1 (join): %0t ns", $time);
      #3ns $display("Islem 2 (join): %0t ns", $time);
    join
    $display("join bitti: %0t ns", $time);

    // fork...join_none ornegi
    // Bu blok, surecleri baslatir ve HICBIRINI beklemez.
    // Hemen devam eder ve surecler arka planda calisir.
    $display("--------------------------------------------------");
    $display(">>> fork...join_none <<<");
    fork
      #5ns $display("Islem 1 (join_none): %0t ns", $time);
      #3ns $display("Islem 2 (join_none): %0t ns", $time);
    join_none
    $display("join_none bitti: %0t ns", $time);
    $display("--------------------------------------------------");

    #10ns;  // join_none ile baslayan islemlerin bitmesi icin bekleme
    $display("Tum islemler bitti: %0t ns", $time);
    $finish;
  end

endmodule
