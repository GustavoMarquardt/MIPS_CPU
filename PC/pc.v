module pc(
    input Clk, Reset, zeroFlag, jmpFlag, branchFlag,
    input [31:0] branchOffset, jmpAddress,
    output reg [31:0] addr,
    output reg resetControl
);
    // Processo sensível ao clock e ao reset
    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            addr <= 32'h9F0; // Reset para o endereço inicial
            resetControl <= 0; // Reset também desativa o controle
        end
        else if (jmpFlag) begin
            addr <= jmpAddress + 32'h9F0; // Jump para endereço imediato
            resetControl <= 0; // Nenhum reset necessário
        end
        else if (branchFlag && !zeroFlag) begin   // B = 1, zero = 0
            addr <= addr + $signed(branchOffset) - 4; // Offset assinado
            resetControl <= 1; // Reset ativado
        end
        else begin
            addr <= addr + 4; // Incremento padrão
            resetControl <= 0; // Reset desativado
        end
    end
endmodule
