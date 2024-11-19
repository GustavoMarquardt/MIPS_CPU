`timescale 1ns / 1ps

module control_TB;

    // Entradas
    reg [31:0] in;

    // Saída
    wire [24:0] out;

    // Sinais internos para verificar cada campo de 'out'
    wire [5:0] operation_code_tb;
    wire [4:0] rs_tb, rt_tb, rd_tb;
    wire WR_regfile_tb, mux_immediate_or_regB_tb, mux2_ALU_tb, WR_mem_tb;
    wire [1:0] ALU_sel_tb;
    wire mul_Start_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb;

    // Instancia o módulo de controle
    control uut (
        .in(in),
        .out(out)
    );

    // Atribui os valores dos campos de saída para facilitar os testes
    assign operation_code_tb = in[31:26];
    assign rs_tb = out[24:20];
    assign rt_tb = out[19:15];
    assign rd_tb = out[14:10];
    assign WR_regfile_tb = out[9];
    assign mux_immediate_or_regB_tb = out[8];
    assign ALU_sel_tb = out[7:6];
    assign mul_Start_tb = out[5];
    assign mux2_ALU_tb = out[4];
    assign WR_mem_tb = out[3];
    assign CS_WB_2_tb = out[2];
    assign branchFlag_tb = out[1];
    assign jmpFlag_tb = out[0];

    // Testes de estímulo
    initial begin
        // Teste 1: Load Word
        in = 32'b100011_00000100100011010001010110; // opcode = 6'b100011 - 32 + 3 = 35
        #10;
        $display("Teste Load Word:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b100011) $display("Erro: operation_code incorreto para Load Word");

        // Teste 2: Store Word
        in = 32'b100100_00000001000011010001010110; // opcode = 6'b101011 33 + 3 = 36
        #10;
        $display("Teste Store Word:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b100100) $display("Erro: operation_code incorreto para Store Word");

        // Teste 3: Branch on Not Equal
        in = 32'b100101_00000000010000000000000001; // opcode = 6'b000101 34 + 3 = 37
        #10;
        $display("Teste Branch on Not Equal:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b100101) $display("Erro: operation_code incorreto para Branch on Not Equal");

        // Teste 4: ADD Immediate
        in = 32'b100110_00000000010000000000000001; // opcode = 6'b001000 35 + 3 = 38
        #10;
        $display("Teste ADD Immediate:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b100110) $display("Erro: operation_code incorreto para ADD Immediate");
		  
		  // Teste 5: Or immediate
        in = 32'b100111_00000000000000000000000100; // opcode = 6'b000010 36 + 3 = 39
        #10;
        $display("Teste Or immediate:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b100111) $display("Erro: operation_code incorreto para Jump");
		  
		  // INSTRUÇÕES DO TIPO R
        // Teste 1: ADD
        in = 32'b001101_00000000000000000000000100; // opcode = 6'b000010 10 + 3
        #10;
        $display("Teste ADD:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b001101) $display("Erro: operation_code incorreto para ADD");
		  
		  // Teste 2: Subtracat
        in = 32'b001110_00000000000000000000000100; // opcode = 6'b000010 10 + 3
        #10;
        $display("Teste Subtract:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b001110) $display("Erro: operation_code incorreto para Subtract");
		  
		  // Teste 3: Multiplication
        in = 32'b001111_00000000000000000000000100; // opcode = 6'b000010 10 + 3
        #10;
        $display("Teste Multiplication:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b001101) $display("Erro: operation_code incorreto para Multiplication");
		  
		   // Teste 4: And
        in = 32'b010000_00000000000000000000000100; // opcode = 6'b000010 10 + 3
        #10;
        $display("Teste And:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b010000) $display("Erro: operation_code incorreto para And");
		  
		  // Teste 5: Or
        in = 32'b010001_00000000000000000000000100; // opcode = 6'b000010 10 + 3
        #10;
        $display("Teste Or:");
        $display("operation_code_tb: %b, rs_tb: %b, rt_tb: %b, rd_tb: %b, WR_regfile_tb: %b, mux_immediate_or_regB_tb: %b, ALU_sel_tb: %b, mul_Start_tb: %b, mux2_ALU_tb: %b, WR_mem_tb: %b, CS_WB_2_tb: %b, branchFlag_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, rs_tb, rt_tb, rd_tb, WR_regfile_tb, mux_immediate_or_regB_tb, ALU_sel_tb, mul_Start_tb, mux2_ALU_tb, WR_mem_tb, CS_WB_2_tb, branchFlag_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b010001) $display("Erro: operation_code incorreto para Or");
		  
		  
		  // Teste 6: Or
        in = 32'b000010_00000000000000000000000100; // opcode = 6'b000010 = 2
        #10;
        $display("Teste para JUMP:");
        $display("operation_code_tb: %b, mux2_ALU_tb: %b, jmpFlag_tb: %b",
                 operation_code_tb, mux2_ALU_tb, jmpFlag_tb);
        if (operation_code_tb !== 6'b000010) $display("Erro: operation_code incorreto para JUMP");
		  
        $finish;
    end
endmodule
