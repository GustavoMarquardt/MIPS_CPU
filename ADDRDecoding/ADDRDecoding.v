module ADDRDecoding(
    input [31:0] addr,
    input WE,
    output reg cs, iWE,
    output reg [31:0] iAddress
);
    reg [31:0] sup;
    reg [31:0] inf;

    // Memória interna 6F0h a AEFh
    initial begin
        sup = 32'h00000AEF; // Limite superior
        inf = 32'h000006F0; // Limite inferior
        cs = 0;
        iWE = 0;
        iAddress = 0;
    end

    always @(*) begin
        // Verifica se o endereço está no intervalo permitido
        if (addr >= inf && addr <= sup) begin
            cs = 1;
            iWE = WE; // Habilita escrita se o sinal WE estiver ativo
            iAddress = addr - inf; // Calcula o deslocamento base
        end else begin
            cs = 0;
            iWE = 0;
            iAddress = 0; // Sinais padrão fora do intervalo
        end
    end
endmodule
