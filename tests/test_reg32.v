module test_reg32 ();
  reg reset;
  reg clk;
  reg [31:0] d;

  wire [31:0] q;

  Register register(.reset(reset), .clk(clk), .d(d), .q(q));

  always begin
    clk = 1'b1;
    #5 clk = 1'b0;
    #5;
  end

  initial begin
    reset = 1;
    d = 1;
    #20

    d = 1;
    #10
    d = 0;
    #10
    d = 1;
    #10

    $finish;
  end
endmodule