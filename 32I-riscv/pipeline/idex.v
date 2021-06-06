/*
 * For Stall
 * We have to make sure if doesn't go into id too
 * For Jump 
 * It can go into ex stage but not update the processors state (memory or registers)
 */
module ID_EX_PIPE(
    input        clk, reset,
    input        stall1, stall2, branch, is_hazard1, is_hazard2,
    input [2:0]  hazard_reg1, hazard_reg2,

    input        mem_read_in, mem_write_in, alu_src_a_in, alu_src_b_in, reg_write_in, sign_in,
    input [1:0]  jump_in, mem_to_reg_in, mem_size_in,
    input [3:0]  alu_op_in,
    input [31:0] pc_in, pc4_in, inst_in, branch_addr_in, rs1_in, rs2_in, sext_in,

    input [31:0] alu_in, mem_alu_in, mem_rdata_in,

    output reg        mem_read, mem_write, alu_src_a, alu_src_b, reg_write, sign,
    output reg [1:0]  jump, mem_to_reg, mem_size,
    output reg [3:0]  alu_op,
    output reg [31:0] pc, pc4, inst, branch_addr, rs1, rs2, sext
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            mem_read <= 0;
            mem_write <= 0;
            alu_src_a <= 1'bx;
            alu_src_b <= 1'bx;
            reg_write <= 1;
            sign <= 0;

            jump <= 0;
            mem_to_reg <= 2'bx;
            mem_size <= 0;
            alu_op <= 0;

            pc <= 0;
            pc4 <= 0;
            inst <= 0;
            branch_addr <= 0;
            rs1 <= 0;
            rs2 <= 0;
            sext <= 0;
        end

        if(stall1 || stall2 || branch) begin
            pc <= pc_in;
            pc4 <= pc4_in;
            inst <= 0;

            mem_read <= 0;
            mem_write <= 0;
            reg_write <= 1;

            jump <= 2'bx;
            mem_to_reg <= 2'bx;
            alu_op <= 0;

        end
        else begin
            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            alu_src_a <= alu_src_a_in;
            alu_src_b <= alu_src_b_in;
            reg_write <= reg_write_in;
            sign <= sign_in;

            jump <= jump_in;
            mem_to_reg <= mem_to_reg_in;
            mem_size <= mem_size_in;
            alu_op <= alu_op_in;

            pc <= pc_in;
            pc4 <= pc4_in;
            inst <= inst_in;
            branch_addr <= branch_addr_in;
            sext <= sext_in;
        end
        /*
         * Hazard Handling
         */
        if (is_hazard1 && is_hazard2) begin
            // same target/src register can cause overwrite
            // make sure to flow from first hazard's register because it is the latest result
            if (hazard_reg1 == 3'd1 && hazard_reg2 == 3'd3) begin
                rs1 <= alu_in;
                rs2 <= rs2_in;
            end
            else if (hazard_reg1 == 3'd3 && hazard_reg2 == 3'd1) begin
                rs1 <= (mem_rdata_in !== 32'hx) ? mem_rdata_in : (mem_alu_in !== 32'hx) ? mem_alu_in : alu_in;
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
                rs2 <= (mem_rdata_in !== 32'hx) ? mem_rdata_in : (mem_alu_in !== 32'hx) ? mem_alu_in : alu_in;
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
                        rs1 <= (mem_rdata_in !== 32'hx) ? mem_rdata_in : mem_alu_in;
                    end
                    4 : begin
                        // forward from mem stage (rs2) 
                        // need to check EX_MEM_ALU cause exists cases where hazard1 & hazard2's forwarding target register's overlap
                        rs2 <= (mem_rdata_in !== 32'hx) ? mem_rdata_in : mem_alu_in;
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
                        rs1 <= (mem_rdata_in !== 32'hx) ? mem_rdata_in : mem_alu_in;
                        rs2 <= rs2_in;
                    end
                    4 : begin
                        // forward from mem stage (rs2) 
                        rs1 <= rs1_in;
                        rs2 <= (mem_rdata_in !== 32'hx) ? mem_rdata_in : mem_alu_in;

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
endmodule
