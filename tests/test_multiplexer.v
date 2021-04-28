module test_multiplexer ();
  reg [31:0] in1;
  reg [31:0] in2;
  reg select;

  wire [31:0] out;

  Mux2_1 mux(.in1(in1), .in2(in2), .select(select), .out(out));

  initial begin
    in1 = 32'd5;
    in2 = 32'd10;
    select = 1;
    #10

    in1 = 32'd5;
    in2 = 32'd10;
    select = 0;
    #10

    $finish;
  end
endmodule