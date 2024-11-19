`timescale 1ns / 1ps

module TB;

    reg Clk, Reset;
    reg [31:0] Data_BUS_READ, Prog_BUS_READ;
    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog, writeBack_out;
    wire CS, WE, CS_P;
    wire [31:0] CS_P_OUT, pc_jmpAddress, pc_branchOffset;
    wire pc_zeroFlag, pc_jmpFlag, branchFlag;

    // Instância do módulo CPU
    cpu dut (
        .Clk(Clk),
        .Reset(Reset),
        .Data_BUS_READ(Data_BUS_READ),
        .Prog_BUS_READ(Prog_BUS_READ),
        .ADDR(ADDR),
        .Data_BUS_WRITE(Data_BUS_WRITE),
        .ADDR_Prog(ADDR_Prog),
        .CS(CS),
        .WE(WE),
        .CS_P(CS_P),
        .writeBack_out(writeBack_out),
        .CS_P_OUT(CS_P_OUT),
        .pc_jmpAddress(pc_jmpAddress),
        .pc_branchOffset(pc_branchOffset),
        .pc_zeroFlag(pc_zeroFlag),
        .pc_jmpFlag(pc_jmpFlag),
        .branchFlag(branchFlag)
    );

    // Inicialização dos sinais
    initial begin
        Clk = 0;
        Reset = 1; // Ativando o reset inicialmente
        Data_BUS_READ = 32'h0; // Inicializando com 0
        Prog_BUS_READ = 32'h0;

        // Liberando o reset após 50 unidades de tempo
        #50 Reset = 0;

        // Simulando algumas operações no barramento
        #100 Data_BUS_READ = 32'h12345678; // Alterando dados do barramento
        #100 Prog_BUS_READ = 32'h87654321; // Alterando dados do programa

        // Tempo adicional para observar o comportamento
        #1000 $stop; // Finaliza a simulação após 500 unidades de tempo
    end

    // Geração de clock com período de 10 unidades de tempo
    always #5 Clk = ~Clk;

    // Monitoramento dos sinais de depuração

endmodule
