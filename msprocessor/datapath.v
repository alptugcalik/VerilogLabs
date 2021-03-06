// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
// CREATED		"Mon May 31 21:31:03 2021"

module datapath(
	PCWrite,
	CLK,
	RST,
	AdrSrc,
	MemW,
	IRWrite,
	RA1Src,
	RegWrite,
	R7Write,
	ALUSrcA,
	updateFlags,
	reg_enb,
	ALUControl,
	ALUSrcB,
	RA2Src,
	RA3Src,
	ResultSrc,
	shift,
	WD3Src,
	C,
	V,
	N,
	Z,
	ALUA,
	ALUB,
	alures,
	counter,
	instruction,
	mem,
	rd2,
	result,
	shiftd
);


input wire	PCWrite;
input wire	CLK;
input wire	RST;
input wire	AdrSrc;
input wire	MemW;
input wire	IRWrite;
input wire	RA1Src;
input wire	RegWrite;
input wire	R7Write;
input wire	ALUSrcA;
input wire	updateFlags;
input wire	reg_enb;
input wire	[2:0] ALUControl;
input wire	[1:0] ALUSrcB;
input wire	[1:0] RA2Src;
input wire	[1:0] RA3Src;
input wire	[1:0] ResultSrc;
input wire	[2:0] shift;
input wire	[1:0] WD3Src;
output wire	C;
output wire	V;
output wire	N;
output wire	Z;
output wire	[7:0] ALUA;
output wire	[7:0] ALUB;
output wire	[7:0] alures;
output wire	[7:0] counter;
output wire	[15:0] instruction;
output wire	[15:0] mem;
output wire	[7:0] rd2;
output wire	[7:0] result;
output wire	[7:0] shiftd;

wire	[7:0] ALUOut;
wire	[7:0] ALUResult;
wire	[7:0] DATA;
wire	enb;
wire	[15:0] INSTR;
wire	[15:0] MEM_ALTERA_SYNTHESIZED;
wire	[7:0] ONE;
wire	[7:0] PC;
wire	[2:0] RA1;
wire	[2:0] RA2;
wire	[2:0] RA3;
wire	[7:0] RD_ALTERA_SYNTHESIZED2;
wire	[7:0] Result_ALTERA_SYNTHESIZED;
wire	[2:0] SEVEN;
wire	[7:0] shifted;
wire	[2:0] SIX;
wire	[7:0] WD3;
wire	[7:0] SYNTHESIZED_WIRE_0;
wire	[7:0] SYNTHESIZED_WIRE_1;
wire	[7:0] SYNTHESIZED_WIRE_2;
wire	[7:0] SYNTHESIZED_WIRE_3;
wire	[7:0] SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	[7:0] SYNTHESIZED_WIRE_6;

assign	ALUA = SYNTHESIZED_WIRE_0;
assign	ALUB = SYNTHESIZED_WIRE_1;
assign	SYNTHESIZED_WIRE_5 = 1;




register_WE	b2v_inst(
	.clk(CLK),
	.rst(RST),
	.enb(PCWrite),
	.A(Result_ALTERA_SYNTHESIZED),
	.B(PC));
	defparam	b2v_inst.W = 8;


alu	b2v_inst1(
	.updateFlags(updateFlags),
	.A(SYNTHESIZED_WIRE_0),
	.B(SYNTHESIZED_WIRE_1),
	.CONTROL(ALUControl),
	.CO(C),
	.OVF(V),
	.N(N),
	.Z(Z),
	.C(ALUResult));
	defparam	b2v_inst1.W = 8;


constant_value	b2v_inst10(
	.A(SIX));
	defparam	b2v_inst10.V = 6;
	defparam	b2v_inst10.W = 3;


my_2mux	b2v_inst11(
	.C(RA1Src),
	.A(INSTR[5:3]),
	.B(SEVEN),
	.D(RA1));
	defparam	b2v_inst11.W = 3;


constant_value	b2v_inst12(
	.A(SEVEN));
	defparam	b2v_inst12.V = 7;
	defparam	b2v_inst12.W = 3;


register_file	b2v_inst13(
	.wrt(RegWrite),
	.rst(RST),
	.clk(CLK),
	.R7Write(R7Write),
	.din1(WD3),
	.Rd(RA3),
	.Rm(RA2),
	.Rn(RA1),
	.dout1(SYNTHESIZED_WIRE_2),
	.dout2(SYNTHESIZED_WIRE_3));
	defparam	b2v_inst13.W = 8;


register_WE	b2v_inst14(
	.clk(CLK),
	.rst(RST),
	.enb(enb),
	.A(SYNTHESIZED_WIRE_2),
	.B(SYNTHESIZED_WIRE_4));
	defparam	b2v_inst14.W = 8;


register_WE	b2v_inst15(
	.clk(CLK),
	.rst(RST),
	.enb(enb),
	.A(SYNTHESIZED_WIRE_3),
	.B(RD_ALTERA_SYNTHESIZED2));
	defparam	b2v_inst15.W = 8;


shifter	b2v_inst19(
	.data(RD_ALTERA_SYNTHESIZED2),
	.sh(shift),
	.sh_data(shifted));
	defparam	b2v_inst19.W = 8;


my_2mux	b2v_inst2(
	.C(AdrSrc),
	.A(PC),
	.B(Result_ALTERA_SYNTHESIZED),
	.D(SYNTHESIZED_WIRE_6));
	defparam	b2v_inst2.W = 8;


my_2mux	b2v_inst20(
	.C(ALUSrcA),
	.A(SYNTHESIZED_WIRE_4),
	.B(PC),
	.D(SYNTHESIZED_WIRE_0));
	defparam	b2v_inst20.W = 8;


my_4mux	b2v_inst21(
	.A(shifted),
	.B(INSTR[7:0]),
	.C(ONE),
	
	.E(ALUSrcB),
	.F(SYNTHESIZED_WIRE_1));
	defparam	b2v_inst21.W = 8;


constant_value	b2v_inst22(
	.A(ONE));
	defparam	b2v_inst22.V = 1;
	defparam	b2v_inst22.W = 8;


register_WE	b2v_inst28(
	.clk(CLK),
	.rst(RST),
	.enb(SYNTHESIZED_WIRE_5),
	.A(ALUResult),
	.B(ALUOut));
	defparam	b2v_inst28.W = 8;



my_4mux	b2v_inst31(
	.A(ALUOut),
	.B(DATA),
	.C(ALUResult),
	
	.E(ResultSrc),
	.F(Result_ALTERA_SYNTHESIZED));
	defparam	b2v_inst31.W = 8;


memory	b2v_inst32(
	.clk(CLK),
	.mem_write(MemW),
	.address(SYNTHESIZED_WIRE_6),
	.data_in(RD_ALTERA_SYNTHESIZED2),
	.data_out(MEM_ALTERA_SYNTHESIZED));


register_WE	b2v_inst4(
	.clk(CLK),
	.rst(RST),
	.enb(IRWrite),
	.A(MEM_ALTERA_SYNTHESIZED),
	.B(INSTR));
	defparam	b2v_inst4.W = 16;


register_WE	b2v_inst5(
	.clk(CLK),
	.rst(RST),
	.enb(enb),
	.A(MEM_ALTERA_SYNTHESIZED[7:0]),
	.B(DATA));
	defparam	b2v_inst5.W = 8;


my_4mux	b2v_inst7(
	.A(DATA),
	.B(Result_ALTERA_SYNTHESIZED),
	.C(PC),
	
	.E(WD3Src),
	.F(WD3));
	defparam	b2v_inst7.W = 8;


my_4mux	b2v_inst8(
	.A(INSTR[8:6]),
	.B(INSTR[10:8]),
	.C(SIX),
	
	.E(RA3Src),
	.F(RA3));
	defparam	b2v_inst8.W = 3;


my_4mux	b2v_inst9(
	.A(INSTR[2:0]),
	.B(INSTR[8:6]),
	.C(SIX),
	.D(INSTR[10:8]),
	.E(RA2Src),
	.F(RA2));
	defparam	b2v_inst9.W = 3;

assign	enb = reg_enb;
assign	alures = ALUResult;
assign	counter = PC;
assign	instruction = INSTR;
assign	mem = MEM_ALTERA_SYNTHESIZED;
assign	rd2 = RD_ALTERA_SYNTHESIZED2;
assign	result = Result_ALTERA_SYNTHESIZED;
assign	shiftd = shifted;

endmodule
