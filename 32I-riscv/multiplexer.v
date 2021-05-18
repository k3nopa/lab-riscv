module multiplexer (
    input clock,
    input [31:0] in1,
    input [31:0] in2,
    input select,

    output [31:0] out
);
    reg [31:0] _select;
    
    always @(posedge clock) begin
        case (select)
            0 : _select = in1;
            1 : _select = in2;
            default: ;
        endcase
    end
    
    assign out = _select;

endmodule