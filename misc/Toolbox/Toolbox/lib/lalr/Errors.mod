(* $Id: Errors.mi,v 2.1 1992/08/07 15:28:42 grosch rel $ *)

IMPLEMENTATION MODULE Errors;

FROM SYSTEM	IMPORT ADDRESS;
FROM IO		IMPORT tFile, StdError, WriteC, WriteNl, WriteS, WriteI,
		       WriteB, WriteR, CloseIO;
FROM Sets	IMPORT tSet, IsElement, Size;
FROM Idents	IMPORT tIdent, WriteIdent;
FROM Positions	IMPORT tPosition, WritePosition;

IMPORT System, Strings;

PROCEDURE ErrorMessage	(ErrorCode, ErrorClass: CARDINAL; Position: tPosition);
   BEGIN
      WriteHead	(Position, ErrorClass);
      WriteCode	(ErrorCode);
      WriteTail	(ErrorClass);
   END ErrorMessage;

PROCEDURE ErrorMessageI	(ErrorCode, ErrorClass: CARDINAL; Position: tPosition;
			 InfoClass: CARDINAL; Info: ADDRESS);
   BEGIN
      WriteHead	(Position, ErrorClass);
      WriteCode	(ErrorCode);
      WriteInfo	(InfoClass, Info);
      WriteTail	(ErrorClass);
   END ErrorMessageI;

PROCEDURE Message  (ErrorText: ARRAY OF CHAR; ErrorClass: CARDINAL; Position: tPosition);
   BEGIN
      WriteHead	(Position, ErrorClass);
      WriteS	(StdError, ErrorText);
      WriteTail	(ErrorClass);
   END Message;

PROCEDURE MessageI (ErrorText: ARRAY OF CHAR; ErrorClass: CARDINAL; Position: tPosition;
			 InfoClass: CARDINAL; Info: ADDRESS);
   BEGIN
      WriteHead	(Position, ErrorClass);
      WriteS	(StdError, ErrorText);
      WriteInfo	(InfoClass, Info);
      WriteTail	(ErrorClass);
   END MessageI;

PROCEDURE WriteHead (Position: tPosition; ErrorClass: CARDINAL);
   BEGIN
      WritePosition (StdError, Position);
      WriteS	(StdError, ": ");
      CASE ErrorClass OF
      |  Fatal		: WriteS (StdError, "Fatal       ");
      |  Restriction	: WriteS (StdError, "Restriction ");
      |  Error		: WriteS (StdError, "Error       ");
      |  Warning	: WriteS (StdError, "Warning     ");
      |  Repair		: WriteS (StdError, "Repair      ");
      |  Note		: WriteS (StdError, "Note        ");
      |  Information	: WriteS (StdError, "Information ");
      ELSE WriteS (StdError, "Error class: "); WriteI (StdError, ErrorClass, 0);
      END;
   END WriteHead;

PROCEDURE WriteTail (ErrorClass: CARDINAL);
   BEGIN
      WriteNl (StdError);
      IF ErrorClass = Fatal THEN Exit; END;
   END WriteTail;

PROCEDURE WriteCode (ErrorCode: CARDINAL);
   BEGIN
      CASE ErrorCode OF
      |  NoText		 :
      |  SyntaxError	 : WriteS (StdError, "syntax error"		);
      |  ExpectedTokens	 : WriteS (StdError, "expected tokens"		);
      |  RestartPoint	 : WriteS (StdError, "restart point"		);
      |  TokenInserted	 : WriteS (StdError, "token inserted "		);
      |  WrongParseTable : WriteS (StdError, "parse table mismatch"	);
      |  OpenParseTable	 : WriteS (StdError, "cannot open parse table"	);
      |  ReadParseTable	 : WriteS (StdError, "cannot read parse table"	);
      ELSE WriteS (StdError, " error code: "); WriteI (StdError, ErrorCode, 0);
      END;
   END WriteCode;

PROCEDURE WriteInfo	(InfoClass: CARDINAL; Info: ADDRESS);
   VAR
      PtrToInteger	: POINTER TO INTEGER;
      PtrToShort	: POINTER TO SHORTCARD;
      PtrToLong		: POINTER TO LONGINT;
      PtrToReal		: POINTER TO REAL;
      PtrToBoolean	: POINTER TO BOOLEAN;
      PtrToCharacter	: POINTER TO CHAR;
      PtrToString	: POINTER TO Strings.tString;
      PtrToArray	: POINTER TO ARRAY [0..1023] OF CHAR;
      PtrToIdent	: POINTER TO tIdent;
   BEGIN
      WriteS (StdError, ": ");
      CASE InfoClass OF
      | Integer	: PtrToInteger	:= Info; WriteI (StdError, PtrToInteger^, 0);
      | Short  	: PtrToShort	:= Info; WriteI (StdError, PtrToShort^, 0);
      | Long   	: PtrToLong	:= Info; WriteI (StdError, PtrToLong^, 0);
      | Real   	: PtrToReal	:= Info; WriteR (StdError, PtrToReal^, 1, 10, 1);
      | Boolean	: PtrToBoolean	:= Info; WriteB (StdError, PtrToBoolean^);
      | Character:PtrToCharacter:= Info; WriteC (StdError, PtrToCharacter^);
      | String	: PtrToString	:= Info; Strings.WriteS (StdError, PtrToString^);
      | Array	: PtrToArray	:= Info; WriteS (StdError, PtrToArray^);
      | Ident	: PtrToIdent	:= Info; WriteIdent (StdError, PtrToIdent^);
      ELSE
      END;
   END WriteInfo;

PROCEDURE yyExit;
   BEGIN
      CloseIO; System.Exit (1);
   END yyExit;

BEGIN
   Exit := yyExit;
END Errors.
