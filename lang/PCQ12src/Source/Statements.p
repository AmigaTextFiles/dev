External;

{
	Statements.p (of PCQ Pascal)
	Copyright (c) 1989 Patrick Quaid

	This module handles normal statements, including the
	standard statements like if, while, case, etc.
}

{$O-}
{$I "Pascal.i"}

	Function Match(s : Symbols) : Boolean;
	    external;
	Function Expression : TypePtr;
	    external;
	Procedure Error(s : string);
	    external;
	Function TypeCheck(t1, t2 : TypePtr): Boolean;
	    external;
	Procedure SaveStack(t : TypePtr);
	    external;
	Procedure SaveVal(v : IDPtr);
	    external;
	Procedure ns;
	    external;
	Procedure NextSymbol;
	    external;
	Function GetLabel : Integer;
	    external;
	Procedure Mismatch;
	    external;
	Function LoadAddress : TypePtr;
	    external;
	Procedure CallProc(ProcID : IDPtr);
	    external;
	procedure StdProc(ID : IDPtr);
	    external;
	Function EndOfFile : Boolean;
	    external;
	Procedure ReadChar;
	    external;
	Function FindID(s : string): IDPtr;
	    external;
	Function IsVariable(i : IDPtr) : Boolean;
	    external;
	Function ConExpr(var t : TypePtr) : integer;
	    external;
	function BaseType(t : TypePtr) : TypePtr;
	    external;
	Procedure PromoteType(var f : TypePtr; o : TypePtr; r : Short);
	    external;
	Function NumberType(t : TypePtr): Boolean;
	    external;
	Procedure PushLongD0;
	    external;
	Procedure PushLongA0;
	    External;
	Procedure PopStackSpace(amount : Integer);
	    External;
	Function Selector(ID : IDPtr) : TypePtr;
	    external;
	Function FindWithField(s : String) : IDPtr;
	    External;
	Function CheckBreak : Boolean;
	    External;
	Procedure Abort;
	    External;
	Procedure Assignment;
	    External;
	Procedure AddConstant(Amount : Integer; ToReg : Regs; Size : Byte);
	    External;
	Function GetReference : ExprPtr;
	    External;
	Function ExpressionTree : ExprPtr;
	    External;
	Procedure EvalAddress(Expr : ExprPtr; ToReg : Regs);
	    External;
	Procedure Evaluate(Expr : ExprPtr; ToReg : Regs);
	    External;
	Function PromoteTypeA(Expr : ExprPtr; DestType : TypePtr) : ExprPtr;
	    External;
	Procedure Optimize(Expr : ExprPtr);
	    External;
	Function SimpleReference(Expr : ExprPtr) : Boolean;
	    External;
	Procedure FreeAllRegisters;
	    External;
	Procedure StoreValue(Expr, Dest : ExprPtr);
	    External;
	Procedure MarkRegister(reg : Regs);
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
	Procedure WriteSimpleSource(Expr : ExprPtr; op : OpCodes; Size : Byte;
					DestEA : EAModes; DestReg : Regs);
	    External;



Procedure Statement;
    forward;

Procedure ReturnVal;

{
	This is similar to the above, but the value is left in d0.
}

var
    ExprType	: TypePtr;
begin
    nextsymbol;
    if not Match(becomes1) then
	error("expecting :=");
    ExprType := Expression();
    if not TypeCheck(CurrFn^.VType, ExprType) then
	Mismatch;
    if NumberType(ExprType) then
	PromoteType(ExprType, CurrFn^.VType, 0);
    AddConstant(StackLoad, a7, 4);
    Out_Operation0(op_RESTORE);
    Out_Operation1(op_UNLK,3,ea_Register,a5);
    Out_Operation0(op_RTS);
end;

Procedure DoWhile;

{
	Handles the while statement.
}

var
    LoopLabel,
    ExitLabel	: Integer;
begin
    LoopLabel := GetLabel();
    ExitLabel := GetLabel();
    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(LoopLabel);
    MathLoaded := False;
    if not TypeCheck(Expression(), BoolType) then
	error("Expecting boolean expression");

    Out_Operation1(op_TST,1,ea_Register,d0);
    Out_Operation1(op_BEQ,3,ea_Label,a7);
    Out_Extension(ExitLabel);

    if not Match(Do1) then
	error("Missing DO");
    Statement;

    Out_Operation1(op_BRA,3,ea_Label,a7);
    Out_Extension(LoopLabel);

    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(ExitLabel);
end;

Procedure DoRepeat;

{
	Handles the repeat statement.
}

var
    RepLabel	: Integer;
begin
    RepLabel := GetLabel();
    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(RepLabel);

    MathLoaded := False;
    while not Match(until1) do begin
	Statement;
	ns;
    end;
    if not TypeCheck(Expression(), Booltype) then
	error("Expecting a Boolean expression.");

    Out_Operation1(op_TST,1,ea_Register,d0);
    Out_Operation1(op_BEQ,3,ea_Label,a7);
    Out_Extension(RepLabel);
end;

Procedure DoFor;

{
	handles the for statement.
}

var
    increment	: Short;
    Dest,
    Expr,
    IncExpr	: ExprPtr;
    BoundType	: TypePtr;
    NumberIndex : Boolean;
    STag	: Byte;
    InLabel,
    LoopLabel,
    DoneLabel	: Integer;
    Simple	: Boolean;
begin
    LoopLabel := GetLabel;  { Inc or Dec the index, getting ready to check }
    InLabel   := GetLabel;  { Check index against upper bound }
    DoneLabel := GetLabel;  { Done with loop, move along }

    NextFreeExprNode := 0;
    FreeAllRegisters;
    Dest := GetReference;
    if Dest^.EType^.Object <> ob_ordinal then
	Error("Expecting an ordinal type")
    else
	Optimize(Dest);
    if not Match(becomes1) then
	Error("missing :=");

    Expr := ExpressionTree;
    BoundType := Dest^.EType;
    STag := BoundType^.Size;

    NumberIndex := TypeCheck(BoundType, IntType);
    if TypeCheck(BoundType, Dest^.EType) then begin
	if NumberIndex then
	    Expr := PromoteTypeA(Expr, Dest^.EType);
	Optimize(Expr);
    end else
	Mismatch;

    if Match(to1) then
	increment := 1
    else if Match(downto1) then
	increment := -1
    else
	error("Expecting TO or DOWNTO");

    FreeAllRegisters;
    Simple := SimpleReference(Dest);
    StoreValue(Expr, Dest);		{ _must_ leave dest in A0 }
    if not Simple then
	PushLongA0;

    Out_Operation1(op_BRA,3,ea_Label,a7);
    Out_Extension(InLabel);

    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(LoopLabel);

    if Simple then begin
	if Increment > 0 then
	    WriteSimpleDest(Dest, op_ADDQ,STag,ea_Constant,a7,1,0)
	else
	    WriteSimpleDest(Dest, op_SUBQ,STag,ea_Constant,a7,1,0);
    end else begin
	Out_Operation2(op_MOVE,4,ea_Indirect,a7,ea_Register,a0);
	if Increment > 0 then
	    Out_Operation2(op_ADDQ,STag,ea_Constant,a7,ea_Indirect,a0)
	else
	    Out_Operation2(op_SUBQ,STag,ea_Constant,a7,ea_Indirect,a0);
	Out_Extension(1);
    end;

    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(InLabel);

    Expr := ExpressionTree;
    if TypeCheck(Expr^.EType, BoundType) then begin
	if NumberIndex then
	    Expr := PromoteTypeA(Expr, IntType);
	Optimize(Expr);
    end else
	Mismatch;

    FreeAllRegisters;
    Evaluate(Expr, d0);

    if Simple then
	WriteSimpleSource(Dest,op_CMP,STag,ea_Register,d0)
    else
	Out_Operation2(op_CMP,STag,ea_Indirect,a0,ea_Register,d0);

    if increment > 0 then
	Out_Operation1(op_BLT,3,ea_Label,a7)
    else
	Out_Operation1(op_BGT,3,ea_Label,a7);
    Out_Extension(DoneLabel);

    if not Match(do1) then
	Error("Missing DO");

    MathLoaded := False;
    Statement;

    Out_Operation1(op_BRA,3,ea_Label,a7);
    Out_Extension(LoopLabel);

    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(DoneLabel);

    if not Simple then
	PopStackSpace(4);
end;



Procedure DoReturn;

{
	This just takes care of return.
}

begin
    if CurrFn <> Nil then begin
	if CurrFn^.Object = proc then begin
	    AddConstant(StackLoad, a7, 4);
	    Out_Operation0(op_RESTORE);
	    Out_Operation1(op_UNLK,3,ea_Register,a5);
	    Out_Operation0(op_RTS);
	end else
	    error("return only allowed in procedures.");
    end else
	error("No return from the main procedure");
end;

Procedure Compound;

{
	This takes care of the begin...end syntax.
}

begin
    while not Match(end1) do begin
	Statement;
	if (CurrSym = Else1) or (CurrSym = Until1) then begin
	    Error("Expecting a statement");
	    NextSymbol;
	end;
	if CurrSym <> End1 then
	    ns;
    end;
end;

procedure DoIf;

{
	This handles the if statement.  Eventually it should handle
elsif.
}

var
    flab1, flab2	: integer;
begin
    flab1 := GetLabel();
    if not TypeCheck(Expression(), BoolType) then
	error("Expecting a Boolean type");
    Out_Operation1(op_TST,1,ea_Register,d0);
    Out_Operation1(op_BEQ,3,ea_Label,a7);
    Out_Extension(FLab1);

    if not Match(then1) then
	error("Missing THEN");
    Statement;

    if Match(else1) then begin
	flab2 := getlabel();
	Out_Operation1(op_BRA,3,ea_Label,a7);
	Out_Extension(FLab2);

	Out_Operation1(op_LABEL,3,ea_Label,a7);
	Out_Extension(FLab1);

	MathLoaded := False;
	Statement;

	Out_Operation1(op_LABEL,3,ea_LABEL,a7);
	Out_Extension(FLab2);
    end else begin
	Out_Operation1(op_LABEL,3,ea_LABEL,a7);
	Out_Extension(FLab1);
    end;
    MathLoaded := False;
end;

procedure DoCase;

    procedure DoRange(first, second, lab, typesize : Integer);
    var
	otherlabel : Integer;
    begin
	otherlabel := GetLabel();
	Out_Operation2(op_CMP,TypeSize,ea_Constant,a7,ea_Register,d0);
	Out_Extension(First);

	Out_Operation1(op_BLT,3,ea_Label,a7);
	Out_Extension(OtherLabel);

	Out_Operation2(op_CMP,TypeSize,ea_Constant,a7,ea_Register,d0);
	Out_Extension(Second);

	Out_Operation1(op_BLE,3,ea_Label,a7);
	Out_Extension(Lab);

	Out_Operation1(op_LABEL,3,ea_Label,a7);
	Out_Extension(OtherLabel);
    end;

    procedure DoSingle(number, lab, typesize : Integer);
    begin
	Out_Operation2(op_CMP,TypeSize,ea_Constant,a7,ea_Register,d0);
	Out_Extension(Number);

	Out_Operation1(op_BEQ,3,ea_Label,a7);
	Out_Extension(Lab);
    end;

    Procedure DoCases(ctype : TypePtr; codelabel : Integer);
    var
	firstnumber, secondnumber : Integer;
	contype : TypePtr;
	Quit	: Boolean;
    begin
	Quit := False;
	repeat
	    firstnumber := ConExpr(ConType);
	    if not TypeCheck(ConType, ctype) then begin
		Mismatch;
		return;
	    end;
	    if Match(dotdot1) then begin
		secondnumber := conexpr(contype);
		if not typecheck(ctype, contype) then begin
		    mismatch;
		    return;
		end;
		dorange(firstnumber, secondnumber, codelabel,ctype^.Size);
	    end else
		dosingle(firstnumber, codelabel, ctype^.size);
	    if currsym <> colon1 then
		if not match(comma1) then begin
		    error("Expecting : or ,");
		    return;
		end;
	until Match(Colon1);
    end;

var
    casetype : TypePtr;
    outofcases, nextsetlabel, codelabel : Integer;
begin
    CaseType := Expression();
    if CaseType^.Object <> ob_ordinal then
	error("Expecting an ordinal type");
    if not match(of1) then
	error("Missing 'of'");
    outofcases := GetLabel();
    while (currsym <> end1) and (currsym <> else1) and (not endoffile()) do begin
	NextSetLabel := GetLabel();
	CodeLabel := GetLabel();
	DoCases(CaseType, CodeLabel);

	Out_Operation1(op_BRA,3,ea_Label,a7);
	Out_Extension(NextSetLabel);

	Out_Operation1(op_LABEL,3,ea_Label,a7);
	Out_Extension(CodeLabel);

	MathLoaded := False;
	Statement;
	if (CurrSym <> Else1) and (CurrSym <> End1) then
	    ns;

	Out_Operation1(op_BRA,3,ea_Label,a7);
	Out_Extension(OutOfCases);

	Out_Operation1(op_LABEL,3,ea_Label,a7);
	Out_Extension(NextSetLabel);
    end;
    if Match(else1) then
	if CurrSym <> end1 then begin
	    Statement;
	    ns;
	end;
    if not Match(end1) then
	Error("Expecting 'end'");

    Out_Operation1(op_LABEL,3,ea_Label,a7);
    Out_Extension(OutOfCases);
end;

Procedure DoWith;
var
    TempRec,
    FirstRec : WithRecPtr;
    Stay    : Boolean;
begin
    FirstRec := Nil;
    repeat
	New(TempRec);
	if FirstRec = Nil then
	    FirstRec := TempRec;
	TempRec^.Previous := FirstWith;
	TempRec^.RecType := LoadAddress;
	FirstWith := TempRec;
	if FirstWith^.RecType^.Object <> ob_record then
	    Error("Expecting a record type");
	PushLongA0;
	FirstWith^.Offset := StackLoad;
	Stay := Match(Comma1);
    until not Stay;
    if not Match(Do1) then
	Error("Missing DO");
    Statement;
    repeat
	Stay := FirstWith <> FirstRec;
	TempRec := FirstWith^.Previous;
	Dispose(FirstWith);
	FirstWith := TempRec;
	PopStackSpace(4);
    until not Stay;
end;

Procedure DoGoto;
var
    ID : IDPtr;
begin
    if CurrSym = Ident1 then begin
	ID := FindID(SymText);
	if ID <> Nil then begin
	    if ID^.Object = lab then begin
		if ID^.Level = CurrentBlock^.Level then begin
		    Out_Operation1(op_BRA,3,ea_Label,a7);
		    Out_Extension(ID^.Unique);
		    NextSymbol;
		end else
		    Error("You cannot jump out of scopes");
	    end else
		Error("Expecting a label");
	end else
	    Error("Unknown ID");
    end else
	Error("Expecting a comment");
end;

Procedure Statement;

{
	This is the main routine for handling statements of all
sorts.  It distributes the work as necessary.
}

var
    VarIndex	: IDPtr;
begin
    if EndOfFile() then
	return;
    VarIndex := Nil;
    if CurrSym = Ident1 then begin { Handle label prefix }
	VarIndex := FindWithField(SymText);
	if VarIndex = Nil then
	    VarIndex := FindID(SymText);
	if VarIndex <> Nil then begin
	    if VarIndex^.Object = lab then begin
		Out_Operation1(op_LABEL,3,ea_Label,a7);
		Out_Extension(VarIndex^.Unique);
		NextSymbol;
		if not Match(Colon1) then
		    Error("Missing colon");
		VarIndex := Nil;
	    end;
	end else
	    Error("Unknown ID");
    end;
    if CurrSym = Ident1 then begin
	if VarIndex = Nil then begin { if not Nil, we found it above }
	    VarIndex := FindWithField(SymText);
	    if VarIndex = Nil then
		VarIndex := FindID(symtext);
	end;
	if varindex = nil then begin
	    error("unknown ID");
	    while (currsym <> semicolon1) and
		  (currsym <> end1) and
		  (currentchar <> chr(10)) do
		nextsymbol;
	end else if IsVariable(VarIndex) then
	    assignment
	else if VarIndex^.Object = proc then
	    callproc(varindex)
	else if VarIndex^.Object = stanproc then
	    stdproc(varindex)
	else if varindex = currfn then begin
	    if currfn^.Object = func then
		returnval
	    else begin
		Error("Expecting a variable or procedure.");
		NextSymbol;
	    end;
	end else begin
	    error("expecting a variable or procedure.");
	    while (currsym <> semicolon1) and
		  (currsym <> end1) and
		  (currentchar <> chr(10)) do
		nextsymbol;
	    if currsym = semicolon1 then
		nextsymbol;
	end;
    end else if match(begin1) then begin
	Compound;
    end else if match(if1) then begin
	DoIf;
    end else if match(while1) then begin
	DoWhile;
    end else if match(repeat1) then begin
	DoRepeat;
    end else if match(for1) then begin
	DoFor;
    end else if match(case1) then begin
	DoCase;
    end else if match(return1) then begin
	DoReturn;
    end else if Match(With1) then begin
	DoWith;
    end else if Match(Goto1) then begin
	DoGoto;
    end else if (CurrSym <> SemiColon1) and (CurrSym <> End1) and
		(CurrSym <> Else1) and (CurrSym <> Until1) then begin
	Error("Expecting a statement");
	while (CurrSym <> SemiColon1) and
	      (CurrSym <> End1) and
	      (CurrSym <> Else1) and
	      (CurrSym <> Until1) and
	      (currentchar <> chr(10)) do
	    NextSymbol;
    end else
	if CheckBreak then
	    Abort;
end;
