library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity classifier is
    Port(enable: in std_logic;
         x1: in std_logic_vector(7 downto 0);
         x2: in std_logic_vector(7 downto 0);
         w1: in signed(7 downto 0);
         w2: in signed(7 downto 0);
         w3: in signed(7 downto 0);
         clf: out std_logic
        );
end classifier;

architecture Behavioral of classifier is

signal multiplier_res1: signed(15 downto 0);
signal multiplier_res2: signed(15 downto 0);
signal result: signed(16 downto 0);

begin
    process(enable)
    begin
        if enable = '1' then
            multiplier_res1 <= signed(x1) * w1;
            multiplier_res2 <= signed(x2) * w2;
            
            result <= ('0' & multiplier_res1) + ('0' & multiplier_res2) + w3;
            if result > 0 then
                clf <= '1';
            else
                clf <= '0';
            end if;   
        end if;
    end process;
end Behavioral;
