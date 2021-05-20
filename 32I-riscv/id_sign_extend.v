module id_sign_extend(
    input [31:0] inst,

    output [31:0] extend_imm
);

    localparam [6:0]
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    I_IMM = 7'b0010011,
    LOAD = 7'b0000011,
    STORE = 7'b0100011;

    function [31:0] sign_extend;
        input [31:0] _inst;

        reg [6:0] op_part;
        reg [31:0] imm_lui, imm_i, imm_store;

        begin

            op_part = _inst[6:0];

            imm_lui = { _inst[31:12], 12'h0 }; // lui & auipc
            imm_i = { {20{_inst[31]}}, _inst[31:20] }; // load & imm instruction
            imm_store = { {20{_inst[31]}}, _inst[31:25], _inst[11:7] };

            case (op_part)
                LUI     : sign_extend = imm_lui;
                AUIPC   : sign_extend = imm_lui;
                I_IMM   : sign_extend = imm_i;
                LOAD    : sign_extend = imm_i;
                STORE   : sign_extend = imm_store;
                default : sign_extend = 32'h0;
            endcase
        end
    endfunction

    assign extend_imm = sign_extend(inst);


endmodule