module extender (Imm, ExtImm);
// it should be noted that Imm number is assumed as maximum of 12 bits
input [11:0] Imm;
output [31:0] ExtImm;

// combinational extender
assign ExtImm = {20'b0,Imm};

endmodule
