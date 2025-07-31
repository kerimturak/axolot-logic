
module tb_task_func;

  reg  [2:0] a;
  reg  [2:0] b;
  reg  [6:0] c;
  reg  [6:0] comb;
  reg  [6:0] assgn;
  reg        flag_;
  wire [2:0] wait_wire;
  reg        clk = 0;
  always #5 clk = ~clk;

  //always @(*) begin               // fonksiyon inputlarını hassasiyet listesine almaz
  //    comb = calc(2'b10, 2'b01);
  //end

  assign assgn = calc(2'b10, 2'b01);

  initial begin
    a = 0;
    b = 0;
    c = 0;
    $display("\ntime :%0t ", $time);

    /* Function
            - Simülasyon zamanı tüketmezler
            - sadece 1 değer döndürebilirler (return)
            - Herhangi bir zaman ifadesi içermezler #10, @(posedge), $wait()
            - fonksiyon içerisinde fonksiyon çağırabilirsiniz, ama task çağıramazsınız
            - 
        */
    #10;
    c = calc(2'b10, 2'b01);
    $display("\ntime :%0t, c_diff:%d, c_sum:%d ", $time, c[6:4], c[3:0]);


    /*  Task
            - Simülasyon zamanı tüketecek ifadeler kullanılabilir #10; @(posedge), wait
            - birden fazla input, birden outputa izin verir
            - task içinde task ya da fonksiyon çağırabilirsiniz
            - assign ile kullanılmazlar
        */
    a = 2;
    b = 3;
    wait (wait_wire == 2'b11);
    my_proc(a, b, flag_);
    $display("\ntime :%0t, flag: %d ", $time, flag_);
    $stop;
  end
  assign #30 wait_wire = 2'b11;

  task my_proc;
    input [2:0] a;
    input [2:0] b;
    output flag;
    begin
      @(posedge clk);
      flag = ($signed((a - b)) < 0);
    end
  endtask

  function [3:0] add;
    input [2:0] a;
    input [2:0] b;
    add = a + b;
  endfunction

  function [2:0] sub;
    input [2:0] a;
    input [2:0] b;
    sub = a - b;
  endfunction

  function [6:0] calc;
    input [2:0] a;
    input [2:0] b;
    reg [3:0] sum;
    reg [2:0] diff;
    begin
      sum  = add(a, b);
      diff = sub(a, b);
      calc = {diff, sum};
    end
  endfunction
endmodule
