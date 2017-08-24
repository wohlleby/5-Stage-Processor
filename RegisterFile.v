`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
//
//
// Student(s) Name and Last Name: Nicholas Wohlleb & Olivial Morell
//
//
// Module - register_file.v
// Description - Implements a register file with 32 32-Bit wide registers.
//
// 
// INPUTS:-
// ReadRegister1: 5-Bit address to select a register to be read through 32-Bit 
//                output por`t 'ReadRegister1'.
// ReadRegister2: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister2'.
// WriteRegister: 5-Bit address to select a register to be written through 32-Bit
//                input port 'WriteRegister'.
// WriteData: 32-Bit write input port.
// RegWrite: 1-Bit control input signal.
//
// OUTPUTS:-
// ReadData1: 32-Bit registered output. 
// ReadData2: 32-Bit registered output. 
//
// FUNCTIONALITY:-
// 'ReadRegister1' and 'ReadRegister2' are two 5-bit addresses to read two 
// registers simultaneously. The two 32-bit data sets are available on ports 
// 'ReadData1' and 'ReadData2', respectively. 'ReadData1' and 'ReadData2' are 
// registered outputs (output of register file is written into these registers 
// at the falling edge of the clock). You can view it as if outputs of registers
// specified by ReadRegister1 and ReadRegister2 are written into output 
// registers ReadData1 and ReadData2 at the falling edge of the clock. 
//
// 'RegWrite' signal is high during the rising edge of the clock if the input 
// data is to be written into the register file. The contents of the register 
// specified by address 'WriteRegister' in the register file are modified at the 
// rising edge of the clock if 'RegWrite' signal is high. The D-flip flops in 
// the register file are positive-edge (rising-edge) triggered. (You have to use 
// this information to generate the write-clock properly.) 
//
// NOTE:-
// We will design the register file such that the contents of registers do not 
// change for a pre-specified time before the falling edge of the clock arrives 
// to allow for data multiplexing and setup time.
////////////////////////////////////////////////////////////////////////////////

//    RegisterFile ResiterFile_1(Instruction[25:21], Instruction[20:16], regdstout, hilowriteout, regwrite, nowrite, Clk, readdata1, readdata2, writeRA, pccounter);
module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, nowrite, Clk, ReadData1, ReadData2, s1, s2, s3, s4, writeRA, PCounter);

	/* Please fill in the implementation here... */
	input [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    input [31:0] WriteData, PCounter;
    input RegWrite, Clk, nowrite, writeRA;
    
    reg [31:0] register [0:31];
    
    integer i = 0;
    
    output [31:0] s1, s2, s3, s4;	
    output [31:0] ReadData1, ReadData2;
    
    initial begin
        
         for(i=0; i < 32; i=i+1)
                register[i] = 0;
         
    end
    
   assign ReadData1 = register[ReadRegister1];
   assign ReadData2 = register[ReadRegister2]; 
    

   
   always@( negedge Clk) begin
   
        /*if(Clk)begin
            register[0] = 0;
        end*/
   
            if(writeRA == 1)
               register[31] <= (PCounter + 4) >> 2; //+1 may not be the right amount to store in RA
            if(RegWrite == 1 && nowrite != 1)
               register[WriteRegister] <= WriteData;
           
       end
       
       
   
   
       assign s1 = register[17];
       assign s2 = register[18];
       assign s3 = register[19];
       assign s4 = register[20];
   
    

endmodule