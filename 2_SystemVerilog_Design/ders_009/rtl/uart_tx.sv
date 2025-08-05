`timescale 1ns / 1ps
/*
* Baud Rate = Clock Frequency / (16 × Divisor)
*
* Clock Frequency: System saat frekansı
* Divisor: Baud rate oluşturmak için kullanılan bölücü değeri
* 16: UART'larda genellikle kullanılan oversampling oranıdır
*
* Divisor = Clock_Freq / (16 * Baud_Rate)
* Örnek: 16 MHz saat ve 9600 baud rate için:
* Divisor = 16_000_000 / (16 * 9600) = 104.1667 ≈ 104
*/
module uart_tx #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input logic        clk_i,
    input logic        rst_ni,
    input logic [15:0] baud_div_i,
    input logic        tx_we_i,
    input logic        tx_en_i,
    input logic [ 7:0] din_i,

    output logic empty_o,
    output logic full_o,
    output logic tx_bit_o
);

  // Dahili sinyaller
  logic        rd_en;
  logic [ 7:0] data;
  logic [ 7:0] data_q;  // Start (1), Data (8), Stop (1)
  logic [ 3:0] bit_counter;
  logic [15:0] baud_counter;

  // Durum makinesi (FSM) tanımları
  typedef enum logic [1:0] {
    IDLE,
    SENDING_START,
    SENDING_DATA,
    SENDING_STOP
  } state_t;

  state_t state, next_state;

  // FIFO modülü
  wbit_fifo #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) tx_buffer (
      .clk  (clk_i),
      .rst  (!rst_ni),
      .wr_en(tx_we_i),
      .rd_en(rd_en),
      .wdata(din_i),
      .rdata(data),
      .full (full_o),
      .empty(empty_o)
  );


  // FSM'nin kombinasyonel (next_state) mantığı
  always_comb begin
    next_state = state;
    rd_en = 1'b0;

    case (state)
      IDLE: begin
        // FIFO'da veri varsa ve TX etkinse, yeni bir transfer başlat
        if (tx_en_i && !empty_o) begin
          rd_en = 1'b1;  // Veriyi FIFO'dan oku
          next_state = SENDING_START;  // sonraki cycle state SENDING_START rd_en burada 1 yaptığımız için verisi okunmuş olacak
        end
      end
      SENDING_START: begin
        // İlk bit (start) gönderildikten sonra veri bitlerini göndermeye başla
        if (baud_counter == baud_div_i - 1) begin
          next_state = SENDING_DATA;
        end
      end
      SENDING_DATA: begin
        // 8 veri bitinin tümü gönderildiğinde, stop bitini göndermeye başla
        if (baud_counter == baud_div_i - 1 && bit_counter == 7) begin
          next_state = SENDING_STOP;
        end
      end
      SENDING_STOP: begin
        // Stop biti gönderildiğinde, IDLE durumuna dön veya yeni veri varsa tekrar başlat
        if (baud_counter == baud_div_i - 1) begin
          if (tx_en_i && !empty_o) begin
            rd_en = 1'b1;
            next_state = SENDING_START;
          end else begin
            next_state = IDLE;
          end
        end
      end
    endcase

    // TX Pini Çıkışı

    case (state)
      IDLE:          tx_bit_o = 1'b1;
      SENDING_START: tx_bit_o = 1'b0;
      SENDING_DATA:  tx_bit_o = data_q[bit_counter];
      SENDING_STOP:  tx_bit_o = 1'b1;
    endcase
  end

  // FSM'nin ardışık (sequential) mantığı
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state        <= IDLE;
      baud_counter <= 0;
      bit_counter  <= 0;
      data_q       <= '1;
    end else begin
      state <= next_state;

      // Baud rate sayacı
      if (state != IDLE) begin
        if (baud_counter == baud_div_i - 1) begin
          baud_counter <= 0;
        end else begin
          baud_counter <= baud_counter + 1;
        end
      end else begin
        baud_counter <= 0;
      end

      // Bit sayacı ve frame yönetimi
      if (baud_counter == baud_div_i - 1) begin
        case (state)
          IDLE: begin
            bit_counter <= 0;
          end
          SENDING_START: begin
            bit_counter <= 0;
            data_q <= data;
          end
          SENDING_DATA: begin
            if (bit_counter == 7) begin
              bit_counter <= 0;
            end else begin
              bit_counter <= bit_counter + 1;
            end
          end
          SENDING_STOP: begin
            bit_counter <= 0;  // Stop bit'in gönderildiğini belirt
          end
        endcase
      end
    end
  end
endmodule
