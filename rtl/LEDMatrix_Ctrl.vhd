library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_arith.all;

-- Displays the image contained in a display buffer

-- Display buffer is a 2-port RAM connected to this entity.
-- Each word is a pixel value in one of the 1024 pixels
-- But memory contains 2048 words, MSB switches between two such display buffers

entity LEDMatrix_Ctrl is

	port
	(

		clk	: in  std_logic;
		reset	 : in	std_logic;
		
		
		-- Display buffer connection
		mem_a : out std_logic_vector(10 downto 0);
		mem_q : in std_logic_vector(23 downto 0);
		
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
	
end LEDMatrix_Ctrl;




architecture LEDMatrix_Ctrl_arch of LEDMatrix_Ctrl is


 
 -- pixel currently presented at the data port of the memory
 signal mem_pixel_r : std_logic_vector(7 downto 0);
 signal mem_pixel_g : std_logic_vector(7 downto 0);
 signal mem_pixel_b : std_logic_vector(7 downto 0);

 
 -- Registers where we keep the low and high pixel.
 -- The panel is actually two mini-panels of 16 rows, and we can write
 -- an upper row and a lower row at once.
 signal pixel_lo_r : std_logic_vector(7 downto 0);
 signal pixel_lo_g : std_logic_vector(7 downto 0);
 signal pixel_lo_b : std_logic_vector(7 downto 0);
 signal pixel_hi_r : std_logic_vector(7 downto 0);
 signal pixel_hi_g : std_logic_vector(7 downto 0);
 signal pixel_hi_b : std_logic_vector(7 downto 0);
 
 signal row_addr : integer range 0 to 1023;		-- for generating ram address
 
 signal row_half_addr: integer range 0 to 31;	-- for iterating through rows in panel
 signal colour_bit: integer range 0 to 7; 		-- which of the 4 colour bits is being shifted out
 
 signal col_addr : integer range 0 to 1023;		-- part of ram address generation
 
 signal pixel_timer : integer range 0 to 30000;
 
 type state_type is (setup, latch_pixel_lo1, latch_pixel_lo2, latch_pixel_lo3, latch_pixel_lo4, latch_pixel_hi, latch_pixel_hi2, latch_pixel_hi3, latch_pixel_hi4, shift_bit_out1, shift_bit_out2, post_shift_wait, send_latch, unblanking, hold_row);
 signal state   : state_type;

begin

	--mem_a <= '1' & (conv_std_logic_vector(row_addr, 5) & conv_std_logic_vector(col_addr, 5);	


	mem_pixel_r <= mem_q(23 downto 16);
	mem_pixel_g <= mem_q(15 downto 8);
	mem_pixel_b <= mem_q(7 downto 0);

	

	
	
	process (clk, reset, mem_q)
	begin
		if reset = '0' then
			state <= setup;
			
		elsif (rising_edge(clk)) then
			case state is
			
				when setup =>
					pixel_timer <= 0;
					row_addr <= row_half_addr;
					state <= latch_pixel_lo1;
	
				when latch_pixel_lo1 =>
					state <= latch_pixel_lo2;
	
				when latch_pixel_lo2 =>
					pixel_lo_r <= mem_q(23 downto 16);
					pixel_lo_g <= mem_q(15 downto 8);
					pixel_lo_b <= mem_q(7 downto 0);
					
					state <= latch_pixel_lo3;
	
				when latch_pixel_lo3 =>
				
					panel_R0 <= pixel_lo_r(colour_bit);
					panel_G0 <= pixel_lo_g(colour_bit);
					panel_B0 <= pixel_lo_b(colour_bit);
					
					state <= latch_pixel_lo4;

				when latch_pixel_lo4 =>
					state <= latch_pixel_hi;
					
				when latch_pixel_hi =>
					row_addr <= row_half_addr+16;
								
					state <= latch_pixel_hi2;
				
				when latch_pixel_hi2 =>
					state <= latch_pixel_hi3;
		

				when latch_pixel_hi3 =>
					pixel_hi_r <= mem_q(23 downto 16);
					pixel_hi_g <= mem_q(15 downto 8);
					pixel_hi_b <= mem_q(7 downto 0);
					
					state <= latch_pixel_hi4;
					
				when latch_pixel_hi4 =>
	
					panel_R1 <= pixel_hi_r(colour_bit);
					panel_G1 <= pixel_hi_g(colour_bit);
					panel_B1 <= pixel_hi_b(colour_bit);		
						
					state <= shift_bit_out1;
				
				when shift_bit_out1 =>
					state <= shift_bit_out2;
					
				when shift_bit_out2 =>	
					if col_addr=31 then
						col_addr <= 0;
						state <= post_shift_wait;
						pixel_timer <= 1;
					else
						state <= setup;
						col_addr <= col_addr + 1;
					end if;
					
					-- not necessary
				when post_shift_wait =>
					if pixel_timer /= 0 then
						pixel_timer <= pixel_timer - 1;
						state <= post_shift_wait;
					else					
						state <= send_latch;
					end if;
					
					
				when send_latch =>
					state <= unblanking;
				
				when unblanking =>
					state <= hold_row;
					
					-- set timer for the next state
					if colour_bit = 0 then
						pixel_timer <= 32;
					elsif colour_bit = 1 then
						pixel_timer <= 64;
					elsif colour_bit = 2 then
						pixel_timer <= 128;
					elsif colour_bit = 3 then
						pixel_timer <= 256;
					elsif colour_bit = 4 then
						pixel_timer <= 512;
					elsif colour_bit = 5 then
						pixel_timer <= 1024;						
					elsif colour_bit = 6 then
						pixel_timer <= 2048;
					elsif colour_bit = 7 then
						pixel_timer <= 4096;
					else
						pixel_timer <= 0;
					end if;
					

					
				
				when hold_row =>
					
					if pixel_timer /= 0 then
						pixel_timer <= pixel_timer - 1;
						state <= hold_row;
					else
						if colour_bit = 7 then
							colour_bit <= 0;
							if row_half_addr = 15 then
								row_half_addr <= 0;
							else
								row_half_addr <= row_half_addr + 1;
							end if;
							
						else
							colour_bit <= colour_bit + 1;
						end if;
						state <= setup;
	
					end if;

					
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
	
	mem_a <= '1' & conv_std_logic_vector(row_addr*32 + col_addr, 10);	
	panel_A <= conv_std_logic_vector(15-row_half_addr, 4);
	
		case state is
		
			when setup =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
			when latch_pixel_lo1 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
			when latch_pixel_lo2 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';

			when latch_pixel_lo3 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';

			when latch_pixel_lo4 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
	
			when latch_pixel_hi =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';

			when latch_pixel_hi2 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';

			when latch_pixel_hi3 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
			when latch_pixel_hi4 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
			
			when shift_bit_out1 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '1';
				
			when shift_bit_out2 =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
			when post_shift_wait =>
				panel_blank	<= '1';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';	
				
			when send_latch =>
				panel_blank	<= '1';
				panel_latch	<= '1';
				panel_SCLK 	<= '0';
			
			when unblanking =>
				panel_blank	<= '0';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
	
			when hold_row =>
				panel_blank	<= '0';
				panel_latch	<= '0';
				panel_SCLK 	<= '0';
				
		end case;
	end process;
	
	
	
	
	

end LEDMatrix_Ctrl_arch;
