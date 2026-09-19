----------------------------------------------------------------------------------
-- Company: FCTE - UnB
-- Engineer: Noboru L. W. Monteiro
-- 
-- Create Date: 06/10/2025 07:36:30 PM
-- Design Name: Maquina de Refri RTL
-- Module Name: refri_controle - Behavioral
-- Project Name: FSM da Maquina de Refri
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

entity refri_controle is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           c : in STD_LOGIC;
           tot_lt_s : in STD_LOGIC;
           tot_clr : out STD_LOGIC;
           tot_ld : out STD_LOGIC;
           d : out STD_LOGIC;
           mostrar_estado : out STD_LOGIC_VECTOR (1 downto 0));
end refri_controle;

architecture Behavioral of refri_controle is

type estado is (inicio, esperar, somar, fornecer);
signal estado_atual, proximo_estado : estado := inicio;

begin

--processo para registrar estado
process(clk, reset)
begin

    if reset = '1' then
        estado_atual <= inicio;
    elsif rising_edge(clk) then
        estado_atual <= proximo_estado;
    end if;
end process;

--processo para transicao de estados
process(estado_atual, tot_lt_s, c)
begin

    case estado_atual is
        when inicio =>
            proximo_estado <= esperar;
            
        when esperar =>
            if c = '0' and tot_lt_s = '0' then
                proximo_estado <= fornecer;
                
            elsif c = '1' then
                proximo_estado <= somar;
                
            else
                proximo_estado <= esperar;
                
            end if;
            
        when somar =>
            proximo_estado <= esperar;
            
        when fornecer =>
            proximo_estado <= inicio;
            
    end case;
end process;

--processo para saidas
process(estado_atual)
begin

    case estado_atual is
    
        when inicio =>
            tot_clr <= '1';
           tot_ld <= '0';
           d <= '0';
           mostrar_estado <= "00"; 
           
        when esperar =>
            tot_clr <= '0';
            tot_ld <= '0';
            d <= '0';
            mostrar_estado <= "01";
            
        when somar =>
            tot_clr <= '0';
            tot_ld <= '1';
            d <= '0';
            mostrar_estado <= "10";
            
        when fornecer =>
            tot_clr <= '0';
            tot_ld <= '0';
            d <= '1';
            mostrar_estado <= "11";
            
    end case;
end process;


end Behavioral;
