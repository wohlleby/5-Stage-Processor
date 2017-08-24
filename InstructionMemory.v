`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Laboratory  1
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:-
// Address: 32-Bit address input port.f
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
// FUNCTIONALITY:-
// Similar to the DataMemory, this module should also be byte-addressed
// (i.e., ignore bits 0 and 1 of 'Address'). All of the instructions will be 
// hard-coded into the instruction memory, so there is no need to write to the 
// InstructionMemory.  The contents of the InstructionMemory is the machine 
// language program to be run on your MIPS processor.
//
//
//we will store the machine code for a code written in C later. for now initialize 
//each entry to be its index * 4 (memory[i] = i * 4;)
//all you need to do is give an address as input and read the contents of the 
//address on your output port. 
// 
//Using a 32bit address you will index into the memory, output the contents of that specific 
//address. for data memory we are using 1K word of storage space. for the instruction memory 
//you may assume smaller size for practical purpose. you can use 128 words as the size and 
//hardcode the values.  in this case you need 7 bits to index into the memory. 
//
//be careful with the least two significant bits of the 32bit address. those help us index 
//into one of the 4 bytes in a word. therefore you will need to use bit [8-2] of the input address. 


///////////////////////z/////////////////////////////////////////////////////////

module InstructionMemory(Address, Instruction); 

    input [31:0] Address;        // Input Address 

    output wire [31:0] Instruction;
    
    /* Please fill in the implementation here */
    reg [31:0] memory[0:127];
    
    integer i = 0;
    
    initial begin
    
        
        //$readmemh("output.txt", memory);
        memory[0] = 32'h23bdfffc;	//	main:		addi	$sp, $sp, -4
        memory[1] = 32'hafbf0000;    //            sw    $ra, 0($sp)
        memory[2] = 32'h34040000;    //            ori    $a0, $zero, 0
        memory[3] = 32'h34050010;    //            ori    $a1, $zero, 16
        memory[4] = 32'h34060050;    //            ori    $a2, $zero, 80
        memory[5] = 32'h0c000007;    //            jal    vbsme
        memory[6] = 32'h08000006;    //    end:        j    end
        memory[7] = 32'h20020000;    //    vbsme:        addi    $v0, $0, 0
        memory[8] = 32'h20030000;    //            addi    $v1, $0, 0
        memory[9] = 32'h20110000;    //            addi    $s1, $0, 0
        memory[10] = 32'h20120000;    //            addi    $s2, $0, 0
        memory[11] = 32'h23f00000;    //            addi    $s0, $ra, 0
        memory[12] = 32'h8c8c0008;    //            lw    $t4, 8($a0)
        memory[13] = 32'h8c8d000c;    //            lw    $t5, 12($a0)
        memory[14] = 32'h00054020;    //            add    $t0, $0, $a1
        memory[15] = 32'h201701f4;    //            addi    $s7, $0, 500
        memory[16] = 32'h8c890000;    //            lw    $t1, 0($a0)
        memory[17] = 32'h8c930004;    //            lw    $s3, 4($a0)
        memory[18] = 32'h012c5022;    //            sub    $t2, $t1, $t4
        memory[19] = 32'h026d5822;    //            sub    $t3, $s3, $t5
        memory[20] = 32'h21adffff;    //            addi    $t5, $t5, -1
        memory[21] = 32'h218cffff;    //            addi    $t4, $t4, -1
        memory[22] = 32'h0005c020;    //            add    $t8, $0, $a1
        memory[23] = 32'h0006c820;    //            add    $t9, $0, $a2
        memory[24] = 32'h0c000047;    //            jal    window
        memory[25] = 32'h22310001;    //    go_right:    addi    $s1, $s1, 1
        memory[26] = 32'h23180004;    //            addi    $t8, $t8, 4
        memory[27] = 32'h21080004;    //            addi    $t0, $t0, 4
        memory[28] = 32'h0c000047;    //            jal    window
        memory[29] = 32'h162b0004;    //            bne    $s1, $t3, continue
        memory[30] = 32'h00009820;    //            add    $s3, $0, $0
        memory[31] = 32'h00009820;    //            add    $s3, $0, $0
        memory[32] = 32'h164a0001;    //            bne    $s2, $t2, continue
        memory[33] = 32'h08000068;    //            j    done
        memory[34] = 32'h00009820;    //    continue:    add    $s3, $0, $0
        memory[35] = 32'h00009820;    //            add    $s3, $0, $0
        memory[36] = 32'h124a0015;    //            beq    $s2, $t2, up_right
        memory[37] = 32'h22520001;    //    down_left:    addi    $s2, $s2, 1
        memory[38] = 32'h2231ffff;    //            addi    $s1, $s1, -1
        memory[39] = 32'h00099820;    //            add    $s3, $0, $t1
        memory[40] = 32'h2273ffff;    //            addi    $s3, $s3, -1
        memory[41] = 32'h00139880;    //            sll    $s3, $s3, 2
        memory[42] = 32'h0313c020;    //            add    $t8, $t8, $s3
        memory[43] = 32'h01134020;    //            add    $t0, $t0, $s3
        memory[44] = 32'h0c000047;    //            jal    window
        memory[45] = 32'h124affed;    //            beq    $s2, $t2, go_right
        memory[46] = 32'h00009820;    //            add    $s3, $0, $0
        memory[47] = 32'h00009820;    //            add    $s3, $0, $0
        memory[48] = 32'h12200001;    //            beq    $s1, $0, go_down
        memory[49] = 32'h08000025;    //            j    down_left
        memory[50] = 32'h22520001;    //    go_down:    addi    $s2, $s2, 1
        memory[51] = 32'h00099820;    //            add    $s3, $0, $t1
        memory[52] = 32'h00139880;    //            sll    $s3, $s3, 2
        memory[53] = 32'h0313c020;    //            add    $t8, $t8, $s3
        memory[54] = 32'h01134020;    //            add    $t0, $t0, $s3
        memory[55] = 32'h0c000047;    //            jal    window
        memory[56] = 32'h12200001;    //            beq    $s1, $0, up_right
        memory[57] = 32'h08000025;    //            j    down_left
        memory[58] = 32'h2231ffff;    //    up_right:    addi    $s1, $s1, -1
        memory[59] = 32'h22520001;    //            addi    $s2, $s2, 1
        memory[60] = 32'h00099820;    //            add    $s3, $0, $t1
        memory[61] = 32'h2273ffff;    //            addi    $s3, $s3, -1
        memory[62] = 32'h00139880;    //            sll    $s3, $s3, 2
        memory[63] = 32'h0313c022;    //            sub    $t8, $t8, $s3
        memory[64] = 32'h01134022;    //            sub    $t0, $t0, $s3
        memory[65] = 32'h0c000047;    //            jal    window
        memory[66] = 32'h122bfff1;    //            beq    $s1, $t3, go_down
        memory[67] = 32'h00009820;    //            add    $s3, $0, $0
        memory[68] = 32'h00009820;    //            add    $s3, $0, $0
        memory[69] = 32'h1240ffd5;    //            beq    $s2, $0, go_right
        memory[70] = 32'h0800003a;    //            j    up_right
        memory[71] = 32'h8f130000;    //    window:        lw    $s3, 0($t8)
        memory[72] = 32'h8f340000;    //            lw    $s4, 0($t9)
        memory[73] = 32'h02749822;    //            sub    $s3, $s3, $s4
        memory[74] = 32'h06610001;    //            bgez  $s3, positive
        memory[75] = 32'h00139822;    //            sub    $s3, $0, $s3
        memory[76] = 32'h02d3b020;    //    positive:    add    $s6, $s6, $s3
        memory[77] = 32'h11ed0004;    //            beq    $t7, $t5, end_column
        memory[78] = 32'h21ef0001;    //            addi    $t7, $t7, 1
        memory[79] = 32'h23180004;    //            addi    $t8, $t8, 4
        memory[80] = 32'h23390004;    //            addi    $t9, $t9, 4
        memory[81] = 32'h08000047;    //            j    window
        memory[82] = 32'h11cc0007;    //    end_column:    beq    $t6, $t4, end_window
        memory[83] = 32'h00007820;    //            add    $t7, $0, $0
        memory[84] = 32'h21ce0001;    //            addi    $t6, $t6, 1
        memory[85] = 32'h012d9822;    //            sub    $s3, $t1, $t5
        memory[86] = 32'h00139880;    //            sll    $s3, $s3, 2
        memory[87] = 32'h0313c020;    //            add    $t8, $t8, $s3
        memory[88] = 32'h23390004;    //            addi    $t9, $t9, 4
        memory[89] = 32'h08000047;    //            j    window
        memory[90] = 32'h0008c020;    //    end_window:    add    $t8, $0, $t0
        memory[91] = 32'h0006c820;    //            add    $t9, $0, $a2
        memory[92] = 32'h00007020;    //            add    $t6, $0, $0
        memory[93] = 32'h00007820;    //            add    $t7, $0, $0
        memory[94] = 32'h02f69822;    //            sub    $s3, $s7, $s6
        memory[95] = 32'h06610003;    //            bgez    $s3, replace
        memory[96] = 32'h0000b020;    //            add    $s6, $0, $0
        memory[97] = 32'h00009820;    //            add    $s3, $0, $0
        memory[98] = 32'h03e00008;    //            jr    $ra
        memory[99] = 32'h0016b820;    //    replace:    add    $s7, $0, $s6
        memory[100] = 32'h00121020;    //            add    $v0, $0, $s2
        memory[101] = 32'h00111820;    //            add    $v1, $0, $s1
        memory[102] = 32'h0000b020;    //            add    $s6, $0, $0
        memory[103] = 32'h03e00008;    //            jr    $ra
        memory[104] = 32'h0200f820;    //    done:        add    $ra, $s0, $0
        memory[105] = 32'h03e00008;    //            jr    $ra







        
    end
    
    assign Instruction = memory[Address[31:0]];    

endmodule