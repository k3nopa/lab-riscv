module alu(a, b, alu_op, result, branch);
  input [31:0] a, b;
  input [3:0] alu_op;

  output reg [31:0] result;
  output reg branch; // 0: !branch, 1: branch

  // define constants
  localparam [3:0] ADD = 4'd0;
  localparam [3:0] SUB = 4'd1;
  localparam [3:0] MUL = 4'd2;
  localparam [3:0] AND = 4'd3;
  localparam [3:0] OR = 4'd4;
  localparam [3:0] SL = 4'd5;
  localparam [3:0] SR = 4'd6;
  localparam [3:0] BEQ = 4'd7;
  localparam [3:0] BGT = 4'd8;
  localparam [3:0] BLT = 4'd9;

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