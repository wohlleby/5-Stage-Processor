`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nicholas Wohlleb and Olivia Morell (50% and 50%)
// 
// Create Date: 10/26/2016 11:14:00 AM
// Design Name: 
// Module Name: TopTopModule_tb
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


module TopTopModule_tb();

    reg Clk, Reset, ClkReset;
    wire [6:0] out7;
    wire [7:0] en_out;
    
    //module TopTopModule(Clk, Reset, out7, en_out);

    TopTopModule u0(.Clk(Clk), .Reset(Reset), .ClkReset(ClkReset), .out7(out7), .en_out(en_out));
    
    initial begin
      Clk <= 1'b0;
      forever #10 Clk <= ~Clk;
    end
    
        initial begin
           
           Reset <= 1;
           
            @(posedge Clk);
     
            Reset <= 0;
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            
        end    

   
endmodule
