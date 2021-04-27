module ID (
  input clk,
  input reset,

  // input [31:0] pc4,
  input [31:0] inst,
  input [31:0] write_data,

  output [11:0] controls,
  output [1:0] inst_size,
  // output [31:0] pc4_pass,
  //output [31:0] branch_addr,
  output [31:0] reg_dest,
  output [31:0] reg_a,
  output [31:0] reg_b,
  output [31:0] sext
);
  // Instructions' Format in Parts
  wire [6:0] op_part = inst[6:0];
  wire [6:0] rd_part = inst[11:7];
  wire [6:0] ra_part = inst[19:15];
  wire [6:0] rb_part = inst[24:20];

  wire lui   = (7'b0110111 == op_part);
  wire auipc = (7'b0010111 == op_part);
  wire alu_imm = (7'b00110011 == op_part);
  wire load = (7'b0000011 == op_part);
  wire store = (7'b0100011 == op_part);

  // Control Unit
  wire mem_read, mem_write, reg_write, alu_src;
  wire [1:0] mem_to_reg, jump;
  wire [3:0] alu_op;

  // Register File
  wire [31:0] reg_a, reg_b;

  /* ----- Control Unit ----- */
  Control control_unit(
    .reset(reset), .inst(inst), 
    .mem_read(mem_read), .mem_write(mem_write), .reg_write(reg_write), 
    .alu_src(alu_src), .mem_to_reg(mem_to_reg), .jump(jump), .inst_size(inst_size), .alu_op(alu_op)
  );

  /* ----- Register File ----- */
  rf32x32 reg_file(
    .clk(clk), .reset(reset), .wr_n(reg_write), 
    .rd1_addr(ra_part), .rd2_addr(rb_part), .wr_addr(rd_part),
    .data_in(write_data),
    .data1_out(reg_a), .data2_out(reg_b)
  );

  /* ----- Sign Extend ----- */
  wire [31:0] imm_lui = { inst[31:12], 12'h0 };  // lui & auipc
  wire [31:0] imm_i = { {20{inst[31]}}, inst[31:20] };  // load & imm instruction
  wire [31:0] imm_store = { {20{inst[31]}}, inst[31:25], inst[11:7] };

  /* ----- Address Adder ----- */
  //assign branch_addr = pc4 + imm_branch;

  // Assignments
  assign controls = {mem_read, mem_write, reg_write, alu_src, mem_to_reg, jump, alu_op};
  // assign pc4_pass = pc4;
  assign reg_dest = rd_part;
  assign reg_a = ra_part;
  assign reg_b = rb_part;
  assign sext = 
    (lui || auipc)    ? imm_lui :
    (load || alu_imm) ? imm_i :
    (store)           ? imm_store : 32'b0;

endmodule