module forwarding(
    input           is_hazard1, is_hazard2,
    input [2:0]     hazard_reg1, hazard_reg2,
    input [6:0]     op,
    input [31:0]    rs1_in, rs2_in,
    input [31:0]    pc4_in, alu_in, mem_alu_in, mem_rdata_in,

    output reg [31:0]   rs1, rs2
);

    // maybe change to function 
    always @(*) begin
        if (is_hazard1 && is_hazard2) begin
            case(hazard_reg2)
                3 : begin
                    // forward from mem stage (rs1)
                    // need to check EX_MEM_ALU cause exists cases where hazard1 & hazard2's forwarding target register's overlap
                    rs1 <= (op == `LOAD) ? mem_rdata_in : mem_alu_in;
                end
                4 : begin
                    // forward from mem stage (rs2) 
                    // need to check EX_MEM_ALU cause exists cases where hazard1 & hazard2's forwarding target register's overlap
                    rs2 <= (op == `LOAD) ? mem_rdata_in : mem_alu_in;
                end
                default : ;
            endcase

            case(hazard_reg1)
                1 : begin
                    // forward from ex stage (rs1)
                    rs1 <= alu_in;
                end
                2 : begin
                    // forward from ex stage (rs2)
                    rs2 <= alu_in;
                end
                default : ;
            endcase
        end

        // handle when either hazard is detected
        else if (is_hazard1 || is_hazard2) begin
            case(hazard_reg1)
                1 : begin
                    // forward from ex stage (rs1)
                    rs1 <= alu_in;
                    rs2 <= rs2_in;
                end
                2 : begin
                    // forward from ex stage (rs2)
                    rs1 <= rs1_in;
                    rs2 <= alu_in;
                end
                default : ;
            endcase

            case(hazard_reg2)
                3 : begin
                    // forward from mem stage (rs1)
                    if (op == `JALR || op == `JAL) begin
                        rs1 <= pc4_in;
                        rs2 <= rs2_in;
                    end
                    else begin
                        rs1 <= (op == `LOAD) ? mem_rdata_in : mem_alu_in;
                        rs2 <= rs2_in;
                    end
                end
                4 : begin
                    // forward from mem stage (rs2)
                    if (op == `JALR || op == `JAL) begin
                        rs1 <= pc4_in;
                        rs2 <= rs2_in;
                    end
                    else begin
                        rs1 <= rs1_in;
                        rs2 <= (op == `LOAD) ? mem_rdata_in : mem_alu_in;
                    end
                end
                default : ;
            endcase
        end
        else begin
            rs1 <= rs1_in;
            rs2 <= rs2_in;
        end
    end
endmodule
