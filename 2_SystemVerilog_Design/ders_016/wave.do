onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/DATA_WIDTH
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/FIFO_DEPTH
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/clk_i
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/rst_ni
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/baud_div_i
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/tx_we_i
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/tx_en_i
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/din_i
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/empty_o
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/full_o
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/tx_bit_o
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/rd_en
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/data
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/data_q
add wave -noupdate -expand -group TX -radix unsigned /tb_uart/uart_inst/uart_tx_inst/bit_counter
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/baud_counter
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/state
add wave -noupdate -expand -group TX /tb_uart/uart_inst/uart_tx_inst/next_state
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/clk_i
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rst_ni
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/baud_div_i
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_re_i
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_en_i
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_bit_i
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/dout_o
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/full_o
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/empty_o
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/frame_error_o
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_we
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_data_reg
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_data_out_reg
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/bit_counter
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/baud_counter
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/state
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/next_state
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/mid_tick
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/end_tick
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_we_d
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/rx_we_q
add wave -noupdate -expand -group RX /tb_uart/uart_inst/uart_rx_inst/frame_error
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/clk_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/rst_ni
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/stb_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/adr_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/byte_sel_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/we_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/dat_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/dat_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/uart_rx_i
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/uart_tx_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/baud_div_reg
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/tx_en_reg
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/rx_en_reg
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/tx_full_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/tx_empty_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/rx_full_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/rx_empty_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/rx_frame_error
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/tx_we_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/rx_re_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/dout_o
add wave -noupdate -group UART -radix hexadecimal /tb_uart/uart_inst/uart_reg_e
add wave -noupdate -group TB /tb_uart/CLK_PERIOD
add wave -noupdate -group TB /tb_uart/BAUD_RATE
add wave -noupdate -group TB /tb_uart/CLK_FREQ
add wave -noupdate -group TB /tb_uart/BAUD_DIVISOR
add wave -noupdate -group TB /tb_uart/FIFO_DEPTH
add wave -noupdate -group TB /tb_uart/XLEN
add wave -noupdate -group TB /tb_uart/clk
add wave -noupdate -group TB /tb_uart/rst_n
add wave -noupdate -group TB /tb_uart/stb
add wave -noupdate -group TB /tb_uart/addr
add wave -noupdate -group TB /tb_uart/byte_sel
add wave -noupdate -group TB /tb_uart/we
add wave -noupdate -group TB /tb_uart/data_i
add wave -noupdate -group TB /tb_uart/data_o
add wave -noupdate -group TB /tb_uart/uart_rx
add wave -noupdate -group TB /tb_uart/uart_tx
add wave -noupdate -radix hexadecimal /tb_uart/uart_inst/uart_tx_inst/tx_buffer/fifo_mem
add wave -noupdate -radix hexadecimal /tb_uart/uart_inst/uart_rx_inst/rx_buffer/fifo_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58639768 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {58352320 ps} {59177680 ps}
