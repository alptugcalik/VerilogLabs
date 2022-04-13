module msprocessor(clk,C,Z,N,V,PC,ALUResult,Result,ShiftOut,MemoryRead,ALUB,ALUA,RESET,RUN,INSTR,RD2);

input clk, RESET, RUN; 

output C,Z,N,V;
output [7:0] ALUB,ALUA;
output [7:0] PC,ALUResult,Result,ShiftOut, RD2;
output [15:0] MemoryRead,INSTR;

wire [15:0] inst;
wire PCWrite,AdrSrc,MemW,IRWrite,RA1Src,RegWrite,R7Write,ALUSrcA,updateFlags;
wire [1:0] RA2Src,RA3Src,WD3Src,ALUSrcB,ResultSrc;
wire [2:0] Shift,ALUControl;

assign INSTR = inst;

datapath dpt(.CLK(clk),.RST(RESET),.PCWrite(PCWrite&RUN),.AdrSrc(AdrSrc),.MemW(MemW&RUN),.IRWrite(IRWrite&RUN),
				.RA1Src(RA1Src),.RA2Src(RA2Src),.RA3Src(RA3Src),.WD3Src(WD3Src),
					.RegWrite(RegWrite&RUN),.R7Write(R7Write&RUN),.shift(Shift),.ALUSrcA(ALUSrcA),
						.ALUSrcB(ALUSrcB),.ALUControl(ALUControl),.ResultSrc(ResultSrc),.C(C),.Z(Z),
							.N(N),.V(V),.counter(PC),.alures(ALUResult),.result(Result),.shiftd(ShiftOut),
								.mem(MemoryRead),.updateFlags(updateFlags),.ALUB(ALUB),.ALUA(ALUA),.reg_enb(RUN),.instruction(inst),.rd2(RD2));
								
controller cont(.rst(RESET),.clk(clk),.PCWrite(PCWrite),.AdrSrc(AdrSrc),.MemW(MemW),.IRWrite(IRWrite),
				.RA1Src(RA1Src),.RA2Src(RA2Src),.RA3Src(RA3Src),.WD3Src(WD3Src),
					.RegWrite(RegWrite),.R7Write(R7Write),.Shift(Shift),.ALUSrcA(ALUSrcA),
						.ALUSrcB(ALUSrcB),.ALUControl(ALUControl),.ResultSrc(ResultSrc),.updateFlags(updateFlags),.instr(inst),
							.C(C),.Z(Z),.N(N),.V(V),.RUN(RUN));

endmodule
