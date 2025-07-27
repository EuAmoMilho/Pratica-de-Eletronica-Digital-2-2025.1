----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/15/2025 09:31:42 PM
-- Design Name: 
-- Module Name: media_controle - Behavioral
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

entity media_controle is
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
end media_controle;

architecture Behavioral of media_controle is

type estado is (e0, e1, e2, e3);
signal estado_atual, proximo_estado : estado := e0;

begin

    --processo para registro de estados
    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual <= e0;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;

    end process;

    --processo para transiçao de estados
    process(estado_atual, start, i_lt16)
    begin
        case estado_atual is
            when e0 => 
                if start = '1' then proximo_estado <= e1;
                else proximo_estado <= e0;
                end if;
            when e1 =>
                proximo_estado <= e2;
            when e2 =>
                if i_lt16 = '0' then proximo_estado <= e3;
                else proximo_estado <= e1;
                end if;
            when e3 =>
                proximo_estado <= e0;
        end case;
    end process;

    --processo para saidas
    process(estado_atual)
    begin
        case estado_atual is
            when e0 =>
                i_ld <= '0';
                i_clr <= '1';
                s_ld <= '0';
                s_clr <= '1';
                a_ld <= '0';
                a_clr <= '1';
                media_ld <= '0';
                media_clr <= '0';
                ready <= '1';
                
            when e1 =>
                i_ld <= '0';
                i_clr <= '0';
                s_ld <= '0';
                s_clr <= '0';
                a_ld <= '1';
                a_clr <= '0';
                media_ld <= '0';
                media_clr <= '1';
                ready <= '0';
                
            when e2 =>
                i_ld <= '1';
                i_clr <= '0';
                s_ld <= '1';
                s_clr <= '0';
                a_ld <= '0';
                a_clr <= '0';
                media_ld <= '0';
                media_clr <= '0';
                ready <= '0';
            
            when e3 =>
                i_ld <= '0';
                i_clr <= '0';
                s_ld <= '0';
                s_clr <= '0';
                a_ld <= '0';
                a_clr <= '0';
                media_ld <= '1';
                media_clr <= '0';
                ready <= '1';
        end case;
    end process;
    
end Behavioral;
