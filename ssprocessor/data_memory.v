module data_memory #(parameter AD_WD = 16, DATA_WD = 32) (clk, address, mem_write, data_in, data_out);

// 100 address spaced data memory

input clk;
input [AD_WD-1:0] address; // input for memory address
input mem_write; // input for enabling write enable
input [DATA_WD-1:0] data_in; // input for data
output [DATA_WD-1:0] data_out; // data output

reg [DATA_WD-1:0] mem [99:0];

initial begin
	$readmemb("D:/Lectures/EE446/Lab3/ssprocessor/data_memory.txt",mem); // memory is read from file
end

// combinational read from the memory 
	assign data_out = mem[address];

// sequential write to the memory
always@(posedge clk)
	if(mem_write)
		mem[address] <= data_in;
endmodule
