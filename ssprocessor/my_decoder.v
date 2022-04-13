module my_decoder (A,B,O);
	
	input A,B;
	output reg [3:0] O;
	
	initial begin 
	O = 4'b0000;
	end

		// AB select signal generates outputs according to the behavior of a real decoder
	always@* 
	begin
		if ( A == 1'b0 && B == 1'b0 )
			O = 4'b0001;
		else if ( A == 1'b0 && B == 1'b1 )
			O = 4'b0010;
		else if ( A == 1'b1 && B == 1'b0 )
			O = 4'b0100;
		else if ( A == 1'b1 && B == 1'b1 )
			O = 4'b1000;
	end
	
endmodule