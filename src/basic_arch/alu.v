module alu(a, b, alu_op, result, branch);
  input [31:0] a, b;
  input [3:0] alu_op;

  output reg [31:0] result;
  output reg branch; // 0: !branch, 1: branch

  always @(*) begin
    case (alu_op)
      4'b0000: result = a + b;  // ADD
      4'b0001: result = a - b;  // SUB
      4'b0010: result = a << b; // SHIFT LEFT 
      4'b0100: result = a >> b; // SHIFT RIGHT
      4'b1000: result = a * b;  // MUL
      4'b0011: result = a & b;  // AND
      4'b0110: result = a | b;  // OR
      4'b1100: branch = (a == b) ? 1'b1 : 1'b0;  // EQ 
      4'b1001: branch = (a > b) ? 1'b1 : 1'b0;  // GT
      4'b0101: branch = (a < b) ? 1'b1 : 1'b0;  // LT
      default: begin 
        result = a + b;
        branch = 1'b0;
      end
    endcase
  end

endmodule