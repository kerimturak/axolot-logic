`timescale 1ns / 1ps

module tb_dynamic_arrays;

  // Eğer simülasyon sırasında bir array'in boyutunu değiştirmek istiyorsanız.
  // array'in tanımından sonra unpack olan boyutunu [] bırakıyoruz.

  logic [7:0] dyn_arr[];

  initial begin
    dyn_arr = new[8];  // create, ya da boyutunu değiştirir

    for (int i = 0; i < 8; i++) begin
      dyn_arr[i] = i;
    end

    $display("size: %0d", dyn_arr.size());

    dyn_arr = new[16];  // create, ya da boyutunu değiştirir
    $display("size: %0d", dyn_arr.size());



    dyn_arr.delete();
    $display("size: %0d", dyn_arr.size());  // elemanları temizler ve eleman sayısını sıfıra ayarlar
  end

  // associative arrays
  // Atama yapılana kadar array elemanları var olmaz
  // key: value
  logic [7:0] assoc_arr1[int];  // key : int
  logic [7:0] assoc_arr2[string];

  /*
    num()
    size()
    exists()
    delete()
    first()
    last()
    prev()
    next()
  */
  initial begin
    assoc_arr1[10] = 8'd7;
    assoc_arr2["ev_fiyati"] = 8'd7;

    $display("assoc_arr1[10]: %0d", assoc_arr1[10]);
    $display("ev_fiyati: %0d", assoc_arr2["ev_fiyati"]);

  end


  // Queues
  // dinamik olarak kendini boyutlandırır

  /*
    size()
    insert()
    delete()
    pop_front()
    push_front()
    pop_back()
    push_back()
  */
  int my_que[$:100];

  int size;

  initial begin
    my_que.push_front(1);  // {1}
    my_que.push_back(2);  // {1, 2}
    my_que.push_front(5);  //{5, 1, 2}
    my_que.push_back(0);  // //{5, 1, 2, 0}
    #20ns;

    for (int i = 0; i < my_que.size(); ++i) begin
      //$display("quque%0d: %0d", i, my_que.pop_front());
      $display("quque: %0p", my_que[i]);

    end

    /*
    size = my_que.size();

    for (int i = 0; i < size; ++i) begin
      $display("quque%0d: %0d", i, my_que.pop_front());
    end
*/

  end
endmodule
