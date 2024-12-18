`timescale 1ns / 1ps

module TB;

    reg CLK, Reset;
    reg [31:0] Data_BUS_READ, Prog_BUS_READ;
	 reg CLK_SYS, CLK_MUL;
	 reg [31:0] writeBack;
	 //,fioA,fioB,dataOut_Mult;
	 // wire [31:0] monitor_dataOut_Inst_M;
    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog; 
	 //writeBack_out,monitor_outA,monitor_outB;
    wire CS, WE, CS_P;
	

    // Instância do módulo CPU
    cpu dut (
        .CLK(CLK),
        .Reset(Reset),
        .Data_BUS_READ(Data_BUS_READ),
        .Prog_BUS_READ(Prog_BUS_READ),
        .ADDR(ADDR),
        .Data_BUS_WRITE(Data_BUS_WRITE),
        .ADDR_Prog(ADDR_Prog),
        .CS(CS),
		  .WE(WE),
		  .CS_P(CS_P)
		     );

    // Inicialização dos sinais
    initial begin

		$init_signal_spy("dut/CLK_SYS","CLK_SYS",1);
		$init_signal_spy("dut/CLK_MUL","CLK_MUL",1);
		$init_signal_spy("dut/writeBack","writeBack",1);
		//$init_signal_spy("dut/ctrl3","ctrl3",1);
		//$init_signal_spy("dut/dout","dout",1);
//		$init_signal_spy("dut/ctrl0","ctrl0",1);
		// $init_signal_spy("dut/fioA","fioA",1);
		// $init_signal_spy("dut/fioB","fioB",1);
		//$init_signal_spy("dut/dataOut_Mult","dataOut_Mult",1);
		// $init_signal_spy("dut/dataOut_M3","dataOut_M3",1);
		
		//$init_signal_spy("dut/dout","dout",1);
		
	 CLK = 0;
        Reset = 1; // Ativando o reset inicialmente
        Data_BUS_READ = 32'hFFFFFFFF; // Inicializando com 0
        Prog_BUS_READ = 32'h0;
		  

        // Liberando o reset após 50 unidades de tempo
        #10 Reset = 0;


        // Tempo adicional para observar o comportamento
        #134003 $stop; // Finaliza a simulação após 500 unidades de tempo
    end

    // Geração de clock com período de 10 unidades de tempo
    always #5 CLK = ~CLK;

    // Monitoramento dos sinais de depuração

endmodule
