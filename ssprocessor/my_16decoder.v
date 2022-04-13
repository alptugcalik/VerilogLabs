
module my_16decoder (select,o1);
	
	input[3:0] select;
	output reg [15:0] o1;
	
	initial begin 
	o1 = 4'b0000;
	end

		// AB select signal generates outputs according to the behavior of a real decoder
	always@* 
	begin
		if ( select == 4'b0000  )
			o1 = 16'h1;
		else if ( select == 4'b0001 )
			o1 = 16'h2;
		else if ( select == 4'b0010  )
			o1 = 16'h4;
		else if ( select == 4'b0011  )
			o1 = 16'h8;
		else if ( select == 4'b0100 )
			o1 = 16'h10;
		else if ( select == 4'b0101  )
			o1 = 16'h20;
		else if ( select == 4'b0110  )
			o1 = 16'h40;
		else if ( select == 4'b0111 )
			o1 = 16'h80;
		else if ( select == 4'b1000  )
			o1 = 16'h100;
		else if ( select == 4'b1001 )
			o1 = 16'h200;
		else if ( select == 4'b1010  )
			o1 = 16'h400;
		else if ( select == 4'b1011  )
			o1 = 16'h800;
		else if ( select == 4'b1100 )
			o1 = 16'h1000;
		else if ( select == 4'b1101  )
			o1 = 16'h2000;
		else if ( select == 4'b1110  )
			o1 = 16'h4000;
		else if ( select == 4'b1111 )
			o1 = 16'h8000;
	end
	
endmodule
