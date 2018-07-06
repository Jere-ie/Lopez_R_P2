/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	12/06/2016
******************************************************************/


module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 128
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign  PortOut = 0;

//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire BranchNE_wire;
wire BranchNE_wire_Pipe;
wire BranchNE_wire_Pipe2;
wire BranchEQ_wire;
wire BranchEQ_wire_Pipe;
wire BranchEQ_wire_Pipe2;
wire RegDst_wire;
wire RegDst_wire_Pipe;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire ALUSrc_wire_Pipe;
wire RegWrite_wire;
wire RegWrite_wire_Pipe;
wire RegWrite_wire_Pipe2;
wire Zero_wire;
wire Zero_wire_Pipe;
wire NOTZero_wire;
wire Shamt;
wire JumpReg_Selector;
wire JumpReg_Selector_Pipe;
wire MemtoReg_wire;
wire MemtoReg_wire_Pipe;
wire MemtoReg_wire_Pipe2;
wire MemWrite_wire;
wire MemWrite_wire_Pipe;
wire MemWrite_wire_Pipe2;
wire MemRead_wire;
wire MemRead_wire_Pipe;
wire MemRead_wire_Pipe2;
wire Jump;
wire Jump_Pipe;
wire Jump_Pipe2;
wire [2:0] ALUOp_wire;
wire [2:0] ALUOp_wire_Pipe;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [4:0] WriteRegister_wire_Pipe;
wire [31:0] MUX_PC_wire;
wire [31:0] ReadDataorALUResult_wire;
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] Instruction_wire_Pipe;
wire [31:0] Instruction_wire_Pipe2;
wire [31:0] Instruction_wire_Pipe3;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData1_wire_Pipe;
wire [31:0] ReadData2_wire;
wire [31:0] ReadData2_wire_Pipe;
wire [31:0] ReadData2_wire_Pipe2;
wire [31:0] ReadDataMem_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] InmmediateExtend_wire_Pipe;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] ALUResult_wire_Pipe;
wire [31:0] PC_4_wire;
wire [31:0] PC_4_wire_Pipe;
wire [31:0] PC_4_wire_Pipe2;
wire [31:0] PC_4_wire_ThirdStage;
wire [31:0] PC_4_wire_ThirdStage_Pipe;
//wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] New_PC_Branch;
wire [31:0] PCtoBranch_wire;
wire [31:0] PCtoBranch_wire_Pipe;
wire [31:0] Extended_shamt;
wire [31:0] Extended_shamt_Pipe;
wire [31:0] ReadData1OrExtended_shamt_wire;
wire [31:0] Shifted_InmmediateExtend_wire;
wire [31:0] JumpReg_wire;
wire [31:0] Jump_wire;
wire [31:0] JumpAddress;
wire [31:0] DataWriteBackOrPc_4;
wire [31:0] RdOr31_wire;
integer ALUStatus;

reg [64:0] FirstStage;


//******************************************************************/
//******************************************************************/
//******************************************************************/

assign Extended_shamt[4:0] = Instruction_wire[10:6];
assign Extended_shamt[31:5] = 0;

assign Shifted_InmmediateExtend_wire[31:2] = InmmediateExtend_wire[29:0];
assign Shifted_InmmediateExtend_wire[1:0] = 0;

assign ZeroANDBranchEQ = Zero_wire & BranchEQ_wire;

assign NOTZero_wire = ~Zero_wire;
assign NotZeroANDBrachNE = NOTZero_wire & BranchNE_wire;

assign ORForBranch = NotZeroANDBrachNE | ZeroANDBranchEQ;

assign Jump_wire[27:2] = Instruction_wire_Pipe3[25:0];
assign Jump_wire[31:28] = PC_4_wire[31:28];
assign Jump_wire[1:0] = 0;

assign PC_4_wire_ThirdStage = PC_4_wire;

Register_Pipeline
#(
	.N(64)
)
Pipeline_FirstStage
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.DataInput({Instruction_wire_Pipe,PC_4_wire_Pipe}),
	
	.DataOutput({Instruction_wire,PC_4_wire_Pipe2})
);

Register_Pipeline
#(
	.N(204)
)
Pipeline_SecondStage
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.DataInput({Instruction_wire,BranchNE_wire_Pipe,BranchEQ_wire_Pipe,MemRead_wire_Pipe,MemtoReg_wire_Pipe,
	MemWrite_wire_Pipe,ALUSrc_wire_Pipe,RegWrite_wire_Pipe,ReadData1_wire_Pipe,ReadData2_wire_Pipe,InmmediateExtend_wire_Pipe,ALUOp_wire_Pipe,
	Jump_Pipe,RegDst_wire_Pipe,Extended_shamt,PC_4_wire_Pipe2}),
	
	.DataOutput({Instruction_wire_Pipe2,BranchNE_wire_Pipe2,BranchEQ_wire_Pipe2,MemRead_wire_Pipe2,MemtoReg_wire_Pipe2,
	MemWrite_wire_Pipe2,ALUSrc_wire,RegWrite_wire,ReadData1_wire,ReadData2_wire,InmmediateExtend_wire,ALUOp_wire,Jump,RegDst_wire,Extended_shamt_Pipe,PC_4_wire})
);

Register_Pipeline
#(
	.N(201)
)
Pipeline_ThirdStage
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.DataInput({BranchEQ_wire_Pipe2,BranchNE_wire_Pipe2,WriteRegister_wire_Pipe,PC_4_wire_ThirdStage,PCtoBranch_wire_Pipe,MemRead_wire_Pipe2,MemtoReg_wire_Pipe2,
	MemWrite_wire_Pipe2,Zero_wire_Pipe,JumpReg_Selector_Pipe,ALUResult_wire_Pipe,ReadData2_wire,Instruction_wire_Pipe2,Jump,RegWrite_wire}),
	
	.DataOutput({BranchEQ_wire,BranchNE_wire,WriteRegister_wire,PC_4_wire_ThirdStage_Pipe,PCtoBranch_wire,MemRead_wire,MemtoReg_wire,
	MemWrite_wire,Zero_wire,JumpReg_Selector,ALUResult_wire,ReadData2_wire_Pipe2,Instruction_wire_Pipe3,Jump_Pipe2,RegWrite_wire_Pipe2})
);



//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(RegDst_wire_Pipe),
	.BranchNE(BranchNE_wire_Pipe),
	.BranchEQ(BranchEQ_wire_Pipe),
	.ALUOp(ALUOp_wire_Pipe),
	.ALUSrc(ALUSrc_wire_Pipe),
	.RegWrite(RegWrite_wire_Pipe),
	.MemWrite(MemWrite_wire_Pipe),
	.MemRead(MemRead_wire_Pipe),
	.MemtoReg(MemtoReg_wire_Pipe),
	.Jump(Jump_Pipe)
);

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(JumpAddress),
	.PCValue(PC_wire)
);



ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire_Pipe)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire_Pipe)
);

Adder32bits
PC_Plus_4_ShiftLeft
(
	.Data0(PC_4_wire),
	.Data1(Shifted_InmmediateExtend_wire),
	
	.Result(PCtoBranch_wire_Pipe)
);

//******************************************************************/
//******************************************************************/
//******************************************************************/

DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(512)
)
RAM
(
	.WriteData(ReadData2_wire_Pipe2),
	.Address(ALUResult_wire),
	.clk(clk),
	.ReadData(ReadDataMem_wire),
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire)
);

//******************************************************************/
//******************************************************************/
Multiplexer2to1
#(
	.NBits(32)
)
MUX_Memory_Read
(
	.Selector(MemtoReg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(ReadDataMem_wire),
	
	.MUX_Output(ReadDataorALUResult_wire)
);

Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire_Pipe2[20:16]),
	.MUX_Data1(RdOr31_wire),
	
	.MUX_Output(WriteRegister_wire_Pipe)

);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_WriteBack_PCvalue
(
	.Selector(Jump),
	.MUX_Data0(Instruction_wire_Pipe2[15:11]),
	.MUX_Data1(31),
	
	.MUX_Output(RdOr31_wire)
	
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_NewPC
(
	.Selector(ORForBranch),
	.MUX_Data0(PC_4_wire_Pipe),
	.MUX_Data1(PCtoBranch_wire),
	
	.MUX_Output(New_PC_Branch)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_JR
(
	.Selector(JumpReg_Selector),
	.MUX_Data0(New_PC_Branch),
	.MUX_Data1(ReadData1_wire),
	
	.MUX_Output(JumpReg_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_Shamt
(
	.Selector(Shamt),
	.MUX_Data0(ReadData1_wire),
	.MUX_Data1(Extended_shamt_Pipe),
	
	.MUX_Output(ReadData1OrExtended_shamt_wire)
	
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_Jump
(
	.Selector(Jump_Pipe2),
	.MUX_Data0(JumpReg_wire),
	.MUX_Data1(Jump_wire),
	
	.MUX_Output(JumpAddress)
	
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_JAL_31RegPick
(
	.Selector(Jump_Pipe2),
	.MUX_Data0(ReadDataorALUResult_wire),
	.MUX_Data1(PC_4_wire_ThirdStage_Pipe),
	
	.MUX_Output(DataWriteBackOrPc_4)
	
);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire_Pipe2),
	.WriteRegister(WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(DataWriteBackOrPc_4),
	.ReadData1(ReadData1_wire_Pipe),
	.ReadData2(ReadData2_wire_Pipe)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire_Pipe)
);



Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire_Pipe2[5:0]),
	.ALUOperation(ALUOperation_wire),
	.Shamt(Shamt),
	.JumpReg_Selector(JumpReg_Selector_Pipe)

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1OrExtended_shamt_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire_Pipe),
	.ALUResult(ALUResult_wire_Pipe)
);

assign ALUResultOut = ALUResult_wire;


endmodule

