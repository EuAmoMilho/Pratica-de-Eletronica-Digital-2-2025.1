----------------------------------------------------------------------------------
-- Company: FCTE - UnB
-- Engineer: Noboru L. W. Monteiro
-- 
-- Create Date: 06/10/2025 07:36:30 PM
-- Design Name: Maquina de Refri RTL
-- Module Name: refri_operacional - Behavioral
-- Project Name: Operacional da Maquina de Refri
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
use IEEE.NUMERIC_STD.ALL;


entity refri_operacional is
    Port ( clk : in STD_LOGIC;
           tot_ld : in STD_LOGIC;
           tot_clr : in STD_LOGIC;
           s : in STD_LOGIC_VECTOR (7 downto 0);
           a : in STD_LOGIC_VECTOR (7 downto 0);
           tot_lt_s : out STD_LOGIC);
end refri_operacional;

architecture Behavioral of refri_operacional is

    signal tot : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk, tot_clr, tot_ld)
    begin
        if tot_clr = '1' then
            tot <= (others => '0');
        elsif rising_edge(clk) then
            if tot_ld = '1' then
                tot <= std_logic_vector(unsigned(tot) + unsigned(a));
            end if;
        end if;
    end process;

    tot_lt_s <= '1' when tot < s else '0';

end Behavioral;
