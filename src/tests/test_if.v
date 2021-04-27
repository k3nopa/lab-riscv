
module test_if();
   reg [31:0] pc_in;
   reg clk, reset;

   wire [31:0] pc_out;
   wire [31:0] test;

  always begin
    clk = 1'b1;
    #5 clk = 1'b0;
    #5;
  end

  IF if_phase(.clock(clk), .reset(reset), .pc(pc_in), .pc4(pc_out), .inst(test));
  
  initial begin

    pc_in=32'h200;
    reset=1'b1;
    #10
    pc_in=32'h204;
    reset=1'b0;
    #100
    $finish;

  end
endmodule // test_adder