module hazard_detection(
    input [31:0]    current, before,
    input           next, // if next, means the next instruction. if !next, oldest instruction

    output [3:0]    hazard
);

    function [3:0] hazard_check(input [31:0] _current, _before);
        reg [5:0] c_op, b_op;
        reg [4:0] rd, rs1, rs2 ;

        begin
            c_op = _current[6:0];
            b_op = _before[6:0];

            rd = _before[11:7];
            rs1 = _current[19:15];
            rs2 = _current[24:20];
            /* 
             *  load & branch have no dest reg.
             *  lui & auipc & jal dont have src reg.
             *  Thus these instructions are not valid to be check for hazards.
             *  To simplify, the condition needed to be checking for hazards are have both dest and src registers
             */
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

    assign hazard = hazard_check(current, before);

endmodule
