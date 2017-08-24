`timescale 1ns / 1ns



module ClkDiv(Clk, Rst, ClkOut);

	input Clk, Rst;
	output reg ClkOut;
	//to create 1 Hz clock from 100-MHz on the board
	parameter DivVal1 = 50000000;//00000000;//50_000_000;
	
	//reg [26:0] DivVal;
	reg [26:0] DivCnt;
	reg ClkInt;

	always @(posedge Clk) 
	begin
		if( Rst == 1 ) 
			begin
				DivCnt <= 0;
				ClkOut <= 0;
				ClkInt <= 0;
			end
		
		else
			begin
				if( DivCnt == DivVal1 )
					begin
						ClkOut <= ~ClkInt;
						ClkInt <= ~ClkInt;
						DivCnt <= 0;
					end
				else
					begin		
						ClkOut <= ClkInt;
						ClkInt <= ClkInt;
						DivCnt <= DivCnt + 1;
					end
			end
	end

endmodule
