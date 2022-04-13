module memory (clk, address, mem_write, data_in, data_out);

// 100 address spaced data memory

input clk;
input [7:0] address; // input for memory address
input mem_write; // input for enabling write enable
input [7:0] data_in; // input for data
output [15:0] data_out; // data output

reg [15:0] mem [63:0];

initial begin
	$readmemb("D:/Lectures/EE446/Lab5/msprocessor/memory_even.txt",mem); // memory is read from file
end

// combinational read from the memory 
	assign data_out = mem[address];

// sequential write to the memory
always@(posedge clk)
	if(mem_write)
		mem[address][7:0] <= data_in;
endmodule
