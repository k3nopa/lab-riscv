module test_wb ();
  
  reg [31:0] pc4;
  reg [31:0] mem_data;
  reg [31:0] alu_result;
  reg [1:0] mem_to_reg;

  wire [31:0] write_data;

  WB wb_phase(.pc4(pc4), .mem_data(mem_data), .alu_result(alu_result), .mem_to_reg(mem_to_reg), .write_data(write_data));

  initial begin
    pc4 = 32'h0x0001200;
    mem_data = 32'h0x01001000;
    alu_result = 32'd10;

    write_data = 2'd0;
    #10;

    write_data = 2'd0;
    #10;

    write_data = 2'd0;
    #10;

    $finish ;

  end 
endmodule