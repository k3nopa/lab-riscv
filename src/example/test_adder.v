module test_adder();
   reg [31:0] data1,data2;
   wire [31:0] adder_output;

   adder i_adder(data1,data2,adder_output);


   initial begin
      
      assign data1=32'd4;
      assign data2=32'd6;
      #10
      assign data1=32'd2;
      assign data2=32'd5;
      #10
      assign data1=32'd5;
      assign data2=32'd8;
      #10
	$finish;
   end
endmodule // test_adder

      
