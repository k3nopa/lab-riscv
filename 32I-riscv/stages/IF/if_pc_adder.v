module if_pc_adder(
    input           reset, // active at low

    input [31:0]    pc,
    output [31:0]   pc4
);

    assign pc4 = (!reset) ? 32'h0001_0000 : pc + 4;
endmodule