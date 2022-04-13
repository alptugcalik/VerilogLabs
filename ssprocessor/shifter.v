module shifter (shamt5, sh, data, sh_data, enable);
// 32 bit shifter module
input enable; // enable shifts
input [4:0] shamt5; // shift amount
input [1:0] sh; // shift type
input [31:0] data; // 32 bit data input
output reg [31:0] sh_data; // shifted data

always@* begin
	if(enable == 0)
		sh_data <= data; // no shift
	else begin
		if(sh == 2'b00)
			sh_data = data << shamt5; // lsl
		else if(sh == 2'b01)
			sh_data = data >> shamt5; // lsr 
	end
end
endmodule 
