library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_to_bcd is
    port (
        binary_in : in std_logic_vector(7 downto 0);
        tens      : out std_logic_vector(3 downto 0);
        uunits     : out std_logic_vector(3 downto 0)
    );
end entity;

-- algoritmo double-dabble: reserva N registradores de M bits para cada digito em bcd e realiza um deslocamento para a esquerda
-- a partir do registrador com o binario original. o deslocamento ocorre ate que um dos digitos ultrapasse o algarismo de deze-
-- na, centena ou unidade. quando o valor e ultrapassado, soma-se +3 ao numero da respectiva casa decimal. O numero de desloca-
-- mentos nao pode ultrapassar o numero de bits do binario original.

architecture behavioral of bin_to_bcd is
    signal shift_reg : std_logic_vector(15 downto 0); -- 8-bit binary + 2 numeros de 4 bits BCD = 16 bits
    signal i : integer := 0;
begin
    process(binary_in)
    begin
        -- Initialize shift register
        shift_reg <= (others => '0');
        shift_reg(15 downto 12) <= (others => '0');      -- BCD part
        shift_reg(7 downto 0) <= binary_in;              -- Binary input

        -- Perform Double Dabble algorithm
        for i in 0 to 7 loop
            if shift_reg(11 downto 8) > "0100" then
                shift_reg(11 downto 8) <= std_logic_vector(unsigned(shift_reg(11 downto 8)) + 3);
            end if;
            if shift_reg(15 downto 12) > "0100" then
                shift_reg(15 downto 12) <= std_logic_vector(unsigned(shift_reg(15 downto 12)) + 3);
            end if;
            shift_reg <= shift_reg(14 downto 0) & '0';  -- Shift left
        end loop;

        -- Output BCD digits
        uunits   <= shift_reg(11 downto 8);
        tens    <= shift_reg(15 downto 12);
    end process;
end architecture;