module ex_alu(
    input is_signed,
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
    SLL = 4'd6,
    SRL = 4'd7,
    SRA = 4'd8,
    SLT = 4'd9,
    LUI = 4'd10,
    BEQ = 4'd11,
    BNE = 4'd12,
    BGE = 4'd13,
    BLT = 4'd14;


    function [31:0] arithematic(
        input [3:0] in_op,
        input [31:0] in_a, in_b
    );
        reg signed [31:0] s_in_a, s_in_b;

        begin
            s_in_a = in_a;
            s_in_b = in_b;
            case (in_op)
                LUI: arithematic = in_b;
                ADD: arithematic = in_a + in_b;
                SUB: arithematic = in_a - in_b;
                MUL: arithematic = in_a * in_b;
                AND: arithematic = in_a & in_b;
                OR : arithematic = in_a | in_b;
                XOR: arithematic = in_a ^ in_b;
                SLL: arithematic = in_a << in_b;
                SRL: arithematic = in_a >> in_b;
                SRA: arithematic = s_in_a >>> in_b;
                SLT: begin
                    if (is_signed) 
                        arithematic = (s_in_a < s_in_b)  ? 1'b1 : 1'b0; 
                    else
                        arithematic = (in_a < in_b)  ? 1'b1 : 1'b0;
                end
                default: arithematic = in_a + in_b;
            endcase
        end
    endfunction

    function _branch;
        input [3:0] in_op;
        input [31:0] in_a, in_b;

        reg signed in_s_a, in_s_b;

        begin
            case(in_op)
                BEQ: _branch = (in_a == in_b) ? 1'b1 : 1'b0;
                BNE: _branch = (in_a != in_b) ? 1'b1 : 1'b0;
                BGE: begin
                    if(is_signed) begin
                        in_s_a = in_a;
                        in_s_b = in_b;
                        _branch = (in_s_a >= in_s_b)  ? 1'b1 : 1'b0;
                    end
                    else
                        _branch = (in_a >= in_b)  ? 1'b1 : 1'b0;
                end
                BLT: begin
                    if(is_signed) begin
                        in_s_a = in_a;
                        in_s_b = in_b;
                        _branch = (in_s_a < in_s_b)  ? 1'b1 : 1'b0;
                    end
                    else
                        _branch = (in_a < in_b)  ? 1'b1 : 1'b0;
                end
                default: begin
                    _branch = 1'b0;
                end
            endcase
        end
    endfunction

    assign result = arithematic(op, a, b);
    assign branch = _branch(op, a, b);

endmodule
