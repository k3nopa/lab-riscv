module test_control();
  reg reset; 
  reg [31:0] inst; 

  wire mem_read, mem_write, reg_write, alu_src; 
  wire [1:0] mem_to_reg, jump; // 11(3) -> jump
  wire [1:0] inst_size;
  wire [3:0] alu_op;

  Control control(
    .reset(reset), 
    .inst(inst), 
    .mem_read(mem_read), 
    .mem_write(mem_write), 
    .reg_write(reg_write), 
    .alu_src(alu_src), 
    .mem_to_reg(mem_to_reg),

   .jump(jump), 
   .inst_size(inst_size), 
   .alu_op(alu_op)
  );

  initial begin
    reset = 1;
    #10

    reset = 0;
    
    // LUI lui x1[00001], 10[1010]
    inst = 32'b00000000_10100000_10110111;
    #10

    // LW lw x1[00001], 8[1000](x2[00010])
    inst = 32'b00000000_10000001_00100000_10000011;
    #10
    // SW sw x1[00001], 8[1000](x2[00010])
    inst = 32'b00000000_00010001_00100100_00100011;
    #10
    // ADD add x1[00001], x2[00010], x3[00011]
    inst = 32'b00000000_00110001_00000000_10110011;
    #10

    // ADDI addi x1[00001], x2[00010], 8[1000]
    inst = 32'b00000000_10000001_00000000_10010011;
    #10

    $finish;
  end
endmodule