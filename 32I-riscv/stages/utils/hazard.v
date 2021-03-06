module hazard(
    input [6:0]     if_id_op, id_ex_op, ex_mem_op,
    input [4:0]     if_id_reg_src1, if_id_reg_src2,
    input [4:0]     id_ex_rd,
    input [4:0]     ex_mem_rd,

    output is_hazard1, is_hazard2,
    output [2:0] hazard_reg1, hazard_reg2
);

    wire [3:0] hazard1, hazard2;
    wire [2:0] tgt1 = hazard1[2:0];
    wire [2:0] tgt2 = hazard2[2:0];

    hazard_detection hazard_detect_unit1(
        .current_op(if_id_op),
        .before_op(id_ex_op),
        .before_rd(id_ex_rd),
        .current_reg_src1(if_id_reg_src1),
        .current_reg_src2(if_id_reg_src2),
        .next(1'b0),
        
        .hazard(hazard1)
    );

    hazard_detection hazard_detect_unit2(
        .current_op(if_id_op),
        .before_op(ex_mem_op),
        .before_rd(ex_mem_rd),
        .current_reg_src1(if_id_reg_src1),
        .current_reg_src2(if_id_reg_src2),
        .next(1'b1),
        
        .hazard(hazard2)
    );

    // set to zero, so it will forward the data from regfile
    //    assign {is_hazard2, hazard_reg2} = (hazard1[2:0] == 1 && hazard2[2:0] == 3 || hazard1[2:0] == 3 && hazard2[2:0] == 1) ? 4'd0 : hazard2;
    //    assign {is_hazard1, hazard_reg1} = (hazard1[2:0] == 2 && hazard2[2:0] == 4 || hazard1[2:0] == 4 && hazard2[2:0] == 2) ? 4'd0 : hazard1;
    assign {is_hazard1, hazard_reg1} = hazard1;
    assign {is_hazard2, hazard_reg2} = 
    (tgt1 == 1 && tgt2 == 3 || tgt1 == 3 && tgt2 == 1 || tgt1 == 2 && tgt2 == 4 || tgt1 == 4 && tgt2 == 2) ? 4'd0 : hazard2;
endmodule
