module pc_adder(
  input clk, 
  input reset, 
  input [31:0] pc_in, 
  
  output [31:0] pc_out
);

  reg [31:0] pc_current;
  wire [31:0] new_pc;

  always @ (posedge clk or posedge reset) begin
    if(reset)
      pc_current <= 32'd0;
    else
      pc_current <= pc_in + 32'd4;
  end

  assign pc_out = pc_current;

endmodule // pc