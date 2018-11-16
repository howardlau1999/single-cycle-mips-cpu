`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 02:42:16 PM
// Design Name: 
// Module Name: cpu
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


module cpu(
    input wire clk, rst,
    output wire bg_wrt,
    output wire [12:0] bam_addr,
    output wire [7:0] bam_write_data,
    input  wire dbg_clk,
    
    output reg  [31:0] pc, next_pc, 
    input  wire [31:0] led_read,
    output wire [31:0] led_reg_data, led_rs, led_rt, led_alurslt, led_db
    );
    reg  [31:0] pc4;
    wire [31:0] inst;
    reg         pcsrc;
    wire [31:0] baddr, jaddr;
    wire        jump;
    
    wire [5:0]  opcode;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [5:0]  funct;
    wire [15:0] imm;
    wire [4:0]  shamt;
    wire [31:0] seimm, zeimm, alimm;  // sign extended immediate
    
    wire [31:0] rs_data, rt_data;
    wire        regdst;
    wire        branch_eq;
    wire        branch_ne;
    wire        branch_ltz;
    wire        halt;
    wire        memread;
    wire        memwrite;
    wire        memtoreg;
    wire [1:0]  aluop;
    wire        regwrite;
    wire        alusrc_a, alusrc_b, extsel;
    wire [4:0]  wrreg;
    wire [31:0] wrdata;
    
    wire [4:0]  dbg_reg;
    wire [31:0] dbg_reg_data;
    
    wire [31:0]  dbg_ram_addr;
    wire [31:0] dbg_ram_data;
    
    reg working;
    initial begin
        pc4 = 0;
        pc = 0;
        working = 0;
    end
    always @ * begin
        pc4 = pc + 4;
        if (pcsrc) next_pc = baddr;
        else if (jump) next_pc <= jaddr;
        else if (halt | ~working) next_pc <= pc; 
        else next_pc <= pc4;
    end
    always @ (posedge clk) begin
        if (rst) begin
            pc <= 0;
            working <= 0;
        end else begin
            if (pcsrc) pc <= baddr;
            else if (jump) pc <= jaddr;
            else if (halt | ~working) pc <= pc; 
            else pc <= pc4;
            working <= 1;
        end
    end
   // IF
    inst_mem im(pc, inst);
   // ID
    assign opcode   = inst[31:26];
    assign rs       = inst[25:21];
    assign rt       = inst[20:16];
    assign rd       = inst[15:11];
    assign imm      = inst[15:0];
    assign shamt    = inst[10:6];
    assign funct    = inst[5:0];
    assign jaddr    = {pc[31:28], inst[25:0], {2{1'b0}}};
    assign seimm    = {{16{inst[15]}}, inst[15:0]};
    assign zeimm    = {16'd0, inst[15:0]};
    // branch address
    assign baddr = pc4 + (seimm << 2);
  
    reg_file regs(.clk(clk), .rst(rst),
                  .read1(rs), .read2(rt), .data1(rs_data), .data2(rt_data), 
                  .dbg_read(dbg_reg), .dbg_data(dbg_reg_data), .led_read(led_read), .led_data(led_reg_data),
                  .regwrite(regwrite), .wrreg(wrreg), .wrdata(wrdata));
                  
    cpu_control control(.opcode(opcode), .regdst(regdst),
                .branch_eq(branch_eq), .branch_ne(branch_ne), .branch_ltz(branch_ltz),
                .halt(halt),.memread(memread),.memtoreg(memtoreg), .aluop(aluop), .extsel(extsel),
                .memwrite(memwrite), .alusrc_a(alusrc_a), .alusrc_b(alusrc_b),
                .regwrite(regwrite), .jump(jump));
    // EX
    wire [31:0] alu_data1, alu_data2;
    assign alu_data1 = (alusrc_a) ? shamt : rs_data;
    assign alimm = (extsel ? seimm : imm);
    assign alu_data2 = (alusrc_b) ?  alimm : rt_data;
    // ALU control
    wire [3:0] aluctl;
    ALU_control alu_ctl(.opcode(opcode), .funct(funct), .aluop(aluop), .aluctl(aluctl));
    // ALU
    wire [31:0]    alurslt;
    wire           zero;
    ALU alu(.control(aluctl), .a(alu_data1), .b(alu_data2), .rslt(alurslt), .zero(zero));
   
    // MEM
    assign wrreg = (regdst) ? rd : rt;
    wire [31:0] rdata;
    data_mem dm(.clk(clk), .rst(rst), .addr(alurslt), .rd(memread), .wr(memwrite),
            .wdata(rt_data), .rdata(rdata), .dbg_ram_addr(dbg_ram_addr), .dbg_ram_data(dbg_ram_data));
            
    always @(*) begin
        pcsrc = (branch_eq & zero) | (branch_ne & ~zero) | (branch_ltz & ~zero);
    end
    
    // WB
    assign wrdata = memtoreg ? rdata : alurslt;
    
    // debug
    
    assign led_rs = rs;
    assign led_rt = rt;
    assign led_alurslt = alurslt;
    assign led_db = wrdata;
    debug_screen debug_screen(.clk(dbg_clk), .pc(pc), .reg_data(dbg_reg_data), .reg_addr(dbg_reg), .ram_data(dbg_ram_data), .ram_addr(dbg_ram_addr),
            .inst(inst), .rs(rs), .rt(rt), .rd(rd), .imm(imm), .shamt(shamt), .funct(funct), .alurslt(alurslt),
            .bg_wrt(bg_wrt), .bam_addr(bam_addr), .bam_write_data(bam_write_data));    
endmodule
