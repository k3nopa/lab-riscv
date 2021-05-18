module if_stage (
    input clock,
    input reset,
    input pc_src,
    input [31:0] pc,
    input [31:0] branch_addr,

    output [31:0] pc4,
    output [31:0] inst_addr
);

    wire [31:0] current_pc, pc_out;
    
    multiplexer pc_mux(
        .clock(clock), .in1(pc), .in2(branch_addr), .select(pc_src),
        .out(current_pc)
    );

    if_pc_adder pc_adder(.clock(clock), .reset(reset), .pc(current_pc), .pc4(pc_out));
    
    assign pc4 = pc_out;
    assign inst_addr = current_pc;

endmodule
