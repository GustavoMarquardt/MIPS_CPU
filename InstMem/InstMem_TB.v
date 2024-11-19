`timescale 1ns / 1ps

module  InstMem_TB;

  // Definir os sinais de entrada
  reg [9:0] address;   // 10 bits para o endereço (porque numwords_a = 1024)
  reg clock;            // Relógio

  // Definir o sinal de saída
  wire [31:0] q;        // Saída de 32 bits

  // Instancia o módulo InstMem
  InstMem uut (
    .address(address),
    .clock(clock),
    .q(q)
  );

  // Gerador de relógio (clock)
  always begin
    #5 clock = ~clock; // Clock com período de 10 unidades de tempo
  end

  // Inicialização do testbench
  initial begin
    // Inicializar sinais
    clock = 0;
    address = 10'd0;

    // Monitorar as saídas
    $monitor("Time = %0t | Address = %h | Data = %h", $time, address, q);

    // Teste: Ler várias localizações da memória ROM
    #10 address = 10'd0;   // Endereço 0
    #10 address = 10'd1;   // Endereço 1
    #10 address = 10'd2;   // Endereço 2
    #10 address = 10'd3;   // Endereço 3
    #10 address = 10'd4;   // Endereço 4

    // Teste adicional para verificar maior intervalo de endereços
    #10 address = 10'd10;  // Endereço 10
    #10 address = 10'd20;  // Endereço 20
    #10 address = 10'd100; // Endereço 100
    #10 address = 10'd500; // Endereço 500
    #10 address = 10'd1023;// Último endereço (1023)

    // Finaliza a simulação
    #10 $finish;
  end

endmodule
