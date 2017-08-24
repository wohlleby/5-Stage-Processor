`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 06:46:11 PM
// Design Name: 
// Module Name: fowardingUnit
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

/*synopsys attribute fpga_dont_touch "true" */
module forwardingUnit(EX_Rs, EX_Rt, MEM_Rt, MEM_WriteReg, WB_WriteReg, MEM_RegWrite, WB_RegWrite, ALUSrcSelect, ShiftSelect,
                      EX_OPCode, MEM_OPCode, EX_ALUSrc, EX_Shift, MEM_WriteData, EX_WriteData);

/*synopsys attribute fpga_dont_touch "true" */

input[5:0] MEM_OPCode, EX_OPCode;
input [4:0]  EX_Rs, EX_Rt, MEM_Rt, MEM_WriteReg, WB_WriteReg;

input MEM_RegWrite, WB_RegWrite, ALUSrcSelect, ShiftSelect;
output reg [1:0] EX_ALUSrc, EX_Shift;
output reg MEM_WriteData, EX_WriteData; 

reg [4:0] MEM_dependency, WB_dependency;

    always @(EX_Rs, EX_Rt, MEM_WriteReg, WB_WriteReg, MEM_RegWrite, WB_RegWrite, ALUSrcSelect, ShiftSelect, MEM_OPCode, MEM_Rt, EX_OPCode)begin
    
        EX_Shift = 0;
        EX_ALUSrc = 0;
        MEM_WriteData = 0;
        EX_WriteData = 0;
    
        if(MEM_RegWrite || WB_RegWrite) begin
        
        
                if(MEM_RegWrite && MEM_WriteReg == EX_Rs) 
                    EX_Shift <= 2'b11;
                else if (WB_RegWrite && WB_WriteReg == EX_Rs)
                    EX_Shift <= 2'b10;
                else
                    EX_Shift <= ShiftSelect;
                    
                    
                if(!ALUSrcSelect && MEM_RegWrite && MEM_WriteReg == EX_Rt)
                    EX_ALUSrc <= 2'b11;
                else if (!ALUSrcSelect && WB_RegWrite && WB_WriteReg == EX_Rt)
                    EX_ALUSrc <= 2'b10;
                else
                    EX_ALUSrc <= ALUSrcSelect;
            
           
            
            //forwarding back to write data
            //sw, sh,sb
            if(WB_RegWrite && (MEM_OPCode == 6'b101011 || MEM_OPCode == 6'b101000 || MEM_OPCode == 6'b101001)) begin
            
                if(MEM_Rt == WB_WriteReg)
                    MEM_WriteData <= 1;
                
            end
            //sw, sh, sb
            else if(WB_RegWrite && (EX_OPCode == 6'b101011 || EX_OPCode == 6'b101000 || EX_OPCode == 6'b101001)) begin
            
                if(EX_Rt == WB_WriteReg)
                    EX_WriteData <= 1;
            
            end               
            
        end
        
        else begin //no dependencies in memory or writeback
        
            EX_Shift <= ShiftSelect;
            EX_ALUSrc <= ALUSrcSelect;
        end
        

        
    end  

endmodule
