module uart_tx #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input logic clk_i,
    input logic rst_ni,
    input logic [15:0] baud_div_i,
    input logic tx_we_i,     // İşlemciden gelen yazma enable sinyali
    input logic tx_en_i,     // TX modülü için genel enable sinyali
    input logic [DATA_WIDTH-1:0] din_i, // FIFO'ya yazılacak veri

    output logic empty_o,  // TX FIFO'sunun boş olduğunu gösterir
    output logic full_o,   // TX FIFO'sunun dolu olduğunu gösterir
    output logic tx_bit_o  // Giden UART seri data hattı
);

  // Dahili sinyaller
  localparam COUNTER_WIDTH = $clog2(DATA_WIDTH);

  logic                     rd_en;  // TX FIFO'dan okuma enable sinyali
  logic [   DATA_WIDTH-1:0] data;  // FIFO'dan okunan veri
  logic [   DATA_WIDTH-1:0] data_q;  // Gönderilmek üzere kaydedilen veri
  logic [COUNTER_WIDTH-1:0] bit_counter;  // Gönderilen bit sayacını tutar (0'dan DATA_WIDTH-1'e kadar)
  logic [             15:0] baud_counter;  // Her bir bitin gönderim süresini sayar

  // Durum makinesi (FSM) tanımları
  typedef enum logic [1:0] {
    IDLE,           // Boş bekleme durumu
    SENDING_START,  // Start bitini gönderme durumu
    SENDING_DATA,   // Veri bitlerini gönderme durumu
    SENDING_STOP    // Stop bitini gönderme durumu
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
    rd_en = 1'b0;  // Varsayılan olarak FIFO'dan okuma yapma

    unique case (state)
      IDLE: begin
        if (tx_en_i && !empty_o) begin
          rd_en = 1'b1;
          next_state = SENDING_START;
        end
      end
      SENDING_START: begin
        if (baud_counter == baud_div_i - 1) begin
          next_state = SENDING_DATA;
        end
      end
      SENDING_DATA: begin
        if (baud_counter == baud_div_i - 1 && bit_counter == DATA_WIDTH - 1) begin
          next_state = SENDING_STOP;
        end
      end
      SENDING_STOP: begin
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
      default:       tx_bit_o = 1'b1;
    endcase
  end

  // FSM'nin ardışık (sequential) mantığı
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state <= IDLE;
      baud_counter <= 0;
      bit_counter <= 0;
      data_q <= '1;
    end else begin
      state <= next_state;

      // Baud rate sayacını yönetir
      if (state == IDLE) begin
        baud_counter <= 0;
      end else if (baud_counter == baud_div_i - 1) begin
        baud_counter <= 0;
      end else begin
        baud_counter <= baud_counter + 1;
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
            if (bit_counter < DATA_WIDTH - 1) begin
              bit_counter <= bit_counter + 1;
            end
          end
          SENDING_STOP: begin
            bit_counter <= 0;
          end
          default: ;
        endcase
      end
    end
  end

endmodule
