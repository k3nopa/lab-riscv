module test_pc();
   reg [31:0] pc_in;
   reg clk, reset;

   wire [31:0] pc_out;

  always begin
    clk = 1'b1;
    #5 clk = 1'b0;
    #5;
  end

  pc i_pc(clk, reset, pc_in, pc_out);
  
  initial begin

    pc_in=32'h200;
    reset=1'b1;
    #10
    pc_in=32'h204;
    reset=1'b0;
    #10
    pc_in=32'h208;
    reset=1'b0;
    #10 
    pc_in=32'h2c0;
    reset=1'b1;
    #10
    $finish;

  end
endmodule // test_adder