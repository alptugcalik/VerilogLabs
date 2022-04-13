module alu #(parameter W=4) (A,B,C,CONTROL,CO,OVF,N,Z);

	input [W-1:0] A,B;
	reg [W-1:0] B_temp,A_temp;
	input [2:0] CONTROL;
	output reg CO,OVF,N,Z;
	output reg [W-1:0] C;
	
	always@* 
	begin 
	if ( CONTROL == 3'b000)
	begin
		{CO,C} = A + B; // ADD 
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS 
		if ( (A[W-1] == B[W-1] ) && (A[W-1] != C[W-1] )) // check the sign bits for ovf
			OVF = 1; // if sign bit is changed , there is ovf
		else 
			OVF = 0; // no change => no ovf
	end
	else if ( CONTROL == 3'b001)
	begin
		B_temp = ~B;
		{CO,C} = A + B_temp + 1'b1; // SUB A-B
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		if ( (A[W-1] != B[W-1] ) && (A[W-1] != C[W-1] )) // check the sign bits for ovf
			OVF = 1;
		else 
			OVF = 0; 
	end
	else if ( CONTROL == 3'b010)
	begin
		A_temp = ~A;
		{CO,C} = B + A_temp + 1'b1; // SUB B-A
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		if ( (A[W-1] != B[W-1] ) && (B[W-1] != C[W-1] )) // check the sign bits for ovf
			OVF = 1; 
		else 
			OVF = 0;
	end
	else if ( CONTROL == 3'b011)
	begin
		C = A & (~B);    // BTC
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		CO = 0; // NO CARRY 
		OVF = 0; // NO OVF
	end
	else if ( CONTROL == 3'b100)
	begin
		C = A & B; 			// AND
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		CO = 0; // NO CARRY
		OVF = 0; // NO OVF
	end
	else if ( CONTROL == 3'b101)
	begin
		C = A | B;			// OR
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		CO = 0; // NO CARRY 
		OVF = 0; // NO OVF
	end
	else if ( CONTROL == 3'b110)
	begin
		C = A ^ B; 			// XOR
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		CO = 0; // NO CARRY 
		OVF = 0; // NO OVF
	end
	else if ( CONTROL == 3'b111)
	begin
		C = ~(A^B);			// XNOR
		N = C[W-1]; // SIGN BIT
		Z = ( C == 0); // ALL ZEROS
		CO = 0; // NO CARRY 
		OVF = 0; // NO OVF
	end
	
	end
	
	
endmodule

