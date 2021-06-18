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
    function [31:0] load_conv(
        input _is_signed,
        input [1:0] _inst_size,
        input [31:0] _mem_data
    );
        begin
            if (_is_signed) begin
                case (_inst_size)
                    `BYTE : load_conv = { {24{_mem_data[7]}}, _mem_data[7:0]};
                    `HALF : load_conv = { {16{_mem_data[15]}}, _mem_data[15:0]};
                    `WORD : load_conv = _mem_data;
                    default: load_conv = _mem_data;
                endcase
            end
            else begin
                case (_inst_size)
                    `BYTE : load_conv = { {24{1'b0}}, _mem_data[7:0]};
                    `HALF : load_conv = { {16{1'b0}}, _mem_data[15:0]};
                    `WORD : load_conv = _mem_data;
                    default: load_conv = _mem_data;
                endcase
            end
        end
    endfunction

    assign addr = address;
    assign access_size = inst_size;

    assign mreq = (mem_read || mem_write) ? 1 : 0;
    assign read_data = (mem_read) ? load_conv(is_signed, inst_size, rd_data) : 32'hx;

    assign write = (mem_write) ? 1 : 0;
    assign wr_data = (mem_write) ?  write_data : 32'hx;

endmodule
