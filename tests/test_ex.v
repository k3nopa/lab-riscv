module test_ex ();
    reg [3:0] alu_op;
    reg alu_src;
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] sext;

    wire branch_result;
    wire [31:0] alu_result; // alu result
    wire [31:0] wr_data; // sext value

    ex_stage ex_phase(
        .alu_op(alu_op),
        .alu_src(alu_src),
        .a(a),
        .b(b),
        .sext(sext),

        .branch_result(branch_result),
        .alu_result(alu_result), // alu result
        .wr_data(wr_data) // sext value
    );

    initial begin
        $dumpfile("test_ex.vcd");
        $dumpvars(0, ex_phase);

        a = 5;
        b = 2;
        sext = 32'h80010000;
        alu_src = 1'd1;
        alu_op = 4'd10;

        #10
        $finish;
    end
endmodule
