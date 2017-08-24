`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2016 07:32:17 PM
// Design Name: 
// Module Name: Control
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

/*    Control Control_1(ID_instruction[31:26], ID_instruction[5:0], ID_RegDst, ID_Shift, ID_ALUSrc, ID_RegWrite,
                      ID_hilo, ID_hi, ID_lo, ID_hilowrite, jump, jumpRA, jumpRegister, writeRA, ID_MemRead, ID_MemWrite, IF_ID_Flush, ID_EX_Flush, EX_Flush); */

module Control(Op, Func, RegDst, Shift, ALUSrc, RegWrite, hilo, hi, lo , hiloWrite, jumpRA, jumpRegister, MemRead, MemWrite,
               IF_ID_Flush, ID_EX_Flush, EX_Flush);

input [5:0] Op, Func;
output reg [1:0] hi, lo;
output reg RegDst, Shift, ALUSrc, RegWrite, hilo, MemRead, MemWrite;
output reg hiloWrite, jumpRA, jumpRegister, IF_ID_Flush, ID_EX_Flush, EX_Flush; 


    initial begin
    
        IF_ID_Flush = 0;
        ID_EX_Flush = 0;
        EX_Flush = 0;
    end      

 
always@(Op or Func) begin
RegDst <= 0;
Shift <= 0;
ALUSrc <= 0;
RegWrite <= 0;
hilo <= 0;
hiloWrite <= 0;
jumpRegister  <= 0;
jumpRA <= 0;
MemRead <= 0;
MemWrite <= 0;
IF_ID_Flush <= 0;
ID_EX_Flush <= 0;
EX_Flush <= 0;
hi <= 2'b11;
lo <= 2'b11; //set hi lo to maintain by default
    
 
    case (Op)
    
    //R-Type
    6'b000000:
        begin
        if (Func == 6'b000000 || Func == 6'b000010) begin //SLL and ROTR, ROTR uses 21 flag
            RegWrite <= 1;
            Shift <= 1;
            RegDst <= 1;
        end
        
        else if (Func == 6'b000011) begin //SRA
            RegWrite <= 1;
            Shift <= 1;
            RegDst <= 1;
        end
        else begin
            Shift <= 0;
            RegDst <= 1;
            ALUSrc <= 0;
            RegWrite <= 1;
            hiloWrite <= 0;
            //ALUOp = 6'b000000;
        end
        
        if(Func == 6'b010001) begin //mthi
            RegWrite <= 0;
            hi <= 0;
        end
        if(Func == 6'b010011) begin //mtlo
            RegWrite <= 0; 
            lo <= 0;
        end
        
        if(Func == 6'b010000) begin //MFHI
            hilo <= 1; //set to hi out
            hiloWrite <= 1; //write from hilo
        end
        if(Func == 6'b010010) begin //MFLO
            hilo <= 0; //set to lo out
            hiloWrite <= 1; //write from hilo
        end
        if(Func == 6'b011000|Func == 6'b011001) begin //MULT & MULTU
            hi <= 0; //write to hi and lo
            lo <= 0;
            RegWrite <= 0; //don't write to reg
        end
        if(Func == 6'b001000) begin //JR
            RegWrite <= 0;
            jumpRegister <= 1;
        end
            
    end
    
    6'b100011: // lw
    begin
   // Shift = 1;
    ALUSrc <= 1 ;
    MemRead <= 1;
    RegWrite <= 1;
    end 
    
    //sw
    6'b101011: 
    begin
    MemWrite <= 1;
   // Shift = 1;
    ALUSrc <= 1;
    end
    
     // sb
    6'b101000:
    begin
    //Shift = 1;
    ALUSrc <= 1;
    MemWrite <= 1;
    end
    
    //lh
    6'b100001: 
    begin
    //keep RegDst before reg file at zero 
    //Shift = 1;
    ALUSrc <= 1;
    MemRead <= 1;
    RegWrite <= 1;
    end
    
    //lb
    6'b100000:
    begin
   // Shift = 1;
    ALUSrc <= 1; 
    MemRead <= 1;
    RegWrite <= 1;
    end
    
    //sh
    6'b101001:
    begin
   // Shift = 1;
    ALUSrc <= 1;
    MemWrite <= 1; 
    end
    
    //lui
    6'b001111:
    begin
    //Shift = 1;
    ALUSrc <= 1;
    //MemRead = 1;
    RegWrite <= 1;
    end
    
    //addi
    6'b001000:
    begin
        Shift <= 0;
        RegDst <= 0;
        ALUSrc <= 1;
        RegWrite <= 1;
        //ALUOp = 6'b000001;
    end
    
    //addiu
    6'b001001:    
    begin
        Shift <= 0;
        RegDst <= 0;
        ALUSrc <= 1;
        RegWrite <= 1;
        //ALUOp = 6'b000010;
    end
    
    //MADD, MSUB, MUL
    6'b011100:
    begin
        Shift <= 0;
        RegDst <= 1;
        ALUSrc <= 0;
        //ALUOp = 6'b010000;
        
        if(Func == 6'b000010) //write to reg for mul
            RegWrite <= 1;
        else begin
            RegWrite <= 0;
            if(Func == 6'b000100) begin //msub to hi, lo
                hi <= 2'b10;
                lo <= 2'b10;
            end
            else if(Func == 6'b000000) begin //madd to hi, lo
                hi <= 2'b01;
                lo <= 2'b01;
            end
        end
    end
    
    //ori
    6'b001101:
    begin
        Shift <= 0;
        RegDst <= 0;
        ALUSrc <= 1;
        RegWrite <= 1;
        //ALUOp = 6'b000110;
    end
    
    
    //xori
    6'b001110:
    begin
        Shift <= 0;
        RegDst <= 0;
        ALUSrc <= 1;
        RegWrite <= 1;
        //ALUOp = 6'b100000;
    end
    
    //andi
    6'b001100:
    begin
        Shift <= 0;
        RegDst <= 0;
        ALUSrc <= 1;
        RegWrite <=1 ;
        //ALUOp = 6'b100011;
    end
    
    
    //slti
    6'b001010:
    begin
        Shift <= 0;
        RegDst <= 0;
        ALUSrc <= 1;
        RegWrite <= 1;
        //ALUOp = 6'b100101;
    end
    
    
    //seh and seb
    6'b011111:
    begin
        Shift <= 1;
        RegDst <= 1;
        ALUSrc <= 0;
        RegWrite <= 1;
        //ALUOp = 6'b110000;
    end
    
    /*
    6'b000011: begin //JAL
        IF_ID_Flush <= 1;
        RegWrite <= 0;
        jump <= 1;
        writeRA <= 1;
    end*/
    
    endcase
end
endmodule