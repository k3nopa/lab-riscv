module ex_alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output branch, // 0: !branch, 1: branch
    output [31:0] result
);
    // ALU constants
    localparam [3:0]
    ADD = 4'd0,
    SUB = 4'd1,
    MUL = 4'd2,
    AND = 4'd3,
    OR = 4'd4,
    XOR = 4'd5,
    SHL = 4'd6,
    SHR = 4'd7,
    SLT = 4'd8,
    SLTU = 4'd9,
    LUI = 4'd10,
    BEQ = 4'd11,
    BGT = 4'd12,
    BLT = 4'd13;


    function [31:0] arithematic;
        input [3:0] in_op;
        input [31:0] in_a, in_b;

        begin
            case (in_op)
                LUI: arithematic = 32'h0 + in_b;
                ADD: arithematic = in_a + in_b;
                SUB: arithematic = in_a - in_b;
                MUL: arithematic = in_a * in_b;
                AND: arithematic = in_a & in_b;
                OR : arithematic = in_a | in_b;
                XOR: arithematic = in_a ^ in_b;
                SHL: arithematic = in_a << in_b;
                SHR: arithematic = in_a >> in_b;
                SLT: arithematic = (in_a < in_b)  ? 1'b1 : 1'b0;
                default: begin
                    arithematic = in_a + in_b;
                end
            endcase
        end
    endfunction

    function _branch;
        input [3:0] in_op;
        input [31:0] in_a, in_b;

        begin
            case(in_op)
                BEQ: _branch = (in_a == in_b) ? 1'b1 : 1'b0;
                BGT: _branch = (in_a > in_b)  ? 1'b1 : 1'b0;
                BLT: _branch = (in_a < in_b)  ? 1'b1 : 1'b0;
                default: begin
                    _branch = 1'b0;
                end
            endcase
        end
    endfunction

    assign result = arithematic(op, a, b);
    assign branch = _branch(op, a, b);

endmodule
