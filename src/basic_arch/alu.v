module alu(a, b, alu_op, result, branch);
  input [31:0] a, b;
  input [3:0] alu_op;

  output reg [31:0] result;
  output reg branch; // 0: !branch, 1: branch

  // define constants
  parameter [3:0] ADD = 4'b0000;
  parameter [3:0] SUB = 4'b0001;
  parameter [3:0] MUL = 4'b1000;
  parameter [3:0] AND = 4'b0011;
  parameter [3:0] OR = 4'b0110;
  parameter [3:0] SL = 4'b0010;
  parameter [3:0] SR = 4'b0100;
  parameter [3:0] BEQ = 4'b1100;
  parameter [3:0] BGT = 4'b1001;
  parameter [3:0] BLT = 4'b0101;

  always @(*) begin
    case (alu_op)
      ADD: result = a + b;
      SUB: result = a - b;
      MUL: result = a * b;
      AND: result = a & b;
      OR: result = a | b;
      SL: result = a << b;
      SR: result = a >> b;
      BEQ: branch = (a == b) ? 1'b1 : 1'b0;
      BGT: branch = (a > b) ? 1'b1 : 1'b0;
      BLT: branch = (a < b) ? 1'b1 : 1'b0;
      default: begin 
        result = a + b;
        branch = 1'b0;
      end
    endcase
  end

endmodule