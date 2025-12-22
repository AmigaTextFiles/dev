(* $Id: Parser.mi,v 2.8 1992/08/12 06:54:05 grosch rel $ *)

$@ IMPLEMENTATION MODULE @;

$@ IMPORT SYSTEM, $, Positions, Errors, Strings, DynArray, Sets, System;

$G	(* GLOBAL section is inserted here *)

CONST
   yyInitStackSize	= 100;
   yyNoState		= 0;

$T	(* Table Constants are inserted here *)

   yyFirstFinalState	= yyFirstReadTermState;
   yyLastState		= yyLastReduceState;

TYPE
   yyTableElmt		= SHORTCARD;
   yyTCombRange		= yyTableElmt [0 .. yyTableMax];
   yyNCombRange		= yyTableElmt [yyLastTerminal + 1 .. yyNTableMax];
   yyStateRange		= yyTableElmt [0 .. yyLastState];
   yyReadRange		= yyTableElmt [yyFirstReadState .. yyLastReadState];
   yyReadReduceRange	= yyTableElmt [yyFirstReadTermState ..yyLastReadNontermState];
   yyReduceRange	= yyTableElmt [yyFirstReduceState .. yyLastReduceState];
   yySymbolRange	= yyTableElmt [yyFirstSymbol .. yyLastSymbol];
   yyTCombType		= RECORD Check, Next: yyStateRange; END;
   yyNCombType		= yyStateRange;
   yyTCombTypePtr	= POINTER TO yyTCombType;
   yyNCombTypePtr	= POINTER TO yyNCombType;
   yyStackType		= POINTER TO ARRAY [0 .. 1000000] OF yyStateRange;

VAR
   yyTBasePtr		: ARRAY [0 .. yyLastReadState]	OF yyTCombTypePtr;
   yyNBasePtr		: ARRAY [0 .. yyLastReadState]	OF yyNCombTypePtr;
   yyDefault		: ARRAY [0 .. yyLastReadState]	OF yyReadRange	;
   yyTComb		: ARRAY yyTCombRange		OF yyTCombType	;
   yyNComb		: ARRAY yyNCombRange		OF yyNCombType	;
   yyLength		: ARRAY yyReduceRange		OF yyTableElmt	;
   yyLeftHandSide	: ARRAY yyReduceRange		OF yySymbolRange;
   yyContinuation	: ARRAY [0 .. yyLastReadState]	OF yySymbolRange;
   yyFinalToProd	: ARRAY yyReadReduceRange	OF yyReduceRange;
   yyIsInitialized	: BOOLEAN;
   yyTableFile		: System.tFile;

PROCEDURE TokenName (Token: CARDINAL; VAR Name: ARRAY OF CHAR);
   PROCEDURE Copy (Source: ARRAY OF CHAR; VAR Target: ARRAY OF CHAR);
      VAR i, j: CARDINAL;
      BEGIN
	 IF HIGH (Source) < HIGH (Target)
	 THEN j := HIGH (Source); ELSE j := HIGH (Target); END;
	 FOR i := 0 TO j DO Target [i] := Source [i]; END;
	 IF HIGH (Target) > j THEN Target [j + 1] := CHR (0); END;
      END Copy;
   BEGIN
      CASE Token OF
$W	(* token names are inserted here *)
      END;
   END TokenName;

$@ PROCEDURE @ (): CARDINAL;
$L	(* LOCAL section is inserted here *)
   VAR
      yyState		: yyStateRange;
      yyTerminal	: yySymbolRange;
      yyNonterminal	: yySymbolRange;	(* left-hand side symbol *)
      yyStackPtr	: yyTableElmt;
      yyStateStackSize	: LONGINT;
      yyAttrStackSize	: LONGINT;
      yyShortStackSize	: yyTableElmt;
      yyStateStack	: yyStackType;
      yyAttributeStack	: POINTER TO ARRAY [0 .. 1000000] OF tParsAttribute;
      yySynAttribute	: tParsAttribute;	(* synthesized attribute *)
$@       yyRepairAttribute : $.tScanAttribute;
      yyRepairToken	: yySymbolRange;
      yyTCombPtr	: yyTCombTypePtr;
      yyNCombPtr	: yyNCombTypePtr;
      yyIsRepairing	: BOOLEAN;
      yyErrorCount	: CARDINAL;
      yyTokenString	: ARRAY [0..127] OF CHAR;
   BEGIN
$@       Begin@;
      yyState		:= yyStartState;
$@       yyTerminal	:= $.GetToken ();
      yyStateStackSize	:= yyInitStackSize;
      yyAttrStackSize	:= yyInitStackSize;
      DynArray.MakeArray (yyStateStack, yyStateStackSize, SYSTEM.TSIZE (yyStateRange));
      DynArray.MakeArray (yyAttributeStack, yyAttrStackSize, SYSTEM.TSIZE (tParsAttribute));
      yyShortStackSize	:= yyStateStackSize - 1;
      yyStackPtr	:= 0;
      yyErrorCount	:= 0;
      yyIsRepairing	:= FALSE;

      LOOP
	 IF yyStackPtr >= yyShortStackSize THEN
	    DynArray.ExtendArray (yyStateStack, yyStateStackSize, SYSTEM.TSIZE (yyStateRange));
	    DynArray.ExtendArray (yyAttributeStack, yyAttrStackSize, SYSTEM.TSIZE (tParsAttribute));
	    yyShortStackSize := yyStateStackSize - 1;
	 END;
	 yyStateStack^ [yyStackPtr] := yyState;

	 LOOP	(* SPEC State := Next (State, Terminal); terminal transition *)
	    yyTCombPtr := yyTCombTypePtr (LONGCARD (yyTBasePtr [yyState]) 
			     + yyTerminal * SYSTEM.TSIZE (yyTCombType));
	    IF yyTCombPtr^.Check = yyState THEN
	       yyState := yyTCombPtr^.Next;
	       EXIT;
	    END;
	    yyState := yyDefault [yyState];

	    IF yyState = yyNoState THEN			(* syntax error *)
	       yyState := yyStateStack^ [yyStackPtr];
	       IF yyIsRepairing THEN			(* repair *)
		  yyRepairToken := yyContinuation [yyState];
		  yyState := Next (yyState, yyRepairToken);
		  IF yyState <= yyLastReadTermState THEN (* read or read terminal reduce ? *)
$@ 		     $.ErrorAttribute (yyRepairToken, yyRepairAttribute);
		     TokenName (yyRepairToken, yyTokenString);
		     Errors.ErrorMessageI (Errors.TokenInserted, Errors.Repair,
$@ 			$.Attribute.Position, Errors.Array, SYSTEM.ADR (yyTokenString));
		     IF yyState >= yyFirstFinalState THEN (* avoid second push *)
			yyState := yyFinalToProd [yyState];
		     END;
		     INC (yyStackPtr);
		     yyAttributeStack^ [yyStackPtr].Scan := yyRepairAttribute;
		     yyStateStack^     [yyStackPtr] := yyState;
		  END;
		  IF yyState >= yyFirstFinalState THEN	(* final state ? *)
		    EXIT;
		  END;
	       ELSE					(* report and recover *)
		  INC (yyErrorCount);
		  ErrorRecovery (yyTerminal, yyStateStack, yyStateStackSize, yyStackPtr);
		  yyIsRepairing := TRUE;
	       END;
	    END;
	 END;

	 IF yyState >= yyFirstFinalState THEN		(* final state ? *)
	    IF yyState <= yyLastReadTermState THEN	(* read terminal reduce ? *)
	       INC (yyStackPtr);
$@ 	       yyAttributeStack^ [yyStackPtr].Scan := $.Attribute;
$@ 	       yyTerminal := $.GetToken ();
	       yyIsRepairing := FALSE;
$X	       yyState := yyFinalToProd [yyState];
	    END;

	    LOOP					(* reduce *)
$R	(* Code for Reductions is inserted here *)
	       (* SPEC State := Next (Top (), Nonterminal); nonterminal transition *)
	       yyNCombPtr := yyNCombTypePtr (LONGCARD (yyNBasePtr [yyStateStack^ [yyStackPtr]])
				+ yyNonterminal * SYSTEM.TSIZE (yyNCombType));
	       yyState := yyNCombPtr^;
	       INC (yyStackPtr);
	       yyAttributeStack^ [yyStackPtr] := yySynAttribute;
	       IF yyState < yyFirstFinalState THEN EXIT END; (* read nonterminal ? *)
$X	       yyState := yyFinalToProd [yyState];
	    END;

	 ELSE						(* read *)
	    INC (yyStackPtr);
$@ 	    yyAttributeStack^ [yyStackPtr].Scan := $.Attribute;
$@ 	    yyTerminal := $.GetToken ();
	    yyIsRepairing := FALSE;
	 END;
      END;
$@    END @;

PROCEDURE ErrorRecovery (
      VAR Terminal	: yySymbolRange	;
	  StateStack	: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	);
   VAR
      TokensSkipped	: BOOLEAN;
      ContinueSet	: Sets.tSet;
      RestartSet	: Sets.tSet;
      Token		: yySymbolRange;
      TokenArray	: ARRAY [0..127] OF CHAR;
      TokenString	: Strings.tString;
      ContinueString	: Strings.tString;
   BEGIN
   (* 1. report the error *)
$@       Errors.ErrorMessage (Errors.SyntaxError, Errors.Error, $.Attribute.Position);

   (* 2. report the set of expected terminal symbols *)
      Sets.MakeSet (ContinueSet, yyLastTerminal);
      ComputeContinuation (StateStack, StackSize, StackPtr, ContinueSet);
      Strings.AssignEmpty (ContinueString);
      FOR Token := Sets.Minimum (ContinueSet) TO Sets.Maximum (ContinueSet) DO
	 IF Sets.IsElement (Token, ContinueSet) THEN
	    TokenName (Token, TokenArray);
	    Strings.ArrayToString (TokenArray, TokenString);
	    IF (Strings.Length (ContinueString) + Strings.Length (TokenString) + 1 <= Strings.cMaxStrLength) THEN
	       Strings.Concatenate (ContinueString, TokenString);
	       Strings.Append (ContinueString, ' ');
	    END;
	 END;
      END;
      Errors.ErrorMessageI (Errors.ExpectedTokens, Errors.Information,
$@ 	 $.Attribute.Position, Errors.String, SYSTEM.ADR (ContinueString));
      Sets.ReleaseSet (ContinueSet);

   (* 3. compute the set of terminal symbols for restart of the parse *)
      Sets.MakeSet (RestartSet, yyLastTerminal);
      ComputeRestartPoints (StateStack, StackSize, StackPtr, RestartSet);

   (* 4. skip terminal symbols until a restart point is reached *)
      TokensSkipped := FALSE;
      WHILE NOT Sets.IsElement (Terminal, RestartSet) DO
$@ 	 Terminal := $.GetToken ();
	 TokensSkipped := TRUE;
      END;
      Sets.ReleaseSet (RestartSet);

   (* 5. report the restart point *)
      IF TokensSkipped THEN
$@ 	 Errors.ErrorMessage (Errors.RestartPoint, Errors.Information, $.Attribute.Position);
      END;
   END ErrorRecovery;

(*
   compute the set of terminal symbols that can be accepted (read)
   in a given stack configuration (eventually after reduce actions)
*)

PROCEDURE ComputeContinuation (
	  Stack		: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	;
      VAR ContinueSet	: Sets.tSet	);
   VAR Terminal		: yySymbolRange;
   BEGIN
      Sets.AssignEmpty (ContinueSet);
      FOR Terminal := yyFirstTerminal TO yyLastTerminal DO
	 IF IsContinuation (Terminal, Stack, StackSize, StackPtr) THEN
	    Sets.Include (ContinueSet, Terminal);
	 END;
      END;
   END ComputeContinuation;

(*
   check whether a given terminal symbol can be accepted (read)
   in a certain stack configuration (eventually after reduce actions)
*)

PROCEDURE IsContinuation (
      Terminal		: yySymbolRange	;
      ParseStack	: yyStackType	;
      StackSize		: LONGINT	;
      StackPtr		: LONGINT	): BOOLEAN;
   VAR
      State		: LONGINT;
      Nonterminal	: yySymbolRange;
      Stack		: yyStackType;
   BEGIN
      DynArray.MakeArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
      FOR State := 0 TO StackPtr DO
	 Stack^ [State] := ParseStack^ [State];
      END;
      State := Stack^ [StackPtr];
      LOOP
	 Stack^ [StackPtr] := State;
	 State := Next (State, Terminal);
	 IF State = yyNoState THEN
	    DynArray.ReleaseArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
	    RETURN FALSE;
	 END;
	 IF State <= yyLastReadTermState THEN		(* read or read terminal reduce ? *)
	    DynArray.ReleaseArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
	    RETURN TRUE;
	 END;

	 LOOP						(* reduce *)
	    IF State =	yyStopState THEN
	       DynArray.ReleaseArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
	       RETURN TRUE;
	    ELSE 
	       DEC (StackPtr, yyLength [State]);
	       Nonterminal := yyLeftHandSide [State];
	    END;

	    State := Next (Stack^ [StackPtr], Nonterminal);
	    IF StackPtr >= StackSize THEN
	       DynArray.ExtendArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
	    END;
	    INC (StackPtr);
	    IF State < yyFirstFinalState THEN EXIT; END; (* read nonterminal ? *)
	    State := yyFinalToProd [State];		(* read nonterminal reduce *)
	 END;
      END;
   END IsContinuation;

(*
   compute a set of terminal symbols that can be used to restart
   parsing in a given stack configuration. we simulate parsing until
   end of file using a suffix program synthesized by the function
   Continuation. All symbols acceptable in the states reached during
   the simulation can be used to restart parsing.
*)

PROCEDURE ComputeRestartPoints (
	  ParseStack	: yyStackType	;
	  StackSize	: LONGINT	;
	  StackPtr	: LONGINT	;
      VAR RestartSet	: Sets.tSet	);
   VAR
      Stack		: yyStackType;
      State		: LONGINT;
      Nonterminal	: yySymbolRange;
      ContinueSet	: Sets.tSet;
   BEGIN
      DynArray.MakeArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
      FOR State := 0 TO StackPtr DO
	 Stack^ [State] := ParseStack^ [State];
      END;
      Sets.MakeSet (ContinueSet, yyLastTerminal);
      Sets.AssignEmpty (RestartSet);
      State := Stack^ [StackPtr];

      LOOP
	 IF StackPtr >= StackSize THEN
	    DynArray.ExtendArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
	 END;
	 Stack^ [StackPtr] := State;
	 ComputeContinuation (Stack, StackSize, StackPtr, ContinueSet);
	 Sets.Union (RestartSet, ContinueSet);
	 State := Next (State, yyContinuation [State]);

	 IF State >= yyFirstFinalState THEN		(* final state ? *)
	    IF State <= yyLastReadTermState THEN	(* read terminal reduce ? *)
	       INC (StackPtr);
	       State := yyFinalToProd [State];
	    END;

	    LOOP					(* reduce *)
	       IF State = yyStopState THEN
		  DynArray.ReleaseArray (Stack, StackSize, SYSTEM.TSIZE (yyStateRange));
		  Sets.ReleaseSet (ContinueSet);
		  RETURN;
	       ELSE 
		  DEC (StackPtr, yyLength [State]);
		  Nonterminal := yyLeftHandSide [State];
	       END;

	       State := Next (Stack^ [StackPtr], Nonterminal);
	       INC (StackPtr);
	       IF State < yyFirstFinalState THEN EXIT; END; (* read nonterminal ? *)
	       State := yyFinalToProd [State];		(* read nonterminal reduce *)
	    END;
	 ELSE						(* read *)
	    INC (StackPtr);
	 END;
      END;
   END ComputeRestartPoints;

(* access the parse table:   Next : State x Symbol -> State *)

PROCEDURE Next (State: yyStateRange; Symbol: yySymbolRange): yyStateRange;
   VAR
      TCombPtr		: yyTCombTypePtr;
      NCombPtr		: yyNCombTypePtr;
   BEGIN
      IF Symbol <= yyLastTerminal THEN
	 LOOP
	    TCombPtr := yyTCombTypePtr (LONGCARD (yyTBasePtr [State]) 
			   + Symbol * SYSTEM.TSIZE (yyTCombType));
	    IF TCombPtr^.Check # State THEN
	       State := yyDefault [State];
	       IF State = yyNoState THEN RETURN yyNoState; END;
	    ELSE
	       RETURN TCombPtr^.Next;
	    END;
	 END;
      ELSE
	NCombPtr := yyNCombTypePtr (LONGCARD (yyNBasePtr [State]) 
			+ Symbol * SYSTEM.TSIZE (yyNCombType));
	RETURN NCombPtr^;
      END;
   END Next;

PROCEDURE yyGetTables;
   VAR
      BlockSize, j, n	: CARDINAL;
      State	: yyStateRange;
      TBase	: ARRAY [0 .. yyLastReadState] OF yyTCombRange;
      NBase	: ARRAY [0 .. yyLastReadState] OF yyNCombRange;
   BEGIN
      BlockSize	:= 64000 DIV SYSTEM.TSIZE (yyTCombType);
      yyTableFile := System.OpenInput (ParsTabName);
      yyErrorCheck (Errors.OpenParseTable, yyTableFile);
      IF 
	 (yyGetTable (SYSTEM.ADR (TBase	        )) DIV SYSTEM.TSIZE (yyTCombRange ) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.ADR (NBase	        )) DIV SYSTEM.TSIZE (yyNCombRange ) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.ADR (yyDefault     )) DIV SYSTEM.TSIZE (yyReadRange  ) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.ADR (yyNComb       )) DIV SYSTEM.TSIZE (yyNCombType  )
	    # yyNTableMax - yyLastTerminal) OR
	 (yyGetTable (SYSTEM.ADR (yyLength      )) DIV SYSTEM.TSIZE (yyTableElmt  ) - 1
	    # yyLastReduceState - yyFirstReduceState) OR
	 (yyGetTable (SYSTEM.ADR (yyLeftHandSide)) DIV SYSTEM.TSIZE (yySymbolRange) - 1
	    # yyLastReduceState - yyFirstReduceState) OR
	 (yyGetTable (SYSTEM.ADR (yyContinuation)) DIV SYSTEM.TSIZE (yySymbolRange) - 1
	    # yyLastReadState) OR
	 (yyGetTable (SYSTEM.ADR (yyFinalToProd )) DIV SYSTEM.TSIZE (yyReduceRange) - 1
	    # yyLastReadNontermState - yyFirstReadTermState)
      THEN
	 Errors.ErrorMessage (Errors.WrongParseTable, Errors.Fatal, Positions.NoPosition);
      END;
      n := 0;
      j := 0;
      WHILE j <= yyTableMax DO
	 INC (n, yyGetTable (SYSTEM.ADR (yyTComb [j])) DIV SYSTEM.TSIZE (yyTCombType));
         INC (j, BlockSize);
      END;
      IF n # yyTableMax + 1 THEN 
	 Errors.ErrorMessage (Errors.WrongParseTable, Errors.Fatal, Positions.NoPosition);
      END;
      System.Close (yyTableFile);

      FOR State := 1 TO yyLastReadState DO
	 yyTBasePtr [State] := SYSTEM.ADR (yyTComb [TBase [State]]);
      END;
      FOR State := 1 TO yyLastReadState DO
	 yyNBasePtr [State] := SYSTEM.ADR (yyNComb [NBase [State]]);
      END;
   END yyGetTables;

PROCEDURE yyGetTable (Address: SYSTEM.ADDRESS): CARDINAL;
   VAR
      N		: INTEGER;
      Length	: yyTableElmt;
   BEGIN
      N := System.Read (yyTableFile, SYSTEM.ADR (Length), SYSTEM.TSIZE (yyTableElmt));
      yyErrorCheck (Errors.ReadParseTable, N);
      N := System.Read (yyTableFile, Address, Length);
      yyErrorCheck (Errors.ReadParseTable, N);
      RETURN Length;
   END yyGetTable;

PROCEDURE yyErrorCheck (ErrorCode: INTEGER; Info: INTEGER);
   VAR ErrNo: INTEGER;
   BEGIN
     IF Info < 0 THEN
	ErrNo := System.ErrNum ();
	Errors.ErrorMessageI (ErrorCode, Errors.Fatal, Positions.NoPosition,
	   Errors.Integer, SYSTEM.ADR (ErrNo));
     END;
   END yyErrorCheck;

$@ PROCEDURE Begin@;
   BEGIN
$B	(* BEGIN section is inserted here *)
      IF NOT yyIsInitialized THEN
	 yyIsInitialized := TRUE;
	 yyGetTables;
      END;
$@    END Begin@;

$@ PROCEDURE Close@;
   BEGIN
$C	(* CLOSE section is inserted here *)
$@    END Close@;

BEGIN
    yyIsInitialized := FALSE;
$@     ParsTabName := '@.Tab';
$@ END @.
