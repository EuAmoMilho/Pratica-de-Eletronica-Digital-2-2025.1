----------------------------------------------------------------------------------
-- Company: FCTE - UnB
-- Engineer: Noboru L. W. Monteiro
-- 
-- Create Date: 06/10/2025 07:36:30 PM
-- Design Name: Maquina de Refri RTL
-- Module Name: refri_top_module - Behavioral
-- Project Name: Top Module da Maquina de Refri
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

entity refri_top_module is
    Port ( clk : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnC : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (2 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end refri_top_module;

architecture Behavioral of refri_top_module is

    component refri_controle is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           c : in STD_LOGIC;
           tot_lt_s : in STD_LOGIC;
           tot_clr : out STD_LOGIC;
           tot_ld : out STD_LOGIC;
           d : out STD_LOGIC;
           mostrar_estado : out STD_LOGIC_VECTOR (1 downto 0));
    end component;
    
    component refri_operacional is
    Port ( clk : in STD_LOGIC;
           tot_ld : in STD_LOGIC;
           tot_clr : in STD_LOGIC;
           s : in STD_LOGIC_VECTOR (7 downto 0);
           a : in STD_LOGIC_VECTOR (7 downto 0);
           tot_lt_s : out STD_LOGIC);
    end component;

    component mux_7seg is
	Port (bin_a   : in std_logic_vector (7 downto 0);
	      bin_s   : in std_logic_vector (7 downto 0);
	      clk : in STD_LOGIC;
	      rst : in Std_logic;
	      start : in std_logic;
	      an : out STD_LOGIC_VECTOR (3 downto 0);
	      seg : out STD_LOGIC_VECTOR (6 downto 0);
	      dp : out STD_LOGIC);
    end component;

    signal tot_ld, tot_clr, tot_lt_s: std_logic := '0';
    signal a, s : std_logic_vector(7 downto 0) := (others => '0');
    
begin

    s <= sw(15 downto 8);
    a <= sw(7 downto 0);

    op_block : refri_operacional port map(
    clk => btnR,
    tot_ld => tot_ld,
    tot_clr => tot_clr,
    s => sw(15 downto 8),
    a => sw(7 downto 0),
    tot_lt_s => tot_lt_s
    );
    
    ctrl_block : refri_controle port map(
    clk => btnR,
    reset => btnL,
    tot_ld => tot_ld,
    tot_clr => tot_clr,
    tot_lt_s => tot_lt_s,
    c => btnC,
    d => led(0),
    mostrar_estado => led(2 downto 1)
    );

    unidade_de_display_incrivel : mux_7seg port map(
    clk => clk,
    rst => btnL,
    start =>'1',
    an => an,
    seg => seg,
    dp => open,
    bin_a => a,
    bin_s => s 
    );

end Behavioral;
