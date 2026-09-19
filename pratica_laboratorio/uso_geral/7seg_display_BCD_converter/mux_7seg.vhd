library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_7seg is
	Port (bin_s   : in std_logic_vector (7 downto 0);
	      clk : in STD_LOGIC;
	      start : in std_logic;
	      an : out STD_LOGIC_VECTOR (3 downto 0);
	      seg : out STD_LOGIC_VECTOR (6 downto 0);
	      dp : out STD_LOGIC);
end mux_7seg;

architecture Behavioral of mux_7seg is
	component set_segs is
		Port (sw : in STD_LOGIC_VECTOR (3 downto 0);
		      seg : out STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component div_clock is
	Port (
	      clk : in STD_LOGIC;
	      clk_dividido : out std_logic);
    end component;
	
	component binto_bcd is
    port (
        clk       : in std_logic;
        binary_in : in std_logic_vector(7 downto 0);
        start     : in std_logic;
        done      : out std_logic;
        cents     : out std_logic_vector(3 downto 0);
        tens      : out std_logic_vector(3 downto 0);
        uunits     : out std_logic_vector(3 downto 0)
    );
    end component;
	
	signal counter: integer range 1 to 100_000 := 1;
	signal s_an, bcd_now, bcd_cs, bcd_ds, bcd_us : STD_LOGIC_VECTOR (3 downto 0);
	signal seletor_display : integer range 1 to 3;
	signal clock_dividido, done_s : std_logic := '0';
	
begin
    
	multiplexacao: process (clock_dividido)
	
	begin
		if rising_edge(clock_dividido) then
		
			case seletor_display is
			when 1 => s_an <= "1110"; bcd_now <= bcd_us;
			when 2 => s_an <= "1101"; bcd_now <= bcd_ds;
			when others => s_an <= "1011"; bcd_now <= bcd_cs;
			
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
    conversor_s : binto_bcd port map(
        clk => clk,
        start => start,
        done => done_s,
        binary_in => bin_s,
        cents => bcd_cs,
        tens => bcd_ds,
        uunits => bcd_us
    );

end Behavioral;
		