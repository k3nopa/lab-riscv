module if_pc_adder(
    input clock,
    input reset,
    
    input [31:0] pc,
    output [31:0] pc4
);
    
    reg [31:0] current_pc;
    
    always @(posedge clock or posedge reset) begin
        if(reset)
            current_pc <= 32'h0001_0000;
        else if (pc === 32'h0)
            current_pc <= 32'h0001_0000;
        else
            current_pc <= pc + 32'd4;
    end
    
    assign pc4 = current_pc;
endmodule