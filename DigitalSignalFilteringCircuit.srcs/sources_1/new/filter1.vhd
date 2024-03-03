----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2023 04:14:28 PM
-- Design Name: 
-- Module Name: filter1 - Behavioral
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
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter1 is  -- range [10,20]
    Port (aclk : IN STD_LOGIC;
         s_axis_a_tvalid : IN STD_LOGIC;
         s_axis_a_tready : OUT STD_LOGIC;
         s_axis_a_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         m_axis_result_tvalid : OUT STD_LOGIC;
         m_axis_result_tready : IN STD_LOGIC;
         m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
         );
end filter1;

architecture Behavioral of filter1 is

component comparator is
Port ( clk : in std_logic;
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        smaller_or_eq : out std_logic;
        greater : out std_logic 
        );
end component;

signal a : std_logic_vector(7 downto 0):= "00001010";
signal b : std_logic_vector(7 downto 0):= "00010100";

type state_type is (READ_OPERANDS, WRITE_RESULT);
signal state: state_type:=READ_OPERANDS;
signal res_valid : std_logic:='0';
signal result : std_logic_vector (15 downto 0) := (others => 'Z');
signal internal_ready, external_ready, inputs_valid : STD_LOGIC := '0';

signal se1, g1, se2, g2 : std_logic :='0';

begin
    s_axis_a_tready <= external_ready;
    internal_ready <= '1' when state = READ_OPERANDS else '0';
    inputs_valid <= s_axis_a_tvalid;
    external_ready <= internal_ready and inputs_valid;
    m_axis_result_tvalid <= '1' when state = WRITE_RESULT else '0';
    m_axis_result_tdata <= result;
    
    comp1 : comparator port map(
                    clk => aclk,
                    a => a,
                    b => s_axis_a_tdata,
                    smaller_or_eq => se1,
                    greater => g1
                    );
    
    comp2 : comparator port map(
                    clk => aclk,
                    a => s_axis_a_tdata,
                    b => b,
                    smaller_or_eq => se2,
                    greater => g2
                    );
    
    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is 
                when READ_OPERANDS => 
                    if external_ready = '1' and inputs_valid ='1' then
                        if se1 = '1' and se2 = '1' then
                            result <= "00000000" & s_axis_a_tdata;
                        else 
                            result <= "ZZZZZZZZZZZZZZZZ";
                         end if;
                         state <= WRITE_RESULT;
                   end if;
                 when WRITE_RESULT => 
                    if m_axis_result_tready ='1' then
                        state <= READ_OPERANDS;
                    end if;
            end case;
         end if;
   end process;
   
   
   
end Behavioral;
