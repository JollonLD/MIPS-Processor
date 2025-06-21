module Processador (clock, saida_pc, endereco_RS, endereco_RT, endereco_RD, dado1_entrada_ULA, dado2_entrada_ULA, saida_ULA, intrucao_lida, 
	endereco_acesso_memoria, dado_leitura_memoria, dado_escrita_banco, JAL, JR, HLT, DadoSel, PilhaE, PilhaOP, SZ, ResSel, ALUOp, MemToReg, RegWrite, ALUsrc, MemRead, MemWrite, Branch, RSsel, RTsel, IMsel, Jump);
	 
	input clock;

	wire SZ;
	wire JAL;
	wire JR;
	wire HLT;
	wire Jump;
	wire Branch;
	wire RegWrite;
	wire RSsel;
	wire RTsel;
	wire DadoSel;
	wire ResSel;
	wire PilhaE;
	wire PilhaOP;
	wire ALUsrc;
	wire MemToReg;
	wire MemRead;
	wire MemWrite;
	wire [1:0] IMsel;
	wire [3:0] ALUOp;

	
	output        SZ;
	output        JAL;
	output        JR;
	output        HLT;
	output        Jump;
	output        Branch;
	output        RegWrite;
	output        RSsel;
	output        RTsel;
	output        DadoSel;
	output        ResSel;
	output        PilhaE;
	output        PilhaOP;
	output        ALUsrc;
	output        MemToReg;
	output        MemRead;
	output        MemWrite;
	output [1:0]  IMsel;
	output [3:0]  ALUOp;
	
	
   wire [31:0] instrucao; // Fio de saída da memória de instruções
	wire [31:0] dado1; // Fio saída do banco de registradores
	wire [31:0] dado2; // Fio saída do banco de registradores
   wire [31:0] addr_rs; // Endereço do registrador RS
   wire [31:0] addr_rt; // Endereço do registrador RT
   wire [31:0] addr_rd; // Endereço do registrador RD
   wire [31:0] Imediato; // Fio de saída do mux com imediato
	wire [31:0] in1; // Fio de saída do mux com dado1 ou dado2
	wire [31:0] in2; // Fio de saída do mux com dado1 ou imediato
   wire [31:0] resultado; // Fio de saída da ULA
   wire [31:0] escrita_dado; // Fio de saída do dado a ser escrito no banco de registradores
	wire [31:0] rp; // Fio de saída do novo endereço do $rp
   wire [31:0] in_pc; // Fio de entrada do PC
   wire [31:0] out_pc; // Fio de saída do PC
   wire [31:0] rp_mem; // Fio de saída do dado a ser escrito na memória
	wire [31:0] mem_out;
   wire [31:0] addr_leitura;
   wire [31:0] result_out; // Fio de saída do dado a ser escrito no banco de registradores
   wire [31:0] mem_reg_out; // Fio de saída do dado a ser escrito no banco de registradores
   wire [31:0] pc_plus_one; // Fio de saída do somador 1
   wire [31:0] pc_branch; // Fio de saída do somador 2
   wire [31:0] pc_jump; // Fio de saída do mux de jump
   wire [31:0] pc_jr_jump; // Fio de saída do mux de jump para JR
   wire Zero; // Sinal de branch da ULA
	wire and_branch;
	 
	output [4:0]  saida_pc;
	output [5:0]  endereco_RS;
	output [5:0]  endereco_RT;
	output [5:0]  endereco_RD;
	output [31:0] dado1_entrada_ULA;
	output [31:0] dado2_entrada_ULA;
	output [31:0] saida_ULA;  
	output [31:0] intrucao_lida;
	output [7:0]  endereco_acesso_memoria;
	output [31:0] dado_leitura_memoria;
	output [31:0] dado_escrita_banco;

	Adder somador_1 (
		.a(32'd1),
		.b(out_pc),
		.out(pc_plus_one) 
	);
	
	Adder somador_2 (
		.a(pc_plus_one),
		.b(Imediato),
		.out(pc_branch)  
	);

	mux mux_jr (
		.a(Imediato),
		.b(dado1),
		.s(JR),
		.out(pc_jr_jump)
	);

	mux mux_jump (
		.a(pc_plus_one),
		.b(pc_jr_jump),
		.s(Jump),
		.out(pc_jump)
	);

	assign and_branch = Zero & Branch;

	mux mux_branch (
		.a(pc_jump),
		.b(pc_branch),
		.s(and_branch),
		.out(in_pc)
	);

	PC pc (
		.clock(clock),
		.in_pc(in_pc),  // Endereço do próximo PC
		.HLT(HLT),
		.out_pc(out_pc)  // Fio de saída do PC
	);	

	MemoriaInstrucoes mem_instr (
		.addr_pc(out_pc[5:0]),
		.q(instrucao)  // Fio de saída da memória de instruções
	);
	
	UnidadeControle UC (
		.opcode(instrucao[31:26]), 
		.JAL(JAL), 
		.JR(JR), 
		.HLT(HLT), 
		.DadoSel(DadoSel), 
		.PilhaE(PilhaE), 
		.PilhaOP(PilhaOP), 
		.SZ(SZ), 
		.ResSel(ResSel), 
		.ALUOp(ALUOp), 
		.MemToReg(MemToReg), 
		.RegWrite(RegWrite), 
		.ALUsrc(ALUsrc), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.Branch(Branch), 
		.RSsel(RSsel), 
		.RTsel(RTsel), 
		.IMsel(IMsel), 
		.Jump(Jump)
	);
	
	mux mux_rs (
		.a(instrucao[19:14]),
		.b(instrucao[25:20]),
		.s(RSsel),
		.out(addr_rs)
	);

	mux mux_rt (
		.a(instrucao[13:8]),
		.b(instrucao[19:14]),
		.s(RTsel),
		.out(addr_rt)
	);

	assign addr_rd = instrucao[25:20];

	mux mux_reg_ra (
		.a(mem_reg_out),
		.b(pc_plus_one),  // $ra
		.s(JAL),
		.out(escrita_dado)  // Fio de saída do dado a ser escrito no banco de registradores
	);

	BancoRegistradores banco (
		.clock(clock),
		.addr_rs(addr_rs),
		.addr_rt(addr_rt),
		.addr_rd(addr_rd),
		.escrita_dado(escrita_dado),  // valor calculado pela ULA
		.rp(rp),
		.RegWrite(RegWrite),
		.PilhaE(PilhaE),
		.JAL(JAL),
		.dado1(dado1),
		.dado2(dado2)
	);

	Extensor extensor (
		.in1(instrucao[13:0]),
		.in2(instrucao[19:0]),
		.in3(instrucao[25:0]),
		.IMsel(IMsel),
		.out(Imediato)  // Fio de saída do imediato
	);

	mux mux_sel_in1_ULA (
		.a(dado1),
		.b(dado2),
		.s(DadoSel),
		.out(in1)
	);

	mux mux_sel_in2_ULA (
		.a(dado2),
		.b(Imediato),
		.s(ALUsrc),
		.out(in2)
	);

	ULA ula (
		.in1(in1),
		.in2(in2),
		.ALUop(ALUOp),
		.sz(SZ),
		.result(resultado),
		.branch(Zero)
	);

	UC_Pilha pilha_ctrl (
		.rp_in(dado2),
		.PilhaE(PilhaE),
		.PilhaOP(PilhaOP),
		.rp_out(rp),  // Fio de saída do novo endereço do $rp
		.rp_mem(rp_mem)  // Fio de saída do dado a ser escrito na memória
	);

	mux mux_addr_leitura (
		.a(resultado),
		.b(rp_mem),
		.s(PilhaE),
		.out(addr_leitura)
	);

	MemoriaDados mem_dados (
		.clk(clock),
		.data(dado2),	
		.addr(addr_leitura[7:0]),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.q(mem_out)  // Fio de saída do dado lido da memória
	);

	mux mux_result (
		.a(resultado),
		.b(Imediato),
		.s(ResSel),
		.out(result_out)  // Fio de saída do dado a ser escrito no banco de registradores
	);

	mux mux_MemReg (
		.a(result_out),
		.b(mem_out),
		.s(MemToReg),
		.out(mem_reg_out)  // Fio de saída do dado a ser escrito no banco de registradores
	);


	assign saida_pc                 = out_pc[4:0];
	assign endereco_RS              = addr_rs;
	assign endereco_RT              = addr_rt;
	assign endereco_RD              = addr_rd;
	assign dado1_entrada_ULA        = in1;
	assign dado2_entrada_ULA        = in2;
	assign saida_ULA                = resultado;
	assign intrucao_lida            = instrucao;
	assign endereco_acesso_memoria  = addr_leitura[7:0];
	assign dado_leitura_memoria     = mem_out;
	assign dado_escrita_banco       = escrita_dado;
 
endmodule