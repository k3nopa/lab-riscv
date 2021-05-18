module id_stage (
    input clock,
    input reset,            // active at low
    input [31:0] inst, pc4,
    input [31:0] write_data,

    output [10:0] controls,
    output [1:0] inst_size,
    output [31:0] reg_a, reg_b,
    output [31:0] branch_addr,
    output [31:0] sign_extend
);

    // Control Unit
    wire mem_read, mem_write, alu_src;
    wire [1:0] mem_to_reg, jump;
    wire [3:0] alu_op;

    wire [4:0] rd_part = inst[11:7];
    wire [4:0] ra_part = inst[19:15];
    wire [4:0] rb_part = inst[24:20];
    
    /* ----- Control Unit ----- */
    id_control control_unit(
        .reset(reset), .inst(inst),
        .mem_read(mem_read), .mem_write(mem_write), .reg_write(reg_write),
        .alu_src(alu_src), .mem_to_reg(mem_to_reg), .jump(jump), .inst_size(inst_size), .alu_op(alu_op)
    );

    /* ----- Register File ----- */
    rf32x32 regfile(
        .clk(clock), .reset(reset), .wr_n(reg_write),
        .rd1_addr(ra_part), .rd2_addr(rb_part), .wr_addr(rd_part),
        .data_in(write_data),
        .data1_out(reg_a), .data2_out(reg_b)
    );
    
    id_sign_extend imm_extend(.clock(clock), .inst(inst), .extend_imm(sign_extend));

    /* ----- Address Adder ----- */
    assign branch_addr = pc4 + sign_extend;

    assign controls = {mem_read, mem_write, alu_src, mem_to_reg, jump, alu_op};

endmodule
