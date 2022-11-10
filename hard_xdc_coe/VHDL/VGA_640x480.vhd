
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity VGA_640x480 is
 Port (clk, rst : in std_logic;
        hsync, vsync, vidon : out std_logic;
        HC : out std_logic_vector(9 downto 0);
        VC : out std_logic_vector(9 downto 0));
end VGA_640x480;

architecture Behavioral of VGA_640x480 is
    constant hbp : std_logic_vector(9 downto 0) := "0010010000";  -- 96 + 48 = 144d 
    constant hfp : std_logic_vector(9 downto 0) := "1100010000"; -- 96 + 48 + 640 = 784d
    constant hpixels : std_logic_vector(9 downto 0) := "1100100000";-- 800
    constant vbp : std_logic_vector(9 downto 0) := "0000011111";  -- 2 + 29 = 31
    constant vfp : std_logic_vector(9 downto 0) := "0111111111";  -- 2+29+480 = 511
    constant vlines : std_logic_vector(9 downto 0) := "1000001001";-- 521
    
    signal act_cptv : std_logic;
    signal cpt_h, cpt_v : std_logic_vector(9 downto 0);
begin


process (rst, clk)
    begin 
    if rst = '1'
        then cpt_h <= (others => '0');
             act_cptv <= '0'; 
     elsif clk'event and clk='1' then
        if cpt_h = hpixels-1
            then cpt_h <= (others => '0');
                 act_cptv <= '1';
        else
            cpt_h <= cpt_h + 1;
            act_cptv <= '0';
        end if;
     end if;       
end process;

process ( rst, clk)
    begin 
    if rst = '1'
        then cpt_v <= (others => '0');
    elsif clk'event and clk='1' then
        if act_cptv = '1'
            then if cpt_v = vlines - 1
                    then cpt_v <= (others => '0');
                 else cpt_v <= cpt_v + 1;
                 end if;
        end if;
      end if;  
end process; 

 process (cpt_v, cpt_h)
 begin 
 
 if cpt_h < 96 then hsync <= '0';
    else hsync <= '1';
 end if;
 
 if cpt_v < 2 then vsync <= '0';
    else vsync <= '1';
 end if;
 
 if (cpt_h < hfp and cpt_h >= hbp and cpt_v < vfp and cpt_v >= vbp)
    then vidon <= '1';
    else vidon <= '0';
 end if;
 
 end process;

 HC <= cpt_h;
 VC <= cpt_v;

end Behavioral;
