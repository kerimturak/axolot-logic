// ayrı olarak compile edilmesi lazım
// içerisindeki elemanlanılmadan compile edilmeli
// function, task, parameter, typedef, struct


package uart_pkg;

  parameter DATA_WIDTH = 8;
  parameter FIFO_DEPTH = 16;

  // Testbench Parametreleri
  // ---
  parameter CLK_PERIOD = 10;  // 100MHz clock (10ns period)
  parameter BAUD_DIV = 104;  // 9600 baud rate için
  parameter BAUD_CLK_PERIOD = CLK_PERIOD * BAUD_DIV;

  // Durum makinesi (FSM) tanımları
  typedef enum logic [1:0] {
    IDLE,
    SENDING_START,
    SENDING_DATA,
    SENDING_STOP
  } state_t;

  // imports do not chain


  /*
  p1    p2     uart

  - p1'i p2 import 
  - p2'i uart'a import ettim
  - uart p1'i göremez



  p1 ve p2 aynı parametreye sahip add_sum

  p1::*;
  p2::*;

  p2::add_sum;
  */
endpackage
