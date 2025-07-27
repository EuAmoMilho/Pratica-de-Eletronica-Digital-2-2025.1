----------------------------------------------------------------------------------
-- Company: FCTE - UnB
-- Engineer: Noboru Luiz W. Monteiro
-- 
-- Create Date: 06/15/2025 09:31:42 PM
-- Design Name: FSM of ROM RTL
-- Module Name: media_operacional - Behavioral
-- Project Name: Media da Memoria
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

entity media_operacional is
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
           
end media_operacional;

architecture Behavioral of media_operacional is

signal s, a, media : std_logic_vector(15 downto 0) := (others => '0');
signal i : std_logic_vector(3 downto 0) := (others => '0');

begin

    process(clk, i_clr, i_ld)
    begin
        if i_clr = '1' then
            i <= (others => '0');
        elsif rising_edge(clk) then
            if i_ld = '1' then
                i <= std_logic_vector(unsigned(i) + 1);
            end if;
        end if;
        
    end process;
    
    process(clk, s_clr, s_ld)
    begin
        if s_clr = '1' then
            s <= (others => '0');
        elsif rising_edge(clk) then
            if s_ld = '1' then
                s <= std_logic_vector(unsigned(s) + unsigned(a));
            end if;
        end if;
        
    end process;

    process(clk, a_clr, a_ld)
    begin
        if a_clr = '1' then
            a <= (others => '0');
        elsif rising_edge(clk) then
            if a_ld = '1' then
                a <= m_dados;
            end if;
        end if;
        
    end process;

    process(clk, media_clr, media_ld)
    begin
        if media_clr = '1' then
            media <= (others => '0');
        elsif rising_edge(clk) then
            if media_ld = '1' then
                media <= "0000" & s(15 downto 4);
            end if;
        end if;
        
    end process;

    m_end <= i;
    i_lt16 <= '1' when i < "1111" else '0';
    y <= media;
    
end Behavioral;
