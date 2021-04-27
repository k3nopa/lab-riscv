module Mux2_1 (
  input [31:0] in1,
  input [31:0] in2,
  input select,

  output [31:0] out
);

  reg [31:0] mux_out;

  always @(select) begin
    case (select)
      0 : mux_out <= in1;
      1 : mux_out <= in2;
      default: mux_out <= 32'bx;
    endcase
  end

  assign out = mux_out;

endmodule