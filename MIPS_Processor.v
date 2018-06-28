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
wire BranchEQ_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire NOTZero_wire;
wire Shamt;
wire JumpReg_Selector;
wire MemtoReg_wire;
wire MemWrite_wire;
wire MemRead_wire;
wire Jump;
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [31:0] MUX_PC_wire;
wire [31:0] ReadDataorALUResult_wire;
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] ReadDataMem_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
//wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] New_PC_Branch;
wire [31:0] PCtoBranch_wire;
wire [31:0] Extended_shamt;
wire [31:0] ReadData1OrExtended_shamt_wire;
wire [31:0] Shifted_InmmediateExtend_wire;
wire [31:0] JumpReg_wire;
wire [31:0] Jump_wire;
wire [31:0] JumpAddress;
wire [31:0] DataWriteBackOrPc_4;
wire [31:0] RdOr31_wire;
integer ALUStatus;


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

assign Jump_wire[27:2] = Instruction_wire[25:0];
assign Jump_wire[31:28] = PC_4_wire[31:28];
assign Jump_wire[1:0] = 0;

//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire),
	.MemtoReg(MemtoReg_wire),
	.Jump(Jump)
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
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire)
);

Adder32bits
PC_Plus_4_ShiftLeft
(
	.Data0(PC_4_wire),
	.Data1(Shifted_InmmediateExtend_wire),
	
	.Result(PCtoBranch_wire)
);

//******************************************************************/
//******************************************************************/
//******************************************************************/

DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(1024)
)
RAM
(
	.WriteData(ReadData2_wire),
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
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(RdOr31_wire),
	
	.MUX_Output(WriteRegister_wire)

);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_WriteBack_PCvalue
(
	.Selector(Jump),
	.MUX_Data0(Instruction_wire[15:11]),
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
	.MUX_Data0(PC_4_wire),
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
	.MUX_Data1(Extended_shamt),
	
	.MUX_Output(ReadData1OrExtended_shamt_wire)
	
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_Jump
(
	.Selector(Jump),
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
	.Selector(Jump),
	.MUX_Data0(ReadDataorALUResult_wire),
	.MUX_Data1(PC_4_wire),
	
	.MUX_Output(DataWriteBackOrPc_4)
	
);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(DataWriteBackOrPc_4),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
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
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire),
	.Shamt(Shamt),
	.JumpReg_Selector(JumpReg_Selector)

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1OrExtended_shamt_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire)
);

assign ALUResultOut = ALUResult_wire;


endmodule

