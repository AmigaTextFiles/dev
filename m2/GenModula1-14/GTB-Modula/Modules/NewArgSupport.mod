IMPLEMENTATION MODULE NewArgSupport;

(*
 * -------------------------------------------------------------------------
 *
 *	:Module.	NewArgSupport
 *	:Contents.	Support module to get arguments transparent from CLI or Workbench

 *	:Author.	Reiner Nix
 *	:Address.	Geranienhof 2, 5000 Köln 71 Seeberg
 *	:Address.	rbnix@pool.informatik.rwth-aachen.de
 *	:Copyright.	Public Domain
 *	:Language.	Modula-2
 *	:Translator.	M2Amiga A-L V4.2d
 *	:History.	V1.0	08.08.92 ArgSupport
 *	:History	V1.0	03.04.93 NewArgSupport now getting cli-args by ReadArg
 *
 * -------------------------------------------------------------------------
 *)

FROM	SYSTEM			IMPORT	ADR;
FROM	Arts			IMPORT	wbStarted,
					dosCmdBuf, dosCmdLen,
					programName,
					Assert, BreakPoint, Exit;
FROM	Conversions		IMPORT	StrToVal;
FROM	Arguments		IMPORT	NumArgs, GetArg;
FROM	String			IMPORT	Length, Compare, ComparePart,
					ANSICapString,
					Copy, CopyPart,
					Concat, ConcatChar;
FROM	DosD			IMPORT	maxTemplateItems,
					RDArgsPtr;
FROM	DosL			IMPORT	ReadArgs, FreeArgs,
					AllocDosObject, FreeDosObject,
					FindArg,
					FPuts,
					Output;
FROM	WorkbenchD		IMPORT	WBObjectType,
					DiskObjectPtr;
FROM	IconL			IMPORT	GetDiskObject, FreeDiskObject,
					FindToolType, MatchToolValue;
FROM	Memory			IMPORT	Allocate, Deallocate;


CONST	CaseEqual		=FALSE;
	maxTemplate		=1024;
	dosRDArgs		=5;	(* fehlt noch in DosD.def *)


VAR	Programmicon		:DiskObjectPtr;
	ArgTemplate,
	Arguments		:ARRAY [0..maxTemplate] OF CHAR;
	ArgArray		:ARRAY [0..maxTemplateItems] OF LONGINT;
	MyRDArguments,
	RDArguments		:RDArgsPtr;
	ShowInfo		:InfoProcedure;


(*
 * --- private Funktionen -------------------------------------------------------
 *)

PROCEDURE GetIcon;

VAR	Laenge			:INTEGER;
	Iconname		:Str;


BEGIN
GetArg (0, Iconname, Laenge);
Programmicon := GetDiskObject (ADR (Iconname))
END GetIcon;


PROCEDURE StandardInfo ();

VAR	dummy	:BOOLEAN;

BEGIN
IF Output () # NIL THEN
  dummy := FPuts (Output (), programName);
  dummy := FPuts (Output (), ADR (": "));
  dummy := FPuts (Output (), ADR (ArgTemplate));
  dummy := FPuts (Output (), ADR ("\nGefordertes Argument fehlt.\n"));
  END
END StandardInfo;


(*
 * --- öffentliche Funktionen ---------------------------------------------------
 *)

PROCEDURE SetArgumentInfo	(    ArgumentInfo	:InfoProcedure);

BEGIN
ShowInfo := ArgumentInfo
END SetArgumentInfo;


PROCEDURE UseArguments		(    Template		:ARRAY OF CHAR);

VAR	i	:CARDINAL;

BEGIN
IF NOT (wbStarted) THEN
  Copy (ArgTemplate, Template);

  FOR i := 0 TO maxTemplateItems-1 DO
    ArgArray[i] := 0
    END;


  MyRDArguments := AllocDosObject (dosRDArgs, NIL);
  Assert (MyRDArguments # NIL, ADR ("Argumentstruktur nicht anzulegen."));

  Copy (Arguments, StrPtr (dosCmdBuf)^);

  WITH MyRDArguments^.source DO
    buffer := ADR (Arguments);
    length := Length (Arguments)
    END;


  RDArguments := ReadArgs (ADR (ArgTemplate), ADR (ArgArray), NIL (*MyRDArguments*));

  IF RDArguments = NIL THEN
    ShowInfo ();					(* Prozedurvariable		*)
    Exit (10)
    END

  END
END UseArguments;


PROCEDURE ArgString		(    Keyword,
				     Default		:ARRAY OF CHAR;
				 VAR Value		:ARRAY OF CHAR);

VAR	i		:LONGINT;
	ToolType	:StrPtr;
	Name		:Str;

BEGIN
Copy (Name, Keyword);
ANSICapString (Name);

IF wbStarted THEN
  IF Programmicon = NIL THEN
    Copy (Value, Default);
    RETURN
    END;

  ToolType := FindToolType (Programmicon^.toolTypes, ADR (Name));
  IF ToolType = NIL THEN
    Copy (Value, Default);
    RETURN
  ELSE
    Copy (Value, ToolType^);
    RETURN
    END

ELSE (* NOT wbStarted *)
  i := FindArg (ADR (ArgTemplate), ADR (Keyword));
  Assert (i # -1, ADR ("ArgString: das Schlüsselwort fehlt in der Schablone."));

  IF StrPtr (ArgArray[i]) # NIL THEN
    Copy (Value, StrPtr (ArgArray[i])^)
  ELSE
    Copy (Value, Default)
    END;
  RETURN
  END
END ArgString;


PROCEDURE ArgInt		(    Keyword		:ARRAY OF CHAR;
				     Default		:INTEGER) :INTEGER;


TYPE	NumPtr		=POINTER TO LONGINT;

VAR	Negativ, Error	:BOOLEAN;
	Number, i	:LONGINT;
	Value		:Str;
	ToolType	:StrPtr;

BEGIN
ANSICapString (Keyword);

IF wbStarted THEN
  IF Programmicon = NIL THEN
    RETURN Default
    END;

  ToolType := FindToolType (Programmicon^.toolTypes, ADR (Keyword));
  IF ToolType = NIL THEN
    RETURN Default
  ELSE
    Copy (Value, ToolType^)
    END;
  StrToVal (Value, Number, Negativ, 10, Error);
  IF NOT (Error) & (MIN (INTEGER) <= Number) & (Number <= MAX (INTEGER)) THEN
    RETURN Number
  ELSE
    RETURN Default
    END

ELSE (* NOT wbStarted *)
  i := FindArg (ADR (ArgTemplate), ADR (Keyword));
  Assert (i # -1, ADR ("ArgInt: das Schlüsselwort fehlt in der Schablone."));

  IF (NumPtr (ArgArray[i]) # NIL) &
     (MIN (INTEGER) <= NumPtr (ArgArray[i])^) & (NumPtr (ArgArray[i])^ <= MAX (INTEGER)) THEN
    RETURN NumPtr (ArgArray[i])^
  ELSE
    RETURN Default
    END
  END
END ArgInt;


PROCEDURE ArgBoolean		(    Keyword		:ARRAY OF CHAR;
				     Default		:BOOLEAN) :BOOLEAN;

VAR	i		:LONGINT;
	Value		:Str;
	ToolType	:StrPtr;

BEGIN
ANSICapString (Keyword);

IF wbStarted THEN
  IF Programmicon = NIL THEN
    RETURN Default
    END;

  ToolType := FindToolType (Programmicon^.toolTypes, ADR (Keyword));
  IF ToolType = NIL THEN
    RETURN Default
    END;

  IF    MatchToolValue (ToolType, ADR ("yes")) OR
        MatchToolValue (ToolType, ADR ("YES")) OR
        MatchToolValue (ToolType, ADR ("Yes")) THEN
    RETURN TRUE
  ELSIF MatchToolValue (ToolType, ADR ("no")) OR
        MatchToolValue (ToolType, ADR ("NO")) OR
        MatchToolValue (ToolType, ADR ("No")) THEN
    RETURN FALSE
  ELSE
    RETURN Default
    END

ELSE (* NOT wbStarted *)
  i := FindArg (ADR (ArgTemplate), ADR (Keyword));
  Assert (i # -1, ADR ("ArgBoolean: das Schlüsselwort fehlt in der Schablone."));

  RETURN (ArgArray[i] # 0)
  END
END ArgBoolean;


PROCEDURE ArgMultiple		(    Keyword		:ARRAY OF CHAR) :StrArrayPtr;


VAR	i		:LONGINT;

BEGIN
IF wbStarted THEN
  RETURN NIL

ELSE
  i := FindArg (ADR (ArgTemplate), ADR (Keyword));
  Assert (i # -1, ADR ("ArgMultiple: das Schlüsselwort fehlt in der Schablone."));

  RETURN StrArrayPtr (ArgArray[i])
  END
END ArgMultiple;


(* NewArgSupport *)
BEGIN
Programmicon := NIL;
RDArguments := NIL;
MyRDArguments := NIL;
ShowInfo := StandardInfo;

IF wbStarted THEN
  GetIcon
  END;


CLOSE
IF Programmicon # NIL THEN
  FreeDiskObject (Programmicon);
  Programmicon := NIL
  END;

IF RDArguments # NIL THEN
  FreeArgs (RDArguments);
  RDArguments := NIL;
  END;

IF MyRDArguments # NIL THEN
  FreeDosObject (dosRDArgs, MyRDArguments);
  MyRDArguments := NIL
  END
END NewArgSupport.
