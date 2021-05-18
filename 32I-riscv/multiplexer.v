module multiplexer (
    input [31:0] in1,
    input [31:0] in2,
    input select,

    output [31:0] out
);
    
    function [31:0] mux;
        input [31:0] _in1, _in2, _select;
        begin
        case (_select)
            0 : mux = _in1;
            1 : mux = _in2;
            default: ;
        endcase
        end
    endfunction
    
    assign out = mux(in1, in2, select);

endmodule