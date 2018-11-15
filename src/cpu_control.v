`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 02:43:02 PM
// Design Name: 
// Module Name: cpu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_control(
        input  wire	[5:0]	opcode,
		output reg			branch_eq, branch_ne, branch_ltz, halt,
		output reg [1:0]	aluop,
		output reg			memread, memwrite, memtoreg,
		output reg			regdst, regwrite, alusrc_a, alusrc_b, extsel,
		output reg			jump);

	always @(*) begin
		aluop[1:0]	<= 2'b10;
		alusrc_a		<= 1'b0;
		alusrc_b		<= 1'b0;
		branch_eq	<= 1'b0;
		branch_ne	<= 1'b0;
		branch_ltz  <= 1'b0;
		memread		<= 1'b0;
		memtoreg	<= 1'b0;
		memwrite	<= 1'b0;
		regdst		<= 1'b1;
		regwrite	<= 1'b1;
		jump		<= 1'b0;
		halt        <= 1'b0;
        extsel      <= 1'b1;
		case (opcode)
		    6'b010000: begin      /* andi */
		        extsel <= 0;
		        regdst   <= 1'b0;
		        alusrc_b   <= 1'b1;
		    end
            6'b010010: begin    /* ori */
                extsel <= 0;  
                regdst   <= 1'b0; 
                alusrc_b   <= 1'b1;
            end
			6'b100111: begin	/* lw */
				memread  <= 1'b1;
				regdst   <= 1'b0;
				memtoreg <= 1'b1;
				aluop[1] <= 1'b0;
				alusrc_b   <= 1'b1;
			end
			6'b000010: begin	/* addiu */
				regdst   <= 1'b0;
				aluop[1] <= 1'b0;
				alusrc_b   <= 1'b1;
			end
			6'b011000: begin	/* sll */
                alusrc_a   <= 1'b1;
            end
			6'b110000: begin	/* beq */
				aluop[0]  <= 1'b1;
				aluop[1]  <= 1'b0;
				branch_eq <= 1'b1;
				regwrite  <= 1'b0;
			end
			6'b100110: begin	/* sw */
				memwrite <= 1'b1;
				aluop[1] <= 1'b0;
				alusrc_b   <= 1'b1;
				regwrite <= 1'b0;
			end
			6'b110001: begin	/* bne */
				aluop[0]  <= 1'b1;
				aluop[1]  <= 1'b0;
				branch_ne <= 1'b1;
				regwrite  <= 1'b0;
			end
			6'b110010: begin	/* bltz */
                branch_ltz <= 1'b1;
                regwrite  <= 1'b0;
            end
			6'b111000: begin	/* j jump */
				jump <= 1'b1;
			end
			6'b111111: begin	/* halt */
                halt <= 1'b1;
            end
		endcase
	end
endmodule
