----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2020 18:37:48
-- Design Name: 
-- Module Name: hex7seg - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity hex7seg is
  port(
    hex: in std_logic_vector(7 downto 0);
    a_to_g: out std_logic_vector(0 to 6));
end hex7seg;

architecture archi of hex7seg is
begin
  process (hex)
    begin
      case hex is
      when x"00" => a_to_g <="0000001"; -- 0 -- NB: O = ON , 1 = OFF
      when x"01" => a_to_g <="1001111"; -- 1
      when x"02" => a_to_g <="0010010"; -- 2
      when x"03" => a_to_g <="0000110"; -- 3 
      when x"04" => a_to_g <="1001100"; -- 4
      when x"05" => a_to_g <="0100100"; -- 5
      when x"06" => a_to_g <="0100000"; -- 6 
      when x"07" => a_to_g <="0001101"; -- 7
      when x"08" => a_to_g <="0000000"; -- 8
      when x"09" => a_to_g <="0000100"; -- 9
      when x"0A" => a_to_g <="0001000"; -- A
      when x"0B" => a_to_g <="1100000"; -- b
      when x"0C" => a_to_g <="0110001"; -- C
      when x"0D" => a_to_g <="1000010"; -- d
      when x"0E" => a_to_g <="0110000"; -- E
      when x"0F" => a_to_g <="0111000"; -- F
      when x"10" => a_to_g <="0100001"; -- G
      when x"11" => a_to_g <="1001000"; -- H
      when x"12" => a_to_g <="1001111"; -- I
      when x"13" => a_to_g <="1000011"; -- J
      when others => a_to_g <="1111111"; -- " "
    end case;    
  end process;

end archi;  
