module forwarding(
    input               clk, reset,
    input               is_hazard1, is_hazard2,
    input [6:0]         op,
    input [2:0]         hazard_reg1, hazard_reg2,
    input [31:0]        pc4_in, alu_in, mem_alu_in, mem_rdata_in, rs1_in, rs2_in,

    output reg [31:0]   rs1, rs2
);
    always @ (posedge clk or negedge reset) begin
        if (!reset) begin
            rs1 <= 0;
            rs2 <= 0;
        end
        else begin
            if (is_hazard1 && is_hazard2) begin
                // same target/src register can cause overwrite
                // make sure to flow from first hazard's register because it is the latest result
                if (hazard_reg1 == 3'd1 && hazard_reg2 == 3'd3) begin
                    rs1 <= alu_in;
                    rs2 <= rs2_in;
                end
                else if (hazard_reg1 == 3'd3 && hazard_reg2 == 3'd1) begin
                    rs1 <= (mem_rdata_in != 32'hx) ? mem_rdata_in : (mem_alu_in != 32'hx) ? mem_alu_in : alu_in;
                    rs2 <= rs2_in;
                end
                // same target/src register can cause overwrite
                // make sure to flow from first hazard's register because it is the latest result
                else if (hazard_reg1 == 3'd2 && hazard_reg2 == 3'd4) begin
                    rs1 <= rs1_in;
                    rs2 <= alu_in;
                end
                else if (hazard_reg1 == 3'd4 && hazard_reg2 == 3'd2) begin
                    rs1 <= rs1_in;
                    rs2 <= (mem_rdata_in != 32'hx) ? mem_rdata_in : (mem_alu_in != 32'hx) ? mem_alu_in : alu_in;
                end

                else begin
                    // need to handle only either one register cause both hazards will fill each other
                    case(hazard_reg2)
                        1 : begin
                            // forward from ex stage (rs1)
                            rs1 <= mem_alu_in;

                        end
                        2 : begin
                            // forward from ex stage (rs2)
                            rs2 <= mem_alu_in;
                        end
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
                        3 : begin
                            // forward from mem stage (rs1)
                            rs1 <= alu_in;
                        end
                        4 : begin
                            // forward from mem stage (rs2)
                            rs2 <= alu_in;
                        end
                        default : ;
                    endcase
                end

            end

            // handle when either hazard is detected
            else if (is_hazard1 || is_hazard2) begin
                if (is_hazard1) begin
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
                        3 : begin
                            // forward from mem stage (rs1)
                            rs1 <= alu_in;
                            rs2 <= rs2_in;
                        end
                        4 : begin
                            // forward from mem stage (rs2)
                            rs1 <= rs1_in;
                            rs2 <= alu_in;
                        end
                        default : begin
                            rs1 <= rs1_in;
                            rs2 <= rs2_in;
                        end
                    endcase
                end

                if (is_hazard2) begin
                    case(hazard_reg2)
                        1 : begin
                            // forward from ex stage (rs1)
                            rs1 <= mem_alu_in;
                            rs2 <= rs2_in;
                        end
                        2 : begin
                            // forward from ex stage (rs2)
                            rs1 <= rs1_in;
                            rs2 <= mem_alu_in;
                        end
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
                        default : begin
                            rs1 <= rs1_in;
                            rs2 <= rs2_in;
                        end
                    endcase
                end
            end

            else begin
                rs1 <= rs1_in;
                rs2 <= rs2_in;
            end
        end
    end
endmodule