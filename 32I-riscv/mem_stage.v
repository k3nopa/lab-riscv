module mem_stage (
    input [31:0] address,
    input [31:0] write_data,
    input mem_read,
    input mem_write,

    // data memory
    input [31:0] rd_data,

    output [31:0] read_data,

    // data memory
    output [31:0] addr,
    output write,
    output mreq,
    output [31:0] wr_data
);

    assign addr = address;

    assign mreq = (mem_read || mem_write) ? 1 : 0;
    assign read_data = (mem_read) ? rd_data : 32'hx;
    
    assign write = (mem_write) ? 1 : 0;
    assign wr_data = (mem_write) ? write_data : 32'hx;

endmodule
