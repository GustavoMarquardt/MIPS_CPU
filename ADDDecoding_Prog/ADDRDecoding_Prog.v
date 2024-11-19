module ADDRDecoding_Prog(
    input [31:0] addr,
    output reg CS_P
);

    reg [31:0] sup;
    reg [31:0] inf;

    initial begin
        CS_P = 0;  // Inicializa CS_P para evitar valores indefinidos
    end

    always @(*) begin
        sup = 32'h00001A13; // Define o limite superior
        inf = 32'h000009F0;  // Define o limite inferior (corrigido para 32 bits)

        // Condicional que verifica se o endereço está dentro do intervalo
        if (addr >= inf && addr <= sup) 
            CS_P = 1;  // Dentro do intervalo
        else
            CS_P = 0;  // Fora do intervalo
    end

endmodule
