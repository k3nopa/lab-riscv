
module test_if();
   reg [31:0] pc_in, branch_addr;
   reg reset, pc_src;

   wire [31:0] pc4;
   wire [31:0] inst_addr;

  if_stage if_phase(
      .reset(reset), .pc_src(pc_src) , .pc(pc_in), .branch_addr(branch_addr), 
      .pc4(pc4), .inst_addr(inst_addr)
  );
 
  initial begin
    $dumpfile("test_if.vcd");
    $dumpvars(0, test_if);

    reset=1'b0;
    #10

    reset=1'b1;
    pc_src = 0;
    branch_addr = 32'h0;

    pc_in = pc4;
    #10
    pc_in = pc4;
    #10
    pc_in = pc4;
    #10
    pc_in = pc4;
    #10
    pc_in = pc4;
    #10

    $finish;
  end
endmodule
