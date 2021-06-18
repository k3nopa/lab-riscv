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

    function [31:0] a_selector(input [31:0] in_a, input [31:0] in_b, input select);
        begin
            case(select)
                0:  a_selector = in_a; 
                1:  a_selector = in_b; 
            endcase
        end
    endfunction

    function [31:0] b_selector(input [31:0] in_a, input [31:0] in_b, input select);
        begin
            case(select)
                0:  b_selector = in_a; 
                1:  b_selector = in_b; 
            endcase
        end
    endfunction

    assign alu_a = a_selector(pc, a, alu_src_a);
    assign alu_b = b_selector(b, sext, alu_src_b);

    ex_alu alu(.a(alu_a), .b(alu_b), .op(alu_op), .is_signed(is_signed), .result(alu_result), .branch(branch_result));

endmodule