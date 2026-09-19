----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/14/2025 10:27:13 AM
-- Design Name: 
-- Module Name: toplevel - Behavioral
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

entity toplevel is
    Port ( clk : in std_logic; 
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end toplevel;

architecture Behavioral of toplevel is

component core_padrao is
    Port ( clk : in std_logic;
           direcao : in STD_LOGIC_VECTOR (0 downto 0);
           padrao : in STD_LOGIC_VECTOR (1 downto 0);
           leds : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component core_soma is
    Port ( clk : in std_logic;
           parc1 : in STD_LOGIC_VECTOR (7 downto 0);
           parc2 : in STD_LOGIC_VECTOR (7 downto 0);
           soma : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component seletor_clk is
    Port ( clk : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           clk_div : out STD_LOGIC);
end component;

component mux_7seg is
	Port (bin_s   : in std_logic_vector (7 downto 0);
	      clk : in STD_LOGIC;
	      start : in std_logic;
	      an : out STD_LOGIC_VECTOR (3 downto 0);
	      seg : out STD_LOGIC_VECTOR (6 downto 0);
	      dp : out STD_LOGIC);
end component;

signal soma : std_logic_vector(7 downto 0);
signal clk_div : std_logic;

begin

    core1 : core_soma Port map(
        clk => clk,
        parc1 => sw(7 downto 0),
        parc2 => sw(15 downto 8),
        soma => soma
            
    );
    
    core2 : core_padrao Port map(
        clk => clk_div,
        direcao => sw(10 downto 10),
        padrao => sw(9 downto 8),
        leds => led
    
    );
    
    clk_sel : seletor_clk Port map(
        clk => clk,
        sel => sw(12 downto 11),
        clk_div => clk_div
    
    );
    
    unidade_de_display_incrivel : mux_7seg Port map(
        clk => clk,
        bin_s => soma,
        start => '1',
        an => an,
        seg => seg,
        dp => open
    
    );

end Behavioral;
