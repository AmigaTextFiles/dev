External;

{$I "Pascal.i"}

	Function GetLabel : Integer;
	    external;
	Function GetFramePointer(Ref : Integer) : Regs;
	    External;
	Function BaseType(b : TypePtr): TypePtr;
	    external;
	Function SimpleType(t : TypePtr) : Boolean;
	    external;
	Function NumberType(t : TypePtr) : Boolean;
	    External;
	Function TypeCheck(l, r : TypePtr) : Boolean;
	    External;
	Function ExpressionTree : ExprPtr;
	    External;
	Procedure Optimize(Expr : ExprPtr);
	    External;
	Procedure Error(msg : String);
	    External;
	Function GetReference : ExprPtr;
	    External;
	Function Match(s : Symbols) : Boolean;
	    External;
	Function PromoteTypeA(Expr : ExprPtr; TP : TypePtr) : ExprPtr;
	    External;
	Function MakeNode(s : Symbols; L, R : ExprPtr; TP : TypePtr;
				Val : Integer) : ExprPtr;
	    External;
	Procedure PopStackSpace(Amount : Integer);
 	    External;
	Procedure Out_Operation0(op : OpCodes);
	    External;
	Procedure Out_Operation1(op : OpCodes; Size : Byte;
					EA : EAModes; Reg : Regs);
	    External;
	Procedure Out_Operation2(op : OpCodes; Size : Byte;
					SrcEA : EAModes; SrcReg : Regs;
					DestEA : EAModes; DestReg : Regs);
	    External;
	Procedure Out_Extension(Ext : Integer);
	    External;



Function RegisterInUse(reg : Regs) : Boolean;
begin
    RegisterInUse := (UsedRegs and (1 shl Ord(reg))) <> 0;
end;

Procedure MarkRegister(reg : Regs);
begin
{    if not RegisterInUse(reg) then
        Writeln(OutFile, '*  ', RN[reg], ': used'); }
    UsedRegs := UsedRegs or (1 shl Ord(reg));
end;

Procedure UnmarkRegister(reg : Regs);
begin
{    if RegisterInUse(reg) then
        Writeln(OutFile, '*  ', RN[reg], ': free'); }
    UsedRegs := UsedRegs and (not (1 shl Ord(reg)));
end;

Procedure SaveRegisterToStack(reg : Regs);
begin
    Out_Operation1(op_PUSH,4,ea_Register,reg);
    StackLoad := StackLoad + 4;
    UnmarkRegister(reg);
end;

Procedure RestoreRegisterFromStack(reg : Regs);
begin
    Out_Operation1(op_POP,4,ea_Register,reg);
    StackLoad := StackLoad - 4;
    MarkRegister(reg);
end;

Procedure FreeAllRegisters;
begin
    UsedRegs := 0;
    NextDataRegister := d7;
    NextAddressRegister := a3;
end;

Procedure AllocateDataRegister(var reg : Regs; var Stacked : Boolean);
begin
    if NextDataRegister >= d2 then begin
	reg := NextDataRegister;
	Stacked := False;
	Dec(NextDataRegister);
    end else begin
	SaveRegisterToStack(d7);
	reg := d7;
	Stacked := True;
    end;
end;

Procedure DeallocateDataRegister(reg : Regs; Stacked : Boolean);
begin
    if Stacked then
	RestoreRegisterFromStack(reg)
    else begin
	UnmarkRegister(reg);
	Inc(NextDataRegister);
    end;
end;

Procedure AllocateAddressRegister(var reg : Regs; var Stacked : Boolean);
begin
    if NextAddressRegister >= a0 then begin
	reg := NextAddressRegister;
	Stacked := False;
	Dec(NextAddressRegister);
    end else begin
	SaveRegisterToStack(a3);
	reg := a3;
	Stacked := True;
    end;
end;


Procedure DeallocateAddressRegister(reg : Regs; Stacked : Boolean);
begin
    if Stacked then
	RestoreRegisterFromStack(reg)
    else begin
	UnmarkRegister(reg);
	Inc(NextAddressRegister);
    end;
end;

Function TemporaryData : Regs;
var
    reg : Regs;
begin
    if not RegisterInUse(d0) then
	TemporaryData := d0;
    if not RegisterInUse(d1) then
	TemporaryData := d1;
    for reg := d7 to d2 do begin
	if not RegisterInUse(reg) then
	    TemporaryData := reg;
    end;
    TemporaryData := a7;
end;

Function TemporaryAddress : Regs;
var
    reg : Regs;
begin
    for reg := a0 to a3 do begin
	if not RegisterInUse(reg) then
	    TemporaryAddress := reg;
    end;
    TemporaryAddress := a7;
end;


Procedure SaveAllRegisters;
var
    reg : Regs;
begin
    if (UsedRegs and $0FFF) <> 0 then begin
	Out_Operation2(op_MOVEM,4,ea_RegList,a7,ea_PreDec,a7);
	Out_Extension(UsedRegs and $0FFF);

	for reg := d0 to a3 do begin
	    if RegisterInUse(reg) then begin
		UnmarkRegister(reg);
		StackLoad := StackLoad + 4;
	    end;
	end;
    end;
end;


Procedure RestoreAllRegisters;
var
    reg : Regs;
begin
    if (UsedRegs and $0FFF) <> 0 then begin
	Out_Operation2(op_MOVEM,4,ea_PostInc,a7,ea_RegList,a7);
	Out_Extension(UsedRegs and $0FFF);

	for reg := d0 to a3 do begin
	    if RegisterInUse(reg) then
		StackLoad := StackLoad - 4;
	end;
    end;
end;


Procedure SaveScratchRegisters;

    Procedure DoReg(reg : Regs);
    begin
	if RegisterInUse(reg) then begin
	    StackLoad := StackLoad + 4;
	    UnmarkRegister(reg);
	end;
    end;

begin
    if (UsedRegs and $0303) <> 0 then begin
	Out_Operation2(op_MOVEM,4,ea_RegList,a7,ea_PreDec,a7);
	Out_Extension(UsedRegs and $0303);  { d0, d1, a0 and a1 }
	DoReg(d0);
	DoReg(d1);
	DoReg(a0);
	DoReg(a1);
    end;
end;


Procedure RestoreScratchRegisters;
var
    WroteAny : Boolean;

    Procedure DoReg(reg : Regs);
    begin
	if RegisterInUse(reg) then
	    StackLoad := StackLoad - 4;
    end;

begin
    if (UsedRegs and $0303) <> 0 then begin
	Out_Operation2(op_MOVEM,4,ea_PostInc,a7,ea_RegList,a7);
	Out_Extension(UsedRegs and $0303); { d0, d1, a0 and a1 }

	DoReg(d0);
	DoReg(d1);
	DoReg(a0);
	DoReg(a1);
    end;
end;


{
    This routine is used to add a constant value to any register.
    It does so in the most efficient way, to wit:

	Add  0 < x <= 8 to An	: addq.w #x,An
	Add word to An		: lea word(An),An
	Add  9 <= x <= 16 to An	: addq.w #8,An
				  addq.w #x-8,An

    Subtractions work the same way.  For data registers, A68k will
    handle optimizations, so they just work normally.
}

Procedure AddConstant(Amount : Integer; ToReg : Regs; Size : Byte);
begin
    if Amount = 0 then
	return;
    if ToReg >= a0 then begin
	case Amount of
	  1..8 :
	    begin
		Out_Operation2(op_ADDQ,2,ea_Constant,a7,ea_Register,ToReg);
		Out_Extension(Amount);
	    end;

	  -8..-1 :
	    begin
		Out_Operation2(op_SUBQ,2,ea_Constant,a7,ea_Register,ToReg);
		Out_Extension(-Amount);
	    end;
	  -32768..32767 :
	    begin
		Out_Operation2(op_LEA,3,ea_Index,ToReg,ea_Register,ToReg);
		Out_Extension(Amount);
	    end;
	else begin
		 if Amount > 0 then begin
		     Out_Operation2(op_ADDA,4,ea_Constant,a7,ea_Register,ToReg);
		     Out_Extension(Amount);
		 end else begin
		     Out_Operation2(op_SUBA,4,ea_Constant,a7,ea_Register,ToReg);
		     Out_Extension(-Amount);
		 end;
	     end;
	end;
    end else begin
	if Amount > 0 then begin
	    Out_Operation2(op_ADD,Size,ea_Constant,a7,ea_Register,ToReg);
	    Out_Extension(Amount);
	end else begin
	    Out_Operation2(op_SUB,Size,ea_Constant,a7,ea_Register,ToReg);
	    Out_Extension(-Amount);
	end;
    end;
end;

{
    If the expression Expr is a variable that can be referenced as one
    of the arguments of an assembly command, return true.  Return false
    if the expression requires calculations.

    Global variables, typed constants, local variables, and value
    parameters return true if they are simple types (i.e. can be held
    in a register).  Reference parameters, sub-expressions, arrays, etc.
    all return false.  Field references return true if the record reference
    is a simple reference.
}

Function SimpleReference(Expr : ExprPtr) : Boolean;
var
    ID : IDPtr;
begin
    if not SimpleType(Expr^.EType) then
	SimpleReference := False;	{ Requires a memory reference }

    if Expr^.Kind = Var1 then begin
	ID := IDPtr(Expr^.Value);
	case ID^.Object of
	  global,
	  typed_const : SimpleReference := True;
	  local,
	  valarg : SimpleReference := (ID^.Level = CurrentBlock^.Level) or
					(ID^.Level <= 1);
	else
	    SimpleReference := False;
	end;
    end;

    if Expr^.Kind = period1 then
        if Expr^.Left^.Kind = var1 then
            SimpleReference := SimpleReference(Expr^.Left);

    SimpleReference := False;
end;


{
    Given that the expression satifies "SimpleReference" above,
    write the actual value reference.
}

Procedure GetSimpleReference(var EA : EAModes; var Reg : Regs;
				var Ext1, Ext2 : Integer; Expr : ExprPtr);
var
    ID : IDPtr;
    WasField : Boolean;
begin
    if Expr^.Kind = period1 then begin
	WasField := True;
	Ext2 := Expr^.Value;
	Expr := Expr^.Left;
    end else begin
	WasField := False;
	Ext2 := 0;
    end;

    Reg := a7;
    ID := IDPtr(Expr^.Value);
    case ID^.Object of
      typed_const,
      global  : begin
		    if WasField then
			EA := ea_Offset
		    else
		        EA := ea_Global;
		    Ext1 := Integer(ID);
		end;
      valarg,
      local   : begin
		    EA := ea_Index;
		    Ext1 := ID^.Offset + Ext2;
		    Reg := a5;
		end;
    end;
end;

Procedure WriteSimpleSource(Expr : ExprPtr; op : OpCodes; Size : Byte;
				DestEA : EAModes; DestReg : Regs);
var
    SrcEA  : EAModes;
    SrcReg : Regs;
    Ext1,
    Ext2   : Integer;
begin
    GetSimpleReference(SrcEA, SrcReg, Ext1, Ext2, Expr);
    Out_Operation2(op, Size, SrcEA, SrcReg, DestEA, DestReg);
    Out_Extension(Ext1);
    if SrcEA = ea_Offset then
	Out_Extension(Ext2);
end;

Procedure WriteSimpleDest(Expr : ExprPtr; op : OpCodes; Size : Byte;
				SrcEA : EAModes; SrcReg : Regs;
				SExt1, SExt2 : Integer);
var
    DestEA  : EAModes;
    DestReg : Regs;
    Ext1,
    Ext2    : Integer;
begin
    GetSimpleReference(DestEA, DestReg, Ext1, Ext2, Expr);
    Out_Operation2(op, Size, SrcEA, SrcReg, DestEA, DestReg);
    if Extensions[SrcEA] >= 1 then begin
	Out_Extension(SExt1);
	if Extensions[SrcEA] >= 2 then
	    Out_Extension(SExt2);
    end;
    Out_Extension(Ext1);
    if DestEA = ea_Offset then
	Out_Extension(Ext2);
end;

Procedure WriteSimpleSingle(Expr : ExprPtr; op : OpCodes; Size : Byte);
var
    EA : EAModes;
    Reg : Regs;
    Ext1,
    Ext2 : Integer;
begin
    GetSimpleReference(EA, Reg, Ext1, Ext2, Expr);
    Out_Operation1(op, Size, EA, Reg);
    Out_Extension(Ext1);
    if EA = ea_Offset then
	Out_Extension(Ext2);
end;


Procedure Evaluate(Expr : ExprPtr; ToReg : Regs);
    forward;

Procedure EvalAddress(Expr : ExprPtr; ToReg : Regs);
    forward;



Procedure ConstantShiftLeft(Shifts : Byte; ToReg : Regs; Size : Byte);
begin
    Shifts := Shifts and 31;
    while Shifts > 0 do begin
	case Shifts of
	  1 :	begin
		    Out_Operation2(op_ADD,Size,ea_Register,ToReg,
						ea_Register,ToReg);
		    Shifts := 0;
		end;
	  2..7 :
		begin
		    Out_Operation2(op_LSL,Size,ea_Constant,a7,ea_Register,ToReg);
		    Out_Extension(Shifts);
		    Shifts := 0;
		end;
	  8..15 :
		if Size = 1 then
		    Shifts := 0
		else begin
		    Out_Operation2(op_LSL,Size,ea_Constant,a7,ea_Register,ToReg);
		    Out_Extension(8);
		    Shifts := Shifts - 8;
		end;
	  16..31 :
		if Size <> 4 then
		    Shifts := 0
		else begin
		    Out_Operation1(op_SWAP,3,ea_Register,ToReg);
		    Out_Operation1(op_CLR,2,ea_Register,ToReg);
		    Shifts := Shifts - 16;
		end;
	end;
    end;
end;


Procedure ConstantShiftRight(Op : OpCodes; Shifts : Byte;
                             ToReg : Regs; Size : Byte);
begin
    Shifts := Shifts and 31;
    while Shifts > 0 do begin
	case Shifts of
	  1..7 :
		begin
		    Out_Operation2(Op,Size,ea_Constant,a7,
						ea_Register,ToReg);
		    Out_Extension(Shifts);
		    Shifts := 0;
		end;
	  8..15 :
		if Size = 1 then
		    Shifts := 0
		else begin
		    Out_Operation2(Op,Size,ea_Constant,a7,
						ea_Register,ToReg);
		    Out_Extension(8);
		    Shifts := Shifts - 8;
		end;
	  16..31 :
		if Size <> 4 then
		    Shifts := 0
		else if Op = op_LSR then begin
		    Out_Operation1(op_CLR,2,ea_Register,ToReg);
		    Out_Operation1(op_SWAP,3,ea_Register,ToReg);
		    Shifts := Shifts - 16;
		end else begin
		    Out_Operation1(op_SWAP,3,ea_Register,ToReg);
		    Out_Operation1(op_EXT,4,ea_Register,ToReg);
		    Shifts := Shifts - 16;
		end;
	end;
    end;
end;


{
    Push each expression in the list onto the stack, then return
    the total size (in bytes) of the stack load.  This routine
    assumes that all the scratch registers are free.
}


Function PushArguments(Expr : ExprPtr; ToReg : Regs) : Integer;
var
    Argument : ExprPtr;
    Formal   : IDPtr;
    Total    : Integer;
    Stag     : Byte;
    lab,
    VarSize  : Integer;
begin
    Argument := Expr^.Left;
    Formal   := IDPtr(Expr^.Value);
    Formal   := Formal^.Param;
    Total    := 0;
    while (Argument <> Nil) and (Formal <> Nil) do begin
	VarSize := Formal^.VType^.Size;
	if Formal^.Object = valarg then begin
	    STag := VarSize;
	    if STag = 1 then
		STag := 2;
	    Total := Total + VarSize;
	    if SimpleType(Formal^.VType) then begin
		if Argument^.Kind = Const1 then begin
		    if STag = 4 then begin
			Out_Operation1(op_PEA,3,ea_Absolute,a7);
			Out_Extension(Argument^.Value);
		    end else begin
			Out_Operation1(op_PUSH,2,ea_Constant,a7);
			Out_Extension(Argument^.Value);
		    end;
		end else if SimpleReference(Argument) and
			    (Argument^.EType^.Size = STag) then begin
		    WriteSimpleSingle(Argument,op_PUSH,STag);
		end else begin
		    Evaluate(Argument,ToReg);
		    Out_Operation1(op_PUSH,STag,ea_Register,ToReg);
		    UnmarkRegister(ToReg);
		end;
		StackLoad := StackLoad + VarSize;
		if Odd(Total) then begin
		    Inc(StackLoad);
		    Inc(Total);
		end;
	    end else begin
		Evaluate(Argument,a0);
		VarSize := Formal^.VType^.Size;

		Out_Operation2(op_MOVE,4,ea_Register,a7,ea_Register,a1);
		AddConstant(-VarSize, a1, 4);
		Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d1);
		Out_Extension(Pred(VarSize));

		lab := GetLabel();
		Out_Operation1(op_LABEL,3,ea_Label,a7);
		Out_Extension(lab);
		Out_Operation2(op_MOVE,1,ea_PostInc,a0,ea_PostInc,a1);
		Out_Operation2(op_DBRA,3,ea_Register,d1,ea_Label,a7);
		Out_Extension(lab);

		AddConstant(-VarSize, a7, 4);
		StackLoad := StackLoad + VarSize;
		UnmarkRegister(a0);
	    end;
	end else begin { reference parameter }
	    EvalAddress(Argument, a0);
	    Out_Operation1(op_PUSH,4,ea_Register,a0);
	    StackLoad := StackLoad + 4;
	    Total := Total + 4;
	    UnmarkRegister(a0);
	end;
	Argument := Argument^.Next;
	Formal := Formal^.Next;
    end;
    PushArguments := Total;
end;


Function PushFrame(Callee : Integer) : Integer;
var
    Caller : Integer;
begin
    if Callee <= 1 then { global-level routines, which include externs }
	PushFrame := 0
    else begin
	Caller := Pred(CurrentBlock^.Level);
	if Callee = Caller + 1 then { calling child procedure }
	    Out_Operation1(op_PUSH,4,ea_Register,a5)
	else if Callee = Caller then begin { same level }
	    Out_Operation1(op_PUSH,4,ea_Index,a5);
	    Out_Extension(8);
	end else begin
	    Out_Operation2(op_MOVE,4,ea_Index,a5,ea_Register,a4);
	    Out_Extension(8);
	    Caller := Pred(Caller);
	    while Caller > Callee do begin
		Out_Operation2(op_MOVE,4,ea_Index,a4,ea_Register,a4);
		Out_Extension(8);
		Caller := Pred(Caller);
	    end;
	    Out_Operation1(op_PUSH,4,ea_Index,a4);
	    Out_Extension(8);
	end;
	StackLoad := StackLoad + 4;
	PushFrame := 4;
    end;
end;

{  Load the address of Expr into ToReg.  The Expr must be a valid
   variable reference, not a general expression. }

Procedure EvalAddress(Expr : ExprPtr; ToReg : Regs);
var
    Stacked  : Boolean;
    OtherReg : Regs;
    ID       : IDPtr;
    Reg      : Regs;
    WithInfo : WithRecPtr;
    SavedRegs: Integer;
begin
    case Expr^.Kind of
      var1 : begin
		ID := IDPtr(Expr^.Value);
		case ID^.Object of
		  global,
		  typed_const,
		  func,
		  proc  :
			begin
			    Out_Operation2(op_MOVE,4,ea_Address,a7,ea_Register,ToReg);
			    Out_Extension(Integer(ID));
			end;
		  local,
		  valarg :
			begin
			    Reg := GetFramePointer(ID^.Level);
			    if ToReg >= a0 then begin
				Out_Operation2(op_LEA,3,ea_Index,Reg,ea_Register,ToReg);
				Out_Extension(ID^.Offset);
			    end else begin
				Out_Operation2(op_LEA,3,ea_Index,Reg,ea_Register,a4);
				Out_Extension(ID^.Offset);
				Out_Operation2(op_MOVE,4,ea_Register,a4,ea_Register,ToReg);
			    end;
			end;
		  refarg :
			begin
			    Reg := GetFramePointer(ID^.Level);
			    Out_Operation2(op_MOVE,4,ea_Index,Reg,ea_Register,ToReg);
			    Out_Extension(ID^.Offset);
			end;
		end;
	     end;
      field1  : begin
		    ID := IDPtr(Expr^.Value);
		    WithInfo := WithRecPtr(Expr^.Left);
		    Out_Operation2(op_MOVE,4,ea_Index,a7,ea_Register,ToReg);
		    Out_Extension(Stackload - WithInfo^.Offset);
		    if ID^.Offset <> 0 then
			AddConstant(ID^.Offset, ToReg, 4);
		end;
      period1 : begin
		    EvalAddress(Expr^.Left,ToReg);
		    AddConstant(Expr^.Value, ToReg, 4);
                end;
      carat1 : if Expr^.Left^.EType^.Object = ob_file then begin
		   SavedRegs := UsedRegs;
		   SaveScratchRegisters;
		   Evaluate(Expr^.Left,a0);
		   Out_Operation1(op_JSR,3,ea_String,a7);
		   Out_Extension(Integer("_p%FilePtr"));
		   if IOCheck then begin
			Out_Operation1(op_JSR,3,ea_String,a7);
			Out_Extension(Integer("_p%CheckIO"));
		   end;
		   if ToReg <> a0 then
			Out_Operation2(op_MOVE,4,ea_Register,a0,ea_Register,ToReg);
		   UsedRegs := SavedRegs;
		   RestoreScratchRegisters;
		end else
		   Evaluate(Expr^.Left,ToReg);
      leftbrack1 : 
		with Expr^ do begin
		    if Left^.EType = StringType then
			Evaluate(Left, ToReg)
		    else
			EvalAddress(Left,ToReg);
		    if SimpleReference(Right) and (not RangeCheck) then begin
			WriteSimpleSource(Right,op_ADD,4,ea_Register,ToReg);
			{ If it's a simple reference it must be an Integer}
		    end else begin
			AllocateDataRegister(OtherReg, Stacked);
			Evaluate(Right, OtherReg);
			if RangeCheck and (Left^.EType <> StringType) then begin
			    Out_Operation1(op_PEA,3,ea_Absolute,a7);
			    Out_Extension((Left^.EType^.Upper -
					   Left^.EType^.Lower) *
					   Left^.EType^.SubType^.Size);
			    Out_Operation1(op_PUSH,4,ea_Register,OtherReg);
			    Out_Operation1(op_JSR,3,ea_String,a7);
			    Out_Extension(Integer("_p%CheckRange"));
			end;
			Out_Operation2(op_ADD,4,ea_Register,OtherReg,
						ea_Register,ToReg);
			DeallocateDataRegister(OtherReg,Stacked);
		    end;
		end;
      type1 : EvalAddress(Expr^.Left, ToReg);
    else
        Writeln('Error in EvalAddress : ', Ord(Expr^.Kind));
    end;
    MarkRegister(ToReg);
end;


Procedure Evaluate(Expr : ExprPtr; ToReg : Regs);
var
    op : Symbols;
    TagModel : String;

    Procedure ConstantOperation(op : OpCodes; STag : Byte;
					Value : Integer; ToReg : Regs);
    var
	OtherReg : Regs;
    begin
	OtherReg := TemporaryData;
	if (OtherReg < a0) and (Value <= 127) and (Value >= -128) and
	   (STag >= 3) and (Value <> 0) then begin
	    Out_Operation2(op_MOVEQ,3,ea_Constant,a7,ea_Register,OtherReg);
	    Out_Extension(Value);
	    Out_Operation2(op,STag,ea_Register,OtherReg,ea_Register,ToReg);
	end else begin
	    Out_Operation2(op, STag, ea_Constant,a7,ea_Register,ToReg);
	    Out_Extension(Value);
	end;
    end;


    Procedure Eval_BinaryFloat(offset : Integer);
    var
	SaveUsed : Integer;
    begin
	SaveUsed := UsedRegs;
	SaveScratchRegisters;
	Evaluate(Expr^.Left, d1);
	Evaluate(Expr^.Right, d0);
	if not MathLoaded then begin
	    Out_Operation2(op_MOVE,4,ea_String,a7,ea_Register,a6);
	    Out_Extension(Integer("_p%MathBase"));
	    MathLoaded := True;
	end;
	Out_Operation1(op_JSR,3,ea_Index,a6);
	Out_Extension(Offset);
	if ToReg <> d0 then
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,ToReg);
	UsedRegs := SaveUsed;
	RestoreScratchRegisters;
    end;


    Procedure Eval_UnaryFloat(offset : Integer);
    var
	SaveUsed : Integer;
    begin
	SaveUsed := UsedRegs;
	SaveScratchRegisters;
	Evaluate(Expr^.Left, d0);
	if not MathLoaded then begin
	    Out_Operation2(op_MOVE,4,ea_String,a7,ea_Register,a6);
	    Out_Extension(Integer("_p%MathBase"));
	    MathLoaded := True;
	end;
	Out_Operation1(op_JSR,3,ea_Index,a6);
	Out_Extension(Offset);
	if ToReg <> d0 then
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,ToReg);
	UsedRegs := SaveUsed;
	RestoreScratchRegisters;
    end;


    Procedure Eval_32BitMath(math : String);
    var
	SavedRegs : Integer;

	Procedure EvalToStack(Expr : ExprPtr);
 	begin
	    if Expr^.Kind = Const1 then begin
		Out_Operation1(op_PEA,3,ea_Absolute,a7);
		Out_Extension(Expr^.Value);
	    end else if SimpleReference(Expr) then begin
		WriteSimpleSingle(Expr,op_PUSH,4);
	    end else begin
		Evaluate(Expr, ToReg);
		Out_Operation1(op_PUSH,4,ea_Register,ToReg);
	    end;
	    StackLoad := StackLoad + 4;
	    UnmarkRegister(ToReg);
	end;

    begin
	with Expr^ do begin
	    SavedRegs := UsedRegs;
	    SaveScratchRegisters;
	    EvalToStack(Left);
	    EvalToStack(Right);
	    Out_Operation1(op_JSR,3,ea_String,a7);
	    Out_Extension(Integer(Math));
	    if ToReg <> d0 then
		Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,ToReg);
	    PopStackSpace(8);
	    UsedRegs := SavedRegs;
	    RestoreScratchRegisters;
	end;
    end;


    Procedure Eval_BinaryMath(op : OpCodes; UseSize : Boolean);
	{ add, sub, or, and, xor }
    var
	OtherReg : Regs;
	Stacked  : Boolean;
	STag	 : Byte;
    begin
	with Expr^ do begin
	    if UseSize then
		STag := EType^.Size
	    else
		STag := 3;

	    if Left^.Kind = Const1 then begin
		Evaluate(Right, ToReg);
		ConstantOperation(op, STag, Left^.Value, ToReg);
	    end else if SimpleReference(Left) then begin
		Evaluate(Right, ToReg);
		WriteSimpleSource(Left,op,STag,ea_Register,ToReg);
	    end else begin
		AllocateDataRegister(OtherReg, Stacked);
		Evaluate(Left, OtherReg);
		Evaluate(Right, ToReg);
		Out_Operation2(op,STag,ea_Register,OtherReg,ea_Register,ToReg);
		DeallocateDataRegister(OtherReg, Stacked);
	    end;
	end;
    end;


    Procedure Eval_UnaryMath(op : OpCodes);
    begin
	with Expr^ do begin
	    Evaluate(Left, ToReg);
	    Out_Operation1(op,EType^.Size,ea_Register,ToReg);
	end;
    end;


    Procedure Eval_Boolean;
	{ Boolean and & or, possibly with short circuits }
    var
	OtherReg : Regs;
	Stacked  : Boolean;
	ShortLab : Integer;
	op       : OpCodes;
	Temp     : ExprPtr;
    begin
	with Expr^ do begin

	    ShortLab := GetLabel;

	    if Left^.Kind = Const1 then begin
		Temp := Left;
		Left := Right;
		Right := Temp;
	    end;

	    Evaluate(Left, ToReg);

		{ If the right half is a constant, it must just be an }
		{ 'enabler' - FALSE for OR expressions, or TRUE for   }
		{ AND expressions.  Otherwise the expression would    }
		{ have optimized out. }

	    if Right^.Kind = Const1 then
		return;

	    Out_Operation1(op_TST,1,ea_Register,ToReg);

	    if Kind = or1 then
		Out_Operation1(op_BNE,3,ea_Label,a7)
	    else
		Out_Operation1(op_BEQ,3,ea_Label,a7);
	    Out_Extension(ShortLab);

	    case Kind of
	      or1  : op := op_OR;
	      and1 : op := op_AND;
	    end;

		{ We know at this point that the left half of the equation }
		{ is an enabler - otherwise the branch would have taken    }
		{ effect.  Therefore the value of the right half of the    }
		{ equation will determine the overall value                }

	    UnmarkRegister(ToReg);

	    Evaluate(Right, ToReg);

	    Out_Operation1(op_LABEL,3,ea_Label,a7);
	    Out_Extension(ShortLab);
	end;
    end;


    Procedure Eval_Comparison;
    var
	STag     : Byte;
	OtherReg : Regs;
	Stacked  : Boolean;

	Function LeftToRight : OpCodes;
	begin
	    case Expr^.Kind of
	      greater1  : LeftToRight := op_SLT;
	      less1	: LeftToRight := op_SGT;
	      notgreater1 : LeftToRight := op_SGE;
	      notless1	: LeftToRight := op_SLE;
	      equal1	: LeftToRight := op_SEQ;
	      notequal1	: LeftToRight := op_SNE;
	    end;
	end;


	Function RightToLeft : OpCodes;
	begin
	    case Expr^.Kind of
	      greater1  : RightToLeft := op_SGT;
	      less1	: RightToLeft := op_SLT;
	      notgreater1 : RightToLeft := op_SLE;
	      notless1	: RightToLeft := op_SGE;
	      equal1	: RightToLeft := op_SEQ;
	      notequal1	: RightToLeft := op_SNE;
	    end;
	end;


    begin
	with Expr^ do begin
	    if Left^.EType = RealType then begin
		Eval_BinaryFloat(-42);
		Out_Operation1(LeftToRight, 3, ea_Register, ToReg);
	    end else begin
		STag := Left^.EType^.Size;

		if Right^.Kind = Const1 then begin
		    Evaluate(Left, ToReg);
		    ConstantOperation(op_CMP,STag,Right^.Value,ToReg);
		    Out_Operation1(RightToLeft,3,ea_Register,ToReg);
		end else if Left^.Kind = Const1 then begin
		    Evaluate(Right, ToReg);
		    ConstantOperation(op_CMP,STag, Left^.Value, ToReg);
		    Out_Operation1(LeftToRight,3,ea_Register,ToReg);
		end else if SimpleReference(Right) then begin
		    Evaluate(Left, ToReg);
		    WriteSimpleSource(Right,op_CMP,STag,ea_Register,ToReg);
		    Out_Operation1(RightToLeft,3,ea_Register,ToReg);
		end else if SimpleReference(Left) then begin
		    Evaluate(Right, ToReg);
		    WriteSimpleSource(Left,op_CMP,STag,ea_Register,ToReg);
		    Out_Operation1(LeftToRight,3,ea_Register,ToReg);
		end else begin
		    AllocateDataRegister(OtherReg, Stacked);
		    Evaluate(Right, OtherReg);
		    Evaluate(Left, ToReg);
		    Out_Operation2(op_CMP,STag,ea_Register,OtherReg,
						ea_Register,ToReg);
		    Out_Operation1(RightToLeft,3,ea_Register,ToReg);
		    DeallocateDataRegister(OtherReg, Stacked);
		end;
	    end;
	end;
    end;

    Procedure LoadIDValue(ID : IDPtr);
    var
	STag : Byte;
	Simp : Boolean;
	OtherReg : Regs;
    begin
	STag := ID^.VType^.Size;
	Simp := SimpleType(ID^.VType);
	case ID^.Object of
	  typed_const,
	  global :
		if Simp then begin
		    Out_Operation2(op_MOVE,STag,ea_Global,a7,ea_Register,ToReg);
		    Out_Extension(Integer(ID));
		end else begin
		    Out_Operation2(op_MOVE,4,ea_Address,a7,ea_Register,ToReg);
		    Out_Extension(Integer(ID));
		end;
	  local,
	  valarg :
		begin
		    OtherReg := GetFramePointer(ID^.Level);
		    if Simp then begin
			Out_Operation2(op_MOVE,STag,ea_Index,OtherReg,
							ea_Register,ToReg);
			Out_Extension(ID^.Offset);
		    end else begin
			if ToReg >= a0 then begin
			    Out_Operation2(op_LEA,3,ea_Index,OtherReg,
							ea_Register,ToReg);
			    Out_Extension(ID^.Offset);
			end else begin
			    Out_Operation2(op_LEA,3,ea_Index,OtherReg,
							ea_Register,a4);
			    Out_Extension(ID^.Offset);
			    Out_Operation2(op_MOVE,4,ea_Register,a4,
							ea_Register,ToReg);
			end;
		    end;
	 	end;
	  refarg :
		begin
		    OtherReg := GetFramePointer(ID^.Level);
		    if Simp then begin
			Out_Operation2(op_MOVE,4,ea_Index,OtherReg,
						ea_Register,a4);
			Out_Extension(ID^.Offset);
			Out_Operation2(op_MOVE,STag,ea_Indirect,a4,
							ea_Register,ToReg);
		    end else begin
			Out_Operation2(op_MOVE,4,ea_Index,OtherReg,
						ea_Register,ToReg);
			Out_Extension(ID^.Offset);
		    end;
		end;
	end;
    end;


    Procedure Eval_Shift;
    var
	OtherReg : Regs;
	Stacked	: Boolean;
    begin
	with Expr^ do begin
	    if Right^.Kind = Const1 then begin
		Evaluate(Left, ToReg);
		if Kind = shl1 then
		    ConstantShiftLeft(Right^.Value, ToReg, EType^.Size)
		else
		    ConstantShiftRight(op_LSR,Right^.Value,ToReg,EType^.Size);
	    end else begin
		AllocateDataRegister(OtherReg, Stacked);
		Evaluate(Left, ToReg);
		Evaluate(Right, OtherReg);
		if Kind = shl1 then
		    Out_Operation2(op_LSL,EType^.Size,ea_Register,OtherReg,
							ea_Register,ToReg)
		else
		    Out_Operation2(op_LSR,EType^.Size,ea_Register,OtherReg,
							ea_Register,ToReg);
		DeallocateDataRegister(OtherReg, Stacked);
	    end;
	end;
    end;


    Procedure Eval_Constant;
    begin
	with Expr^ do begin
	    Out_Operation2(op_MOVE,EType^.Size,ea_Constant,a7,
						ea_Register,ToReg);
	    Out_Extension(Value);
	end;
    end;
				


    { Generate the value of an array reference.  Cases where the index
      is a constant will not occur - they are converted to period1 nodes
      in Expr.p and Optimize.p }

    Procedure Eval_ArrayReference;
    var
	AReg,
	DReg : Regs;
	Stacked : Boolean;
    begin
	with Expr^ do begin
	    if ToReg >= a0 then
		AReg := ToReg
	    else
		AllocateAddressRegister(AReg, Stacked);
	    if Left^.EType = StringType then
		Evaluate(Left, AReg)
	    else
		EvalAddress(Left, AReg);
	    if SimpleReference(Right) and (not RangeCheck) then begin
		WriteSimpleSource(Right,op_ADDA,4,ea_Register,AReg);
		if SimpleType(EType) then
		    Out_Operation2(op_MOVE,EType^.Size,ea_Indirect,AReg,
							ea_Register,ToReg)
		else if AReg <> ToReg then
		    Out_Operation2(op_MOVE,4,ea_Register,AReg,
						ea_Register,ToReg);
		if AReg <> ToReg then
		    DeallocateAddressRegister(AReg, Stacked);
	    end else begin
		if ToReg < a0 then
		    DReg := ToReg
		else
		    AllocateDataRegister(DReg, Stacked); { will not happen with above }
		Evaluate(Right, DReg);
		if RangeCheck and (Left^.EType <> StringType) then begin
		    Out_Operation1(op_PEA,3,ea_Absolute,a7);
		    Out_Extension((Left^.EType^.Upper -
				   Left^.EType^.Lower) *
				   Left^.EType^.SubType^.Size);
		    Out_Operation1(op_PUSH,4,ea_Register,DReg);
		    Out_Operation1(op_JSR,3,ea_String,a7);
		    Out_Extension(Integer("_p%CheckRange"));
		end;
		if SimpleType(EType) then begin
		    Out_Operation2(op_MOVE,EType^.Size,ea_RegInd,AReg,
							ea_Register,DReg);
		    Out_Extension(Ord(DReg));
		end else begin
		    if DReg = ToReg then
			Out_Operation2(op_ADD,4,ea_Register,AReg,
							ea_Register,DReg)
		    else
			Out_Operation2(op_ADDA,4,ea_Register,DReg,
							ea_Register,AReg);
		end;
		if DReg = ToReg then
		    DeallocateAddressRegister(AReg, Stacked)
		else
		    DeallocateDataRegister(DReg, Stacked);
	    end;
	end;
    end;


    Procedure Eval_Dereference;
    var
	OtherReg : Regs;
	Stacked  : Boolean;
	SaveUsed : Integer;
    begin
	with Expr^ do begin
	    if Left^.EType^.Object = ob_file then begin
		SaveUsed := UsedRegs;
		SaveScratchRegisters;
		Evaluate(Left,a0);
		Out_Operation1(op_JSR,3,ea_String,a7);
		Out_Extension(Integer("_p%FilePtr"));
		if IOCheck then begin
		    Out_Operation1(op_JSR,3,ea_String,a7);
		    Out_Extension(Integer("_p%CheckIO"));
		end;
		Out_Operation2(op_MOVE,EType^.Size,ea_Indirect,a0,
							ea_Register,ToReg);
		UsedRegs := SaveUsed;
		RestoreScratchRegisters;
	    end else if SimpleType(EType) then begin
		if ToReg < a0 then
		    AllocateAddressRegister(OtherReg, Stacked)
		else
		    OtherReg := ToReg;
		Evaluate(Left, OtherReg);
		Out_Operation2(op_MOVE,EType^.Size,ea_Indirect,OtherReg,
							ea_Register,ToReg);
		if ToReg < a0 then
		    DeallocateAddressRegister(OtherReg, Stacked);
	    end else
		Evaluate(Left, ToReg);
	end;
    end;


    Procedure Eval_RecordReference;
    var
	OtherReg : Regs;
	Stacked  : Boolean;
    begin
	with Expr^ do begin
	    if SimpleType(EType) then begin
		if ToReg < a0 then
		    AllocateAddressRegister(OtherReg, Stacked)
		else
		    OtherReg := ToReg;
		EvalAddress(Left,OtherReg);
		Out_Operation2(op_MOVE,EType^.Size,ea_Index,OtherReg,
							ea_Register,ToReg);
		Out_Extension(Value);
		if ToReg < a0 then
		    DeallocateAddressRegister(OtherReg, Stacked);
	    end else begin
		EvalAddress(Left,ToReg);
		AddConstant(Value, ToReg, 4);
	    end;
	end;
    end;


    Procedure DoOpen(AccessMode : Short);

    {
	This routine handles both open and reopen, depending on the
	AccessMode sent to it.  This is just passed on to the DOS routine.

	OpenExpr:
		Kind: stanfunc1
		Value: 7 or 8 (reopen or open)
		Left Right
	       /         \
	      /           \
	File Var Expr      file name expr (string)
	Next
	    \
	     \
	      Buffer Size
     }

    var
	BufferSize	: ExprPtr;
	SaveUsed	: Integer;
    begin
	SaveUsed := UsedRegs;
	SaveScratchRegisters;
	with Expr^.Right^ do begin
	    if Kind = Const1 then begin
		Out_Operation1(op_PUSH,4,ea_Constant,a7);
		Out_Extension(Value);
	    end else if Kind = Quote1 then begin
		Out_Operation1(op_PUSH,4,ea_Literal,a7);
		Out_Extension(Value);
	    end else begin
		Evaluate(Expr^.Right, d0);
		Out_Operation1(op_PUSH,4,ea_Register,d0);
		UnmarkRegister(d0);
	    end;
	end;

	StackLoad := StackLoad + 4;	
	Evaluate(Expr^.Left,a0);

	Out_Operation2(op_MOVE,2,ea_Constant,a7,ea_Index,a0);
	Out_Extension(AccessMode);
	Out_Extension(30);

	Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Index,a0);
	Out_Extension(Expr^.Left^.EType^.SubType^.Size);
	Out_Extension(24);

	BufferSize := Expr^.Left^.Next;
	if BufferSize^.Kind = Const1 then begin
	    Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Index,a0);
	    Out_Extension(BufferSize^.Value);
	end else if SimpleReference(BufferSize) then begin
	    WriteSimpleSource(BufferSize,op_MOVE,4,ea_Index,a0);
	end else begin
	    Evaluate(BufferSize,d0);
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Index,a0);
	end;
	Out_Extension(20);

	Out_Operation1(op_PUSH,4,ea_Register,a0);
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%Open"));

	if ToReg <> d0 then
	    Out_Operation2(op_MOVE,1,ea_Register,d0,ea_Register,ToReg);

	AddConstant(8, a7, 4);
	StackLoad := StackLoad - 4;

	UsedRegs := SaveUsed;
	RestoreScratchRegisters;
	MathLoaded := False;
    end;


    Procedure Eval_StandardFunction;
    var
	Stacked  : Boolean;
	Lab      : Integer;
	STag     : Byte;
	SaveUsed : Integer;
	OtherReg : Regs;
    begin
	STag := Expr^.Left^.EType^.Size;
	case Expr^.Value of
    {Ord} 1,
    {Chr} 2,  : Evaluate(Expr^.Left,ToReg);
    {Odd} 3   : begin
		    Evaluate(Expr^.Left,ToReg);
		    ConstantOperation(op_AND,STag,1,ToReg);
		    Out_Operation1(op_SNE,3,ea_Register,ToReg);
		end;
    {Abs} 4   : if Expr^.EType = RealType then begin
		    Eval_UnaryFloat(-54);
		end else begin
		    Lab := GetLabel;
		    Evaluate(Expr^.Left, ToReg);
		    Out_Operation1(op_TST,STag,ea_Register,ToReg);
		    Out_Operation1(op_BPL,3,ea_Label,a7);
		    Out_Extension(Lab);
		    Out_Operation1(op_NEG,STag,ea_Register,ToReg);
		    Out_Operation1(op_LABEL,3,ea_Label,a7);
		    Out_Extension(Lab);
		end;
    {Succ} 5  : begin
		    Evaluate(Expr^.Left,ToReg);
		    AddConstant(1, ToReg, STag);
		end;
    {Pred} 6  : begin
		    Evaluate(Expr^.Left,ToReg);
		    AddConstant(-1, ToReg, STag);
		end;
    {ReOpen} 7 : DoOpen(1005);
    {Open}   8 : DoOpen(1006);
    {EOF} 9   : begin
		    AllocateAddressRegister(OtherReg, Stacked);
		    Evaluate(Expr^.Left,OtherReg);
		    Out_Operation2(op_MOVE,1,ea_Index,OtherReg,
						ea_Register,ToReg);
		    Out_Extension(29);
		    DeallocateAddressRegister(OtherReg, Stacked);
		end;
 {Trunc}  10  : Eval_UnaryFloat(-30);
 {Round}  11  : begin
		    SaveUsed := UsedRegs;
		    SaveScratchRegisters;
		    Evaluate(Expr^.Left, d0);
		    Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d1);
		    Out_Extension(Integer(0.5));
		    if not MathLoaded then begin
			Out_Operation2(op_MOVE,4,ea_String,a7,ea_Register,a6);
			Out_Extension(Integer("_p%MathBase"));
			MathLoaded := True;
		    end;
		    Out_Operation1(op_JSR,3,ea_Index,a6);
		    Out_Extension(-66);
		    Out_Operation1(op_JSR,3,ea_Index,a6);
		    Out_Extension(-90);
		    Out_Operation1(op_JSR,3,ea_Index,a6);
		    Out_Extension(-30);
		    if ToReg <> d0 then
			Out_Operation2(op_MOVE,4,ea_Register,d0,
							ea_Register,ToReg);
		    UsedRegs := SaveUsed;
		    RestoreScratchRegisters;
		end;
 { Float } 12 : Eval_UnaryFloat(-36);
 { Floor } 13 : Eval_UnaryFloat(-90);
 { Ceil }  14 : Eval_UnaryFloat(-96);
 { SizeOf }

 { Adr }   16 : EvalAddress(Expr^.Left, ToReg);
 { Bit }
 { Sqr }   18 : begin
		    SaveUsed := UsedRegs;
		    SaveScratchRegisters;
		    Evaluate(Expr^.Left, d0);
		    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,d1);
		    if not MathLoaded then begin
			Out_Operation2(op_MOVE,4,ea_String,a7,ea_Register,a6);
			Out_Extension(Integer("_p%MathBase"));
			MathLoaded := True;
		    end;
		    Out_Operation1(op_JSR,3,ea_Index,a6);
		    Out_Extension(-78);
		    if ToReg <> d0 then
			Out_Operation2(op_MOVE,4,ea_Register,d0,
							ea_Register,ToReg);
		    UsedRegs := SaveUsed;
		    RestoreScratchRegisters;
		end;
      19..25 : { Sqr, Sin, Cos, Sqrt, Tan, ArcTan, Ln, Exp }
	    with Expr^ do begin
		SaveUsed := UsedRegs;
		SaveScratchRegisters;
		if Left^.Kind = Const1 then begin
		    Out_Operation1(op_PEA,3,ea_Absolute,a7);
		    Out_Extension(Expr^.Value);
		end else if SimpleReference(Expr) then begin
		    WriteSimpleSingle(Expr,op_PUSH,4);
		end else begin
		    Evaluate(Expr^.Left, ToReg);
		    Out_Operation1(op_PUSH,4,ea_Register,ToReg);
		end;
		Out_Operation1(op_JSR,3,ea_String,a7);
		case Value of
		  19 : Out_Extension(Integer("_p%sin"));
		  20 : Out_Extension(Integer("_p%cos"));
		  21 : Out_Extension(Integer("_p%sqrt"));
		  22 : Out_Extension(Integer("_p%tan"));
		  23 : Out_Extension(Integer("_p%atn"));
		  24 : Out_Extension(Integer("_p%ln"));
		  25 : Out_Extension(Integer("_p%exp"));
		end;
		AddConstant(4, a7, 4);
		if ToReg <> d0 then
		    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,ToReg);
                UsedRegs := SaveUsed;
                RestoreScratchRegisters;
	    end;
	end;
    end;


    Procedure Eval_FunctionCall;
    var
	SaveUsed : Integer;
	ID       : IDPtr;
	PushSize : Integer;
    begin
	SaveUsed := UsedRegs;
	SaveScratchRegisters;
	PushSize := PushArguments(Expr, ToReg);
	ID := IDPtr(Expr^.Value);
	PushSize := PushSize + PushFrame(ID^.Level);
	Out_Operation1(op_JSR,3,ea_Global,a7);
	Out_Extension(Integer(ID));
	PopStackSpace(PushSize);
	if ToReg <> d0 then
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,ToReg);
	UsedRegs := SaveUsed;
	RestoreScratchRegisters;
	MathLoaded := False;
    end;



    Procedure Eval_FieldReference;
    var
	WithInfo : WithRecPtr;
	Stacked  : Boolean;
	STag     : Byte;
	OtherReg : Regs;
	ID       : IDPtr;
    begin
	ID := IDPtr(Expr^.Value);
	WithInfo := WithRecPtr(Expr^.Left);
	if SimpleType(Expr^.EType) then begin
	    STag := ID^.VType^.Size;
	    if ToReg < a0 then
		AllocateAddressRegister(OtherReg, Stacked)
	    else
		OtherReg := ToReg;
	    Out_Operation2(op_MOVE,4,ea_Index,a7,ea_Register,OtherReg);
	    Out_Extension(StackLoad - WithInfo^.Offset);

	    Out_Operation2(op_MOVE,STag,ea_Index,OtherReg,ea_Register,ToReg);
	    Out_Extension(ID^.Offset);
	    if ToReg < a0 then
		DeallocateAddressRegister(OtherReg, Stacked);
	end else begin
	    Out_Operation2(op_MOVE,4,ea_Index,a7,ea_Register,ToReg);
	    Out_Extension(StackLoad - WithInfo^.Offset);
	    AddConstant(ID^.Offset, ToReg, 4);
	end;
    end;



    { Return the power of 2 represented by Value, or -1 if it's not
      a power of 2 }

    Function GetShifts(Value : Integer) : Integer;
    var
	Compare : Integer;
	Shifts  : Integer;
    begin
	Shifts := 0;
	Compare := 1;
	repeat
	    if Compare = Value then
		GetShifts := Shifts;
	    Inc(Shifts);
	    Compare := Compare shl 1;
	until Shifts > 30;
	GetShifts := -1;
    end;


    Procedure Eval_Multiplier;
    var
	Shifts   : Integer;
    begin
	with Expr^ do begin
	    if Left^.Kind = Const1 then begin
		Shifts := GetShifts(Left^.Value);
		if Shifts = 0 then begin
		    Evaluate(PromoteTypeA(Right,IntType), ToReg);
		    Return;
		end;
		if Shifts < 0 then begin
		    if Left^.EType^.Size = 4 then
			Eval_32BitMath("_p%lmul")
		    else
			Eval_BinaryMath(op_MULS,False);
		end else begin
		    Evaluate(PromoteTypeA(Right,IntType), ToReg);
		    ConstantShiftLeft(Shifts, ToReg, 4);
		end;
	    end else begin
		if Left^.EType^.Size = 4 then
		    Eval_32BitMath("_p%lmul")
		else
		    Eval_BinaryMath(op_MULS,False);
	    end;
	end;
    end;


    Procedure Eval_Divisor;
    var
	Shifts   : Integer;
    begin
	with Expr^ do begin
	    if Left^.Kind = Const1 then begin
		Shifts := GetShifts(Left^.Value);
		if Shifts = 0 then begin
		    Evaluate(Right, ToReg);
		    Return;
		end;
		if Shifts < 0 then begin
		    if Left^.EType^.Size = 4 then
			Eval_32BitMath("_p%ldiv")
		    else
			Eval_BinaryMath(op_DIVS,False);
		end else begin
		    Evaluate(Right, ToReg);
		    ConstantShiftRight(op_ASR,Shifts, ToReg, 4);
		end;
	    end else begin
		if Left^.EType^.Size = 4 then
		    Eval_32BitMath("_p%ldiv")
		else
		    Eval_BinaryMath(op_DIVS,False);
	    end;
	end;
    end;


    Procedure Eval_Modulus;
    var
	Shifts   : Integer;
    begin
	with Expr^ do begin
	    if Left^.Kind = Const1 then begin
		Shifts := GetShifts(Left^.Value);
		if Shifts = 0 then begin
		    Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,ToReg);
		    Out_Extension(0);
		    Return;
		end;
		if Shifts < 0 then begin
		    if Left^.EType^.Size = 4 then
			Eval_32BitMath("_p%lrem")
		    else begin
			Eval_BinaryMath(op_DIVS,False);
			Out_Operation1(op_SWAP,3,ea_Register,ToReg);
		    end;
		end else begin
		    Evaluate(Right, ToReg);
		    ConstantOperation(op_AND,Expr^.EType^.Size,
					Pred(1 shl shifts), ToReg);
		end;
	    end else begin
		if Left^.EType^.Size = 4 then
		    Eval_32BitMath("_p%lrem")
		else begin
		    Eval_BinaryMath(op_DIVS,False);
		    Out_Operation1(op_SWAP,3,ea_Register,ToReg);
		end;
	    end;
	end;
    end;


begin
    if Expr^.EType = BadType then
	return;

    op := Expr^.Kind;
    TagModel := ". \t";

    if op <= minus1 then begin
	if op <= xor1 then begin
	    case op of
	      and1	: if (Expr^.EType = BoolType) and ShortCircuit then
			      Eval_Boolean
			  else
			      Eval_BinaryMath(op_AND,True);
	      const1	: Eval_Constant;
	      div1	: Eval_Divisor;
	      func1	: Eval_FunctionCall;
	      mod1	: Eval_Modulus;
	      not1	: Eval_UnaryMath(op_NOT);
	      or1	: if (Expr^.EType = BoolType) and ShortCircuit then
			      Eval_Boolean
			  else
			      Eval_BinaryMath(op_OR,True);
	      shl1	: Eval_Shift;
	      shr1	: Eval_Shift;
	      type1	: Evaluate(Expr^.Left, ToReg);
	      var1	: LoadIDValue(IDPtr(Expr^.Value));
	      xor1	: Eval_BinaryMath(op_EOR,True);
	    else
		Writeln(OutFile, 'Did not do: ', Ord(op));
	    end;
	end else begin
	    case op of
	      asterisk1	: if Expr^.EType = RealType then
			      Eval_BinaryFloat(-78)
			  else
			      Eval_Multiplier;
	      equal1	: Eval_Comparison;
	      greater1	: Eval_Comparison;
	      leftbrack1: Eval_ArrayReference;
	      less1	: Eval_Comparison;
	      minus1	: if Expr^.Right = Nil then begin { Unary minus }
				if Expr^.EType = RealType then
				    Eval_UnaryFloat(-60)
				else
				    Eval_UnaryMath(op_NEG);
			  end else begin
				if Expr^.EType = RealType then
				    Eval_BinaryFloat(-72)
				else
				    Eval_BinaryMath(op_SUB,True);
			  end;
	    else
		Writeln(OutFile, 'Did not do ', Ord(op));
	    end;
	end;
    end else begin
	if op <= carat1 then begin
	    case op of
	      notequal1	: Eval_Comparison;
	      notgreater1 : Eval_Comparison;
	      notless1	: Eval_Comparison;
	      period1	: Eval_RecordReference;
	      plus1	: if Expr^.EType = RealType then
			      Eval_BinaryFloat(-66)
			  else
			      Eval_BinaryMath(op_ADD,True);
	      quote1	: begin
			      Out_Operation2(op_MOVE,4,ea_Literal,a7,
							ea_Register,ToReg);
			      Out_Extension(Expr^.Value);
			  end;
	      carat1	: Eval_Dereference;
	    else
		Writeln(OutFile, 'Did not do ', Ord(op));
	    end;
	end else begin
	    case op of
	      at1    : EvalAddress(Expr^.Left, ToReg);
	      realdiv1 : Eval_BinaryFloat(-84);
	      int2real : Eval_UnaryFloat(-36);
	      real2int : Eval_UnaryFloat(-30);
	      short2long : begin
				Evaluate(Expr^.Left, ToReg);
				Out_Operation1(op_EXT,4,ea_Register,ToReg);
			   end;
	      byte2short : begin
				Evaluate(Expr^.Left, ToReg);
				Out_Operation2(op_AND,2,ea_Constant,a7,
							ea_Register,ToReg);
				Out_Extension(255);
			   end;
	      byte2long	: begin
			      Evaluate(Expr^.Left, ToReg);
			      ConstantOperation(op_AND, 4, $FF, ToReg);
			  end;
	      stanfunc1 : Eval_StandardFunction;
	      field1	: Eval_FieldReference;
	    else
		Writeln(OutFile, 'Did not do ', Ord(op));
	    end;
	end;
    end;
    MarkRegister(ToReg);
end;

{
Procedure ReportTree(Expr : ExprPtr);
var
    ID : IDPtr;
    E2 : ExprPtr;
    TP : TypePtr;
begin
    Write(OutFile, '(');
    case Expr^.Kind of
	const1 : if Expr^.EType = RealType then
		     Write(OutFile, Real(Expr^.Value))
		 else
		     Write(OutFile, Expr^.Value);
	and1,
	div1,
	or1,
	shl1,
	shr1,
	xor1,
	asterisk1,
	equal1,
	notequal1,
	greater1,
	less1,
	notgreater1,
	notless1,
	plus1,
	realdiv1,
	mod1 : begin
		   ReportTree(Expr^.Left);
		   case Expr^.Kind of
		     and1 : Write(OutFile, ' and ');
		     div1 : Write(OutFile, ' div ');
		     mod1 : Write(OutFile, ' mod ');
		     or1  : Write(OutFile, ' or ');
		     shl1 : Write(OutFile, ' shl ');
		     shr1 : Write(OutFile, ' shr ');
		     xor1 : Write(OutFile, ' xor ');
		     asterisk1 : Write(OutFile, ' * ');
		     equal1 : Write(OutFile, ' = ');
		     notequal1 : Write(OutFile, ' <> ');
		     greater1 : write(OutFile, ' > ');
		     less1 : Write(OutFile, ' < ');
		     notgreater1 : Write(OutFile, ' <= ');
		     notless1 : Write(OutFile, ' >= ');
		     plus1 : Write(OutFile, ' + ');
		     minus1 : Write(OutFile, ' - ');
		     realdiv1 : Write(OutFile, ' / ');
		   end;
		   ReportTree(Expr^.Right);
		end;
	minus1: if Expr^.Right = Nil then begin
		    Write(OutFile, '-');
		    ReportTree(Expr^.Left);
		end else begin
		    ReportTree(Expr^.Left);
		    Write(OutFile, ' - ');
		    ReportTree(Expr^.Right);
		end;
	func1 : begin
		    ID := IDPtr(Expr^.Value);
		    Write(OutFile, ID^.Name, '(');
		    E2 := Expr^.Left;
		    while E2 <> Nil do begin
			ReportTree(E2);
			Write(OutFile, ',');
			E2 := E2^.Next;
		    end;
		    Write(OutFile, ')');
		end;
	not1: begin
		write(OutFile, ' not ');
		ReportTree(Expr^.Left);
	      end;
	type1: begin
		write(OutFile, 'type(');
		ReportTree(Expr^.Left);
		Write(OutFile, ')');
	       end;
	var1 : begin
		    ID := IDPtr(Expr^.Value);
		    case ID^.Object of
		      global,
		      typed_const : Write(OutFile, ID^.Name);
		      local,
		      refarg,
		      valarg : Write(OutFile, ID^.Offset, '(a5)');
		    else
		        Write(OutFile, 'var(', Ord(ID^.Object), ')');
		    end;
		end;
	leftbrack1 :
		begin
		    ReportTree(Expr^.Left);
		    Write(OutFile, '[');
		    ReportTree(Expr^.Right);
		    Write(OutFile, ']');
		end;
	period1	:
		begin
		    ReportTree(Expr^.Left);
		    Write(OutFile, '.', Expr^.Value);
		end;
	quote1	: Write(OutFile, '""');
	carat1	: begin
			ReportTree(Expr^.Left);
			Write(OutFile, '^');
		  end;
	at1    : begin
		     Write(OutFile, '@');
		     ReportTree(Expr^.Left);
		 end;
	int2real : begin
			write(OutFile, '_float(');
			ReportTree(Expr^.Left);
			write(OutFile, ')');
		   end;
	real2int : begin
			Write(OutFile, '_trunc(');
			ReportTree(Expr^.Left);
			Write(OutFile, ')');
		   end;
	short2long : begin
			Write(OutFile, 'short2long(');
			ReportTree(Expr^.Left);
			Write(OutFile, ')');
		    end;
	byte2short : begin
			Write(OutFile, 'byte2short(');
			ReportTree(Expr^.Left);
			Write(OutFile, ')');
		     end;
	byte2long : begin
			Write(OutFile, 'byte2long(');
			ReportTree(Expr^.Left);
			Write(OutFile, ')');
		    end;
	stanfunc1 : begin
			Write(OutFile, 'standard', Expr^.Value, '(');
			ReportTRee(Expr^.Left);
			Write(OutFile, ')');
		    end;
	field1	: Write(OutFile, 'withfield');
    else
	Writeln(OutFile, 'Did not report ', Ord(Expr^.Kind));
    end;
    Write(OutFile, ')');
end;
}

Function Expression : TypePtr;
var
    Expr : ExprPtr;
    TP   : TypePtr;
begin
    NextFreeExprNode := 0;
    ConstantExpression := False;
    Expr := ExpressionTree;
    Optimize(Expr);
    TP := Expr^.EType;
    FreeAllRegisters;
{    if DoReport then begin
	ReportTree(Expr);
	Writeln(OutFile);
    end; }
    Evaluate(Expr,d0);
    NextFreeExprNode := 0;
    Expression := Expr^.EType;
end;

Function ConExpr(VAR ConType : TypePtr) : Integer;
var
    Expr : ExprPtr;
    Result : Integer;
begin
    NextFreeExprNode := 0;
    ConstantExpression := True;
    Expr := ExpressionTree;
    ConstantExpression := False;
    Optimize(Expr);
    Result := Expr^.Value;
    if (Expr^.Kind = Const1) or (Expr^.Kind = Quote1) then begin
	ConType := Expr^.EType;
	NextFreeExprNode := 0;
	ConExpr := Result;
    end else begin
	NextFreeExprNode := 0;
	ConType := BadType;
	Error("Expecting a Constant Expression");
	ConExpr := 1;
    end;
end;


{
    Store the result of the expression Expr in the address Destination.
    The two expressions must pass TypeCheck, or this will not work at all.
}

Procedure StoreValue(Expr : ExprPtr; Destination : ExprPtr);
var
    STag : Byte;
    SameType : Boolean;
    Lab  : Integer;
    OtherReg : Regs;
begin
    STag := Destination^.EType^.Size;
    SameType := STag = Expr^.EType^.Size;
    if SimpleReference(Destination) then begin
	if Expr^.Kind = Const1 then begin
	    OtherReg := TemporaryData;
	    with Expr^ do begin
		if (OtherReg < a0) and (STag = 4) and (Value <= 127) and
			(Value >= -128) and (Value <> 0) then begin
		    Out_Operation2(op_MOVEQ,3,ea_Constant,a7,
						ea_Register,OtherReg);
		    Out_Extension(Value);
		    WriteSimpleDest(Destination,op_MOVE,4,
						ea_Register,OtherReg,0,0);
		end else
		    WriteSimpleDest(Destination,op_MOVE,STag,
						ea_Constant,a7,Value,0);
	    end;
	end else begin
	    Evaluate(Expr,d0);
	    WriteSimpleDest(Destination,op_MOVE,STag,ea_Register,d0,0,0);
	end;
    end else if SimpleType(Destination^.EType) then begin
	EvalAddress(Destination,a0);
	if Expr^.Kind = Const1 then begin
	    Out_Operation2(op_MOVE,STag,ea_Constant,a7,ea_Indirect,a0);
	    Out_Extension(Expr^.Value);
	end else if SimpleReference(Expr) and SameType then begin
	    WriteSimpleSource(Expr,op_MOVE,STag,ea_Indirect,a0);
	end else begin
	    Evaluate(Expr, d0);
	    Out_Operation2(op_MOVE,STag,ea_Register,d0,ea_Indirect,a0);
	end;
    end else begin
	Evaluate(Expr,a0);
	EvalAddress(Destination,a1);

	Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d1);
	Out_Extension(Pred(Destination^.EType^.Size));

	lab := GetLabel();
	Out_Operation1(op_LABEL,3,ea_Label,a7);
	Out_Extension(Lab);
	Out_Operation2(op_MOVE,1,ea_PostInc,a0,ea_PostInc,a1);
	Out_Operation2(op_DBRA,3,ea_Register,d1,ea_Label,a7);
	Out_Extension(Lab);
    end;
end;

Procedure Assignment;
{
	Not surprisingly, this routine handles assignments.
}
var
    Destination,
    Expr	: ExprPtr;
begin
    NextFreeExprNode := 0;
    FreeAllRegisters;
    Destination := GetReference;
    if not Match(becomes1) then begin
	Error("Expecting :=");
	return;
    end;
    Optimize(Destination);
{    if DoReport then begin
	ReportTree(Destination);
	writeln(OutFile);
    end; }
    Expr := ExpressionTree;
    if NumberType(Destination^.EType) then begin
	Expr := PromoteTypeA(Expr, Destination^.EType);
	if (Expr^.EType = RealType) and
	    (Destination^.EType^.Object = ob_ordinal) then
	    Expr := MakeNode(real2int, Expr, Nil, IntType, 0);
    end;
{    if DoReport then begin
	ReportTree(Expr);
	Writeln(OutFile);
    end; }
    Optimize(Expr);
{    if DoReport then begin
	ReportTree(Expr);
	Writeln(OutFile);
    end; }

    if TypeCheck(Destination^.EType, Expr^.EType) then
	StoreValue(Expr, Destination)
    else
	Error("Mismatched Types in Assignment");
end;
