library IEEE;
use ieee.std_logic_1164.all;


entity LEDMatrix_testbench is
end entity LEDMatrix_testbench;




architecture LEDMatrix_testbench_arch of LEDMatrix_testbench is
  
  signal CLOCK_50 : std_logic:= '1';
  signal reset :  std_logic;
  
	component LEDMatrix_Ctrl is
		port
		(
			clk	: in  std_logic;
			reset	 : in	std_logic;
					
			-- Display buffer connection
			mem_a : out std_logic_vector(10 downto 0);
			mem_q : in std_logic_vector(11 downto 0);
			
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

begin
  
  CLOCK_50 <= not CLOCK_50 after 20 ns;
  
  reset <= '1' after 0 ns,
    '0' after 300 ns,
    '1' after 400 ns;
  
  
	m0 : component LEDMatrix_Ctrl
		port map (
			clk	=>	CLOCK_50,
			reset => reset,
			mem_q => "101011110000"

		);
		
		  
  
end architecture LEDMatrix_testbench_arch;