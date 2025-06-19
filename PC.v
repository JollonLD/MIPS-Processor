module PC (clock, in_pc, HLT, out_pc);

	input clock;
	input HLT;
	input [31:0]in_pc;	
	
	reg [31:0]pc;
	
	output [31:0]out_pc;
	
	initial begin
		pc = 32'b0;
	end
	
	always @ (posedge clock) begin
			if (HLT)
				pc <= pc;
			else
				pc <= in_pc;
	end
	
	assign out_pc = pc;
	
endmodule
