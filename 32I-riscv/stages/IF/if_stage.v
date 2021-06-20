module if_stage (
    input           pc_src,
    input           stall,
    input [1:0]     jump,

    input [31:0]    pc,
    input [31:0]    branch_addr,
    input [31:0]    jump_addr,

    output [31:0]   pc4,
    output [31:0]   inst_addr
);

    wire [31:0] pc_in, current_pc;

    assign pc_in = (jump == 2'd2) ? jump_addr : (pc_src) ? branch_addr : pc;
    assign current_pc = (stall == 1'b1) ? (pc_in - 4) : pc_in; 
    
    assign inst_addr = current_pc;
    assign pc4 = current_pc + 32'h4;

endmodule
