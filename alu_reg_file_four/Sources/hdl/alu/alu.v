`timescale 10 ns / 1 ns

`define DATA_WIDTH 32
`define ADDR_WIDTH 5

module alu(
  	input [`DATA_WIDTH - 1:0] A_wdata,
        input [`DATA_WIDTH - 1:0] B,
        input [2:0] ALUop,
        output [2:0] Flag,
        output reg [`DATA_WIDTH - 1:0] Result_rdata1,

        input clk,
        input rst,
        input [`ADDR_WIDTH - 1:0] waddr,
        input [`ADDR_WIDTH - 1:0] raddr1,
        input [`ADDR_WIDTH - 1:0] raddr2,
        input wen,
        output [`DATA_WIDTH - 1:0] rdata2

);

	// TODO: insert your code

	parameter ALUOP_AND = 3'b000,
		ALUOP_OR = 3'b001,
		ALUOP_ADD = 3'b010,
		ALUOP_SUB = 3'b110,
		ALUOP_SLT = 3'b111;

        wire Zero,CarryOut,Overflow;
	wire is_sub = (ALUop == ALUOP_SUB) | (ALUop == ALUOP_SLT);
	wire [`DATA_WIDTH - 1:0] B_inv = (is_sub ? ~B : B);

	wire [`DATA_WIDTH - 1:0] sum;
	wire add_carry;

	assign {add_carry, sum} = A_wdata + B_inv + is_sub;
	assign CarryOut = add_carry ^ is_sub;

	assign cin_msb = sum[`DATA_WIDTH - 1] ^ A_wdata[`DATA_WIDTH - 1] ^ B_inv[`DATA_WIDTH - 1];
	assign Overflow = add_carry ^ cin_msb;

	assign Zero = ~(|Result_rdata1);

	assign Flag = { Zero,CarryOut,Overflow };
   
	always@(*) begin
		case(ALUop)
			ALUOP_AND: Result_rdata1 = A_wdata & B;
			ALUOP_OR: Result_rdata1 = A_wdata | B;
			ALUOP_ADD: Result_rdata1 = sum;
			ALUOP_SUB: Result_rdata1 = sum;
			ALUOP_SLT: Result_rdata1 = {{(`DATA_WIDTH - 1){1'b0}}, (Overflow ^ sum[`DATA_WIDTH - 1])};
			default: Result_rdata1 = {`DATA_WIDTH{1'b0}};
		endcase
	end

endmodule
