module comparator( // @suppress "File contains multiple design units"
    input               is_signed,
    input [3:0]         alu_op,
    input [32:0]        sub,

    output              branch,
    output              slt
);
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

module shifter( // @suppress "File contains multiple design units"
    input           is_signed,
    input [3:0]     alu_op,
    input [31:0]    a, b,

    output [31:0]   shift
);

    wire [31:0] sll = a << b;
    wire [31:0] srl = a >> b;
    wire [31:0] sra = $signed(a) >>> $signed(b);

    assign shift =
    (alu_op == `ALU_SLL)? sll :
    (alu_op == `ALU_SRL)? srl :
    (alu_op == `ALU_SRA)? sra : 0;

endmodule

module ex_alu1( // @suppress "File contains multiple design units"
    input           is_signed,
    input [3:0]     alu_op,
    input [31:0]    a, b,

    output          branch, slt,
    output [31:0]   shift
);

    comparator comp_alu(
        .is_signed(is_signed),
        .alu_op(alu_op),
        .sub({{1'b0}, a} - {{1'b0}, b}),

        .branch(branch),
        .slt(slt)
    );

    shifter shifter_alu(
        .is_signed(is_signed),
        .alu_op(alu_op),
        .a(a),
        .b(b),

        .shift(shift)
    );

endmodule
