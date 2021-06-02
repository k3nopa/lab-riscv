module id_control(
    input reset, // active at low
    input [31:0] inst,

    output reg mem_read, mem_write, reg_write, alu_src_a, alu_src_b,
    output reg [1:0] mem_to_reg, jump, // 10(2) -> jump
    output is_signed,
    output [1:0] inst_size,
    output [3:0] alu_op,
    output [4:0] shift_amount
);
    // Instructions' Type
    localparam [6:0]
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    IMM = 7'b0010011,
    LOAD = 7'b0000011,
    STORE = 7'b0100011,
    R_TYPE = 7'b0110011,
    BRANCH = 7'b1100011,
    JAL = 7'b1101111,
    JALR = 7'b1100111;

    // Alu Operations
    localparam [3:0]
    ALU_ADD = 4'd0,
    ALU_SUB = 4'd1,
    ALU_MUL = 4'd2,
    ALU_AND = 4'd3,
    ALU_OR = 4'd4,
    ALU_XOR = 4'd5,
    ALU_SLL = 4'd6,
    ALU_SRL = 4'd7,
    ALU_SRA = 4'd8,
    ALU_SLT = 4'd9,
    ALU_LUI = 4'd10,
    ALU_BEQ = 4'd11,
    ALU_BNE = 4'd12,
    ALU_BGE = 4'd13,
    ALU_BLT = 4'd14;

    // Data Memory Size
    localparam [1:0]
    WORD = 2'b00,
    HALF = 2'b01,
    BYTE = 2'b10;

    // Instructions' Format in Parts
    wire [6:0] op_part = inst[6:0];
    wire [2:0] f3_part = inst[14:12];

    // U-type Instructions
    wire lui   = (LUI == op_part);
    wire auipc = (AUIPC == op_part);

    // Jump-Type Instructions
    wire jal     = (JAL == op_part);
    wire jalr    = (JALR == op_part);

    // Load Instructions
    wire lb      = (LOAD == op_part) && (3'b000 == f3_part);
    wire lh      = (LOAD == op_part) && (3'b001 == f3_part);
    wire lw      = (LOAD == op_part) && (3'b010 == f3_part);
    wire lbu     = (LOAD == op_part) && (3'b100 == f3_part);
    wire lhu     = (LOAD == op_part) && (3'b101 == f3_part);
    wire load    = (lb || lh || lw || lbu || lhu);

    // Store Instructions
    wire sb       = (STORE == op_part) && (3'b000 == f3_part);
    wire sh       = (STORE == op_part) && (3'b001 == f3_part);
    wire sw       = (STORE == op_part) && (3'b010 == f3_part);
    wire store    = (sb || sh || sw);

    // I-Type Instructions
    wire addi   = (IMM == op_part) && (3'b000 == f3_part);
    wire slti   = (IMM == op_part) && (3'b010 == f3_part);
    wire sltiu  = (IMM == op_part) && (3'b011 == f3_part);
    wire xori   = (IMM == op_part) && (3'b100 == f3_part);
    wire ori    = (IMM == op_part) && (3'b110 == f3_part);
    wire andi   = (IMM == op_part) && (3'b111 == f3_part);
    wire slli   = (IMM == op_part) && (3'b001 == f3_part);
    wire srli   = (IMM == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b0);
    wire srai   = (IMM == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b1);

    // R-Type Instructions
    wire add    = (R_TYPE == op_part) && (3'b000 == f3_part) && (inst[30] == 1'b0);
    wire sub    = (R_TYPE == op_part) && (3'b000 == f3_part) && (inst[30] == 1'b1);
    wire slt    = (R_TYPE == op_part) && (3'b010 == f3_part);
    wire sltu   = (R_TYPE == op_part) && (3'b011 == f3_part);
    wire xor_i  = (R_TYPE == op_part) && (3'b100 == f3_part);
    wire or_i   = (R_TYPE == op_part) && (3'b110 == f3_part);
    wire and_i  = (R_TYPE == op_part) && (3'b111 == f3_part);
    wire sll    = (R_TYPE == op_part) && (3'b001 == f3_part);
    wire srl    = (R_TYPE == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b0);
    wire sra    = (R_TYPE == op_part) && (3'b101 == f3_part) && (inst[30] == 1'b1);

    // Branch-Type Instructions
    wire beq     = (BRANCH == op_part) && (3'b000 == f3_part);
    wire bne     = (BRANCH == op_part) && (3'b001 == f3_part);
    wire blt     = (BRANCH == op_part) && (3'b100 == f3_part);
    wire bge     = (BRANCH == op_part) && (3'b101 == f3_part);
    wire bltu    = (BRANCH == op_part) && (3'b110 == f3_part);
    wire bgeu    = (BRANCH == op_part) && (3'b111 == f3_part);

    // reg_write is active at low
    always @(*) begin

        if (!reset) begin
            mem_read = 1'b0;
            mem_write = 1'b0;
            reg_write = 1'b1;
            alu_src_a = 1'bx;
            alu_src_b = 1'bx;
            mem_to_reg = 2'bxx;
            jump = 2'bxx;
        end

        else begin
            case (op_part)
                LUI: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'bx;
                    alu_src_b = 1'b1; // sext
                    mem_to_reg = 2'd2; // alu
                    jump = 2'bxx;
                end
                AUIPC: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'b0; // pc
                    alu_src_b = 1'b1; // sext
                    mem_to_reg = 2'd2; // alu
                    jump = 2'bxx;
                end
                IMM: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'b1; // reg
                    alu_src_b = 1'b1; // sext
                    mem_to_reg = 2'd2; // alu
                    jump = 2'bxx;
                end
                LOAD: begin
                    mem_read = 1'b1;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'b1; // reg
                    alu_src_b = 1'b1; // sext
                    mem_to_reg = 2'd1; // mem data
                    jump = 2'bxx;
                end
                STORE: begin
                    mem_read = 1'b0;
                    mem_write = 1'b1;
                    reg_write = 1'b1;
                    alu_src_a = 1'b1; // reg
                    alu_src_b = 1'b1; // sext
                    mem_to_reg = 2'bxx; // none
                    jump = 2'bxx;
                end
                R_TYPE: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'b1; // reg
                    alu_src_b = 1'b0; // reg
                    mem_to_reg = 2'd2; // alu
                    jump = 2'bxx;
                end
                BRANCH: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b1;
                    alu_src_a = 1'b1; // reg
                    alu_src_b = 1'b0; // reg
                    mem_to_reg = 2'bxx; // none
                    jump = 2'bxx;
                end
                JAL: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'b0; // pc
                    alu_src_b = 1'b1; // sext
                    mem_to_reg = 2'd0; // pc4
                    jump = 2'd2;
                end
                JALR: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src_a = 1'b1; // reg
                    alu_src_b = 1'b1; // reg
                    mem_to_reg = 2'd0; // pc4
                    jump = 2'd2;
                end
                default: ;
            endcase
        end
    end

    assign alu_op =
    (add || addi || auipc || load || store || jal || jalr) ? ALU_ADD :
    (andi || and_i)                                        ? ALU_AND :
    (ori || or_i)                                          ? ALU_OR  :
    (xori || xor_i)                                        ? ALU_XOR :
    (slti || slt || sltiu || sltu)                         ? ALU_SLT :
    (sll || slli)                                          ? ALU_SLL :
    (srl || srli)                                          ? ALU_SRL :
    (sra || srai)                                          ? ALU_SRA :
    (beq)                                                  ? ALU_BEQ :
    (bne)                                                  ? ALU_BNE :
    (bge || bgeu)                                          ? ALU_BGE :
    (blt || bltu)                                          ? ALU_BLT :
    (lui)                                                  ? ALU_LUI : ALU_SUB;

    assign inst_size =
    (lb || lbu || sb) ? BYTE :
    (lh || lhu || sh) ? HALF : WORD;

    assign is_signed = (lbu || lhu || sltu || sltiu || bltu || bgeu) ? 1'b0 : 1'b1;

    assign shift_amount = (sll || slli || srl || srli || sra || srai) ? inst[24:20] : 5'bx;

endmodule
