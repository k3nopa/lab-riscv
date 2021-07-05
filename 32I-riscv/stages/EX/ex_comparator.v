module ex_comparator(
    input               is_signed,
    input [3:0]         alu_op,
    input [31:0]        a, b,

    output              branch,
    output              slt
);

    wire [32:0] sub = {{1'b0}, a} - {{1'b0}, b};

    wire beq = ~|sub;
    wire bne =  |sub;
    wire bge = (is_signed)? ~sub[31] : ~sub[32];
    wire blt = (is_signed)? sub[31] : sub[32];

    assign branch =
    (alu_op == `ALU_BEQ) ? beq :
    (alu_op == `ALU_BNE) ? bne :
    (alu_op == `ALU_BGE) ? bge :
    (alu_op == `ALU_BLT) ? blt : 0;

    assign slt = (alu_op == `ALU_SLT) ? blt : 0;
endmodule