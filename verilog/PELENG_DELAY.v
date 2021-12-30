// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Full Version"
// CREATED		"Mon Dec 20 12:12:12 2021"

module PELENG_DELAY(
	input 	clk,
	input 	pel_strobe,
	input 	read_pel,
	input 	clr,
	input 	[31:0]PEL_IN_IM,
	input 	[31:0]PEL_IN_RE,
	output 	[31:0]PEL_OUT_IM,
	output 	[31:0]PEL_OUT_RE
);

AKP_pel_delay	AKP_pel_delay(
	.wr_en(pel_strobe),
	.rd_en(read_pel),
	.clk(clk),
	.srst(clr),
	.din({PEL_IN_RE[31:0],PEL_IN_IM[31:0]}),
	
	.dout({PEL_OUT_RE,PEL_OUT_IM})
	);


endmodule
