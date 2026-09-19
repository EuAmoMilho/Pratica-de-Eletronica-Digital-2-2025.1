----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/15/2025 09:31:42 PM
-- Design Name: 
-- Module Name: media_topmodule - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity media_topmodule is
    Port ( clk : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnC : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           led : out std_logic_vector (0 downto 0));
end media_topmodule;

architecture Behavioral of media_topmodule is

component dist_mem_gen_0 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END component;

component media_operacional is
    Port ( clk : in STD_LOGIC;
           M_dados : in STD_LOGIC_VECTOR (15 downto 0);
           i_ld : in STD_LOGIC;
           i_clr : in STD_LOGIC;
           s_ld : in STD_LOGIC;
           s_clr : in STD_LOGIC;
           a_ld : in STD_LOGIC;
           a_clr : in STD_LOGIC;
           media_ld : in STD_LOGIC;
           media_clr : in STD_LOGIC;
           
           y : out STD_LOGIC_VECTOR (15 downto 0);
           M_end : out STD_LOGIC_VECTOR (3 downto 0);
           i_lt16 : out STD_LOGIC);
           
end component;

component media_controle is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in std_logic;
           i_lt16 : in STD_LOGIC;
           i_ld : out STD_LOGIC;
           i_clr : out STD_LOGIC;
           s_ld : out STD_LOGIC;
           s_clr : out STD_LOGIC;
           a_ld : out STD_LOGIC;
           a_clr : out STD_LOGIC;
           media_ld : out STD_LOGIC;
           media_clr : out STD_LOGIC;
           ready : out STD_LOGIC);
           
end component;

component mux_segs is
	Port (bin   : in std_logic_vector (15 downto 0);
	      clk : in STD_LOGIC;
	      an : out STD_LOGIC_VECTOR (3 downto 0);
	      seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal i_lt16, i_ld, i_clr, s_ld, s_clr, a_ld, a_clr, media_ld, media_clr : std_logic := '0';
signal y, m_dados : std_logic_vector(15 downto 0);
signal m_end : std_logic_vector(3 downto 0);

begin
    unidade_de_display_topzera : mux_segs port map(
    bin => y,
    clk => clk,
    an => an,
    seg => seg
    
    );
    
    memoria_topzera : dist_mem_gen_0 port map(
    a => m_end,
    spo => m_dados
    );

    controle : media_controle port map(
    clk => clk,
    reset => btnL,
    start => btnC,
    i_lt16 => i_lt16,
    i_ld => i_ld,
    i_clr => i_clr,
    s_ld => s_ld,
    s_clr => s_clr,
    a_ld => a_ld,
    a_clr => a_clr,
    media_ld => media_ld,
    media_clr => media_clr,
    ready => led(0)
    );
    
    operacional : media_operacional port map(
    clk => clk,
    m_dados => m_dados,
    i_ld => i_ld,
    i_clr => i_clr,
    s_ld => s_ld,
    s_clr => s_clr,
    a_ld => a_ld,
    a_clr => a_clr,
    media_ld => media_ld,
    media_clr => media_clr,
    i_lt16 => i_lt16,
    y => y,
    m_end => m_end
    );

    

end Behavioral;
