
(*#################################*)
 IMPLEMENTATION MODULE Assertions0;        (* v1.0-022193 *)
(*#################################*)
                                           (* FROM Assertions v1.0-062792 for Benchmark *)
(*$D-*) (* no copy of dynamic string *)
(*
   (c) Copyright 1993 Tom Breeden, All Rights Reserved

                           Aglet Software
                           PO Box 3314
                           Charlottesville, VA 22903
*)
(*
	Assertion and Debug support.
*)

FROM SYSTEM          IMPORT ADDRESS, ADR;
FROM InOut           IMPORT Write, WriteString, WriteLn,
                            WriteInt, Read, Done, EOL;
FROM Str0            IMPORT StrLen, String10;
FROM Str1            IMPORT ChrCat;

CONST BELL = 7C;

VAR   DEBUG     :BOOLEAN;

(* VERSION HISTORY
*)

VAR  CleanUpList   :ARRAY[0..24] OF RECORD inuse:BOOLEAN; p:PROC; END;

(*------------------*)
 PROCEDURE CloseDown;
(*------------------*)

VAR  i :INTEGER;

BEGIN

FOR i := HIGH(CleanUpList) TO 0 BY -1 DO
   IF CleanUpList[i].inuse THEN
      CleanUpList[i].inuse := FALSE;
      CleanUpList[i].p;
   END;
END;

END CloseDown;

(*------------------------------------------*)
 PROCEDURE ReadStringLn(VAR s:ARRAY OF CHAR);
(*------------------------------------------*)

VAR   ch :CHAR;

BEGIN

Read(ch);
WHILE Done AND (ch # EOL) DO
   ChrCat(ch, s);
   Read(ch);
END;

END ReadStringLn;

(*=============================================*)
 PROCEDURE Assert(b:BOOLEAN; msg:ARRAY OF CHAR);
(*=============================================*)

VAR stemp :String10;

BEGIN

IF NOT b THEN
   Write(BELL);
   WriteString(msg); WriteLn;
   WriteString("HALTing, press <CR> to continue"); WriteLn;
   ReadStringLn(stemp);
   CloseDown;
   HALT;
END;

END Assert;

(*============================================*)
 PROCEDURE Debug(msg:ARRAY OF CHAR; i:INTEGER);
(*============================================*)

BEGIN

IF NOT DEBUG THEN RETURN END;

WriteString('DEBUG> '); WriteString(msg); WriteInt(i, 10);

END Debug;

(*=================================================*)
 PROCEDURE DebugPause(msg:ARRAY OF CHAR; i:INTEGER);
(*=================================================*)

VAR stemp :String10;

BEGIN

IF NOT DEBUG THEN RETURN END;

WriteString('DEBUG> '); WriteString(msg); WriteInt(i, 10);
WriteString('  H)alt, O)ff, or <CR>');
ReadStringLn(stemp);
IF (StrLen(stemp) > 0) THEN
   IF (CAP(stemp[0]) = "H") THEN
      CloseDown;
      HALT;
   ELSIF CAP(stemp[0]) = "O" THEN
      DebugOff;
   END;
END;

END DebugPause;

(*===================*)
 PROCEDURE DebugOn();
(*===================*)

BEGIN

DEBUG := TRUE;

END DebugOn;

(*=================*)
 PROCEDURE DebugOff;
(*=================*)

BEGIN

DEBUG := FALSE;

END DebugOff;

(*======================================*)
 PROCEDURE DebugQuery(msg:ARRAY OF CHAR);
(*======================================*)

VAR stemp :String10;

BEGIN

WriteString(msg);
WriteString(" DEBUG on? ");
ReadStringLn(stemp);

IF (StrLen(stemp) > 0) THEN
   DEBUG := CAP(stemp[0]) = 'Y';
END;

END DebugQuery;

(*===================================*)
 PROCEDURE AddCleanUp(p:PROC):BOOLEAN;
(*===================================*)

VAR i :INTEGER;

BEGIN

FOR i := 0 TO HIGH(CleanUpList) DO
   IF NOT CleanUpList[i].inuse THEN
      CleanUpList[i].inuse := TRUE;
      CleanUpList[i].p := p;
      RETURN TRUE;
   END;
END;

RETURN FALSE;

END AddCleanUp;

VAR i :INTEGER;
(*---------------*)
 BEGIN (* module *)
(*---------------*)

DEBUG := TRUE;
FOR i := 0 TO HIGH(CleanUpList) DO
   CleanUpList[i].inuse := FALSE;
END;

END Assertions0.
