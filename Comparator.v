`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2016 03:01:15 AM
// Design Name: 
// Module Name: Comparator
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

/*Comparator Comparator_1(ID_instruction, branch, ID_ReadData1, ID_ReadData2, ID_JumpAmount, EX_instruction, MEM_instruction, WB_instruction, 
                            EX_RegWrite, EX_WriteReg, EX_hilowriteout, MEM_RegWrite, MEM_WriteReg, MEM_hilowriteout, MEM_DataMemOut, MEM_MemRead,
                            WB_RegWrite, WB_WriteReg, WB_output, Clk);*/

module Comparator(instruction, branch, ReadData1, ReadData2, jumpAmount, EX_instruction, ID_Rs, ID_Rt, 
                 EX_RegWrite, EX_WriteReg, EX_hilowriteout, MEM_RegWrite, MEM_WriteReg, MEM_hilowriteout, MEM_DataMemOut, MEM_MemRead,
                 WB_RegWrite, WB_WriteReg, WB_output, Clk);
     
     reg [31:0] A, B;

    input [31:0] instruction, EX_instruction, ReadData1, ReadData2, EX_hilowriteout;
    input [31:0] MEM_hilowriteout, MEM_DataMemOut, WB_output;
    
    input [4:0] EX_WriteReg, MEM_WriteReg, WB_WriteReg, ID_Rs, ID_Rt;
    
    input Clk, EX_RegWrite, MEM_RegWrite, EX_RegWrite, WB_RegWrite, MEM_MemRead;
    
    output reg [15:0] jumpAmount;
    output reg branch;

    
    always@(negedge Clk) begin
   
            branch <= 0;
            jumpAmount <= 0;
            
            A = ReadData1;
            B = ReadData2;
            
            /*if(WB_RegWrite && (WB_WriteReg == instruction [25:21] || WB_WriteReg == instruction[20:16])) begin
            
                if(WB_WriteReg == instruction[25:21])
                    A = WB_output;
                if(WB_WriteReg == instruction[20:16])
                    B = WB_output;
            
            end*/
            

            if(MEM_MemRead && MEM_WriteReg == ID_Rs)
                A <= MEM_DataMemOut;
            if(MEM_MemRead && MEM_WriteReg == ID_Rt)
                B <= MEM_DataMemOut;
             

            if(MEM_RegWrite && MEM_WriteReg == ID_Rs)
                A <= MEM_hilowriteout;
            if(MEM_RegWrite && MEM_WriteReg == ID_Rt)
                B <= MEM_hilowriteout;                    

            

            

            
            if(EX_RegWrite && EX_WriteReg == ID_Rs)
                A <= EX_hilowriteout;
            if(EX_RegWrite && EX_WriteReg == ID_Rt)
                B <= EX_hilowriteout; 
            

    
   
        if(instruction[31:26] == 6'b000001 && instruction[20:16] == 5'b00001) begin //bgez
            if($signed(A) > 0 || $signed(A) == 0) begin
                branch <= 1;            
                jumpAmount <= instruction[15:0];
            end
        end
        
        if(instruction[31:26] == 6'b000100) begin //beq
            if($signed(A) == $signed(B)) begin
                branch <= 1;               
                jumpAmount <= instruction[15:0];
            end
        end
        
        if(instruction[31:26] == 6'b000101) begin //bne
            if($signed(A) != $signed(B)) begin
               branch <= 1;        
               jumpAmount <= instruction[15:0];
            end
        end
        
        if(instruction[31:26] == 6'b000111 && instruction[20:16] == 5'b00000) begin //bgtz
            if($signed(A) > 0) begin
                   branch <= 1;
                   jumpAmount <= instruction[15:0];
            end
        end
        
        if(instruction[31:26] == 6'b000110 && instruction[20:16] == 5'b00000) begin //blez
            if($signed(A) < 0 || $signed(A) == 0) begin
                branch <= 1;
                jumpAmount <= instruction[15:0]; 
            end
        end
        
        if(instruction[31:26] == 6'b000001 && instruction[20:16] == 5'b00000) begin //bltz
            if($signed(A) < 0) begin
                branch <= 1;
                jumpAmount <= instruction[15:0];
            end              
        end   
    
    end
    
endmodule
