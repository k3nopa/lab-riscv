`default_nettype none 

`include "constants.v"
`include "stages/IF/if_stage.v"
`include "stages/ID/id_stage.v"
`include "stages/ID/id_control.v"
`include "stages/ID/id_sign_extend.v"
//`include "stages/EX/ex_alu.v"
`include "stages/EX/ex_alu1.v"
`include "stages/EX/ex_alu2.v"
`include "stages/EX/ex_stage.v"
`include "stages/MEM/mem_stage.v"
`include "stages/WB/wb_stage.v"

`include "stages/utils/reg32.v"
`include "stages/utils/hazard.v"
`include "stages/utils/hazard_detection.v"
`include "stages/utils/forwarding.v"
`include "stages/utils/stalling.v"
`include "stages/utils/rf32x32.v"
`include "stages/utils/DW_ram_2r_w_s_dff.v"

`include "pipeline/ifid.v"
`include "pipeline/idex.v"
`include "pipeline/exmem.v"
`include "pipeline/memwb.v"

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

    wire [31:0]     pc, pc_in, pc4;
    wire            pc_src;

    wire            mem_read, mem_write, alu_src_a, alu_src_b, reg_write, is_signed;
    wire [1:0]      mem_to_reg, jump, mem_size;
    wire [3:0]      alu_op;
    wire [31:0]     reg_data_in;

    wire [31:0]     branch_addr, sext;
    wire [1:0]      inst_size;
    wire [31:0]     mem_rdata, rs1_data, rs2_data, alu, rd_write_data;

    // Forwarding & Hazard Detection & Stall
    wire            is_hazard1, is_hazard2, stall;
    wire [2:0]      hazard_reg1, hazard_reg2;
    wire [31:0]     rs1_in, rs2_in;

    // Pipelines
    wire [31:0]     if_id_pc, if_id_pc4, if_id_inst;

    wire [31:0]     id_ex_pc, id_ex_pc4, id_ex_inst, id_ex_branch_addr, id_ex_rs1, id_ex_rs2, id_ex_sext;
    wire [3:0]      id_ex_alu_op;
    wire [1:0]      id_ex_jump, id_ex_mem_to_reg, id_ex_mem_size;
    wire            id_ex_mem_read, id_ex_mem_write, id_ex_alu_src_a, id_ex_alu_src_b, id_ex_reg_write, id_ex_sign;

    wire [31:0]     ex_mem_pc, ex_mem_pc4, ex_mem_inst, ex_mem_alu, ex_mem_rs2;
    wire [1:0]      ex_mem_mem_to_reg, ex_mem_mem_size;
    wire            ex_mem_mem_read, ex_mem_mem_write, ex_mem_reg_write, ex_mem_sign;

    wire [31:0]     mem_wb_pc4, mem_wb_inst, mem_wb_mem_rdata, mem_wb_alu;
    wire [1:0]      mem_wb_mem_to_reg;
    wire            mem_wb_reg_write;

    reg32 PC(
        .reset(rst), 
        .clk(clk), 
        .d(pc4),
        
        .q(pc)
    );

    if_stage if_phase(
        .pc(pc), 
//        .branch_addr(id_ex_branch_addr), 
        .branch_addr(alu), 
        .jump_addr(alu), 
        .pc_src(pc_src), 
        .jump(id_ex_jump), 
        .stall(stall),
        
        .pc4(pc4), 
        .inst_addr(IAD)
    );

    IF_ID_PIPE if_id(
        .clk(clk), 
        .reset(rst),
        .pc_in(IAD), 
        .pc4_in(pc4), 
        .inst_in(IDT), 
        .jump(jump), 
        .branch(pc_src),
        
        .pc(if_id_pc), 
        .pc4(if_id_pc4), 
        .inst(if_id_inst)
    );

    id_stage id_phase(
        .reset(rst), 
        .inst(if_id_inst), 
        .pc(if_id_pc),
        
        .controls({mem_read, mem_write, alu_src_a, alu_src_b, mem_to_reg, alu_op, reg_write, jump}),
        .inst_size(inst_size), 
        .is_signed(is_signed),
//        .branch_addr(branch_addr), 
        .sign_extend(sext)
    );

    rf32x32 regfile(
        .clk(clk), 
        .reset(rst), 
        .wr_n(mem_wb_reg_write),
        .rd1_addr(if_id_inst[19:15]), 
        .rd2_addr(if_id_inst[24:20]), 
        .wr_addr(mem_wb_inst[11:7]),
        .data_in(rd_write_data),
        
        .data1_out(rs1_data), 
        .data2_out(rs2_data)
    );

    ID_EX_PIPE id_ex(
        .clk(clk), 
        .reset(rst),
        .stall(stall), 
        .branch(pc_src),
        .mem_read_in(mem_read), 
        .mem_write_in(mem_write), 
        .alu_src_a_in(alu_src_a), 
        .alu_src_b_in(alu_src_b), 
        .reg_write_in(reg_write), 
        .sign_in(is_signed),
        .jump_in(jump), 
        .mem_to_reg_in(mem_to_reg), 
        .mem_size_in(inst_size),
        .alu_op_in(alu_op),
        .pc_in(if_id_pc), 
        .pc4_in(if_id_pc4), 
        .inst_in(if_id_inst), 
//        .branch_addr_in(branch_addr), 
        .sext_in(sext), 
        .rs1_in(rs1_in), 
        .rs2_in(rs2_in),

        .mem_read(id_ex_mem_read), 
        .mem_write(id_ex_mem_write), 
        .alu_src_a(id_ex_alu_src_a), 
        .alu_src_b(id_ex_alu_src_b), 
        .reg_write(id_ex_reg_write), 
        .sign(id_ex_sign),
        .jump(id_ex_jump), 
        .mem_to_reg(id_ex_mem_to_reg), 
        .mem_size(id_ex_mem_size),
        .alu_op(id_ex_alu_op),
        .pc(id_ex_pc), 
        .pc4(id_ex_pc4), 
        .inst(id_ex_inst), 
//        .branch_addr(id_ex_branch_addr), 
        .sext(id_ex_sext), 
        .rs1(id_ex_rs1), 
        .rs2(id_ex_rs2)
    );

    ex_stage ex_phase(
        .alu_op(id_ex_alu_op), 
        .alu_src_a(id_ex_alu_src_a), 
        .alu_src_b(id_ex_alu_src_b), 
        .is_signed(id_ex_sign), 
        .pc(id_ex_pc), 
        .a(id_ex_rs1), 
        .b(id_ex_rs2), 
        .sext(id_ex_sext),
        
        .branch_result(pc_src), 
        .alu_result(alu)
    );

    EX_MEM_PIPE ex_mem(
        .clk(clk), 
        .reset(rst),
        .pc_in(id_ex_pc), 
        .pc4_in(id_ex_pc4), 
        .inst_in(id_ex_inst), 
        .alu_in(alu), 
        .rs2_in(id_ex_rs2),
        .mem_read_in(id_ex_mem_read), 
        .mem_write_in(id_ex_mem_write), 
        .reg_write_in(id_ex_reg_write), 
        .sign_in(id_ex_sign),
        .mem_to_reg_in(id_ex_mem_to_reg), 
        .mem_size_in(id_ex_mem_size),

        .pc(ex_mem_pc), 
        .pc4(ex_mem_pc4), 
        .inst(ex_mem_inst), 
        .alu(ex_mem_alu), 
        .rs2(ex_mem_rs2),
        .mem_read(ex_mem_mem_read), 
        .mem_write(ex_mem_mem_write), 
        .reg_write(ex_mem_reg_write), 
        .sign(ex_mem_sign),
        .mem_to_reg(ex_mem_mem_to_reg), 
        .mem_size(ex_mem_mem_size)
    );

    mem_stage mem_phase(
        .address(ex_mem_alu), 
        .write_data(ex_mem_rs2), 
        .mem_read(ex_mem_mem_read), 
        .mem_write(ex_mem_mem_write), 
        .inst_size(ex_mem_mem_size), 
        .is_signed(ex_mem_sign), 
        .rd_data(DDT),
        
        .access_size(SIZE), 
        .read_data(mem_rdata), 
        .addr(DAD), 
        .write(WRITE), 
        .mreq(MREQ), 
        .wr_data(DDT)
    );

    MEM_WB_PIPE mem_wb(
        .clk(clk), 
        .reset(rst),
        .pc4_in(ex_mem_pc4), 
        .inst_in(ex_mem_inst), 
        .mem_rdata_in(mem_rdata), 
        .alu_in(ex_mem_alu),
        .mem_to_reg_in(ex_mem_mem_to_reg),
        .reg_write_in(ex_mem_reg_write),

        .pc4(mem_wb_pc4), 
        .inst(mem_wb_inst), 
        .mem_rdata(mem_wb_mem_rdata), 
        .alu(mem_wb_alu),
        .mem_to_reg(mem_wb_mem_to_reg),
        .reg_write(mem_wb_reg_write)
    );

    wb_stage wb_phase(
        .pc4(mem_wb_pc4), 
        .mem_rdata(mem_wb_mem_rdata), 
        .alu_result(mem_wb_alu), 
        .rd(mem_wb_inst[11:7]), 
        .mem_to_reg(mem_wb_mem_to_reg),
        
        .write_data(rd_write_data)
    );

    hazard hazard_unit(
        .if_id_inst(if_id_inst), 
        .id_ex_inst(id_ex_inst), 
        .ex_mem_inst(ex_mem_inst),
        
        .is_hazard1(is_hazard1), 
        .is_hazard2(is_hazard2),
        .hazard_reg1(hazard_reg1), 
        .hazard_reg2(hazard_reg2)
    );

    stalling stall_unit(
        .if_inst(if_id_inst), 
        .id_inst(id_ex_inst), 
        
        .stall(stall)
    );

    forwarding forwarder(
        .is_hazard1(is_hazard1), 
        .is_hazard2(is_hazard2),
        .hazard_reg1(hazard_reg1), 
        .hazard_reg2(hazard_reg2),
        .op(ex_mem_inst[6:0]),
        .pc4_in(ex_mem_pc4), 
        .alu_in(alu), 
        .mem_alu_in(ex_mem_alu), 
        .mem_rdata_in(mem_rdata), 
        .rs1_in(rs1_data), 
        .rs2_in(rs2_data),

        .rs1(rs1_in), 
        .rs2(rs2_in)
    );
endmodule
