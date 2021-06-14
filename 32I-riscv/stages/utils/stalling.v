module stalling(
    input [31:0] if_inst, id_inst,

    output stall
);
    function staller(input [31:0] before, input [31:0] current);
        begin
            if (before[6:0] == `LOAD && before[11:7] != 5'h0) begin
                if (before[11:7] == current[19:15] || before[11:7] == current[24:20]) 
                    staller = 1'b1;
                else 
                   staller = 1'b0;
            end
            else
                staller = 1'b0;
        end
    endfunction

    assign stall = staller(id_inst, if_inst);
endmodule