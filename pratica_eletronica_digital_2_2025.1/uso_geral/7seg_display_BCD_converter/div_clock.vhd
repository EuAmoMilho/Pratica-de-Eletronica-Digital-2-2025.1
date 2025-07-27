library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_clock is
	Port (
	      clk : in STD_LOGIC;
	      clk_dividido : out std_logic);
end div_clock;

architecture Behavioral of div_clock is
	component bcd_7seg is
		Port (sw : in STD_LOGIC_VECTOR (3 downto 0);
		      seg : out STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	signal counter: integer range 1 to 100_000 := 1;
	signal s_an, bcd_now : STD_LOGIC_VECTOR (3 downto 0);
	signal seletor_display : integer range 1 to 4;
	signal clk_temporario : std_logic := '0';
	
begin
    
	divisor_clk: process(clk)
	begin
		if rising_edge(clk) then
		
			if counter = 100_000 then
				counter <= 1;
				clk_temporario <= not clk_temporario;
				
			else
				counter <= counter + 1;
				
			end if;
		end if;
	end process;
	
	clk_dividido <= clk_temporario;

end Behavioral;