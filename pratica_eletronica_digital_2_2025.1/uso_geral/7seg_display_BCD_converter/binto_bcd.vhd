library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binto_bcd is
    port (
        clk       : in std_logic;
        binary_in : in std_logic_vector(7 downto 0);
        start     : in std_logic;
        done      : out std_logic;
        cents     : out std_logic_vector(3 downto 0);
        tens      : out std_logic_vector(3 downto 0);
        uunits    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of binto_bcd is
    type state_type is (idle, prepare, add, shift, finish);
    signal state     : state_type := idle;
    signal shift_reg : std_logic_vector(19 downto 0) := (others => '0');
    signal count     : integer range 0 to 8 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when idle =>
                    done <= '0';
                    if start = '1' then
                        state <= prepare;
                    end if;

                when prepare =>
                    shift_reg <= (others => '0');
                    shift_reg(7 downto 0) <= binary_in;
                    count <= 0;
                    state <= add;

                when add =>
                    -- Add 3 if necessary
                    if unsigned(shift_reg(11 downto 8)) > 4 then
                        shift_reg(11 downto 8) <= std_logic_vector(unsigned(shift_reg(11 downto 8)) + 3);
                    end if;
                    if unsigned(shift_reg(15 downto 12)) > 4 then
                        shift_reg(15 downto 12) <= std_logic_vector(unsigned(shift_reg(15 downto 12)) + 3);
                    end if;
                    if unsigned(shift_reg(19 downto 16)) > 4 then
                        shift_reg(19 downto 16) <= std_logic_vector(unsigned(shift_reg(19 downto 16)) + 3);
                    end if;
                    
                    state <= shift;

                when shift =>
                    -- Shift left
                    shift_reg <= shift_reg(18 downto 0) & '0';
                    count <= count + 1;
                    if count = 7 then
                        state <= finish;
                    else 
                        state <= add;
                    end if;

                when finish =>
                    cents    <= shift_reg(19 downto 16);
                    tens     <= shift_reg(15 downto 12);
                    uunits   <= shift_reg(11 downto 8);
                    done     <= '1';
                    state    <= idle;
            end case;
        end if;
    end process;
end architecture;
