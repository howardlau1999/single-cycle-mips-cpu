`timescale 1ns / 1ps

module ALU(
        input		[3:0]	control,
		input		[31:0]	a, b,
		output reg	[31:0]	rslt,
		output				zero);

	wire [31:0] sub_ab;
	wire [31:0] add_ab;
	wire 		oflow_add;
	wire 		oflow_sub;
	wire 		oflow;
	wire 		slt;

	assign zero = (0 == rslt);

	assign sub_ab = a - b;
	assign add_ab = a + b;

	assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;
	assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0;

	assign oflow = (control == 4'b0010) ? oflow_add : oflow_sub;

	// set if less than, 2s compliment 32-bit numbers
	assign slt = oflow_sub ? ~(a[31]) : a[31];

	always @(*) begin
		case (control)
		    4'b0000: rslt <= add_ab;
		    4'b0001: rslt <= sub_ab;
		    4'b0010: rslt <= b << a;
		    4'b0011: rslt <= a | b;
		    
		    4'b0100: rslt <= a & b;
		    4'b0101: rslt <= a < b ? 1 : 0;
		    4'b0110: rslt <= {{31{1'b0}}, slt};
		    4'b0111: rslt <= a ^ b;
		    /* standard mips impl */
//			4'd2:  rslt <= add_ab;				/* add */
//			4'd0:  rslt <= a & b;				/* and */
//			4'd12: rslt <= ~(a | b);				/* nor */
//			4'd1:  rslt <= a | b;				/* or */
//			4'd7:  rslt <= {{31{1'b0}}, slt};	/* slt */
//			4'd6:  rslt <= sub_ab;				/* sub */
//			4'd13: rslt <= a ^ b;				/* xor */
			default: rslt <= 0;
		endcase
	end
endmodule
