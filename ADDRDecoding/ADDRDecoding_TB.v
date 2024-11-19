`timescale 1ns/100ps
module ADDRDecoding_TB();

	// Sinais de entrada e saída
	reg [31:0] addr;
	wire cs;
	wire iWE;
	wire [31:0] iAddress;
	integer n;

	// Instanciação do DUT (Device Under Test)
	ADDRDecoding DUT(
		.addr(addr),
		.cs(cs),
		.iWE(iWE),
		.iAddress(iAddress)
	);

	// Testbench
	initial begin
		// Monitoramento de todos os sinais relevantes
		$monitor("Time = %0t, addr = %h, cs = %b, iWE = %b, iAddress = %h", $time, addr, cs, iWE, iAddress);

		// Teste variando o valor de 'addr' de 0x00000000 até 0x00001713
		for (n = 32'h0000; n <= 32'h00001713; n = n + 1) begin
			addr = n;
			#20; // Delay de 20 unidades de tempo
		end
		
		// Teste para endereços fora do intervalo
		addr = 32'h00001800; #20;
		addr = 32'h00002000; #20;
		addr = 32'h00000500; #20;

		// Fim da simulação
		$finish;
	end

endmodule
