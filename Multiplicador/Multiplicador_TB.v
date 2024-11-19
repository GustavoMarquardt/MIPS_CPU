`timescale 1ns/100ps

module Multiplicador_TB();

	reg St, Clk, Reset;
	reg [15:0]Multiplicando;
	reg [15:0]Multiplicador;
	
	wire Idle, Done; 
	wire [31:0]Produto;
	
	//Multiplicador(Idle, Done, Produto, St, Clk, Multiplicador, Multiplicando, Reset);
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
	
	always #20 Clk = ~Clk;

		// Comandos para exibição do estado dos fios internos
	initial   begin
		$init_signal_spy("/Multiplicador_TB/DUT/U1/estado_atual", "estado_atual", 1);
		$init_signal_spy("/Multiplicador_TB/DUT/U2/intReg", "contagem", 1);
		$init_signal_spy("/Multiplicador_TB/DUT/U2/K", "K", 1);
	end
	
	// Teste e verificação de todas as possibilidades de multiplicação
	integer i, j;

	initial begin
		// Valores iniciais
		Reset = 1;
		Clk = 0;
		St = 0;
		Multiplicando = 16'b0;
		Multiplicador = 16'b0;
		#50 Reset = 0;
		
		// Todas as possibilidades
		for(i = 0; i <= 15; i = i + 1) begin
		
			Multiplicador = i[15:0];
			
			for(j = 0; j <= 15; j = j + 1) begin
				Multiplicando = j[15:0];
				St = 1;
				#80 St = 0;
				
				// Impressão de informações sobre a multiplicação no display do ModelSim:
				#1360 $display("Multiplicador = ", Multiplicador, " Multiplicando = ", Multiplicando, ", Mult = ", Produto);
				if(Produto == Multiplicador*Multiplicando)
					$display("RESULTADO CORRETO");
				else
					$display("RESULTADO INCORRETO");
			end
		end
		
		$stop;
	end
endmodule 