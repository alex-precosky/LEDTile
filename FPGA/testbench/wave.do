onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ledmatrix_testbench/m0/clk
add wave -noupdate /ledmatrix_testbench/m0/row_half_addr
add wave -noupdate /ledmatrix_testbench/m0/colour_bit
add wave -noupdate /ledmatrix_testbench/m0/state
add wave -noupdate -divider {Address Generation}
add wave -noupdate /ledmatrix_testbench/m0/col_addr
add wave -noupdate /ledmatrix_testbench/m0/row_addr
add wave -noupdate /ledmatrix_testbench/m0/panel_A
add wave -noupdate /ledmatrix_testbench/m0/mem_a
add wave -noupdate -divider {Panel Colours}
add wave -noupdate /ledmatrix_testbench/m0/mem_q
add wave -noupdate /ledmatrix_testbench/m0/panel_R0
add wave -noupdate /ledmatrix_testbench/m0/panel_G0
add wave -noupdate /ledmatrix_testbench/m0/panel_B0
add wave -noupdate /ledmatrix_testbench/m0/panel_R1
add wave -noupdate /ledmatrix_testbench/m0/panel_G1
add wave -noupdate /ledmatrix_testbench/m0/panel_B1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {617994 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 219
configure wave -valuecolwidth 141
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {2100 ns}
