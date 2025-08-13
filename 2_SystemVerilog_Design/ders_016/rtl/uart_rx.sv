module uart_rx #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input logic        clk_i,       // Sistem saat girişi
    input logic        rst_ni,      // Asenkron aktif-düşük reset sinyali
    input logic [15:0] baud_div_i,  // Baud rate bölücü değeri
    input logic        rx_re_i,     // FIFO'dan okuma etkinleştirme sinyali
    input logic        rx_en_i,     // RX modülü için genel etkinleştirme sinyali
    input logic        rx_bit_i,    // Gelen seri data hattı

    output logic [DATA_WIDTH-1:0] dout_o,  // FIFO'dan okunan veri çıkışı
    output logic                  full_o,  // FIFO'nun dolu olduğunu gösterir
    output logic                  empty_o  // FIFO'nun boş olduğunu gösterir
);

  // Dahili parametre ve sinyaller
  localparam COUNTER_WIDTH = $clog2(DATA_WIDTH + 1);

  logic [   DATA_WIDTH-1:0] rx_data_reg;  // Gelen veri bitlerini tutar
  logic [COUNTER_WIDTH-1:0] bit_counter;  // Alınan bit sayacını tutar
  logic [             15:0] baud_counter;  // Her bir bit periyodunu sayan sayaç

  // Durum makinesi (FSM) tanımları
  typedef enum logic [1:0] {
    IDLE,  // Boş bekleme durumu, start bitini bekler
    START_BIT,  // Start bitini doğrulama durumu
    DATA_BITS,  // Veri bitlerini alma durumu
    STOP_BIT  // Stop bitini kontrol etme durumu
  } state_t;

  state_t state, next_state;

  // Baud rate ve bit periyodu sinyalleri
  logic mid_tick;
  logic end_tick;

  assign mid_tick = (baud_counter == (baud_div_i >> 1));
  assign end_tick = (baud_counter == baud_div_i);

  // FIFO modülü
  wbit_fifo #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) rx_buffer (
      .clk  (clk_i),
      .rst  (!rst_ni),
      .wr_en(rx_we),
      .rd_en(rx_re_i),
      .wdata(rx_data_reg),
      .rdata(dout_o),
      .full (full_o),
      .empty(empty_o)
  );

  // FIFO'ya yazma etkinleştirme sinyali
  assign rx_we = (state == STOP_BIT) && end_tick;

  // FSM ve diğer lojikler
  always_comb begin
    next_state = state;

    unique case (state)
      IDLE: begin
        if (rx_en_i && !rx_bit_i && !full_o) begin
          next_state = START_BIT;
        end
      end
      START_BIT: begin
        if (mid_tick) begin
          if (!rx_bit_i) begin
            next_state = DATA_BITS;
          end else begin
            next_state = IDLE;
          end
        end
      end
      DATA_BITS: begin
        if (mid_tick && bit_counter == DATA_WIDTH - 1) begin
          next_state = STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (mid_tick) begin
          if (rx_bit_i == 1'b1) begin
            next_state = IDLE;
          end
        end
      end
    endcase
  end

  // Ardışık (Sequential) Lojik
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state    <= IDLE;
      baud_counter <= '0;
      bit_counter <= '0;
      rx_data_reg <= '0;
    end else begin
      state <= next_state;

      // Baud sayacı
      if (state == IDLE || end_tick) begin
        baud_counter <= '0;
      end else begin
        baud_counter <= baud_counter + 1'b1;
      end

      // Örnekleme ve bit sayacı
      if (mid_tick) begin
        if (state == DATA_BITS) begin
          rx_data_reg[bit_counter] <= rx_bit_i;
          if (bit_counter < DATA_WIDTH - 1) begin
            bit_counter <= bit_counter + 1'b1;
          end
        end else if (state == START_BIT) begin
          bit_counter <= '0;
        end
      end
    end
  end

endmodule
