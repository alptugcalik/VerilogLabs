module constant_value #(parameter W=8, V=0) (A);

	output reg [W-1:0] A; // output bus
	
	always@* 
	begin
	A = V; // GENERATE BINARY EQUIVALENT OF DECIMAL PARAMETER
	end
	
endmodule
