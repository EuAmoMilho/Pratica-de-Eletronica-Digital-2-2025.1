----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2025 11:48:14 PM
-- Design Name: 
-- Module Name: fsm_110_101 - Behavioral
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

entity fsm_110_101 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC;
           z : out STD_LOGIC);
end fsm_110_101;

architecture Behavioral of fsm_110_101 is

signal Q : std_logic_vector(1 downto 0) := "00";
signal D : std_logic_vector(1 downto 0) := "00";

begin
    process(reset, clk)
    begin
        if reset = '1' then
            Q <= "00";
        elsif rising_edge(clk) then
            Q <= D;
        end if;
    end process;
    
    D(1) <= Q(0);
    D(0) <= A;
    Z <= Q(1) and (A XOR Q(0));

end Behavioral;
