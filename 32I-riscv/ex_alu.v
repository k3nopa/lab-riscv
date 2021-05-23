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
    SHL = 4'd6,
    SHR = 4'd7,
    SLT = 4'd8,
    LUI = 4'd9,
    BEQ = 4'd10,
    BNE = 4'd11,
    BGE = 4'd12,
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
        
        reg unsigned in_u_a, in_u_b;

        begin
            case(in_op)
                BEQ: _branch = (in_a == in_b) ? 1'b1 : 1'b0;
                BNE: _branch = (in_a != in_b) ? 1'b1 : 1'b0;
                BGE: begin
                    if(is_signed)
                        _branch = (in_a >= in_b)  ? 1'b1 : 1'b0;
                    else begin
                        in_u_a = in_a;
                        in_u_b = in_b;
                        _branch = (in_u_a >= in_u_b)  ? 1'b1 : 1'b0;
                        end
                end
                BLT: begin
                    if(is_signed)
                        _branch = (in_a < in_b)  ? 1'b1 : 1'b0;
                    else begin
                        in_u_a = in_a;
                        in_u_b = in_b;
                        _branch = (in_u_a < in_u_b)  ? 1'b1 : 1'b0;
                        end
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
