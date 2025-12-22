(* $Id: Scanner.mi,v 2.2 1992/08/07 15:28:42 grosch rel $ *)

$@ IMPLEMENTATION MODULE $;

FROM IO IMPORT StdInput, ReadC;

PROCEDURE GetToken (): CARDINAL;
   VAR ch: CHAR;
   BEGIN
      LOOP
	 ch := ReadC (StdInput);
	 IF ch = 12C THEN INC (Attribute.Position.Line); Attribute.Position.Column := 0;
	 ELSIF ch = ' ' THEN INC (Attribute.Position.Column);
	 ELSE INC (Attribute.Position.Column); EXIT;
	 END;
      END;
      RETURN ORD (ch);
   END GetToken;

PROCEDURE ErrorAttribute (Token: CARDINAL; VAR Attribute: tScanAttribute);
   BEGIN
   END ErrorAttribute;

BEGIN
   Attribute.Position.Line	:= 1;
   Attribute.Position.Column	:= 0;
$@ END $.
