library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    
    generic(dataset_size : integer:=5);

    Port(clk: in std_logic;
         btn: in std_logic_vector(4 downto 0);
         sw: in std_logic_vector(15 downto 0);
         led: out std_logic_vector(15 downto 0);
         an: out std_logic_vector(3 downto 0);
         cat: out std_logic_vector(6 downto 0)
        );
end test_env;

architecture Behavioral of test_env is

    -- fsm signals
    signal enable_dataset: std_logic := '0';
    signal enable_predictor: std_logic := '0';
    
    -- epoch control signals
    signal number_of_epochs: std_logic_vector(9 downto 0) := (others => '0');
    signal sig_final_epoch: std_logic := '0';
    signal epoch_enable: std_logic := '0';
    
    -- weights
    signal weight1: signed(7 downto 0) := "00000010";
    signal weight2: signed(7 downto 0) := "00000010";
    signal weight3: signed(7 downto 0) := "00000010";

    -- memory signals
    signal data_sample_address: std_logic_vector(dataset_size downto 0) := (others => '0');
    signal x1,x2: std_logic_vector(7 downto 0);
    signal lbl: std_logic;


    -- predictor signals
    signal prediction: signed(16 downto 0);
        
    -- error
    signal err: signed(16 downto 0);

    --classification signals
    signal enable_classifier: std_logic;


    signal ready: std_logic := '0';
    
    signal wight: std_logic_vector(15 downto 0);
begin

    address_cnt:process(enable_dataset)
    begin            
        if enable_dataset = '1' then
            data_sample_address <= data_sample_address + '1';
            if data_sample_address = "111100" then
                data_sample_address <= "000000";
                epoch_enable <= '1';
            else
                epoch_enable <= '0';
            end if;
        end if;
    end process;

    epochs_cnt: process(epoch_enable)
    begin
        if(sig_final_epoch /= '1') then
            if epoch_enable = '1' then
                number_of_epochs <= number_of_epochs + '1';
            end if;
            if number_of_epochs = "1111101000" then
                sig_final_epoch <= '1';
            end if;
        end if;
    end process;

start_fsm: process(btn(1), sig_final_epoch)
begin
    if btn(1) = '1' then
        ready <= '1';
    end if;

    if sig_final_epoch = '1' then
        ready <= '0';
    end if;
end process;

fsm: entity WORK.fsm port map(clk => clk , rst => btn(0), ready => ready,training_ended => sig_final_epoch, enable_dataset => enable_dataset, enable_predictor => enable_predictor, enable_classifier => enable_classifier);

dataset: entity WORK.ROM port map(enable => enable_dataset , address => data_sample_address, data1 => x1, data2 => x2, lbl => lbl);

predictor: entity WORK.predictor port map(enable => enable_predictor, x1 => x1, x2 => x2, w1 => weight1, w2 => weight2, w3 => weight3, res => prediction);

error_component: entity WORK.comp_error port map(lbl => lbl, prediction => prediction, err => err);

classifier_component: entity WORK.classifier port map(enable => enable_classifier, x1 => sw(7 downto 0), x2 => sw(15 downto 8), w1 => weight1, w2 => weight2, w3 => weight3, clf => led(0));

--ssd: entity WORK.ssd port map(clk => clk, digits => std_logic_vector(err(15 downto 0)), an => an, cat => cat);

wight <= std_logic_vector(weight1) & std_logic_vector(weight2);
ssd: entity WORK.ssd port map(clk => clk, digits => wight, an => an, cat => cat);



update_weights: process(prediction,lbl)
    begin
        if prediction < 0 and lbl = '1' then
            weight1 <= (weight1 + signed(x1))/10;
            weight2 <= (weight1 + signed(x2))/10;
            weight3 <= weight3 + 1;
        elsif prediction < 0 and lbl = '0' then
            NULL;    
        elsif prediction > 0 and lbl ='1' then
            NULL;
        elsif prediction > 0 and lbl = '0' then
            weight1 <= (weight1 - signed(x1))/10;
            weight2 <= (weight1 - signed(x2))/10;
            weight3 <= weight3 - 1;
        else
            NULL;
        end if;
            
    end process;

end Behavioral;
