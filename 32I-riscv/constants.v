// Instructions
`define LUI             7'b0110111
`define AUIPC           7'b0010111
`define IMM             7'b0010011
`define LOAD            7'b0000011
`define STORE           7'b0100011
`define R_TYPE          7'b0110011
`define BRANCH          7'b1100011
`define JAL             7'b1101111
`define JALR            7'b1100111

// Alu Operations
`define ALU_ADD         4'd0
`define ALU_SUB         4'd1
`define ALU_AND         4'd2
`define ALU_OR          4'd3
`define ALU_XOR         4'd4
`define ALU_SLL         4'd5
`define ALU_SRL         4'd6
`define ALU_SRA         4'd7
`define ALU_SLT         4'd8
`define ALU_LUI         4'd9
`define ALU_BEQ         4'd10
`define ALU_BNE         4'd11
`define ALU_BGE         4'd12
`define ALU_BLT         4'd13
 
// Data Memory Size
`define WORD            2'b00
`define HALF            2'b01
`define BYTE            2'b10

// Hazard Forward Target
`define NONE            3'd0
`define FROM_EX_RS1     3'd1
`define FROM_EX_RS2     3'd2
`define FROM_MEM_RS1    3'd3
`define FROM_MEM_RS2    3'd4

// WB Target
`define PC4             2'd0
`define MEMDATA         2'd1
`define ALURESULT       2'd2