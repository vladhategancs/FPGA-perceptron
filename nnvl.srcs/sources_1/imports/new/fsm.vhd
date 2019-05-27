
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is
    
    generic(dataset_size : integer:=5);

    Port(clk: in std_logic;
         rst: in std_logic;
         ready: in std_logic;
         training_ended: in std_logic;
         enable_dataset: out std_logic;
         enable_predictor: out std_logic;
         enable_classifier: out std_logic
        );
end fsm;

architecture Behavioral of fsm is
    type STATE_TYPE is (idle, data, train, classify);
    signal state : STATE_TYPE;

begin
    
    state_change:process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= idle;
            else
                case state is
                    when idle =>
                        if(ready = '1') then
                            state <= data;
                        else    
                            state <= idle; --TODO
                        end if;
                    when data =>
                        state <= train;
                    when train =>
                    if training_ended = '0' then
                        state <= data;
                    else
                        state <= classify;
                    end if;
                    when others => state <= idle;
                end case;
            end if;
        end if;
    end process;

    output_control: process(state)
    begin
        case state is
            when idle => enable_dataset <= '0'; enable_predictor <= '0'; enable_classifier <= '0'; --TODO
            when data => enable_dataset <= '1'; enable_predictor <= '0'; enable_classifier <= '0';-- TODO
            when train => enable_dataset <= '0'; enable_predictor <= '1'; enable_classifier <= '0';
            when classify => enable_dataset <= '0'; enable_predictor <= '0'; enable_classifier <= '1';
        end case;
    end process;

end Behavioral;
