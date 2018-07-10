

module Forwarding
(
	input [4:0]Rs_direction,
	input [4:0]Rt_direction,
	input [4:0]RsOrRt_4thStage,
	input [4:0]RsOrRt_5thStage,

	output [1:0]Forward_A,
	output [1:0]Forward_B

);

localparam 
   
   always @ (Rs_direction or Rt_direction or RsOrRt_4thStage or RsOrRt_5thStage or Forward_A or Forward_B)
     begin
		if (RsOrRt_4thStage == Rs_direction)
			begin
				Forward_A = 2'b10
				Forward_B = 2'b00
			end
		if (RsOrRt_4thStage == Rt_direction)
			begin
				Forward_A = 2'b00
				Forward_B = 2'b10
			end
		if (RsOrRt_5thStage == Rs_direction)
			begin
				Forward_A = 2'b01
				Forward_B = 2'b00
			end
		if (RsOrRt_5thStage == Rt_direction)
			begin
				Forward_A = 2'b00
				Forward_B = 2'b01
			end
	  end 