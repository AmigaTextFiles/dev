(* $Id: Scanner.mi,v 2.10 1992/08/18 09:05:32 grosch rel $ *)

$@ IMPLEMENTATION MODULE @;
 
$@ IMPORT SYSTEM, Checks, System, General, Positions, IO, DynArray, Strings, $Source;
$G global user declarations
 
CONST
   yyTabSpace		= 8;
   yyDNoState		= 0;
   yyFileStackSize	= 16;
   yyInitBufferSize	= 1024 * 8 + 256;
$C constant declarations
 
TYPE
   yyTableElmt		= SHORTCARD;
   yyStateRange		= yyTableElmt [0 .. yyDStateCount];
   yyTableRange		= yyTableElmt [0 .. yyTableSize];
   yyCombType		= RECORD Check, Next: yyStateRange; END;
   yyCombTypePtr	= POINTER TO yyCombType;
   yytChBufferPtr	= POINTER TO ARRAY [0 .. 1000000] OF CHAR;
   yyChRange		= [yyFirstCh .. yyLastCh];

VAR
   yyBasePtr		: ARRAY yyStateRange	OF LONGCARD	;
   yyDefault		: ARRAY yyStateRange	OF yyStateRange	;
   yyComb		: ARRAY yyTableRange	OF yyCombType	;
   yyEobTrans		: ARRAY yyStateRange	OF yyStateRange	;
$M yyAction		: ARRAY yyStateRange	OF yyTableElmt	;
   yyToLower, yyToUpper	: ARRAY yyChRange	OF CHAR		;

   yyStateStack		: POINTER TO ARRAY [0 .. 1000000] OF yyStateRange;
   yyStateStackSize	: LONGINT;
   yyStartState		: yyStateRange;
   yyPreviousStart	: yyStateRange;
   yyCh			: CHAR;
 
   yySourceFile		: System.tFile;
   yyEof		: BOOLEAN;
   yyChBufferPtr	: yytChBufferPtr;
   yyChBufferStart	: INTEGER;
   yyChBufferSize	: LONGINT;
   yyChBufferIndex	: INTEGER;
   yyBytesRead		: INTEGER;
   yyLineCount		: CARDINAL;
   yyLineStart		: INTEGER;

   yyFileStackPtr	: SHORTCARD;
   yyFileStack		: ARRAY [1 .. yyFileStackSize] OF RECORD
   			     SourceFile		: System.tFile;
			     Eof		: BOOLEAN;
   			     ChBufferPtr	: yytChBufferPtr;
			     ChBufferStart	: INTEGER;
			     ChBufferSize	: LONGINT;
   			     ChBufferIndex	: INTEGER;
   			     BytesRead		: INTEGER;
   			     LineCount		: CARDINAL;
   			     LineStart		: INTEGER;
			  END;

PROCEDURE GetToken (): INTEGER;
   VAR
      yyState		: yyStateRange;
      yyTablePtr	: yyCombTypePtr;
      yyRestartFlag	: BOOLEAN;
      yyi, yySource, yyTarget, yyChBufferFree	: INTEGER;
$L local user declarations
BEGIN
   LOOP
      yyState		:= yyStartState;
      TokenLength 	:= 0;
$J    IF yyChBufferPtr^ [yyChBufferIndex - 1] = yyEolCh THEN INC (yyState); END;
 
      (* ASSERT yyChBuffer [yyChBufferIndex] = first character *)
 
      LOOP		(* eventually restart after sentinel *)
	 LOOP		(* execute as many state transitions as possible *)
	    					(* determine next state *)
	    yyTablePtr := yyCombTypePtr (yyBasePtr [yyState] +
	       ORD (yyChBufferPtr^ [yyChBufferIndex]) * SYSTEM.TSIZE (yyCombType));
	    IF yyTablePtr^.Check # yyState THEN
	       yyState := yyDefault [yyState];
	       IF yyState = yyDNoState THEN EXIT; END;
	    ELSE
	       yyState := yyTablePtr^.Next;
	       INC (TokenLength);
	       yyStateStack^ [TokenLength] := yyState;	(* push state *)
	       INC (yyChBufferIndex);		(* get next character *)
	    END;
	 END;
 
	 LOOP					(* search for last final state *)
$A case header and user actions		(* CASE yyStateStack^ [TokenLength] OF *)
$N non final states
	    (* non final states *)
		  DEC (yyChBufferIndex);	(* return character *)
		  DEC (TokenLength)		(* pop state *)
 
$P	    |  yyDefaultState	: 
		  Attribute.Position.Line   := yyLineCount;
		  Attribute.Position.Column := yyChBufferIndex - yyLineStart;
		  INC (yyChBufferIndex);
		  TokenLength := 1;
$D default action
	          yyRestartFlag := FALSE; EXIT;

	    |  yyDNoState	:		(* automatic initialization *)
		  yyGetTables;
		  yyStateStack^ [0] := yyDefaultState; (* stack underflow sentinel *)
		  IF yyFileStackPtr = 0 THEN
		     yyInitialize;
		     yySourceFile := System.StdInput;
		  END;
	          yyRestartFlag := FALSE; EXIT;

$O	    |  yyEobState	:		(* end of buffer sentinel found *)
		  DEC (yyChBufferIndex);	(* undo last state transition *)
		  DEC (TokenLength);		(* get previous state *)
		  IF TokenLength = 0 THEN
		     yyState := yyStartState;
$J		     IF yyChBufferPtr^ [yyChBufferIndex - 1] = yyEolCh THEN INC (yyState); END;
		  ELSE
		     yyState := yyStateStack^ [TokenLength];
		  END;

		  IF yyChBufferIndex # yyChBufferStart + yyBytesRead THEN
		     yyState := yyEobTrans [yyState];	(* end of buffer sentinel in buffer *)
		     IF yyState # yyDNoState THEN
			INC (yyChBufferIndex);
			INC (TokenLength);
			yyStateStack^ [TokenLength] := yyState;
			yyRestartFlag := TRUE; EXIT;
		     END;
		  ELSE				(* end of buffer reached *)

		     (* copy initial part of token in front of input buffer *)

		     yySource := yyChBufferIndex - TokenLength - 1;
		     yyTarget := General.MaxAlign - TokenLength MOD General.MaxAlign - 1;
		     IF yySource # yyTarget THEN
			FOR yyi := 1 TO TokenLength DO
			   yyChBufferPtr^ [yyTarget + yyi] := yyChBufferPtr^ [yySource + yyi];
			END;
			DEC (yyLineStart, yySource - yyTarget);
			yyChBufferStart := yyTarget + TokenLength + 1;
		     ELSE
			yyChBufferStart := yyChBufferIndex;
		     END;

		     IF NOT yyEof THEN		(* read buffer and restart *)
			yyChBufferFree := General.Exp2 (General.Log2 (yyChBufferSize - 4 - General.MaxAlign - TokenLength));
			IF yyChBufferFree < yyChBufferSize DIV 8 THEN
			   DynArray.ExtendArray (yyChBufferPtr, yyChBufferSize, SYSTEM.TSIZE (CHAR));
			   IF yyChBufferPtr = NIL THEN yyErrorMessage (1); END;
			   yyChBufferFree := General.Exp2 (General.Log2 (yyChBufferSize - 4 - General.MaxAlign - TokenLength));
			   IF yyStateStackSize < yyChBufferSize THEN
			      DynArray.ExtendArray (yyStateStack, yyStateStackSize, SYSTEM.TSIZE (yyStateRange));
			      IF yyStateStack = NIL THEN yyErrorMessage (1); END;
			   END;
			END;
			yyChBufferIndex := yyChBufferStart;
$@ 			yyBytesRead := $Source.GetLine (yySourceFile, SYSTEM.ADR
			   (yyChBufferPtr^ [yyChBufferIndex]), yyChBufferFree);
			IF yyBytesRead <= 0 THEN yyBytesRead := 0; yyEof := TRUE; END;
			yyChBufferPtr^ [yyChBufferStart + yyBytesRead    ] := yyEobCh;
			yyChBufferPtr^ [yyChBufferStart + yyBytesRead + 1] := 0C;
			yyRestartFlag := TRUE; EXIT;
		     END;

		     IF TokenLength = 0 THEN	(* end of file reached *)
			Attribute.Position.Line   := yyLineCount;
			Attribute.Position.Column := yyChBufferIndex - yyLineStart;
			CloseFile;
			IF yyFileStackPtr = 0 THEN
$E eof action
			END;
			IF yyFileStackPtr = 0 THEN RETURN EofToken; END;
			yyRestartFlag := FALSE; EXIT;
		     END;
		  END;
	    ELSE
	       yyErrorMessage (0);
	    END;
	 END;
	 IF yyRestartFlag THEN ELSE EXIT; END;
      END;
   END;
   END GetToken;
 
PROCEDURE BeginFile (FileName: ARRAY OF CHAR);
   BEGIN
      IF yyStateStack^ [0] = yyDNoState THEN	(* have tables been read in ? *)
	 yyGetTables;
	 yyStateStack^ [0] := yyDefaultState;	(* stack underflow sentinel *)
      END;
      yyInitialize;
$@       yySourceFile := $Source.BeginSource (FileName);
   END BeginFile;

PROCEDURE yyInitialize;
   BEGIN
      IF yyFileStackPtr >= yyFileStackSize THEN yyErrorMessage (3); END;
      INC (yyFileStackPtr);			(* push file *)
      WITH yyFileStack [yyFileStackPtr] DO
	 SourceFile	:= yySourceFile		;
	 Eof		:= yyEof		;
	 ChBufferPtr	:= yyChBufferPtr	;
	 ChBufferStart	:= yyChBufferStart	;
	 ChBufferSize	:= yyChBufferSize	;
	 ChBufferIndex	:= yyChBufferIndex	;
	 BytesRead	:= yyBytesRead		;
	 LineCount	:= yyLineCount		;
	 LineStart	:= yyLineStart		;
      END;
						(* initialize file state *)
      yyChBufferSize	:= yyInitBufferSize;
      DynArray.MakeArray (yyChBufferPtr, yyChBufferSize, SYSTEM.TSIZE (CHAR));
      yyChBufferStart	:= General.MaxAlign;
      yyChBufferPtr^ [yyChBufferStart - 1] := yyEolCh; (* begin of line indicator *)
      yyChBufferPtr^ [yyChBufferStart    ] := yyEobCh; (* end of buffer sentinel *)
      yyChBufferPtr^ [yyChBufferStart + 1] := 0C;
      yyChBufferIndex	:= yyChBufferStart;
      yyEof		:= FALSE;
      yyBytesRead	:= 0;
      yyLineCount	:= 1;
      yyLineStart	:= yyChBufferStart - 1;
   END yyInitialize;

PROCEDURE CloseFile;
   BEGIN
      IF yyFileStackPtr = 0 THEN yyErrorMessage (4); END;
$@       $Source.CloseSource (yySourceFile);
      DynArray.ReleaseArray (yyChBufferPtr, yyChBufferSize, SYSTEM.TSIZE (CHAR));
      WITH yyFileStack [yyFileStackPtr] DO	(* pop file *)
	 yySourceFile	:= SourceFile		;
	 yyEof		:= Eof			;
	 yyChBufferPtr	:= ChBufferPtr		;
	 yyChBufferStart:= ChBufferStart	;
	 yyChBufferSize	:= ChBufferSize		;
	 yyChBufferIndex:= ChBufferIndex	;
	 yyBytesRead	:= BytesRead		;
	 yyLineCount	:= LineCount		;
	 yyLineStart	:= LineStart		;
      END;
      DEC (yyFileStackPtr);		
   END CloseFile;

PROCEDURE GetWord (VAR Word: Strings.tString);
   VAR i, WordStart	: INTEGER;
   BEGIN
      WordStart := yyChBufferIndex - TokenLength - 1;
      FOR i := 1 TO TokenLength DO
	 Word.Chars [i] := yyChBufferPtr^ [WordStart + i];
      END;
      Word.Length := TokenLength;
   END GetWord;
 
PROCEDURE GetLower (VAR Word: Strings.tString);
   VAR i, WordStart	: INTEGER;
   BEGIN
      WordStart := yyChBufferIndex - TokenLength - 1;
      FOR i := 1 TO TokenLength DO
	 Word.Chars [i] := yyToLower [yyChBufferPtr^ [WordStart + i]];
      END;
      Word.Length := TokenLength;
   END GetLower;
 
PROCEDURE GetUpper (VAR Word: Strings.tString);
   VAR i, WordStart	: INTEGER;
   BEGIN
      WordStart := yyChBufferIndex - TokenLength - 1;
      FOR i := 1 TO TokenLength DO
	 Word.Chars [i] := yyToUpper [yyChBufferPtr^ [WordStart + i]];
      END;
      Word.Length := TokenLength;
   END GetUpper;
 
PROCEDURE yyStart (State: yyStateRange);
   BEGIN
      yyPreviousStart	:= yyStartState;
      yyStartState	:= State;
   END yyStart;
 
PROCEDURE yyPrevious;
   VAR s	: yyStateRange;
   BEGIN
      s		      := yyStartState;
      yyStartState    := yyPreviousStart;
      yyPreviousStart := s;
   END yyPrevious;
 
PROCEDURE yyEcho;
   VAR i	: INTEGER;
   BEGIN
      FOR i := yyChBufferIndex - TokenLength TO yyChBufferIndex - 1 DO
	 IO.WriteC (IO.StdOutput, yyChBufferPtr^ [i]);
      END;
   END yyEcho;
 
PROCEDURE yyLess (n: INTEGER);
   BEGIN
      DEC (yyChBufferIndex, TokenLength - n);
      TokenLength := n;
   END yyLess;
 
PROCEDURE yyTab;
   BEGIN
      DEC (yyLineStart, yyTabSpace - 1 - (yyChBufferIndex - yyLineStart - 2) MOD yyTabSpace);
   END yyTab;

PROCEDURE yyTab1 (a: INTEGER);
   BEGIN
      DEC (yyLineStart, yyTabSpace - 1 - (yyChBufferIndex - yyLineStart - TokenLength + a - 1) MOD yyTabSpace);
   END yyTab1;

PROCEDURE yyTab2 (a, b: INTEGER);
   BEGIN
      DEC (yyLineStart, yyTabSpace - 1 - (yyChBufferIndex - yyLineStart - TokenLength + a - 1) MOD yyTabSpace);
   END yyTab2;

PROCEDURE yyEol (Column: INTEGER);
   BEGIN
      INC (yyLineCount);
      yyLineStart := yyChBufferIndex - 1 - Column;
   END yyEol;

PROCEDURE output (c: CHAR);
   BEGIN
      IO.WriteC (IO.StdOutput, c);
   END output;

PROCEDURE unput (c: CHAR);
   BEGIN
      DEC (yyChBufferIndex);
      yyChBufferPtr^ [yyChBufferIndex] := c;
   END unput;

PROCEDURE input (): CHAR;
   BEGIN
      IF yyChBufferIndex = yyChBufferStart + yyBytesRead THEN
	 IF NOT yyEof THEN
	    DEC (yyLineStart, yyBytesRead);
	    yyChBufferIndex := 0;
	    yyChBufferStart := 0;
$@ 	    yyBytesRead := $Source.GetLine (yySourceFile, yyChBufferPtr, General.Exp2 (General.Log2 (yyChBufferSize)));
	    IF yyBytesRead <= 0 THEN yyBytesRead := 0; yyEof := TRUE; END;
	    yyChBufferPtr^ [yyBytesRead    ] := yyEobCh;
	    yyChBufferPtr^ [yyBytesRead + 1] := 0C;
	 END;
      END;
      IF yyChBufferIndex = yyChBufferStart + yyBytesRead THEN
	 RETURN 0C;
      ELSE
	 INC (yyChBufferIndex);
	 RETURN yyChBufferPtr^ [yyChBufferIndex - 1];
      END
   END input;

PROCEDURE BeginScanner;
   BEGIN
$I user initialization code
   END BeginScanner;
 
PROCEDURE CloseScanner;
   BEGIN
$F user finalization code
   END CloseScanner;
 
PROCEDURE yyGetTables;
   VAR
      BlockSize, j, n	: CARDINAL;
      TableFile	: System.tFile;
      i		: yyStateRange;
      Base	: ARRAY yyStateRange OF yyTableRange;
   BEGIN
      BlockSize	:= 64000 DIV SYSTEM.TSIZE (yyCombType);
      TableFile := System.OpenInput (ScanTabName);
      Checks.ErrorCheck ("yyGetTables.OpenInput", TableFile);
      IF (yyGetTable (TableFile, SYSTEM.ADR (Base      )) DIV SYSTEM.TSIZE (yyTableElmt) - 1 # yyDStateCount) OR
         (yyGetTable (TableFile, SYSTEM.ADR (yyDefault )) DIV SYSTEM.TSIZE (yyTableElmt) - 1 # yyDStateCount) OR
         (yyGetTable (TableFile, SYSTEM.ADR (yyEobTrans)) DIV SYSTEM.TSIZE (yyTableElmt) - 1 # yyDStateCount)
$M    OR (yyGetTable (TableFile, SYSTEM.ADR (yyAction  )) DIV SYSTEM.TSIZE (yyTableElmt) - 1 # yyDStateCount)
	 THEN
	 yyErrorMessage (2);
      END;
      n := 0;
      j := 0;
      WHILE j <= yyTableSize DO
         INC (n, yyGetTable (TableFile, SYSTEM.ADR (yyComb [j])) DIV SYSTEM.TSIZE (yyCombType));
         INC (j, BlockSize);
      END;
      IF n # yyTableSize + 1 THEN yyErrorMessage (2); END;
      System.Close (TableFile);

      FOR i := 0 TO yyDStateCount DO
	 yyBasePtr [i] := LONGCARD (SYSTEM.ADR (yyComb [Base [i]]));
      END;
   END yyGetTables;
 
PROCEDURE yyGetTable (TableFile: System.tFile; Address: SYSTEM.ADDRESS): CARDINAL;
   VAR
      N		: INTEGER;
      Length	: yyTableElmt;
   BEGIN
      N := System.Read (TableFile, SYSTEM.ADR (Length), SYSTEM.TSIZE (yyTableElmt));
      Checks.ErrorCheck ("yyGetTable.Read1", N);
      N := System.Read (TableFile, Address, Length);
      Checks.ErrorCheck ("yyGetTable.Read2", N);
      RETURN Length;
   END yyGetTable;
 
PROCEDURE yyErrorMessage (ErrorCode: SHORTCARD);
   BEGIN
      Positions.WritePosition (IO.StdError, Attribute.Position);
      CASE ErrorCode OF
$@    | 0: IO.WriteS (IO.StdError, ": @: internal error");
$@    | 1: IO.WriteS (IO.StdError, ": @: out of memory");
$@    | 2: IO.WriteS (IO.StdError, ": @: table mismatch");
$@    | 3: IO.WriteS (IO.StdError, ": @: too many nested include files");
$@    | 4: IO.WriteS (IO.StdError, ": @: file stack underflow (too many calls of CloseFile)");
      END;
      IO.WriteNl (IO.StdError); Exit;
   END yyErrorMessage;
 
PROCEDURE yyExit;
   BEGIN
      IO.CloseIO; System.Exit (1);
   END yyExit;

BEGIN
$@    ScanTabName		:= "@.Tab";
   Exit			:= yyExit;
   yyFileStackPtr	:= 0;
   yyStartState		:= 1;			(* set up for auto init *)
   yyPreviousStart	:= 1;
   yyBasePtr [yyStartState] := LONGCARD (SYSTEM.ADR (yyComb [0]));
   yyDefault [yyStartState] := yyDNoState;
   yyComb [0].Check	:= yyDNoState;
   yyChBufferPtr	:= SYSTEM.ADR (yyComb [0]);	(* dirty trick *)
   yyChBufferIndex	:= 1;				(* dirty trick *)
   yyStateStackSize	:= yyInitBufferSize;
   DynArray.MakeArray (yyStateStack, yyStateStackSize, SYSTEM.TSIZE (yyStateRange));
   yyStateStack^ [0]	:= yyDNoState;
   
   FOR yyCh := yyFirstCh TO yyLastCh DO yyToLower [yyCh] := yyCh; END;
   yyToUpper := yyToLower;
   FOR yyCh := 'A' TO 'Z' DO
      yyToLower [yyCh] := CHR (ORD (yyCh) - ORD ('A') + ORD ('a'));
   END;
   FOR yyCh := 'a' TO 'z' DO
      yyToUpper [yyCh] := CHR (ORD (yyCh) - ORD ('a') + ORD ('A'));
   END;
$@ END @.
