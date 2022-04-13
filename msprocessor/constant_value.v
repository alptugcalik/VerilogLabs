module constant_value #(parameter W=8, V=0) (A);

	output [W-1:0] A; // output bus
	
	assign A = V;
	
endmodule
