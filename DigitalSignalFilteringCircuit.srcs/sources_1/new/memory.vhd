----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2023 02:08:03 PM
-- Design Name: 
-- Module Name: memory - Behavioral
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
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory is
  Port ( clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(31 downto 0);
        data : out std_logic_vector(7 downto 0)
         );
end memory;

architecture Behavioral of memory is
type rom is array (0 to 255) of std_logic_vector(31 downto 0);
signal rom_signal : rom := ( 
                            "00000001", 
                            "00001100", 
                            "00001011",
                            "00000010",
                            "00001001",
                            "00001010",
                            "00000100",
                            "00000101",
                            others => "00000001");
begin
    process (clk)
        begin
            if rising_edge(clk) then
                if en = '1' then
                    data <= rom_signal(to_integer(unsigned((addr))));
                else
                    data <= "00000000";
                end if;
             end if;
        end process;
end Behavioral;
