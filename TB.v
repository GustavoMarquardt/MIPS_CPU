module TB_pc;

    // Declaração dos sinais
    reg Clk, Reset, zeroFlag, jmpFlag, branchFlag;
    reg [31:0] branchOffset, jmpAddress;
    wire [31:0] addr;
    wire [4:0] reset_count, jump_count, branch_count, increment_count;

    // Instância do módulo pc
    pc uut (
        .Clk(Clk),
        .Reset(Reset),
        .zeroFlag(zeroFlag),
        .jmpFlag(jmpFlag),
        .branchFlag(branchFlag),
        .branchOffset(branchOffset),
        .jmpAddress(jmpAddress),
        .addr(addr),
        .reset_count(reset_count),
        .jump_count(jump_count),
        .branch_count(branch_count),
        .increment_count(increment_count)
    );

    // Inicialização dos sinais
    initial begin
        Clk = 0;
        Reset = 1;
        zeroFlag = 0;
        jmpFlag = 0;
        branchFlag = 0;
        branchOffset = 32'h4;  // Definindo um valor para o offset do branch
        jmpAddress = 32'h1000; // Definindo um endereço para o jump

        // Libera o reset após 50 unidades de tempo
        #50 Reset = 0;
        #50 jmpFlag = 1; // Ativando o jump
        #50 jmpFlag = 0; // Desativando o jump

        // Ativando o branch
        #50 branchFlag = 1;
        #50 zeroFlag = 1; // Mantendo zeroFlag em 1 para não fazer branch
        #50 branchFlag = 0;

        // Ativando o branch com zeroFlag 0 para permitir o branch
        #50 zeroFlag = 0;
        #50 branchFlag = 1;

        // Tempo para observar o funcionamento
        #400 $stop;  // Termina a simulação após 400 unidades de tempo
    end

    // Geração de clock (período de 10 unidades de tempo)
    always #5 Clk = ~Clk;

    // Monitoramento dos sinais
    initial begin
        $monitor("Time = %0t, addr = %h, reset_count = %d, jump_count = %d, branch_count = %d, increment_count = %d",
                 $time, addr, reset_count, jump_count, branch_count, increment_count);
    end

endmodule
