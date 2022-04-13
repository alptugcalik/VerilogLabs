module register_file #(parameter W=8) (din1,Rn,Rm,Rd,wrt,rst,clk,dout1,dout2);

	input [W-1:0] din1;
	input [3:0] Rn,Rm,Rd;
	input rst,wrt,clk;
	output [W-1:0] dout1,dout2;
	
	wire [15:0] enb;
	wire [W-1:0] w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16;
	
	// registers are wired with the corrsponding enable signals
	register_WE #(W) reg1 (din1,w1,clk,rst,enb[15]&wrt);
	register_WE #(W) reg2 (din1,w2,clk,rst,enb[14]&wrt);
	register_WE #(W) reg3 (din1,w3,clk,rst,enb[13]&wrt);
	register_WE #(W) reg4 (din1,w4,clk,rst,enb[12]&wrt);
	register_WE #(W) reg5 (din1,w5,clk,rst,enb[11]&wrt);
	register_WE #(W) reg6 (din1,w6,clk,rst,enb[10]&wrt);
	register_WE #(W) reg7 (din1,w7,clk,rst,enb[9]&wrt);
	register_WE #(W) reg8 (din1,w8,clk,rst,enb[8]&wrt);
	register_WE #(W) reg9 (din1,w9,clk,rst,enb[7]&wrt);
	register_WE #(W) reg10 (din1,w10,clk,rst,enb[6]&wrt);
	register_WE #(W) reg11 (din1,w11,clk,rst,enb[5]&wrt);
	register_WE #(W) reg12 (din1,w12,clk,rst,enb[4]&wrt);
	register_WE #(W) reg13 (din1,w13,clk,rst,enb[3]&wrt);
	register_WE #(W) reg14 (din1,w14,clk,rst,enb[2]&wrt);
	register_WE #(W) reg15 (din1,w15,clk,rst,enb[1]&wrt);
	register_WE #(W) reg16 (din1,w16,clk,rst,enb[0]&wrt);
	
	// mux's chooses which register will be on output wires
	my_16mux #(W) mux1 (w16,w15,w14,w13,w12,w11,w10,w9,w8,w7,w6,w5,w4,w3,w2,w1,Rn,dout1);
	my_16mux #(W) mux2 (w16,w15,w14,w13,w12,w11,w10,w9,w8,w7,w6,w5,w4,w3,w2,w1,Rm,dout2);
	
	// write enable signals are choosen according to the Rd value
	my_16decoder dec1 (Rd,enb);
	
	
endmodule
