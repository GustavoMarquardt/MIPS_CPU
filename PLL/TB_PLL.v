`timescale 1ns/1ps

module TB_PLL;

    // Declaração de sinais
    reg inclk0;         // Clock de entrada
    wire c0;            // Clock multiplicado (saída)
    wire c1;            // Clock do sistema (saída)

    // Instância do DUT (Design Under Test)
    PLL dut (
        .inclk0(inclk0),
        .c0(c0),
        .c1(c1)
    );

    // Geração do clock de entrada (inclk0)
    initial begin
        inclk0 = 1'b0;           // Inicializa em 0
        forever #10 inclk0 = ~inclk0; // Gera um clock de 50MHz (período de 20ns)
    end

    // Monitoramento das saídas
    initial begin
        $monitor("Time: %0t | inclk0: %b | c0: %b | c1: %b", 
                 $time, inclk0, c0, c1);
    end

    // Finalização da simulação
    initial begin
        #200; // Simula por 200ns
        $finish;
    end

endmodule
