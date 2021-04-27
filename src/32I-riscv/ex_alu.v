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
    SL = 4'd5,
    SR = 4'd6,
    SLT = 4'd7,
    SLTU = 4'd8,
    AUIPC = 4'd9;


  always @(*) begin
    case (op)
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