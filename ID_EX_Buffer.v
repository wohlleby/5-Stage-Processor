`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 05:40:46 PM
// Design Name: 
// Module Name: ID_EX_Buffer
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


module ID_EX_Buffer(instruction_in, ReadData1_in, ReadData2_in, signextend16_in, signextend5_in, hi_in, lo_in, 
                    hilowrite_in, hilo_in, ALUSrc_in, memRead_in, memWrite_in, regDst_in, regWrite_in, shift_in, Clk,
                    instruction_out, ReadData1_out, ReadData2_out, signextend16_out, signextend5_out, hi_out, lo_out,
                    hilowrite_out, hilo_out, ALUSrc_out, memRead_out, memWrite_out, regDst_out, regWrite_out, shift_out,
                    flush, IF_Stall_in, IF_Stall_out);
                    

    input [31:0] instruction_in, ReadData1_in, ReadData2_in, signextend16_in, signextend5_in;
    
    input [1:0] hi_in, lo_in;
    
    input Clk, hilowrite_in, hilo_in, ALUSrc_in, memRead_in, memWrite_in, regDst_in, regWrite_in, shift_in, flush, IF_Stall_in;
    
    output reg [31:0] instruction_out, ReadData1_out, ReadData2_out, signextend16_out, signextend5_out;                    
    
    output reg [1:0] hi_out, lo_out;
    
    output reg hilowrite_out, hilo_out, ALUSrc_out, memRead_out, memWrite_out, regDst_out, regWrite_out, shift_out, IF_Stall_out;
    
    initial begin
    
        instruction_out = 0;
        ReadData1_out = 0;
        ReadData2_out = 0;
        signextend16_out = 0;
        signextend5_out = 0;
        hi_out = 0;
        lo_out = 0;
        hilowrite_out = 0;
        hilo_out = 0;
        ALUSrc_out = 0;
        memRead_out = 0;
        memWrite_out = 0;
        regDst_out = 0;
        regWrite_out = 0;
        shift_out = 0;
        IF_Stall_out = 0;
    end
    
    always@(posedge Clk) begin
    
        if(flush == 1'b1) begin
        
            hilowrite_out <= 0;
            hilo_out <= 0;
            ALUSrc_out <= 0;
            memRead_out <= 0;
            memWrite_out <= 0;
            regDst_out <= 0;
            regWrite_out <= 0;
            shift_out <= 0;
            IF_Stall_out <= 0;  
            
            hi_out <= 0; //make 00 maintain
            lo_out <= 0;
            
            instruction_out <= 0;
            ReadData1_out <= 0;
            ReadData2_out <= 0;
            signextend16_out <= 0;
            signextend5_out <= 0; 
    
        end
        
        else begin
        
           
        
                hilowrite_out <= hilowrite_in;
                hilo_out <= hilo_in;
                ALUSrc_out <= ALUSrc_in;
                memRead_out <= memRead_in;
                memWrite_out <= memWrite_in;
                regDst_out <= regDst_in;
                regWrite_out <= regWrite_in;
                shift_out <= shift_in;
                IF_Stall_out <= IF_Stall_in;
                
                hi_out <= hi_in;
                lo_out <= lo_in;
                
                instruction_out <= instruction_in;
                ReadData1_out <= ReadData1_in;
                ReadData2_out <= ReadData2_in;
                signextend16_out <= signextend16_in;
                signextend5_out <= signextend5_in;
            
        end
    end                 
                    
endmodule
