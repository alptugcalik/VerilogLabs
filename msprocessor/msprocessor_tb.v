module msprocessor_tb ();

	reg clk,rst,run;
	
	wire C,Z,N,V;
	wire [7:0] ALUB,ALUA,RD2;
	wire [7:0] PC,ALUResult,Result,ShiftOut;
	wire [15:0] MemoryRead,instr;

	reg [5:0] vectornum;
	
	initial begin
	vectornum = 0;
	rst = 1;
	run = 1;
	end
	
	msprocessor dut(.clk(clk),.C(C),.Z(Z),.N(N),.V(V),.PC(PC),.ALUResult(ALUResult)
				,.Result(Result),.ShiftOut(ShiftOut),.MemoryRead(MemoryRead),.ALUB(ALUB),.ALUA(ALUA),.RESET(rst),.INSTR(instr),.RUN(run),.RD2(RD2));
	
	// clock generation
	always
		begin
		clk = 1; #5; 
		rst=0;
		clk = 0; #5; 
		end

	// increase vectornum
	always @(negedge clk)
	begin
	vectornum = vectornum + 1;
	if (vectornum == 35)	$stop;
	end
		
endmodule

