----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2023 03:06:19 PM
-- Design Name: 
-- Module Name: filter2 - Behavioral
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

entity filter2 is  --arithmetical average
    Generic ( 
        size : integer :=8
        );
    Port (aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tready : OUT STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
end filter2;

architecture Behavioral of filter2 is

component carryLookaheadAdder is
Port ( x : in std_logic_vector (3 downto 0);
        y : in std_logic_vector(3 downto 0);
        c0 : in std_logic;
        c : out std_logic;
        s : out std_logic_vector(3 downto 0)
          );
end component; 

type state_type is (READ_OPERANDS, WRITE_RESULT);
signal state: state_type:=READ_OPERANDS;
signal res_valid : std_logic:='0';
signal result : std_logic_vector (15 downto 0) := (others => '0');
signal internal_ready, external_ready, inputs_valid : STD_LOGIC := '0';
signal al, ah, bl,bh : std_logic_vector(3 downto 0):="0000";
signal carry0, carry1, carry2 : std_logic:='0';
signal sum1, sum2 : std_logic_vector(3 downto 0):="0000";
signal count: std_logic_vector(2 downto 0):="000";
--signal avg : std_logic_vector(7 downto 0);

type WindowArrayType is array (7 downto 0) of std_logic_vector(7 downto 0);
signal window : WindowArrayType := (others => (others => '0'));
signal index : integer range 0 to size-1:= 0;
signal computed_sum : std_logic_vector(15 downto 0) := (others => '0');

begin
    s_axis_a_tready <= external_ready;
    internal_ready <= '1' when state = READ_OPERANDS else '0';
    inputs_valid <= s_axis_a_tvalid;
    external_ready <= internal_ready and inputs_valid;
    m_axis_result_tvalid <= '1' when state = WRITE_RESULT else '0';
    m_axis_result_tdata <= "000" & result(15 downto 3);
    al <= s_axis_a_tdata (3 downto 0);
    ah <= s_axis_a_tdata (7 downto 4);
    bl <= result (3 downto 0);
    bh <= result (7 downto 4);
    carry0 <= result(8);
    
    low : carryLookaheadAdder port map (al, bl, carry0, carry1, sum1);
    high : carryLookaheadAdder port map (ah, bh, carry1, carry2, sum2); 
 
    process(aclk)
    variable sum : std_logic_vector(15 downto 0):= (others => '0');
        begin
                 
            if rising_edge(aclk) then
              if index mod size = 0 then
                result <= "0000000000000000";
                index <= 0;
              end if;
                case state is 
                    when READ_OPERANDS => 
                        if external_ready = '1' and inputs_valid ='1' then
                              sum := "0000000" & carry2 & sum2 & sum1;
                              result<=sum;
                              state <= WRITE_RESULT;
                               index <= index + 1;
                       end if;
                     when WRITE_RESULT => 
                        if m_axis_result_tready ='1' then
                             state <= READ_OPERANDS;
                        end if;
                end case;
               
                end if;
       end process;
    end Behavioral;
    
