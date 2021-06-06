module reg32 (
  input         reset,  // active at low
  input         clk,
  input [31:0]  d,

  output reg [31:0] q
);

  always @(posedge clk or negedge reset) begin
    if (!reset)
      q = 32'h0001_0000;
    else 
      q = d;
  end 

endmodule