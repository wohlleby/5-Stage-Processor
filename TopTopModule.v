`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nicholas Wohlleb(50%) and Olivia Morell (50%)
// 
// Create Date: 10/24/2016 01:26:57 PM
// Design Name: 
// Module Name: TopTopModule
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


module TopTopModule(Clk, Reset, ClkReset, out7, en_out);

input Clk, Reset, ClkReset;
output [7:0] en_out;
output[6:0] out7;

wire [31:0] memwriteout, pccounter;
wire Clk_s;

//module ClkDiv(Clk, Rst, ClkOut);
ClkDiv ClkDiv_1(Clk, ClkReset, Clk_s);

//module TopModule(Clk, Reset, memwriteout, pccounter);
TopModule Top_1(Clk_s, Reset, memwriteout, pccounter);

//module Two4DigitDisplay(Clk, NumberA, NumberB, out7, en_out);
Two4DigitDisplay Display_1(Clk, pccounter[7:0], memwriteout[7:0], out7, en_out);

endmodule
