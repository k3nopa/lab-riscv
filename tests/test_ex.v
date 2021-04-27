module test_ex ();
  reg clk, reset;

  reg [31:0] pc4 = 32'd204;
  reg [3:0] alu_op;
  reg alu_src;
  reg [31:0] a, b, sext;

  wire [31:0] pc4_out, addr, data;
  wire branch;

  EX ex_stage(
    .clock(clk),
    .reset(reset),
    .pc4(pc4),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .a(a),
    .b(b),
    .sext(sext),
    .pc4_pass(pc4_out),
    .branch_result(branch), 
    .address(addr), // alu result
    .wr_data(data) // sext value
  );

  always begin
    clk = 1'b1;
    #5 clk = 1'b0;
    #5;
  end 

  initial begin
    a = 5;
    b = 2;
    sext = 7;
    alu_src = 1'd0;
    alu_op = 4'd0;

    #10
    alu_op = 4'd1;
    #10
    alu_op = 4'd2;
    alu_src = 1'd1;

    #10
    $finish;
  end
endmodule