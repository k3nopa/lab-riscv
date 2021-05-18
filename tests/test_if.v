
module test_if();
   reg [31:0] pc_in;
   reg clk, reset;

   wire [31:0] pc4;
   wire [31:0] inst_addr;

  always begin
    clk = 1'b1;
    #5 clk = 1'b0;
    #5;
  end

  IF if_phase(.clock(clk), .reset(reset), .pc_in(pc_in), .pc4(pc4), .inst_addr(inst_addr));
  
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, test_if);

    reset=1'b1;
    #10

    reset=1'b0;

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
