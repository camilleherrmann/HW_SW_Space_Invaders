----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2022 16:24:02
-- Design Name: 
-- Module Name: plasma_7seg - Behavioral
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

entity plasma_7seg_vga is
 Port (clk, btnC, btnL, btnU, btnR, btnD, RsRx : in std_logic;
        sw : in std_logic_vector(15 downto 0);
        RsTx, dp : out std_logic;
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(0 to 6);
        an : out std_logic_vector(3 downto 0);
        hsync, vsync : out std_logic;
        vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0));
end plasma_7seg_vga;

architecture Behavioral of plasma_7seg_vga is
signal s_gpio0 : std_logic_vector(31 downto 0);
signal s_gpio1 : std_logic_vector(31 downto 0);
signal s_gpio2 : std_logic_vector(31 downto 0);
signal s_gpio3 : std_logic_vector(31 downto 0);
signal s_gpio4 : std_logic_vector(31 downto 0);

component plasma_bassys3 is
    Port ( clk,RsRx : in STD_LOGIC;
            RsTx : out std_logic;
            led : out std_logic_vector(15 downto 0);
            btnR,btnL,btnU,btnD,btnC : in std_logic;
            sw : in std_logic_vector(15 downto 0);
            gpio0 : out std_logic_vector(31 downto 0);
            gpio1 : out std_logic_vector(31 downto 0);
            gpio2 : out std_logic_vector(31 downto 0);
            gpio3 : out std_logic_vector(31 downto 0);
            gpio4 : out std_logic_vector(31 downto 0));
end component;

component top_7seg is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           e1 : in STD_LOGIC_VECTOR (7 downto 0);
           e2 : in STD_LOGIC_VECTOR (7 downto 0);
           e3 : in STD_LOGIC_VECTOR (7 downto 0);
           e4 : in STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (0 to 6);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC);
end component;

component top_vga is
Port (clk, rst : in std_logic;
        hsync, vsync : out std_logic;
        gpio0 : in std_logic_vector(29 downto 0);
        gpio2 : in std_logic_vector(29 downto 0);
        gpio3 : in std_logic_vector(29 downto 0);
        gpio4 : in std_logic_vector(29 downto 0); 
        vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0)); 
end component ;

begin

instance1 : plasma_bassys3 port map (clk => clk, 
                                    RsRx => RsRx,
                                    RsTx => RsTx,
                                    led => led,
                                    btnR => btnR,
                                    btnC => btnC,
                                    btnL => btnL,
                                    btnU => btnU,
                                    btnD => btnD,
                                    sw => sw,
                                    gpio0 => s_gpio0,
                                    gpio1 => s_gpio1,
                                    gpio2 => s_gpio2,
                                    gpio3 => s_gpio3,
                                    gpio4 => s_gpio4);
instance2 : top_7seg port map ( rst => btnc,
                                clk => clk,
                                e1 => s_gpio1(31 downto 24),
                                e2 =>  s_gpio1(23 downto 16),
                                e3 => s_gpio1(15 downto 8),
                                e4 => s_gpio1(7 downto 0),
                                seg => seg,
                                an => an ,
                                dp => dp);    
                                
instance3 : top_vga port map (clk => clk,
                              rst => btnc,
                              hsync=> hsync,
                              vsync => vsync,
                              gpio0 => s_gpio0(29 downto 0),
                              gpio2 => s_gpio2(29 downto 0),
                              gpio3 => s_gpio3(29 downto 0),
                              gpio4 => s_gpio4(29 downto 0),
                              vgaRed => vgaRed,
                              vgaBlue => vgaBlue,
                              vgaGreen => vgaGreen);      
                                
                                    


end Behavioral;
