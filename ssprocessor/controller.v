module controller (instr,RegSrc,RegWrite,ALUControl,AluSrc,ShiftEnable,MemWrite,MemtoReg,cmp);

// declarations of inputs and output control signals
input[31:0] instr; // 32-bit instruction
// control signals to datapath
output RegSrc,RegWrite,AluSrc,ShiftEnable,MemWrite,cmp;
output reg [1:0] MemtoReg;
output reg [2:0] ALUControl;

// The assumptions are made by looking to the truth tabel in the report

// RegSrc is 1 for STR and CMP
assign RegSrc = (instr[27:26] == 2'b01 && instr[22] == 0 && instr[20] == 0) || (instr[27:26] == 2'b00 && instr[24:20] == 5'b10101);

// RegWrite is 0 for STR and CMP
assign RegWrite = ~RegSrc;

// ALUSource is 1 for memory instructions 
assign AluSrc = (instr[27:26] == 2'b01);

// ShiftEnable is 1 for LSL and LSR
assign ShiftEnable = (instr[27:26] == 2'b00 && instr[25:21] == 5'b01101 && instr[6:5] == 2'b00 && instr[11:4] != 0) 
								|| (instr[27:26] == 2'b00 && instr[25:21] == 5'b01101 && instr[6:5] == 2'b01) ;
								
// MemWrite is 1 for STR
assign MemWrite = (instr[27:26] == 2'b01 && instr[22] == 0 && instr[20] == 0);

// cmp is 1 for CMP
assign cmp = (instr[27:26] == 2'b00 && instr[24:20] == 5'b10101);


//MemtoReg
// 00 for Memory Instructions
// 01 for ADD,SUB,AND,ORR
// 10 for LSL,LSR
always@(*) begin 
	if(instr[27:26] == 2'b01) MemtoReg = 0; // memory
	else if(instr[27:26] == 2'b00) begin // data
		if(instr[24:21] == 4'b0000 || instr[24:21] == 4'b0010 || instr[24:21] == 4'b0100 || instr[24:21] == 4'b1100)
			MemtoReg = 2'b01;
		else if(instr[24:21] == 4'b1101)
			MemtoReg = 2'b10;
	end
	else MemtoReg = 0;
end

//ALUControl
// 000 for LDR,STR,ADD
// 001 for SUB
// 100 for AND
// 101 for ORR
// 010 for CMP
always@(instr) begin
	if(instr[27:26] == 2'b01) ALUControl = 3'b000; // memory
	else if(instr[27:26] == 2'b00) begin  // data
		if(instr[24:21] == 4'b0100) ALUControl = 3'b000; // add
		else if(instr[24:21] == 4'b0010) ALUControl = 3'b001; // sub
		else if(instr[24:21] == 4'b0000) ALUControl = 3'b100; // and
		else if(instr[24:21] == 4'b1100) ALUControl = 3'b101; // orr
		else if(instr[24:21] == 4'b1010) ALUControl = 3'b010; // cmp
	end
end								
endmodule
