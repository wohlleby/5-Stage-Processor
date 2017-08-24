`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 05:40:46 PM
// Design Name: 
// Module Name: EX_MEM_Buffer
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


module EX_MEM_Buffer(instruction_in, ReadData2_in, hilowrite_in, WriteReg_in,
                     RegWrite_in, nowrite_in, MemWrite_in, MemRead_in, Clk,
                     instruction_out, ReadData2_out, hilowrite_out, WriteReg_out,
                     RegWrite_out, nowrite_out, MemWrite_out, MemRead_out, stall_in, stall_out);

    input [31:0] ReadData2_in, instruction_in, hilowrite_in;
    
    input [4:0] WriteReg_in;

    input RegWrite_in, nowrite_in, MemWrite_in, MemRead_in, Clk, stall_in;

    output reg [31:0] instruction_out, ReadData2_out, hilowrite_out;
    
    output reg [4:0] WriteReg_out;

    output reg RegWrite_out, nowrite_out, MemWrite_out, MemRead_out, stall_out;

    initial begin
    
        instruction_out = 0;
        ReadData2_out = 0;
        hilowrite_out = 0;
        MemRead_out = 0;
        RegWrite_out = 0;
        nowrite_out = 0;
        stall_out = 0;
        MemWrite_out = 0;
        
    end

    always@(posedge Clk) begin
    
        instruction_out <= instruction_in;
        ReadData2_out <= ReadData2_in;
        hilowrite_out <= hilowrite_in;
        stall_out <= stall_in;

        WriteReg_out <= WriteReg_in;
        
        RegWrite_out <= RegWrite_in;
        nowrite_out <= nowrite_in;
        MemWrite_out <= MemWrite_in;
        MemRead_out <= MemRead_in;
    end

endmodule
