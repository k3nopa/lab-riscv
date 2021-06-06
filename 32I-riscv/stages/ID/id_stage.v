module id_stage (
    input reset,            // active at low
    input [31:0] inst, pc,
    
    output is_signed,
    output [12:0] controls,
    output [1:0] inst_size,
    output [31:0] branch_addr,
    output [31:0] sign_extend
);

    // Control Unit
    wire mem_read, mem_write, alu_src_a, alu_src_b, reg_write;
    wire [1:0] mem_to_reg, jump;
    wire [3:0] alu_op;
    wire [4:0] shift_amount;
    wire [31:0] extend_imm;
    
    /* ----- Control Unit ----- */
    id_control control_unit(
        .reset(reset), .inst(inst),
        .mem_read(mem_read), .mem_write(mem_write), .reg_write(reg_write),
        .alu_src_a(alu_src_a), .alu_src_b(alu_src_b), .mem_to_reg(mem_to_reg), .jump(jump), 
        .inst_size(inst_size), .is_signed(is_signed), .alu_op(alu_op), .shift_amount(shift_amount)
    );
    
    id_sign_extend imm_extend(.inst(inst), .extend_imm(extend_imm));

    /* ----- Address Adder ----- */
    assign sign_extend = (shift_amount !== 5'hx) ? shift_amount : extend_imm;
    assign branch_addr = pc + extend_imm;

    assign controls = {mem_read, mem_write, alu_src_a, alu_src_b, mem_to_reg, alu_op, reg_write, jump};

endmodule
