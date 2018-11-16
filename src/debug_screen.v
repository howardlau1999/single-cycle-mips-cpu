`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2018 04:18:21 PM
// Design Name: 
// Module Name: debug_screen
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


module debug_screen # (
    parameter CHAR_WIDTH = 8,
    parameter CHAR_HEIGHT = 8,
    parameter SCREEN_WIDTH = 640,
    parameter SCREEN_HEIGHT = 480,
    parameter CHARS_PER_ROW = SCREEN_WIDTH / CHAR_WIDTH,
    parameter CHARS_PER_COL = SCREEN_HEIGHT / CHAR_HEIGHT
)
(
    input wire clk,
    input wire [31:0] pc,
    input wire [31:0] reg_data, ram_data,
    input wire [31:0] inst, rs, rt, rd, imm, shamt, funct, alurslt,
    output wire [4:0] reg_addr,
    output wire [31:0] ram_addr,
    output reg bg_wrt,
    output reg [12:0] bam_addr,
    output reg [7:0] bam_write_data
);

reg [6:0] char_x = 0;
reg [5:0] char_y = 0;
reg [6:0] next_char_x = 0;
reg [5:0] next_char_y = 0;
reg [31:0] hex_data;
reg [7:0] hex_char[7:0];
integer i, hex;
always @ (posedge clk) begin
    char_x <= next_char_x;
    char_y <= next_char_y;
end
assign reg_addr = char_y >= 1 && char_y < 33 ? char_y - 1 : 0; 
assign ram_addr = char_y >= 1 && char_y < 10 ? (char_y - 1) * 4 : 0;
always @ * begin
    bam_write_data = 0;
    next_char_y = char_y;
    hex_data = 0;
    bam_addr = 0;
    bg_wrt = 0;
    if (char_x >= 13) begin
        if (char_x < 21 && (char_y <= 41 && char_y != 33)) begin
            if (char_y == 0) hex_data = pc;
            else if (char_y >= 1 && char_y < 33) hex_data = reg_data;
            else if (char_y == 34) hex_data = inst;
            else if (char_y == 35) hex_data = rs;
            else if (char_y == 36) hex_data = rt;
            else if (char_y == 37) hex_data = rd;
            else if (char_y == 38) hex_data = imm;
            else if (char_y == 39) hex_data = shamt;
            else if (char_y == 40) hex_data = funct;
            else if (char_y == 41) hex_data = alurslt;
            
            bg_wrt = 1;
            bam_write_data = hex_char[char_x - 13];
            bam_addr = char_x + char_y * CHARS_PER_ROW;
        end 
        else if (char_x >= 27 && char_x < 35 && char_y >= 1 && char_y < 10) begin
            bg_wrt = 1;
            bam_write_data = hex_char[char_x - 27];
            bam_addr = char_x + char_y * CHARS_PER_ROW;
            
            hex_data = ram_data;
            
        end
    end 
    
    if (char_x == CHARS_PER_ROW - 1) begin
        if (char_y == CHARS_PER_COL - 1) begin
            next_char_y = 0;
        end else begin 
            next_char_y = char_y + 1;
        end
        next_char_x = 0;
    end else begin 
        next_char_x = char_x + 1;
    end
    
    for (i = 0; i < 8; i = i + 1) begin
        hex = (hex_data >> ((7 - i) * 4) & 4'hF);
        hex_char[i] = hex < 10 ? 8'b00010000 + hex : 8'b00100001 + hex - 10 ;
    end
    
end

endmodule
