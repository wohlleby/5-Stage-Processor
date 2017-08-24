`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2016 08:30:52 AM
// Design Name: 
// Module Name: TopModule_tb
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


module TopModule_tb( );

    reg Clk, Reset;
    wire [31:0] WB_output, IF_PCounter, v0, v1;
    wire WB_stall;              
    
    //module TopModule(Clk, Reset, WB_output, IF_PCounter, WB_IF_Stall, IF_Stall);
    TopModule u0(.Clk(Clk), .Reset(Reset), .WB_output(WB_output), .IF_PCounter(IF_PCounter),
                 .WB_stall(WB_stall), .v0(v0), .v1(v1));
    
    initial begin
       Clk <= 1'b0;
      forever #10 Clk <= ~Clk;
    end
    
    initial begin
       
       Reset <= 1;
       
        #12
 
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
