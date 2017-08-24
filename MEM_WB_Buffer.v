`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 06:59:47 PM
// Design Name: 
// Module Name: M_WB_Buffer
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

/*   MEM_WB_Buffer buffer_4(MEM_instruction, MEM_RegWrite, MEM_DataMemOut, MEM_hilowriteout, MEM_WriteReg, MEM_NoWrite, MEM_MemRead,
                 WB_instruction, WB_RegWrite, WB_DataMemOut, WB_hilowriteout, WB_WriteReg, WB_NoWrite, WB_MemRead, Clk);  */

module MEM_WB_Buffer(instruction_in, regWrite_in, dataMem_in, ALUoutput_in, writeReg_in, NoWrite_in, MemRead_in,
                    instruction_out, regWrite_out, dataMem_out, ALUoutput_out, writeReg_out, NoWrite_out, MemRead_out, Clk,
                    IF_Stall_in, IF_Stall_out, PCounter_in, PCounter_out);

input [31:0] dataMem_in, ALUoutput_in, instruction_in, PCounter_in;

input [4:0] writeReg_in;

input regWrite_in, Clk, NoWrite_in, MemRead_in, IF_Stall_in;

output reg [31:0] ALUoutput_out, dataMem_out, instruction_out, PCounter_out;

output reg [4:0] writeReg_out;

output reg regWrite_out, NoWrite_out, MemRead_out, IF_Stall_out;

        initial begin
            instruction_out = 0;
            ALUoutput_out = 0;
            dataMem_out = 0;
            writeReg_out =0;
            regWrite_out = 0;
            NoWrite_out = 0;
            MemRead_out = 0;
            IF_Stall_out = 0;
            PCounter_out = 0;
        end        

    always@(posedge Clk) begin
    
        instruction_out <= instruction_in;
        ALUoutput_out <= ALUoutput_in;
        dataMem_out <= dataMem_in;
        IF_Stall_out <= IF_Stall_in;
        
        writeReg_out <= writeReg_in;
        
        regWrite_out <= regWrite_in;
        NoWrite_out <= NoWrite_in;
        MemRead_out <= MemRead_in;
        MemRead_out <= MemRead_in;
        PCounter_out <= PCounter_in;
        
        end

endmodule
