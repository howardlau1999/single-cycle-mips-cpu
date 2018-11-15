`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 02:47:57 PM
// Design Name: 
// Module Name: inst_mem
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


module inst_mem # (
    parameter ENTRIES = 128,
	parameter CODE_DATA = "/home/howard/single-cycle-mips-cpu/src/test_single_cycle.txt"
)
(
		input wire 	[31:0] 	addr,
		output wire [31:0] 	data);

	reg [7:0] mem [0:ENTRIES - 1];
	initial begin
		$readmemb(CODE_DATA, mem);
	end
	assign data[31:24] = mem[addr];
	assign data[23:16] = mem[addr + 1];
	assign data[15:8]  = mem[addr + 2];
	assign data[7:0]   = mem[addr + 3];
	
endmodule
