module id_control(
    input reset,        // active at low
    input [31:0] inst,

    output reg mem_read, mem_write, reg_write, alu_src,
    output reg [1:0] mem_to_reg, jump, // 11(3) -> jump
    output [1:0] inst_size,
    output [3:0] alu_op
);
    // Instructions' Type
    localparam [6:0]
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    IMM = 7'b0010011,
    JAL = 7'b1101111,
    JALR = 7'b1100111,
    BRANCH = 7'b1100011,
    LOAD = 7'b0000011,
    STORE = 7'b0100011,
    R_TYPE = 7'b0110011;

    localparam [3:0]
    ALU_ADD = 4'd0,
    ALU_SUB = 4'd1,
    ALU_MUL = 4'd2,
    ALU_AND = 4'd3,
    ALU_OR = 4'd4,
    ALU_XOR = 4'd5,
    ALU_SHL = 4'd6,
    ALU_SHR = 4'd7,
    ALU_SLT = 4'd8,
    ALU_SLTU = 4'd9,
    ALU_LUI = 4'd10;

    localparam [1:0]
    WORD = 2'b00,
    HALF = 2'b01,
    BYTE = 2'b10;

    // Instructions' Format in Parts
    wire [6:0] op_part = inst[6:0];
    wire [2:0] f3_part = inst[14:12];
    wire [6:0] f7_part = inst[31:25];

    // Instructions
    wire lui   = (7'b0110111 == op_part);
    wire auipc = (7'b0010111 == op_part);

    wire [6:0] load_op = 7'b0000011;

    wire lb      = (load_op == op_part) && (3'b000 == f3_part);
    wire lh      = (load_op == op_part) && (3'b001 == f3_part);
    wire lw      = (load_op == op_part) && (3'b010 == f3_part);
    wire lbu     = (load_op == op_part) && (3'b100 == f3_part);
    wire lhu     = (load_op == op_part) && (3'b101 == f3_part);
    wire load    = (lb || lh || lw || lbu || lhu);

    wire [6:0] store_op = 7'b0100011;

    wire sb       = (store_op == op_part) && (3'b000 == f3_part);
    wire sh       = (store_op == op_part) && (3'b001 == f3_part);
    wire sw       = (store_op == op_part) && (3'b010 == f3_part);
    wire store    = (sb || sh || sw);

    wire [6:0] imm_op = 7'b0010011;

    wire addi   = (imm_op == op_part) && (3'b000 == f3_part);
    wire slti   = (imm_op == op_part) && (3'b010 == f3_part);
    wire sltiu  = (imm_op == op_part) && (3'b011 == f3_part);
    wire xori   = (imm_op == op_part) && (3'b100 == f3_part);
    wire ori    = (imm_op == op_part) && (3'b110 == f3_part);
    wire andi   = (imm_op == op_part) && (3'b111 == f3_part);
    wire slli   = (imm_op == op_part) && (3'b001 == f3_part);
    wire srli   = (imm_op == op_part) && (3'b101 == f3_part) && (7'b0000000 == f7_part);
    wire srai   = (imm_op == op_part) && (3'b101 == f3_part) && (7'b0100000 == f7_part);

    wire [6:0] r_op   = 7'b0110011;

    wire add    = (r_op == op_part) && (3'b000 == f3_part) && (7'b0000000 == f7_part);
    wire sub    = (r_op == op_part) && (3'b000 == f3_part) && (7'b0100000 == f7_part);
    wire slt    = (r_op == op_part) && (3'b010 == f3_part);
    wire sltu   = (r_op == op_part) && (3'b011 == f3_part);
    wire xor_i  = (r_op == op_part) && (3'b100 == f3_part);
    wire or_i   = (r_op == op_part) && (3'b110 == f3_part);
    wire and_i  = (r_op == op_part) && (3'b111 == f3_part);
    wire sll    = (r_op == op_part) && (3'b001 == f3_part);
    wire srl    = (r_op == op_part) && (3'b101 == f3_part) && (7'b0000000 == f7_part);
    wire sra    = (r_op == op_part) && (3'b101 == f3_part) && (7'b0100000 == f7_part);

    assign alu_op =
    (add || addi || auipc || load || store) ? ALU_ADD :
    (andi || and_i)                         ? ALU_AND :
    (ori || or_i)                           ? ALU_OR :
    (xori || xor_i)                         ? ALU_XOR :
    (slti || slt)                           ? ALU_SLT :
    (sltiu || sltu)                         ? ALU_SLTU :
    (sll || slli)                           ? ALU_SHL :
    (srl || srli || sra || srai)            ? ALU_SHR :
    (lui)                                   ? ALU_LUI : ALU_SUB;

    assign inst_size =
    (lb || lbu || sb) ? BYTE :
    (lh || lhu || sh) ? HALF : WORD;

    // reg_write is active at low
    always @(*) begin
        if (!reset) begin
            mem_read = 1'b0;
            mem_write = 1'b0;
            reg_write = 1'b1;
            alu_src = 1'b0;
            mem_to_reg = 2'b00;
            jump = 2'b00;
        end

        else begin

            case (inst[6:0])
                LUI: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src = 1'b1;
                    mem_to_reg = 2'd2;
                    jump = 2'bx;
                end
                AUIPC: begin
                end
                IMM: begin
                    mem_read = 1'bx;
                    mem_write = 1'bx;
                    reg_write = 1'b0;
                    alu_src = 1'b1;
                    mem_to_reg = 2'd2;
                    jump = 2'bx;
                end
                LOAD: begin
                    mem_read = 1'b1;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src = 1'b1;
                    mem_to_reg = 2'b01;
                    jump = 2'bx;
                end
                STORE: begin
                    mem_read = 1'b0;
                    mem_write = 1'b1;
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    mem_to_reg = 2'bxx;
                    jump = 2'bx;
                end
                R_TYPE: begin
                    mem_read = 1'b0;
                    mem_write = 1'b0;
                    reg_write = 1'b0;
                    alu_src = 1'b0;
                    mem_to_reg = 2'b00;
                    jump = 2'bx;
                end
                default: ;
            endcase

        end
    end

endmodule
