module registerfile (
	input Clk, we,
	input [4:0] rs, rt, rd,
	input [31:0] in,
	output reg [31:0] outA, outB	
);	
	integer j;
	reg [31:0] register [31:0];
	
	//assign outA = register[rs];
	//assign outB = register[rt];
	
	always @ (posedge Clk)
		begin 
			if(rs == 0)
				outA <= 0;
			else if ( rt == 0)
				outB <= 0;
			else
			begin
				outA <= register[rs];
				outB <= register[rt];
			end
		if (we)
				register[rd] <= in;
	end 
	
	initial
		for(j = 0; j <= 31; j = j+1) begin
				register[j] <= 32'h0;
	end

endmodule
