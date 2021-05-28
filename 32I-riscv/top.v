`default_nettype none 

`include "if_stage.v"
`include "id_stage.v"
`include "ex_stage.v"
`include "mem_stage.v"
`include "wb_stage.v"

`include "if_pc_adder.v"
`include "id_control.v"
`include "id_sign_extend.v"
`include "ex_alu.v"
`include "reg32.v"
`include "multiplexer.v"
`include "hazard_detection.v"
`include "rf32x32.v"
`include "DW_ram_2r_w_s_dff.v"

/*
 *  WORD = 2'b00,
 *  HALF = 2'b01,
 *  BYTE = 2'b10;
 */
module top (
    input clk,
    input rst,

    input ACKD_n, // acknowledge from data memory [active low]
    input ACKI_n, // acknowledge from instruction memory [active low]
    input [31:0] IDT, // instruction data bus
    input [2:0] OINT_n, // out interrupt [active low] 111 -> no interrupt

    inout [31:0] DDT, // data data bus

    output [31:0] IAD, // instruction address bus
    output [31:0] DAD, // data address bus
    output MREQ, // memory request [active high] for reading
    output WRITE, // write permission [active high]
    output [1:0] SIZE, // memory access bit size
    output IACK_n // interrupt acknowledge
);

    // Modules' inputs & outputs
    wire [31:0] pc, pc_in;
    wire pc_src;

    wire mem_read, mem_write, alu_src_a, alu_src_b, reg_write, is_signed;
    wire [1:0] mem_to_reg, jump, mem_size;
    wire [3:0] alu_op;
    wire [31:0] reg_data_in;

    wire [31:0] branch_addr, mem_read_data, reg_read_data1, reg_read_data2, imm, alu_result;

    // Pipelines
    reg [31:0] IF_ID_PC, IF_ID_PC4, ID_EX_PC, ID_EX_PC4, EX_MEM_PC4, MEM_WB_PC4;
    reg [31:0] IF_ID_INST, ID_EX_INST, EX_MEM_INST, MEM_WB_INST;
    reg [31:0] EX_MEM_ALU, MEM_WB_ALU;
    reg [31:0] ID_EX_RD2, EX_MEM_RD2;
    reg [31:0] ID_EX_BRANCH_ADDR, ID_EX_RD1, ID_EX_SEXT, MEM_WB_MDATA;

    // Controls Pipelines
    reg ID_EX_MEM_READ, ID_EX_MEM_WRITE, ID_EX_ALU_SRC_A, ID_EX_ALU_SRC_B, ID_EX_REG_WRITE, ID_EX_SIGNED,
    EX_MEM_MEM_READ, EX_MEM_MEM_WRITE, EX_MEM_REG_WRITE, EX_MEM_SIGNED,
    MEM_WB_REG_WRITE;

    reg [1:0] ID_EX_MEM_TO_REG, ID_EX_MEM_SIZE, ID_EX_JUMP, EX_MEM_MEM_TO_REG, EX_MEM_MEM_SIZE, MEM_WB_MEM_TO_REG;
    reg [3:0] ID_EX_ALU_OP;

    // Forwarding & Hazard Detection & Stall
    wire is_hazard1, stall1, is_hazard2, stall2;
    wire [2:0] hazard_reg1, hazard_reg2;
    reg stalling;
    reg [31:0] hold_inst;

    reg32 PC(
        .reset(rst), .clk(clk), .d(pc_in),
        .q(pc)
    );

    if_stage if_phase(
        .reset(rst), .pc(pc), .branch_addr(ID_EX_BRANCH_ADDR), .jump_addr(alu_result), .pc_src(pc_src), .jump(ID_EX_JUMP), .stall(stall1 || stall2),
        .pc4(pc_in), .inst_addr(IAD)
    );

    id_stage id_phase(
        .reset(rst), .inst(IF_ID_INST), .pc(IF_ID_PC),
        .controls({mem_read, mem_write, alu_src_a, alu_src_b, mem_to_reg, alu_op, reg_write, jump}),
        .inst_size(mem_size), .is_signed(is_signed),
        .branch_addr(branch_addr), .sign_extend(imm)
    );

    /* ----- Register File ----- */
    rf32x32 regfile(
        .clk(clk), .reset(rst), .wr_n(MEM_WB_REG_WRITE),
        .rd1_addr(IF_ID_INST[19:15]), .rd2_addr(IF_ID_INST[24:20]), .wr_addr(MEM_WB_INST[11:7]),
        .data_in(reg_data_in),
        .data1_out(reg_read_data1), .data2_out(reg_read_data2)
    );

    ex_stage ex_phase(
        .alu_op(ID_EX_ALU_OP), .alu_src_a(ID_EX_ALU_SRC_A), .alu_src_b(ID_EX_ALU_SRC_B), .is_signed(ID_EX_SIGNED), .pc(ID_EX_PC), .a(ID_EX_RD1), .b(ID_EX_RD2), .sext(ID_EX_SEXT),
        .branch_result(pc_src), .alu_result(alu_result)
    );

    mem_stage mem_phase(
        .address(EX_MEM_ALU), .write_data(EX_MEM_RD2), .mem_read(EX_MEM_MEM_READ), .mem_write(EX_MEM_MEM_WRITE), .inst_size(EX_MEM_MEM_SIZE), .is_signed(EX_MEM_SIGNED), .rd_data(DDT),
        .access_size(SIZE), .read_data(mem_read_data), .addr(DAD), .write(WRITE), .mreq(MREQ), .wr_data(DDT)
    );

    wb_stage wb_phase(
        .pc4(MEM_WB_PC4), .mem_data(MEM_WB_MDATA), .alu_result(MEM_WB_ALU), .mem_to_reg(MEM_WB_MEM_TO_REG),
        .write_data(reg_data_in)
    );

    hazard_detection hazard_detect_unit1(
        .current(IF_ID_INST), .before(ID_EX_INST), .next(1'b0),
        .hazard({is_hazard1, hazard_reg1}), .stall(stall1)
    );

    hazard_detection hazard_detect_unit2(
        .current(IF_ID_INST), .before(EX_MEM_INST), .next(1'b1),
        .hazard({is_hazard2, hazard_reg2}), .stall(stall2)
    );

    /*
     * IF/ID Pipeline
     */
    always @(posedge clk) begin
        IF_ID_PC <= IAD;
        IF_ID_PC4 <= pc_in;
        IF_ID_INST <= IDT;
    end

    /*
     * ID/EX Pipeline
     */
    always @(posedge clk) begin
        /*
         * Pipeline Flushing
         */
        if(pc_src || ID_EX_JUMP === 2'd3) begin
            ID_EX_PC <= 32'h0;
            ID_EX_PC4 <= 32'h0;
            ID_EX_INST <= 32'h0;
            ID_EX_RD2 <= 32'h0;
            ID_EX_BRANCH_ADDR <= 32'h0;
            ID_EX_RD1 <= 32'h0;
            ID_EX_SEXT <= 32'h0;

            // Controls Pipelines
            ID_EX_MEM_READ <= 1'b0;
            ID_EX_MEM_WRITE <= 1'b0;
            ID_EX_ALU_SRC_A <= 1'bx;
            ID_EX_ALU_SRC_B <= 1'bx;
            ID_EX_REG_WRITE <= 1'b1;
            ID_EX_SIGNED <= 1'bx;

            ID_EX_MEM_TO_REG <= 2'b0;
            ID_EX_MEM_SIZE <= 2'bx;
            ID_EX_JUMP <= 2'bx;

            ID_EX_ALU_OP <= 4'bx;

            // Forwarding & Hazard Detection & Stall
            stalling <= 1'bx;
            hold_inst <= 32'hx;
        end
        else begin
            ID_EX_PC <= IF_ID_PC;
            ID_EX_PC4 <= IF_ID_PC4;
            ID_EX_INST <= IF_ID_INST;
            ID_EX_BRANCH_ADDR <= branch_addr;
            ID_EX_SEXT <= imm;

            ID_EX_MEM_READ <= mem_read;
            ID_EX_MEM_WRITE <= mem_write;
            ID_EX_REG_WRITE <= reg_write;
            ID_EX_ALU_SRC_A <= alu_src_a;
            ID_EX_ALU_SRC_B <= alu_src_b;
            ID_EX_MEM_TO_REG <= mem_to_reg;
            ID_EX_ALU_OP <= alu_op;
            ID_EX_MEM_SIZE <= mem_size;
            ID_EX_SIGNED <= is_signed;
            ID_EX_JUMP <= jump;
        end
    end

    /*
     * EX/MEM Pipeline
     */
    always @(posedge clk) begin
        EX_MEM_PC4 <= ID_EX_PC4;
        EX_MEM_INST <= ID_EX_INST;
        EX_MEM_ALU <= alu_result;
        EX_MEM_RD2 <= ID_EX_RD2;

        EX_MEM_REG_WRITE <= ID_EX_REG_WRITE;
        EX_MEM_MEM_READ <= ID_EX_MEM_READ;
        EX_MEM_MEM_WRITE <= ID_EX_MEM_WRITE;
        EX_MEM_MEM_TO_REG <= ID_EX_MEM_TO_REG;
        EX_MEM_MEM_SIZE <= ID_EX_MEM_SIZE;
        EX_MEM_SIGNED <= ID_EX_SIGNED;
    end
    /*
     * MEM/WB Pipeline
     */
    always @(posedge clk) begin
        MEM_WB_PC4 <= EX_MEM_PC4;
        MEM_WB_INST <= EX_MEM_INST;
        MEM_WB_MDATA <= mem_read_data;
        MEM_WB_ALU <= EX_MEM_ALU;

        MEM_WB_REG_WRITE <= EX_MEM_REG_WRITE;
        MEM_WB_MEM_TO_REG <= EX_MEM_MEM_TO_REG;
    end

    /*
     * Hazard Handling
     */
    always @(posedge clk) begin
        if (is_hazard1 && is_hazard2) begin
            // same target/src register can cause overwrite
            // make sure to flow from first hazard's register because it is the latest result
            if (hazard_reg1 === 3'd1 && hazard_reg2 === 3'd3) begin
                ID_EX_RD1 <= alu_result;
                ID_EX_RD2 <= reg_read_data2;
            end
            else if (hazard_reg1 === 3'd3 && hazard_reg2 === 3'd1) begin
                ID_EX_RD1 <= (mem_read_data !== 32'hx) ? mem_read_data : (EX_MEM_ALU !== 32'hx) ? EX_MEM_ALU : alu_result;
                ID_EX_RD2 <= reg_read_data2;
            end
            // same target/src register can cause overwrite
            // make sure to flow from first hazard's register because it is the latest result
            else if (hazard_reg1 === 3'd2 && hazard_reg2 === 3'd4) begin
                ID_EX_RD1 <= reg_read_data1;
                ID_EX_RD2 <= alu_result;
            end
            else if (hazard_reg1 === 3'd4 && hazard_reg2 === 3'd2) begin
                ID_EX_RD1 <= reg_read_data1;
                ID_EX_RD2 <= (mem_read_data !== 32'hx) ? mem_read_data : (EX_MEM_ALU !== 32'hx) ? EX_MEM_ALU : alu_result;
            end

            else begin
                // need to handle only either one register cause both hazards will fill each other
                case(hazard_reg2)
                    1 : begin
                        // forward from ex stage (rs1)
                        ID_EX_RD1 <= EX_MEM_ALU;

                    end
                    2 : begin
                        // forward from ex stage (rs2)
                        ID_EX_RD2 <= EX_MEM_ALU;
                    end
                    3 : begin
                        // forward from mem stage (rs1)
                        // need to check EX_MEM_ALU cause exists cases where hazard1 & hazard2's forwarding target register's overlap
                        ID_EX_RD1 <= (mem_read_data !== 32'hx) ? mem_read_data : (EX_MEM_ALU !== 32'hx) ? EX_MEM_ALU : alu_result;
                    end
                    4 : begin
                        // forward from mem stage (rs2) 
                        // need to check EX_MEM_ALU cause exists cases where hazard1 & hazard2's forwarding target register's overlap
                        ID_EX_RD2 <= (mem_read_data !== 32'hx) ? mem_read_data : (EX_MEM_ALU !== 32'hx) ? EX_MEM_ALU : alu_result;

                    end
                    default : ;
                endcase

                case(hazard_reg1)
                    1 : begin
                        // forward from ex stage (rs1)
                        ID_EX_RD1 <= alu_result;
                    end
                    2 : begin
                        // forward from ex stage (rs2)
                        ID_EX_RD2 <= alu_result;
                    end
                    3 : begin
                        // forward from mem stage (rs1)
                        ID_EX_RD1 <= alu_result;
                    end
                    4 : begin
                        // forward from mem stage (rs2)
                        ID_EX_RD2 <= alu_result;
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
                        ID_EX_RD1 <= alu_result;
                        ID_EX_RD2 <= reg_read_data2;
                    end
                    2 : begin
                        // forward from ex stage (rs2)
                        ID_EX_RD1 <= reg_read_data1;
                        ID_EX_RD2 <= alu_result;
                    end
                    3 : begin
                        // forward from mem stage (rs1)
                        ID_EX_RD1 <= alu_result;
                        ID_EX_RD2 <= reg_read_data2;
                    end
                    4 : begin
                        // forward from mem stage (rs2)
                        ID_EX_RD1 <= reg_read_data1;
                        ID_EX_RD2 <= alu_result ;
                    end
                    default : begin
                        ID_EX_RD1 <= reg_read_data1;
                        ID_EX_RD2 <= reg_read_data2;
                    end
                endcase
            end

            if (is_hazard2) begin
                case(hazard_reg2)
                    1 : begin
                        // forward from ex stage (rs1)
                        ID_EX_RD1 <= EX_MEM_ALU;
                        ID_EX_RD2 <= reg_read_data2;
                    end
                    2 : begin
                        // forward from ex stage (rs2)
                        ID_EX_RD1 <= reg_read_data1;
                        ID_EX_RD2 <= EX_MEM_ALU;
                    end
                    3 : begin
                        // forward from mem stage (rs1)
                        ID_EX_RD1 <= (mem_read_data !== 32'hx) ? mem_read_data : EX_MEM_ALU;
                        ID_EX_RD2 <= reg_read_data2;
                    end
                    4 : begin
                        // forward from mem stage (rs2) 
                        ID_EX_RD1 <= reg_read_data1;
                        ID_EX_RD2 <= (mem_read_data !== 32'hx) ? mem_read_data : EX_MEM_ALU;

                    end
                    default : begin
                        ID_EX_RD1 <= reg_read_data1;
                        ID_EX_RD2 <= reg_read_data2;
                    end
                endcase
            end
        end

        else begin
            ID_EX_RD1 <= reg_read_data1;
            ID_EX_RD2 <= reg_read_data2;
        end
    end

endmodule
