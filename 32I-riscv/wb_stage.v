module wb_stage (
  input [31:0] pc4,
  input [31:0] mem_data,
  input [31:0] alu_result,

  input [1:0] mem_to_reg,

  output [31:0] write_data
);

  localparam 
    PC4 = 2'd0,
    MEMDATA = 2'd1,
    ALURESULT = 2'd2;

  reg [31:0] r_write_data;

  always @(*) begin
    case (mem_to_reg)
      PC4: r_write_data <= pc4;
      MEMDATA: r_write_data <= mem_data;
      ALURESULT: r_write_data <= alu_result;
      default: r_write_data <= alu_result;
    endcase
  end

  assign write_data = r_write_data;
  
endmodule