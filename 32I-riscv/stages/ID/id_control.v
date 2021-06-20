module id_control(
    input reset, // active at low
    input [31:0] inst,

    output  mem_read, mem_write, reg_write, alu_src_a, alu_src_b,
    output [1:0] mem_to_reg, jump, 
    output is_signed,
    output [1:0] inst_size,
    output [3:0] alu_op,
    output [31:0] imm
);
    // Instructions' Format in Parts
    wire [6:0] op_part = inst[6:0];
    wire [2:0] f3_part = inst[14:12];

    // U-type Instructions
    wire lui   = (`LUI == op_part);
    wire auipc = (`AUIPC == op_part);

    // Jump-Type Instructions
    wire jal     = (`JAL == op_part);
    wire jalr    = (`JALR == op_part);

    // Load Instructions
    wire lb      = (`LOAD == op_part) && (3'b000 == f3_part);
    wire lh      = (`LOAD == op_part) && (3'b001 == f3_part);
    wire lw      = (`LOAD == op_part) && (3'b010 == f3_part);
    wire lbu     = (`LOAD == op_part) && (3'b100 == f3_part);
    wire lhu     = (`LOAD == op_part) && (3'b101 == f3_part);
    wire load    = (lb || lh || lw || lbu || lhu);

    // Store Instructions
    wire sb       = (`STORE == op_part) && (3'b000 == f3_part);
    wire sh       = (`STORE == op_part) && (3'b001 == f3_part);
    wire sw       = (`STORE == op_part) && (3'b010 == f3_part);
    wire store    = (sb || sh || sw);

    // I-Type Instructions
    wire addi   = (`IMM == op_part) && (3'b000 == f3_part);
    wire slti   = (`IMM == op_part) && (3'b010 == f3_part);
    wire sltiu  = (`IMM == op_part) && (3'b011 == f3_part);
    wire xori   = (`IMM == op_part) && (3'b100 == f3_part);
    wire ori    = (`IMM == op_part) && (3'b110 == f3_part);
    wire andi   = (`IMM == op_part) && (3'b111 == f3_part);
    wire slli   = (`IMM == op_part) && (3'b001 == f3_part);
    wire srli   = (`IMM == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b0);
    wire srai   = (`IMM == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b1);

    // R-Type Instructions
    wire add    = (`R_TYPE == op_part) && (3'b000 == f3_part) && (inst[30] == 1'b0);
    wire sub    = (`R_TYPE == op_part) && (3'b000 == f3_part) && (inst[30] == 1'b1);
    wire slt    = (`R_TYPE == op_part) && (3'b010 == f3_part);
    wire sltu   = (`R_TYPE == op_part) && (3'b011 == f3_part);
    wire xor_i  = (`R_TYPE == op_part) && (3'b100 == f3_part);
    wire or_i   = (`R_TYPE == op_part) && (3'b110 == f3_part);
    wire and_i  = (`R_TYPE == op_part) && (3'b111 == f3_part);
    wire sll    = (`R_TYPE == op_part) && (3'b001 == f3_part);
    wire srl    = (`R_TYPE == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b0);
    wire sra    = (`R_TYPE == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b1);

    // Branch-Type Instructions
    wire beq     = (`BRANCH == op_part) && (3'b000 == f3_part);
    wire bne     = (`BRANCH == op_part) && (3'b001 == f3_part);
    wire blt     = (`BRANCH == op_part) && (3'b100 == f3_part);
    wire bge     = (`BRANCH == op_part) && (3'b101 == f3_part);
    wire bltu    = (`BRANCH == op_part) && (3'b110 == f3_part);
    wire bgeu    = (`BRANCH == op_part) && (3'b111 == f3_part);

    wire [31:0] extend_imm;

    function [12:0] controller(
        input rst,
        input [6:0] op
    );

        begin
            if (!rst || op == 0) begin
                // can't use xx for jump, because !== can't be use in synthesis
                controller = {1'b0, 1'b0, 1'b0, 1'b0, 2'd0, 1'b1, 2'b0};
            end
            else begin
                case (op)
                    `LUI: begin
                        controller = {1'b0, 1'b0, 1'b0, 1'b1, 2'd2, 1'b0, 2'b0};
                    end
                    `AUIPC: begin
                        controller = {1'b0, 1'b0, 1'b0, 1'b1, 2'd2, 1'b0, 2'b0};
                    end
                    `IMM: begin
                        controller = {1'b0, 1'b0, 1'b1, 1'b1, 2'd2, 1'b0, 2'b0};
                    end
                    `LOAD: begin
                        controller = {1'b1, 1'b0, 1'b1, 1'b1, 2'd1, 1'b0, 2'b0};
                    end
                    `STORE: begin
                        controller = {1'b0, 1'b1, 1'b1, 1'b1, 2'd0, 1'b1, 2'b0};
                    end
                    `R_TYPE: begin
                        controller = {1'b0, 1'b0, 1'b1, 1'b0, 2'd2, 1'b0, 2'b0};
                    end
                    `BRANCH: begin
                        controller = {1'b0, 1'b0, 1'b1, 1'b0, 2'd0, 1'b1, 2'b0};
                    end
                    `JAL: begin
                        controller = {1'b0, 1'b0, 1'b0, 1'b1, 2'd0, 1'b0, 2'd2};
                    end
                    `JALR: begin
                        controller = {1'b0, 1'b0, 1'b1, 1'b1, 2'b0, 1'b0, 2'd2};
                    end
                    default: ;
                endcase
            end
        end
    endfunction

    id_sign_extend imm_extend(.inst(inst), .extend_imm(extend_imm));

    assign {mem_read, mem_write, alu_src_a, alu_src_b, mem_to_reg, reg_write, jump} = controller(reset, op_part);

    assign alu_op =
    (add || addi || auipc || load || store || jal || jalr) ? `ALU_ADD :
    (andi || and_i)                                        ? `ALU_AND :
    (ori || or_i)                                          ? `ALU_OR  :
    (xori || xor_i)                                        ? `ALU_XOR :
    (slti || slt || sltiu || sltu)                         ? `ALU_SLT :
    (sll || slli)                                          ? `ALU_SLL :
    (srl || srli)                                          ? `ALU_SRL :
    (sra || srai)                                          ? `ALU_SRA :
    (beq)                                                  ? `ALU_BEQ :
    (bne)                                                  ? `ALU_BNE :
    (bge || bgeu)                                          ? `ALU_BGE :
    (blt || bltu)                                          ? `ALU_BLT :
    (lui)                                                  ? `ALU_LUI : `ALU_SUB;

    assign inst_size =
    (lb || lbu || sb) ? `BYTE :
    (lh || lhu || sh) ? `HALF : `WORD;

    assign is_signed = (lbu || lhu || sltu || sltiu || bltu || bgeu) ? 1'b0 : 1'b1;

    assign imm = (sll || slli || srl || srli || sra || srai) ? inst[24:20] : extend_imm;

endmodule
