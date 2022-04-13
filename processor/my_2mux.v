module my_2mux #(parameter W=4) (A,B,C,D);
	
	input [W-1:0] A,B;
	input C;
	output reg [W-1:0] D;
// output A if select is 0, else B if select is 1
	always@* 
	begin
		if ( C == 0 )
			D = A;
		else if ( C == 1 )
			D = B;

	end
	
endmodule
