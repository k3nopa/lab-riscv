module EX_MEM_PIPE(
    input               clk, reset,
    input               mem_read_in, mem_write_in, reg_write_in, sign_in,
    input [1:0]         mem_to_reg_in, mem_size_in,
    input [4:0]         rd_in, reg_src1_in, reg_src2_in,
    input [6:0]         op_in,
    input [31:0]        pc_in, pc4_in, alu_in, rs2_in, 

    output reg          mem_read, mem_write, reg_write, sign,
    output reg [1:0]    mem_to_reg, mem_size,
    output reg [4:0]    rd, reg_src1, reg_src2,
    output reg [6:0]    op,
    output reg [31:0]   pc, pc4, alu, rs2 
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            pc <= 0;
            pc4 <= 0;
            alu <= 0;
            rs2 <= 0;
            
            op <= 0;
            rd <= 0;
            reg_src1 <= 0;
            reg_src2 <= 0;

            mem_read <= 0;
            mem_write <= 0;
            reg_write <= 1;
            sign <= 0;
            
            mem_to_reg <= 2'bx;
            mem_size <= 0;
        end
        else begin
            pc <= pc_in;
            pc4 <= pc4_in;
            alu <= alu_in;
            rs2 <= rs2_in;

            op <= op_in;
            rd <= rd_in;
            reg_src1 <= reg_src1_in;
            reg_src2 <= reg_src2_in;

            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            reg_write <= reg_write_in;
            sign <= sign_in;
            
            mem_to_reg <= mem_to_reg_in;
            mem_size <= mem_size_in;
        end
    end
endmodule
