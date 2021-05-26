module hazard_detection(
    input [31:0] current, before,
    input next, // if next, means the next instruction. if !next, oldest instruction

    output [3:0] hazard,
    output stall
);

    localparam [2:0]
    NONE = 0,
    FROM_EX_RS1 = 1,
    FROM_EX_RS2 = 2,
    FROM_MEM_RS1 = 3,
    FROM_MEM_RS2 = 4;

    // Instructions' Type
    localparam [6:0]
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    LOAD = 7'b0000011,
    STORE = 7'b0100011,
    BRANCH = 7'b1100011,
    JAL = 7'b1101111;

    function [4:0] hazard_check(input [31:0] _current, _before);
        begin
            /* 
             *  load & branch have no dest reg.
             *  lui & auipc & jal dont have src reg.
             *  Thus these instructions are not valid to be check for hazards.
             *  To simplify, the condition needed to be checking for hazards are have both dest and src registers
             */
            if ( _current[6:0] !== LUI && _current[6:0] !== AUIPC && _current[6:0] !== JAL && _before[6:0] !== STORE && _before[6:0] !== BRANCH ) begin

                // compare current inst at id to inst at mem(if inst exist)
                if (next) begin
                    if (_before !== 32'hx &&  _before[11:7] === _current[19:15])
                        hazard_check = {1'b1, FROM_MEM_RS1, 1'b0};
                    else if (_before !== 32'hx && _before[11:7] === _current[24:20])
                        hazard_check = {1'b1, FROM_MEM_RS2, 1'b0};
                end
                // compare current inst at id to inst at ex(if inst exist)
                else begin
                    if (_before !== 32'hx && _before[11:7] === _current[19:15]) begin
                        // if load was instruction before, stall current stage
                        if (_before[6:0] === LOAD) begin
                            hazard_check = {1'b1, FROM_MEM_RS1, 1'b1};
                        end
                        else begin
                            hazard_check = {1'b1, FROM_EX_RS1, 1'b0};
                        end
                    end
                    else if (_before !== 32'hx && _before[11:7] === _current[24:20]) begin
                        // if load was instruction before, stall current stage
                        if (_before[6:0] === LOAD) begin
                            hazard_check = {1'b1, FROM_MEM_RS2, 1'b1};
                        end
                        else begin
                            hazard_check = {1'b1, FROM_EX_RS2, 1'b0};
                        end
                    end
                end
            end
            else
                hazard_check = {1'b0, 3'b000, 1'b0};
        end

    endfunction

    assign {hazard, stall} = hazard_check(current, before);

endmodule