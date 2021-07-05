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

    wire            slt;
    wire        src_a = (branch_result) ? 0 : alu_src_a;
    wire        src_b = (branch_result) ? 1 : alu_src_b;

    wire [31:0] logic_a = (src_a) ? a : pc;
    wire [31:0] logic_b = (src_b) ? sext : b;


    ex_comparator comp_alu(
        .is_signed(is_signed),
        .alu_op(alu_op),
        .a(a),
        .b(b),

        .branch(branch_result),
        .slt(slt)
    );

    ex_arithmetic logic_alu(
        .is_signed(is_signed),
        .alu_op((branch_result) ? `ALU_ADD : alu_op),
        .slt(slt),
        .a(logic_a),
        .b(logic_b),

        .result(alu_result)
    );

    //    ex_alu1 alu_half1(
    //        .is_signed(is_signed),
    //        .alu_op(alu_op),
    //        .a(alu_a),
    //        .b(alu_b),
    //
    //        .branch(branch_result),
    //        .slt(slt),
    //        .shift(shift)
    //    );
    //
    //    ex_alu2 alu_half2(
    //        .is_signed(is_signed),
    //        .alu_op((branch_result) ? `ALU_ADD : alu_op),
    //        .slt(slt),
    //        .a(bra_a),
    //        .b(bra_b),
    //        .shift(shift),
    //
    //        .result(alu_result)
    //    );

endmodule
//    ex_alu alu(.a(alu_a), .b(alu_b), .op(alu_op), .is_signed(is_signed), .result(alu_result), .branch(branch_result));
//    function [31:0] a_selector(input [31:0] in_a, input [31:0] in_b, input select);
//        begin
//            case(select)
//                0:  a_selector = in_a; 
//                1:  a_selector = in_b; 
//            endcase
//        end
//    endfunction
//
//    function [31:0] b_selector(input [31:0] in_a, input [31:0] in_b, input select);
//        begin
//            case(select)
//                0:  b_selector = in_a; 
//                1:  b_selector = in_b; 
//            endcase
//        end
//    endfunction

//    assign alu_a = a_selector(pc, a, alu_src_a);
//    assign alu_b = b_selector(b, sext, alu_src_b);