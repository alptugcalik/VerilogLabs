module controller(clk,rst,LOAD,COMP,CLR,OP,Q,Q1,Q_RL,ACC_RL,MUX1_SELECT,
	MUX2_SELECT,MUX3_SELECT,MUX4_SELECT,ALU_CONTROL,ACC_PS,Q_PS,
	RST,ACC_RST,Q_RST,R0_WE,R1_WE,ACC_WE,Q_WE,Q1_WE,Q1_RST
);

	// inputs for controller module
	input clk,rst,LOAD,COMP,CLR,Q,Q1;
	input[2:0] OP;
	
	// outputs of controller module
	// register control signals
	output reg RST;
	output reg Q_RL,Q_WE,Q_PS,Q_RST;
	output reg ACC_RL,ACC_WE,ACC_PS,ACC_RST;
	output reg R0_WE,R1_WE;
	output reg Q1_WE,Q1_RST;

	// MUX selects
	output reg MUX2_SELECT;
	output reg [1:0] MUX1_SELECT,MUX3_SELECT,MUX4_SELECT;
	
	// ALU CONTROL
	output reg[2:0] ALU_CONTROL;
	
	// sequence counter for multiplication
	reg[1:0] SC;
	
	// state register
	reg[1:0] state;
	
	
	// state decision at each posedge of clock
	always@(posedge clk)
	begin
		if(rst) begin
			state <= 2'b00; // go to idle state if rst
		end
		else begin
			// state 0 (idle)
			if(state == 2'b00) begin
				if(CLR) state <= 2'b00; // go to idle again if clr
				else begin
					if(LOAD) state <= 2'b00; // go to idle again if load
					else begin
						if(COMP == 0) state <= 2'b00; // go to idle again if no comp
						else begin
							if(OP == 3'b010) begin
								state <= 2'b01; // go to state 1 if multiplication
								SC <= 2'b11; // Set sc as 3
							end
							else begin
								state <= 2'b00; // go to idle again if no multiplication
							end
						end
					end
				end
			end
			// state 1
			else if(state == 2'b01) begin
				state <= 2'b10; // go to state 2 with no condition
			end
			// state 2
			else if(state == 2'b10) begin
				if(SC == 2'b00) state <= 2'b11; // go to state 3 if SC is 0
				else begin
					state <= 2'b01; // go to state 1 else
				end
				SC <= SC - 1; // decrement sc
			end
			// state 3
			else if(state == 2'b11) begin
				state <= 2'b00; // go to state 0(idle) with no condition
			end
			
		end
	end
	
	// control signal decisions 
	always@(state,CLR,LOAD,COMP,OP)
	begin
	// STATE 0
	if(state == 2'b00) begin
		if(CLR == 1) RST = 1; // clr operation
		else begin
			RST = 0;
			if(LOAD == 1) begin // load operation
				MUX1_SELECT = 2'b01;
				MUX4_SELECT = 2'b00;
				R0_WE = 1;
				R1_WE = 1;
			end
			else begin
				if(COMP == 1) begin // comp operation
				// ADD 
					if(OP == 3'b000) begin
						MUX1_SELECT = 2'b00;
						MUX2_SELECT = 0;
						MUX3_SELECT = 2'b00;
						MUX4_SELECT = 2'b11;
						ALU_CONTROL = 3'b000;
					end
				// SUBTRACT
					else if(OP == 3'b001) begin
						MUX1_SELECT = 2'b00;
						MUX2_SELECT = 0;
						MUX3_SELECT = 2'b00;
						MUX4_SELECT = 2'b11;
						ALU_CONTROL = 3'b001;
					end
				// AND
					else if(OP == 3'b100) begin
						MUX1_SELECT = 2'b00;
						MUX2_SELECT = 0;
						MUX3_SELECT = 2'b00;
						MUX4_SELECT = 2'b11;
						ALU_CONTROL = 3'b100;
					end
				// OR
					else if(OP == 3'b101) begin
						MUX1_SELECT = 2'b00;
						MUX2_SELECT = 0;
						MUX3_SELECT = 2'b00;
						MUX4_SELECT = 2'b11;
						ALU_CONTROL = 3'b101;
					end
				// EXOR
					else if(OP == 3'b110) begin
						MUX1_SELECT = 2'b00;
						MUX2_SELECT = 0;
						MUX3_SELECT = 2'b00;
						MUX4_SELECT = 2'b11;
						ALU_CONTROL = 3'b110;
					end
				// BTC
					else if(OP == 3'b111) begin
						MUX1_SELECT = 2'b00;
						MUX2_SELECT = 0;
						MUX3_SELECT = 2'b00;
						MUX4_SELECT = 2'b11;
						ALU_CONTROL = 3'b011;
					end
				// MULTIPLY
					else if(OP == 3'b010) begin
						MUX2_SELECT = 1;
						MUX3_SELECT = 2'b00;
						ALU_CONTROL = 3'b000;
						Q1_RST = 1;
						ACC_RST = 1;
						Q_WE = 1;
						Q_PS = 1;
						R0_WE = 0;
						R1_WE = 0;
					end
				end				
			end		
		end
	end	
	// STATE 1
	else if(state == 2'b01) begin
		Q1_RST = 0;
		ACC_RST = 0;
		if({Q,Q1} == 2'b00 || {Q,Q1} == 2'b11) begin
			ACC_WE = 0;
			Q_WE = 0;
		end
		else if({Q,Q1} == 2'b10) begin
			MUX2_SELECT = 0;
			MUX3_SELECT = 2'b10;
			ALU_CONTROL = 3'b010;
			ACC_PS = 1;
			ACC_WE = 1;
			Q_WE = 0;
		end
		else if({Q,Q1} == 2'b01) begin
			MUX2_SELECT = 0;
			MUX3_SELECT = 2'b10;
			ALU_CONTROL = 3'b000;
			ACC_PS = 1;
			ACC_WE = 1;
			Q_WE = 0;
		end
	end
	// STATE 2
	else if(state == 2'b10) begin
		ACC_WE = 1;
		ACC_PS = 0;
		ACC_RL = 1;
		Q_WE = 1;
		Q_PS = 0;
		Q_RL = 1;
		Q1_WE=1;
	end
	// STATE 3
	else if(state == 2'b11) begin
		R0_WE = 1;
		R1_WE = 1;
		MUX1_SELECT = 2'b10;
		MUX4_SELECT = 2'b01;
	end
	end
	
endmodule

