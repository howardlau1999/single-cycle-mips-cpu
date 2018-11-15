module vga_display
	(
		input wire clk, clr,
		input wire [15:0] sw,
		input wire up, down, left, right, 
		output wire hsync, vsync,
		output wire [11:0] rgb,
		output wire [6:0] seg,
        output wire [3:0] ano,
        output wire dp
	);
	reg [31:0] up_reg;
    wire up_edge;
    
	reg [11:0] rgb_reg;
	wire bg_wea;
	wire wlk;

	wire [11:0] rgb_pic;
	wire layer_on;
	wire video_on, f_tick;
	wire [9:0] x, y;
	wire [15:0] nums;
	wire [7:0] dina;
    wire [12:0] addr;
    wire [12:0] bg_ram_addr;
    wire [7:0] bam_data;
    
    wire [4:0] dbg_reg;
    wire [31:0] dbg_pc, dbg_reg_data, dbg_inst, dbg_rs, dbg_rt, dbg_rd, dbg_imm, dbg_shamt, dbg_funct, dbg_alurslt;
    ram #(
        .RAM_WIDTH(8), 
        .RAM_DEPTH(4800), 
        .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
        .INIT_FILE("debug_screen.hex")
      ) bg_ram (
        .addra(addr),
        .addrb(bg_ram_addr),
        .dina(dina), 
        .clka(clk),     
        .wea(bg_wea),    
        .enb(1), .rstb(0),    
        .regceb(1), .doutb(bam_data)
      );
    
    cpu cpu(up_edge, bg_wea, addr, dina, clk, dbg_pc);
    background_engine bg_engine(clk, video_on, x, y, bam_data, bg_ram_addr, layer_on, rgb_pic);
    vga_sync vga_sync_unit (.clk(clk), .clr(0), .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(), .f_tick(f_tick), .x(x), .y(y));
    display led_display(.basys3_clk(clk), .seg(seg), .ano(ano), .nums(nums));
              
    always @ (posedge clk)

    begin
        if (layer_on)
            rgb_reg <= rgb_pic;
        up_reg <= {up_reg[30:0], up};
    end
    
    assign nums = dbg_pc;
    assign dp = 1;
    assign rgb = (video_on & layer_on) ? rgb_reg : 12'b0;
    assign up_edge = ~(|up_reg) & up;
endmodule