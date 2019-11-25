// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
import definitions::*;  // includes package "definitions"
module ALU(
  input [7:0]  INPUTA,        // data inputs
               INPUTB,
  input [4:0]	ImmI,
  input [4:1]	ImmX,
  input [3:0]  OP,            // ALU opcode, part of microcode
  input        T,             // Toggle bit used to toggle our instruction functionality
  //input        SC_IN,         // shift in/carry in 
  output logic [7:0] OUT,     // or:  output reg [7:0] OUT,
  //output logic SC_OUT,        // shift out/carry out
  output logic ZERO,          // zero out flag
  output logic [3:0] bOFFSET, // Signed branch offset produced by branch op
  output logic bSIGN
  );

  op_mne op_mnemonic;  // type enum: used for convenient waveform viewing

  always_comb begin
    //{SC_OUT, OUT} = 0;            // default -- clear carry out and result out
    
    // single instruction for both LSW & MSW
    case(OP)
      kADD : OUT = INPUTA + INPUTB + T; // + SC_IN;  // add w/ carry-in & out

      kXOR : begin // XOR rs with r0
               OUT    = INPUTA^INPUTB; // exclusive OR
               // SC_OUT = 0;             // clear carry out -- possible convenience
             end
				 
		kBRC : begin
		         if (INPUTB == 8'h00) begin
					  bOFFSET = ImmI[3:0];
					  bSIGN   = ImmI[4];
					end else begin
					  bOFFSET = 3'b001;
					  bSIGN   = 0;
					end
		       end
      kGST : begin // Get/Set registers
				   if (T)           // if toggle bit is 1,
					  OUT  = INPUTB; // set OUT to value at r0
					else             // otherwise,
					  OUT  = INPUTA; // set OUT to value at rs
					// SC_OUT = 0;      // ?? not sure about this line ??
             end

      kLSB : begin // Set r0's LSB/MSB to whatever was the LSB of rs
               if (T)                                   // if toggle bit is 1,
					  OUT  = {INPUTA[0], INPUTB[6:0]}; // set the LSB in r0 to the MSB of rs
					else                                     // otherwise,
					  OUT  = {INPUTB[7:1], INPUTA[0]};        // set the MSB in r0 to the LSB of rs
					// SC_OUT = 0;      // ?? not sure about this line ??
             end

		kMSB : begin // Set r0's LSB/MSB to whatever was the MSB of rs
		         if (T)                                   // if toggle bit is 1,
					  OUT  = {INPUTA[7], INPUTB[6:0]};        // set the MSB in r0 to the MSB of rs
					else                                     // otherwise,
					  OUT  = {INPUTB[7:1], INPUTA[7]}; // set the MSB in r0 to the LSB of rs
					// SC_OUT = 0;      // ?? not sure about this line ??
		       end

		kLRS : begin // Shift rs left/right by one bit depending on the toggle bit
		         if (T)
					  OUT  = INPUTA >> 1;
					else
					  OUT  = INPUTA << 1;
		       end

		kACC : begin // Set accumulator(r0) to ImmI(immediate in I instruction format)
		         OUT = ImmI;
					// SC_OUT = 0;      // ?? not sure about this line ??
		       end

		kENQ : begin // Checks if r0 ==/!= rs depending on the toggle bit
		         if (T) begin
					  if (INPUTB != INPUTA)
					    OUT = 8'h01;
					  else
					    OUT = 8'h00;
					end else begin
					  if (INPUTB == INPUTA)
					    OUT = 8'h01;
					  else
					    OUT = 8'h00;
					end
					// SC_OUT = 0;      // ?? not sure about this line ??
		       end

		kEQI : begin // Checks if r0 ==/!= ImmX depending on the toggle bit
		         if (T) begin
					  if (INPUTB != ImmX)
					    OUT = 8'h01;
					  else
					    OUT = 8'h00;
					end else begin
					  if (INPUTB == ImmX)
					    OUT = 8'h01;
					  else
					    OUT = 8'h00;
					end
					//SC_OUT = 0;      // ?? not sure about this line ??
		       end
      default: OUT = 0;       // no-op, zero out
    endcase
    case(OUT)
      'b0     : ZERO = 1'b1;
      default : ZERO = 1'b0;
    endcase
    //$display("ALU Out %d \n",OUT);
    op_mnemonic = op_mne'(OP);  // displays operation name in waveform viewer
  end
endmodule