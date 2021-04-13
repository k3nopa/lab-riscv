module pc(clk,reset,pc_in,pc_out);

  input clk,reset;
  input [31:0] pc_in;

  reg [31:0] pc_current;
  wire [31:0] new_pc;

  output[31:0] pc_out;

  always @ (posedge clk or posedge reset) begin
    if(reset)
      pc_current <= 32'd0;
    else
      pc_current <= pc_in + 32'd4;
  end

  assign pc_out = pc_current;

endmodule // pc