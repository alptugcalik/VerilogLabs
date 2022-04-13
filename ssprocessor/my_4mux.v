module my_4mux #(parameter W=4) (A,B,C,D,E,F);
	
	input [W-1:0] A,B,C,D;
	input [1:0] E;
	output reg [W-1:0] F;
// output A if select is 00, B if select is 01, C if select is 10, D if select is 11
	always@* 
	begin
		if ( E == 2'b00  )
			F = A;
		else if ( E == 2'b01 )
			F = B;
		else if ( E == 2'b10  )
			F = C;
		else if ( E == 2'b11  )
			F = D;
	end
	
endmodule
