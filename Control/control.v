
module control(
	input [31:0] in,
	output [24:0] out
);	
	// Grupo 3 
	reg [5:0] operation_code, operation;
	reg [4:0] rs, rt, rd;
	
	reg [1:0] ALU_sel;
	reg mul_Start, mux_immediate_or_regB, mux2_ALU;
	reg WR_mem, CS_WB_2, WR_regfile;
	reg jmpAdress; // Defina a quantidade de bits, se necessário
	reg jmpFlag, branchFlag;
	
	assign out = {
		rs, 			// Primeiro registrador
		rt, 			// Segundo para R ou destino para I
		rd, 			// Destino para R
		WR_regfile, 	// Leitura ou escrita do regFile
		mux_immediate_or_regB, // MUX para escolher entre REG B ou Immediate
		ALU_sel,		// ALU: 00 = +, 01 = -, 10 = &, 11 = |
		mul_Start,		// Controle para iniciar uma multiplicação  
		mux2_ALU, 		// Seleção entre Soma ou Multiplicação
		WR_mem, 		// Write/Read na memória dataMemory
		CS_WB_2, 		// Write Back 2 entre D e saída do mux 1
		branchFlag, 	// Flag de Branch
		jmpFlag 		// Flag de Jump
		};
		
	always @ (in) 
	begin
		operation_code = in[31:26]; // 6 bits mais significativos para identificar a operação
		rs = in[25:21]; // Primeiro registrador fonte
		rt = in[20:16]; // Segundo registrador Fonte ou destino para instruções I
		operation = in[5:0];
		
		case(operation_code)
			6'h23: // Load Word
			begin
				ALU_sel = 2'b00;
				rd = rt;
				WR_regfile = 1;
				WR_mem = 0;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 1;
				jmpFlag = 0;
				branchFlag = 0;
			end

			6'h24: // Store Word
			begin
				ALU_sel = 2'b00;
				rd = rs;
				WR_regfile = 0;
				WR_mem = 1;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 0;
				branchFlag = 0;
			end

			6'h26: // Branch on Not Equal
			begin
				ALU_sel = 2'b01;
				rd = 5'b0; // Registro de destino é irrelevante em um branch
				WR_regfile = 0;
				WR_mem = 0;
				mux_immediate_or_regB = 0;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 0;
				branchFlag = 1;
			end

			6'h25: // ADD Immediate
			begin  
				ALU_sel = 2'b00;
				rd = rt;
				WR_regfile = 1;
				WR_mem = 0;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 0;
				branchFlag = 0;
			end

			6'h02: // Jump (exemplo de uso da flag jmpFlag)
			begin
				ALU_sel = 2'b00;
				rd = 5'b0;
				WR_regfile = 0;
				WR_mem = 0;
				mux_immediate_or_regB = 0;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 1; // Ativa a flag de jump
				branchFlag = 0;
			end

			default: 
			begin
				case(operation)
					6'h20: // ADD R
					begin
						ALU_sel = 2'b00;
						rd = rd;
						WR_regfile = 1;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'h22: // SUB R
					begin
						ALU_sel = 2'b01;
						rd = rd;
						WR_regfile = 1;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'h32: // MULT R
					begin
						ALU_sel = 2'bxx; // Tanto faz
						rd = rd;
						WR_regfile = 1;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'h24: // AND R
					begin
						ALU_sel = 2'b10;
						rd = rd;
						WR_regfile = 1;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'h25: // OR R
					begin
						ALU_sel = 2'b11;
						rd = rd;
						WR_regfile = 1;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					default: // Condição padrão
					begin
						ALU_sel = 2'b00;
						rd = 0;
						WR_regfile = 0;
						WR_mem = 0;
						mux_immediate_or_regB = 1;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end
				endcase
			end
		endcase
	end

endmodule 
