module hazard_detection(
    input [31:0]    current, before,
    input           next, // if next, means the next instruction. if !next, oldest instruction

    output [3:0]    hazard
);

    /* 
     *  load & branch have no dest reg.
     *  lui & auipc & jal dont have src reg.
     *  Thus these instructions are not valid to be check for hazards.
     *  To simplify, the condition needed to be checking for hazards are have both dest and src registers
     */
     wire [6:0] current_op = current[6:0];
     wire [6:0] before_op  = before[6:0];
     
     wire [4:0] _rd  = before[11:7];
     wire [4:0] _rs1 = current[19:15];
     wire [4:0] _rs2 = current[24:20];

    function [3:0] hazard_check(
        input [6:0] c_op, b_op,
        input [4:0] rd, rs1, rs2
    );
        begin
            if ( c_op != `LUI && c_op != `AUIPC && c_op != `JAL && b_op != `STORE && b_op != `BRANCH ) begin
                if (next) begin // compare inst from mem stage 
                    if (rd == rs1 && rd != 5'h0 && rs1 != 5'h0)
                        hazard_check = {1'b1, `FROM_MEM_RS1};
                    else if (rd == rs2 && rd != 5'h0 && rs2 != 5'h0)
                        hazard_check = {1'b1, `FROM_MEM_RS2};
                    else
                        hazard_check = {1'b0, 3'b000};
                end
                else begin // compare inst from id stage
                    if (rd == rs1 && rd != 5'h0 && rs1 != 5'h0) begin
                        hazard_check = {1'b1, `FROM_EX_RS1};

                    end
                    else if (rd == rs2 && rd != 5'h0 && rs2 != 5'h0) begin
                        hazard_check = {1'b1, `FROM_EX_RS2};
                    end
                    else
                        hazard_check = {1'b0, 3'b000};
                end
            end

            else
                hazard_check = {1'b0, 3'b000};
        end

    endfunction

    assign hazard = hazard_check(current_op, before_op, _rd, _rs1, _rs2);

endmodule
