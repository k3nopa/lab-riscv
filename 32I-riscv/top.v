module top (
    input clk,
    input rst,

    input ACKD_n, // acknowledge from data memory [active low]
    input ACKI_n, // acknowledge from instruction memory [active low]
    input [31:0] IDT, // instruction data bus
    input [2:0] OINT_n, // out interrupt [active low] 111 -> no interrupt

    inout [31:0] DDT, // data data bus

    output [31:0] IAD, // instruction address bus
    output [31:0] DAD, // data address bus
    output MREQ, // memory request [active high] for reading
    output WRITE, // write permission [active high]
    output [1:0] SIZE, // memory access bit size
    output IACK_n // interrupt acknowledge
);

    // If stage inputs and outputs
    wire pc_src = 1'b0;
    wire [31:0] pc4, pc_in;

    // Id stage inputs and outputs
    wire mem_read, mem_write, alu_src;
    wire [1:0] mem_to_reg, jump;
    wire [3:0] alu_op;
//    wire [10:0] controls;
    wire [31:0] reg_data_in;

    // Mem stage inputs and outputs
    wire [31:0] branch_addr, alu_result, mem_read_data, reg_read_data1, reg_read_data2, imm;

    // Pipeline

    /*
     * IF~WB : pc4
     * IF/ID : instruction
     * ID/EX : branch_addr, rd1, rd2, sext
     * EX/MEM: alu_result, wd
     * MEM/WB: alu_result, mem_data  
     */

    localparam IF_ID = 0, ID_EX = 1, EX_MEM = 2, MEM_WB = 3;

    reg [31:0] PL_PC4[IF_ID:MEM_WB], PL_ALU_RESULT[EX_MEM:MEM_WB];
    reg [31:0] PL_INST, PL_BRANCH_ADDR, PL_RD1, PL_RD2, PL_SEXT, PL_WB, PL_MEM_DATA;
    reg [10:0] PL_CONTROLS;

    // PC register
    reg32 PC(
        .reset(~rst), .clk(clk), .d(pc_in),
        .q(pc4)
    );

    // if stage
    if_stage if_phase(
        .clock(clk), .reset(~rst), .pc(pc4), .branch_addr(branch_addr), .pc_src(pc_src),
        .pc4(pc_in), .inst_addr(IAD)
    );

//    always @(posedge clk) begin
//        PL_PC4[IF_ID] = pc_in;
//        PL_INST = IDT;
//    end

    id_stage id_phase(
        .clock(clk), .reset(~rst), .inst(IDT), .write_data(reg_data_in),
        .controls({mem_read, mem_write, alu_src, mem_to_reg, jump, alu_op}),
        .inst_size(SIZE),
        .reg_a(reg_read_data1), .reg_b(reg_read_data2), .sign_extend(imm)
    );

//    assign {mem_read, mem_write, alu_src, mem_to_reg, jump, alu_op} = controls;

//    always @(posedge clk) begin
//        PL_PC4[IF_ID] = PL_PC4[PL_PC4];
//        PL_INST = IDT;
//    end

    ex_stage ex_phase(
        .alu_op(alu_op), .alu_src(alu_src), .a(reg_read_data1), .b(reg_read_data2), .sext(imm),
        .branch_result(pc_src), .alu_result(alu_result)
    );

    mem_stage mem_phase(
        .address(alu_result), .write_data(reg_read_data2), .mem_read(mem_read), .mem_write(mem_write), .rd_data(DDT),
        .read_data(mem_read_data), .addr(DAD), .write(WRITE), .mreq(MREQ), .wr_data(DDT)
    );

    wb_stage wb_phase(
        .pc4(pc4), .mem_data(mem_read_data), .alu_result(alu_result), .mem_to_reg(mem_to_reg),
        .write_data(reg_data_in)
    );

endmodule
