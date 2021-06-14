module hazard(
    input [31:0] if_id_inst, id_ex_inst, ex_mem_inst,

    output is_hazard1, is_hazard2,
    output [2:0] hazard_reg1, hazard_reg2
);

    wire [3:0] hazard1, hazard2;

    hazard_detection hazard_detect_unit1(
        .current(if_id_inst), .before(id_ex_inst), .next(1'b0),
        .hazard(hazard1)
    );

    hazard_detection hazard_detect_unit2(
        .current(if_id_inst), .before(ex_mem_inst), .next(1'b1),
        .hazard(hazard2)
    );

    // set to zero, so it will forward the data from regfile
    assign {is_hazard2, hazard_reg2} = (hazard1[2:0] == 1 && hazard2[2:0] == 3 || hazard1[2:0] == 3 && hazard2[2:0] == 1) ? 4'd0 : hazard2;
    assign {is_hazard1, hazard_reg1} = (hazard1[2:0] == 2 && hazard2[2:0] == 4 || hazard1[2:0] == 4 && hazard2[2:0] == 2) ? 4'd0 : hazard1;
    //  assign hazard_reg1 = hazard1;
    //  assign hazard_reg2 = hazard2;
endmodule
