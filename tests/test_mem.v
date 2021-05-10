module test_mem ();
  
  reg [31:0] address;
  reg [31:0] write_data;
  reg mem_read;
  reg mem_write;
  reg [1:0] inst_size;

  // data memory
  reg [31:0] rd_data;

  wire [31:0] read_data;
  wire [31:0] alu_result;

  // data memory
  wire [31:0] addr;
  wire size; 
  wire write;
  wire mreq;
  wire [31:0] wr_data;

  initial begin

  end

endmodule