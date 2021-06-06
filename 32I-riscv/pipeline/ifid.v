module IF_ID_PIPE(
    input clk, reset, branch,
    input [1:0] jump,
    input [31:0] pc_in, pc4_in, inst_in,
    output reg [31:0] pc, pc4, inst
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            pc <= 0;
            pc4 <= 0;
            inst <= 0;
        end
    else if (jump == 2'd2 && !branch) begin
            pc <= pc_in;
            pc4 <= pc4_in;
            inst <= 0;
        end
        else begin
            pc <= pc_in;
            pc4 <= pc4_in;
            inst <= inst_in;
        end
    end
endmodule
