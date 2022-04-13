module simple_register #(parameter W = 8) (A,B,clk,rst);
		input [W-1:0] A;
		input clk,rst;
		output reg [W-1:0] B;
		
		always@(posedge clk)
		begin
		// if reset = 1; output is 0
		// else, parallel load is loaded to the output
		if(rst == 1) begin
			B = 0;
		end
		else begin
			B = A;
		end		
		end
endmodule

