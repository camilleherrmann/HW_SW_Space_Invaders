library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_div is
     port(clk, rst: in std_logic;
     clk25: out std_logic);
end clk_div;

architecture archi of clk_div is
signal q_int: std_logic_vector(1 downto 0);
--signal clk_buffer: std_logic;

begin
  process(rst, clk, q_int)
  
  begin
  if rst='1' 
    then q_int <= (others => '0');
  elsif clk'event and clk='1' then
         q_int <= q_int + 1;
  end if;


 clk25 <= q_int(1);
 end process;
end archi;
