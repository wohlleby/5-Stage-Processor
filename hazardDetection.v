`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 06:49:39 PM
// Design Name: 
// Module Name: hazardDetection
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hazardDetection(IF_instruction, ID_instruction, EX_instruction, EX_RegWrite, stall, Clk); 

    

    input [31:0] IF_instruction, ID_instruction, EX_instruction;
    input EX_RegWrite, Clk;
    output reg stall;
    
 
    
    initial begin
     
        stall = 0;
    end
    
   /* always@(posedge Clk) begin
    
        if (counter > 0) begin
            counter = counter -1;
         end
        
       
    end*/
    
    always@(EX_instruction or EX_RegWrite) begin
    
      
            
            
//       else if(!stall && (EX_instruction [31:26] == 6'b000001 || EX_instruction[31:26] == 6'b000100 ||
//                       EX_instruction[31:26] == 6'b000101 || (EX_instruction[31:26] == 6'b000111 && EX_instruction[20:16] == 5'b00000) ||
//                       (EX_instruction[31:26] == 6'b000110 && EX_instruction[20:16] == 5'b00000))) begin
                       
//                       counter <= 0;
//                       stall <= 0;
//       end //branch logic
        
    
         if (EX_RegWrite && (EX_instruction[31:26] == 6'b100011 || EX_instruction[31:26] == 6'b100000 ||  EX_instruction[31:26] == 6'b100001) && (ID_instruction[31:26] == 6'b100011 || ID_instruction[31:26] == 6'b100000 || ID_instruction[31:26] == 6'b100001) && (EX_instruction[20:16] != ID_instruction[25:21])) begin
            
                //special case where we have 2 load words in a row that don't have any dependences so they require no stalling
                
            end
            
            //regular case for load word, stall if there is a dependency immediately after the instruction
        else if (EX_RegWrite && (EX_instruction[31:26] == 6'b100011 || EX_instruction[31:26] == 6'b100000 || EX_instruction[31:26] == 6'b100001) && (EX_instruction[20:16] == ID_instruction[25:21]||EX_instruction[20:16] == ID_instruction[20:16])) begin
                         
                    stall <= 1;
    
        end
        
        else
            stall <= 0;
    
    
    
    end
    

endmodule
