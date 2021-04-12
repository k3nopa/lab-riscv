module pc(clock,reset,pcin,pcwrite,pcout);
   
   input clock,reset;
   input [31:0] pcin;
   input 	pcwrite;
   output[31:0] pcout;
   reg[31:0] 	pcout;


   always@(posedge clock or negedge reset)
     begin

     if(reset==1'b0)
       begin
	  pcout<=32'h00010000;
       end
	
     end
   

endmodule // pc

	
	     
   
