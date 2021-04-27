module adder(data1,data2,adder_out);
   
   input [31:0] data1,data2; // declear bit width and name of input 
   output [31:0] adder_out; // declear bit width and name of output

   assign adder_out = data1+data2; //assign result to output 

endmodule // adder
