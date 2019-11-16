// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
import definitions::*;  // includes package "definitions"
module ALU(
  input [7:0]  INPUTA,        // data inputs
               INPUTB,
					II,
					IX,
  input [3:0]  OP,            // ALU opcode, part of microcode
  input        T,             // Toggle bit used to toggle our instruction functionality
  input        SC_IN,         // shift in/carry in 
  output logic [7:0] OUT,     // or:  output reg [7:0] OUT,
  output logic SC_OUT,        // shift out/carry out
  output logic ZERO,          // zero out flag
  output logic BEVEN          // LSB of input B = 0
  );

  op_mne op_mnemonic;  // type enum: used for convenient waveform viewing

  always_comb begin
    {SC_OUT, OUT} = 0;            // default -- clear carry out and result out
    
    // single instruction for both LSW & MSW
    case(OP)
      kADD : {SC_OUT, OUT} = {1'b0,INPUTA} + INPUTB + SC_IN;  // add w/ carry-in & out

      kXOR : begin // XOR rs with r0
               OUT    = INPUTA^INPUTB; // exclusive OR
               SC_OUT = 0;             // clear carry out -- possible convenience
             end

      kGST : begin // Get/Set registers
				   if (T)           // if toggle bit is 1,
					  OUT  = INPUTB; // set OUT to value at r0
					else             // otherwise,
					  OUT  = INPUTA; // set OUT to value at rs
					SC_OUT = 0;      // ?? not sure about this line ??
             end

      kLSB : begin // Set r0's LSB to whatever was the LSB/MSB of rs
               if (T)                                   // if toggle bit is 1,
					  OUT  = ((INPUTA&8'h80) >> 7) | INPUTB; // set the LSB in r0 to the MSB of rs
					else                                     // otherwise,
					  OUT  = (INPUTA&8'h01) | INPUTB;        // set the LSB in r0 to the LSB of rs
					SC_OUT = 0;      // ?? not sure about this line ??
             end

		kMSB : begin // Set r0's MSB to whatever was the LSB/MSB of rs
		         if (T)                                   // if toggle bit is 1,
					  OUT  = (INPUTA&8'h80) | INPUTB;        // set the MSB in r0 to the MSB of rs
					else                                     // otherwise,
					  OUT  = ((INPUTA&8'h01) << 7) | INPUTB; // set the MSB in r0 to the LSB of rs
					SC_OUT = 0;      // ?? not sure about this line ??
		       end

		kLRS : begin // Shift rs left/right by one bit depending on the toggle bit
		         if (T)
					  {OUT, SC_OUT} = {SC_IN, INPUTA}; // Don't understand, copied from starter code
					  // OUT  = INPUTA >> 1;
					else
					  {OUT, SC_OUT} = {INPUTA, SC_IN}; // Don't understand, copied from starter code
					  // OUT  = INPUTA << 1;
		       end

		kACC : begin // Set accumulator(r0) to II(immediate in I instruction format)
		         OUT = II;
					SC_OUT = 0;      // ?? not sure about this line ??
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
					SC_OUT = 0;      // ?? not sure about this line ??
		       end

		kEQI : begin // Checks if r0 ==/!= II depending on the toggle bit
		         if (T) begin
					  if (INPUTB != II)
					    OUT = 8'h01;
					  else
					    OUT = 8'h00;
					end else begin
					  if (INPUTB == II)
					    OUT = 8'h01;
					  else
					    OUT = 8'h00;
					end
					SC_OUT = 0;      // ?? not sure about this line ??
		       end
      default: {SC_OUT,OUT} = 0;       // no-op, zero out
    endcase
    case(OUT)
      'b0     : ZERO = 1'b1;
      default : ZERO = 1'b0;
    endcase
    //$display("ALU Out %d \n",OUT);
    op_mnemonic = op_mne'(OP);  // displays operation name in waveform viewer
  end
  always_comb BEVEN = OUT[0];            // note [0] -- look at LSB only
  //    OP == 3'b101; //!INPUTB[0];               
  // always_combbranch_enable = opcode[8:6]==3'b101? 1 : 0;  
endmodule