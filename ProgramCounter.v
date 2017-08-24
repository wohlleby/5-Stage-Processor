`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Laboratory 1
// Module - pc_register.v
// Description - 32-Bit program counter (PC) register.
//
// INPUTS:-
// Address: 32-Bit address input port.
// Reset: 1-Bit input control signal.
// Clk: 1-Bit input clock signal.
//
// OUTPUTS:-
// PCResult: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design a program counter register that holds the current address of the 
// instruction memory.  This module should be updated at the positive edge of 
// the clock. The contents of a register default to unknown values or 'X' upon 
// instantiation in your module. Hence, please add a synchronous 'Reset' 
// signal to your PC register to enable global reset of your datapath to point 
// to the first instruction in your instruction memory (i.e., the first address 
// location, 0x00000000H).
////////////////////////////////////////////////////////////////////////////////

module ProgramCounter(Address, Register, PCResult, jumpRegister, branch, branchAmount, Reset, Clk, instruction, lookAhead, stall, writeRA);

	input [31:0] Address, Register, instruction, lookAhead;
	input Reset, Clk, branch, jumpRegister;
	input [15:0] branchAmount;

	output reg [31:0] PCResult;
    
    output reg stall;
    output reg writeRA;
    
    reg [15:0] prevAddress;
    reg [15:0] prevPrevAddress;
    
    reg [3:0] counter;
    /* Please fill in the implementation here... */
    
    always @(posedge Clk) begin
   
        writeRA <= 0;
        
        if(Reset == 1)  begin //f reset, then reset address to 0 
            PCResult <= 0; 
            counter <= 0;
            stall <= 0;
        end
        
        else if(counter > 0) //stall 1 cycle
            counter <= counter - 1;
        
        else if(stall && branch) begin
                //PCResult <= Address + $signed(branchAmount) - 1; 
                PCResult <= $signed(Address) + $signed(branchAmount);
                counter <= 0;
                stall <= 0;
        end
        
        
        else if (jumpRegister == 1) begin
            PCResult <= Register;
            counter <= 0;
            stall <= 0;
            prevAddress <= Address;
            prevPrevAddress <= prevAddress; 
        end
        
        /*else if (stall == 0 && instruction[31:26] == 6'b000010) begin //stall for jumps, set counter to 1 so that it stalls for 2 cycles
                                                                      //and it gives it time for the branch to resolve from decode stage
            stall <= 1;
            counter <= 1;
        
        end*/
        
        else if(stall == 0 && (instruction [31:26] == 6'b000001 || instruction[31:26] == 6'b000100 ||
           instruction[31:26] == 6'b000101 || (instruction[31:26] == 6'b000111 && instruction[20:16] == 5'b00000) ||
           (instruction[31:26] == 6'b000110 && instruction[20:16] == 5'b00000))) begin
                stall <= 1;
                counter <= 1;
        end
        
        else if (instruction[31:26] == 6'b000010) begin//jumps
               
            counter <= 0;                                             //stalls are taken care of by the branch
            stall <= 0;
            PCResult <= instruction[25:0];
            prevAddress <= Address;
            prevPrevAddress <= prevAddress; 
            
        
        end
        
        else if(stall == 0 && instruction[31:26] == 6'b000011) begin //JAL stall so we store the right value
            writeRA<= 1;
            stall <= 1;
        end
        
        else if(instruction[31:26] == 6'b000011) begin //Actual JAL after we stall
        
            stall <= 0;
            counter <= 0;
            PCResult <= instruction[25:0];
            prevAddress <= Address;
            prevPrevAddress <= prevAddress; 
        
        end
        
        else if (stall == 0 && instruction[31:26] == 6'b100011 && lookAhead[31:26] == 6'b100011 && (instruction[20:16] != lookAhead[25:21])) begin
        
            //special case where we have 2 load words in a row that don't have any dependences so they require no stalling
            PCResult <= Address;
            prevAddress <= Address;
            prevPrevAddress <= prevAddress; 
        end
        
        //regular case for load word, stall if there is a dependency immediately after the instruction
        else if ( stall == 0  && instruction[31:26] == 6'b100011 && (instruction[20:16] == lookAhead[25:21]|instruction[20:16] == lookAhead[20:16])) begin
                        
                stall <= 1;
                counter <= 0;

        end
        
        else begin
            stall <= 0;
            counter <= 0;
            PCResult <= Address;  
            prevAddress <= Address;
            prevPrevAddress <= prevAddress; 
        end
    end
    
    
    /*always@(*) begin
    
       if(instruction[31:26] == 6'b000010) begin    
               PCResult <= instruction[25:0];
               counter <= 0;
               stall <= 0;
       end
    end*/

endmodule
