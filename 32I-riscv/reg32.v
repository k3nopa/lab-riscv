module Register (
  input reset,
  input clk,
  input [31:0] d,

  output [31:0] q
);

  reg [31:0] q;

  always @(posedge clk or posedge reset) begin
    if (reset)
      q = 0;
    else 
      q = d;
  end 

endmodule