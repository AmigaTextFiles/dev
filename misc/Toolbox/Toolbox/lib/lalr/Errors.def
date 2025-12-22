(* $Id: Errors.md,v 2.1 1992/08/07 15:28:42 grosch rel $ *)

DEFINITION MODULE Errors;

FROM SYSTEM	IMPORT ADDRESS;
FROM Positions	IMPORT tPosition;

CONST
   NoText		= 0	;
   SyntaxError		= 1	;	(* error codes		*)
   ExpectedTokens	= 2	;
   RestartPoint		= 3	;
   TokenInserted	= 4	;
   WrongParseTable	= 5	;
   OpenParseTable	= 6	;
   ReadParseTable	= 7	;

   Fatal		= 1	;	(* error classes	*)
   Restriction		= 2	;
   Error		= 3	;
   Warning		= 4	;
   Repair		= 5	;
   Note			= 6	;
   Information		= 7	;

   None			= 0	;
   Integer		= 1	;	(* info classes		*)
   Short		= 2	;
   Long			= 3	;
   Real			= 4	;
   Boolean		= 5	;
   Character		= 6	;
   String		= 7	;
   Array		= 8	;
   Set			= 9	;
   Ident		= 10	;

VAR Exit	: PROC;

PROCEDURE ErrorMessage	(ErrorCode, ErrorClass: CARDINAL; Position: tPosition);
PROCEDURE ErrorMessageI	(ErrorCode, ErrorClass: CARDINAL; Position: tPosition;
			 InfoClass: CARDINAL; Info: ADDRESS);
PROCEDURE Message  (ErrorText: ARRAY OF CHAR; ErrorClass: CARDINAL; Position: tPosition);
PROCEDURE MessageI (ErrorText: ARRAY OF CHAR; ErrorClass: CARDINAL; Position: tPosition;
			 InfoClass: CARDINAL; Info: ADDRESS);

END Errors.
