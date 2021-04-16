module control(reset, inst, alu_op, mem_read, mem_write, reg_write, alu_src, mem_to_reg, jump);

  input reset;
  input [31:0] inst;

  output reg mem_read, mem_write, reg_write, alu_src;
  output reg [1:0] mem_to_reg, jump; // 11(3) -> jump
  output reg [3:0] alu_op;

  // wire [6:0] op_part = if_opcode_w[6:0];
  // wire [4:0] rd_part = if_opcode_w[11:7];
  // wire [2:0] f3_part = if_opcode_w[14:12];
  // wire [4:0] ra_part = if_opcode_w[19:15];
  // wire [4:0] rb_part = if_opcode_w[24:20];
  // wire [6:0] f7_part = if_opcode_w[31:25];

  // Main parameters
  localparam 
    IMM = 7'b00110011,
    JAL = 7'b1101111,
    JALR = 7'b1100111,
    BRANCH = 7'b1100011,
    LOAD = 7'b0000011,
    STORE = 7'b0100011,
    R_TYPE = 7'b0110011;

  // Immediate parameters
  localparam 
    ADDI = 3'b000,
    LTI = 3'b010,
    STLIU = 3'b011,
    XORI = 3'b100,
    ORI = 3'b110,
    ANDI = 3'b111,
    SLLI = 3'b001;

  always @(*) begin
    if (reset) begin
      alu_op = 2'b00;  
      mem_read = 1'b0;  
      mem_write = 1'b0;  
      reg_write = 1'b0;  
      alu_src = 1'b0;  
      mem_to_reg = 2'b00;  
      jump = 1'b0;  
    end

    else begin
      case (inst[6:0])
        IMM: begin
          case (inst[14:12])
            3'b101: begin
              if (inst[30])
                // SRAI 
              else 
                // SRLI
            end
          endcase
        end
        JAL: begin
          alu_op = 2'b00;  
          mem_read = 1'b0;  
          mem_write = 1'b0;  
          reg_write = 1'b0;  
          alu_src = 1'b0;  
          mem_to_reg = 2'b00;  
          jump = 2'b11;  
        end
        JALR: begin
          alu_op = 2'b00;  
          mem_read = 1'b0;  
          mem_write = 1'b0;  
          reg_write = 1'b0;  
          alu_src = 1'b0;  
          mem_to_reg = 2'b00;  
          jump = 2'b11;
        end
        BRANCH: begin
          alu_op = 2'b00;  
          mem_read = 1'b0;  
          mem_write = 1'b0;  
          reg_write = 1'b0;  
          alu_src = 1'b0;  
          mem_to_reg = 2'b00;  
          jump = 1'b0;
        end 
        LOAD: begin
          alu_op = 2'b00;  
          mem_read = 1'b0;  
          mem_write = 1'b0;  
          reg_write = 1'b0;  
          alu_src = 1'b0;  
          mem_to_reg = 2'b00;  
          jump = 1'b0;
        end
        STORE: begin
          alu_op = 2'b00;  
          mem_read = 1'b0;  
          mem_write = 1'b0;  
          reg_write = 1'b0;  
          alu_src = 1'b0;  
          mem_to_reg = 2'b00;  
          jump = 1'b0;
        end
        R_TYPE: begin
          alu_op = 2'b00;  
          mem_read = 1'b0;  
          mem_write = 1'b0;  
          reg_write = 1'b0;  
          alu_src = 1'b0;  
          mem_to_reg = 2'b00;  
          jump = 1'b0;
        end
      endcase
      
    end
  end

endmodule