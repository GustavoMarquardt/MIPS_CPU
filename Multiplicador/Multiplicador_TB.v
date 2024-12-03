`timescale 1ns/100ps

module Multiplicador_TB();

	reg St, Clk, Reset;
	reg [15:0] Multiplicando;
	reg [15:0] Multiplicador;

	wire Idle, Done; 
	wire [31:0] Produto;

	// Instância do módulo Multiplicador
	Multiplicador DUT (
		.St(St),
		.Clk(Clk),
		.Multiplicando(Multiplicando),
		.Multiplicador(Multiplicador),
		.Idle(Idle),
		.Done(Done),
		.Produto(Produto),
		.Reset(Reset)
	);

	// Geração do clock com período de 40ns
	always #20 Clk = ~Clk;

	// Espionagem de sinais internos para depuração
	initial begin
		$init_signal_spy("/Multiplicador_TB/DUT/U1/estado_atual", "estado_atual", 1);
		$init_signal_spy("/Multiplicador_TB/DUT/U2/intReg", "contagem", 1);
		$init_signal_spy("/Multiplicador_TB/DUT/U2/K", "K", 1);
	end

	// Teste inicial para o módulo Multiplicador
	initial begin
		// Inicialização dos sinais
		Reset = 1;
		Clk = 0;
		St = 0;
		Multiplicando = 16'd496;
		Multiplicador = 16'd255;

		#50;          // Aguarda 50ns
		Reset = 0;    // Libera o reset

		#20;          // Aguarda um ciclo de clock
		St = 1;       // Ativa o início do cálculo

		#40;          // Aguarda dois ciclos de clock
		St = 0;       // Desativa o sinal de início

		// Aguardar o sinal Done indicando o término do cálculo
		wait(Done == 1);

		// Verifica o resultado (pode ser substituído por assert ou outro método)
		$display("Multiplicação concluída:");
		$display("Multiplicando: %d, Multiplicador: %d, Produto: %d", 
			Multiplicando, Multiplicador, Produto);
		
		#500 $stop;        // Finaliza a simulação
	end

endmodule
