`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - Mux32Bit2To1.v
// Description - Performs signal multiplexing between 3 32-Bit words.
////////////////////////////////////////////////////////////////////////////////

module Mux32Bit4To1(out, inA, inB, inC, inD, sel);

    output reg [31:0] out;
    
    input [31:0] inA;
    input [31:0] inB;
    input [31:0] inC;
    input [31:0] inD;
    
    input [1:0] sel;

   always@(sel, inA, inB, inC, inD) begin

    if(sel == 2'b00)
         out <= inA;
    
    else if (sel == 2'b01)
       out <= inB;
    
    else if(sel == 2'b10)
       out <= inC;
       
    else
       out <= inD;

   end
   
endmodule
