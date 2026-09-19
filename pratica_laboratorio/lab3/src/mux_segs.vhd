library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_segs is
	Port (bin   : in std_logic_vector (15 downto 0);
	      clk : in STD_LOGIC;
	      an : out STD_LOGIC_VECTOR (3 downto 0);
	      seg : out STD_LOGIC_VECTOR (6 downto 0));
end mux_segs;

architecture Behavioral of mux_segs is
	component set_segs is
		Port (sw : in STD_LOGIC_VECTOR (3 downto 0);
		      seg : out STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component div_clock is
	Port (
	      clk : in STD_LOGIC;
	      clk_dividido : out std_logic);
    end component;
	
	signal counter: integer range 1 to 100_000 := 1;
	signal s_an, bcd_now, uhex, dhex, chex, mhex: STD_LOGIC_VECTOR (3 downto 0);
	signal seletor_display : integer range 1 to 4;
	signal clock_dividido: std_logic := '0';
	
begin
    
    uhex <= bin(3 downto 0);
    dhex <= bin(7 downto 4);
    chex <= bin(11 downto 8);
    mhex <= bin(15 downto 12);
    
	multiplexacao: process (clock_dividido)
	
	begin
		if rising_edge(clock_dividido) then
		
			case seletor_display is
			when 1 => s_an <= "1110"; bcd_now <= uhex;
			when 2 => s_an <= "1101"; bcd_now <= dhex;
			when 3 => s_an <= "1011"; bcd_now <= chex;
			when others => s_an <= "0111"; bcd_now <= mhex;
			end case;
			
			if seletor_display = 4 then seletor_display <= 1;
			else seletor_display <= seletor_display + 1;	
		    end if;
		    
		end if;
	
	end process;
    
	an <= s_an;
	dr_bcd: set_segs port map(
	    sw => bcd_now,
	    seg => seg);
    divisor : div_clock port map (
        clk => clk,
        clk_dividido => clock_dividido
    );

end Behavioral;
		