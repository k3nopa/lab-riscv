module test_multiplexer ();
  reg [31:0] in1,
  reg [31:0] in2,
  reg select,

  wire [31:0] out

  initial begin
    in1 = 32'b5;
    in2 = 32'b10;
    select = 1
    #10

    in1 = 32'b5;
    in2 = 32'b10;
    select = 0
    #10
  end
endmodule