module top (
  input [31:0] IDT,
  input [31:0] DDT,
  input ACKI#,
  input ACKD#,
  
  output [31:0] IAD,
  output [31:0] DAD,
  output MREQ,
  output WRITE,
  output [1:0] SIZE
);
  
endmodule