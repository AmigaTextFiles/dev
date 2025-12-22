external;

{
	Utilities.p (of PCQ Pascal)
	Copyright (c) 1989 Patrick Quaid.

	This module handles the various tables and whatever
	run-time business the compiler might have.
}

{$O-}
{$I "Pascal.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/Break.i"}

	Procedure Error(s : string);
	    external;
	Procedure NextSymbol;
	    external;
	Procedure Abort;
	    external;
	Procedure PushLongD0;
	    external;
	Procedure PushLongD1;
	    External;
	Procedure PopLongD1;
	    external;
	Procedure PopLongD0;
	    External;
	Procedure WriteHex(num : Integer);
	    External;


Procedure NewSpell;
var
    TempPtr : SpellRecPtr;
begin
    New(TempPtr);
    TempPtr^.Previous := CurrentSpellRec;
    CurrentSpellRec := TempPtr;
    CurrentSpellRec^.First := SpellPtr;
end;

Procedure BackUpSpell(Position : Integer);
var
    TempPtr : SpellRecPtr;
begin
    while Position < CurrentSpellRec^.First do begin
	TempPtr := CurrentSpellRec^.Previous;
	Dispose(CurrentSpellRec);
	CurrentSpellRec := TempPtr;
    end;
    SpellPtr := Position;
end;

Function EnterSpell(S : String) : String;
var
    Length : Integer;
    Result : String;
begin
    Length := strlen(S) + 1;
    if (Length + SpellPtr) - CurrentSpellRec^.First > Spell_Max then
	NewSpell;
    Result := Adr(CurrentSpellRec^.Data[SpellPtr - CurrentSpellRec^.First]);
    strcpy(Result, S);
    SpellPtr := SpellPtr + Length;
    EnterSpell := Result;
end;


Procedure Inc_NextCode;
begin
    Inc(NextCode);
    if NextCode > MaxCode then begin
	Error("Procedure too long (code table full)");
	Abort;
    end;
end;

Procedure Out_Operation0(op : OpCodes);
begin
    Code_Table^[NextCode] := (Ord(op) shl 24) or ((2 shl 16) or
				(Ord(ea_None) shl 12) or (Ord(a7) shl 8) or
				(Ord(ea_None) shl 4) or Ord(a7));
    Inc_NextCode;
end;

Procedure Out_Operation1(op : OpCodes; Size : Byte;
			 EA : EAModes; Reg : Regs);
begin
    Code_Table^[NextCode] := (Ord(op) shl 24) or (Pred(Size) shl 16) or
				(Extensions[EA] shl 18) or
				(Ord(EA) shl 12) or (Ord(Reg) shl 8) or
				((Ord(ea_None) shl 4) or Ord(a7));
    Inc_NextCode;
end;

Procedure Out_Operation2(op : OpCodes; Size : Byte;
			 SrcEA : EAModes; SrcReg : Regs;
			 DestEA: EAMOdes; DestReg: Regs);
begin
    Code_Table^[NextCode] := (Ord(op) shl 24) or (Pred(Size) shl 16) or
			    ((Extensions[SrcEA] + Extensions[DestEA]) shl 18) or
				(Ord(SrcEA) shl 12) or (Ord(SrcReg) shl 8) or
				(Ord(DestEA) shl 4) or Ord(DestReg);
    Inc_NextCode;
end;

Procedure Out_Extension(Ext : Integer);
begin
    Code_Table^[NextCode] := Ext;
    Inc_NextCode;
end;

Procedure WriteRegisterList(Mask : Integer);
var
    Reg      : Regs;
    WroteAny : Boolean;
begin
    WroteAny := False;
    for Reg := d0 to a6 do begin
	if (Mask and (1 shl Ord(Reg))) <> 0 then begin
	    if WroteAny then
		Write(OutFile, '/')
	    else
		WroteAny := True;
	    Write(OutFile, RN[Reg]);
	end;
    end;
end;

Procedure WriteEA(EA : EAModes; Reg : Regs; Pos : Integer);
var
    ID : IDPtr;
    Ext : Integer;
begin
    Ext := Code_Table^[Pos];
    case EA of
      ea_Constant : Write(OutFile, '#', Ext);
      ea_Absolute : Write(OutFile, Ext);
      ea_Literal  : Write(OutFile, '#_p%1+', Ext);
      ea_Global   : begin
			ID := IDPtr(Ext);
			if ID^.Level <= 1 then
			    Write(OutFile, '_', ID^.Name)
			else
			    Write(OutFile, '_', ID^.Name, '%', ID^.Unique);
		    end;
      ea_Address  : begin
			ID := IDPtr(Ext);
			if ID^.Level <= 1 then
			    Write(OutFile, '#_', ID^.Name)
			else
			    Write(OutFile, '#_', ID^.Name,'%',ID^.Unique);
		    end;
      ea_Index    : Write(OutFile, Ext, '(', RN[Reg], ')');
      ea_String   : Write(OutFile, String(Ext));
      ea_Label    : Write(OutFile, '_p%', Ext);
      ea_RegInd   : Write(OutFile, Ext shr 8, '(', RN[Reg], ',',
					RN[Regs(Ext and 15)], '.l)');
      ea_RegList  : WriteRegisterList(Ext);
      ea_Offset   : begin
			ID := IDPtr(Ext);
			if ID^.Level <= 1 then
			    Write(OutFile, '#_', ID^.Name)
			else
			    Write(OutFile, '#_', ID^.Name, '%', ID^.Unique);
			Write(OutFile, '+', Code_Table^[Succ(Pos)]);
		    end;
      ea_Indirect : Write(OutFile, '(', RN[Reg], ')');
      ea_PostInc  : Write(OutFile, '(', RN[Reg], ')+');
      ea_PreDec   : Write(OutFile, '-(', RN[Reg], ')');
      ea_Register : Write(OutFile, RN[Reg]);
      ea_None     : ;
    end;
end;

Procedure FlushCodeTable;
var
    Code    : Integer;
    Temp    : Integer;
    Op      : OpCodes;
    Size    : Byte;
    SrcEA,
    DestEA  : EAModes;
    SrcReg,
    DestReg : Regs;
    UsedRegs: Integer;
begin
    Code     := 0;
    UsedRegs := 0;
    while Code < NextCode do begin
	Temp   := Code_Table^[Code];

	case OpCodes(Temp shr 24) of
	  op_LINK,
	  op_UNLK : ;
	else
	    UsedRegs := UsedRegs or (1 shl ((Temp shr 8) and 15))
			     or (1 shl (Temp and 15));
	end;

	Code := Succ(Code + ((Temp shr 18) and 3));
    end;
    UsedRegs := UsedRegs and $2CFC; { a5/a3/a2/d7/d6/d5/d4/d3/d2 }

    Code := 0;
    while Code < NextCode do begin
	Temp := Code_Table^[Code];
	Op     := OpCodes(Temp shr 24);
	Size   := Succ((Temp shr 16) and 3);
	SrcEA  := EAModes((Temp shr 12) and 15);
	SrcReg := Regs((Temp shr 8) and 15);
	DestEA := EAModes((Temp shr 4) and 15);
	DestReg:= Regs(Temp and 15);

	case Op of
	  op_LABEL :
		    begin
			WriteEA(SrcEA,SrcReg,Succ(Code));
			Writeln(OutFile);
			Op := op_None;
		    end;

	  op_LINK : if (UsedRegs and $2000) = 0 then
			Op := op_None;

	  op_POP :  begin
			Op      := op_MOVE;
			DestEA  := SrcEA;
			DestReg := SrcReg;
			SrcEA   := ea_PostInc;
			SrcReg  := a7;
		    end;
	  op_PUSH : begin
			Op      := op_MOVE;
			DestEA	:= ea_PreDec;
			DestReg := a7;
		    end;
	  op_Save : begin
			if (UsedRegs and $0CFC) <> 0 then begin
			    Write(OutFile, '\tmovem.l\t');
			    WriteRegisterList(UsedRegs and $0CFC);
			    Writeln(OutFile, ',-(sp)');
			end;
			op := op_None;
		    end;
	  op_RESTORE :
		    begin
			if (UsedRegs and $0CFC) <> 0 then begin
			    Write(OutFile, '\tmovem.l\t(sp)+,');
			    WriteRegisterList(UsedRegs and $0CFC);
			    Writeln(OutFile);
			end;
			op := op_None;
		    end;
	  op_UNLK : if (UsedRegs and $2000) = 0 then
			Op := op_None;
	end;

	if Op <> op_None then begin
	    Write(OutFile, '\t', OpText[Op]);
	    case Size of
	      1 : Write(OutFile, '.b');
	      2 : Write(OutFile, '.w');
	      4 : Write(OutFile, '.l');
	    end;

	    if SrcEA <> ea_None then begin
		Write(OutFile, '\t');
		WriteEA(SrcEA,SrcReg,Succ(Code));
	    end;
	    if DestEA <> ea_None then begin
		Write(OutFile, ',');
		WriteEA(DestEA,DestReg,Succ(Code + Extensions[SrcEA]));
	    end;

	{    Write(OutFile, '\t;');
	    WriteHex(Temp); }

	    Writeln(OutFile);
	end;
	Code := Succ(Code + Extensions[SrcEA] + Extensions[DestEA]);
    end;
end;


Function BaseType(orgtype : TypePtr): TypePtr;

{
	This routine returns the base type of type.  If this
routine is used consistently, ranges and subtypes will work with
some consistency.
}

begin
    while (orgtype^.Object = ob_subrange) or (orgtype^.Object = ob_synonym) do
	orgtype := orgtype^.SubType;
    basetype := orgtype;
end;

Function SimpleType(testtype : TypePtr) : Boolean;

{
	If a variable passes this test, it is held in a register
during processing.  If not, the address of the variable is held in
the register.  This is the main reason why type conversions don't
work across all types of the same size.
}

begin
    TestType := BaseType(TestType);
    SimpleType := (TestType^.Size <= 4) and
		  (TestType^.Size <> 3) and
		  (TestType^.Object <> ob_record) and
		  (TestType^.Object <> ob_array);
end;

Function HigherType(typea, typeb : TypePtr): TypePtr;

{
	This routine returns the more complex type of the two
numeric types passed to it.  In other words a 32 bit integer is
'higher' than a 16 bit one.
}

begin
    if (TypeA = RealType) or (TypeB = RealType) then
	HigherType := RealType;
    if (typea = inttype) or (typeb = inttype) then
	highertype := inttype;
    if (typea = shorttype) or (typeb = shorttype) then
	highertype := shorttype;
    highertype := typea;
end;

Procedure PromoteType(var from : TypePtr; other : TypePtr; reg : Short);

{
	This routine extends reg as necessary to make the 'from'
type equivalent to 'other'.
}

var
    totype : TypePtr;
begin
    from := basetype(from);
    other := basetype(other);
    totype := highertype(from, other);
    if from = totype then
	return;
    if totype = realtype then begin
	if from^.Size = 1 then begin
	    Out_Operation2(op_AND,4,ea_Constant,a7,ea_Register,Regs(reg));
	    Out_Extension(255);
	end else if from^.Size = 2 then
	    Out_Operation1(op_EXT,4,ea_Register,Regs(reg));
	if reg = 0 then
	    PushLongD1
	else begin
	    PushLongD0;
	    Out_Operation2(op_MOVE,4,ea_Register,d1,ea_Register,d0);
	end;
	Out_Operation2(op_MOVE,4,ea_String,a7,ea_Register,a6);
	Out_Extension(Integer("_p%MathBase"));

	Out_Operation1(op_JSR,3,ea_Index,a6);
	Out_Extension(-36);			{ _LVOSPFlt }

	if reg = 0 then
	    PopLongD1
	else begin
	    Out_Operation2(op_MOVE,4,ea_Register,d0,ea_Register,d1);
	    PopLongD0;
	end;
	from := RealType;
    end else if totype = inttype then begin
	if from^.Size = 2 then
	    Out_Operation1(op_EXT,4,ea_Register,Regs(Reg))
	else if from^.Size = 1 then begin
	    Out_Operation2(op_AND,4,ea_Constant,a7,ea_Register,Regs(Reg));
	    Out_Extension(255);
	end;
	from := inttype;
    end else if totype = shorttype then begin
	if from^.Size = 1 then begin
	    Out_Operation2(op_AND,2,ea_Constant,a7,ea_Register,Regs(reg));
	    Out_Extension(255);
	end;
	from := shorttype;
    end;
end;

Procedure NewBlock;
var
    CB : BlockPtr;
    i  : Short;
begin
    New(CB);
    CB^.FirstType := Nil;
    for i := 0 to Hash_Size do
	CB^.Table[i] := Nil;
    if CurrentBlock = Nil then
	CB^.Level := 0
    else
	CB^.Level := Succ(CurrentBlock^.Level);
    CB^.Previous := CurrentBlock;
    CurrentBlock := CB;
end;

Procedure KillIDList(ID : IDPtr);
var
    TempID : IDPtr;
begin
    while ID <> Nil do begin
	if (ID^.Object = proc) or (ID^.Object = func) then
	    KillIDList(ID^.Param);
	TempID := ID^.Next;
	Dispose(ID);
	ID := TempID;
    end;
end;

Procedure KillBlock;
var
    CB : BlockPtr;
    ID : IDPtr;
    TP : TypePtr;
    i  : Integer;

    Procedure KillTypeList(TP : TypePtr);
    var
	TempType : TypePtr;
    begin
	while TP <> nil do begin
	    if TP^.Object = ob_record then
		KillIDList(TP^.Ref);
	    TempType := TP^.Next;
	    Dispose(TP);
	    TP := TempType;
	end;
    end;

begin
    CB := CurrentBlock;
    CurrentBlock := CurrentBlock^.Previous;
    for i := 0 to Hash_Size do
	KillIDList(CB^.Table[i]);
    KillTypeList(CB^.FirstType);
end;

Function Match(sym : Symbols): Boolean;

{
	If the current symbol is sym, return true and get the
next one.
}

begin
    if CurrSym = Sym then begin
	NextSymbol;
	Match := True;
    end else
	Match := False;
end;

{
	The following routines just print out common error messages
and make some common tests.
}
 
procedure Mismatch;
begin
    error("Mismatched types");
end;

procedure NeedNumber;
begin
    error("Expecting a numeric expression");
end;

procedure NoLeftParent;
begin
    error("No left parenthesis");
end;

procedure NoRightParent;
begin
    error("No right parenthesis");
end;

Procedure UsingSmallStartup;
begin
    Error("This command is not supported by small startup code");
end;

procedure NeedLeftParent;
begin
    if not match(leftparent1) then
	noleftparent;
end;

procedure NeedRightParent;
begin
    if not match(rightparent1) then
	norightparent;
end;

Procedure EnterID(EntryBlock : BlockPtr; ID : IDPtr);
var
    HVal : Short;
begin
    ID^.Level := EntryBlock^.Level;
    HVal := Hash(ID^.Name) and Hash_Size;
    ID^.Next := EntryBlock^.Table[HVal];
    EntryBlock^.Table[HVal] := ID;
end;

Function EnterStandard( st_Name : String;
			st_Object : IDObject;
			st_Type : TypePtr;
			st_Storage : IDStorage;
			st_Offset  : Integer)	: IDPtr;
var
    ID : IDPtr;
begin
    new(ID);
    with ID^ do begin
	Next	:= Nil;
	Name 	:= EnterSpell(st_Name);
	Object	:= st_Object;
	VType	:= st_Type;
	Param	:= Nil;
	Storage	:= st_Storage;
	Offset	:= st_Offset;
    end;
    EnterID(CurrentBlock, ID);
    EnterStandard := ID;
end;

Procedure ns;

{
	This routine just tests for a semicolon.
}

begin
    if not match(semicolon1) then begin
	if (currsym <> end1) and (currsym <> else1) and (currsym <> until1) then
	    error("missing semicolon");
    end else
	while match(semicolon1) do;
end;

Function TypeCmp(TypeA, TypeB : TypePtr) : Boolean;

{
	This routine just compares two types to see if they're
equivalent.  Subranges of the same type are considered equivalent.
Note that 'badtype' is actually a universal type used when there
are errors, in order to avoid streams of errors.
}

var
	t1ptr,
	t2ptr  : IDPtr;
begin
    TypeA := BaseType(TypeA);
    TypeB := BaseType(TypeB);

    if TypeA = TypeB then
	TypeCmp := True;
    if (TypeA = BadType) or (TypeB = BadType) then
	TypeCmp := True;
    if TypeA^.Object <> TypeB^.Object then
	typecmp := false;
    if TypeA^.Object = ob_array then begin
	if (TypeA^.Upper - TypeA^.Lower) <>
	   (TypeB^.Upper - TypeB^.Lower) then
	    typecmp := false;
	TypeCmp := TypeCmp(TypeA^.Subtype, TypeB^.SubType);
    end;
    if TypeA^.Object = ob_pointer then
	TypeCmp := TypeCmp(TypeA^.SubType, TypeB^.SubType);
    if TypeA^.Object = ob_file then
	TypeCmp := TypeCmp(TypeA^.SubType, TypeB^.Subtype);
    TypeCmp := false;
end;

Function NumberType(testtype : TypePtr) : Boolean;

{
	Return true if this is a numeric type.
}

begin
    TestType := BaseType(TestType);
    if TestType = IntType then
	NumberType := true
    else if TestType = ShortType then
	NumberType := True
    else if TestType = RealType then
	NumberType := True
    else if TestType = ByteType then
	NumberType := True;
    NumberType := False;
end;

Function TypeCheck(TypeA, TypeB : TypePtr) : Boolean;

{
	This is similar to typecmp, but considers numeric types
equivalent.
}

begin
    TypeA := BaseType(TypeA);
    TypeB := BaseType(TypeB);
    if TypeA = TypeB then
	TypeCheck := True;
    if NumberType(TypeA) and NumberType(TypeB) then
	TypeCheck := True;
    TypeCheck := TypeCmp(TypeA, TypeB);
end;

Function AddType(at_Object : TypeObject;
		 at_SubType: TypePtr;
		 at_Ref    : Address;
		 at_Upper,
		 at_Lower,
		 at_Size   : Integer) : TypePtr;

{
	Adds a type to the id array.
}

var
    TP	: TypePtr;
begin
    New(TP);
    with TP^ do begin
	Object	:= at_Object;
	SubType	:= at_SubType;
	Ref 	:= at_Ref;
	Upper	:= at_Upper;
	Lower	:= at_Lower;
	Size	:= at_Size;
	Next	:= CurrentBlock^.FirstType;
    end;
    CurrentBlock^.FirstType := TP;
    AddType := TP;
end;

Function FindID(idname : string): IDPtr;
{ Find the most local reference to a variable }
var
    ID	: IDPtr;
    CB  : BlockPtr;
    HVal : Short;
begin
    CB := CurrentBlock;
    HVal := Hash(idname) and Hash_Size;
    while CB <> nil do begin
	ID := CB^.Table[HVal];
	while ID <> nil do begin
	    if strieq(idname, ID^.Name) then
		FindID := ID;
	    ID := ID^.Next;
	end;
	CB := CB^.Previous;
    end;
    FindID := Nil;
end;

Function CheckID(idname : string): IDPtr;

{
	This is like the above, but only checks the current block.
}

var
    ID : IDPtr;
begin
    ID := CurrentBlock^.Table[Hash(idname) and Hash_Size];
    while ID <> nil do begin
	if strieq(idname, ID^.Name) then
	    CheckID := ID;
	ID := ID^.Next;
    end;
    CheckID := Nil;
end;

Function CheckIDList(S : String; ID : IDPtr) : Boolean;
begin
    while ID <> nil do begin
	if strieq(S, ID^.Name) then
	    CheckIDList := True;
	ID := ID^.Next;
    end;
    CheckIDList := False;
end;

Function FindField(idname : string; RecType : TypePtr) : IDPtr;

{
	This just finds the appropriate field, given the index of
the record type.

}

var
    ID	: IDPtr;
begin
    ID := RecType^.Ref;
    while ID <> Nil do begin
	if strieq(idname, ID^.Name) then
	    FindField := ID;
	ID := ID^.Next;
    end;
    FindField := Nil;
end;

Function FindWithField(Str : String) : IDPtr;
var
    CurrentWith : WithRecPtr;
    ID : IDPtr;
begin
    CurrentWith := FirstWith;
    while CurrentWith <> Nil do begin
	ID := FindField(Str, CurrentWith^.RecType);
	if ID <> Nil then begin
	    LastWith := CurrentWith;
	    FindWithField := ID;
	end;
	CurrentWith := CurrentWith^.Previous;
    end;
    FindWithField := Nil;
end;

Function IsVariable(ID : IDPtr) : Boolean;

{
	Returns true if index is a variable.
}

begin
    case ID^.Object of
	local,
	refarg,
	valarg,
	global,
	typed_const,
	field	: IsVariable := True;
    else
	IsVariable := False;
    end;
end;

Function Suffix(size : integer): char;

{
	Returns the proper assembly language suffix for the various
operations.
}

begin
    case Size of
      1 : Suffix := 'b';
      2 : Suffix := 'w';
      4 : Suffix := 'l';
    else
        Suffix := '!'
    end;
end;



Function CompareProcs(Proc1, Proc2 : IDPtr) : Boolean;
var
    ID1, ID2 : IDPtr;
begin
    if Proc1^.Object <> Proc2^.Object then
	CompareProcs := False;
    if Proc1^.Object = func then
	if not TypeCmp(Proc1^.VType, Proc2^.VType) then
	    CompareProcs := False;
    ID1 := Proc1^.Param;
    ID2 := Proc2^.Param;
    while (ID1 <> Nil) and (ID2 <> Nil) do begin
	if not TypeCmp(ID1^.VType, ID2^.VType) then
	    CompareProcs := False;
	ID1 := ID1^.Next;
	ID2 := ID2^.Next;
    end;
    CompareProcs := ID1 = ID2;
end;
