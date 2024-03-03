// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Wed Dec 13 00:10:47 2023
// Host        : DESKTOP-59VQ6AS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top axis_broadcaster_0 -prefix
//               axis_broadcaster_0_ axis_broadcaster_0_stub.v
// Design      : axis_broadcaster_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "top_axis_broadcaster_0,Vivado 2016.4" *)
module axis_broadcaster_0(aclk, aresetn, s_axis_tvalid, s_axis_tready, 
  s_axis_tdata, m_axis_tvalid, m_axis_tready, m_axis_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_tvalid,s_axis_tready,s_axis_tdata[7:0],m_axis_tvalid[2:0],m_axis_tready[2:0],m_axis_tdata[23:0]" */;
  input aclk;
  input aresetn;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  output [2:0]m_axis_tvalid;
  input [2:0]m_axis_tready;
  output [23:0]m_axis_tdata;
endmodule
