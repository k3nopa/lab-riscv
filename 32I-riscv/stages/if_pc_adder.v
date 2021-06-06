module if_pc_adder(
    input reset, // active at low

    input [31:0] pc,
    output [31:0] pc4
);

    function [31:0] pc_add4(
        input [31:0] _pc,
        input _reset
    );

        begin
            if(!_reset)
                pc_add4 = 32'h0001_0000;
            else
                pc_add4 = _pc + 32'd4;
        end
    endfunction

    assign pc4 = pc_add4(pc, reset);
endmodule