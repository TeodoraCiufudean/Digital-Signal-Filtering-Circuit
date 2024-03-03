----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2023 04:29:14 PM
-- Design Name: 
-- Module Name: circuit - Behavioral
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

entity circuit is
    Port (aclk : in std_logic;
        arst : in std_logic; 
        t1_valid: in std_logic;
        t1_ready :out std_logic;
        t1_data: in std_logic_vector(7 downto 0);
        t2_valid: in std_logic;
        t2_ready :out std_logic;
        t2_data: in std_logic_vector(7 downto 0);
        t3_valid: in std_logic;
        t3_ready :out std_logic;
        t3_data: in std_logic_vector(7 downto 0);
        out_valid1: out std_logic;
        out_ready1: in std_logic;
        out_data1:out std_logic_vector(15 downto 0);
        out_valid2: out std_logic;
        out_ready2: in std_logic;
        out_data2:out std_logic_vector(15 downto 0);
        out_valid3: out std_logic;
        out_ready3: in std_logic;
        out_data3:out std_logic_vector(15 downto 0);
        --cat : out STD_LOGIC_VECTOR (6 downto 0);
        --an : out STD_LOGIC_VECTOR (3 downto 0);
        fltr: in std_logic_vector(1 downto 0)
        );
end circuit;

architecture Behavioral of circuit is
COMPONENT axis_data_fifo
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

component filter1 is 
    Port (aclk : IN STD_LOGIC;
         s_axis_a_tvalid : IN STD_LOGIC;
         s_axis_a_tready : OUT STD_LOGIC;
         s_axis_a_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         m_axis_result_tvalid : OUT STD_LOGIC;
         m_axis_result_tready : IN STD_LOGIC;
         m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
         );
end component;

component filter2 is 
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
end component;

component filter3 is 
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
end component;

COMPONENT axis_out_fifo
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

component ssd is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal valid1, ready1, valid2, ready2, valid3,ready3: std_logic:='0';
signal data1, data2, data3 :std_logic_vector(7 downto 0);
signal data_count1, wr_data_count1, rd_data_count1: std_logic_vector(31 downto 0);
signal data_count2, wr_data_count2, rd_data_count2: std_logic_vector(31 downto 0);
signal data_count3, wr_data_count3, rd_data_count3: std_logic_vector(31 downto 0);
signal data_count4, wr_data_count4, rd_data_count4: std_logic_vector(31 downto 0);
signal data_count5, wr_data_count5, rd_data_count5: std_logic_vector(31 downto 0);
signal data_count6, wr_data_count6, rd_data_count6: std_logic_vector(31 downto 0);

signal data_o: std_logic_vector(23 downto 0);
signal valid_o, ready_o : std_logic_vector(2 downto 0);
signal f1_out, f2_out, f3_out: std_logic_vector(15 downto 0);
signal f1_valid, f1_ready, f2_valid, f2_ready, f3_valid, f3_ready : std_logic := '0'; 
signal filter_out : std_logic_vector(15 downto 0);
signal filter_valid, filter_ready : std_logic :='0';
signal display : std_logic_vector (15 downto 0);
signal addr : std_logic_vector(31 downto 0) := (others => '0');
signal data : std_logic_vector(7 downto 0);

begin  
    fifo_i1 : axis_data_fifo port map (
        s_axis_aresetn =>arst,
        s_axis_aclk => aclk,
        s_axis_tvalid => t1_valid,
        s_axis_tready => t1_ready,
        s_axis_tdata => t1_data,
        m_axis_tvalid => valid1,
        m_axis_tready => ready1,
        m_axis_tdata => data1, 
        axis_data_count => data_count1,
        axis_wr_data_count => wr_data_count1,
        axis_rd_data_count => rd_data_count1
        );
        
        
   fifo_i2 : axis_data_fifo port map (
        s_axis_aresetn =>arst,
        s_axis_aclk => aclk,
        s_axis_tvalid => t2_valid,
        s_axis_tready => t2_ready,
        s_axis_tdata => t2_data,
        m_axis_tvalid => valid2,
        m_axis_tready => ready2,
        m_axis_tdata => data2, 
        axis_data_count => data_count2,
        axis_wr_data_count => wr_data_count2,
        axis_rd_data_count => rd_data_count2
       );
     
   fifo_i3 : axis_data_fifo port map (
        s_axis_aresetn =>arst,
        s_axis_aclk => aclk,
        s_axis_tvalid => t3_valid,
        s_axis_tready => t3_ready,
        s_axis_tdata => t3_data,
        m_axis_tvalid => valid3,
        m_axis_tready => ready3,
        m_axis_tdata => data3, 
        axis_data_count => data_count3,
        axis_wr_data_count => wr_data_count3,
        axis_rd_data_count => rd_data_count3
        );
     
     f1 : filter1 port map (
        aclk => aclk,
        s_axis_a_tvalid => valid1, --valid_o(0),
        s_axis_a_tready => ready1, --ready_o(0),
        s_axis_a_tdata => data1, --data_o(7 downto 0),
        m_axis_result_tvalid => f1_valid,
        m_axis_result_tready => f1_ready,
        m_axis_result_tdata => f1_out
        );
       
     f2 : filter2 generic map (size => 8)
         port map (
         aclk => aclk,
         s_axis_a_tvalid => valid2, -- valid_o(1),
         s_axis_a_tready => ready2, --ready_o(1),
         s_axis_a_tdata => data2, --data_o(15 downto 8), 
         m_axis_result_tvalid => f2_valid,
         m_axis_result_tready => f2_ready,
         m_axis_result_tdata => f2_out
         );
      
     f3 : filter3 port map (
        aclk => aclk, 
        s_axis_a_tvalid => valid3, --valid_o(2),
        s_axis_a_tready => ready3, --ready_o(2),
        s_axis_a_tdata => data3, --data_o(23 downto 16),
        m_axis_result_tvalid => f3_valid,
        m_axis_result_tready => f3_ready,
        m_axis_result_tdata  =>f3_out
        );
   
        
     fifo_o1 : axis_out_fifo port map(
         s_axis_aresetn => arst,
         s_axis_aclk => aclk,
         s_axis_tvalid => f1_valid,
         s_axis_tready => f1_ready,
         s_axis_tdata => f1_out,
         m_axis_tvalid => out_valid1,
         m_axis_tready => out_ready1,
         m_axis_tdata => out_data1, 
         axis_data_count => data_count4,
         axis_wr_data_count => wr_data_count4,
         axis_rd_data_count => rd_data_count4
         );
     
      fifo_o2 : axis_out_fifo port map(
         s_axis_aresetn => arst,
         s_axis_aclk => aclk,
         s_axis_tvalid => f2_valid,
         s_axis_tready => f2_ready,
         s_axis_tdata => f2_out,
         m_axis_tvalid => out_valid2,
         m_axis_tready => out_ready2,
         m_axis_tdata => out_data2, 
         axis_data_count => data_count5,
         axis_wr_data_count => wr_data_count5,
         axis_rd_data_count => rd_data_count5
         );    
       
     fifo_o : axis_out_fifo port map(
          s_axis_aresetn => arst,
          s_axis_aclk => aclk,
          s_axis_tvalid => f3_valid,
          s_axis_tready => f3_ready,
          s_axis_tdata => f3_out,
          m_axis_tvalid => out_valid3,
          m_axis_tready => out_ready3,
          m_axis_tdata => out_data3, 
          axis_data_count => data_count6,
          axis_wr_data_count => wr_data_count6,
          axis_rd_data_count => rd_data_count6
          );
   
   
end Behavioral;
