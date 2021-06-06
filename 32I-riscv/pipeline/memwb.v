module MEM_WB_PIPE( 
    input           clk, reset,
    input [31:0]    pc4_in, inst_in, mem_rdata_in, alu_in,
    input [1:0]     mem_to_reg_in,
    input           reg_write_in,

    output reg [31:0]    pc4, inst, mem_rdata, alu,
    output reg [1:0]     mem_to_reg,
    output reg           reg_write
);
    always @(posedge clk) begin
        if (!reset) begin
            pc4 <= 0;
            inst <= 0;
            mem_rdata <= 0;
            alu <= 0;

            mem_to_reg <= 2'bx;

            reg_write <= 1;

        end

        else begin
            pc4 <= pc4_in;
            inst <= inst_in;
            mem_rdata <= mem_rdata_in;
            alu <= alu_in;

            mem_to_reg <= mem_to_reg_in;

            reg_write <= reg_write_in;
        end
    end
endmodule
