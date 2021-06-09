module id_sign_extend(
    input [31:0] inst,

    output [31:0] extend_imm
);

    function [31:0] sign_extend;
        input [31:0] _inst;

        begin
            case (_inst[6:0])
                `LUI     : sign_extend = { _inst[31:12], 12'b0 };
                `AUIPC   : sign_extend = { _inst[31:12], 12'b0 };
                `IMM     : sign_extend = { {20{_inst[31]}}, _inst[31:20] };
                `LOAD    : sign_extend = { {20{_inst[31]}}, _inst[31:20] };
                `STORE   : sign_extend = { {20{_inst[31]}}, _inst[31:25], _inst[11:7] };
                `BRANCH  : sign_extend = { {19{_inst[31]}}, _inst[31], _inst[7], _inst[30:25], _inst[11:8], 1'b0};
                `JAL     : sign_extend = { {11{_inst[31]}}, _inst[31],  _inst[19:12], _inst[20], _inst[30:21], 1'b0 };
                `JALR    : sign_extend = { {20{_inst[31]}}, _inst[31:20] };
                default : sign_extend = 32'h0;
            endcase
        end
    endfunction

    assign extend_imm = sign_extend(inst);


endmodule