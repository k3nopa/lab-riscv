module EX (
  input clock,
  input reset,

  // input [31:0] pc4,
  input [3:0] alu_op,
  input alu_src,
  input [31:0] a,
  input [31:0] b,
  input [31:0] sext,

  // output [31:0] pc4_pass,
  output branch_result, 

  // data memory
  output [31:0] alu_result, // alu result
  output [31:0] wr_data // sext value
);

  reg [31:0] alu_a, alu_b;
  wire [31:0] alu_res;

  // 2-mux
  always @(*) begin
    if (alu_src)
      alu_b <= sext;
    else
      alu_b <= b;

    alu_a <= a;
  end

  // alu  
  alu alu_unit(.a(alu_a), .b(alu_b), .op(alu_op), .result(alu_res), .branch(branch_result));

  // finish preparation
  // assign pc4_pass = pc4;
  assign alu_result = alu_res;
  assign wr_data = b;

endmodule