module ex_alu(
    input           is_signed,
    input [31:0]    a, b,
    input [3:0]     op,

    output          branch, // 0: !branch, 1: branch
    output [31:0]   result
);

    function [31:0] arithematic(
        input       is_signed,
        input [3:0] in_op,
        input [31:0] in_a, in_b
    );
        begin
            case (in_op)
                `ALU_LUI: arithematic = in_b;
                `ALU_ADD: arithematic = in_a + in_b;
                `ALU_SUB: arithematic = in_a - in_b;
                `ALU_AND: arithematic = in_a & in_b;
                `ALU_OR : arithematic = in_a | in_b;
                `ALU_XOR: arithematic = in_a ^ in_b;
                `ALU_SLL: arithematic = in_a << in_b;
                `ALU_SRL: arithematic = in_a >> in_b;
                `ALU_SRA: arithematic = $signed(in_a) >>> $signed(in_b);
                `ALU_SLT: arithematic = (is_signed) ? ($signed(in_a) < $signed(in_b))  ? 1'b1 : 1'b0 : (in_a < in_b)  ? 1'b1 : 1'b0;
                default: arithematic = in_a + in_b;
            endcase
        end
    endfunction

    //    function _branch(
    //        input       is_signed,
    //        input [3:0] in_op,
    //        input [31:0] in_a, in_b
    //    );
    //
    //        begin
    //            case(in_op)
    //                `ALU_BEQ: _branch = (in_a == in_b) ? 1'b1 : 1'b0;
    //                `ALU_BNE: _branch = (in_a != in_b) ? 1'b1 : 1'b0;
    //                `ALU_BGE: _branch = (is_signed) ? ($signed(in_a) >= $signed(in_b)) ? 1'b1 : 1'b0 : (in_a >= in_b) ? 1'b1 : 1'b0;
    //                `ALU_BLT: _branch = (is_signed) ? ($signed(in_a) < $signed(in_b)) ? 1'b1 : 1'b0 : (in_a < in_b) ? 1'b1 : 1'b0;
    //                default: _branch = 1'b0;
    //            endcase
    //        end
    //    endfunction
    function _branch (
        input       is_signed,
        input [3:0] in_op,
        input [31:0] in_a, in_b
    );
        reg [32:0] sub;
        begin
            sub = {{1'b0}, a} - {{1'b0}, b};
            case(in_op)
                `ALU_BEQ: _branch = ~|sub;
                `ALU_BNE: _branch = |sub;
                `ALU_BGE: _branch = (is_signed)? ~sub[31] : ~sub[32];
                `ALU_BLT: _branch = (is_signed)? sub[31] : sub[32];
                default: _branch = 1'b0;
            endcase
        end
    endfunction

    assign result = arithematic(is_signed, op, a, b);
    assign branch = _branch(is_signed, op, a, b);

endmodule
