MODULE DivModTest;

IMPORT InOut;

VAR
 i:LONGINT;

BEGIN
 FOR i:=4 TO -4 BY -1 DO
  InOut.WriteInt(i DIV 3,5);
  InOut.WriteInt(i MOD 3,5);
  InOut.WriteInt(i DIV -3,5);
  InOut.WriteInt(i MOD -3,5);
  InOut.WriteLn;
 END;
END DivModTest.
