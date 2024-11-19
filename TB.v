`timescale 1ns / 1ps
module TB;

    reg Clk, Reset;
    reg [31:0] Data_BUS_READ, Prog_BUS_READ;
    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog, writeBack_out;
    wire CS, WE, CS_P, branchFlag;
    wire [31:0] CS_P_OUT, pc_jmpAddress, pc_branchOffset;
    wire pc_zeroFlag, pc_jmpFlag;
    wire [4:0] reset_count, jump_count, branch_count;

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
        .branchFlag(branchFlag),
        .reset_count(reset_count),   // Conectando as variáveis de contagem
        .jump_count(jump_count),     // Conectando as variáveis de contagem
        .branch_count(branch_count)  // Conectando as variáveis de contagem
    );

    // Inicialização e Clock
    initial begin
        Clk = 0;
        Reset = 1;
        #1 Reset = 0;
        Data_BUS_READ = 32'h0;
        Prog_BUS_READ = 32'h0;

        // Libera o reset após 5 unidades de tempo
        #1000 $stop;  // Termina a simulação após 100 unidades de tempo
    end

    always #5 Clk = ~Clk; // Geração de clock com período de 10 unidades de tempo

    // Monitorando os sinais de depuração
    initial begin
        $monitor("Reset Count: %d, Jump Count: %d, Branch Count: %d", reset_count, jump_count, branch_count);
    end

endmodule
