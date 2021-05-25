module if_stage (
    input reset,    // active at low
    input pc_src,
    input [1:0] jump,
    input [31:0] pc,
    input [31:0] branch_addr,
    input [31:0] jump_addr,

    output [31:0] pc4,
    output [31:0] inst_addr
);

    wire [31:0] current_pc;
    
    multiplexer pc_mux(
        .in1(pc), .in2(branch_addr), .in3(jump_addr), .select(pc_src), .jump(jump),
        .out(current_pc)
    );

    if_pc_adder pc_adder(.reset(reset), .pc(current_pc), .pc4(pc4));
    
    assign inst_addr = current_pc;

endmodule
