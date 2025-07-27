----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/14/2025 11:22:47 AM
-- Design Name: 
-- Module Name: seletor_clk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seletor_clk is
    Port ( clk : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           clk_div : out STD_LOGIC);
end seletor_clk;

architecture Behavioral of seletor_clk is

    signal counter: integer range 1 to 100_000_000 := 1;
	signal clk_temporario : std_logic := '0';

begin

    process(clk, sel)
	begin
		if rising_edge(clk) then
            case sel is
                when "00" =>
                    if counter = 1250000 then
                        counter <= 1;
                        clk_temporario <= not clk_temporario;
                        
                    else
                        counter <= counter + 1;
                        
                    end if;
                when "01" =>
                    if counter = 625000 then
                        counter <= 1;
                        clk_temporario <= not clk_temporario;
                        
                    else
                        counter <= counter + 1;
                        
                    end if;
                when "10" =>
                    if counter = 312500 then
                        counter <= 1;
                        clk_temporario <= not clk_temporario;
                        
                    else
                        counter <= counter + 1;
                        
                    end if;
                when others =>
                    if counter = 156_250 then
                        counter <= 1;
                        clk_temporario <= not clk_temporario;
                        
                    else
                        counter <= counter + 1;
                        
                    end if;
            end case;
		end if;
	end process;
	
	clk_div <= clk_temporario;

end Behavioral;
