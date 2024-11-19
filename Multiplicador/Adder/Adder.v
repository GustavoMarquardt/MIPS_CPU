module Adder (
	input [15:0] OperandoA, OperandoB,
	output [16:0] Soma
);

// Descrição utilizando o nível de abstração de fluxo de dados:
assign Soma = OperandoA + OperandoB;
	
endmodule
