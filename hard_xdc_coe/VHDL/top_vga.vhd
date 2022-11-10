----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2022 12:15:36
-- Design Name: 
-- Module Name: top_vga - Behavioral
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

entity top_vga is
Port (clk, rst : in std_logic;
        hsync, vsync : out std_logic;
        gpio0 : in std_logic_vector(29 downto 0);
        gpio2 : in std_logic_vector(29 downto 0);
        gpio3 : in std_logic_vector(29 downto 0);
        gpio4 : in std_logic_vector(29 downto 0); 
        vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0)); 
end top_vga;

architecture Behavioral of top_vga is
signal s_vidon, clk25 : std_logic;
signal  s_HC, s_VC : std_logic_vector(9 downto 0);
signal s_M_alien : std_logic_vector(11 downto 0);
signal s_M_vaisseau : std_logic_vector(11 downto 0);
signal s_M_faucon : std_logic_vector(11 downto 0);
signal s_M_Camille : std_logic_vector(11 downto 0);
signal s_M_munition : std_logic_vector(11 downto 0);
signal s_M_choose : std_logic_vector(11 downto 0);
signal s_M_over : std_logic_vector(11 downto 0);
signal s_addr :std_logic_vector(11 downto 0);
signal s_addr1 :std_logic_vector(12 downto 0);
signal s_addr2 :std_logic_vector(9 downto 0);
signal s_addr3 :std_logic_vector(16 downto 0);
signal s_addr4 : std_logic_vector(13 downto 0);

component sprite_rom IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;

component camille IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
end component;

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component; 

component choose is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
end component;

component over is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
end component;

component faucon IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

component  VGA_PROM_2 is
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
end component;

component VGA_640x480 is
 Port (clk, rst : in std_logic;
        hsync, vsync, vidon : out std_logic;
        HC : out std_logic_vector(9 downto 0);
        VC : out std_logic_vector(9 downto 0));
end component;

component clk_div is
     port(clk, rst: in std_logic;
     clk25: out std_logic);
end component;



begin
instance1 : clk_div port map ( clk =>clk,
                                rst =>rst,
                                clk25 =>clk25);
instance2 : VGA_640x480 port map (clk => clk25,
                                    rst => rst,
                                    hsync => hsync,
                                    vsync => vsync,
                                    vidon => s_vidon,
                                    HC => s_HC,
                                    VC => s_VC);
instance3 : VGA_PROM_2 port map (HC => s_HC,
                                VC => s_VC,
                                M_alien => s_M_alien,
                                M_vaisseau => s_M_vaisseau,
                                M_munition => s_M_munition,
                                M_choose => s_M_choose,
                                M_over => s_M_over,
                                Rom_addr_alien => s_addr,
                                Rom_addr_vaisseau => s_addr1,
                                Rom_addr_munition => s_addr2,
                                Rom_addr_choose => s_addr3,
                                Rom_addr_over => s_addr4,
                                vidon => s_vidon,
                                gpio0 => gpio0,
                                gpio2 => gpio2,
                                gpio3 => gpio3,
                                gpio4 => gpio4,
                                vgaRed => vgared,
                                vgaBlue => vgablue,
                                vgaGreen => vgaGreen);
instance4 : sprite_rom port map (addra =>s_addr,
                                 douta=>s_M_alien, 
                                 clka=>clk25);
instance5  : camille port map  (addra =>s_addr1,
                                douta=>s_M_Camille, 
                               clka=>clk25);    
instance6  : blk_mem_gen_0 port map  (addra =>s_addr2,
                                douta=>s_M_munition, 
                               clka=>clk25);      
instance7 : choose port map (addra =>s_addr3,
                                douta=>s_M_choose, 
                               clka=>clk25);  
instance8  : faucon port map  (addra =>s_addr1,
                                douta=>s_M_faucon, 
                               clka=>clk25); 
instance9  : over port map  (addra =>s_addr4,
                                douta=>s_M_over, 
                               clka=>clk25);                                
                             
 process (gpio3(29 downto 28),s_M_Camille,s_M_faucon )
 begin                   
if(gpio3(29 downto 28) = "10") 
    then 
    s_M_vaisseau <= s_M_Camille; 
elsif(gpio3(29 downto 28) = "01") 
    then 
    s_M_vaisseau <= s_M_faucon;
else s_M_vaisseau <= (others => '0');
end if;
end process;

end Behavioral;
