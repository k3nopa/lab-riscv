module id_sign_extend(
    input [31:0] inst,

    output [31:0] extend_imm
);

    function [31:0] sign_extend;
        input [31:0] _inst;

        reg [6:0] op_part;
        reg [31:0] imm_u, imm_i, imm_store, imm_branch, imm_j;

        begin

            op_part = _inst[6:0];

            imm_u       = { _inst[31:12], 12'b0 }; // lui & auipc
            imm_i       = { {20{_inst[31]}}, _inst[31:20] }; // load & imm instruction
            imm_store   = { {20{_inst[31]}}, _inst[31:25], _inst[11:7] };
            imm_branch  = { {19{_inst[31]}}, _inst[31], _inst[7], _inst[30:25], _inst[11:8], 1'b0};
            imm_j       = { {11{_inst[31]}}, _inst[31],  _inst[19:12], _inst[20], _inst[30:21], 1'b0 };

            case (op_part)
                `LUI     : sign_extend = imm_u;
                `AUIPC   : sign_extend = imm_u;
                `IMM     : sign_extend = imm_i;
                `LOAD    : sign_extend = imm_i;
                `STORE   : sign_extend = imm_store;
                `BRANCH  : sign_extend = imm_branch;
                `JAL     : sign_extend = imm_j;
                `JALR    : sign_extend = imm_i;
                default : sign_extend = 32'h0;
            endcase
        end
    endfunction

    assign extend_imm = sign_extend(inst);


endmodule