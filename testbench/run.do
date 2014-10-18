vcom -work work -2002 -explicit C:/Users/Alex/Desktop/LEDTile/rtl/LEDMatrix_Ctrl.vhd
vcom -work work -2002 -explicit C:/Users/Alex/Desktop/LEDTile/testbench/LEDMatrix_testbench.vhd
vsim -novopt work.ledmatrix_testbench 
do wave.do
run 2 us