External;

{
	Calls.p (of PCQ Pascal)
	Copyright (c) 1989 Patrick Quaid

	Calls.p is the first attempt to organize the various
addressing and code generating routines in one section.  If you
read the other sections you'll find that not much effort went into
this project.  Nonetheless, a couple of common addressing things
can be found here.
	If the compiler were designed so that all the addressing
things were here, it would be much easier to port to a different
processor.
}

{$O-}
{$I "Pascal.i"}

	Function Match(s : Symbols) : Boolean;
	    external;
	Procedure Error(s : string);
	    external;
	Function FindField(s : string; TP : TypePtr): IDPtr;
	    external;
	Function FindWithField(S : String) : IDPtr;
	    External;
	Procedure NextSymbol;
	    external;
	Function Expression : TypePtr;
	    external;
	Function GetReference : ExprPtr;
	    External;
	Procedure EvalAddress(Expr : ExprPtr; ToReg : Regs);
	    External;
	Procedure FreeAllRegisters;
	    External;
	Procedure Optimize(Expr : ExprPtr);
	    External;
	Function TypeCheck(t1, t2 : TypePtr): Boolean;
	    external;
	Function TypeCmp(t1, t2 : TypePtr) : Boolean;
	    external;
	Function FindID(s : string) : IDPtr;
	    external;
	Function IsVariable(i : IDPtr) : Boolean;
	    external;
	Function GetLabel() : Integer;
	    external;
	Procedure ns;
	    external;
	Procedure Mismatch;
	    external;
	Function SimpleType(t : TypePtr): Boolean;
	    external;
	Function NumberType(t : TypePtr): Boolean;
	    external;
	Procedure AddConstant(Amount : Integer; Reg : Regs; Size : Byte);
	    External;
	Function ReadParameters(ID : IDPtr) : ExprPtr;
	    External;
	Function PushArguments(Args : ExprPtr; ToReg : Regs) : Integer;
	    External;
	Function PushFrame(Level : Integer) : Integer;
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

Procedure PushLongD0;
begin
    Out_Operation1(op_PUSH,4,ea_Register,d0);
    StackLoad := StackLoad + 4;
end;

Procedure PopLongD0;
begin
    Out_Operation1(op_POP,4,ea_Register,d0);
    StackLoad := StackLoad - 4;
end;


Procedure PopStackSpace(amount : Integer);
begin
    AddConstant(Amount, a7, 4);
    StackLoad := StackLoad - amount;
end;

Procedure PushWordD0;
begin
    Out_Operation1(op_PUSH,2,ea_Register,d0);
    StackLoad := StackLoad + 2;
end;

Procedure PushLongD1;
begin
    Out_Operation1(op_PUSH,4,ea_Register,d1);
    StackLoad := StackLoad + 4;
end;

Procedure PopLongD1;
begin
    Out_Operation1(op_POP,4,ea_Register,d1);
    StackLoad := StackLoad - 4;
end;

Procedure PushLongA0;
begin
    Out_Operation1(op_PUSH,4,ea_Register,a0);
    StackLoad := StackLoad + 4;
end;

Procedure PopLongA0;
begin
    Out_Operation1(op_POP,4,ea_Register,a0);
    StackLoad := StackLoad - 4;
end;

Procedure PopLongA1;
begin
    Out_Operation1(op_POP,4,ea_Register,a1);
    StackSpace := StackSpace - 4;
end;

Procedure DoRangeCheck(VarType : TypePtr);

{
	This routine is called from selector() when range checking
is turned on.  Notice that the code is now in a library, rather
than inline as it was in 1.0.  Also note that the library code fixes
the stack after the call.
}

begin
    Out_Operation1(op_PEA,3,ea_Absolute,a7);
    Out_Extension(VarType^.Lower);
    Out_Operation1(op_PEA,3,ea_Absolute,a7);
    Out_Extension(VarType^.Upper);
    Out_Operation1(op_JSR,3,ea_String,a7);
    Out_Extension(Integer("_p%CheckRange"));
end;

Function GetFramePointer(Reference : Integer) : Regs;
var
    Current : Integer;
begin
    Current := CurrentBlock^.Level;
    if Current = Reference then
	GetFramePointer := a5
    else begin
	Out_Operation2(op_MOVE,4,ea_Index,a5,ea_Register,a4);
	Out_Extension(8);
	Dec(Current);
	while Current > Reference do begin
	    Out_Operation2(op_MOVE,4,ea_Index,a4,ea_Register,a4);
	    Out_Extension(8);
	    Dec(Current);
	end;
	GetFramePointer := a4;
    end;
end;

Function LoadAddress : TypePtr;

{
	This is the routine used wherever I need the address of a
variable, for example reference parameters or the adr() function.
The address is loaded into a0.
}

var
    Expr	: ExprPtr;
begin
    NextFreeExprNode := 0;
    FreeAllRegisters;
    Expr := GetReference;
    Optimize(Expr);
    EvalAddress(Expr,a0);
    LoadAddress := Expr^.EType;
end;

Procedure CallProc(ProcID : IDPtr);

{
	This routine handles the nitty-gritty of calling a
	procedure.  A very similar routine exists in Evaluate
	called Eval_FunctionCall, which does most of the same
	stuff but accepts a return value.
}
var
    ArgSize : Integer;
    Args	: ExprPtr;
    OneArg	: ExprPtr;
begin
    NextSymbol;  { Read past procedure identifier }
    NextFreeExprNode := 0;

    Args := ReadParameters(ProcID);
    OneArg := Args;
    while OneArg <> Nil do begin
	Optimize(OneArg);
	OneArg := OneArg^.Next;
    end;

    FreeAllRegisters;

    ArgSize := PushArguments(Args, d0);

    ArgSize := ArgSize + PushFrame(ProcID^.Level);

    Out_Operation1(op_JSR,3,ea_Global,a7);
    Out_Extension(Integer(ProcID));

    PopStackSpace(ArgSize);

    MathLoaded := False;
end;
