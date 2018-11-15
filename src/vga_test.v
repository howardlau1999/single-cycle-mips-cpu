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
	
    wire up_edge;
    
	reg [11:0] rgb_reg;
	wire bg_wea;
	wire wlk;

	wire [11:0] rgb_pic;
	wire layer_on;
	wire video_on, f_tick;
	wire [9:0] x, y;
	reg [15:0] nums;
	wire [7:0] dina;
    wire [12:0] addr;
    wire [12:0] bg_ram_addr;
    wire [7:0] bam_data;
    
    wire [31:0] dbg_pc, dbg_next_pc, dbg_reg, dbg_db, dbg_reg_data, dbg_inst, dbg_rs, dbg_rt, dbg_rd, dbg_imm, dbg_shamt, dbg_funct, dbg_alurslt;
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
    
    cpu cpu(up_edge, sw[0], bg_wea, addr, dina, clk, dbg_pc, dbg_next_pc, dbg_reg, dbg_reg_data, dbg_rs, dbg_rt, dbg_alurslt, dbg_db);
    background_engine bg_engine(clk, video_on, x, y, bam_data, bg_ram_addr, layer_on, rgb_pic);
    vga_sync vga_sync_unit (.clk(clk), .clr(0), .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(), .f_tick(f_tick), .x(x), .y(y));
    display led_display(.basys3_clk(clk), .seg(seg), .ano(ano), .nums(nums));
    always @ * begin
        case (sw[15:14])
            2'b00: begin nums = {dbg_pc[7:0], dbg_next_pc[7:0]}; end
            2'b01: begin nums = {dbg_rs[7:0], dbg_reg_data[7:0]}; end
            2'b10: begin nums = {dbg_rt[7:0], dbg_reg_data[7:0]}; end
            2'b11: begin nums = {dbg_alurslt[7:0], dbg_db[7:0]}; end            
        endcase
    end 
    assign dbg_reg = sw[15:14] == 2'b01 ? dbg_rs : dbg_rt;
    always @ (posedge clk)

    begin
        if (layer_on)
            rgb_reg <= rgb_pic;
    end
    debouncer debouncer(clk, right, up_edge);
    assign dp = 1;
    assign rgb = (video_on & layer_on) ? rgb_reg : 12'b0;
endmodule