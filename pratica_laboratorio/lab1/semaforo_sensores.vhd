----------------------------------------------------------------------------------
-- Company: FCTE - UnB
-- Engineer: Noboru Luiz W. Monteiro
-- 
-- Create Date: 05/02/2025 01:55:18 AM
-- Design Name: 
-- Module Name: semaforo_sensores - Behavioral
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

entity semaforo_sensores is
    Port ( btnR : in STD_LOGIC;
           btnC : in STD_LOGIC; --reset
           sw : in STD_LOGIC_VECTOR (5 downto 0); --sensores sw(1 a 6)
           led : out STD_LOGIC_VECTOR (3 downto 0);--saídas C1, C2, S1, S2, respectivamente
           mostrar_estado : out STD_LOGIC_VECTOR (2 downto 0)); 
end semaforo_sensores;

architecture Behavioral of semaforo_sensores is

type tipo_estado is (e0, e1, e2, e3, e4, e5, e6);
signal estado_atual, proximo_estado : tipo_estado := e0;

begin

--processo sequencial sincrono para registro de estado
    process(btnR, btnC)
    begin
        if btnC = '1' then
            estado_atual <= e0;
        elsif rising_edge(btnR) then
            estado_atual <= proximo_estado;
        end if;
    end proCESs;
    
    --processo assíncrono para transição de estado
    process(estado_atual, sw(5 downto 0))
    begin
        case estado_atual is
            when e0 =>
            	mostrar_estado <= "000";
                if sw = "000001" then proximo_estado <= e1;
                elsif sw = "010001" then proximo_estado <= e1;
                elsif sw = "010000" then proximo_estado <= e5;
                else proximo_estado <= e0;
                end if;
            when e1 =>
            	mostrar_estado <= "001";
                if sw(0) = '0' then proximo_estado <= e2;
                else proximo_estado <= e1;
                end if;
            when e2 =>
            	mostrar_estado <= "010";
                if sw(1) = '1' then proximo_estado <= e3;
                elsif sw(5) = '1' then proximo_estado <= e0;
                else proximo_estado <= e2;
                end if;
            when e3 =>
            	mostrar_estado <= "011";
                if sw(2) = '1' then proximo_estado <= e4;            
                else proximo_estado <= e3;
                end if;
            when e4 =>
            	mostrar_estado <= "100";
                if sw(3) = '1' then proximo_estado <= e0;
                elsif sw(2) = '1' then proximo_estado <= e6;
                else proximo_estado <= e4;
                end if;   
            when e5 =>
            	mostrar_estado <= "101";
                if sw(4) = '0' then proximo_estado <= e4;
                else proximo_estado <= e5;
                end if;
            when e6 =>
            	mostrar_estado <= "110";
                if sw(1) = '1' then proximo_estado <= e2;
                else proximo_estado <= e6;
                end if;
            when others => proximo_estado <= e3;
        end case;
    end process;

    --processo para a saída
    process(estado_atual, sw(5 downto 0))
    begin
        case estado_atual is
            when e0 =>
                if sw = "000001" then led <= "1010";
                elsif sw = "010001" then led <= "1010";
                elsif sw = "010000" then led <= "0101";
                else led <= "0000";
                end if;
            when e1 =>
                if sw = "000001" then led <= "1010";
                else led <= "1000";
                end if;
            when e2 =>
                if (sw(1) OR sw(5)) = '1' then led <= "0000";
                else led <= "1000";
                end if;
            when e3 =>
                if sw(2) = '1' then led <= "0100";
                else led <= "0000";
                end if;
            when e4 =>
                if (sw(3) OR sw(2)) = '1' then led <= "0000";
                else led <= "0100";
                end if;   
            when e5 =>
                if sw = "010000" then led <= "0101";
                else led <= "0100";
                end if;
            when e6 =>
                if sw(1) = '1' then led <= "1000";
                else led <= "0000";
                end if;
            when others => led <= "0000";
        end case;
    end process;
    
end Behavioral;
