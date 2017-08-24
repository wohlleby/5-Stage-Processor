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
    wire [31:0] WB_output, IF_PCounter, s1, s2, s3, s4;
    wire WB_IF_Stall, IF_Stall; //IF_Stall and WB_IF_Stall are the same stall, just one is
                                //seen when it exits the instruction fetch unit to help 
                                //visualize jumps and branches and the other is seen when 
                                //it exits the writeback stage so you can visualize stalls
                                //against the program counter
    
    //module TopModule(Clk, Reset, WB_output, IF_PCounter, WB_IF_Stall, IF_Stall);
    TopModule u0(.Clk(Clk), .Reset(Reset), .WB_output(WB_output), .IF_PCounter(IF_PCounter),
                 .WB_IF_Stall(WB_IF_Stall), .IF_Stall(IF_Stall), .s1(s1), .s2(s2), .s3(s3), .s4(s4));
    
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
