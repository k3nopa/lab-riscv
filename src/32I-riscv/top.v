module top (
  input clk,
  input rst,

  input ACKD_n,           // acknowledge from data memory [active low]
  input ACKI_n,           // acknowledge from instruction memory [active low]
  input [31:0] IDT,       // instruction data bus
  input [2:0] OINT_n,           // out interrupt [active low] 111 -> no interrupt

  inout [31:0] DDT,       // data data bus

  output [31:0] IAD,      // instruction address bus
  output [31:0] DAD,      // data address bus
  output MREQ,            // memory request [active high] for reading
  output WRITE,           // write permission [active high]
  output [1:0] SIZE,      // memory access bit size
  output IACK_n           // interrupt acknowledge
);            

  wire [31:0] pc_in; // pc value came from mux
  wire [31:0] pc;
  wire [31:0] pc4;
  wire [1:0] pc_select;

  wire [31:0] rd, ra, rb;
  wire [31:0] imm_sext;
  wire [11:0] controls;
  wire [31:0] write_data;

  wire mem_read, mem_write, reg_write, alu_src;
  wire [1:0] mem_to_reg, jump, inst_size;
  wire [3:0] alu_op;
  wire branch_result;
  wire [31:0] alu_result; // alu result
  wire [31:0] wr_data; // sext value

  wire [31:0] rd_data;

  // PC reg
  Register PC(
    .reset(rst), .clk(clk), .d(pc_in), 
    .q(pc)
  );

  // if mux
  Mux2_1 pc_mux(
    .in1(pc4), .in2(branch_addr), .select(pc_select), 
    .out(pc_in)
  );

  // if stage
  IF if_phase(
    .clock(clk), .reset(rst), .pc_in(pc_in), 
    .pc4(pc4), .inst_addr(IAD)
  );
  // instruction memory

  // if pipeline register
  ID id_phase(
    .clk(clk), .reset(rst), .inst(IDT), .write_data(write_data), 
    .controls(controls), .inst_size(inst_size), .reg_dest(rd), .reg_a(ra), .reg_b(rb), .sext(imm_sext)
  );
  assign {mem_read, mem_write, reg_write, alu_src, mem_to_reg, jump, alu_op} = controls;

  // id pipeline register

  EX ex_phase(
    .clock(clk), .reset(rst), .alu_op(alu_op), .alu_src(alu_src), .a(ra), .b(rb), .sext(imm_sext), 
    .branch_result(branch_result), .alu_result(alu_result), .wr_data(wr_data)
  );

  // ex pipeline register
  MEM mem_phase(
    .address(alu_result), .write_data(DDT), .mem_read(mem_read), .mem_write(mem_write), .inst_size(inst_size), .rd_data(DDT),
    .read_data(rd_data), .alu_result(alu_result), .addr(DAD), .size(mem_size), .write(WRITE), .mreq(MREQ), .wr_data(DDT)
  );

  // data memory

  // mem pipeline register
  WB wb_phase(
    .pc4(pc4), .mem_data(rd_data), .alu_result(alu_result), .mem_to_reg(mem_to_reg),
    .write_data(write_data)
  );

endmodule