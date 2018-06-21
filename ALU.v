/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add
*		sub
*		or
*		and
*		nor
* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module ALU 
(
	input [3:0] ALUOperation,
	input [31:0] A,
	input [31:0] B,
	output reg Zero,
	output reg [31:0]ALUResult
);

localparam AND = 4'b0000;
localparam OR  = 4'b0001;
localparam NOR = 4'b0010;
localparam ADD = 4'b0011;
localparam SUB = 4'b0100;
localparam LUI = 4'b0101;
localparam SLL = 4'b0110;
   
   always @ (A or B or ALUOperation)
     begin
		case (ALUOperation)
		  ADD: // add
			ALUResult=A + B;
		  SUB: // sub
			ALUResult=A - B;
		  AND:
			ALUResult=A & B;
		  OR:
			ALUResult=A | B;
		  NOR:
			ALUResult= ~(A|B);
		  LUI:
		   begin
		   ALUResult[15:0] = 16'h0;
		   ALUResult[31:16] = B[15:0];
			end
		  SLL:
		   case (A)
				32'h00000000:
				 ALUResult = B;
				32'h00000001:
				 begin
				 ALUResult[31:1] = B[30:0];
				 ALUResult[0] = 0;
				 end
				32'h00000002:
				 begin
				 ALUResult[31:2] = B[29:0];
				 ALUResult[1:0] = 0;
				 end
				32'h00000003:
				 begin
				 ALUResult[31:3] = B[28:0];
				 ALUResult[2:0] = 0;
				 end
				32'h00000004:
				 begin
				 ALUResult[31:4] = B[27:0];
				 ALUResult[3:0] = 0;
				 end
				32'h00000005:
				 begin
				 ALUResult[31:5] = B[26:0];
				 ALUResult[4:0] = 0;
				 end
				32'h00000006:
				 begin
				 ALUResult[31:6] = B[25:0];
				 ALUResult[5:0] = 0;
				 end
				32'h00000007:
				 begin
				 ALUResult[31:7] = B[24:0];
				 ALUResult[6:0] = 0;
				 end
				32'h00000008:
				 begin
				 ALUResult[31:8] = B[23:0];
				 ALUResult[7:0] = 0;
				 end
				32'h00000009:
				 begin
				 ALUResult[31:9] = B[22:0];
				 ALUResult[8:0] = 0;
				 end
				32'h0000000a:
				 begin
				 ALUResult[31:10] = B[21:0];
				 ALUResult[9:0] = 0;
				 end
				32'h0000000b:
				 begin
				 ALUResult[31:11] = B[20:0];
				 ALUResult[10:0] = 0;
				 end
				32'h0000000c:
				 begin
				 ALUResult[31:12] = B[19:0];
				 ALUResult[11:0] = 0;
				 end
				32'h0000000d:
				 begin
				 ALUResult[31:13] = B[18:0];
				 ALUResult[12:0] = 0;
				 end
				32'h0000000e:
				 begin
				 ALUResult[31:14] = B[17:0];
				 ALUResult[13:0] = 0;
				 end
				32'h0000000f:
				 begin
				 ALUResult[31:15] = B[16:0];
				 ALUResult[14:0] = 0;
				 end
				32'h00000010:
				 begin
				 ALUResult[31:16] = B[15:0];
				 ALUResult[15:0] = 0;
				 end
				32'h00000011:
				 begin
				 ALUResult[31:17] = B[14:0];
				 ALUResult[16:0] = 0;
				 end
				32'h00000012:
				 begin
				 ALUResult[31:18] = B[13:0];
				 ALUResult[17:0] = 0;
				 end
				32'h00000013:
				 begin
				 ALUResult[31:19] = B[12:0];
				 ALUResult[18:0] = 0;
				 end
				32'h00000014:
				 begin
				 ALUResult[31:20] = B[11:0];
				 ALUResult[19:0] = 0;
				 end
				32'h00000015:
				 begin
				 ALUResult[31:21] = B[10:0];
				 ALUResult[20:0] = 0;
				 end
				32'h00000016:
				 begin
				 ALUResult[31:22] = B[9:0];
				 ALUResult[21:0] = 0;
				 end
				32'h00000017:
				 begin
				 ALUResult[31:23] = B[8:0];
				 ALUResult[22:0] = 0;
				 end
				32'h00000018:
				 begin
				 ALUResult[31:24] = B[7:0];
				 ALUResult[23:0] = 0;
				 end
				32'h00000019:
				 begin
				 ALUResult[31:25] = B[6:0];
				 ALUResult[24:0] = 0;
				 end
				32'h0000001a:
				 begin
				 ALUResult[31:26] = B[5:0];
				 ALUResult[25:0] = 0;
				 end
				32'h0000001b:
				 begin
				 ALUResult[31:27] = B[4:0];
				 ALUResult[26:0] = 0;
				 end
				32'h0000001c:
				 begin
				 ALUResult[31:28] = B[3:0];
				 ALUResult[27:0] = 0;
				 end
				32'h0000001d:
				 begin
				 ALUResult[31:29] = B[2:0];
				 ALUResult[28:0] = 0;
				 end
				32'h0000001e:
				 begin
				 ALUResult[31:30] = B[1:0];
				 ALUResult[29:0] = 0;
				 end
				32'h0000001f:
				begin
				 ALUResult[31] = B[0];
				 ALUResult[30:0] = 0;
				 end
			default:
				ALUResult = B;
			endcase
			
		default:
			ALUResult= 0;
		endcase // case(control)
		Zero = (ALUResult==0) ? 1'b1 : 1'b0;
     end // always @ (A or B or control)
endmodule // ALU