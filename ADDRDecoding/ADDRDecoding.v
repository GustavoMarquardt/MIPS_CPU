module ADDRDecoding(
	input [31:0] addr,
	input WE,
	output reg cs, iWE,
	output reg [31:0]  iAddress
);
	reg [31:0] sup;
	reg [31:0] inf;
	
	//Memoria interna 6F0h a 1713h
	
	initial begin
    sup = 32'h00001713;
    inf = 32'h000006F0;
	end

	always @ (*)
	begin
		if(addr[31:0] >= inf) 
		begin
			if(addr[31:0] <= sup)
				begin
					cs = 1;
					iWE = 0;
					iAddress = addr - 32'h000006F0;
				end
			else 
				begin
					cs = 0;
					iWE = 0;
					iAddress = 0;
				end
		end
		else 
			begin
				cs = 0;
				iWE = 0;
				iAddress = 0;
			end
	end 
	
endmodule 

