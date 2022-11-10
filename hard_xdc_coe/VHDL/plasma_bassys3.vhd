----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2022 11:14:47
-- Design Name: 
-- Module Name: plasma_bassys3 - Behavioral
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

entity plasma_bassys3 is
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
end plasma_bassys3;

architecture Behavioral of plasma_bassys3 is

signal clk25, s_uart_write, s_uart_read,s_mem_pause_in, s_no_ddr_start, s_no_ddr_stop: STD_LOGIC;
signal s_address: std_logic_vector(31 downto 2);
signal s_data_write , s_datawrite, s_data_read, s_gpio0_out, s_gpio1_out, s_gpio2_out, s_gpio3_out, s_gpio4_out: std_logic_vector(31 downto 0);
signal  s_byte_we : std_logic_vector(3 downto 0);

component plasma is
   generic(memory_type : string := "XILINX_16X"; --"DUAL_PORT_" "ALTERA_LPM";
           log_file    : string := "UNUSED";
           ethernet    : std_logic := '0';
           use_cache   : std_logic := '0');
   port(clk          : in std_logic;
        reset        : in std_logic;

        uart_write   : out std_logic;
        uart_read    : in std_logic;

        address      : out std_logic_vector(31 downto 2);
        byte_we      : out std_logic_vector(3 downto 0); 
        data_write   : out std_logic_vector(31 downto 0);
        data_read    : in std_logic_vector(31 downto 0);
        mem_pause_in : in std_logic;
        no_ddr_start : out std_logic;
        no_ddr_stop  : out std_logic;
        
        gpio0_out    : out std_logic_vector(31 downto 0);
        gpio1_out    : out std_logic_vector(31 downto 0);
        gpio2_out    : out std_logic_vector(31 downto 0);
        gpio3_out    : out std_logic_vector(31 downto 0);
        gpio4_out    : out std_logic_vector(31 downto 0);
        gpioA_in     : in std_logic_vector(31 downto 0));
end component;

component clk_div is
     port(clk, rst: in std_logic;
     clk25: out std_logic);
end component;

component RAM_PROGRAM IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

begin

instance1 : clk_div port map(clk => clk, rst=> btnC, clk25=>clk25);
instance2 : RAM_PROGRAM port map(clka => clk, 
                                 clkb => clk, 
                                 wea => s_byte_we,
                                 addra => s_address(13 downto 2), 
                                 addrb => s_address(13 downto 2),
                                 dina => s_data_write,
                                 doutb => s_data_read);                       
instance3 : plasma port map(clk => clk25, 
                            reset=>btnC, 
                            uart_write=> s_uart_write,
                            uart_read => s_uart_read,
                            address => s_address,
                            byte_we => s_byte_we, 
                            data_write => s_data_write,  
                            data_read => s_data_read,
                            mem_pause_in => s_mem_pause_in, 
                            no_ddr_start=> s_no_ddr_start, 
                            no_ddr_stop => s_no_ddr_stop,
                            gpio0_out=> s_gpio0_out, 
                            gpio2_out => s_gpio2_out,
                            gpio1_out=> s_gpio1_out,
                            gpio3_out => s_gpio3_out,
                            gpio4_out => s_gpio4_out,
                            gpioA_in(19) => btnL,
                            gpioA_in(18) => btnR,
                            gpioA_in(17) => btnU,
                            gpioA_in(16) => btnD,
                            gpioA_in(15 downto 0) => sw,
                            gpioA_in(31 downto 20) => (others=>'0'));
                      
s_uart_read <= RsRx;
RsTx <= s_uart_write;
gpio0 <= s_gpio0_out;
gpio1 <= s_gpio1_out;
gpio2 <= s_gpio2_out;
gpio3 <= s_gpio3_out;
gpio4 <= s_gpio4_out;

end Behavioral;
