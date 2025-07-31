module fifo_wc #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8
) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] wdata,
    output wire [DATA_WIDTH-1:0] rdata,
    output wire full,
    output wire empty
);

  localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

  reg [DATA_WIDTH-1:0] fifo_mem[FIFO_DEPTH-1:0];
  reg [ADDR_WIDTH-1:0] wr_point, rd_point;
  reg [  ADDR_WIDTH:0] fifo_count;

  reg [DATA_WIDTH-1:0] fifo_rdata;

  always @(posedge clk) begin
    if (rst) begin
      wr_point   <= 0;
      rd_point   <= 0;
      fifo_count <= 0;
    end else begin

      case ({
        wr_en, rd_en
      })
        2'b10:   fifo_count <= fifo_count + 1;
        2'b01:   fifo_count <= fifo_count - 1;
        default: fifo_count <= fifo_count;
      endcase

      if (wr_en && !full) begin
        fifo_mem[wr_point] <= wdata;
        wr_point <= wr_point + 1;
      end

      if (rd_en && !empty) begin
        fifo_rdata <= fifo_mem[rd_point];
        rd_point   <= rd_point + 1;
      end
    end

  end

  assign full  = (fifo_count == FIFO_DEPTH);
  assign empty = (fifo_count == 0);
  assign rdata = empty && (rd_en && wr_en) ? wdata : fifo_rdata;
endmodule
