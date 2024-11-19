module pc(
    input Clk, Reset, zeroFlag, jmpFlag, branchFlag,
    input [31:0] branchOffset, jmpAddress,
    output reg [31:0] addr,
    output reg [4:0] reset_count,    // Contador de Reset
    output reg [4:0] jump_count,     // Contador de Jump
    output reg [4:0] branch_count,   // Contador de Branch
    output reg [4:0] increment_count // Contador de Incremento
);
    // Processo sensível ao clock e ao reset
    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            addr <= 32'h9F0; // Endereço inicial definido pelo Reset
            reset_count <= reset_count + 1; // Incrementa contador do reset
        end
        else if (jmpFlag) begin
            addr <= jmpAddress; // Se o jump for acionado, o endereço vai para jmpAddress
            jump_count <= jump_count + 1; // Incrementa contador do jump
        end
        else if (branchFlag && !zeroFlag) begin
            addr <= addr + 4 + branchOffset; // Operação de Branch
            branch_count <= branch_count + 1; // Incrementa contador do branch
        end
        else begin
            addr <= addr + 4; // Incremento padrão
            increment_count <= increment_count + 1; // Incrementa contador do incremento
        end
    end
endmodule
