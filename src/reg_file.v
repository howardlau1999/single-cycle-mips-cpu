`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 02:34:13 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
		input wire			clk, rst,
		input wire  [4:0]	read1, read2, dbg_read, led_read,
		output wire [31:0]	data1, data2, dbg_data, led_data,
		input wire			regwrite,
		input wire	[4:0]	wrreg,
		input wire	[31:0]	wrdata);
    integer i;
    
	reg [31:0] mem [0:31];
	reg [31:0] _data1, _data2, _dbg_data;
    initial begin
            for (i = 0; i < 32; i=i+1) begin
                mem[i] = 32'd0;
            end
        end
	assign data1 = (read1 == 5'd0) ? 32'b0 : mem[read1];
    assign data2 = (read2 == 5'd0) ? 32'b0 : mem[read2];
    assign dbg_data = (dbg_read == 5'd0) ? 32'b0 : mem[dbg_read];
    assign led_data = (led_read == 5'd0) ? 32'b0 : mem[led_read];
	always @ (negedge clk) begin
	    if (rst) begin
	       for (i = 0; i < 32; i=i+1) begin
                mem[i] = 32'd0;
            end
	    end else
		if (regwrite && wrreg != 5'd0) begin
			mem[wrreg] <= wrdata;
		end
	end
endmodule
