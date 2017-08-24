`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2016 04:40:14 AM
// Design Name: 
// Module Name: ALUcontroller
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
//0000 is add
//0001 is subtract
//0010 is multiply signed
//0011 is and
//0100 is or
//0101 is not or
//0110 is exlusive or
//0111 is sll
//1000 is srl
//1001 is slt



module ALUcontroller(OP, Func, ALUcontrol);

input [5:0] Func, OP;
output reg [5:0] ALUcontrol;

always@(Func or OP) begin
 ALUcontrol =0;
 
 if(OP == 6'b000000)
    case(Func)
    
    //ALUcontrol change
    
    /*
    6'b010010 : ALUcontrol <= 6'b100010; //mflo
    6'b010000 : ALUcontrol <= 6'b101010;//mfhi
    6'b010001 : ALUcontrol <= 6'b110110; // mthi
    6'b010011 : ALUcontrol <= 6'b111110;//mtlo
    */
    
    //ALUcontrol change
    
    6'b100000 : ALUcontrol <= 6'b000001; //add
    6'b100001 : ALUcontrol <= 6'b100011; //addu 
    6'b100010 : ALUcontrol <= 6'b000011; //sub
    6'b100100 : ALUcontrol <= 6'b000101; //and
    6'b100101 : ALUcontrol <= 6'b000111; //or
    6'b100111 : ALUcontrol <= 6'b001001; //nor
    6'b100110 : ALUcontrol <= 6'b001011; //xor
    6'b101010 : ALUcontrol <= 6'b001101; //slt
    6'b011000 : ALUcontrol <= 6'b001111; //mult
    6'b001011 : ALUcontrol <= 6'b010011;//movn
    6'b001010 : ALUcontrol <= 6'b010101;//movz
    6'b000100 : ALUcontrol <= 6'b010111;//sllv  
    6'b000010 : ALUcontrol <= 6'b011001; // srl & rotr
    6'b000110 : ALUcontrol <= 6'b011011; //srlv & rotrv
    6'b000011 : ALUcontrol <= 6'b011101; //sra
    6'b000000 : ALUcontrol <= 6'b010111; //sll
    6'b000111 : ALUcontrol <= 6'b011101; // srav
    6'b101011 : ALUcontrol <= 6'b100001; //sltu
    6'b011001 : ALUcontrol <= 6'b010001; //MULTU
    6'b010001 : ALUcontrol <= 6'b111000; //MTHI
    6'b010011 : ALUcontrol <= 6'b111001; //MTLO
    
    endcase
  // change ALUcontrol signals  
  
   else if (OP == 6'b100011 |OP == 6'b101011)   //lw & sw (give it addi)
        ALUcontrol <= 6'b000001; //add in ALU
    
    else if (OP == 6'b101000) //sb   
        ALUcontrol <= 6'b000001; //add in ALU
      
    else if (OP == 6'b100001)//lh
        ALUcontrol <= 6'b000001;//add in alu
        
    else if (OP == 6'b100000) //lb
        ALUcontrol <= 6'b000001;
        
    else if (OP == 6'b101001)//sh
        ALUcontrol <= 6'b000001;
        
    else if (OP == 6'b001111)//lui   
        ALUcontrol <= 6'b000010;
  
    else if (OP == 6'b000001)//bgez, bltz  
        ALUcontrol <= 6'b110000; //great than equal to 0, less than 0 dependant on 16 flag
    else if (OP == 6'b000100) // beq
        ALUcontrol <= 6'b110001; //equal
    else if (OP == 6'b000101) //bne
        ALUcontrol <= 6'b110010; //not equal  
    else if (OP == 6'b000111)     //bgtz   
        ALUcontrol <= 6'b110011;  //greater than 0
    else if (OP == 6'b000110) // blez
        ALUcontrol <= 6'b110100; //less than or equal to 0
        
    //jal & j & jr   
              
       
    else if (OP == 6'b001000) //addi
        ALUcontrol <= 6'b000001;
                      
    else if (OP == 6'b001001) //addiu
        ALUcontrol <= 6'b100011;
                             
     else if (OP == 6'b001101) //ori
        ALUcontrol <=  6'b100111;      
        
     else if (OP == 6'b001110) //xori
         ALUcontrol <=  6'b111010;
         
     else if (OP == 6'b001010) // slti
         ALUcontrol <=  6'b001101;  
         
      else if (OP == 6'b001011) //sltiu
        ALUcontrol <= 6'b100001;    
         
     else if (OP == 6'b001100) //andi
         ALUcontrol <=  6'b111011;     
         
     else if (OP ==  6'b011111) // seh or seb
         ALUcontrol <=  6'b011111; 
         
     else if (OP ==  6'b011100) begin
     
        if(Func == 6'b000000||(Func == 6'b000100||Func == 6'b000010)) //madd or msub or mul
            ALUcontrol <= 6'b001111;
     end 
            
end

endmodule