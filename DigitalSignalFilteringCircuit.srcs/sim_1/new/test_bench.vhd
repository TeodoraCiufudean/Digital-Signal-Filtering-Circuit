----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2023 08:51:57 PM
-- Design Name: 
-- Module Name: test_bench - Behavioral
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

entity test_bench is
--  Port ( );
end test_bench;

architecture Behavioral of test_bench is
component circuit is
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
        out_data1: out std_logic_vector(15 downto 0);
        out_valid2: out std_logic;
        out_ready2: in std_logic;
        out_data2: out std_logic_vector(15 downto 0);
        out_valid3: out std_logic;
        out_ready3: in std_logic;
        out_data3:out std_logic_vector(15 downto 0);
        --cat : out STD_LOGIC_VECTOR (6 downto 0);
        --an : out STD_LOGIC_VECTOR (3 downto 0);
        fltr: in std_logic_vector(1 downto 0)
        );
end component;

constant T : time := 20 ns;

signal aclk, aresetn : STD_LOGIC := '0';
signal t1_tdata, t2_tdata, t3_tdata :STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal out_tdata1, out_tdata2, out_tdata3 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal t1_tready, t2_tready, t3_tready : STD_LOGIC := '0';
signal t1_tvalid,t2_tvalid,t3_tvalid, out_tvalid1, out_tvalid2, out_tvalid3 : STD_LOGIC := '0';

signal rd_count1, wr_count1, rd_count2, wr_count2,rd_count3, wr_count3  : integer := 0;
signal end_of_reading : std_logic := '0';
signal fltr : std_logic_vector(1 downto 0) := "10";
--signal c : STD_LOGIC_VECTOR (6 downto 0);
--signal a : STD_LOGIC_VECTOR (3 downto 0);

begin
    aclk <= not aclk after T / 2;
    aresetn <= '0', '1' after 5 * T;
    
    dut: circuit port map(
            aclk => aclk,
            arst => aresetn, 
            t1_valid => t1_tvalid,
            t1_ready => t1_tready,
            t1_data => t1_tdata,
            t2_valid => t2_tvalid,
            t2_ready => t2_tready,
            t2_data => t2_tdata,
            t3_valid => t3_tvalid,
            t3_ready => t3_tready,
            t3_data => t3_tdata,
            out_valid1 => out_tvalid1,
            out_ready1 => '1',
            out_data1 => out_tdata1,
            out_valid2 => out_tvalid2,
            out_ready2 => '1',
            out_data2 => out_tdata2,    
            out_valid3 => out_tvalid3,
            out_ready3 => '1',
            out_data3 => out_tdata3,
            --cat => c, 
            --an => a,
            fltr => fltr
            );
            
    
    -- read values from the input file
    process (aclk)
        file sensors_data : text open read_mode is "C:\Users\Teo\Documents\input.csv";
        variable in_line : line;
        variable value : std_logic_vector(7 downto 0);
        begin
           if rising_edge(aclk) then
            if aresetn = '1' and end_of_reading = '0' then
            
              if fltr = "00" then
            
                if not endfile(sensors_data) then --and rd_count1 < 8 then     
                    
                    if t1_tready = '1' then    
                        readline(sensors_data, in_line);
                        t1_tvalid <= '1';
                        read(in_line, value);
                        t1_tdata <= value;
                        rd_count1 <= rd_count1 + 1;
                        
                    else
                        t1_tvalid <= '0';
                        
                    end if;
                        
                else
                    file_close(sensors_data);
                    end_of_reading <= '1';
                end if;
             
             
            elsif fltr = "01" then
               if not endfile(sensors_data) then --and rd_count2 < 8 then                       
                   if t2_tready = '1' then     
                      readline(sensors_data, in_line);
                      t2_tvalid <= '1';      
                      read(in_line, value);
                      t2_tdata <= value;           
                      rd_count2 <= rd_count2 + 1; 
                   else
                      t2_tvalid <= '0';
                   end if;
                                      
               else
                   file_close(sensors_data);
                   end_of_reading <= '1';
               end if;
             
            elsif fltr = "10" then 
                if not endfile(sensors_data) then --and rd_count3 < 2  then
                    if t3_tready = '1' then    
                       readline(sensors_data, in_line);           
                       t3_tvalid <= '1';
                       read(in_line, value);
                       t3_tdata <= value;
                       rd_count3 <= rd_count3 + 1;
                    else 
                        t3_tvalid <= '0';
                    end if;
                else 
                    file_close(sensors_data);
                    end_of_reading <= '1';
                end if;
           end if;
          
         end if;
        end if;
       
    end process;   
    
     -- write results in the output file
  
    process 
        file results : text open write_mode is "C:\Users\Teo\Documents\output.csv";
        variable out_line : line;
        variable writeRes : integer:=0;
    begin
        --wait for 7*T;
        wait until rising_edge(aclk);
            
        if aresetn = '0' then
            wait until rising_edge(aresetn);
        end if;
        
        if fltr = "00" then 
         -- wait;  
            if wr_count1 < rd_count1 then
                if (out_tvalid1 = '1') then  
                    if (out_tdata1 /= "ZZZZZZZZZZZZZZZZ" )then   
                        write(out_line, out_tdata1);
                        writeline(results, out_line);
                    end if;
                 wr_count1 <= wr_count1 + 1;
            end if;
       end if;
        
        elsif fltr = "01" then 
           if wr_count2 < 122 then
             if (out_tvalid2 = '1') then
                if (out_tdata2 /= "ZZZZZZZZZZZZZZZZ" and (wr_count2 mod 8 = 7))then
                    write(out_line, out_tdata2);
                    writeline(results, out_line);
                end if;
                    wr_count2 <= wr_count2 + 1;
             end if;
             else 
                file_close(results);
         end if;
        
        elsif fltr = "10" then 
          --wait;
           if (wr_count3 < rd_count3) then
            if (out_tvalid3 = '1') then 
               if (out_tdata3 /= "ZZZZZZZZZZZZZZZZ" and wr_count3  mod 2 = 1) then 
                  write(out_line, out_tdata3);
                  writeline(results, out_line);
                end if; 
                wr_count3 <= wr_count3 + 1;
   
             end if;  
          end if;  
          end if;          
    end process;   
    
end Behavioral;
