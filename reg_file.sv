// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2
import definitions::*;  // includes package "definitions"
module reg_file #(parameter W=8, D=4)(		 // W = data path width; D = pointer width
  input           CLK,
                  write_en,
						T,       // Toggle bit in instruction
						reset,
  input  [ D-1:0] raddrA,	// raddrA is always rs (Instruction[4:1]) as defined in TopLevel.sv
                  raddrB,	// raddrB is always r0 (the accumulator) as defined in TopLevel.sv
						OP,      // opcode in instruction
  reg    [3:0]    index,
  input  [ W-1:0] data_in,
  output [ W-1:0] data_outA,
  output logic [W-1:0] data_outB
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] registers[2**D];	  // or just registers[16] if we know D=4 always

// combinational reads w/ blanking of address 0
assign      data_outA = registers[raddrA];	              // can read from addr 0, just like ARM
always_comb data_outB = registers[raddrB];                //

// sequential (clocked) writes 
always_ff @ (posedge CLK) begin
  if (write_en && ((OP == kGST && T) || (OP == kLRS) || (OP == kLDS))) // If reg write is enabled AND the operation
    registers[raddrA] <= data_in;                                      // is Get/Set with toggle bit set to 1, the
  else if (write_en)											                    // operation is L/RShift, OR, op is Load/Store write to rs.
    registers[raddrB] <= data_in;                                      // otherwise, write to r0.
  else if (reset) begin
    registers[0] <= 0;
	 registers[1] <= 0;
	 registers[2] <= 0;
	 registers[3] <= 0;
	 registers[4] <= 0;
	 registers[5] <= 0;
	 registers[6] <= 0;
	 registers[7] <= 0;
	 registers[8] <= 0;
	 registers[9] <= 0;
	 registers[10] <= 0;
	 registers[11] <= 0;
	 registers[12] <= 0;
	 registers[13] <= 0;
	 registers[14] <= 0;
	 registers[15] <= 0;
  end
end
endmodule
