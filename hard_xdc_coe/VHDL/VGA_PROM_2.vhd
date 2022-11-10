

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity VGA_PROM_2 is
   Port (HC,VC : in std_logic_vector(9 downto 0);
        vidon :  in std_logic;
        M_alien : in std_logic_vector(11 downto 0);
        M_vaisseau : in std_logic_vector(11 downto 0);
        M_munition : in std_logic_vector(11 downto 0);
        M_choose : in std_logic_vector(11 downto 0);
        M_over : in std_logic_vector(11 downto 0);
        gpio0 : in std_logic_vector(29 downto 0);
        gpio2 : in std_logic_vector(29 downto 0);
        gpio3 : in std_logic_vector(29 downto 0);
        gpio4 : in std_logic_vector(29 downto 0); 
        vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
        Rom_addr_alien : out std_logic_vector(11 downto 0);
        Rom_addr_vaisseau : out std_logic_vector(12 downto 0);
        Rom_addr_munition : out std_logic_vector(9 downto 0);
        Rom_addr_over : out std_logic_vector(13 downto 0);
        Rom_addr_choose  : out std_logic_vector(16 downto 0)); 
end VGA_PROM_2;

architecture Behavioral of VGA_PROM_2 is
 constant hbp : std_logic_vector(9 downto 0) := "0010010000";  -- 96 + 48 = 144
 constant vbp : std_logic_vector(9 downto 0) := "0000011111";  -- 2 + 29 = 31
 constant w : integer := 50; 
 constant dx : integer := 39; 
 constant dy : integer := 15;
 constant w2 : integer := 70; 
 constant h2 : integer := 80; 
 constant h_laser : integer := 30;
 constant w_laser : integer := 4;
 constant h_munition : integer := 25;
 constant w_munition : integer := 25;
 constant h_choose : integer := 197;
 constant w_choose : integer := 440;
 constant h_over : integer := 28;
 constant w_over : integer := 300;
 signal sprite, spriteon2, spriteon3, spriteon4, spriteon5, spriteon6 : std_logic;
 signal deltaC, deltaL, deltaC2, dL3_1, dL3_2, dL3_3, dC3_1, dC3_2, dC3_3: std_logic_vector(9 downto 0);
 signal ypix1, xpix1, ypix2, xpix2, xpix4, ypix4, xc, yc, xo, yo: std_logic_vector(9 downto 0);
begin

deltaC <= gpio2(9 downto 0);
deltaL <= gpio2(19 downto 10) ;
deltaC2 <= gpio2(29 downto 20);
dL3_1 <= gpio0(9 downto 0);
dL3_2 <= gpio0(19 downto 10);
dL3_3 <= gpio0(29 downto 20);
dC3_1 <= gpio4(9 downto 0);
dC3_2 <= gpio4(19 downto 10);
dC3_3 <= gpio4(29 downto 20);
xpix2 <=  HC - (hbp + deltaC2);
ypix2 <= VC - (vbp + 415); 
xc <= HC - (hbp + 100);
yc <= VC - (vbp + 121);
xo <= HC - (hbp + 170);
yo <= VC - (vbp + 205);

alien : process(deltaC, deltaL, HC,VC, gpio3 )
    begin 
    sprite <= '0';
    lignes: FOR i IN 1 TO 5 LOOP
        col: FOR j IN 1 TO 5 LOOP      
            if ( HC >= (hbp + deltaC + (2*j-1)*dx + (j-1)*w)  and HC < (hbp + deltaC + (2*j-1)*dx + j*w)
                and VC >= (vbp + deltaL +(2*i-1)*dy + (i-1)*w) and VC < (vbp + deltaL +(2*i-1)*dy + i*w )
                and gpio3(5*(i-1)+j-1) = '1') then 
            sprite <= '1';
            xpix1 <=  HC - (hbp + deltaC + (2*j-1)*dx + (j-1)*w);
            ypix1 <= VC - (vbp + deltaL +(2*i-1)*dy + (i-1)*w); 
            end if;
        end loop col;
   END LOOP lignes; 
end process alien;  
 
 vaisseau : process(HC, VC, deltaC2)
 begin  
   if ( HC > (hbp + deltaC2)  and HC < (hbp + w2 + deltaC2) and VC > (vbp + 415)   and VC < vbp + 415 + h2 )then 
        spriteon2 <= '1';
    else spriteon2 <= '0';
    end if; 
end process vaisseau;

laser : process(HC, VC, dL3_1, dL3_2, dL3_3, dC3_1, dC3_2, dC3_3, gpio3)
begin               
    if ( HC > (hbp + dC3_1 ) and HC < (hbp + dC3_1 + w_laser) 
            and VC > (vbp + dL3_1) and VC < (vbp + dL3_1 + h_laser) 
            and gpio3(25) = '1'  ) then 
        spriteon3 <= '1';
    elsif ( HC > (hbp + dC3_2 ) and HC < (hbp + dC3_2 + w_laser) 
            and VC > (vbp + dL3_2) and VC < (vbp + dL3_2 + h_laser) 
            and gpio3(26) = '1'  ) then 
        spriteon3 <= '1';
    elsif ( HC > (hbp + dC3_3 ) and HC < (hbp + dC3_3 + w_laser) 
            and VC > (vbp + dL3_3) and VC < (vbp + dL3_3 + h_laser) 
            and gpio3(27) = '1'  ) then 
        spriteon3 <= '1';
    else spriteon3 <= '0';
    end if;   
end process laser;

munition : process(HC, VC, gpio3)
begin
 spriteon4 <= '0';
 FOR k IN 1 TO 3 LOOP      
            if ( HC > (hbp + 640 - w_munition)  and HC < (hbp + 640)
                and VC > (vbp + 203 + (k-1)*w_munition) and VC < (vbp + 203 + k*w_munition  )
                and gpio3(24+k) = '0') then 
            spriteon4 <= '1';
            xpix4 <=  HC - (hbp + 640 - w_munition);
            ypix4 <= VC - (vbp + 203 + (k-1)*w_munition); 
            end if;
        end loop ;
end process munition;

menu : process (HC, VC)
begin
   if ( HC > (hbp + 100)  and HC < (hbp + w_choose + 100) 
   and VC > (vbp + 121)   and VC < vbp + 121 + h_choose )then 
        spriteon5 <= '1';
    else spriteon5 <= '0';
    end if; 
end process menu;

over : process (HC, VC)
begin
   if ( HC > (hbp + 170)  and HC < (hbp + w_over + 170) 
   and VC > (vbp + 205)   and VC < vbp + 205 + h_over )then 
        spriteon6 <= '1';
    else spriteon6 <= '0';
    end if; 
end process over;

process(xpix1, ypix1,xpix2, ypix2, xpix4, ypix4)
    begin                                                               -- fois 16                fois 32               
    Rom_addr_alien <= ("00" & xpix1 ) + ("0" & ypix1 & "0") + ( ypix1(7 downto 0) & "0000") + (ypix1(6 downto 0) & "00000" );
    Rom_addr_vaisseau <= ("000" & xpix2) + ("00" & ypix2 & "0") + ("0" & ypix2 & "00") + (ypix2(6 downto 0) & "000000");
    Rom_addr_munition <= xpix4 + (ypix4(5 downto 0) & "0000") + (ypix4(6 downto 0) & "000") + ypix4(6 downto 0) ;
    Rom_addr_choose <= ("0000000" & xc) + (yc(8 downto 0) & "00000000")+ (yc & "0000000")+ ( "00" & yc & "00000")+ ("000" & yc & "0000") + ("0000" & yc & "000");
    Rom_addr_over <= ("0000" & xo) + (yo(4 downto 0) & "00000000")+ ( yo(8 downto 0) & "00000") + ("0" & yo & "000")+ ("00" & yo & "00");

end process;   

process (gpio3(29 downto 28),sprite, spriteon2,spriteon3, spriteon4,spriteon5, spriteon6, vidon, M_alien, M_vaisseau, M_munition, M_choose,M_over)
    begin
    if (gpio3(29 downto 28) = "00") then 
        if (vidon = '1' and spriteon5= '1') then 
            vgaRed <=  M_choose(11 downto 8);
            vgaGreen<=  M_choose(7 downto 4);
            vgaBlue <= M_choose(3 downto 0); 
       else 
            vgaBlue <= "0000";
            vgaGreen <= "0000";
            vgaRed <= "0000";
        end if;
    elsif (gpio3(29 downto 28) = "11") then 
        if (vidon = '1' and spriteon6= '1') then 
            vgaRed <=  M_over(11 downto 8);
            vgaGreen<=  M_over(7 downto 4);
            vgaBlue <= M_over(3 downto 0); 
       else 
            vgaBlue <= "0000";
            vgaGreen <= "0000";
            vgaRed <= "0000";
        end if;
    else
        if (vidon = '1' and spriteon3 = '1') then
            vgaBlue <= "1110";
            vgaGreen <= "1111";
            vgaRed <= "0000";
        elsif (sprite= '1' and vidon ='1' and M_alien /= x"000") then
            vgaRed <=  M_alien(11 downto 8);
            vgaGreen<=  M_alien(7 downto 4);
            vgaBlue <= M_alien(3 downto 0);    
       elsif (vidon = '1' and spriteon2= '1' and M_vaisseau /=x"000" ) then 
            vgaRed <=  M_vaisseau(11 downto 8);
            vgaGreen<=  M_vaisseau(7 downto 4);
            vgaBlue <= M_vaisseau(3 downto 0); 
       elsif (vidon = '1' and spriteon4= '1' and M_munition /=x"fff" ) then 
            vgaRed <=  M_munition(11 downto 8);
            vgaGreen<=  M_munition(7 downto 4);
            vgaBlue <= M_munition(3 downto 0); 
       else 
            vgaBlue <= "0000";
            vgaGreen <= "0000";
            vgaRed <= "0000";
        end if;
    end if; 
     
    
end process;


end Behavioral;
