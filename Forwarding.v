

module Forwarding
(
	input [4:0]Rs_direction,
	input [4:0]Rt_direction,
	input [4:0]RsOrRt_4thStage,
	input [4:0]RsOrRt_5thStage,

	output reg [1:0]Forward_A,
	output reg [1:0]Forward_B

);

localparam Enable1 = 2'b00;
localparam Enable2 = 2'b01;
localparam Enable3 = 2'b10;


   
  /* always @ (*)
     begin
		if (RsOrRt_4thStage == Rs_direction)
			begin
				Forward_A = Enable3;
			end
		else if (RsOrRt_4thStage != Rs_direction)
			begin
				if (RsOrRt_5thStage == Rs_direction)
				begin
					Forward_A = Enable2;
				end
				else
					Forward_A = Enable1;				
			end
		if (RsOrRt_4thStage == Rt_direction)
			begin
				Forward_B = Enable3;
			end
		else if (RsOrRt_4thStage != Rt_direction)
			begin
				if (RsOrRt_5thStage == Rt_direction)
				begin
					Forward_B = Enable2;
				end
				else
					Forward_B = Enable1;
			end
	  end*/
	  
	always @ (*)
	begin
		Forward_A = Enable1;
		Forward_B = Enable1;
		if(RsOrRt_4thStage == Rs_direction)
			Forward_A = Enable3;
		if(RsOrRt_4thStage == Rt_direction)
			Forward_B = Enable3;
		if(RsOrRt_5thStage == Rs_direction && RsOrRt_4thStage != Rs_direction)
			Forward_A = Enable2;
		if(RsOrRt_5thStage == Rt_direction && RsOrRt_4thStage != Rt_direction)
			Forward_B = Enable2;
		
	end
	  
endmodule