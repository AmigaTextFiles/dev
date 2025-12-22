External;

{
	Stanprocs.p (of PCQ Pascal)
	Copyright (c) 1989 Patrick Quaid

	This routine implements the various standard procedures,
	hence the name.
}

{$O-}
{$I "Pascal.i"}

	Procedure NextSymbol;
	    external;
	Function Match(s : Symbols): Boolean;
	    external;
	Procedure Error(s : string);
	    external;
	Function Expression : TypePtr;
	    external;
	Function ConExpr(VAR t : TypePtr): Integer;
	    external;
	Function GetReference : ExprPtr;
	    External;
	Procedure EvalAddress(Expr : ExprPtr; ToReg : Regs);
	    External;
	Function SimpleReference(Expr : ExprPtr) : Boolean;
	    External;
	Procedure FreeAllRegisters;
	    External;
	Procedure MarkRegister(Reg : Regs);
	    External;
	Procedure Optimize(Expr : ExprPtr);
	    External;
	Function TypeCmp(t1, t2 : TypePtr): Boolean;
	    external;
	Function TypeCheck(t1, t2 : TypePtr): Boolean;
	    external;
	Function LoadAddress : TypePtr;
	    external;
	Procedure Mismatch;
	    external;
	Procedure UsingSmallStartup;
	    External;
	Procedure NeedLeftParent;
	    external;
	Procedure NeedRightParent;
	    external;
	Procedure NeedNumber;
	    external;
	Function FindID(s : string) : IDPtr;
	    external;
	Function FindWithField(s : String) : IDPtr;
	    External;
	Procedure SaveStack(TP : TypePtr);
	    external;
	Procedure SaveVal(ID : IDPtr);
	    external;
	Procedure ns;
	    external;
	Procedure PromoteType(var f : TypePtr; o : TypePtr; r : Short);
	    external;
	Function NumberType(t : TypePtr): Boolean;
	    external;
	Procedure PushLongD0;
	    external;
	Procedure PushWordD0;
	    external;
	Procedure PopLongD1;
	    external;
	Procedure PopStackSpace(amount : Integer);
	    External;
	Procedure PushLongA0;
	    External;
	Function Suffix(size : Integer) : Char;
	    External;
	Procedure AddConstant(Amount : Integer; ToReg : Regs; Size : Byte);
	    External;
	Function PromoteTypeA(Expr : ExprPtr; TP : TypePtr) : ExprPtr;
	    External;
	Function ExpressionTree : ExprPtr;
	    External;
	Procedure Evaluate(Expr : ExprPtr; ToReg : Regs);
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
	Procedure WriteSimpleDest(Expr : ExprPtr; op : OpCodes; Size : Byte;
				SrcEA : EAModes; SrcReg : Regs;
				SExt1, SExt2 : Integer);
	    External;



Procedure CallCheckIO;
begin
    Out_Operation1(op_JSR,3,ea_String,a7);
    Out_Extension(Integer("_p%CheckIO"));
end;

Procedure CallWrite(TP : TypePtr);

{
	This routine calls the appropriate library routine to write
vartype to a text file.
}

var
    ElementType	: TypePtr;
begin
    if TypeCmp(TP, RealType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%WriteReal"));
    end else if NumberType(TP) then begin
	PromoteType(TP, IntType, 0);
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%WriteInt"));
    end else if TypeCmp(TP, CharType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%WriteChar"));
    end else if TypeCmp(TP, BoolType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%WriteBool"));
    end else if TP^.Object = ob_array then begin
	ElementType := TP^.SubType;
	if TypeCmp(ElementType, CharType) then begin
	    Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d3);
	    Out_Extension(Succ(TP^.Upper - TP^.Lower));
	    Out_Operation1(op_JSR,3,ea_String,a7);
	    Out_Extension(Integer("_p%WriteCharray"));
	end else
	    Error("Write() can only write arrays of char");
    end else if TP = StringType then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%WriteString"));
    end else
	Error("can't write that type to text file");
    if IOCheck then
	CallCheckIO;
    MathLoaded := False;
end;

Procedure FileWrite(TP : TypePtr);

{
	This routine writes a variable to a File of TP
}

begin
    Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d3);
    Out_Extension(TP^.Size);
    Out_Operation1(op_JSR,3,ea_String,a7);
    Out_Extension(Integer("_p%WriteArb"));
    if IOCheck then
	CallCheckIO;
    MathLoaded := False;
end;

Procedure DoWrite(ID : IDPtr);

{
	This routine handles all aspects of the write and writeln
statements.
}

var
    FileType	: TypePtr; { file type if there is one }
    ExprType	: TypePtr; { current element type }
    Pushed	: Boolean; { have pushed the file handle on stack }
    Width	: Integer; { constant field width }
    WidType     : TypePtr; { type of the above }
begin
    if SmallInitialize then
	UsingSmallStartup;
    if Match(LeftParent1) then begin
	FileType := Expression();
	Pushed := True;
	if FileType^.Object = ob_file then
	    PushLongD0
	else begin
	    Out_Operation1(op_PUSH,4,ea_String,a7);
	    Out_Extension(Integer("#_Output"));
	    StackLoad := StackLoad + 4;
	    if Match(colon1) then begin
		PushLongD0;
		WidType := Expression();
		if not TypeCheck(IntType, WidType) then
		    NeedNumber
		else
		    PromoteType(WidType,ShortType,0);
		PopLongD1;
		PushWordD0;
		Out_Operation2(op_MOVE,4,ea_Register,d1,ea_Register,d0);
	    end else begin
		Out_Operation1(op_PUSH,2,ea_Constant,a7);
		Out_Extension(0);
		StackLoad := StackLoad + 2;
	    end;
	    if TypeCmp(FileType, RealType) then begin
		if Match(colon1) then begin
		    PushLongD0;
		    WidType := Expression();
		    if not TypeCheck(IntType, WidType) then
			NeedNumber
		    else
			PromoteType(WidType,ShortType,0);
		    PopLongD1;
		    PushWordD0;
		    Out_Operation2(op_MOVE,4,ea_Register,d1,ea_Register,d0);
		end else begin
		    Out_Operation1(op_PUSH,2,ea_Constant,a7);
		    Out_Extension(2);
		    StackLoad := StackLoad + 2;
		end;
	    end;
	    CallWrite(FileType);
	    if TypeCmp(FileType, RealType) then
		PopStackSpace(4)
	    else
		PopStackSpace(2);
	    FileType := TextType;
	end;
	while not Match(RightParent1) do begin
	    if not Match(Comma1) then
		Error("expecting , or )");
	    ExprType := Expression();
	    if FileType = TextType then begin
		if Match(Colon1) then begin
		    PushLongD0;
		    WidType := Expression();
		    if not TypeCheck(IntType, WidType) then
			NeedNumber
		    else
			PromoteType(WidType,ShortType,0);
		    PopLongD1;
		    PushWordD0;
		    Out_Operation2(op_MOVE,4,ea_Register,d1,ea_Register,d0);
		end else begin
		    Out_Operation1(op_PUSH,2,ea_Constant,a7);
		    Out_Extension(0);
		    StackLoad := StackLoad + 2;
		end;
		if TypeCmp(ExprType, RealType) then begin
		    if Match(colon1) then begin
			PushLongD0;
			WidType := Expression();
			if not TypeCheck(IntType, WidType) then
			    NeedNumber
			else
			    PromoteType(WidType,ShortType,0);
			PopLongD1;
			PushWordD0;
			Out_Operation2(op_MOVE,4,ea_Register,d1,ea_Register,d0);
		    end else begin
			Out_Operation1(op_PUSH,2,ea_Constant,a7);
			Out_Extension(2);
			StackLoad := StackLoad + 2;
		    end;
		end;
		CallWrite(ExprType);
		if TypeCmp(ExprType, RealType) then
		    PopStackSpace(4)
		else
		    PopStackSpace(2);
	    end else begin
		if TypeCmp(FileType^.SubType, ExprType) then
		    FileWrite(ExprType)
		else
		    Mismatch;
	    end;
	end;
    end else begin
	FileType := TextType;
	Pushed := False;
	if ID^.Offset = 1 then
	    error("'write' requires arguments.");
    end;
    if ID^.Offset = 2 then begin
	if FileType = TextType then begin
	    if Pushed then begin
		Out_Operation1(op_JSR,3,ea_String,a7);
		Out_Extension(Integer("_p%WriteLn"));
	    end else begin
		Out_Operation1(op_PUSH,4,ea_String,a7);
		Out_Extension(Integer("#_Output"));
		Out_Operation1(op_JSR,3,ea_String,a7);
		Out_Extension(Integer("_p%WriteLn"));
		AddConstant(4, a7, 4);
	    end;
	    if IOCheck then
		CallCheckIO;
	end else
	   error("Writeln is only for text files");
    end;
    if Pushed then
	PopStackSpace(4);
end;

Procedure CallRead(TP : TypePtr);

{
	This routine calls the appropriate library routines to read
the vartype from a text file.
}

begin
    if TypeCmp(TP, CharType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%ReadChar"));
    end else if TypeCmp(TP, IntType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%ReadInt"));
	Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Indirect,a0);
    end else if TypeCmp(TP, ShortType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%ReadInt"));
	Out_Operation2(op_MOVE,2,ea_Register,d0,ea_Indirect,a0);
    end else if TypeCmp(TP, ByteType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%ReadInt"));
	Out_Operation2(op_MOVE,1,ea_Register,d0,ea_Indirect,a0);
    end else if TypeCmp(TP, RealType) then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%ReadReal"));
    end else if TP^.Object = ob_array then begin
	if TypeCmp(TP^.SubType, chartype) then begin
	    Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d3);
	    Out_Extension(Succ(TP^.Upper - TP^.Lower));
	    Out_Operation1(op_JSR,3,ea_String,a7);
	    Out_Extension(Integer("_p%ReadCharray"));
	end else
	    Error("can only read character arrays");
    end else if TP = StringType then begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%ReadString"));
    end else
	Error("cannot read that type from a text file");
    if IOCheck then
	CallCheckIO;
    MathLoaded := False; { Overwritten by DOSBase }
end;

Procedure DoRead(ID : IDPtr);

{
	This handles the read statement.  Note that read(f, var) from a
non-text file really does end up being var := f^; get(f).  Same
goes for text files, but it's all handled within the library.
	Note the difference between this and dowrite(),
specifically the use of expression() up there and loadaddress()
here.
}

var
    FileType,
    VarType	: TypePtr;
    Pushed	: Boolean;
begin
    if SmallInitialize then
	UsingSmallStartup;
    if Match(LeftParent1) then begin
	FileType := LoadAddress();
	Pushed := True;
	if FileType^.Object = ob_file then
	    PushLongA0
	else begin
	    Out_Operation1(op_PUSH,4,ea_String,a7);
	    Out_Extension(Integer("#_Input"));
	    StackLoad := StackLoad + 4;
	    CallRead(FileType);
	    FileType := TextType;
	end;
	while not Match(RightParent1) do begin
	    if not Match(Comma1) then
		Error("expecting , or )");
	    VarType := LoadAddress();
	    if FileType = TextType then
		CallRead(VarType)
	    else begin
		if TypeCmp(FileType^.SubType, VarType) then begin
		    Out_Operation1(op_JSR,3,ea_String,a7);
		    Out_Extension(Integer("_p%ReadArb"));
		end else
		    Mismatch;
		if IOCheck then
		    CallCheckIO;
	    end;
	end;
    end else begin
	FileType := TextType;
	Pushed := False;
	if ID^.Offset = 3 then
	    error("'read' requires arguments.");
    end;
    if ID^.Offset = 4 then begin
	if TypeCmp(FileType, TextType) then begin
	    if Pushed then begin
		Out_Operation1(op_JSR,3,ea_String,a7);
		Out_Extension(Integer("_p%ReadLn"));
	    end else begin
		Out_Operation1(op_PUSH,4,ea_String,a7);
		Out_Extension(Integer("#_Input"));
		Out_Operation1(op_JSR,3,ea_String,a7);
		Out_Extension(Integer("_p%ReadLn"));
		AddConstant(4, a7, 4);
	    end;
	    if IOCheck then
		CallCheckIO;
	end else
	   error("Readln applies only to Text files");
    end;
    if Pushed then
	PopStackSpace(4);
end;

Procedure DoNew;

{
	This just handles allocation of memory.
}

var
    Expr	: ExprPtr;
begin
    NeedLeftParent;
    NextFreeExprNode := 0;
    ConstantExpression := False;
    Expr := GetReference;
    Optimize(Expr);
    if Expr^.EType^.Object <> ob_pointer then
	Error("Expecting a pointer type")
    else begin
	Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Register,d0);
	Out_Extension(Expr^.EType^.SubType^.Size);
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%new"));

	if SimpleReference(Expr) then begin
	    WriteSimpleDest(Expr, op_MOVE,4,ea_Register,d0,0,0);
	end else begin
	    FreeAllRegisters;
	    MarkRegister(d0);
	    EvalAddress(Expr, a0);
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Indirect,a0);
	end;
    end;
    NeedRightParent;
    MathLoaded := False;
    if SmallInitialize then
	UsingSmallStartup;
end;

Procedure DoDispose;

{
	This routine calls the library routine that frees memory.
}

var
    ExprType	: TypePtr;
begin
    NeedLeftParent;
    ExprType := Expression();
    if ExprType^.Object <> ob_pointer then
	Error("Expecting a pointer type")
    else begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%dispose"));
    end;
    NeedRightParent;
    MathLoaded := False;
    if SmallInitialize then
	UsingSmallStartup;
end;

Procedure DoClose;

{
	Closes a file.  The difference between this and a normal
DOS close is that this routine must un-link the file from the
program's open file list.
}

var
    ExprType	: TypePtr;
begin
    NeedLeftParent;
    ExprType := LoadAddress();
    if ExprType^.Object <> ob_file then
	Error("Expecting a file type")
    else begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%Close"));
    end;
    if IOCheck then
	CallCheckIO;
    NeedRightParent;
    MathLoaded := False;
    if SmallInitialize then
	UsingSmallStartup;
end;

Procedure DoGet;

{
	This implements get.
}

var
    ExprType	: TypePtr;
begin
    NeedLeftParent;
    ExprType := LoadAddress();
    if ExprType^.Object <> ob_file then
	Error("Expecting a file type")
    else begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%Get"));
    end;
    if IOCheck then
	CallCheckIO;
    NeedRightParent;
    MathLoaded := False;
    if SmallInitialize then
	UsingSmallStartup;
end;

Procedure DoPut;

{
	This just implements put.  The real guts of these two
routines is in the runtime library.
}

var
    ExprType	: TypePtr;
begin
    NeedLeftParent;
    ExprType := LoadAddress();
    if ExprType^.Object <> ob_file then
	Error("Expecting a file type")
    else begin
	Out_Operation1(op_JSR,3,ea_String,a7);
	Out_Extension(Integer("_p%Put"));
    end;
    if IOCheck then
	CallCheckIO;
    NeedRightParent;
    MathLoaded := False;
    if SmallInitialize then
	UsingSmallStartup;
end;

Procedure DoIncDec(op : OpCodes);

{
	This takes care of Inc.
}

var
    Dest	: ExprPtr;
    Delta	: Integer;
    Expr	: ExprPtr;
    IsSimple	: Boolean;
    DSize	: Short;
    Shifts	: Short;
begin
    NeedLeftParent;
    NextFreeExprNode := 0;
    FreeAllRegisters;
    Dest := GetReference;
    Optimize(Dest);

    with Dest^.EType^ do begin
	if Object = ob_Ordinal then begin
	    Delta := 1;
	    DSize := Size;
	end else if Object = ob_pointer then begin
	    Delta := SubType^.Size;
	    DSize := Size;
	end else begin
	    Error("Expecting an ordinal or pointer type");
	    DSize := 1;
	    Delta := 1;
	end;
    end;

    if match(comma1) then begin
	Expr := ExpressionTree;
	if TypeCheck(Expr^.EType, IntType) then begin
	    case DSize of
	      2 : Expr := PromoteTypeA(Expr,ShortType);
	      4 : Expr := PromoteTypeA(Expr,IntType);
	    end;
	    Optimize(Expr);
	end else
	    MisMatch;
    end else
	Expr := Nil;

    NeedRightParent;

    IsSimple := SimpleReference(Dest);

    if not IsSimple then
	EvalAddress(Dest,a0);

    if (Expr = Nil) or (Expr^.Kind = Const1) then begin
	if Expr <> Nil then
	    Delta := Expr^.Value * Delta;

	if Delta = 0 then
	    return;

	if (Delta < 0) and (Delta >= -8) then begin
	    Delta := -Delta;
	    if Op = op_SUB then
		Op := op_ADD
	    else
		Op := op_SUB;
	end;

	if (Abs(Delta) <= 127) and (Abs(Delta) > 8) then begin
	    Out_Operation2(op_MOVEQ,3,ea_Constant,a7,ea_Register,d0);
	    Out_Extension(Delta);
	    if IsSimple then
		WriteSimpleDest(Dest, Op, DSize, ea_Register,d0,0,0)
	    else
		Out_Operation2(Op, DSize, ea_Register,d0,
							ea_Indirect,a0);
	end else if IsSimple then
	    WriteSimpleDest(Dest,Op,DSize,ea_Constant,a7,Delta,0)
	else begin
	    Out_Operation2(Op,DSize, ea_Constant,a7,ea_Indirect,a0);
	    Out_Extension(Delta);
	end;
    end else begin { not a constant increment }
	if Expr^.EType^.Size = 1 then begin
	    Expr := PromoteTypeA(Expr,ShortType);
	    Optimize(Expr);
	end;
	Evaluate(Expr, d0);
	case Delta of
	     1 : Shifts := 0;
	     2 : Shifts := 1;
	     4 : Shifts := 2;
	     8 : Shifts := 3;
	    16 : Shifts := 4;
	    32 : Shifts := 5;
	    64 : Shifts := 6;
	   128 : Shifts := 7;
	   256 : Shifts := 8;
	   512 : Shifts := 9;
	  1024 : Shifts := 10;
	  2048 : Shifts := 11;
	  4096 : Shifts := 12;
	  8192 : Shifts := 13;
	 16384 : Shifts := 14;
	 32768 : Shifts := 15;
	 65536 : Shifts := 16;
	else begin
	         Out_Operation2(op_MULS,3,ea_Constant,a7,ea_Register,d0);
		 Out_Extension(Delta);
		 Shifts := -1;
	     end;
	end;

	if Shifts > 7 then begin
	    Out_Operation2(op_MOVEQ,3,ea_Constant,a7,ea_Register,d1);
	    Out_Extension(Shifts);
	    Out_Operation2(op_LSL,DSize,ea_Register,d1,ea_Register,d0);
	end else if Shifts > 0 then begin
	    Out_Operation2(op_LSL,DSize,ea_Constant,a7,ea_Register,d0);
	    Out_Extension(Shifts);
	end;

	if IsSimple then
	    WriteSimpleDest(Dest,Op,DSize,ea_Register,d0,0,0)
	else begin
	    Out_Operation2(Op, DSize, ea_Constant,a7,ea_Indirect,a0);
	    Out_Extension(Delta);
	end;
    end;
end;

Procedure DoExit;

{
	Just calls the routine that allows the graceful shut-down
of the program.
}

var
    Expr : ExprPtr;
begin
    if Match(LeftParent1) then begin
	NextFreeExprNode := 0;
	ConstantExpression := False;
	Expr := ExpressionTree;
	Optimize(Expr);
	if TypeCheck(Expr^.EType, IntType) then
	    Expr := PromoteTypeA(Expr, IntType)
	else
	    Error("Expecting an integer argument");
	FreeAllRegisters;
	Evaluate(Expr,d0);
	NextFreeExprNode := 0;
	NeedRightParent;
    end else begin
	Out_Operation2(op_MOVEQ,3,ea_Constant,a7,ea_Register,d0);
	Out_Extension(0);
    end;
    Out_Operation1(op_JSR,3,ea_String,a7);
    Out_Extension(Integer("_p%exit"));
    MathLoaded := False;
end;

Procedure DoTrap;

{
	This is just for debugging a program.  Use some trap, and
your debugger will stop at that statement.
}

var
    ExprType  : TypePtr;
    TrapNum   : Integer;
begin
    NeedLeftParent;
    TrapNum := ConExpr(ExprType);
    Out_Operation1(op_TRAP,3,ea_Constant,a7);
    Out_Extension(TrapNum);
    NeedRightParent;
end;


Procedure DoFileOpen(Which : Integer);
var
    FName : ExprPtr;
    FVar  : ExprPtr;
    Buffer: ExprPtr;
    RecSize : Integer;
begin
    NeedLeftParent;
    NextFreeExprNode := 0;
    ConstantExpression := False;

    FVar := GetReference;
    if FVar^.EType^.Object = ob_file then begin
	Optimize(FVar);
	RecSize := FVar^.EType^.SubType^.Size;
    end else begin
	Error("Expecting a file type");
	RecSize := 1;
    end;

    if not match(comma1) then
	Error("Missing comma");

    FName := ExpressionTree;
    if TypeCheck(StringType,FName^.EType) then begin
	Optimize(FName);
	FreeAllRegisters;
	Evaluate(FName, d0);
	Out_Operation1(op_PUSH,4,ea_Register,d0);
	StackLoad := StackLoad + 4;
    end else
	Mismatch;

    FreeAllRegisters;
    if FVar^.EType^.Object = ob_file then
	EvalAddress(FVar, a0);

    Out_Operation2(op_MOVE,2,ea_Constant,a7,ea_Index,a0);

    if Which = 14 then		{ reset - MODE_OLDFILE}
	Out_Extension(1005)
    else
	Out_Extension(1006);	{ rewrite - MODE_NEWFILE}
    Out_Extension(30);		{ ACCESS(a0) }

    if RecSize <= 127 then begin
	Out_Operation2(op_MOVEQ,3,ea_Constant,a7,ea_Register,d0);
	Out_Extension(RecSize);
	Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Index,a0);
    end else begin
	Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Index,a0);
	Out_Extension(RecSize);
    end;
    Out_Extension(24);

    if match(comma1) then begin
	Buffer := ExpressionTree;
	if TypeCheck(Buffer^.EType,IntType) then begin
	    Optimize(Buffer);
	    Evaluate(Buffer,d0);
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Index,a0);
	end else
	    Mismatch;
    end else begin
	Out_Operation2(op_MOVE,4,ea_Constant,a7,ea_Index,a0);
	Out_Extension(128);
    end;
    Out_Extension(20);

    Out_Operation1(op_PUSH,4,ea_Register,a0);

    Out_Operation1(op_JSR,3,ea_String,a7);
    Out_Extension(Integer("_p%OpenB"));

    AddConstant(8, a7, 4);
    StackLoad := StackLoad - 4; { we only added for FName }
    NeedRightParent;
end;

Procedure StdProc(ProcID : IDPtr);

{
	This routine sifts out the proper routine to call.
}

begin
    NextSymbol;
    case ProcID^.Offset of
      1,2 : DoWrite(ProcID);
      3,4 : DoRead(ProcID);
      5   : DoNew;
      6   : DoDispose;
      7   : DoClose;
      8   : DoGet;
      9   : DoExit;
      10  : DoTrap;
      11  : DoPut;
      12  : DoIncDec(op_ADD);
      13  : DoIncDec(op_SUB);
      14,
      15  : DoFileOpen(ProcID^.Offset);
    end;
end;

