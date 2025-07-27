----------------------------------------------------------------------------------
-- Company: FCTE/UnB
-- Engineer: Noboru Monteiro
-- 
-- Create Date: 04/14/2025 04:23:03 PM
-- Design Name: 
-- Module Name: fsm_11011 - Behavioral
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

entity fsm_11011 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC;
           z : out STD_LOGIC);
end fsm_11011;

architecture Behavioral of fsm_11011 is

signal Q : std_logic_vector (2 downto 0) := "000";
signal D : std_logic_vector (2 downto 0) := "000";

begin
    process(clk, reset)
    begin
        if reset = '1' then
            Q <= "000";
        
        elsif rising_edge(clk) then
            Q <= D;
        end if;
    end process;

D(2) <= A and (NOT Q(2)) and Q(1) and (NOT Q(0));
D(1) <= (A and Q(1)) OR (A and Q(0)) OR (Q(1) and Q(0));
D(0) <= (A and Q(2)) OR (A and Q(0)) OR (A and (NOT Q(1)));

Z <= A and Q(2) and Q(1) and (NOT Q(0));

end Behavioral;
