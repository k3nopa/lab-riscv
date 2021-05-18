module reg32 (
  input reset,
  input clk,
  input [31:0] d,

  output reg [31:0] q
);

  always @(posedge clk or posedge reset) begin
    if (reset)
      q = 0;
    else 
      q = d;
  end 

endmodule