`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Nicholas Wohlleb and Olivia Morell
// Overall percent effort of each team meber: 50%/50%
// 
// ECE369 - Computer Architecture
// Laboratory 3 (PostLab)
// Module - InstructionFetchUnit.v
// Description - Fetches the instruction from the instruction memory based on 
//               the program counter (PC) value.
// INPUTS:-
// Reset: 1-Bit input signal. 
// Clk: Input clock signal.
//
// OUTPUTS:-
// Instruction: 32-Bit output instruction from the instruction memory. 
//              Decimal value diplayed on the LCD usng the wrapper given in Lab 2
//
// FUNCTIONALITY:-
// Please connect up the following implemented modules to create this
// 'InstructionFetchUnit':-
//   (a) ProgramCounter.v
//   (b) PCAdder.v
//   (c) InstructionMemory.v
// Connect the modules together in a testbench so that the instruction memory
// outputs the contents of the next instruction indicated by the memory location
// in the PC at every clock cycle. Please initialize the instruction memory with
// some preliminary values for debugging purposes.
//
// @@ The 'Reset' input control signal is connected to the program counter (PC) 
// register which initializes the unit to output the first instruction in 
// instruction memory.
// @@ The 'Instruction' output port holds the output value from the instruction
// memory module.
// @@ The 'Clk' input signal is connected to the program counter (PC) register 
// which generates a continuous clock pulse into the module.
////////////////////////////////////////////////////////////////////////////////

module InstructionFetchUnit(Instruction, out, Register, jumpRegister, branch, branchAmount, Reset, stall, Clk, writeRA);

    
    input  Clk, Reset, branch, jumpRegister, stall;
    input [31:0] Register;
    input [15:0] branchAmount;
    output wire [31:0] Instruction, out;
    
    output wire writeRA;
    wire [31:0] Address, PCResult;

    //module ProgramCounter(Address, Register, PCResult, jumpAmount, jump, jumpRegister, branch, branchAmount, Reset, Clk, instruction, lookAhead, stall);
    //module ProgramCounter(Address, Register, PCResult, jumpAmount, jump, jumpRegister, branch, branchAmount, Reset, Clk);
    ProgramCounter counter_1(Address, Register, PCResult, jumpRegister, branch, branchAmount, Reset, Clk, Instruction, writeRA, stall);   
       
    InstructionMemory memory_1(PCResult, Instruction);
   
    
    PCAdder adder_1(PCResult, Address);
    
    assign out = PCResult << 2;
 
    
    
endmodule
