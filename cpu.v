// a) Qual a latência do sistema?
// Latência do sistema: 375.173ns, equivalente a 38 ciclos de clock.

// b) Qual o throughput do sistema?
// Throughput do sistema: ~2.63 milhões de operações por segundo (2.63 MIPS).

// c) Qual a máxima frequência operacional entregue pelo Time Quest Timing Analyzer para o multiplicador e para o sistema?
// Frequência máxima operacional (f_max):
// - Sistema (PLL clk[0]): 272 MHz (Caminho crítico de 3.678 ns).
// - Sistema (PLL clk[1]): 8 MHz (Caminho crítico de 125.057 ns).

// d) Qual a máxima frequência de operação do sistema? (Indique a FPGA utilizada)
// Frequência máxima de operação do sistema (f_max):
// - PLL clk[0]: 272 MHz (Caminho crítico de 3.678 ns).
// - PLL clk[1]: 8 MHz (Caminho crítico de 125.057 ns).
// Modelo da FPGA utilizada: Intel Cyclone IV GX.

// e) Analisando a sua implementação de dois domínios de clock diferentes, haverá problemas com metaestabilidade? Por quê?
// Sim, pode haver problemas com metaestabilidade na implementação de dois domínios de clock diferentes, pois pll1|clk[0] e pll1|clk[1] têm frequências distintas e suas bordas não estão alinhadas.
// A metaestabilidade ocorre quando os sinais atravessam esses domínios sem sincronização adequada.
// Para evitar esse problema, recomenda-se:
// - Adicionar mecanismos de sincronização, como registradores de duplo estágio ou FIFOs.
// - Ajustar o Testbench para simular os sinais cruzando os domínios de clock.

// f) A aplicação de um multiplicador do tipo utilizado, no sistema MIPS sugerido, é eficiente em termos de velocidade? Por quê?
// Não, o multiplicador do tipo utilizado não é o mais eficiente em termos de velocidade, pois a operação de multiplicação é realizada em múltiplos ciclos de clock.
// Embora o design seja eficiente em termos de simplicidade de hardware, ele é mais lento do que um multiplicador combinacional ou pipeline, o que pode limitar o desempenho do sistema.

// g) Cite modificações cabíveis na arquitetura do sistema que tornaria o sistema mais rápido (frequência de operação maior). Para cada modificação sugerida, qual a nova latência e throughput do sistema?
// Modificações sugeridas:
// 1. Substituir o multiplicador sequencial por um multiplicador combinacional:
//    - Latência: Reduzida para 10 ns (1 ciclo de clock).
//    - Throughput: Aumentado para 100 MIPS.
// 2. Implementar pipeline no multiplicador:
//    - Latência: Mantida (~375 ns).
//    - Throughput: Aumentado para 100 MIPS.
// 3. Sincronizar adequadamente os sinais entre CLK_SYS e CLK_MUL:
//    - Latência: Ligeiramente aumentada (~380 ns).
//    - Throughput: Mantido em 2.63 MIPS, mas com maior estabilidade.
// 4. Substituir o multiplicador por um bloco IP otimizado:
//    - Latência: Reduzida para 10 ns.
//    - Throughput: Aumentado para 100 MIPS.
// 5. Dividir o estágio de Execute em vários subestágios menores:
//    - Descrição: Quebrar o estágio de Execute em subestágios menores (por exemplo, separando operações da ALU, multiplicador e acesso à memória).
//    - Impacto:
//      - Latência: Pode aumentar em ciclos devido à divisão do estágio, mas com clocks mais rápidos, o tempo total pode ser reduzido.
//      - Throughput: Aumentado, pois mais instruções poderão ser processadas simultaneamente no pipeline.
//      - Frequência de operação: Maior, já que caminhos críticos serão reduzidos, permitindo que o clock do sistema seja mais rápido.


module cpu(
    input CLK, Reset,
    input [31:0] Data_BUS_READ, Prog_BUS_READ,
    output [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog,
    output CS, WE, CS_P
);

    (*keep=1*)wire [31:0] dataOut_Inst_M;
    (*keep=1*)wire [31:0] addressCorrection_mem1, addressCorrection_mem2, dataOut_Imm;
    (*keep=1*)wire [31:0] dataOut_RF1, dataOut_RF2;
    (*keep=1*)wire [31:0] writeBack, register_A, register_B;
    (*keep=1*)wire [31:0] dataOut_M1, dataOut_M2, dataOut_M3;
    (*keep=1*)wire [31:0] dataOut_ALU, dataOut_Mult, dataOut_D1, dataOut_D2;
    (*keep=1*)wire [24:0] ctrl0, ctrl1, ctrl2;
	 (*keep=1*)wire [25:0] ctrl3;
    (*keep=1*)wire [31:0] dataOut_PC;
    (*keep=1*)wire CLK_MUL, CLK_SYS;
    (*keep=1*)wire dataOut_M;
    (*keep=1*)wire [31:0] fioA, fioB;
    (*keep=1*)wire reset_control;
    (*keep=1*)wire zeroFlag;
    (*keep=1*)wire pc_jmpFlag;
    (*keep=1*)wire pc_branchFlag;

    (*keep=1*)wire CS_WB;
    assign CS_WB = ctrl3[25];

	
	
	PLL pll (
		.inclk0 (CLK),
		.c0 (CLK_MUL),
		.c1 (CLK_SYS)
	);	
	
	assign ADDR = dataOut_D1;
	assign WE = ctrl1[3];
	assign ADDR_Prog = dataOut_PC - 32'h9F0;
	assign iAddress = dataOut_D1 - 32'h6F0;
	assign Data_BUS_WRITE = fioB;

//Instruction Fetch
	
	InstMem Intruction_Memory(
		.clock(CLK_SYS),
		.address(ADDR_Prog),
		.q(dataOut_Inst_M)
	);
		
	pc PC(
		.Clk(CLK_SYS),
		.Reset(Reset),
		.zeroFlag(zeroFlag),
		.jmpFlag(ctrl0[0]),
		.branchFlag(ctrl1[1]),
		.jmpAddress(dataOut_Extend),
		.branchOffset(dataOut_Imm),
		.addr(dataOut_PC),
		.resetControl(reset_control)
	);
	
	mux MUX_ADDR(
		.sel(CS_P),
		.a(Prog_BUS_READ),
		.b(dataOut_Inst_M),
		.out(tempOut)
	);
wire [31:0] tempOut;

	
	 
	 ADDRDecoding_Prog addrDecoding_Prog(
		.addr(dataOut_PC),
		.CS_P(CS_P)
	 );

	registerfile Register_File(
		.Clk(CLK_SYS),
		.we(ctrl3[9]),
		.rs(ctrl0[24:20]),
		.rt(ctrl0[19:15]),
		.rd(ctrl3[14:10]),
		.in(writeBack),
		.outA(fioA),
		.outB(fioB),
		.resetControl(reset_control)
	);
	
	
		
	control Control(
		.in(tempOut),
		.out(ctrl0)
	);
	 
	extend Extend(
		.in(tempOut),
		.out(dataOut_Extend)
	);
	
	register IMM(
		.Clk(CLK_SYS),
		.Reset(reset_control),
		.in(dataOut_Extend),
		.out(dataOut_Imm)
	);
	
	wire [31:0] dataOut_Extend;

	register CTRL1 (
		.Clk(CLK_SYS),
		.Reset(reset_control),
		.in(ctrl0[24:0]),
		.out(ctrl1[24:0])
	);
	 
	 
//Execute

	Multiplicador MULTIPLICADOR(
		.Clk(CLK_MUL),
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

//Memory 
	 wire iWE;
	 wire [9:0] iAddress;
	ADDRDecoding ADDR_Decoding (
		.WE(ctrl1[3]),
		.iWE(iWE),
		.iAddress(addressCorrection_mem2),
		.addr(dataOut_D1),
		.cs(CS)
	);

	
	datamemory Data_Memory (
		.clock(CLK_SYS), //
		.wren(iWE), // ok 
		.address(iAddress),
		.data(fioB),
		.q(dout) // q
	);
	
	// WRITE_BACK 1
	  (*keep=1*)wire [31:0] dout;
	 
	mux MUX3(
		.sel(CS_WB),
		.a(Data_BUS_READ), // dout
		.b(dout), // Data_BUS_READ
		.out(dataOut_M3)
	);
	
		mux MUX4(
		.sel(ctrl3[2]),
		.a(dataOut_M3), // dataOut_D2
		.b(dataOut_D2), // dataOut_M3
		.out(writeBack)
	);
	


	
	register D(
		.Clk(CLK_SYS),
		.Reset(Reset),
		.in(dataOut_D1),
		.out(dataOut_D2)
	);
	// assign reg_destino = ctrl3[14:10];
	
   register #(26) CTRL3 (
        .Clk(CLK_SYS),
        .Reset(Reset),
        .in({CS,ctrl1[24:0]}),
        .out(ctrl3)
    );
 endmodule 