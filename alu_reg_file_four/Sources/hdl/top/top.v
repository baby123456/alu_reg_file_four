//////////////////////////////////////////////////////////////////////////////
//  Top-level, static design
//////////////////////////////////////////////////////////////////////////////

`define DATA_WIDTH 32
`define ADDR_WIDTH 5
module top(
);
    	wire [31:0] A_wdata;
    	wire [31:0] B;
	wire [2:0] ALUop;
	wire [2:0] Flag;
   	wire [31:0] Result_rdata1;
    
    	wire [31:0] A1_wdata;
    	wire [31:0] B1;
	wire [2:0] ALUop1;
    	wire [2:0] Flag1;
        wire [31:0] Result1_rdata1;
    
    	wire [31:0] A2_wdata;
    	wire [31:0] B2;
    	wire [2:0] Flag2;
        wire [31:0] Result2_rdata1;
    
    	wire [31:0] A3_wdata;
    	wire [31:0] B3;
	wire [2:0] ALUop3;
	wire [2:0] Flag3;
        wire [31:0] Result3_rdata1;
    
	wire clk;
        wire rst;

	wire [4:0] raddr1_1;
  	wire [4:0] raddr1_2;
  	wire [4:0] raddr1_3;
  	wire [4:0] raddr1;
  	
	wire [4:0] raddr2_1;
  	wire [4:0] raddr2_2;
  	wire [4:0] raddr2_3;
  	wire [4:0] raddr2;

  	wire [31:0] rdata2_1;
  	wire [31:0] rdata2_2;
  	wire [31:0] rdata2_3;
  	wire [31:0] rdata2;

  	wire [4:0] waddr1;
  	wire [4:0] waddr2;
 	wire [4:0] waddr3;
  	wire [4:0] waddr;

  	wire wen1;
  	wire wen2;
  	wire wen3;
  	wire wen;
        
    mpsoc_wrapper u_mpsoc_wrapper(
    .FLag2_tri_i				(Flag2),
    .FLag3_tri_i				(Flag3),
    .Flag1_tri_i				(Flag1),
    .Flag_tri_i					(Flag),
    
    .Result1_rdata1_tri_i			(Result1_rdata1),
    .Result2_rdata1_tri_i			(Result2_rdata1),
    .Result3_rdata1_tri_i			(Result3_rdata1),
    .Result_rdata1_tri_i			(Result_rdata1),
    
    .alu1_A_wdata_tri_o                         (A1_wdata),
    .alu1_B_tri_o                               (B1),
    .alu1_op_tri_o                              (ALUop1),
    
    .alu2_A_wdata_tri_o                         (A2_wdata),
    .alu2_B_tri_o                               (B2),
    .alu2_op_tri_o                              (ALUop2),
    
    .alu3_A_wdata_tri_o                         (A3_wdata),
    .alu3_B_tri_o                               (B3),
    .alu3_op_tri_o                              (ALUop3),
    
    .alu_A_wdata_tri_o                          (A_wdata),
    .alu_B_tri_o                                (B),
    .alu_op_tri_o                               (ALUop),
    
    //reg_file
    .ps_fclk_clk0				(clk),
    .reg_file_rst				(rst),
       
    .waddr1_tri_o				(waddr1),
    .wen1_tri_o					(wen1),
    .raddr1_1_tri_o				(raddr1_1),
    .raddr2_1_tri_o				(raddr2_1),
    .rdata2_1_tri_i				(rdata2_1),
	
    .waddr2_tri_o				(waddr2),
    .wen2_tri_o					(wen2),
    .raddr1_2_tri_o				(raddr1_2),
    .raddr2_2_tri_o				(raddr2_2),
    .rdata2_2_tri_i				(rdata2_2),

    .waddr3_tri_o				(waddr3),
    .wen3_tri_o					(wen3),
    .raddr1_3_tri_o				(raddr1_3),
    .raddr2_3_tri_o				(raddr2_3),
    .rdata2_3_tri_i				(rdata2_3),

    .waddr_tri_o				(waddr),
    .wen_tri_o					(wen),
    .raddr1_tri_o				(raddr1),
    .raddr2_tri_o				(raddr2),
    .rdata2_tri_i				(rdata2)
       
    );
   
   // instantiate module user1
   user1 inst_alu_user1 (
    	.A_wdata                    (A_wdata),
	.B                          (B),
	.ALUop                      (ALUop),
        .Flag			    (Flag),
        .Result_rdata1		    (Result_rdata1),

        .clk			    (clk),
        .rst			    (rst),
        .waddr			    (waddr),
        .raddr1			    (raddr1),
        .raddr2			    (raddr2),
        .wen			    (wen),
        .rdata2			    (rdata2)

   );
 
   // instantiate module user2
   user2 inst_alu_user2(
  	.A_wdata                    (A1_wdata),
        .B                          (B1),
        .ALUop                      (ALUop1),
        .Flag                       (Flag1),
        .Result_rdata1              (Result1_rdata1),

        .clk                        (clk),
        .rst                        (rst),
        .waddr                      (waddr1),
        .raddr1                     (raddr1_1),
        .raddr2                     (raddr2_1),
        .wen                        (wen1),
        .rdata2                     (rdata2_1) 
  );
   
   // instantiate module user3
   user3 inst_alu_user3 (
  	.A_wdata                    (A2_wdata),
        .B                          (B2),
        .ALUop                      (ALUop2),
        .Flag                       (Flag2),
        .Result_rdata1              (Result2_rdata1),

        .clk                        (clk),
        .rst                        (rst),
        .waddr                      (waddr2),
        .raddr1                     (raddr1_2),
        .raddr2                     (raddr2_2),
        .wen                        (wen2),
        .rdata2                     (rdata2_2)
   );
 
   // instantiate module user4
   user4 inst_alu_user4(
	.A_wdata                    (A3_wdata),
        .B                          (B3),
        .ALUop                      (ALUop3),
        .Flag                       (Flag3),
        .Result_rdata1              (Result3_rdata1),

        .clk                        (clk),
        .rst                        (rst),
        .waddr                      (waddr3),
        .raddr1                     (raddr1_3),
        .raddr2                     (raddr2_3),
        .wen                        (wen3),
        .rdata2                     (rdata2_3)
   );
endmodule

// black box definition for module_alu
module user1(
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
endmodule

module user2(
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
endmodule

module user3(
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
endmodule

module user4(
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
endmodule

