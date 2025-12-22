IMPLEMENTATION MODULE RealInOut;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM InOut IMPORT ReadString,WriteString;
FROM RealConvert IMPORT StringToReal,RealToString;

CONST 
  MaxString=50;
  Err='Error conversion Str<->Real';

TYPE
  StrArray=ARRAY[0..MaxString-1] OF CHAR;

VAR 
  Error:BOOLEAN;

PROCEDURE WriteRealExp(r:REAL; width,dec:INTEGER);
VAR s:StrArray;
BEGIN
  RealToString(r,s,width,dec,TRUE,Error);
  IF Error THEN WriteString(Err); ELSE WriteString(s); END;
END WriteRealExp;

PROCEDURE WriteReal(r:REAL; width,dec:INTEGER);
VAR s:StrArray;
BEGIN
  RealToString(r,s,width,dec,FALSE,Error);
  IF Error THEN WriteString(Err); ELSE WriteString(s); END;
END WriteReal;

PROCEDURE ReadReal(VAR r:REAL);
VAR s:StrArray;
BEGIN
  ReadString(s); StringToReal(s,r,Error);
END ReadReal;

END RealInOut.
