module multiplexer (
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input select,
    input [1:0] jump,

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
    
    assign out = (jump !== 2'bx) ? in3 : mux(in1, in2, select);

endmodule