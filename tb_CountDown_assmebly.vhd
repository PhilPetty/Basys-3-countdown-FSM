library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity tb_countdown is
end tb_countdown;

architecture behavior of tb_countdown is

	constant fpga_Clock 		: time := 10 ns;
	constant clksper_cycle		: integer := 100000000;
	
	signal tb_num_disp				:std_logic_vector(7 downto 0);
	signal tb_rst					:std_logic;
	signal tb_active				:std_logic;
	signal tb_clk					:std_logic := '0';
	begin
	-- instantiate
	
	countdown_inst : entity work.countdown
		generic map(
			g_clk		=> clksper_cycle
			)
		port map(
			i_clk		=> tb_clk,
			num_disp	=> tb_num_disp,
			i_rst		=> tb_rst,
			o_active	=> tb_active
			);
			
	tb_clk <= not tb_clk after fpga_Clock/2;
	tb_rst <= '0', '1' after 2 us;
	process is
	begin
	wait until tb_rst = '1';
	--Tell the UART to send a command. (USE TX)
	wait until rising_edge(tb_clk);				-- wait to clock signals before simulations
    wait until rising_edge(tb_clk);
	
		tb_active <= '0';
		
	end process;
   
end behavior;