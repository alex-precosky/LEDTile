library IEEE;
use ieee.std_logic_1164.all;


entity LEDTile is

port(

	CLOCK_50		: in		std_logic;
	
	LED			: out		std_logic_vector(7 downto 0);
	KEY			: in		std_logic_vector(1 downto 0);
	
	DRAM_ADDR	: out		std_logic_vector(12 downto 0);
	DRAM_BA		: out 	std_logic_vector(1 downto 0);
	DRAM_CKE		: out 	std_logic;
	DRAM_CLK		: out 	std_logic;
	DRAM_CS_N	: out 	std_logic;
	DRAM_DQ		: inout 	std_logic_vector(15 downto 0);
	DRAM_DQM		: out		std_logic_vector(1 downto 0);
	DRAM_CAS_N	: out		std_logic;
	DRAM_RAS_N	: out		std_logic;
	DRAM_WE_N	: out		std_logic;

   EPCS_DCLK     : out   std_logic;
   EPCS_NCSO     : out   std_logic;
   EPCS_ASDO     : out   std_logic;
   EPCS_DATA0    : in    std_logic;
	
	GPIO_0		  : out std_logic_vector(33 downto 0)
	
	
	
);


end entity LEDTile;

architecture LEDTile_arch of LEDTile is
	
	signal panel_SCLK			:  std_logic;
	signal panel_A				:  std_logic_vector(3 downto 0);
	signal panel_blank		:  std_logic;
	signal panel_latch		:  std_logic;
	signal panel_R0			:  std_logic;
	signal panel_G0			:  std_logic;
	signal panel_B0			:  std_logic;
	signal panel_R1			:  std_logic;
	signal panel_G1			:  std_logic;
	signal panel_B1			:  std_logic;


	
	
	component QSys is
		port (
			clk_clk        : in    std_logic                     := 'X';             -- clk
			pio_led_export : out   std_logic_vector(7 downto 0);                     -- export
			sdram_addr     : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba       : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n    : out   std_logic;                                        -- cas_n
			sdram_cke      : out   std_logic;                                        -- cke
			sdram_cs_n     : out   std_logic;                                        -- cs_n
			sdram_dq       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm      : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n    : out   std_logic;                                        -- ras_n
			sdram_we_n     : out   std_logic;                                        -- we_n
			epcs_dclk      : out   std_logic;                                        -- dclk
			epcs_sce       : out   std_logic;                                        -- sce
			epcs_sdo       : out   std_logic;                                        -- sdo
			epcs_data0     : in    std_logic                     := 'X';              -- data0
			sdram_clk_clk  : out   std_logic;                                         -- clk
			reset_reset_n     : in    std_logic                     := 'X';              -- reset_n
			pll_areset_export : in    std_logic                     := 'X';              -- export		
			display_buffer_addr_export : out   std_logic_vector(10 downto 0);    -- export
			display_buffer_data_export : out   std_logic_vector(31 downto 0);             -- export
			display_buffer_ctrl_export : out   std_logic_vector(7 downto 0);               -- export
			sys_clk_clk                : out   std_logic                                         -- clk
		);
	end component QSys;

	
	
	component LEDMatrix_Ctrl is
		port
		(
			clk	: in  std_logic;
			reset	 : in	std_logic;
					
			-- Display buffer connection
			mem_a : out std_logic_vector(10 downto 0);
			mem_q : in std_logic_vector(31 downto 0);
			
			-- Outputs to the LED panel
			panel_SCLK : out std_logic;
			panel_A		: out std_logic_vector(3 downto 0);
			panel_blank	: out std_logic;
			panel_latch	: out std_logic;
			panel_R0	: out std_logic;
			panel_G0	: out std_logic;
			panel_B0	: out std_logic;
			panel_R1	: out std_logic;
			panel_G1	: out std_logic;
			panel_B1	: out std_logic	
		);
	end component LEDMatrix_Ctrl;

	component DisplayBuffer IS
		PORT
		(
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rdaddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			wraddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			wren		: IN STD_LOGIC  := '0';
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component DisplayBuffer;
	
	
	signal mem_ra : std_logic_vector(10 downto 0);
	signal mem_wa : std_logic_vector(10 downto 0);
	signal mem_d : std_logic_vector(31 downto 0);
	signal mem_q : std_logic_vector(31 downto 0);
	
	signal display_buffer_ctrl : std_logic_vector(7 downto 0); -- control register so NIOS can send commands 
																				  -- about displaying. bit 0 is write enable for buffer
	
	signal sys_clk : std_logic;  -- PLL output from QSys
	
	
begin

	GPIO_0(1) <= panel_R0;
	GPIO_0(2) <= panel_G0;
	GPIO_0(3) <= panel_B0;
	GPIO_0(4) <= panel_R1;
	GPIO_0(5) <= panel_G1;
	GPIO_0(6) <= panel_B1;
	GPIO_0(8) <= panel_A(0);
	GPIO_0(9) <= panel_A(1);
	GPIO_0(10) <= panel_A(2);
	GPIO_0(11) <= panel_A(3);
	GPIO_0(12) <= panel_SCLK;
	GPIO_0(13) <= panel_latch;
	GPIO_0(14) <= panel_blank;
	
	u0 : component QSys
		port map (
			clk_clk        => CLOCK_50,      --     clk.clk
			pio_led_export => LED,			 	-- pio_led.export
			sdram_addr     => DRAM_ADDR,     --   sdram.addr
			sdram_ba       => DRAM_BA,       --        .ba
			sdram_cas_n    => DRAM_CAS_N,    --        .cas_n
			sdram_cke      => DRAM_CKE,      --        .cke
			sdram_cs_n     => DRAM_CS_N,     --        .cs_n
			sdram_dq       => DRAM_DQ,       --        .dq
			sdram_dqm      => DRAM_DQM,      --        .dqm
			sdram_ras_n    => DRAM_RAS_N,    --        .ras_n
			sdram_we_n     => DRAM_WE_N,     --        .we_n
			epcs_dclk      => EPCS_DCLK,     --    epcs.dclk
			epcs_sce       => EPCS_NCSO,     --        .sce
			epcs_sdo       => EPCS_ASDO,     --        .sdo
			epcs_data0     => EPCS_DATA0,    --        .data0
			sdram_clk_clk  => DRAM_CLK,   	-- clk_sdram.clk
			reset_reset_n     => KEY(0),      --      reset.reset_n
			pll_areset_export => '0',  -- pll_areset.export
			display_buffer_addr_export => mem_wa, -- display_buffer_addr.export
			display_buffer_data_export => mem_d, -- display_buffer_data.export
			display_buffer_ctrl_export => display_buffer_ctrl,  -- display_buffer_ctrl.export		
			sys_clk_clk                => sys_clk                 --             sys_clk.clk	 From PLL
		);
		
	m0 : component LEDMatrix_Ctrl
		port map (
			clk	=>	sys_clk,
			reset => KEY(0),
			mem_a =>mem_ra,
			mem_q =>mem_q,
			panel_SCLK =>panel_SCLK,
			panel_A =>panel_A,
			panel_blank	=>panel_blank,
			panel_latch	=>panel_latch,
			panel_R0	=>panel_R0,
			panel_G0	=>panel_G0,
			panel_B0	=>panel_B0,
			panel_R1	=>panel_R1,
			panel_G1	=>panel_G1,
			panel_B1	=>	panel_B1			
		);
		
		
DisplayBuffer_inst : DisplayBuffer 
	port map (
		clock	 => sys_clk,
		data	 =>   mem_d,
		rdaddress	 => mem_ra,
		wraddress	 => mem_wa,
		wren	 =>  display_buffer_ctrl(0),
		q	 => mem_q
	);
		
		
		
end architecture LEDTile_arch;
