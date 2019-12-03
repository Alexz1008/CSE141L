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
      halt,
  input [ 8:0] bOFFSET,
  output logic[ 9:0] PC);
  
logic start_prog1 = 1;
logic start_prog2 = 0;
logic start_prog3 = 0;

always @(posedge CLK)
  if(init) begin
    PC <= 0;
    if(start_prog1) begin
      PC <= 0;
      start_prog1 <= 0;
      start_prog2 <= 1;
    end else if (start_prog2) begin
      PC <= 2;
      start_prog1 <= 0;
      start_prog2 <= 1;
    end
  end else begin
	 if(branch_en) begin
	   if (bSIGN)
	     PC <= PC - bOFFSET;
		else
		  PC <= PC + bOFFSET;
	 end else
	   PC <= PC + 1;	     // default == increment by 1
  end
endmodule
        