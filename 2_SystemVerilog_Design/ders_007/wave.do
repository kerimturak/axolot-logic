onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_uart_tx/dut/clk_i
add wave -noupdate /tb_uart_tx/dut/rst_ni
add wave -noupdate /tb_uart_tx/dut/baud_div_i
add wave -noupdate /tb_uart_tx/dut/tx_we_i
add wave -noupdate /tb_uart_tx/dut/tx_en_i
add wave -noupdate /tb_uart_tx/dut/din_i
add wave -noupdate /tb_uart_tx/dut/empty_o
add wave -noupdate /tb_uart_tx/dut/full_o
add wave -noupdate /tb_uart_tx/dut/tx_bit_o
add wave -noupdate /tb_uart_tx/dut/rd_en
add wave -noupdate /tb_uart_tx/dut/data
add wave -noupdate /tb_uart_tx/dut/data_q
add wave -noupdate -radix unsigned /tb_uart_tx/dut/bit_counter
add wave -noupdate /tb_uart_tx/dut/baud_counter
add wave -noupdate /tb_uart_tx/dut/state
add wave -noupdate /tb_uart_tx/dut/next_state
add wave -noupdate /tb_uart_tx/clk_i
add wave -noupdate /tb_uart_tx/rst_ni
add wave -noupdate /tb_uart_tx/baud_div_i
add wave -noupdate /tb_uart_tx/tx_we_i
add wave -noupdate /tb_uart_tx/tx_en_i
add wave -noupdate /tb_uart_tx/din_i
add wave -noupdate /tb_uart_tx/empty_o
add wave -noupdate /tb_uart_tx/full_o
add wave -noupdate /tb_uart_tx/tx_bit_o
add wave -noupdate /tb_uart_tx/expected_frame
add wave -noupdate /tb_uart_tx/bit_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80624 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
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
WaveRestoreZoom {0 ps} {1322960 ps}
