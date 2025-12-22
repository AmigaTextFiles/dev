External;

{$I "Pascal.i"}

	Function TypeCheck(l, r : TypePtr) : Boolean;
	    External;
	Function TypeCmp(l, r : TypePtr) : Boolean;
	    External;
	Procedure ReadChar;
	    External;
	Procedure NextSymbol;
	    External;
	Procedure Error(s : string);
	    External;
	Procedure Abort;
	    External;
	Function Match(s : Symbols): Boolean;
	    External;
	Function FindID(s : string) : IDPtr;
	    External;
	Function FindField(s : string; TP : TypePtr): IDPtr;
	    External;
	Function FindWithField(S : String) : IDPtr;
	    External;
	Procedure Mismatch;
	    External;
	Procedure NeedRightParent;
	    External;
	Procedure NeedLeftParent;
	    External;
	Procedure NeedNumber;
	    External;
	Function NumberType(l : TypePtr) : Boolean;
	    External;
	Function BaseType(b : TypePtr): TypePtr;
	    External;
	Function SimpleType(t : TypePtr) : Boolean;
	    External;
	Function EnterStandard(	st_Name : String;
				st_Object : IDObject;
				st_Type : TypePtr;
				st_Storage : IDStorage;
				st_Offset : Integer) : IDPtr;
	    External;

Function GetExpressionNode : ExprPtr;
var
    Expr : ExprPtr;
begin
    if NextFreeExprNode <= MaxExprNodes then begin
	Expr := Adr(ExpressionNodeStore[NextFreeExprNode]);
	Inc(NextFreeExprNode);
	GetExpressionNode := Expr;
    end else begin
	New(Expr);
	GetExpressionNode := Expr;
    end;
end;

Procedure FreeExpressionNode(Expr : ExprPtr);
begin
    Expr^.Used := False;
end;

Function MakeNode(Op : Symbols; L, R : ExprPtr; TP : TypePtr; Val : Integer) : ExprPtr;
var
    Expr : ExprPtr;
begin
    Expr := GetExpressionNode;
    with Expr^ do begin
	Kind	:= Op;
	Next	:= Nil;
	Left	:= L;
	Right	:= R;
	EType	:= BaseType(TP);
	Value	:= Val;
    end;
    MakeNode := Expr;
end;

Function MakeBinary(Op : Symbols; L, R : ExprPtr; TP : TypePtr) : ExprPtr;
begin
    MakeBinary := MakeNode(Op,L,R,TP,0);
end;

Function MakeCommutativeBinary(Op : Symbols; L, R : ExprPtr; TP : TypePtr) : ExprPtr;
begin
    if L^.Kind = Const1 then
	MakeCommutativeBinary := MakeNode(Op, L, R, TP, 0);
    if R^.Kind = Const1 then
        MakeCommutativeBinary := MakeNode(Op, R, L, TP, 0);
    if (L^.Kind = Var1) or (L^.Kind = Period1) then
	MakeCommutativeBinary := MakeNode(Op, L, R, TP, 0);
    MakeCommutativeBinary := MakeNode(Op, R, L, TP, 0);
end;

Function MakeConstant(Val : Integer; TP : TypePtr) : ExprPtr;
begin
    if (TP = StringType) or (TP^.Object = ob_array) then
	MakeConstant := MakeNode(Quote1, Nil, Nil, TP, Val)
    else
	MakeConstant := MakeNode(Const1, Nil, Nil, TP, Val);
end;

Function MakeVariable(ID : IDPtr; TP : TypePtr) : ExprPtr;
begin
    MakeVariable := MakeNode(Var1, Nil, Nil, TP, Integer(ID));
end;

Function CommonType(type1, type2 : TypePtr) : TypePtr;
begin
    Type1 := BaseType(Type1);
    Type2 := BaseType(Type2);
    if (Type1 = BadType) or (Type2 = BadType) then
        CommonType := BadType;
    if (Type1 = RealType) or (Type2 = RealType) then
        CommonType := RealType;
    if (Type1 = IntType) or (Type2 = IntType) then
        CommonType := IntType;
    if (Type1 = ShortType) or (Type2 = ShortType) then
	CommonType := ShortType;
    if (Type1 = ByteType) or (Type2 = ByteType) then
	CommonType := ByteType;
    CommonType := Type1; { What else is there? }
end;

Function PromoteTypeA(Expr : ExprPtr; TP : TypePtr) : ExprPtr;
var
    Common : TypePtr;
begin
    Common := CommonType(Expr^.EType, TP);
    if (Common = Expr^.EType) or (Common = BadType) then
        PromoteTypeA := Expr;

    if Common = RealType then
	PromoteTypeA := MakeBinary(int2real, PromoteTypeA(Expr, IntType),
				Nil, RealType)
    else if Common = IntType then
	PromoteTypeA := MakeBinary(short2long, PromoteTypeA(Expr, ShortType),
					Nil, IntType)
    else if Common = ShortType then
	PromoteTypeA := MakeBinary(byte2short, Expr, Nil, ShortType)
    else
	PromoteTypeA := Expr;
end;

Procedure CheckNumeric(Expr : ExprPtr);
begin
    if not NumberType(Expr^.EType) then begin
	NeedNumber;
        Expr^.EType := BadType;
    end;
end;

Procedure CheckType(Left, Right : ExprPtr);
begin
    if not TypeCheck(Left^.EType, Right^.EType) then begin
	MisMatch;
	Left^.EType := BadType;
	Right^.EType := BadType;
    end;
end;

Procedure CheckOrdinal(Expr : ExprPtr);
begin
    if Expr^.EType^.Object <> ob_ordinal then begin
	Expr^.EType := BadType;
	Error("Expecting an Ordinal Expression");
    end;
end;

Function AutoInt(Expr : ExprPtr) : ExprPtr;
begin
    with Expr^ do begin
	if EType = RealType then
	    AutoInt := MakeNode(real2int,Expr,Nil,IntType,0)
	else
	    AutoInt := Expr;
    end;
end;

Function ExpressionTree : ExprPtr;
    Forward;
Function Factor : ExprPtr;
    Forward;
Function GetReference : ExprPtr;
    Forward;

Function BuildError(ErrorMsg : String) : ExprPtr;
begin
    Error(ErrorMsg);
    BuildError := MakeNode(unknown1, Nil, Nil, BadType, 0);
end;

Function OrdinalError : ExprPtr;
begin
    OrdinalError := BuildError("Expecting an ordinal expression");
end;

Function NumericError : ExprPtr;
begin
    NumericError := BuildError("Expecting a numeric expression");
end;

Procedure IncLitPtrA;
begin
    if LitPtr >= LiteralSize then begin
	Writeln('Too much literal data');
	Abort;
    end else
	Inc(LitPtr);
end;

Function ReadLitA(Quote : Char) : TypePtr;

{
	This routine reads a literal array of char into the literal
array.
}
var
    Length : Short;
begin
    Length := 1;
    while (currentchar <> Quote) and (currentchar <> chr(10)) do begin
	if CurrentChar = '\\' then begin
	    ReadChar;
	    if CurrentChar = Chr(10) then
		Error("Missing closing quote");
	    case CurrentChar of
	      'n' : Litq[LitPtr] := Chr(10);
	      't' : Litq[LitPtr] := Chr(9);
	      '0' : Litq[LitPtr] := Chr(0);
	      'b' : Litq[LitPtr] := Chr(8);
	      'e' : Litq[LitPtr] := Chr(27);
	      'c' : Litq[LitPtr] := Chr($9B);
	      'a' : Litq[LitPtr] := Chr(7);
	      'f' : Litq[LitPtr] := Chr(12);
	      'r' : Litq[LitPtr] := Chr(13);
	      'v' : Litq[LitPtr] := Chr(11);
	    else
		Litq[LitPtr] := CurrentChar;
	    end;
	end else
	    Litq[LitPtr] := CurrentChar;
	if CurrentChar <> Chr(10) then begin
	    ReadChar;
	    if currentchar = chr(10) then
		error("Missing closing quote");
	end;
	Inc(Length);
	IncLitPtrA;
    end;
    ReadChar;
    NextSymbol;
    if Quote = '"' then begin
	LitQ[LitPtr] := Chr(0);
	IncLitPtrA;
	ReadLitA := StringType;
    end else begin
	LiteralType^.Upper := Length - 1;
	ReadLitA := LiteralType;
    end;
end;

Function GetStandardFunction(ID : IDPtr) : ExprPtr;
var
    Expr : ExprPtr;
    Expr2 : ExprPtr;
    TypeID : IDPtr;
begin
    NeedLeftParent;
    if (ID^.Offset < 15) or (ID^.Offset > 16) then
	Expr := ExpressionTree;

    case ID^.Offset of
{Ord} 1 : begin
	    if Expr^.EType^.Object = ob_ordinal then begin
		case Expr^.EType^.Size of
		  1 : Expr := MakeNode(stanfunc1, Expr, Nil, ByteType, 1);
		  2 : Expr := MakeNode(stanfunc1, Expr, Nil, ShortType, 1);
		  4 : Expr := MakeNode(stanfunc1, Expr, Nil, IntType, 1);
		end;
	    end else
		Expr := OrdinalError;
	  end;
{Chr} 2 : if NumberType(Expr^.EType) then
	      Expr := MakeNode(stanfunc1, AutoInt(Expr), Nil, CharType, 2)
	  else
	      Expr := NumericError;
{Odd} 3 : if NumberType(Expr^.EType) then
	      Expr := MakeNode(stanfunc1, AutoInt(Expr), Nil, BoolType, 3)
	  else
	      Expr := NumericError;
{Abs}  4 : if NumberType(Expr^.EType) then
	      Expr := MakeNode(stanfunc1, Expr, Nil, Expr^.EType, ID^.Offset)
	  else
	      Expr := NumericError;
{Succ} 5,
{Pred} 6 : if Expr^.Etype^.Object = ob_ordinal then
	       Expr := MakeNode(stanfunc1, Expr, Nil, Expr^.EType, ID^.Offset)
	   else
	       Expr := OrdinalError;
{ReOpen} 7,
{Open}   8 :
	    begin
		if TypeCheck(StringType,Expr^.EType) then begin
		    if not Match(comma1) then
			Error("Expecting a comma");
		    Expr2 := GetReference;
		    if Expr2^.EType^.Object = ob_file then
			Expr := MakeNode(stanfunc1, Expr2, Expr, BoolType, ID^.Offset)
		    else
			Expr := BuildError("Expecting a file type");
		    if Match(Comma1) then begin
			Expr2 := ExpressionTree;
			if not TypeCheck(Expr2^.EType,IntType) then
			    Expr2 := BuildError("Mismatched Types");
		    end else
			Expr2 := MakeNode(Const1,Nil,Nil,IntType,128);
		    Expr^.Left^.Next := Expr2;
		end else
		    Expr := BuildError("Expecting a string expression");
	    end;
{EOF} 9 : if Expr^.EType^.Object = ob_file then
	      Expr := MakeNode(stanfunc1, Expr, Nil, BoolType, 9)
	  else
	      Expr := BuildError("Expecting a file variable");
{Trunc} 10,
{Round} 11 :
	    if TypeCmp(Expr^.EType,RealType) then
		Expr := MakeNode(stanfunc1, Expr, Nil, IntType, ID^.Offset)
	    else
		Expr := BuildError("Expecting a floating point expression");
{Float} 12 : if NumberType(Expr^.EType) and (Expr^.EType^.Object = ob_ordinal) then
		Expr := MakeNode(stanfunc1, PromoteTypeA(Expr,IntType),
					Nil, RealType, 12)
	     else
		Expr := BuildError("Expecting an ordinal number");
{Floor} 13,
{Ceil}  14 : if TypeCmp(Expr^.EType, RealType) then
		Expr := MakeNode(stanfunc1, Expr, Nil, RealType, ID^.Offset)
	     else
		Expr := BuildError("Expecting a floating point expression");
{SizeOf}
     15 : begin
	     if CurrSym = Ident1 then begin
		TypeID := FindId(SymText);
		if TypeID <> Nil then begin
		    if TypeID^.Object = obtype then
			Expr := MakeNode(Const1, Nil, Nil, IntType, TypeID^.VType^.Size)
		    else
			Expr := BuildError("Expecting a type");
		end else
		    Expr := BuildError("Unknown ID");
	    end else
		Expr := BuildError("Expecting an ID");
	    NextSymbol;
	end;
{Adr}
     16 : Expr := MakeNode(at1, GetReference, Nil, AddressType, 0);
{Bit}
     17 : if NumberType(Expr^.EType) and (Expr^.EType^.Object = ob_ordinal) then
	      Expr := MakeNode(shl1, MakeConstant(1,IntType), Expr, IntType, 17)
	  else
	      Expr := BuildError("Expecting an ordinal number");
{Sqr}18 : if NumberType(Expr^.EType) then
	      Expr := MakeNode(stanfunc1, Expr, Nil, Expr^.EType, 18)
	  else
	      Expr := NumericError;
     19..25 : { Sin, Cos, Sqrt, Tan, ArcTan, Ln, Exp }
	    if NumberType(Expr^.EType) then
		Expr := MakeNode(stanfunc1, PromoteTypeA(Expr,RealType),
						Nil, RealType, ID^.Offset)
	    else
		Expr := NumericError;
    end;
    NeedRightParent;
    GetStandardFunction := Expr;
end;

Function ReadParameters(ID : IDPtr) : ExprPtr;
var
    CurrentParam	: IDPtr;
    stay		: Boolean;
    argtype		: TypePtr;
    argindex		: integer;
    totalsize		: integer;
    lab			: integer;
    Expr		: ExprPtr;
    Argument		: ExprPtr;
    NextExpr		: ExprPtr;
begin
    Stay := True;
    Expr := MakeNode(func1, Nil, Nil, ID^.VType, Integer(ID));
    NextExpr := Nil;
    if Match(LeftParent1) then begin
	CurrentParam := ID^.Param;
	while (not Match(RightParent1)) and Stay do begin
	    if CurrentParam = Nil then
		ReadParameters := BuildError("Argument not expected");
	    if CurrentParam^.Object = valarg then begin
		Argument := ExpressionTree;
		if not TypeCheck(Argument^.EType, CurrentParam^.VType) then begin
		    Mismatch;
		    Argument := MakeConstant(1,BadType);
		end else begin
		    if NumberType(Argument^.EType) then begin
			if (Argument^.EType = RealType) and
			   (CurrentParam^.VType^.Object = ob_ordinal) then
			    Argument := MakeNode(Real2Int,
						PromoteTypeA(Argument, IntType),
						Nil,
						CurrentParam^.VType,0)
			else
			    Argument := PromoteTypeA(Argument, CurrentParam^.VType);
		    end;
		end;
	    end else if CurrentParam^.Object = refarg then begin
		Argument := GetReference;
		if not TypeCmp(Argument^.EType, CurrentParam^.VType) then
		    Mismatch;
	    end;
	    if NextExpr = Nil then
		Expr^.Left := Argument
	    else
		NextExpr^.Next := Argument;
	    NextExpr := Argument;
	    CurrentParam := CurrentParam^.Next;
	    if CurrentParam <> Nil then
		if not Match(Comma1) then
		    Error("Expected ,");
	end;
	if CurrentParam <> Nil then
	    error("More Parameters Expected");
    end else begin
	if ID^.Param <> Nil then
	    error("Expecting Some Parameters");
    end;
    ReadParameters := Expr;
end;

{
   This function reads an identifier and makes an appropriate
   node.  The identifier can be a variable, function, constant,
   or standard function.
}

Function ReadIdentifier : ExprPtr;
var
    Expr : ExprPtr;
    NextExpr : ExprPtr;
    ID	: IDPtr;
begin
    ID := FindWithField(SymText);
    if ID = Nil then
	ID := FindID(SymText);
    NextSymbol;
    if ID = Nil then begin
	ID := EnterStandard(SymText, global, BadType, st_none, 1);
	{ ReadBadArgs(ID); }
	ReadIdentifier := BuildError("Unknown ID");
    end;
    case ID^.Object of
      obtype : begin
		   NeedLeftParent;
		   Expr := MakeBinary(Type1, ExpressionTree, Nil, ID^.VType);
		   NeedRightParent;
	       end;
      constant : Expr := MakeConstant(ID^.Offset, ID^.VType);
      global,
      local,
      refarg,
      valarg   : Expr := MakeNode(Var1, Nil, Nil, ID^.VType, Integer(ID));
      typed_const : if ConstantExpression then
			Expr := MakeConstant(ID^.Offset, ID^.VType)
		    else
			Expr := MakeNode(Var1, Nil, Nil, ID^.VType, Integer(ID));
      func     : Expr := ReadParameters(ID);
      stanfunc : Expr := GetStandardFunction(ID);
      field    : Expr := MakeNode(Field1,ExprPtr(LastWith),Nil,ID^.VType,Integer(ID));
    else
	Expr := BuildError("Expecting a variable or function reference");
    end;
    ReadIdentifier := Expr;
end;

Function Primary : ExprPtr;
var
    Expr    : ExprPtr;
    TP,TP2  : TypePtr;
    LitSpot : Integer;
begin
    case CurrSym of
      numeral1 : begin
		    if Abs(SymLoc) > 32767 then
			Expr := MakeConstant(SymLoc, IntType)
		    else if (SymLoc > 255) or (SymLoc < 0) then
			Expr := MakeConstant(SymLoc, ShortType)
		    else
			Expr := MakeConstant(SymLoc, ByteType);
                    NextSymbol;
                end;
      realnumeral1:
		begin
		    Expr := MakeConstant(Integer(RealValue), RealType);
                    NextSymbol;
                end;
      minus1  : begin
		    NextSymbol;
		    Expr := Factor;
		    if not NumberType(Expr^.EType) then
			Expr := BuildError("Expecting a numeric type")
		    else
			Expr := MakeNode(minus1, Expr, Nil, Expr^.EType, 0);
		end;
      plus1   : begin
		    NextSymbol;
		    Expr := Factor;
		    if not NumberType(Expr^.EType) then
			Expr := BuildError("Expecting a numeric type");
		end;
      at1 : 	begin
		    NextSymbol;
		    Expr := MakeNode(at1, GetReference, Nil, AddressType, 0);
		end;
      not1    : begin
		    NextSymbol;
		    Expr := Factor;
		    if Expr^.EType^.Object <> ob_ordinal then
			Expr := BuildError("Expecting an ordinal type")
		    else
			Expr := MakeNode(not1, Expr, Nil, Expr^.EType, 0);
		end;
      ident1  : Expr := ReadIdentifier;
      leftparent1 :
		begin
		    NextSymbol;
		    Expr := ExpressionTree;
		    NeedRightParent;
		end;
      Apostrophe1 :
		begin
		    LitSpot := LitPtr;
		    TP := ReadLitA(Chr(39));
		    if TP^.Upper = 1 then begin
			Dec(LitPtr);
			Expr := MakeConstant(Ord(LitQ[LitPtr]), CharType);
		    end else begin
			New(TP2);  { Add new type for array }
			TP2^ := TP^;
			TP2^.Next := CurrentBlock^.FirstType;
			CurrentBlock^.FirstType := TP2;
			Expr := MakeNode(quote1, Nil, Nil, TP2, LitSpot);
		    end;
		end;
      Quote1 :  begin
		    LitSpot := LitPtr;
		    TP := ReadLitA('"');
		    Expr := MakeNode(quote1, Nil, Nil, TP, LitSpot);
		end;
    else
        Expr := BuildError("Unknown Factor");
    end;
    Primary := Expr;
end;

Function MakeFieldRef(Expr : ExprPtr; Offset : Integer; TP : TypePtr) : ExprPtr;
begin
    if Expr^.Kind = period1 then begin
        Expr^.Value := Expr^.Value + Offset;
        Expr^.EType := TP;
        MakeFieldRef := Expr;
    end;
    MakeFieldRef := MakeNode(Period1, Expr, Nil, TP, Offset);
end;

Function MakeIndirection(Expr : ExprPtr) : ExprPtr;
var
    Result : ExprPtr;
begin
    MakeIndirection := MakeNode(Carat1, Expr, Nil, Expr^.EType^.SubType, 0);
end;

Function MakeIndex(L, R : ExprPtr; TP : TypePtr) : ExprPtr;
var
    Result : ExprPtr;
begin

{
    These first statements create the following structure:

		*
	       / \
	 element  -
	  size   /  \
	      promote\
	       /      lower bound
	     index
	   expression

    Which is the general calculation for array addressing:
	base address + (index - lower bound) * element size

    L := The expression for the array address
    R := The expression for the index
}

    case R^.EType^.Size of
      1 : R^.EType := ByteType;
      2 : R^.EType := ShortType;
      4 : R^.EType := IntType;
    end;

    with L^.EType^ do begin
	if Lower <> 0 then
	    R := MakeBinary(minus1,MakeConstant(Lower,R^.EType),
				R, R^.EType);
	if (Upper > MaxShort) or (SubType^.Size > MaxShort) then begin
	    R := MakeBinary(asterisk1,
			MakeConstant(SubType^.Size,IntType),
			PromoteTypeA(R,IntType),
			IntType)
	end else begin
	    R := MakeBinary(asterisk1,
			MakeConstant(SubType^.Size,ShortType),
			PromoteTypeA(R,ShortType),IntType);
	end;
    end;
    MakeIndex := MakeNode(LeftBrack1, L, R, TP, 0);
end;

Function GetReference : ExprPtr;
var
    Left,
    Right  : ExprPtr;
    Leave  : Boolean;
    TP     : TypePtr;
    ID     : IDPtr;
begin
    ID := FindWithField(SymText);
    if ID = Nil then
	ID := FindID(SymText);
    NextSymbol;

    if ID = Nil then begin
	ID := EnterStandard(SymText, global, BadType, st_none, 1);
	{ ReadBadArgs(ID); }
	GetReference := BuildError("Unknown ID");
    end;

    case ID^.Object of
      obtype : begin
		   NeedLeftParent;
		   Left := MakeNode(type1, GetReference, Nil, ID^.VType, 0);
		   NeedRightParent;
	       end;
      global,
      local,
      refarg,
      typed_const,
      valarg,
      proc,
      func	: Left := MakeNode(Var1, Nil, Nil, ID^.VType, Integer(ID));
      field    : Left := MakeNode(Field1, ExprPtr(LastWith), Nil, ID^.VType, Integer(ID));
    else
	GetReference := BuildError("Expecting an identifier");
    end;

    Leave := False;
    repeat
        case CurrSym of { handle ., [, and '^' here }
          period1 : begin
			NextSymbol;
			if Left^.EType^.Object = ob_record then begin
			    if CurrSym = ident1 then begin
				ID := FindField(SymText, Left^.EType);
				if ID <> Nil then
				    Left := MakeFieldRef(Left, ID^.Offset, ID^.VType)
				else
				    Left := BuildError("Unknown Field");
				NextSymbol;
			    end else
				Left := BuildError("Expecting an identifier");
			end else
			    Left := BuildError("Not a Record Type");
                    end;
          carat1 :  begin
			NextSymbol;
			if (Left^.EType^.Object <> ob_pointer) and
			   (Left^.EType^.Object <> ob_file) then
			    Left := BuildError("Expecting a pointer or file for ^")
			else
			    Left := MakeIndirection(Left)
		    end;
          leftbrack1 :
		    begin
			NextSymbol;
			repeat
			    if Left^.EType^.Object = ob_array then begin
				Right := ExpressionTree;
				if not TypeCheck(Right^.EType, Left^.EType^.Ref) then
				    MisMatch;
				if Right^.Kind = Const1 then begin
				    if RangeCheck then begin
					if (Right^.Value > Left^.EType^.Upper) or
					   (Right^.Value < Left^.EType^.Lower) then
					    Error("Index out of range");
				    end;
				    Left := MakeFieldRef(Left,
					   (Right^.Value - Left^.EType^.Lower) *
					    Left^.EType^.SubType^.Size,
					    Left^.EType^.SubType)
				end else
				    Left := MakeIndex(Left,Right,Left^.EType^.SubType);
			    end else if Left^.EType = StringType then begin
				Right := ExpressionTree;
				if TypeCheck(Right^.EType, IntType) then
				    Left := MakeIndex(Left,Right,CharType)
				else
				    Left := BuildError("Expecting an integer index");
			    end else
				Left := BuildError("Not an Array Type");
			until not Match(Comma1);
			if not Match(RightBrack1) then
			    Error("Expecting ]");
		    end;
        else
            Leave := True;
        end;
    until Leave;
    GetReference := Left;
end;

{ Create a factor tree.  This level handles the seperators, which in
  version 1.2 are now considered operators. }

Function Factor : ExprPtr;
var
    Left,
    Right  : ExprPtr;
    Leave  : Boolean;
    TP     : TypePtr;
    ID     : IDPtr;
begin
    Left := Primary;
    Leave := False;
    repeat
        case CurrSym of { handle ., [, and '^' here }
          period1 : begin
			NextSymbol;
			if Left^.EType^.Object = ob_record then begin
			    if CurrSym = ident1 then begin
				ID := FindField(SymText, Left^.EType);
				if ID <> Nil then
				    Left := MakeFieldRef(Left, ID^.Offset, ID^.VType)
				else
				    Left := BuildError("Unknown Field");
				NextSymbol;
			    end else
				Left := BuildError("Expecting an identifier");
			end else
			    Left := BuildError("Not a Record Type");
                    end;
          carat1 :  begin
			NextSymbol;
			if (Left^.EType^.Object <> ob_pointer) and
			   (Left^.EType^.Object <> ob_file) then
			    Left := BuildError("Expecting a pointer or file type")
			else
			    Left := MakeIndirection(Left)
		    end;
          leftbrack1 :
		    begin
			NextSymbol;
			repeat
			    if Left^.EType^.Object = ob_array then begin
				Right := ExpressionTree;
				if not TypeCheck(Right^.EType, Left^.EType^.Ref) then
				    MisMatch;
				if Right^.Kind = Const1 then
				    Left := MakeFieldRef(Left,
					    (Right^.Value - Left^.EType^.Lower) *
					     Left^.EType^.SubType^.Size,
					     Left^.EType^.SubType)
				else
				    Left := MakeIndex(Left,Right,Left^.EType^.SubType);
			    end else if Left^.EType = StringType then begin
				Right := ExpressionTree;
				if TypeCheck(Right^.EType, IntType) then
				    Left := MakeIndex(Left,Right,CharType)
				else
				    Left := BuildError("Expecting an integer index");
			    end else
				Left := BuildError("Not an Array Type");
			until not Match(Comma1);
			if not Match(RightBrack1) then
			    Error("Expecting ]");
                    end;
        else
            Leave := True;
        end;
    until Leave;
    Factor := Left;
end;

{ Create a term tree.  This routine handles multiplication, division,
  and, shl, shr, and mod }

Function Term : ExprPtr;
var
    Left,
    Right    : ExprPtr;
    Leave    : Boolean;
    Op       : Symbols;
begin
    Left := Factor;
    Leave := False;
    repeat
        case CurrSym of
          asterisk1:
		begin
		    CheckNumeric(Left);
		    NextSymbol;
		    Right := Factor;
		    CheckNumeric(Right);
		    CheckType(Left,Right);
		    Left  := PromoteTypeA(Left, ShortType); { at least }
		    Left  := PromoteTypeA(Left, Right^.EType);
		    Right := PromoteTypeA(Right, Left^.EType);
		    if Left^.EType^.Size < 4 then
			Left  := MakeCommutativeBinary(asterisk1, Left, Right, IntType)
		    else
			Left := MakeBinary(asterisk1, Left, Right, Left^.EType);
		end;
          realdiv1 :
		begin
		    CheckNumeric(Left);
		    NextSymbol;
		    Right := Factor;
		    CheckNumeric(Right);
		    CheckType(Left,Right);
		    Left  := PromoteTypeA(Left, RealType);
		    Right := PromoteTypeA(Right, Left^.EType);
		    Left := MakeBinary(realdiv1, Right, Left, RealType);
		end;
	  div1,
	  mod1: begin
		    Op := CurrSym;
		    CheckNumeric(Left);
		    NextSymbol;
		    Right := Factor;
		    CheckNumeric(Right);
		    CheckType(Left,Right);
		    Left := AutoInt(Left);
		    Right := AutoInt(Right);
		    Left  := PromoteTypeA(Left, IntType);
		    Right := PromoteTypeA(Right, ShortType);
		    Left := MakeBinary(Op, Right, Left, Right^.EType);
		end;
	  and1,
	  shl1,
	  shr1: begin
		    Op := CurrSym;
		    if Left^.EType = RealType then
			Left := AutoInt(Left)
		    else
			CheckOrdinal(Left);
		    NextSymbol;
		    Right := Factor;
		    if Right^.EType = RealType then
			Right := AutoInt(Right)
		    else
			CheckOrdinal(Right);
		    CheckType(Left,Right);
		    if NumberType(Left^.EType) then begin
			Left  := PromoteTypeA(Left, Right^.EType);
			Right := PromoteTypeA(Right, Left^.EType);
			if Op <> and1 then
			    Left := PromoteTypeA(Left, IntType);
		    end;
		    if (Op = And1) and
		       ((Left^.EType <> BoolType) or (not ShortCircuit)) then
			Left := MakeCommutativeBinary(Op, Left, Right, Left^.EType)
		    else
			Left := MakeBinary(Op, Left, Right, Left^.EType);
		end;
        else
            Leave := True;
        end;
    until Leave;
    Term := Left;
end;

{ Create simple expression tree.  This routine handles +, -, or, and xor }

Function Simple : ExprPtr;
var
    Left,
    Right   : ExprPtr;
    Leave   : Boolean;
    Op      : Symbols;
begin
    Left := Term;
    Leave := False;
    repeat
        case CurrSym of
          plus1,
          minus1 : begin
                      Op := CurrSym;
                      CheckNumeric(Left);
                      NextSymbol;
                      Right := Term;
                      CheckNumeric(Right);
                      CheckType(Left,Right);
                      Left  := PromoteTypeA(Left, Right^.EType);
                      Right := PromoteTypeA(Right, Left^.EType);
                      if Op = plus1 then
                          Left := MakeCommutativeBinary(Op, Left, Right, Left^.EType)
                      else
                          Left := MakeBinary(Op, Right, Left, Left^.EType);
                  end;
	  or1,
	  xor1: begin
		    Op := CurrSym;
		    if Left^.EType = RealType then
			Left := AutoInt(Left)
		    else
			CheckOrdinal(Left);
		    NextSymbol;
		    Right := Term;
		    if Right^.EType = RealType then
			Right := AutoInt(Right)
		    else
			CheckOrdinal(Right);
		    CheckType(Left,Right);
		    if NumberType(Left^.EType) then begin
			Left  := PromoteTypeA(Left, Right^.EType);
			Right := PromoteTypeA(Right, Left^.EType);
		    end;
		    if (not ShortCircuit) or (Op <> or1) or
				(Left^.EType <> BoolType) then
			Left := MakeCommutativeBinary(Op, Left, Right, Left^.EType)
		    else
			Left := MakeBinary(Op, Left, Right, Left^.EType);
		end;
        else
            Leave := True;
        end;
    until Leave;
    Simple := Left;
end;

{ Create an expression tree.  This routine calls the others, and
  handles comparison operators, which have the lowest precedence. }

Function ExpressionTree : ExprPtr;
var
    Left,
    Right  : ExprPtr;
    Leave  : Boolean;
    Op     : Symbols;
begin
    Left  := Simple;
    Leave := False;
    repeat
        case CurrSym of
          less1,
          greater1,
          notless1,
          notgreater1 : begin
                            Op := CurrSym;
			    if Left^.EType <> RealType then
				CheckOrdinal(Left);
                            NextSymbol;
                            Right := Simple;
			    if Right^.EType <> RealType then
				CheckOrdinal(Right);
                            CheckType(Left, Right);
			    if NumberType(Left^.EType) then begin
				if Left^.EType = ByteType then
				    Left := PromoteTypeA(Left, ShortType);
				Left  := PromoteTypeA(Left, Right^.EType);
				Right := PromoteTypeA(Right, Left^.EType);
			    end;
                            Left := MakeBinary(Op, Left, Right, BoolType);
                        end;
          equal1,
          notequal1   : begin
                            Op := CurrSym;
                            NextSymbol;
                            Right := Simple;
                            CheckType(Left, Right);
			    if NumberType(Left^.EType) then begin
				Left := PromoteTypeA(Left, Right^.EType);
				Right := PromoteTypeA(Right, Left^.EType);
			    end;
                            Left := MakeCommutativeBinary(Op, Left, Right, BoolType);
                        end;
        else
            Leave := True;
        end;
    until Leave;
    ExpressionTree := Left;
end;
