module CONTROL
(
	input Clk, St, K, M, Reset, // Reset para máquina de estados
	output Idle, Done, Load, Sh, Ad
);

	// Registrador de estados
	reg	[1:0] estado_atual;
	
	// Codificação dos estados
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
	
	// Vetor auxilar para simplificar a codificação da lógica de saída.
	reg	[4:0] auxiliar;
	
	// Cada posição de "auxiliar" representa o valor de uma determinada saída:
	assign Done = auxiliar[4];
	assign Sh = auxiliar[3];
	assign Ad = auxiliar[2];
	assign Load = auxiliar[1];
	assign Idle = auxiliar[0];
	
	// Saídas da máquina de estados
	always @ (estado_atual, M, St) 
	begin
		case (estado_atual)
			S0:
				if(St)
					auxiliar = 5'b00010;
				else
					auxiliar = 5'b00001;
			S1:
				if(M)
					auxiliar = 5'b00100;
				else
					auxiliar = 5'b00000;
			S2:
				auxiliar = 5'b01000;
			S3:
				auxiliar = 5'b10000;
			default: // Apesar de varrer todas as possibilidades, foi utilizado o default por segurança	
				auxiliar = 5'b00001;
		endcase
	end

	// Lógica de estado seguinte
	always @ (posedge Clk, posedge Reset) 
	begin
		if(Reset)
			estado_atual <= S0;
		else
			case (estado_atual)
				S0:
					if(St) 
						estado_atual <= S1;
					else 
						estado_atual <= S0;
				S1:	
					estado_atual <= S2;
				S2:
					if (K)
						estado_atual <= S3;
					else
						estado_atual <= S1;
				S3:
					estado_atual <= S0;
				default: // Apesar de varrer todas as possibilidades, foi utilizado o default por segurança	
					estado_atual <= S0;
			endcase
	end
	
endmodule
