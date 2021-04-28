module test_control();
  reg reset; 
  reg [31:0] inst; 

  wire mem_read, mem_write, reg_write, alu_src; 
  wire [1:0] mem_to_reg, jump; // 11(3) -> jump
  wire [1:0] inst_size;
  wire [3:0] alu_op;

  Control control(.reset(reset), .inst(inst), .mem_read(mem_read), .mem_write(mem_write), .reg_write(reg_write), .alu_src(alu_src), .mem_to_reg(mem_to_reg),
  .jump(jump), .inst_size(inst_size), .alu_op(alu_op));

  initial begin
    reset = 1;
    #10

    reset = 0;

    inst = 32'b10101110_00000011_10110011; //00000_00_01010_11100_000_00111_01100_11
    #10

    $finish;
  end
endmodule