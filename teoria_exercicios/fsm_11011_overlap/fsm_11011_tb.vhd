----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2025 04:54:31 PM
-- Design Name: 
-- Module Name: fsm_11011_tb - Behavioral
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

entity fsm_11011_tb is
--  Port ( );
end fsm_11011_tb;

architecture Behavioral of fsm_11011_tb is

    component fsm_11011 is
        Port( clk: in std_logic;
              reset: in std_logic;
              a: in std_logic;
              z: out std_logic);
    end component;
    
    signal clk, reset, a, z : std_logic := '0';

begin

uut: fsm_11011 port map(
    clk => clk,
    reset => reset,
    a => a,
    z => z);
    
clk <= not clk after 5 ns;
reset <= '0', '1' after 15 ns, '0' after 21 ns;
a <= '0', '1' after 10 ns, '0' after 40 ns, '1' after 50 ns, '0' after 70 ns; 

end Behavioral;
