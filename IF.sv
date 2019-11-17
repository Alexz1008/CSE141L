// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
// issues halt when PC reaches 63
module IF(
  input init,
		  branch_en, 
		  CLK,
		  bSIGN,
  input [3:0] bOFFSET,
  output logic halt,
  output logic[ 9:0] PC);

always @(posedge CLK)
  if(init) begin
    PC <= 0;
    halt <= 0;
  end else begin
    if(PC>63)
	   halt <= 1;		 // just a randomly chosen number 
	 else if(branch_en) begin
	   if (bSIGN)
	     PC <= PC - bOFFSET;
		else
		  PC <= PC + bOFFSET;
	 end else
	   PC <= PC + 1;	     // default == increment by 1
  end
endmodule
        