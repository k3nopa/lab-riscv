module if_stage (
    input           reset, // active at low
    input           pc_src,
    input           stall,
    input [1:0]     jump,

    input [31:0]    pc,
    input [31:0]    branch_addr,
    input [31:0]    jump_addr,

    output [31:0]   pc4,
    output [31:0]   inst_addr
);

    wire [31:0] pc_in, current_pc, new_pc;

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

    if_pc_adder pc_adder(.reset(reset), .pc(current_pc), .pc4(new_pc));

    assign pc_in = (jump == 2'b10) ? jump_addr : mux(pc, branch_addr, pc_src);
    assign current_pc = (stall == 1'b1) ? (pc_in - 4) : pc_in; 
    
    assign inst_addr = current_pc;
    assign pc4 = new_pc;

endmodule
