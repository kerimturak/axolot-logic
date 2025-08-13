module uart #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input  logic        clk_i,       // Sistem saat girişi
    input  logic        rst_ni,      // Asenkron aktif-düşük reset sinyali
    input  logic        stb_i,       // İşlemci veriyolu (bus) strobe sinyali
    input  logic [ 1:0] adr_i,       // İşlemci tarafından seçilen register adresi
    input  logic [ 3:0] byte_sel_i,  // Hangi byte'ların yazılacağını belirler
    input  logic        we_i,        // Yazma etkinleştirme sinyali
    input  logic [31:0] dat_i,       // İşlemciden gelen veri
    output logic [31:0] dat_o,       // İşlemciye gönderilen veri
    input  logic        uart_rx_i,   // Gelen seri UART hattı
    output logic        uart_tx_o    // Giden seri UART hattı
);

  // Dahili Sinyaller
  logic                                                                                                               [          15:0] baud_div_reg;  // Baud rate bölücü değeri
  logic                                                                                                                                tx_en_reg;  // TX modülü etkinleştirme
  logic                                                                                                                                rx_en_reg;  // RX modülü etkinleştirme
  logic                                                                                                                                tx_full_o;  // TX FIFO dolu
  logic                                                                                                                                tx_empty_o;  // TX FIFO boş
  logic                                                                                                                                rx_full_o;  // RX FIFO dolu
  logic                                                                                                                                rx_empty_o;  // RX FIFO boş
  logic                                                                                                                                rx_frame_error;  // RX framing hatası
  logic                                                                                                                                tx_we_o;  // TX FIFO write enable
  logic                                                                                                                                rx_re_o;  // RX FIFO read enable
  logic                                                                                                               [DATA_WIDTH-1:0] dout_o;  // RX FIFO çıkışı
  logic                                                                                                               [          31:0] rdata;
  logic                                                                                                                                rd_state;

  // Adres haritası
  enum logic [1:0] {UART_BAUD_ADDR = 2'b00, UART_CTRL_ADDR = 2'b01, UART_STATUS_ADDR = 2'b10, UART_DATA_ADDR = 2'b11}                  uart_reg_e;

  // TX Modülü
  uart_tx #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) uart_tx_inst (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .baud_div_i(baud_div_reg),
      .tx_we_i   (tx_we_o),
      .tx_en_i   (tx_en_reg),
      .din_i     (dat_i[DATA_WIDTH-1:0]),
      .full_o    (tx_full_o),
      .empty_o   (tx_empty_o),
      .tx_bit_o  (uart_tx_o)
  );

  // RX Modülü
  uart_rx #(
      .DATA_WIDTH(DATA_WIDTH),
      .FIFO_DEPTH(FIFO_DEPTH)
  ) uart_rx_inst (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .baud_div_i(baud_div_reg),
      .rx_re_i   (rx_re_o),
      .rx_en_i   (rx_en_reg),
      .dout_o    (dout_o),
      .full_o    (rx_full_o),
      .empty_o   (rx_empty_o),
      .rx_bit_i  (uart_rx_i)
  );

  // Register yazma (senkron)
  always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
      baud_div_reg <= 16'd0;
      tx_en_reg    <= 1'b0;
      rx_en_reg    <= 1'b0;
    end else if (stb_i && we_i) begin
      unique case (adr_i)
        UART_BAUD_ADDR: begin
          if (byte_sel_i[0] || byte_sel_i[1]) baud_div_reg <= dat_i[15:0];
        end
        UART_CTRL_ADDR: begin
          if (byte_sel_i[0]) begin
            tx_en_reg <= dat_i[0];
            rx_en_reg <= dat_i[1];
          end
        end
        default: ;  // No other registers writable
      endcase
    end
  end

  // FIFO kontrol sinyalleri (kombinasyonel)
  always_comb begin
    tx_we_o = 1'b0;
    rx_re_o = 1'b0;

    if (stb_i) begin
      unique case (adr_i)
        UART_DATA_ADDR: begin
          if (we_i) begin
            // TX write
            tx_we_o = ~tx_full_o;
          end else begin
            // RX read
            rx_re_o = ~rx_empty_o;
          end
        end
        default: ;
      endcase
    end
  end

  // Okuma verisi (senkron, stabil tutma)
  always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
      rdata <= '0;
      rd_state <= '0;
    end else begin
      // Varsayılan: önceki değeri koru
      rdata <= rdata;
      rd_state <= stb_i && adr_i == UART_DATA_ADDR && !we_i;
      if (stb_i) begin
        unique case (adr_i)
          UART_BAUD_ADDR:   rdata <= {16'b0, baud_div_reg};
          UART_CTRL_ADDR:   rdata <= {29'b0, rx_en_reg, tx_en_reg};
          UART_STATUS_ADDR: rdata <= {27'b0, rx_frame_error, rx_empty_o, rx_full_o, tx_empty_o, tx_full_o};
          //UART_DATA_ADDR: begin
          //  if (!we_i) begin
          //    // RX read
          //    rdata <= {{(32 - DATA_WIDTH) {1'b0}}, dout_o};
          //  end
          //end
          default:          rdata <= '0;
        endcase
      end
    end
  end

  assign dat_o = rd_state ? {{(32 - DATA_WIDTH) {1'b0}}, dout_o} : rdata;

endmodule
