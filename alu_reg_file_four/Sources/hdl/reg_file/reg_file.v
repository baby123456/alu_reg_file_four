`timescale 10 ns / 1 ns

`define DATA_WIDTH 32
`define ADDR_WIDTH 5

module reg_file(
  	input [`DATA_WIDTH - 1:0] A_wdata,
        input [`DATA_WIDTH - 1:0] B,
        input [2:0] ALUop,
        output [2:0] Flag,
        output [`DATA_WIDTH - 1:0] Result_rdata1,

        input clk,
        input rst,
        input [`ADDR_WIDTH - 1:0] waddr,
        input [`ADDR_WIDTH - 1:0] raddr1,
        input [`ADDR_WIDTH - 1:0] raddr2,
        input wen,
        output [`DATA_WIDTH - 1:0] rdata2

);

	// TODO: insert your code
	reg [`DATA_WIDTH - 1:0] regfile [2 ** `ADDR_WIDTH - 1:0];

	always@(posedge clk) begin
		if(rst) begin
			regfile[0] <= {`DATA_WIDTH{1'b0}};
		end
		else begin
			if(wen & waddr != {`ADDR_WIDTH{1'b0}}) begin
				regfile[waddr] <= A_wdata;
			end
		end
	end

	assign Result_rdata1 = regfile[raddr1];
	assign rdata2 = regfile[raddr2];
endmodule
