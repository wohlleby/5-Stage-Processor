`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address: 32-Bit address input port.
// WriteData: 32-Bit input port.
// Clk: 1-Bit Input clock signal.
// MemWrite: 1-Bit control signal for memory write.
// MemRead: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design the above memory similar to the 'RegisterFile' model in the previous 
// assignment.  Create a 1K memory, for which we need 10 bits.  In order to 
// implement byte addressing, we will use bits Address[11:2] to index the 
// memory location. The 'WriteData' value is written into the address 
// corresponding to Address[11:2] in the positive clock edge if 'MemWrite' 
// signal is 1. 'ReadData' is the value of memory location Address[11:2] if 
// 'MemRead' is 1, otherwise, it is 0x00000000. The reading of memory is not 
// clocked.
//
// you need to declare a 2d array. in this case we need an array of 1024 (1K)  
// 32-bit elements for the memory.   
// for example,  to declare an array of 256 32-bit elements, declaration is: reg[31:0] memory[0:255]
// if i continue with the same declaration, we need 8 bits to index to one of 256 elements. 
// however , address port for the data memory is 32 bits. from those 32 bits, least significant 2 
// bits help us index to one of the 4 bytes within a single word. therefore we only need bits [9-2] 
// of the "Address" input to index any of the 256 words. 
////////////////////////////////////////////////////////////////////////////////

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, OppCode); 

    

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data that needs to be written into the address
    input [5:0] OppCode; 
    input Clk;
    input MemWrite; 		// Control signal for memory write 
    input MemRead; 			// Control signal for memory read 

    
    reg[31:0] memory [0:5000];
     
    output reg[31:0] ReadData; // Contents of memory location at Address
    integer i = 0;
    
   
    /* Please fill in the implementation here */
    initial begin
         
       memory[0] = 32'd4;
    memory[1] = 32'd4;
    memory[2] = 32'd2;
    memory[3] = 32'd2;
    memory[4] = 32'd0;
    memory[5] = 32'd0;
    memory[6] = 32'd1;
    memory[7] = 32'd2;
    memory[8] = 32'd0;
    memory[9] = 32'd0;
    memory[10] = 32'd3;
    memory[11] = 32'd4;
    memory[12] = 32'd0;
    memory[13] = 32'd0;
    memory[14] = 32'd0;
    memory[15] = 32'd0;
    memory[16] = 32'd0;
    memory[17] = 32'd0;
    memory[18] = 32'd0;
    memory[19] = 32'd0;
    memory[20] = 32'd1;
    memory[21] = 32'd2;
    memory[22] = 32'd3;
    memory[23] = 32'd4;


        
    end
    
    always @(posedge Clk)begin
    
        if (MemWrite == 1  )     
            memory[Address / 4] <= WriteData;
        else if( OppCode == 6'b101000)
           memory[Address / 4] <= {6'h000000, WriteData[7:0]};
        else if (OppCode == 6'b101001)
           memory[Address / 4] <= {4'h0000, WriteData[15:0]};
        
    end
    
   always @(negedge Clk) begin
   
       /* if (MemWrite == 1 && MemRead == 1 ) begin
               memory[Address >> 2] <= WriteData;
               ReadData <= memory[Address >> 2];
        end*/
        if(MemRead == 1 && OppCode == 6'b100000) begin //special sign extend case for LB
            if(memory[Address / 4][7] == 1'b1)
                ReadData <= {24'b111111111111111111111111, memory[Address / 4][7:0]};
            else
                ReadData <= {24'b000000000000000000000000, memory[Address / 4][7:0]};
        end
        
        else if(MemRead == 1 && OppCode == 6'b100001) begin
             if(memory[Address / 4][15] == 1'b1) 
                 ReadData <= {16'b1111111111111111, memory[Address / 4][15:0]};
            
        else
            ReadData <= {16'b0000000000000000, memory[Address / 4][15:0]};
    end           
              
        else //if(MemRead == 1)
           ReadData <= memory[Address / 4];

          
   end
   
   
    


endmodule
