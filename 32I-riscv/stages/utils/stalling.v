module stalling(
    input [31:0] if_inst, id_inst,

    output stall
);

    wire [6:0] id_op  = id_inst[6:0];
    wire [4:0] rd     = id_inst[11:7];

    wire [4:0] rs1    = if_inst[19:15];
    wire [4:0] rs2    = if_inst[24:20];

    function staller(input [6:0] op);
        begin
            if (op == `LOAD) begin
                if (rd != 5'h0 && rs1 != 5'h0 && ( rd == rs1 || rd == rs2 ))
                    staller = 1'b1;
                else 
                   staller = 1'b0;
            end
            else
                staller = 1'b0;
        end
    endfunction

    assign stall = staller(id_op);
endmodule
