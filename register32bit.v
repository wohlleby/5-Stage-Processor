`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2016 09:49:26 PM
// Design Name: 
// Module Name: register32bit
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


module register32bit(in, out, signal, Reset, Clk); 

    (*dont_touch = "true"*) input [31:0] in;
    input Reset, Clk;
    input [1:0] signal;
    
    reg [31:0] register;
    
    output reg [31:0] out;
  
    
    always @(posedge Clk) begin
       
        
       
        if(Reset == 1)   //f reset, then reset address to 0 
            register <= 0;  
        
        else if(signal == 2'b00)
            register <= in; 
        else if(signal == 2'b01)
            register <= $signed(register) + $signed(in);
        else if(signal == 2'b10)
            register <= register - in;
        else
            register <= register;
    end
        
    always@(negedge Clk) begin
    
        out <= register;
    end

endmodule