module stalling(
    input [6:0]     id_op,
    input [4:0]     if_reg_src1, if_reg_src2,
    input [4:0]     id_rd,

    output stall
);
    function staller(
        input [6:0]     id_op,
        input [4:0]     if_reg_src1, if_reg_src2,
        input [4:0]     id_rd
    );
        begin
            if (id_op == `LOAD && id_rd != 5'h0) begin
                if (id_rd == if_reg_src1 || id_rd == if_reg_src2)
                    staller = 1'b1;
                else
                    staller = 1'b0;
            end
            else
                staller = 1'b0;
        end
    endfunction

    assign stall = staller(id_op, if_reg_src1, if_reg_src2, id_rd);
endmodule