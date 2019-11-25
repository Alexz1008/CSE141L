// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel
// CSE141L
// partial only
import definitions::*;  // includes package "definitions"
module TopLevel(		   // you will have the same 3 ports
	input     start,	   // init/reset, active high
	input     CLK,		   // clock -- posedge used inside design
	output    halt		   // done flag from DUT
    );

wire [ 9:0] PC;            // program count
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] regWriteValue, // data in to reg file
            memWriteValue, // data in to data_memory
	   	   Mem_Out;	      // data out from data_memory
wire [ 3:0] bOFFSET;       // to program counter: branch offset
wire        MEM_READ,	   // data_memory read enable
		      MEM_WRITE,	   // data_memory write enable
			   reg_wr_en,	   // reg_file write enable
			   // sc_clr,        // carry reg clear
			   // sc_en,	      // carry reg enable
		      // SC_OUT,	      // to carry register
			   ZERO,		      // ALU output = 0 flag
            branch_en,	   // to program counter: branch enable
				bSIGN,         // to program counter: branch offset sign (-/+)
				reset;
logic[15:0] cycle_ct;	   // standalone; NOT PC!
// logic       SC_IN;         // carry register (loop with ALU)

// Fetch = Program Counter + Instruction ROM
// Program Counter
  IF IF1 (
	.init       (start),
	.halt              ,  // SystemVerilg shorthand for .halt(halt),
	.branch_en	       ,  // branch enable
	.CLK        (CLK)  ,  // (CLK) is required in Verilog, optional in SystemVerilog
	.bSIGN,
	.bOFFSET,
	.PC             	    // program count = index to instruction memory
	);

// Control decoder
  Ctrl Ctrl1 (
	.Instruction,   // from instr_ROM
	.ZERO,			 // from ALU: result = 0
	.branch_en		 // to PC
	);
// instruction ROM
  InstROM #(.W(9)) instr_ROM1(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	);

  assign load_inst = Instruction == {4'b0001,Instruction[4:1],1'b0};  // calls out load specially
  assign reg_wr_en = !((Instruction[8:5] == kBRC) || ((Instruction[8:5] == kLDS) && (Instruction[0] == 1)));
// reg file
	reg_file #(.W(8),.D(4)) reg_file1 (
		.CLK    	  ,
		.write_en  (reg_wr_en),
		.T         (Instruction[0]),
		.reset,
		.raddrA    (Instruction[4:1]),         // concatenate with 0 to give us 4 bits
		.raddrB    (4'b0000),                  // accumulator address r0
		.OP        (Instruction[8:5]),
		//.waddr     ({4'b0000}), 	            // mux above
		.data_in   (regWriteValue),
		.data_outA (ReadA),
		.data_outB (ReadB)
	);
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

	assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = ReadB;
	assign MEM_READ  = (Instruction == {4'b0001,Instruction[4:1],1'b0});
	assign MEM_WRITE = (Instruction == {4'b0001,Instruction[4:1],1'b1});       // mem_store command
	assign regWriteValue = load_inst? Mem_Out : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .INPUTA  (InA),
	  .INPUTB  (InB),
	  .ImmI    (Instruction[4:0]),
	  .ImmX    (Instruction[4:1]),
	  .OP      (Instruction[8:5]),
	  .T       (Instruction[0]),
	  .OUT     (ALU_out),//regWriteValue),
	  .ZERO,
	  .bOFFSET,
	  .bSIGN,
	  .reset,
	  .halt
	  );
	  
  assign memWriteValue = ReadA;
	data_mem data_mem1(
		.DataAddress  (ReadB),
		.ReadMem      (MEM_READ),          //(MEM_READ) ,   always enabled
		.WriteMem     (MEM_WRITE),
		.DataIn       (memWriteValue),
		.DataOut      (Mem_Out),
		.CLK 		  		     ,
		.reset		  (start)
	);
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

//always_ff @(posedge CLK)    // carry/shift in/out register
//  if (sc_clr)				// tie sc_clr low if this function not needed
//    SC_IN <= 0;             // clear/reset the carry (optional)
//  else if (sc_en)			// tie sc_en high if carry always updates on every clock cycle (no holdovers)
//    SC_IN <= SC_OUT;        // update the carry  

endmodule
