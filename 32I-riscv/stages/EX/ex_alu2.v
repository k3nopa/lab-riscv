module ex_alu2(
    input               is_signed, slt,
    input [3:0]         alu_op,
    input [31:0]        a, b, shift,

    output [31:0]       result
);
    wire [31:0] lui  = b;
    wire [31:0] add  = a + b;
    wire [31:0] sub  = a - b;
    wire [31:0] _and = a & b;
    wire [31:0] _or  = a | b;
    wire [31:0] _xor = a ^ b;

    assign result =
    (alu_op == `ALU_SLT) ? {{31{1'b0}}, slt}  :
    (alu_op == `ALU_ADD) ? add  :
    (alu_op == `ALU_SUB) ? sub  :
    (alu_op == `ALU_LUI) ? lui  :
    (alu_op == `ALU_AND) ? _and :
    (alu_op == `ALU_OR)  ? _or  :
    (alu_op == `ALU_XOR) ? _xor : shift;

endmodule