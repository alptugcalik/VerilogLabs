module register_WE #(parameter W = 8) (A,B,clk,rst,enb);
		input [W-1:0] A;
		input clk,rst,enb;
		output reg [W-1:0] B;
		
		always@(posedge clk)
		begin
		// if reset = 1; output is 0
		// else, parallel load is loaded to the output with the condiiton write enable
		if(rst == 1) begin
			B = 0;
		end
		else begin
			if(enb == 1) begin
				B = A;
			end
		end		
		end
endmodule

