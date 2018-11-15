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
	parameter CODE_DATA = "C:/Users/Liuhaohua/Desktop/project_1/test_single_cycle.txt"
)
(
		input wire 	[31:0] 	addr,
		output wire [31:0] 	data);

	reg [31:0] mem [0:ENTRIES - 1];
	initial begin
		$readmemb(CODE_DATA, mem);
	end
	assign data = mem[addr[31:2]][31:0];
endmodule
