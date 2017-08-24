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


module hazardDetection(OPCode, ID_Rt, ID_Rd, EX_Rt, IF_ID_stall, EX_MemRead);

    input [5:0] OPCode;
    input [4:0] ID_Rt, ID_Rd, EX_Rt;
    input EX_MemRead;
    output reg IF_ID_stall;

    initial begin 
        IF_ID_stall = 1'b0;
    end

    always @(ID_Rt, ID_Rd, EX_Rt, OPCode)

        if (EX_MemRead&&(OPCode == 6'b100011&&(EX_Rt == ID_Rt)|(EX_Rt == ID_Rd)))
            IF_ID_stall = 1'b1;

        else 
            IF_ID_stall = 1'b0;

endmodule
