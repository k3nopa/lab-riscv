module ex_stage (
    input [3:0] alu_op,
    input alu_src,
    input is_signed,
    input [31:0] a,
    input [31:0] b,
    input [31:0] sext,

    output branch_result,
    output [31:0] alu_result // alu result
);

    wire [31:0] alu_a, alu_b, test;

    function [63:0] src_mux(
        input in_alu_src,
        input [31:0] in_a, in_b, in_sext
    );
        begin
            case (in_alu_src)
                1 : src_mux = {in_a, in_sext};
                0 : src_mux = {in_a, in_b};
                default : src_mux = {in_a, in_b};
            endcase
        end
    endfunction

    assign {alu_a, alu_b} = src_mux(alu_src, a, b, sext);

    ex_alu alu(.a(alu_a), .b(alu_b), .op(alu_op), .is_signed(is_signed), .result(alu_result), .branch(branch_result));

endmodule