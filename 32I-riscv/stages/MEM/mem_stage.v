module mem_stage (
    input [31:0]    address, write_data,
    input [1:0]     inst_size,
    input           mem_read, mem_write, is_signed,

    // data memory
    input [31:0]    rd_data,

    output [31:0]   read_data,

    // data memory
    output [1:0]    access_size,
    output [31:0]   addr,
    output          write,
    output          mreq,
    output [31:0]   wr_data
);

    wire [31:0] load_data;
    wire [31:0] load_byte  = (is_signed) ? { {24{rd_data[7]}}, rd_data[7:0]} : { {24{1'b0}}, rd_data[7:0]};
    wire [31:0] load_half  = (is_signed) ? { {16{rd_data[15]}}, rd_data[15:0]} : { {16{1'b0}}, rd_data[15:0]};
    wire [31:0] load_word  = rd_data;

    assign load_data = 
    (inst_size == `BYTE) ? load_byte :
    (inst_size == `HALF) ? load_half : load_word;

    assign addr = address;
    assign access_size = inst_size;

    assign mreq = (mem_read || mem_write) ? 1 : 0;
    assign read_data = (mem_read) ? load_data : 32'h0;

    assign write = (mem_write) ? 1 : 0;
    assign wr_data = (mem_write) ?  write_data : 32'h0;

endmodule
