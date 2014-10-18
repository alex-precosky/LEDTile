	component QSys is
		port (
			clk_clk                    : in    std_logic                     := 'X';             -- clk
			pio_led_export             : out   std_logic_vector(7 downto 0);                     -- export
			sdram_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                : out   std_logic;                                        -- cas_n
			sdram_cke                  : out   std_logic;                                        -- cke
			sdram_cs_n                 : out   std_logic;                                        -- cs_n
			sdram_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n                : out   std_logic;                                        -- ras_n
			sdram_we_n                 : out   std_logic;                                        -- we_n
			epcs_dclk                  : out   std_logic;                                        -- dclk
			epcs_sce                   : out   std_logic;                                        -- sce
			epcs_sdo                   : out   std_logic;                                        -- sdo
			epcs_data0                 : in    std_logic                     := 'X';             -- data0
			pll_locked_export          : out   std_logic;                                        -- export
			reset_reset_n              : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk              : out   std_logic;                                        -- clk
			pll_areset_export          : in    std_logic                     := 'X';             -- export
			display_buffer_addr_export : out   std_logic_vector(10 downto 0);                    -- export
			display_buffer_data_export : out   std_logic_vector(23 downto 0);                    -- export
			display_buffer_ctrl_export : out   std_logic_vector(7 downto 0);                     -- export
			sys_clk_clk                : out   std_logic                                         -- clk
		);
	end component QSys;

	u0 : component QSys
		port map (
			clk_clk                    => CONNECTED_TO_clk_clk,                    --                 clk.clk
			pio_led_export             => CONNECTED_TO_pio_led_export,             --             pio_led.export
			sdram_addr                 => CONNECTED_TO_sdram_addr,                 --               sdram.addr
			sdram_ba                   => CONNECTED_TO_sdram_ba,                   --                    .ba
			sdram_cas_n                => CONNECTED_TO_sdram_cas_n,                --                    .cas_n
			sdram_cke                  => CONNECTED_TO_sdram_cke,                  --                    .cke
			sdram_cs_n                 => CONNECTED_TO_sdram_cs_n,                 --                    .cs_n
			sdram_dq                   => CONNECTED_TO_sdram_dq,                   --                    .dq
			sdram_dqm                  => CONNECTED_TO_sdram_dqm,                  --                    .dqm
			sdram_ras_n                => CONNECTED_TO_sdram_ras_n,                --                    .ras_n
			sdram_we_n                 => CONNECTED_TO_sdram_we_n,                 --                    .we_n
			epcs_dclk                  => CONNECTED_TO_epcs_dclk,                  --                epcs.dclk
			epcs_sce                   => CONNECTED_TO_epcs_sce,                   --                    .sce
			epcs_sdo                   => CONNECTED_TO_epcs_sdo,                   --                    .sdo
			epcs_data0                 => CONNECTED_TO_epcs_data0,                 --                    .data0
			pll_locked_export          => CONNECTED_TO_pll_locked_export,          --          pll_locked.export
			reset_reset_n              => CONNECTED_TO_reset_reset_n,              --               reset.reset_n
			sdram_clk_clk              => CONNECTED_TO_sdram_clk_clk,              --           sdram_clk.clk
			pll_areset_export          => CONNECTED_TO_pll_areset_export,          --          pll_areset.export
			display_buffer_addr_export => CONNECTED_TO_display_buffer_addr_export, -- display_buffer_addr.export
			display_buffer_data_export => CONNECTED_TO_display_buffer_data_export, -- display_buffer_data.export
			display_buffer_ctrl_export => CONNECTED_TO_display_buffer_ctrl_export, -- display_buffer_ctrl.export
			sys_clk_clk                => CONNECTED_TO_sys_clk_clk                 --             sys_clk.clk
		);

