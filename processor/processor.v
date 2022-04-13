module processor(clk,rst,DATA,LOAD,COMP,CLR,OP,R0,R1,ERR);

	// inputs for controller module
	input clk,rst,LOAD,COMP,CLR;
	input[2:0] OP;
	input [3:0] DATA;
	// outputs
	output [3:0] R0,R1;
	output ERR;

	
	// wires btw controller and datapath
		// register control signals
		wire RST;
		wire Q_RL,Q_WE,Q_PS,Q_RST;
		wire ACC_RL,ACC_WE,ACC_PS,ACC_RST;
		wire R0_WE,R1_WE;
		wire Q1_WE,Q1_RST;

		// MUX selects
		wire MUX2_SELECT;
		wire [1:0] MUX1_SELECT,MUX3_SELECT,MUX4_SELECT;
		
		// ALU CONTROL
		wire[2:0] ALU_CONTROL;
		
		// wires for booths algorithm
		wire Q,Q1;
		
		// wire for ERR
		wire OVF;
		
	
	// CONTROLLER MODULE
	controller cont(clk,rst,LOAD,COMP,CLR,OP,Q,Q1,Q_RL,ACC_RL,MUX1_SELECT,
	MUX2_SELECT,MUX3_SELECT,MUX4_SELECT,ALU_CONTROL,ACC_PS,Q_PS,
	RST,ACC_RST,Q_RST,R0_WE,R1_WE,ACC_WE,Q_WE,Q1_WE,Q1_RST);
	
	// DATAPATH MODULE
	datapath datap(.clk(clk),.rst(RST),.DATA_IN(DATA),.MUX1_SELECT(MUX1_SELECT)
			,.MUX2_SELECT(MUX2_SELECT),.MUX3_SELECT(MUX3_SELECT),.MUX4_SELECT(MUX4_SELECT),
			.R1_ENB(R1_WE),.R0_ENB(R0_WE),.R0(R0),.R1(R1),.ALU_CONTROL(ALU_CONTROL),
			.Q_PS(Q_PS),.Q_RL(Q_RL),.Q_WE(Q_WE),.Q_RST(Q_RST),
			.ACC_PS(ACC_PS),.ACC_RL(ACC_RL),.ACC_WE(ACC_WE),.ACC_RST(ACC_RST),
			.OVF(OVF),.Qn(Q),.Qn1(Q1),.Q1_RST(Q1_RST),.Q1_WE(Q1_WE));
			
	assign ERR = OVF & COMP;
endmodule
