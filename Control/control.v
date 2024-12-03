
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
		WR_regfile, 	// Leitura ou escrita do regFile wr = 1 escrita wr = 0 leitura
		mux_immediate_or_regB, // MUX para escolher entre REG B ou Immediate 1 = imediato b = 0 
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
		case(in[31:26])
			6'b100011: //35 // Load Word  100011 11111 00001 offset-0000011011110001
					 // saida para essa entrada deve ser 
					 // rs = 11111, rt = 00001, rd = 00001, 
					 // WR_regfile = 1 , mux_immed = 1, ALU_sel = 00
					 // mul_Start = 0, mux2_ALU = 1,WR_mem = 0,   CS_WB_2 = 1
					 // jmpFlag = 0, branchFlag = 0
					 // esperado : 24'11111 00001 000011100010100  
										// 11111 00001 000000000000000
										// 11111 00010 000001000100000  100111
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

			6'b100100: // 36 Store Word :040004008FE206F28F
					 // Load Word  100011 11111 00001 offset-0000011011110001

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

			6'b100101: 	// 37 Branch on Not Equal 1001 0111 1111 1110 1111 1111 1111 0000
							// 100101 rs31(11111) rt30(11110) offset(1111111111110000)
							// sinal de controle rs(11111) rt(11110) rd(00000) 0 0 sub(01) mulStart(0) mux2(1) wr(0) cs(0) brach(1) jmp(0)
							//assign out = {
							//rs, 			// Primeiro registrador
							//rt, 			// Segundo para R ou destino para I
							//rd, 			// Destino para R
							//WR_regfile, 	// Leitura ou escrita do regFile wr = 1 escrita wr = 0 leitura
							//mux_immediate_or_regB, // MUX para escolher entre REG B ou Immediate 1 = imediato b = 0 
							//ALU_sel,		// ALU: 00 = +, 01 = -, 10 = &, 11 = |
							//mul_Start,		// Controle para iniciar uma multiplicação  
							//mux2_ALU, 		// Seleção entre Soma ou Multiplicação
							//WR_mem, 		// Write/Read na memória dataMemory
							//CS_WB_2, 		// Write Back 2 entre D e saída do mux 1
							//branchFlag, 	// Flag de Branch
							//jmpFlag 		// Flag de Jump
							//};
							// 
							// 
			begin
				ALU_sel = 2'b01; // seleciono a subtração
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

			6'b100110: //38 ADD Immediate
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
			
			6'b100111: //39 ORI 100111
			begin  
				ALU_sel = 2'b11;
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

			6'b000010: // Jump (exemplo de uso da flag jmpFlag) 
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
				rd = in[15:11];
				case(operation) // 32 0011 0100 0100 0011 0101 001010 100000
										//  0011 0100 0100 0011 0101 0010 1010 0000
					6'b100000: // ADD R A0 foda-se= 001101 rs(2)=00010 rt(3) = 00011 rd(10) = 01010 - valor(10)= 01010 32 -100000
					 // saida para essa entrada deve ser 
					 // rs = 00010, rt = 00011, rd = 01010, 
					 // WR_regfile = 1 , mux_immed = 0, ALU_sel = 00
					 // mul_Start = 0, mux2_ALU = 1,WR_mem = 0,   CS_WB_2 = 0
					 // jmpFlag = 0, branchFlag = 0
					 // esperado : 24'0001000011010101000010000
					 
					 
					begin
						ALU_sel = 2'b00;
						WR_regfile = 1;
						rd = rd;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 1;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'b100010: // 34SUB R
					begin
						ALU_sel = 2'b01;
						WR_regfile = 1;
						rd = rd;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'b110010: // 50MULT R
					begin
						ALU_sel = 2'b00; // Tanto faz
						WR_regfile = 1;
						rd = rd;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 1;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'b100100: //36 AND R
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

					6'b100101: // 37 OR R
					begin
						ALU_sel = 2'b11;
						WR_regfile = 1;
						WR_mem = 0;
						rd = rd;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					default: // Condição padrão
					begin
						rs = 5'b00000;
						rt = 5'b00000;
						ALU_sel = 2'b00;
						rd = 5'b00000;
						WR_regfile = 0;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
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
