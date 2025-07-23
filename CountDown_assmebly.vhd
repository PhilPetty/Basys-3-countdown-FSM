library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
--Setting Variables
entity countdown is
	generic(
	-- add generic clock
	g_clk			: integer := 100000000;
	g_done_clk		: integer := 1000;
	g_state_count	: integer := 100000;
	g_flash_count	: integer := 100000000
	);
	port(
	--INPUTS
	i_rst		: in std_logic;
	i_clk		: in std_logic;
	
	--syncRst		: in std_logic;
	--i_start	: in std_logic;
	--OUTPUTS (figure out later)
	o_active	: out std_logic;
	AN0			: out std_logic;
	AN1			: out std_logic;
	AN2			: out std_logic;
	AN3			: out std_logic;
	num_disp	: out std_logic_vector(7 downto 0)
	
	
								 --11111111
	--num9		: out std_logic; --00011001
	--num8		: out std_logic; --00000001
	--num7		: out std_logic; --00011011
	--num6		: out std_logic; --01000001
	--num5		: out std_logic; --01001001
	--num4		: out std_logic; --10011001
	--num3		: out std_logic; --00001101
	--num2		: out std_logic; --00100101
	--num1		: out std_logic; --10011111
	--num0		: out std_logic  --00000011
	--o_digital	: out std_logic;
	);
end countdown;

architecture RTL of countdown is
	type count_main is (num9, num8, num7, num6, num5, num4, num3, num2, num1, num0, stop);
	type done_main is (start, letter_d, letter_o, letter_n, letter_e, check, flash_state);
	--signal r_digi_vec	: integer 9 downto 0 ;= 0;
	signal r_done_state		: done_main := start;
	signal r_count_state 	: count_main := num9;
	signal r_clk_counter 	: integer range 0 to g_clk - 1 := 0;
	signal done_clk_counter : integer range 0 to g_done_clk - 1 := 0;
	signal done_state_count : integer range 0 to g_state_count - 1 := 0;
	signal flash_counter	: integer range 0 to g_flash_count - 1 := 0;
	signal syncRst			: std_logic := '0';
	--instantiate
	
component rstDualRankSync is generic ( asyncRstAssertVal : std_logic := '0');

    port (

        clk                     : in  std_logic;

        asyncRst                : in  std_logic;

        syncRst                 : out std_logic );

    end component;
 
begin
rstDualRankSync_i   : rstDualRankSync        generic map (

            asyncRstAssertVal    => '1')

        port map (

            clk             => i_clk,

            asyncRst        => i_rst,

            syncRst         => syncRst

        );

	p_countdown : process (i_clk)
	begin
		if rising_edge (i_clk) then
		
		--Reset
			if 	syncRst = '0' then
				num_disp		<= "11111111";
				o_active 		<= '1';
				r_count_state 	<= num9;
			else
				o_active		<= '0';
				AN0				<= '0';
				AN1				<= '1';
				AN2				<= '1';
				AN3				<= '1';
				
				case r_count_state is
					when num9 =>
						
						num_disp 	<= "00011001";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num8; 
						end if;
					when num8 =>
						num_disp	<= "00000001";		
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num7;
						end if;
					when num7 =>
						num_disp	<= "00011011";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num6;
						end if;
					when num6 =>
						num_disp	<= "01000001";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num5;
						end if;
					when num5 =>
						num_disp	<= "01001001";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num4;
						end if;
					when num4 =>
						num_disp	<= "10011001";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num3;
						end if;
					when num3 =>
						num_disp	<= "00001101";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num2;
						end if;
					when num2 =>
						num_disp	<= "00100101";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num1;
						end if;
					when num1 =>
						num_disp	<= "10011111";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state 	<= num0;
							
						end if;
					when num0 =>
						num_disp	<= "00000011";
						if 	r_clk_counter < g_clk - 1 then
							r_clk_counter <= r_clk_counter + 1;
						else
							r_clk_counter <= 0;
							r_count_state	<= stop;
						end if;
						
					when stop =>
					--Done State machine
							case r_done_state is
								
								when start =>
									--if 	done_state_count	< g_state_count - 1 then
										r_done_state		<= letter_d;
									--end if;
								when letter_d =>
									AN0				<= '1';
									AN1				<= '1';
									AN2				<= '1';
									AN3				<= '0';	--on
									num_disp		<=	"10000101";
										if	done_clk_counter < g_done_clk - 1 then
											done_clk_counter <= done_clk_counter + 1;
										else
											done_clk_counter	<= 0;
											r_done_state		<= letter_o;
										end if;
										
								when letter_o =>
									AN0				<= '1';
									AN1				<= '1';
									AN2				<= '0';--on	
									AN3				<= '1';
									num_disp		<= "00000011";
										if	done_clk_counter < g_done_clk - 1 then
											done_clk_counter <= done_clk_counter + 1;
										else
											done_clk_counter	<= 0;
											r_done_state		<= letter_n;
										end if;
							
								when letter_n =>
									AN0				<= '1';
									AN1				<= '0';	--on
									AN2				<= '1';
									AN3				<= '1';
									num_disp		<= "00010011";
										if	done_clk_counter < g_done_clk - 1 then
											done_clk_counter <= done_clk_counter + 1;
										else
											done_clk_counter	<= 0;
											r_done_state		<= letter_e;
										end if;
								
								when letter_e =>
									AN0				<= '0';	--on
									AN1				<= '1';
									AN2				<= '1';
									AN3				<= '1';
									num_disp		<= "00100001";
										if			done_clk_counter < g_done_clk - 1 then
													done_clk_counter <= done_clk_counter + 1;										
										else
													done_clk_counter	<= 0;
													r_done_state	<= check;
													
										end if;			
								
								when check =>
								
											if		done_state_count < g_state_count - 1 then
													done_state_count <= done_state_count + 1;
													r_done_state	<= start;
																						
											else
													done_state_count <= 0;
													r_done_state	<= flash_state;
										end if;
										
										
										--flash
								when flash_state =>
									AN0				<= '1';
									AN1				<= '1';
									AN2				<= '1';
									AN3				<= '1';
									
										if 	flash_counter < g_flash_count - 1 then
											flash_counter <= flash_counter + 1;
										else
											flash_counter	<= 0;
											r_done_state	<= start;
										end if;
							end case;
							--done_state_count <= done_state_count + 1;
							
						
							
				end case;
			end if;	
		end if;
	end process;
end RTL;
