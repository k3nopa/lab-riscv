module if_pc_adder(
    input reset, // active at low
    input stall,
    input [1:0] jump,

    input [31:0] pc,
    output [31:0] pc4
);

    function [31:0] pc_add4(
        input [31:0] _pc,
        input _reset,
        input _stall,
        input [1:0] _jump
    );

        begin
            if(!_reset || _pc === 32'h0000_0000)
                pc_add4 = 32'h0001_0000;
            else if (_stall)
                pc_add4 = _pc;
            else
                pc_add4 = _pc + 32'd4;
        end
    endfunction

    assign pc4 = pc_add4(pc, reset, stall, jump);
endmodule