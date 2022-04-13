module controller(rst,instr,clk,PCWrite,AdrSrc,MemW,IRWrite,RA1Src,RA2Src,RA3Src,WD3Src,RegWrite,R7Write,Shift,ALUSrcA,ALUSrcB,ALUControl,ResultSrc,updateFlags,Z,N,V,C,RUN);

input [15:0] instr;
input clk,rst,RUN;
input Z,N,V,C;

output reg PCWrite,AdrSrc,MemW,IRWrite,RA1Src,RegWrite,R7Write,ALUSrcA,updateFlags;
output reg [1:0] RA2Src,RA3Src,WD3Src,ALUSrcB,ResultSrc;
output reg [2:0] Shift,ALUControl;

reg [3:0] state;

/* State Table
* 0000: fetch
* 0001: decode
* 0010: EXEC_D
* 0011: MemAdr
* 0100: MemWrite
* 0101: LDR
* 0110: MemWB
* 0111: ALUWB
* 1000: Branch
* 1001: BranchIndirect
* 1010: BranchLink
* 1011: LDI
* 1100: END
*/

// state transition
always@(posedge clk)
begin
 // if reset
	if(rst == 1) state <= 4'b0000; // go to fetch
	else if (RUN == 1) begin
		// fetch
		if(state == 4'b0000) state <= 4'b0001; // go to decode
		
		// decode
		else if(state == 4'b0001) begin
			// data processing
			if(instr[15:14] == 2'b00) begin
				state <= 4'b0010 ;// go to exec_d
			end
			// memory -register
			else if(instr[15:14] == 2'b01) begin
				// LDR
				if(instr[13:12] == 2'b00) begin
					state <= 4'b0011 ;// go to MemAdr
				end
				// LDI
				else if(instr[13:12] == 2'b01) begin
					state <= 4'b1011 ;// go to LDI
				end
				// STR
				else if(instr[13:12] == 2'b10) begin
					state <= 4'b0011 ;// go to MemAdr
				end
			end
			// branch
			else if(instr[15:14] == 2'b10) begin
				// branch unconditional 
				if(instr[13:11] == 3'b000) begin
					state <= 4'b1000 ;// go to Branch
				end
				// branch with link 
				else if(instr[13:11] == 3'b001) begin
					state <= 4'b1010 ;// go to branchlink
				end
				// branch indirect
				else if(instr[13:11] == 3'b010) begin
					state <= 4'b1001 ;// go to branchindirect
				end
				// branch if equal 
				else if(instr[13:11] == 3'b011) begin
					if(Z == 1) state <= 4'b1000 ;// go to Branch
					else state <= 4'b0000; // go to fetch
				end
				// branch if not equal
				else if(instr[13:11] == 3'b100) begin
					if(Z == 0) state <= 4'b1000 ;// go to Branch
					else state <= 4'b0000; // go to fetch
				end
				// branch if carry is set 
				else if(instr[13:11] == 3'b101) begin
					if(C == 1) state <= 4'b1000 ;// go to Branch
					else state <= 4'b0000; // go to fetch
				end
				// branch if carry is not set 
				else if(instr[13:11] == 3'b110) begin
					if(C == 0) state <= 4'b1000 ;// go to Branch
					else state <= 4'b0000; // go to fetch
				end
			end
		end
		
		// MemAdr
		else if(state == 4'b0011) begin
			if(instr[13:12] == 2'b00) state <= 4'b0101; // go to LDR
			else if(instr[13:12] == 2'b10) state <= 4'b0100; // go to MemWrite
		end
		
		// exec_d
		else if(state == 4'b0010) state <= 4'b0111; // go to ALUWB
		// LDI
		else if(state == 4'b1011) state <= 4'b0000; // go to fetch
		// ALUWB
		else if(state == 4'b0111) state <= 4'b0000; // go to fetch
		// MemWrite
		else if(state == 4'b0100) state <= 4'b0000; // go to fetch
		// LDR
		else if(state == 4'b0101) state <= 4'b0110; // go to MemWB
		// MemWB
		else if(state == 4'b0110) state <= 4'b0000; // go to fetch
		// Branch
		else if(state == 4'b1000) state <= 4'b0000; // go to fetch
		// BranchIndirect
		else if(state == 4'b1001) state <= 4'b0000; // go to fetch
		// BranchLink
		else if(state == 4'b1010) state <= 4'b0000; // go to fetch
	end
end

// control signals
always@(state)
	begin
	// fetch
	if(state == 4'b0000) begin
		PCWrite = 1;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 1;
		RegWrite = 0;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 1;
		ALUSrcB = 2'b10;
		ALUControl = 3'b000;
		ResultSrc = 2'b10;
		updateFlags = 0;
	end
	// decode
	else if(state == 4'b0001) begin
		PCWrite = 0;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		
		// RA1 Source
		if(instr[15:14] == 2'b10) RA1Src = 1; // if branch
		else RA1Src = 0;
		
		// RA2 Source
		if(instr[15:9] == 7'b00000 || instr[15:9] == 7'b00001 || instr[15:9] == 7'b00010 
				|| instr[15:9] == 7'b00011 || instr[15:9] == 7'b00100)  RA2Src = 2'b00; // if data p. except shift
		else if(instr[15:9] == 7'b00101 || instr[15:9] == 7'b00110 || instr[15:9] == 7'b00111 
				|| instr[15:9] == 7'b01000 || instr[15:9] == 7'b01001 || instr[15:9] == 7'b01010) RA2Src = 2'b01; // if shift
		else if(instr[15:14] == 2'b01 && instr[13:12] == 2'b10) RA2Src = 2'b01; // if str
		else if(instr[15:14] == 2'b10 && instr[13:11] == 3'b010) RA2Src = 2'b11; // if bx
		
		// RA3 Source
		if(instr[15:14] == 2'b00 || (instr[15:14] == 2'b01 && instr[13:12] == 2'b00)) RA3Src = 2'b00; // if data p. or ldr
		else if(instr[15:14] == 2'b01 && instr[13:12] == 2'b01) RA3Src = 2'b01; // if LDI
		else if(instr[15:14] == 2'b10 && instr[13:11] == 3'b001) RA3Src = 2'b10; // if BL

		WD3Src = 2'b01;
		RegWrite = 0;
		R7Write = 1;
		Shift = 3'b000;
		ALUSrcA = 1;
		ALUSrcB = 2'b10;
		ALUControl = 3'b000;
		ResultSrc = 2'b10;
		updateFlags = 0;
	end
	// LDR
	else if(state == 4'b0101) begin
		PCWrite = 0;
		AdrSrc = 1;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 0;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		ALUControl = 3'b000;
		ResultSrc = 2'b00;
		updateFlags = 0;
	end
	// LDI
	else if(state == 4'b1011) begin
		PCWrite = 0;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 1;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b01;
		ALUControl = 3'b110;
		ResultSrc = 2'b10;
		updateFlags = 0;
	end
	// exec_d
	else if(state == 4'b0010) begin
		PCWrite = 0;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 0;
		R7Write = 0;
		
		// shift 
		if(instr[13:9] == 5'b00101) 		Shift = 3'b001; // clr
		else if(instr[13:9] == 5'b00110) Shift = 3'b010; // rol
		else if(instr[13:9] == 5'b00111) Shift = 3'b011; // ror
		else if(instr[13:9] == 5'b01000)	Shift = 3'b100; // shl
		else if(instr[13:9] == 5'b01001)	Shift = 3'b101; // asr
		else if(instr[13:9] == 5'b01010) Shift = 3'b110; // lsr
		
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		
		// ALU control
		if(instr[13:9] == 5'b00000) ALUControl = 3'b000; // ADD
		else if(instr[13:9] == 5'b00001) ALUControl = 3'b001; // sub
		else if(instr[13:9] == 5'b00010) ALUControl = 3'b100; // And
		else if(instr[13:9] == 5'b00011) ALUControl = 3'b101; // orr
		else if(instr[13:9] == 5'b00100) ALUControl = 3'b011; // xor
		else if(instr[13:9] == 5'b00101) ALUControl = 3'b110; // clr
		else if(instr[13:9] == 5'b00110) ALUControl = 3'b110; // rol
		else if(instr[13:9] == 5'b00111) ALUControl = 3'b110; // ror
		else if(instr[13:9] == 5'b01000) ALUControl = 3'b110; // shl
		else if(instr[13:9] == 5'b01001) ALUControl = 3'b110; // asr
		else if(instr[13:9] == 5'b01010) ALUControl = 3'b110; // lsr
		
		ResultSrc = 2'b00;
		updateFlags = 1;
	end
	
	// MemAdr
	else if(state == 4'b0011) begin
		PCWrite = 0;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 0;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		ALUControl = 3'b111;
		ResultSrc = 2'b00;
		updateFlags = 0;
	end
	
	// MemWrite
	else if(state == 4'b0100) begin
		PCWrite = 0;
		AdrSrc = 1;
		MemW = 1;
		IRWrite = 0;
		RegWrite = 0;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		ALUControl = 3'b000;
		ResultSrc = 2'b00;
		updateFlags = 0;
	end
	
	// branch
	else if(state == 4'b1000) begin
		WD3Src = 2'b01;
		PCWrite = 1;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 0;
		R7Write = 1;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b01;
		ALUControl = 3'b000;
		ResultSrc = 2'b10;
		updateFlags = 0;
	end
	
	// branchlink
	else if(state == 4'b1010) begin
		WD3Src = 2'b10;
		PCWrite = 1;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 1;
		R7Write = 1;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b01;
		ALUControl = 3'b000;
		ResultSrc = 2'b10;
		updateFlags = 0;
	end
	
	// branch indirect
	else if(state == 4'b1001) begin
		WD3Src = 2'b01;
		PCWrite = 1;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 0;
		R7Write = 1;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		ALUControl = 3'b110;
		ResultSrc = 2'b10;
		updateFlags = 0;
	end
	
	// MemWB
	else if(state == 4'b0110) begin
		WD3Src = 2'b00;
		PCWrite = 0;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 1;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		ALUControl = 3'b000;
		ResultSrc = 2'b00;
		updateFlags = 0;
	end
	
	// ALUWB
	else if(state == 4'b0111) begin
		RA3Src = 2'b00;
		WD3Src = 2'b01;
		PCWrite = 0;
		AdrSrc = 0;
		MemW = 0;
		IRWrite = 0;
		RegWrite = 1;
		R7Write = 0;
		Shift = 3'b000;
		ALUSrcA = 0;
		ALUSrcB = 2'b00;
		ALUControl = 3'b000;
		ResultSrc = 2'b00;
		updateFlags = 0;
	end
end

endmodule
