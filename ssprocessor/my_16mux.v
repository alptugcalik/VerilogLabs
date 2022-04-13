module my_16mux #(parameter W=4) (i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,select,o1);
	
	input [W-1:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15;
	input [3:0] select;
	output reg [W-1:0] o1;

	always@* 
	begin
		if ( select == 4'b0000  )
			o1 = i0;
		else if ( select == 4'b0001 )
			o1 = i1;
		else if ( select == 4'b0010  )
			o1 = i2;
		else if ( select == 4'b0011  )
			o1 = i3;
		else if ( select == 4'b0100 )
			o1 = i4;
		else if ( select == 4'b0101  )
			o1 = i5;
		else if ( select == 4'b0110  )
			o1 = i6;
		else if ( select == 4'b0111 )
			o1 = i7;
		else if ( select == 4'b1000  )
			o1 = i8;
		else if ( select == 4'b1001 )
			o1 = i9;
		else if ( select == 4'b1010  )
			o1 = i10;
		else if ( select == 4'b1011  )
			o1 = i11;
		else if ( select == 4'b1100 )
			o1 = i12;
		else if ( select == 4'b1101  )
			o1 = i13;
		else if ( select == 4'b1110  )
			o1 = i14;
		else if ( select == 4'b1111 )
			o1 = i15;
	end
	
endmodule
