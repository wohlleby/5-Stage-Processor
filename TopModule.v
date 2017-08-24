`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers: Nick Wohlleb and Olivia Morell 
    // Collaboration 50%/50%
// 
// Create Date: 10/16/2016 07:27:01 PM
// Design Name: 
// Module Name: TopModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 5 stage pipeline, branches decision and resolution in EX, jumps in IF
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TopModule(Clk, Reset, WB_output, IF_PCounter, WB_IF_Stall, IF_Stall, s1, s2, s3, s4);

    
    input  Clk, Reset;


    wire  zero;
    wire  nowrite;
    //////////////////////////////////////////////////////////////////
    //Instruction Fetch Stage Wires
    wire [31:0] IF_instruction;
    output wire [31:0] IF_PCounter;
    
    wire IF_ID_Flush, writeRA;
    output wire IF_Stall;
    //////////////////////////////////////////////////////////////////
    
    
    //////////////////////////////////////////////////////////////////
    //Decode Stage Wires
    wire [31:0] ID_instruction, ID_PCounter, ID_ReadData1, ID_ReadData2;
    wire [31:0] ID_SignExtend16Out, ID_SignExtend5Out;
    output wire [31:0] s1, s2, s3, s4;
    
    wire [15:0] ID_JumpAmount;
    
    wire [1:0] ID_hi, ID_lo;
    
    wire ID_hilowrite, ID_hilo, ID_ALUSrc, ID_MemRead, ID_MemWrite,
         ID_RegDst, ID_RegWrite, ID_Shift, ID_RegWriteFlush, ID_MemWriteFlush;
    wire branch, jumpRegister, ID_IF_Stall;
    //////////////////////////////////////////////////////////////////
    
    
    //////////////////////////////////////////////////////////////////
    //Execute Stage Wires
   (*dont_touch = "true"*) wire [63:0] ALU64Out;
    
    wire [31:0] EX_instruction, EX_ReadData1, EX_ReadData2;
    wire [31:0] EX_SignExtend16Out, EX_SignExtend5Out;
    wire [31:0] EX_ShiftOut, EX_ALUSrcOut, EX_ALU32Out, EX_WriteData;
    wire [31:0] EX_hiout, EX_loout, EX_hiloout, EX_hilowriteout;
    
    wire [5:0] ALUcontrol;
    
    wire [4:0] EX_WriteReg;
    
    wire [1:0] EX_hi, EX_lo;
    
    wire EX_hilowrite, EX_hilo, EX_ALUSrc, EX_MemRead, EX_MemWrite,
         EX_RegDst, EX_RegWrite, EX_Shift, ID_EX_Flush,
         EX_NoWrite, EX_WriteDataSel;
         
    wire EX_RegWriteFlush, EX_MemWriteFlush, EX_Flush, EX_IF_Stall;
    //////////////////////////////////////////////////////////////////
    
    
    //////////////////////////////////////////////////////////////////
    //Memory Stage Wires
    wire [31:0] MEM_instruction, MEM_ReadData2, MEM_hilowriteout, MEM_WriteBackData,
                MEM_DataMemOut, MEM_WriteDataInput;
                
    wire [4:0] MEM_WriteReg;
    
    wire MEM_RegWrite, MEM_NoWrite, MEM_MemWrite, MEM_MemRead, MEM_WriteDataSel, MEM_IF_Stall;
    //////////////////////////////////////////////////////////////////
    

    //////////////////////////////////////////////////////////////////    
    //Writeback Stage Wires
    wire [31:0] WB_instruction, WB_DataMemOut, WB_hilowriteout;
    output wire [31:0] WB_output;
    
    wire [4:0] WB_WriteReg;
    
    wire WB_MemRead, WB_RegWrite, WB_NoWrite;
    output wire WB_IF_Stall;
    //////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////
    //Forwarding Unit Wires
    wire [1:0] Shift_Sel, ALUSrc_Sel;
    
    //////////////////////////////////////////////////////////////////
    // Hazard Unit Wires
    //wire IF_ID_stall;    
    
    
    //Instruction Fetch Stage
    
    //module InstructionFetchUnit(Instruction, out, Register, jumpRegister, branch, jumpAmount, branchAmount, Reset, Clk);
    InstructionFetchUnit IFU_1(IF_instruction, IF_PCounter, ID_ReadData1, jumpRegister, branch, EX_instruction[15:0], Reset, IF_Stall, Clk, writeRA);

    
    //module IF_ID_Buffer(instruction_in, instruction_out, PCounter_in, PCounter_out, flush, IF_Stall_in, IF_Stall_out, Clk);
    IF_ID_Buffer Buffer_1(IF_instruction, ID_instruction, jumpRegister|IF_ID_Flush|branch, IF_Stall, ID_IF_Stall, Clk);

    
    
    //Decode Stage
    
    
    //hazard detection unit
    //hazardDetection HD(ID_Rt, ID_Rd, EX_Rt, IF_ID_stall);
    //hazardDetection HD(EX_instruction[31:26], ID_instruction[20:16], ID_instruction[15:11], EX_instruction[20:16], IF_ID_stall, EX_MemRead);
    
    //RegisterFile ResiterFile_1(Instruction[25:21], Instruction[20:16], regdstout, hilowriteout, regwrite, nowrite, Clk, readdata1, readdata2, writeRA, pccounter);
    RegisterFile ResiterFile_1(ID_instruction[25:21], ID_instruction[20:16], WB_WriteReg, WB_output, WB_RegWrite, WB_NoWrite, Clk, ID_ReadData1, ID_ReadData2, s1, s2, s3, s4, writeRA, IF_PCounter);
    
    
    //module Control(Op, Func, RegDst, Shift, ALUSrc, RegWrite, hilo, hi, lo , hiloWrite, ALUOp, jumpRA, jumpRegister, writeRA, MemRead, MemWrite);
    Control Control_1(ID_instruction[31:26], ID_instruction[5:0], ID_RegDst, ID_Shift, ID_ALUSrc, ID_RegWrite,
                      ID_hilo, ID_hi, ID_lo, ID_hilowrite, jumpRA, jumpRegister, ID_MemRead, ID_MemWrite, IF_ID_Flush, ID_EX_Flush, EX_Flush);               ///UPDATE THE CONTROLLER
                                        
    SignExtension signextend_1(ID_instruction[15:0], ID_SignExtend16Out);
    SignExtension5to32 signextend_2(ID_instruction[10:6], ID_SignExtend5Out);
    
    
    //module Comparator(instruction, branch, ReadData1, ReadData2);
    
    /*Comparator Comparator_1(ID_instruction, branch, ID_ReadData1, ID_ReadData2, ID_JumpAmount, EX_instruction, ID_instruction[25:21], ID_instruction[20:16], 
                            EX_RegWrite, EX_WriteReg, EX_hilowriteout, MEM_RegWrite, MEM_WriteReg, MEM_hilowriteout, MEM_DataMemOut, MEM_MemRead,
                            WB_RegWrite, WB_WriteReg, WB_output, Clk);*/

    /*module ID_EX_Buffer(instruction_in, ReadData1_in, ReadData2_in, signextend16_in, signextend5_in, hi_in, lo_in, 
    hilowrite_in, hilo_in, ALUSrc_in, memRead_in, memWrite_in, regDst_in, regWrite_in, shift_in, Clk,
    instruction_out, ReadData1_out, ReadData2_out, signextend16_out, signextend5_out, hi_out, lo_out,
    hilowrite_out, hilo_out, ALUSrc_out, memRead_out, memWrite_out, regDst_out, regWrite_out, shift_out,
    flush, stall);*/
    
    ID_EX_Buffer Buffer_2(ID_instruction, ID_ReadData1, ID_ReadData2, ID_SignExtend16Out, ID_SignExtend5Out, ID_hi, ID_lo,
                         ID_hilowrite, ID_hilo, ID_ALUSrc, ID_MemRead, ID_MemWriteFlush, ID_RegDst, ID_RegWriteFlush, ID_Shift, Clk,
                         EX_instruction, EX_ReadData1, EX_ReadData2, EX_SignExtend16Out, EX_SignExtend5Out, EX_hi, EX_lo,
                         EX_hilowrite, EX_hilo, EX_ALUSrc, EX_MemRead, EX_MemWrite, EX_RegDst, EX_RegWrite, EX_Shift,
                         ID_EX_Flush | branch, ID_IF_Stall, EX_IF_Stall);
                         
    //FLUSH MUXES                      
    Mux1Bit2To1 flush_RegWrite_1(ID_RegWriteFlush, ID_RegWrite, 1'b0, branch);
    Mux1Bit2To1 flush_MemWrite_1(ID_MemWriteFlush, ID_MemWrite, 1'b0, branch);
                         
                        

    //Execution Stage
    
    Mux32Bit2To1 EX_Write_Data(EX_WriteData, EX_ReadData2, WB_output, EX_WriteDataSel);
    
    Mux32Bit4To1 shift_mux(EX_ShiftOut, EX_ReadData1, EX_SignExtend5Out, WB_output, MEM_hilowriteout, Shift_Sel);
    Mux32Bit4To1 ALUSrc_mux(EX_ALUSrcOut, EX_ReadData2, EX_SignExtend16Out, WB_output, MEM_hilowriteout, ALUSrc_Sel);
    
    Mux5Bit2To1 WriteRegMux_1(EX_WriteReg, EX_instruction[20:16], EX_instruction[15:11], EX_RegDst);
   
    
    //module ALUcontroller(OP, Func, ALUcontrol);
    ALUcontroller ALUcontroller_1(EX_instruction[31:26], EX_instruction[5:0], ALUcontrol); 
    
    //module ALU32Bit(ALUControl, A, B, ALUResult, ALU64Result, Zero, nowrite, flag21, flag16, flag6, branch);
    ALU32Bit ALU_1(ALUcontrol, EX_ShiftOut, EX_ALUSrcOut, EX_ALU32Out, ALU64Out, EX_NoWrite, EX_instruction[21], EX_instruction[16], EX_instruction[9], EX_instruction[6], branch);/*synopsys attribute fpga_dont_touch "true" */
    
    //module register32bit(in, out, signal, Instruction, Reset); 
    register32bit hi_1(ALU64Out[63:32], EX_hiout, EX_hi, Reset, Clk);/*synopsys attribute fpga_dont_touch "true" */
    register32bit lo_1(ALU64Out[31:0], EX_loout, EX_lo, Reset, Clk);/*synopsys attribute fpga_dont_touch "true" */
    
    //module Mux32Bit2To1(out, inA, inB, sel);
    Mux32Bit2To1 hilo_1(EX_hiloout, EX_loout, EX_hiout, EX_hilo);
    Mux32Bit2To1 hilowrite_1(EX_hilowriteout, EX_ALU32Out, EX_hiloout, EX_hilowrite); //hilowrite mux
    
 
    
    /*module forwardingUnit(EX_Rs, EX_Rt, MEM_Rt, MEM_WriteReg, WB_WriteReg, MEM_RegWrite, WB_RegWrite, ALUSrcSelect, ShiftSelect,
                          EX_OPCode, MEM_OPCode, EX_ALUSrc, EX_Shift, MEM_WriteData, EX_WriteData);*/
    (*dont_touch = "true"*)forwardingUnit FU(EX_instruction[25:21], EX_instruction[20:16], MEM_instruction[20:16], MEM_WriteReg, WB_WriteReg,
                       MEM_RegWrite, WB_RegWrite, EX_ALUSrc, EX_Shift, EX_instruction[31:26], MEM_instruction[31:26],
                       ALUSrc_Sel, Shift_Sel, MEM_WriteDataSel, EX_WriteDataSel); /*synopsys attribute fpga_dont_touch "true" */
    
       //FLUSH MUXES
    Mux1Bit2To1 flush_RegWrite_2(EX_RegWriteFlush, EX_RegWrite, 1'b0, branch|EX_IF_Stall);
    Mux1Bit2To1 flush_MemWrite_2(EX_MemWriteFlush, EX_MemWrite, 1'b0, branch|EX_IF_Stall);
   
    
    
    //Memory Stage
    
    /*module EX_MEM_Buffer(instruction_in, ReadData2_in, hilowrite_in, WriteBackData_in,
                         RegWrite_in, nowrite_in, MemWrite_in, MemRead_in, Clk,
                         instruction_out, ReadData2_out, hilowrite_out, WriteBackData_out,
                         RegWrite_out, nowrite_out, MemWrite_out, MemRead_out);*/
    
    EX_MEM_Buffer buffer_3(EX_instruction, EX_WriteData, EX_hilowriteout, EX_WriteReg, 
                           EX_RegWriteFlush, EX_NoWrite, EX_MemWriteFlush, EX_MemRead, Clk,
                           MEM_instruction, MEM_ReadData2, MEM_hilowriteout, MEM_WriteReg,
                           MEM_RegWrite, MEM_NoWrite, MEM_MemWrite, MEM_MemRead, EX_IF_Stall, MEM_IF_Stall);

    //module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, OppCode); 

    //module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, OppCode); readdata is output
    DataMemory DataMemory_1(MEM_hilowriteout, MEM_WriteDataInput, Clk, MEM_MemWrite, MEM_MemRead, MEM_DataMemOut, MEM_instruction[31:26]);

    Mux32Bit2To1 MEM_Write_Data(MEM_WriteDataInput, MEM_ReadData2, WB_output, MEM_WriteDataSel);
    
    
    //WRITEBACK
    
    /*module MEM_WB_Buffer(regWrite_in, dataMem_in, ALUoutput_in, writeReg_in,
                       regWrite_out, dataMem_out, ALUoutput_out, writeReg_out, Clk);*/
    
    MEM_WB_Buffer buffer_4(MEM_instruction, MEM_RegWrite, MEM_DataMemOut, MEM_hilowriteout, MEM_WriteReg, MEM_NoWrite, MEM_MemRead,
                 WB_instruction, WB_RegWrite, WB_DataMemOut, WB_hilowriteout, WB_WriteReg, WB_NoWrite, WB_MemRead, Clk, MEM_IF_Stall, WB_IF_Stall); 
    
    
    Mux32Bit2To1 WB_mux(WB_output, WB_hilowriteout, WB_DataMemOut, WB_MemRead);
     
    
    
endmodule

