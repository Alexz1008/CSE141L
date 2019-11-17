// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  input       ZERO,			   // ALU out[7:0] = 0
  output logic branch_en
  );
  
// Enable branching if the Instruction operation is a branch.
always_comb
  if(Instruction[8:5] == kBRC)
    branch_en = 1;
  else
    branch_en = 0;

endmodule

   // ARM instructions sequence
   //				cmp r5, r4
   //				beq jump_label