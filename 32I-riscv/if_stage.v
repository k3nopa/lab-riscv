
module IF (
  input clock,
  input reset,
  input [31:0] pc_in,

  output [31:0] pc4,
  output [31:0] inst_addr
);

  wire [31:0] current_pc = pc_in;
  wire [31:0] next_pc;

  pc_adder pc_4(.reset(reset), .pc_in(current_pc), .pc_out(next_pc));

  assign pc4 = next_pc;
  assign inst_addr = next_pc;
  
endmodule