module test_alu();
  reg [31:0] src1, src2;
  reg [3:0] op;

  wire [31:0] result;
  wire branch;

  ex_alu i_alu(.a(src1), .b(src2), .op(op), .result(result), .branch(branch));
  
  initial begin
    $dumpfile("test_alu.vcd");
    $dumpvars(0, i_alu);

    // add
    src1 = 32'd10;
    src2 = 32'd5;
    op = 4'b0000;
    #10
    // mul
    src1 = 32'd10;
    src2 = 32'd5;
    op = 4'b1000;
    #10
    // sub
    src1 = 32'd10;
    src2 = 32'd5;
    op = 4'b0001;
    #10

    // and
    src1 = 32'dx;
    src2 = 32'd5;
    op = 4'b0011;
    #10

    // or
    src1 = 32'dx;
    src2 = 32'd5;
    op = 4'b0110;
    #10

    // beq
    src1 = 32'd1;
    src2 = 32'd1;
    op = 4'b1100;
    #10

    $finish;

  end
endmodule
