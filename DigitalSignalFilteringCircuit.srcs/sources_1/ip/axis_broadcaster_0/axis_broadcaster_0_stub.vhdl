-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Wed Dec 13 00:10:47 2023
-- Host        : DESKTOP-59VQ6AS running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top axis_broadcaster_0 -prefix
--               axis_broadcaster_0_ axis_broadcaster_0_stub.vhdl
-- Design      : axis_broadcaster_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axis_broadcaster_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );

end axis_broadcaster_0;

architecture stub of axis_broadcaster_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axis_tvalid,s_axis_tready,s_axis_tdata[7:0],m_axis_tvalid[2:0],m_axis_tready[2:0],m_axis_tdata[23:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "top_axis_broadcaster_0,Vivado 2016.4";
begin
end;
