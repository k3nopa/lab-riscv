module wb_stage (
    input [31:0]  pc4,
    input [31:0]  mem_rdata,
    input [31:0]  alu_result,
    input [4:0]   rd,

    input [1:0]   mem_to_reg,

    output [31:0] write_data
);

    function [31:0] r_write_data(
        input [31:0]    _pc4, _mem_rdata, _alu,
        input [1:0]     _select
    );
        begin
            case (_select)
                `PC4: r_write_data = _pc4;
                `MEMDATA: r_write_data = _mem_rdata;
                `ALURESULT: r_write_data = _alu;
                default: ;
            endcase
        end
    endfunction

    assign write_data = (rd == 5'b00000) ? 0 : r_write_data(pc4, mem_rdata, alu_result, mem_to_reg);

endmodule
