module pc_adder(
  input reset, 
  input [31:0] pc_in, 
  
  output [31:0] pc_out
);

  reg [31:0] pc_out;

  always @(*) begin
    if(reset)
      pc_out <= 32'h00010000;
    else
      pc_out <= pc_in + 32'd4;
  end

endmodule // pc