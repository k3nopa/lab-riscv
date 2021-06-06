module EX_MEM_PIPE(
    input               clk, reset,
    input [31:0]        pc_in, pc4_in, inst_in, alu_in, rs2_in, 
    input               mem_read_in, mem_write_in, reg_write_in, sign_in,
    input [1:0]         mem_to_reg_in, mem_size_in,

    output reg [31:0]   pc, pc4, inst, alu, rs2, 
    output reg          mem_read, mem_write, reg_write, sign,
    output reg [1:0]    mem_to_reg, mem_size
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            pc <= 0;
            pc4 <= 0;
            inst <= 0;
            alu <= 0;
            rs2 <= 0;

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
            inst <= inst_in;
            alu <= alu_in;
            rs2 <= rs2_in;

            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            reg_write <= reg_write_in;
            sign <= sign_in;
            
            mem_to_reg <= mem_to_reg_in;
            mem_size <= mem_size_in;
        end
    end
endmodule
