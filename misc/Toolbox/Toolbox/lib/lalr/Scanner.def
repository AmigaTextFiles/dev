(* $Id: Scanner.md,v 2.2 1992/08/07 15:28:42 grosch rel $ *)

$@ DEFINITION MODULE $;

FROM Positions	IMPORT tPosition;

TYPE tScanAttribute	= RECORD Position: tPosition; END;

VAR  Attribute		: tScanAttribute;

PROCEDURE GetToken ()	: CARDINAL;
PROCEDURE ErrorAttribute (Token: CARDINAL; VAR Attribute: tScanAttribute);

$@ END $.
