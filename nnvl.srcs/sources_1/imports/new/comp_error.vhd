library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2019 02:37:00 AM
-- Design Name: 
-- Module Name: test_sign - Behavioral
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

entity comp_error is
    Port ( lbl : in STD_LOGIC;
           prediction: in signed(16 downto 0);
           err: out signed(16 downto 0));
end comp_error;

architecture Behavioral of comp_error is
signal res: signed(16 downto 0);
begin

    process(lbl, prediction)
    begin
        if lbl = '0' then
            res <= 0 - prediction;
        elsif lbl = '1' then
            res <= prediction;
        end if;
       
        if res > 0 then
            err <= res;
        else
            err <= "00000000000000000";
        end if;
    end process;

end Behavioral;
