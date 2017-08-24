`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 04:22:36 PM
// Design Name: 
// Module Name: IF_ID_Buffer
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

//IF_ID_Buffer Buffer_1(IF_instruction, ID_instruction, IF_PCounter, ID_PCounter, IF_ID_Flush | branch, Clk);
module IF_ID_Buffer(instruction_in, instruction_out, flush, stall, Clk);

    input [31:0] instruction_in;
    
    input Clk, flush, stall;
    
    output reg [31:0] instruction_out;
    
        initial begin
            instruction_out = 0;
        end    
    
    always@(posedge Clk) begin
    
        if(flush) begin

            instruction_out <= 0;
        end
        
       if (stall) begin
        
           //do not update instruction
        end
        
        else begin
        
            instruction_out <= instruction_in;

        end
    
    end

endmodule
