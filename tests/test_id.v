
module test_id ();
  
  reg clk;
  reg reset;

  reg [31:0] inst, pc4;
  reg [31:0] write_data;

  wire [10:0] controls;
  wire [1:0] inst_size;
  wire [31:0] rd;
  wire [31:0] rs1;
  wire [31:0] rs2;
  wire [31:0] imm, branch_addr;
    
  id_stage id_test(
    .clock(clk),
    .reset(reset),
    .inst(inst),
    .write_data(write_data),

    .controls(controls),
    .inst_size(inst_size),
    .reg_a(rs1),
    .reg_b(rs2),
    .branch_addr(branch_addr),
    .sign_extend(imm)
  );

  always begin
    clk = 1'b1;
    #5 clk = 1'b0;
    #5;
  end

  initial begin
    $dumpfile("test_id.vcd");
    $dumpvars(0, id_test);
    reset = 0;
    #10
    
    reset = 1;
    pc4 = 32'h0001_0000;

    // LUI lui x1[00001], 10[1010]
    /*
        ra = 00001
        imm = 1010
    */
    inst = 32'b00000000_10100000_10110111;
    write_data = 1;
    #10

    // LW lw x1[00001], 8[1000](x2[00010])
    inst = 32'b00000000_10000001_00100000_10000011;
    write_data = 1;
    #10

    // SW sw x1[00001], 8[1000](x2[00010])
    inst = 32'b00000000_00010001_00100100_00100011;
    write_data = 0;
    #10

    // ADD add x1[00001], x2[00010], x3[00011]
    inst = 32'b00000000_00110001_00000000_10110011;
    write_data = 1;
    #10

    // ADDI addi x1[00001], x2[00010], 8[1000]
    inst = 32'b00000000_10000001_00000000_10010011;
    write_data = 1;
    #10

    $finish;

  end
endmodule
