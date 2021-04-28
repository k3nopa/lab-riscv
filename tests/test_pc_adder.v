module test_pc_adder ();
  reg reset;
  reg [31:0] pc_in;

  wire [31:0] pc_out;

  pc_adder i_pc_adder(.reset(reset), .pc_in(pc_in), .pc_out(pc_out));

  initial begin
    reset = 1;
    #10
    pc_in = 32'd200;
    #10
    pc_in = 32'd200;
    #10
    pc_in = pc_out;
    #10
    pc_in = pc_out;
    
  end
endmodule