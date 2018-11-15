`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 02:30:59 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem # (
    parameter ENTRIES = 32    
)
(
        input wire			clk, rst,
		input wire	[clogb2(ENTRIES-1)-1:0]	addr,
		input wire			rd, wr,
		input wire 	[31:0]	wdata,
		output wire	[31:0]	rdata
		
);
    integer i;
	reg [7:0] mem [0:ENTRIES - 1];
	initial begin
        for (i = 0; i < ENTRIES; i = i + 1) begin
            mem[i] = 8'd0;
        end
    end
	always @(negedge clk) begin
	    if (rst) begin
	       for (i = 0; i < ENTRIES; i = i + 1) begin
                mem[i] = 8'd0;
            end
	    end else
		if (wr) begin
			mem[addr] <= wdata[31:24];
			mem[addr + 1] <= wdata[23:16];
			mem[addr + 2] <= wdata[15:8];
			mem[addr + 3] <= wdata[7:0];
		end
	end

	assign rdata = rd ? {mem[addr + 0][7:0], mem[addr + 1][7:0], mem[addr + 2][7:0], mem[addr + 3][7:0]} :  32'hzzzzzzzz;
	
	function integer clogb2;
        input integer depth;
          for (clogb2=0; depth>0; clogb2=clogb2+1)
            depth = depth >> 1;
      endfunction
endmodule
