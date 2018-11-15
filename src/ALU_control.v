`timescale 1ns / 1ps

module ALU_control(
        input wire [5:0] opcode,
        input wire [5:0] funct,
		input wire [1:0] aluop,
		output reg [3:0] aluctl);

	reg [3:0] alu_funct;

	always @(*) begin
		case(opcode)
			6'b000000:  alu_funct = 4'd0;	/* add */
			6'b000001:  alu_funct = 4'd1;	/* sub */
			6'b000010:  alu_funct = 4'd0;  /* addiu */
			6'b010000:  alu_funct = 4'd4;	/* andi */
			6'b010001:  alu_funct = 4'd4;  /* and */
			6'b010010:  alu_funct = 4'd3;  /* ori */
			6'b010011:  alu_funct = 4'd3;  /* or */
			6'b011000:  alu_funct = 4'd2;  /* sll */
			6'b011100:  alu_funct = 4'd6;  /* slti */
			6'b110010:  alu_funct = 4'd6;
//			4'd6:  alu_funct = 4'd13;	/* xor */
//			4'd7:  alu_funct = 4'd12;	/* nor */
//			4'd10: alu_funct = 4'd7;	/* slt */
			default: alu_funct = 4'd0;
		endcase
	end

	always @(*) begin
		case(aluop)
			2'd0: aluctl = 4'd0;	/* add */
			2'd1: aluctl = 4'd1;	/* sub */
			2'd2: aluctl = alu_funct;
			2'd3: aluctl = 4'd0;	/* add */
			default: aluctl = 0;
		endcase
	end
endmodule
