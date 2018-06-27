/******************************************************************
* Description
*	This is the control unit for the ALU. It receves an signal called 
*	ALUOp from the control unit and a signal called ALUFunction from
*	the intrctuion field named function.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module ALUControl
(
	input [2:0] ALUOp,
	input [5:0] ALUFunction,
	output [3:0] ALUOperation,
	output Shamt

);

localparam R_Type_AND    = 9'b111_100100;
localparam R_Type_OR     = 9'b111_100101;
localparam R_Type_NOR    = 9'b111_100111;
localparam R_Type_ADD    = 9'b111_100000;
localparam R_Type_SLL	 = 9'b111_000000;
localparam R_Type_SUB	 = 9'b111_100010;
localparam R_Type_SRL	 = 9'b111_000010;
localparam I_Type_ADDI   = 9'b100_xxxxxx;
localparam I_Type_ORI    = 9'b101_xxxxxx;
localparam I_Type_LUI	 = 9'b110_xxxxxx;
localparam I_Type_Branch = 9'b001_xxxxxx;
localparam I_Type_ANDI   = 9'b010_xxxxxx;

reg [4:0] ALUControlValues;
wire [8:0] Selector;

assign Selector = {ALUOp, ALUFunction};

always@(Selector)begin
	casex(Selector)
		R_Type_AND:    ALUControlValues = 5'b0_0000;
		R_Type_OR: 		ALUControlValues = 5'b0_0001;
		R_Type_NOR: 	ALUControlValues = 5'b0_0010;
		R_Type_ADD:		ALUControlValues = 5'b0_0011;
		R_Type_SLL:		ALUControlValues = 5'b1_0110;
		R_Type_SUB:		ALUControlValues = 5'b0_0100;
		R_Type_SRL:		ALUControlValues = 5'b1_0111;
		I_Type_ADDI:	ALUControlValues = 5'b0_0011;
		I_Type_ORI:		ALUControlValues = 5'b0_0001;
		I_Type_LUI:		ALUControlValues = 5'b0_0101;
		I_Type_Branch:	ALUControlValues = 5'b0_0100;
		I_Type_ANDI:	ALUControlValues = 5'b0_0000;
		default: ALUControlValues = 5'b0_1001;
	endcase
end


assign ALUOperation = ALUControlValues[3:0];
assign Shamt = ALUControlValues[4];

endmodule