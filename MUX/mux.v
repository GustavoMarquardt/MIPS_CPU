module mux (
    input wire [31:0] a,       // Entrada 0
    input wire [31:0] b,       // Entrada 1
    input wire sel,     // Sinal de seleção
    output wire [31:0] out     // Saída
);

    assign out = (sel) ? b : a;

endmodule
