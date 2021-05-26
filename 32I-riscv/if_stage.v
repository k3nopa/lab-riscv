module if_stage (
    input reset,    // active at low
    input pc_src,
    input stall,
    input [1:0] jump,
    input [31:0] pc,
    input [31:0] branch_addr,
    input [31:0] jump_addr,

    output [31:0] pc4,
    output [31:0] inst_addr
);

    wire [31:0] current_pc, new_pc;
    
    multiplexer pc_mux(
        .in1(pc), .in2(branch_addr), .in3(jump_addr), .select(pc_src), .jump(jump),
        .out(current_pc)
    );

    if_pc_adder pc_adder(.reset(reset), .pc(current_pc), .pc4(new_pc));
        
        
    // need to minus 4 because, stall is detected during id stage.
    // at this stage, pc is already at next instruction
    assign pc4 = (stall !== 1'bx && stall === 1'b1) ? (pc - 32'd4) : new_pc;
    assign inst_addr = (stall !== 1'bx && stall === 1'b1) ? pc : current_pc;

endmodule
