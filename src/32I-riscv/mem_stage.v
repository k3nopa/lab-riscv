module MEM (
  input [31:0] address,
  input [31:0] write_data,
  input mem_read,
  input mem_write,

  // data memory
  input [31:0] rd_data,

  output [31:0] read_data,
  output [31:0] alu_result

  // data memory
  output [31:0] addr,
  output size, 
  output write,
  output mreq,
  output [31:0] wr_data
);

  assign addr = address;
  assign write = (mem_write) ? 1 : 0;
  assign read_data = rd_data;
  assign wr_data = write_data;
  // 00 = word, 01 = half, 10 = byte 
  assign size = 
    (word) ? 2'b00 :
    (half) ? 2'b01 :
    (byte) ? 2'b10 : 2'b00;

  assign mreq = (mem_read) ? 1 : 0;
  assign alu_result = address;

endmodule