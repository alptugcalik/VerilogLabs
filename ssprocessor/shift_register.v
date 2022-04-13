module shift_register #(parameter W = 8) (A,B,clk,rst,PSselect,RLselect,SIleft,SIright,enb);
		input [W-1:0] A;
		input clk,rst,PSselect,RLselect,SIleft,SIright,enb;
		output reg [W-1:0] B;
		
		always@(posedge clk)
		begin
		// if reset = 1; output is 0
		if(rst == 1) begin
			B = 0;
		end
		
		// else, parallel load is loaded to the output if the parallel load is choosen
		else begin
			if(enb == 1) begin
				if(PSselect == 1) begin
					B = A;
				end
				// if serial, look the direction and shift accordingly
				else begin
					if(RLselect == 1) begin
						B = {SIleft,B[W-1:1]};
					end
					else begin
						B = {B[W-2:0],SIright};
					end
				end
			end
		end		
		end
endmodule

