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

module ProgramCounter(Address, Register, PCResult, jumpRegister, branch, branchAmount, Reset, Clk, instruction, writeRA, stall);

	input [31:0] Address, Register, instruction;
	input Reset, Clk, branch, jumpRegister, stall;
	input [15:0] branchAmount;

	output reg [31:0] PCResult;
    
    output reg writeRA;
    
    reg [3:0] counter;
    reg ifstall;
    
    always @(posedge Clk) begin
   
        writeRA <= 0;
        
        if(Reset == 1)  begin //f reset, then reset address to 0 
            PCResult <= 0;
            counter <= 0;
            ifstall <= 0;
        end
       
        else if (counter > 0)
            counter = counter - 1;
        
        else if(branch) begin
                //PCResult <= Address + $signed(branchAmount) - 1; 
                PCResult <= $signed(Address) + $signed(branchAmount);
                counter <= 0;
                ifstall <= 0;
        end
       
        
        else if (jumpRegister == 1) begin
            counter <= 0;
            ifstall <= 0;
            PCResult <= Register;
        end

        else if(!ifstall && instruction[31:26] == 6'b000011) begin 
        
            writeRA <= 1;
            ifstall <= 1;
        end
        
        else if(instruction[31:26] == 6'b000011) begin //Actual JAL after we stall
        
            counter <= 0;
            ifstall <= 0;
            PCResult <= instruction[25:0];
        
        end        
        
        
       
                
        else if(ifstall == 0 && (instruction [31:26] == 6'b000001 || instruction[31:26] == 6'b000100 ||
                           instruction[31:26] == 6'b000101 || (instruction[31:26] == 6'b000111 && instruction[20:16] == 5'b00000) ||
                           (instruction[31:26] == 6'b000110 && instruction[20:16] == 5'b00000))) begin
                                ifstall <= 1;
                                counter <= 1;
                        end

        
        else if (!ifstall && instruction[31:26] == 6'b000010) begin//jumps
                            
                 counter = 1;       
                 ifstall <= 1;  
               end          
        
        
        else if (!stall && instruction[31:26] == 6'b000010) begin//jumps
               
            counter <= 0;
            ifstall <= 0;
            PCResult <= instruction[25:0];         
        
        end
        
       

        else begin
            
            if(!stall)
                 PCResult <= Address;  
                 
            ifstall <= 0;
            counter <= 0;
        end
    end
    
    

endmodule
