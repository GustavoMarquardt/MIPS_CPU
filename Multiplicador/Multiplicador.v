module Multiplicador
(
	input St, Clk, Reset, // Reset para máquina de estados
	input [15:0] Multiplicando, Multiplicador,
	output Idle, Done,
	output [31:0] Produto
);

	wire Load, Sh, Ad, K;
	wire [16:0] Soma;
	wire [32:0] Saidas;
	
	// Descrição estrutural do multiplicador:
	
	ACC 	  U0(.Saidas(Produto), .Entradas({Soma, Multiplicador}), .Load(Load), .Sh(Sh), .Ad(Ad), .Clk(Clk));
	CONTROL U1(.Idle(Idle), .Done(Done), .Load(Load), .Sh(Sh), .Ad(Ad), .Clk(Clk), .St(St), .K(K), .M(Produto[0]), .Reset(Reset));
	Counter U2(.K(K), .Load(Load), .Clk(Clk));
	Adder   U3(.Soma(Soma), .OperandoA(Multiplicando), .OperandoB(Produto[31:16]));
		
endmodule
