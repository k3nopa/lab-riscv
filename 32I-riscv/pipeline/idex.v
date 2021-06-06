/*
 * For Stall
 * We have to make sure if doesn't go into id too
 * For Jump 
 * It can go into ex stage but not update the processors state (memory or registers)
 */
module ID_EX_PIPE(
    input               clk, reset,
    input                stall1, stall2, branch, 

    input               mem_read_in, mem_write_in, alu_src_a_in, alu_src_b_in, reg_write_in, sign_in,
    input [1:0]         jump_in, mem_to_reg_in, mem_size_in,
    input [3:0]         alu_op_in,
    input [31:0]        pc_in, pc4_in, inst_in, branch_addr_in, sext_in,

    output reg          mem_read, mem_write, alu_src_a, alu_src_b, reg_write, sign,
    output reg [1:0]    jump, mem_to_reg, mem_size,
    output reg [3:0]    alu_op,
    output reg [31:0]   pc, pc4, inst, branch_addr, sext
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            mem_read <= 0;
            mem_write <= 0;
            alu_src_a <= 1'bx;
            alu_src_b <= 1'bx;
            reg_write <= 1;
            sign <= 0;

            jump <= 0;
            mem_to_reg <= 2'bx;
            mem_size <= 0;
            alu_op <= 0;

            pc <= 0;
            pc4 <= 0;
            inst <= 0;
            branch_addr <= 0;
            sext <= 0;
        end

        if(stall1 || stall2 || branch) begin
            pc <= pc_in;
            pc4 <= pc4_in;
            inst <= 0;

            mem_read <= 0;
            mem_write <= 0;
            reg_write <= 1;

            jump <= 2'bx;
            mem_to_reg <= 2'bx;
            alu_op <= 0;

        end
        else begin
            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            alu_src_a <= alu_src_a_in;
            alu_src_b <= alu_src_b_in;
            reg_write <= reg_write_in;
            sign <= sign_in;

            jump <= jump_in;
            mem_to_reg <= mem_to_reg_in;
            mem_size <= mem_size_in;
            alu_op <= alu_op_in;

            pc <= pc_in;
            pc4 <= pc4_in;
            inst <= inst_in;
            branch_addr <= branch_addr_in;
            sext <= sext_in;
        end
    end
endmodule
