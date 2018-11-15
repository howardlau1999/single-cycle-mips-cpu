`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2018 01:47:41 PM
// Design Name: 
// Module Name: clock_div
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


module clock_div(
input wire clk, 
input wire clr,
output wire out_clk,
output reg[1:0] s
    );
parameter MAX_COUNT = 50_000 - 1;
        reg [31:0] counter;
        initial begin
        counter <= 0;
        s <= 2'b00;
        end
        always @ (posedge clk or posedge clr)
        begin
        if (clr == 1)
        counter <= 0;
        else if (counter == MAX_COUNT) begin
            counter <= 0;
            s <= s + 1;
        end
        else
        counter <= counter + 1;
        
        end
        assign out_clk = counter == 0;
endmodule



module clock_div_n #(
parameter MAX_COUNT = 15 - 1
)(
input wire clk, 
input wire clr,
output wire out_clk,
output reg wlk
    );

        reg [31:0] counter;
        initial begin
        counter <= 0;
        end
        always @ (posedge clk or posedge clr)
        begin
        if (clr == 1)
        counter <= 0;
        else if (counter == MAX_COUNT) begin
            counter <= 0;
            wlk <= ~wlk;
        end
        else
        counter <= counter + 1;
        
        end
        assign out_clk = counter == 0;
endmodule
