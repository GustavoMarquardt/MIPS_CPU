module Counter
(
	input Clk, Load,
	output reg K
);

	reg [7:0] intReg; //Registrador interno
   
   // Para verificar se todas as operações de shift e add foram efetudas
	// deverá ser utilizado o sinal do clock, uma vez que esse bloco
	// tem acesso somente ao sinais Load e Clk.
	// Os operandos possuem 16 bits.
	
	// Descrição comportamental do contador:
	always @(posedge Clk)
	begin
		if (Load) begin
			K <= 0;
			intReg <= 8'b0;
		end
		else if (intReg == 29) 
			K <= 1;
		else
			intReg <= intReg + 1;
	end

endmodule
