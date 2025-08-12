// Interface kendi portlarına sahip olabilir
interface uart_if #(
    parameter BAUD_DIV = 104
) (
    input logic clk_i
);

  // interface ayrı bir dosyada tanımlanmalı ve ayrı bir modül gibi compile edilmeli

  logic        rst_ni;
  logic [15:0] baud_div_i;
  logic        tx_we_i;
  logic        tx_en_i;
  logic [ 7:0] din_i;
  logic        empty_o;
  logic        full_o;
  logic        tx_bit_o;

  // modport
  modport master(output baud_div_i, output tx_we_i);
  modport slave(input clk_i, input rst_ni, input baud_div_i, input tx_we_i, input tx_en_i, input din_i, output empty_o, output full_o, output tx_bit_o, import rst_signals);

  // task, funcktion, initial, always bloğu gibi bloklar içerebilir

  task rst_signals();
    rst_ni <= 0;
    baud_div_i <= BAUD_DIV;
    tx_we_i <= 0;
    tx_en_i <= 0;
    din_i <= 0;
  endtask

  // array olarakta örnekleyebilirsiniz
  // bir interface içerisinde başka interface'de örneklenebilir
  // assign atamsı kullanılabilir
  // assertion yazılabilir
endinterface
