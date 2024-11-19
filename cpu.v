module cpu(
    input Clk, Reset,
    input [31:0] Data_BUS_READ, Prog_BUS_READ,
    output [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog,
    output CS, WE, CS_P,
    output [31:0] writeBack_out, // Novo nome para o sinal de saída
    // Sinais de debug
    output wire [31:0] CS_P_OUT,
    output wire [31:0] pc_jmpAddress,
    output wire [31:0] pc_branchOffset,
    output wire pc_zeroFlag,
    output wire pc_jmpFlag,
    output wire branchFlag
);
	
	(*keep=1*)wire [31:0] dataOut_Inst_M;
	(*keep=1*)wire [31:0] addressCorrection_mem1, addressCorrection_mem2;
	(*keep=1*)wire [31:0] dataOut_RF1, dataOut_RF2;
	(*keep=1*)wire [31:0] writeBack, register_A,register_B;	
	(*keep=1*)wire [31:0] dataOut_Extend, dataOut_Imm, dataOut_M1,dataOut_M2, dataOut_M3;
	(*keep=1*)wire [31:0] dataOut_ALU, dataOut_Mult, dataOut_D1, dataOut_D2, dout;	 
	(*keep=1*)wire [24:0] ctrl0, ctrl1, ctrl2, ctrl3;
	(*keep=1*)wire [31:0] dataOut_PC;
	(*keep=1*)wire Clk_Mult, Clk_System;
	(*keep=1*)wire CS_P_WIRE;
	(*keep=1*)wire dataOut_M;
	(*keep=1*)wire [31:0] fioA, fioB;

	PLL pll (
		.inclk0 (Clk),
		.c0 (Clk_Mult),
		.c1 (Clk_System)
	);	
	
	assign ADDR = dataOut_D1;
	assign WE = ctrl2[1];
	assign addressCorrection_mem1 = dataOut_PC - 32'h9F0;
	//assign addressCorrection_mem2 = dataOut_D1 - 32'h6F0;
	assign Data_BUS_WRITE = fioB;
	assign ADDR_Prog = dataOut_PC;

	assign CS_P = CS_P_WIRE;
	assign writeBack_out = writeBack;
//Instruction Fetch
	
	InstMem Intruction_Memory(
		.clock(Clk_System),
		.address(addressCorrection_mem1[9:0]),
		.q(dataOut_Inst_M)
	);
		(*keep=1*)wire zeroFlag_Internal;

		assign pc_zeroFlag = zeroFlag_Internal;
		assign pc_addr = dataOut_PC;
		assign pc_jmpAddress = dataOut_Extend;
		assign pc_branchOffset = dataOut_Imm;
		assign pc_jmpFlag = ctrl0[0];
		assign pc_branchFlag = ctrl0[1];
		
	pc PC(
		.Clk(Clk_System),
		.Reset(Reset),
		.zeroFlag(zeroFlag),
		.jmpFlag(pc_jmpFlag),
		.branchFlag(pc_branchFlag),
		.jmpAddress(dataOut_Extend),
		.branchOffset(dataOut_Imm),
		.addr(dataOut_PC),
	);
	
	mux MUX_ADDR(
		.sel(CS_P_REG),
		.a(Prog_BUS_READ),
		.b(dataOut_Inst_M),
		.out(dataOut_M1)
	);
	
	
	 
	 ADDRDecoding_Prog addrDecoding_Prog(
		.addr(dataOut_PC),
		.CS_P(CS_P_WIRE)
	 );
	 
	 wire [31:0] CS_P_REG;
	 
		register CS_P_reg (
		.Clk(Clk_System),
		.Reset(Reset),
		.in(CS_P_WIRE),
		.out(CS_P_REG)
	);
	assign CS_P_OUT = CS_P_REG;
	
	
		//Instruction Decode
		//input Clk, we,
		//input [4:0] rs, rt, rd,
		//input [31:0] in,
		/*
		rs, // Primeiro registra__dor 5 bits 25
		rt, // Segundo para R ou destino para I 5 bits
		rd, // Destino para R 5 bits 
		WR_regfile, // Leitura ou escrita do regFile 1 bit
		mux_immediate_or_regB, // MUX PARA ESCOLHER ENTRE REG B OU IMMEDIATE
		ALU_sel, 	// ALU
						// 2'b00: out <= a+b;	
						// 2'b01: out <= a-b;	
						// 2'b10: out <= a & b;	
						// 2'b11: out <= a | b;
		mul_Start,	// Controle para iniciar uma multiplicação  
		mux2_ALU, // SEGUNDO MUX PARA ESCOLHER O RESULTADO DA SOMA OU DA MULTIPLICAÇÃO
		WR_mem, // Write Read memoria dataMemory eu acho...
		CS_WB_2 // Write Back 2 entre D e saida do mux 1
		branchFlag, // flag de Branch
		jmpFlag // Flag de Jump
		*/
	 
	registerfile Register_File(
		.Clk(Clk_System),
		.we(ctrl3[7]),
		.rs(ctrl0[24:20]),
		.rt(ctrl0[19:15]),
		.rd(ctrl3[14:10]),
		.in(writeBack),
		.outA(fioA),
		.outB(fioB)
	);
	
		
	control Control(
		.in(dataOut_M1),
		.out(ctrl0)
	);
	
	extend Extend(
		.in(dataOut_M1),
		.out(dataOut_Extend)
	);
	
	register IMM(
		.Clk(Clk_System),
		.Reset(Reset),
		.in(dataOut_Extend),
		.out(dataOut_Imm)
	);

	register CTRL1 (
		.Clk(Clk_System),
		.Reset(Reset),
		.in(ctrl0[24:0]),
		.out(ctrl1[24:0])
	);
	 
	 
//Execute

	Multiplicador MULTIPLICADOR(
		.Clk(Clk_Mult),
		.St(ctrl1[5]),
		.Multiplicador(fioA[15:0]),
		.Multiplicando(fioB[15:0]),
		.Produto(dataOut_Mult)
	);
	wire[31:0] dataOut_M111111111;
	
	mux MUX1(
		.sel(ctrl1[8]),
		.a(fioB),
		.b(dataOut_Imm),
		.out(dataOut_M111111111)
	);
	
	  wire zeroFlag;
	  
	alu ALU(
		.sel(ctrl1[7:6]),
		.a(fioA),
		.b(dataOut_M111111111),
		.out(dataOut_ALU),
		.zeroFlag(zeroFlag)
	);

	mux MUX2(
		.sel(ctrl1[4]),
		.a(dataOut_Mult),
		.b(dataOut_ALU),
		.out(dataOut_D1)
	);
	
	register #(25) CTRL2(
		.Clk(Clk_System),
		.Reset(Reset),
		.in(ctrl1[24:0]),
		.out(ctrl2[24:0])
	);	 

//Memory 
	 wire iWE;
	 wire iAddress;
	ADDRDecoding ADDR_Decoding (
		.WE(ctrl2[3]),
		.iWE(iWE),
		.iAddress(addressCorrection_mem2),
		.addr(dataOut_D1),
		.cs(CS)
	);

	
	datamemory Data_Memory (
		.clock(Clk_System), //
		.wren(iWE), // ok 
		.address(addressCorrection_mem2[9:0]),
		.data(fioB),
		.q(dout) // q
	);
	
	// WRITE_BACK 1
	mux MUX3(
		.sel(dataOut_M),
		.a(dout),
		.b(Data_BUS_READ),
		.out(dataOut_M3)
	);
	
	register D(
		.Clk(Clk_System),
		.Reset(Reset),
		.in(dataOut_D1),
		.out(dataOut_D2)
	);
	
	register #(1) M (
		.Clk(Clk_System),
		.Reset(Reset),
		.in(CS),
		.out(dataOut_M)
	);
	

	register #(25) CTRL3(
		.Clk(Clk_System),
		.Reset(Reset),
		.in(ctrl2[24:0]),
		.out(ctrl3[24:0])
	);

//Write Back_2
	mux MUX4(
		.sel(ctrl3[2]),
		.a(dataOut_D2),
		.b(dataOut_M3),
		.out(writeBack)
	);
	
	
 endmodule 