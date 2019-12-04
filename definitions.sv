//This file defines the parameters used in the alu
// CSE141L
package definitions;
    
// Instruction map
    const logic [3:0]kADD  = 4'b0000; // Addition
    const logic [3:0]kLDS  = 4'b0001; // Load/Store
    const logic [3:0]kXOR  = 4'b0010; // XOR
    const logic [3:0]kBRC  = 4'b0011; // Branch
    const logic [3:0]kGST  = 4'b0100; // Get/Set
    const logic [3:0]kLSB  = 4'b0101; // From LSB to LSB/MSB
    const logic [3:0]kMSB  = 4'b0110; // From MSB to LSB/MSB
	 const logic [3:0]kLRS  = 4'b0111; // LShift/RShift
	 const logic [3:0]kACC  = 4'b1000; // Set Accumulator
	 const logic [3:0]kENQ  = 4'b1001; // Equals/Not Equals
	 const logic [3:0]kEQI  = 4'b1010; // Equals/Not Equals Immediate
	 const logic [3:0]kBRR  = 4'b1011; // Branch Register
	 const logic [3:0]kFBT  = 4'b1100; // Flip Bit
	 const logic [3:0]kBRO  = 4'b1101; // Branch Register Offset
	 const logic [3:0]kLTE  = 4'b1110; // Less than or Equal to
	 const logic [3:0]kRST  = 4'b1111; // Reset
	 
// enum names will appear in timing diagram
    typedef enum logic[3:0] {
        ADD, LDS, XOR, BRC,
        GST, LSB, MSB, LRS,
		  ACC, ENQ, EQI, BRR,
        FBT, BRO, LTE,
		  RST } op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
