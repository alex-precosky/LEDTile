
module QSys (
	clk_clk,
	pio_led_export,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	epcs_dclk,
	epcs_sce,
	epcs_sdo,
	epcs_data0,
	pll_locked_export,
	reset_reset_n,
	sdram_clk_clk,
	pll_areset_export,
	display_buffer_addr_export,
	display_buffer_data_export,
	display_buffer_ctrl_export,
	sys_clk_clk);	

	input		clk_clk;
	output	[7:0]	pio_led_export;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		epcs_dclk;
	output		epcs_sce;
	output		epcs_sdo;
	input		epcs_data0;
	output		pll_locked_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	input		pll_areset_export;
	output	[10:0]	display_buffer_addr_export;
	output	[23:0]	display_buffer_data_export;
	output	[7:0]	display_buffer_ctrl_export;
	output		sys_clk_clk;
endmodule