module ex_alu(
    input           is_signed,
    input [31:0]    a, b,
    input [3:0]     op,

    output          branch, // 0: !branch, 1: branch
    output [31:0]   result
);

    function [31:0] arithematic(
        input [3:0] in_op,
        input [31:0] in_a, in_b
    );
        begin
            case (in_op)
                `ALU_LUI: arithematic = in_b;
                `ALU_ADD: arithematic = in_a + in_b;
                `ALU_SUB: arithematic = in_a - in_b;
                `ALU_MUL: arithematic = in_a * in_b;
                `ALU_AND: arithematic = in_a & in_b;
                `ALU_OR : arithematic = in_a | in_b;
                `ALU_XOR: arithematic = in_a ^ in_b;
                `ALU_SLL: arithematic = in_a << in_b;
                `ALU_SRL: arithematic = in_a >> in_b;
                `ALU_SRA: arithematic = $signed(in_a) >>> $signed(in_b);
                `ALU_SLT: begin
                    if (is_signed)
                        arithematic = ($signed(in_a) < $signed(in_b))  ? 1'b1 : 1'b0;
                    else
                        arithematic = (in_a < in_b)  ? 1'b1 : 1'b0;
                end
                default: arithematic = in_a + in_b;
            endcase
        end
    endfunction

    function _branch(
        input [3:0] in_op,
        input [31:0] in_a, in_b
    );

        begin
            case(in_op)
                `ALU_BEQ: _branch = (in_a == in_b) ? 1'b1 : 1'b0;
                `ALU_BNE: _branch = (in_a != in_b) ? 1'b1 : 1'b0;
                `ALU_BGE: begin
                    if(is_signed) begin
                        _branch = ($signed(in_a) >= $signed(in_b)) ? 1'b1 : 1'b0;
                    end
                    else
                        _branch = (in_a >= in_b) ? 1'b1 : 1'b0;
                end
                `ALU_BLT: begin
                    if(is_signed)
                        _branch = ($signed(in_a) < $signed(in_b)) ? 1'b1 : 1'b0;
                    else
                        _branch = (in_a < in_b) ? 1'b1 : 1'b0;
                end
                default: _branch = 1'b0;
            endcase
        end
    endfunction

    assign result = arithematic(op, a, b);
    assign branch = _branch(op, a, b);

endmodule
