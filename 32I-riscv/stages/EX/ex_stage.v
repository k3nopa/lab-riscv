module ex_stage (
    input           alu_src_a,
    input           alu_src_b,
    input           is_signed,
    input [3:0]     alu_op,
    input [31:0]    pc,
    input [31:0]    a,
    input [31:0]    b,
    input [31:0]    sext,

    output          branch_result,
    output [31:0]   alu_result
);

    wire [31:0] alu_a, alu_b, test;

    function [63:0] src_mux(
        input alu_src_a, alu_src_b,
        input [31:0] in_pc, in_a, in_b, in_sext
    );
        reg [31:0] _a, _b;
        begin
            case (alu_src_a)
                0:_a = pc;
                1:_a = in_a;
                default : ;
            endcase

            case (alu_src_b)
                0:_b = in_b;
                1:_b = in_sext;
                default : ;
            endcase
            
            src_mux = {_a, _b};
        end
    endfunction

    assign {alu_a, alu_b} = src_mux(alu_src_a, alu_src_b, pc, a, b, sext);

    ex_alu alu(.a(alu_a), .b(alu_b), .op(alu_op), .is_signed(is_signed), .result(alu_result), .branch(branch_result));

endmodule