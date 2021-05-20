`default_nettype none 

`include "if_stage.v"
`include "id_stage.v"
`include "ex_stage.v"
`include "mem_stage.v"
`include "wb_stage.v"

`include "if_pc_adder.v"
`include "id_control.v"
`include "id_sign_extend.v"
`include "ex_alu.v"
`include "reg32.v"
`include "multiplexer.v"
`include "rf32x32.v"
`include "DW_ram_2r_w_s_dff.v"

module top (
    input clk,
    input rst,

    input ACKD_n, // acknowledge from data memory [active low]
    input ACKI_n, // acknowledge from instruction memory [active low]
    input [31:0] IDT, // instruction data bus
    input [2:0] OINT_n, // out interrupt [active low] 111 -> no interrupt

    inout [31:0] DDT, // data data bus

    output [31:0] IAD, // instruction address bus
    output [31:0] DAD, // data address bus
    output MREQ, // memory request [active high] for reading
    output WRITE, // write permission [active high]
    output [1:0] SIZE, // memory access bit size
    output IACK_n // interrupt acknowledge
);

    // If stage inputs and outputs
    wire pc_src = 1'b0;
    wire [31:0] pc, pc_in;

    // Id stage inputs and outputs
    wire mem_read, mem_write, alu_src, reg_write;
    wire [1:0] mem_to_reg, jump;
    wire [3:0] alu_op;
    wire [31:0] reg_data_in;

    // Mem stage inputs and outputs
    wire [31:0] branch_addr, mem_read_data, reg_read_data1, reg_read_data2, imm, alu_result;

    // Pipelines
    reg [31:0] IF_ID_PC4, ID_EX_PC4, EX_MEM_PC4, MEM_WB_PC4;
    reg [31:0] IF_ID_INST, ID_EX_INST, EX_MEM_INST, MEM_WB_INST;
    reg [31:0] EX_MEM_ALU, MEM_WB_ALU;
    reg [31:0] ID_EX_RD2, EX_MEM_RD2;
    reg [31:0] ID_EX_BRANCH_ADDR, ID_EX_RD1, ID_EX_SEXT, MEM_WB_MDATA;
    
    // Controls Pipelines
    reg ID_EX_MEM_READ, ID_EX_MEM_WRITE, ID_EX_ALU_SRC, ID_EX_REG_WRITE, EX_MEM_MEM_READ, EX_MEM_MEM_WRITE, EX_MEM_REG_WRITE, MEM_WB_REG_WRITE;
    reg [1:0] ID_EX_MEM_TO_REG, EX_MEM_MEM_TO_REG, MEM_WB_MEM_TO_REG; 
    reg [3:0] ID_EX_ALU_OP;
    
    reg32 PC(
        .reset(rst), .clk(clk), .d(pc_in),
        .q(pc)
    );

    if_stage if_phase(
        .reset(rst), .pc(pc), .branch_addr(ID_EX_BRANCH_ADDR), .pc_src(pc_src),
        .pc4(pc_in), .inst_addr(IAD)
    );

    id_stage id_phase(
        .reset(rst), .inst(IF_ID_INST), .pc4(IF_ID_PC4),
        .controls({mem_read, mem_write, alu_src, mem_to_reg, alu_op, reg_write, jump}),
        .inst_size(SIZE),
        .branch_addr(branch_addr), .sign_extend(imm)
    );
    
    /* ----- Register File ----- */
    rf32x32 regfile(
        .clk(clk), .reset(rst), .wr_n(MEM_WB_REG_WRITE),
        .rd1_addr(IF_ID_INST[19:15]), .rd2_addr(IF_ID_INST[24:20]), .wr_addr(MEM_WB_INST[11:7]),
        .data_in(reg_data_in),
        .data1_out(reg_read_data1), .data2_out(reg_read_data2)
    );

    ex_stage ex_phase(
        .alu_op(ID_EX_ALU_OP), .alu_src(ID_EX_ALU_SRC), .a(ID_EX_RD1), .b(ID_EX_RD2), .sext(ID_EX_SEXT),
        .branch_result(pc_src), .alu_result(alu_result)
    );

    mem_stage mem_phase(
        .address(EX_MEM_ALU), .write_data(EX_MEM_RD2), .mem_read(EX_MEM_MEM_READ), .mem_write(EX_MEM_MEM_WRITE), .rd_data(DDT),
        .read_data(mem_read_data), .addr(DAD), .write(WRITE), .mreq(MREQ), .wr_data(DDT)
    );

    wb_stage wb_phase(
        .pc4(MEM_WB_PC4), .mem_data(MEM_WB_MDATA), .alu_result(MEM_WB_ALU), .mem_to_reg(MEM_WB_MEM_TO_REG),
        .write_data(reg_data_in)
    );

    always @(posedge clk) begin
        IF_ID_PC4 <= pc_in;
        IF_ID_INST <= IDT;
    end

    always @(posedge clk) begin
        ID_EX_PC4 <= IF_ID_PC4;
        ID_EX_INST <= IF_ID_INST;
        ID_EX_BRANCH_ADDR <= branch_addr;
        ID_EX_RD1 <= reg_read_data1;
        ID_EX_RD2 <= reg_read_data2;
        ID_EX_SEXT <= imm;
        
        ID_EX_MEM_READ <= mem_read;
        ID_EX_MEM_WRITE <= mem_write;
        ID_EX_REG_WRITE <= reg_write;
        ID_EX_ALU_SRC <= alu_src;
        ID_EX_MEM_TO_REG <= mem_to_reg;
        ID_EX_ALU_OP <= alu_op;
    end

    always @(posedge clk) begin
        EX_MEM_PC4 <= ID_EX_PC4;
        EX_MEM_INST <= ID_EX_INST;
        EX_MEM_ALU <= alu_result;
        EX_MEM_RD2 <= ID_EX_RD2;
        
        EX_MEM_REG_WRITE <= ID_EX_REG_WRITE;
        EX_MEM_MEM_READ <= ID_EX_MEM_READ;
        EX_MEM_MEM_WRITE <= ID_EX_MEM_WRITE;
        EX_MEM_MEM_TO_REG <= ID_EX_MEM_TO_REG;
    end

    always @(posedge clk) begin
        MEM_WB_PC4 <= EX_MEM_PC4;
        MEM_WB_INST <= EX_MEM_INST;
        MEM_WB_MDATA <= mem_read_data;
        MEM_WB_ALU <= EX_MEM_ALU;
        
        MEM_WB_REG_WRITE <= EX_MEM_REG_WRITE;
        MEM_WB_MEM_TO_REG <= EX_MEM_MEM_TO_REG;
    end

endmodule
