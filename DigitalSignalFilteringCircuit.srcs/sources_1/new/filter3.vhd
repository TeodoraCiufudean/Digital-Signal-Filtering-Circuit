----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2023 10:08:29 AM
-- Design Name: 
-- Module Name: filter3 - Behavioral
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

entity filter3 is            -- y(n) = x(n)*x(n)+a*x(n-1)
    Generic ( 
        size : integer :=2
        );
    Port (aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tready : OUT STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);     
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
end filter3;

architecture Behavioral of filter3 is

component carryLookaheadAdder is
Port ( x : in std_logic_vector (3 downto 0);
        y : in std_logic_vector(3 downto 0);
        c0 : in std_logic;
        c : out std_logic;
        s : out std_logic_vector(3 downto 0)
          );
end component; 

component wallaceTreeMultiplier is
  Port (x : in std_logic_vector (7 downto 0);
        y : in std_logic_vector (7 downto 0);
        p : out std_logic_vector (15 downto 0));
end component;

type state_type is (READ_OPERANDS, WRITE_RESULT);
signal state : state_type := READ_OPERANDS;
signal res_valid : std_logic := '0';
signal result : std_logic_vector (15 downto 0):= (others => '0');
signal a_ready : std_logic := '0';
signal internal_ready, external_ready, inputs_valid : std_logic := '0';
signal a :  std_logic_vector (7 downto 0) := "00000011";
signal product1, product2, product3, product4,product5, product6, product22, product33, product44, pr4, pr5 : std_logic_vector (7 downto 0):= (others => '0');
signal ah,al,bh,bl,cl,ch : std_logic_vector(3 downto 0) :="0000";
signal add1, add2, add3, add4, add5, add6,add7,add8,add9,add10,add11,add12,add13,add14,add15,add16 : std_logic_vector(3 downto 0):= (others => '0');
signal add21, add43,add78,add910 : std_logic_vector(7 downto 0):= (others => '0');
signal index : integer:= 0;
signal cin1,cin2,cin3,cin4,cin5,cin6,cin7,cout1,cout2, cout3,cout4,cout5,cout6,cout7,cout8,cout9,cout10,cout11,cout12,cout13,cout14,cout15,cout16:std_logic:='0';
signal square, mul :  std_logic_vector(15 downto 0):= (others => '0');

begin
    s_axis_a_tready <= external_ready;
    internal_ready <= '1' when state = READ_OPERANDS else '0';
    inputs_valid <= s_axis_a_tvalid; 
    external_ready <= internal_ready and inputs_valid;
    m_axis_result_tvalid <= '1' when state = WRITE_RESULT else '0';
    m_axis_result_tdata <= result;
    --al <= s_axis_a_tdata (3 downto 0);
    --ah <= s_axis_a_tdata (7 downto 4);
    --bl <= result (3 downto 0);
    --bh <= result (7 downto 4);
    --cl <= a(3 downto 0);
    --ch <= a (7 downto 4); 
   
    --p1: wallaceTreeMultiplier port map (al,al,product1);
    --p2: wallaceTreeMultiplier port map (al,ah,product2);
    --product44 <= "00000000"; 
    --product33 <= product2(7 downto 4) & "0000";
    --product22 <= product2(7 downto 4) & "0000";
    --a1: carryLookaheadAdder port map(product1(3 downto 0), product22(3 downto 0),cin1,cout1,add1);
    --a2: carryLookaheadAdder port map(product1(7 downto 4), product22(7 downto 4),cout1,cout2,add2);
    --add21 <= add2 & add1;
    --a3: carryLookaheadAdder port map(product33(3 downto 0), product44(3 downto 0),cin2,cout3,add3);
    --a4: carryLookaheadAdder port map(product33(7 downto 4), product44(7 downto 4),cout3, cout4,add4);
    --add43 <= add4 & add3;
    --a5: carryLookaheadAdder port map(add21(3 downto 0),add43(3 downto 0),cin3,cout5,add5);
    --a6: carryLookaheadAdder port map(add21(7 downto 4), add43(7 downto 4),cout5,cout6, add6);
    --square <= "0000000" & cout6 & add6 & add5; 
    
--p3: wallaceTreeMultiplier port map (bl,cl,product3);
 --   p4: wallaceTreeMultiplier port map (bl,ch,product4);
  --  p5: wallaceTreeMultiplier port map (bh,cl,product5);
  --  p6: wallaceTreeMultiplier port map (bh,ch,product6); 
  --  pr4 <= product4(7 downto 4) & "0000";
   -- pr5 <= product5(7 downto 4) & "0000";
   -- product6 <= "00000000";
   -- a7: carryLookaheadAdder port map(product3(3 downto 0), pr4(3 downto 0),cin4,cout7,add7);
   -- a8: carryLookaheadAdder port map (product3(7 downto 4), pr4(7 downto 4),cout7,cout8,add8);
   -- add78 <= add8 & add7;
   -- a9: carryLookaheadAdder port map (pr5(3 downto 0), product6(3 downto 0), cin5,cout9, add9);
   -- a10: carryLookaheadAdder port map (pr5(7 downto 4), product6(7 downto 4), cout9,cout10, add10);
   -- add910 <= add10 & add9; 
  --  a11: carryLookaheadAdder port map (add78(3 downto 0), add910(3 downto 0), cin6, cout11, add11);
  --  a12: carryLookaheadAdder port map (add78(7 downto 4), add910(7 downto 4), cout11, cout12, add12);
   -- mul <= "0000000" & cout12 & add12 & add11;
    
    --a13: carryLookaheadAdder port map (square(3 downto 0), mul(3 downto 0), cin7, cout13, add13);
   -- a14: carryLookaheadAdder port map (square(7 downto 4), mul(7 downto 4), cout13, cout14, add14);
    --a15: carryLookaheadAdder port map (square(11 downto 8), mul(11 downto 8), cout14, cout15, add15);
    --a16: carryLookaheadAdder port map (square(15 downto 12), mul(15 downto 12), cout15, cout16, add16);
    
    p1: wallaceTreeMultiplier port map(s_axis_a_tdata,s_axis_a_tdata,square);
    p2 : wallaceTreeMultiplier port map(a, result(7 downto 0),mul);
    a1: carryLookaheadAdder port map (square(3 downto 0), mul(3 downto 0),'0', cout1, add1);
    a2: carryLookaheadAdder port map (square(7 downto 4), mul(7 downto 4), cout1, cout2, add2);
    a3: carryLookaheadAdder port map (square(11 downto 8), mul(11 downto 8), cout2, cout3, add3);
    a4: carryLookaheadAdder port map (square(15 downto 12), mul(15 downto 12), cout3, cout4, add4);
        
    process (aclk)
    variable sum : std_logic_vector(15 downto 0):= (others => '0');
    begin
        
     --if(index = size ) then 
        if rising_edge (aclk) then 
            case state is 
                when READ_OPERANDS => 
                    if external_ready = '1' and inputs_valid = '1' then 
                        if index mod size = 0 then 
                            result <= "00000000" & s_axis_a_tdata;
                        else 
                            --sum := (add16 & add15 & add14 & add13);
                            sum := (add4 & add3 & add2 & add1);
                            result <= sum;
                        end if; 
                          index <= index + 1;
                          state <= WRITE_RESULT; 
                           
                    end if;
                when WRITE_RESULT =>
                    if m_axis_result_tready = '1' then 
                        state <= READ_OPERANDS;
                    end if;
           end case;
       end if;
  end process;
    
end Behavioral;
