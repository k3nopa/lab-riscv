module alu(
  input [31:0] a, 
  input [31:0] b,
  input [3:0] op,
  
  output reg [31:0] result, 
  output reg branch // 0: !branch, 1: branch
);
  // define constants
  localparam [3:0] 
    ADD = 4'd0,
    SUB = 4'd1,
    MUL = 4'd2,
    AND = 4'd3,
    OR = 4'd4,
    XOR = 4'd5,
    SHL = 4'd6,
    SHR = 4'd7,
    SLT = 4'd8,
    SLTU = 4'd9,
    LUI = 4'd10,
    BEQ = 4'd11,
    BGT = 4'd12,
    BLT = 4'd13;


  always @(*) begin
    case (op)
      LUI: result = b;
      ADD: result = a + b;
      SUB: result = a - b;
      MUL: result = a * b;
      AND: result = a & b;
      OR : result = a | b;
      XOR: result = a ^ b;
      SHL: result = a << b;
      SHR: result = a >> b;
      SLT: result = (a < b)  ? 1'b1 : 1'b0;
      BEQ: branch = (a == b) ? 1'b1 : 1'b0;
      BGT: branch = (a > b)  ? 1'b1 : 1'b0;
      BLT: branch = (a < b)  ? 1'b1 : 1'b0;
      default: begin 
        result = a + b;
        branch = 1'b0;
      end
    endcase
  end

endmodule
