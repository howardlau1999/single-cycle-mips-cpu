`timescale 1ns / 1ns

module background_engine(
    input wire clk,
    input wire video_on,
    input wire [9:0] x, y,
    input wire [7:0] ram_data,
    output reg [12:0] ram_addr,
    output wire pixel_on,
    output wire [11:0] color
);
reg [13:0] rom_addr;
reg [6:0] rom_x;
reg [5:0] rom_y;
wire [11:0] rom_data;
parameter TILE_WIDTH = 8;
parameter TILE_HEIGHT = 8;
parameter TILE_COLS = 640 / TILE_WIDTH;
parameter TILE_ROWS = 480 / TILE_HEIGHT;

`define TILE_COL ram_data[3:0]
`define TILE_ROW ram_data[7:4]
`define POS_X (x / TILE_WIDTH)
`define POS_Y (y / TILE_HEIGHT)

bg_rom bg_rom(.clk(clk), .video_on(video_on), .x(rom_x), .y(rom_y), .color(rom_data));

always @ * begin
  ram_addr = `POS_X + `POS_Y  * TILE_COLS;
  rom_x = `TILE_COL * TILE_WIDTH + x  % TILE_WIDTH;
  rom_y = `TILE_ROW * TILE_HEIGHT + y % TILE_HEIGHT;
end

assign pixel_on = ~(rom_data == 12'h00f);
assign color = (rom_data == 12'h00f) ? 12'b0 : rom_data;

endmodule // background_engine
