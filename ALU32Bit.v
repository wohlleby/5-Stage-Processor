`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: 4-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU behaviorally, so that it supports addition,  subtraction,
// AND, OR, and set on less than (SLT). The 'ALUResult' will output the 
// corresponding result of the operation based on the 32-Bit inputs, 'A', and 
// 'B'. The 'Zero' flag is high when 'ALUResult' is '0'. The 'ALUControl' signal 
// should determine the function of the ALU based on the table below:-
// Op   | 'ALUControl' value
// ==========================
// ADD  | 0010
// SUB  | 0110
// AND  | 0000
// OR   | 0001
// SLT  | 0111
//
// NOTE:-
// SLT (i.e., set on less than): ALUResult is '32'h000000001' if A < B.
// 
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit(ALUControl, A, B, ALUResult, ALU64Result, nowrite, flag21, flag16, flag9, flag6, branch);

	input [5:0] ALUControl; // control bits for ALU operation
	input [31:0] A, B;	    // inputs
	input flag21, flag16, flag6, flag9; //flags for instruction[21] and instruction[6]
    reg [63:0] temp;
    reg [31:0] smallTemp;

    output reg [31:0] ALUResult;	// answer
    (*dont_touch = "true"*) output reg [63:0] ALU64Result;
	
	output reg nowrite, branch;	    // Zero=1 if ALUResult == 0

always@(ALUControl, A, B, flag21, flag16, flag6, flag9) begin
    
    nowrite = 0;
    ALUResult = 0;
    ALU64Result = 0;
    temp = 0;
    branch = 0;
    
    case(ALUControl)
    
        6'b000001: ALUResult <= $signed(A) + $signed(B);//ADD
        6'b000011: ALUResult <= $signed(A) - $signed(B);//SUB
        6'b000101: ALUResult <= A & B; //AND
        6'b000111: ALUResult <= A | B; //OR
        6'b001001: ALUResult <= ~(A | B); //NOR
        6'b001011: ALUResult <= A ^ B; //XOR
        6'b001101: begin //SLT   
            if($signed(A) < $signed(B)) 
                 ALUResult <= 1;
            else
                 ALUResult <= 0;
            end
        6'b001111: begin
        ALU64Result <= $signed(A) * $signed(B); //MULT
        ALUResult <= $signed(A) * $signed(B);
        end
        6'b010001: begin
            ALU64Result <= A * B; //MULTU
            ALUResult <= A * B;
        end
        6'b010011: begin//MOVN
            if(B != 0)
                ALUResult <= A;
            else
                nowrite <= 1;
            end
        6'b010101: begin//MOVZ
            if(B == 0) 
                ALUResult <= A;
            else
                nowrite <= 1;
            end
        6'b010111: ALUResult <= B << A; //SLLV
        6'b011001: begin //SRL
            if(flag21 == 0) 
                ALUResult <= B >> A;
            else begin  //ROTR
                temp = {B,B};
                smallTemp = {26'b0, A[4:0]};
                temp = temp >> smallTemp;
                ALUResult <= temp[31:0];
            end
        end 
        6'b011011: begin
            if(flag6 == 0)
                ALUResult <= B >> A; //SRLV
            else begin
                temp = {B,B}; //ROTRV
                temp = temp >> A;
                ALUResult <= temp[31:0];
            end
        end
        6'b011101: begin //SRA
            if(B[31] == 1)
                temp = {32'hffffffff, B};
            else
                temp = {32'h00000000, B};
            
            
            ALUResult <= temp[31:0] >> A;
        end
        
        6'b000010: begin //LUI
            temp <= {B, 32'h00000000};
            ALUResult <= temp[47:16];
        end
        6'b011111: begin
            if(flag9 == 1) begin //SEH
                if(B[15] == 0'b1) 
                    ALUResult <= {16'hffff,B[15:0]};
                else
                    ALUResult <= {16'h0000,B[15:0]};
                end
            else begin //SEB
                if(B[8] == 0'b1)
                    ALUResult <= {24'hffffff,B[7:0]};
                else
                    ALUResult <= {24'h000000,B[7:0]};
                end
        end
        6'b100001: begin //SLTU
            if(A < B)
                ALUResult <= 1;
            else
                ALUResult <= 0;
        end
        6'b100011: ALUResult <= A + B; //ADDU
        
        /*else if (OP == 6'b000001)//bgez  
                ALUcontrol <= 6'b110000; //great than equal to 0, dependant on 16 flag
            else if (OP == 6'b000100) // beq
                ALUcontrol <= 6'b110001; //equal
            else if (OP == 6'b000101) //bne
                ALUcontrol <= 6'b110010; //not equal  
            else if (OP == 6'b000111)     //bgtz   
                ALUcontrol <= 6'b110011;  //greater than 0
            else if (OP == 6'b000110) // blez
                ALUcontrol <= 6'b110100; //less than or equal to 0
            else if (OP == 6'b000001) // bltz
                ALUcontrol <= 6'b110000; //less than 0, dependant on 16 flag
                */
                
        6'b110000: begin //BGEZ, BLTZ
            if(flag16 == 0) begin //BLTZ
                if($signed(A) < 0) 
                    branch <= 1;
                else
                    branch <= 0;
            end
            else begin //BGEZ
                if($signed(A) >= 0)
                    branch <= 1;
                else
                    branch <= 0;
            end
        end
        
        6'b110001: begin //beq
            if($signed(A) == $signed(B))
                branch <= 1;
            else
                branch <= 0;
        end
        
        6'b110010: begin //bne 
            if($signed(A) != $signed(B))
                branch <= 1;
            else
                branch <= 0;
        end
        
        6'b110011: begin //bgtz
            if($signed(A) > 0) 
                branch <= 1;
            else
                branch <= 0;
        end
        
        6'b110100: begin //blez         
            if($signed(A) < 0 || $signed(A) == 0)
                branch <= 1;
            else
                branch <= 0;
        end
        
        6'b100111: begin //ori
        
            temp = A | B;
            ALUResult = {16'h0000, temp[15:0]};
        end
        
        6'b111011: begin //andi
        
            temp = A & B;
            ALUResult = {16'h0000, temp[15:0]};
        end        
        
        6'b111010: begin //xori
        
            temp = A ^ B;
            ALUResult = {16'h0000, temp[15:0]};
        end      
        
        6'b111000: ALU64Result <= {A, 32'h00000000}; //MTHI
        
        6'b111001: ALU64Result <= {32'h00000000, A}; //MTLO
          
                
        default:
            ALUResult <= 0;
    endcase
    
    
    
   /* if(ALUResult == 0)
        Zero = 1;
    else
        Zero = 0;
    */
    
end
endmodule
