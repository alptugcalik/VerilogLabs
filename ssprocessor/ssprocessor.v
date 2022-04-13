module ssprocessor(clk,rst,rd1,rd2,result,alu_op,alu_result,CMPFlag,PC);

// input and output declerations 
input clk,rst;
// to show the work, the following outputs are shown at waveform
output[31:0] rd1,rd2,result,alu_result;
output CMPFlag;
output [2:0] alu_op;
output[31:0] PC;

// wires to connect datapath and controller
wire[31:0] instr;
wire RegSrc,RegWrite,AluSrc,ShiftEnable,MemWrite,cmp;
wire [2:0] ALUControl;
wire [1:0] MemtoReg;

assign alu_op = ALUControl; // assign alu operation

// create controller module
controller cont(instr,RegSrc,RegWrite,ALUControl,AluSrc,ShiftEnable,MemWrite,MemtoReg,cmp);
// create datapath module
datapath(.RegSrc(RegSrc),.RegWrite(RegWrite),.ALUControl(ALUControl),.AluSrc(AluSrc),.ShiftEnable(ShiftEnable)
			,.MemWrite(MemWrite),.MemtoReg(MemtoReg),.cmp(cmp),.Instr(instr),.clk(clk),.rst(rst)
				,.RD1(rd1),.RD2(rd2),.Result(result),.ALUResult(alu_result),.counter(PC),.COMPFlag(CMPFlag));

endmodule
