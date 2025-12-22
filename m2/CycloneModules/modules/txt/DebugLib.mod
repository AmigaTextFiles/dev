(*$ StackChk-
    OverflowChk-
    RangeChk-
    NilChk-
*)

IMPLEMENTATION MODULE DebugLib;

IMPORT GD: GraphicsD;
IMPORT GL: GraphicsL;
IMPORT HW: Hardware;
IMPORT Ascii;
IMPORT EL: ExecL;
IMPORT R:Reg;
FROM SYSTEM IMPORT ASSEMBLE, ADDRESS, TAG, ADR, CAST;


CONST
   (* entry points to private functions of exec *)
   LVORawPutChar= -516;
   LVORawMayGetChar= -510;
   LVORawIOInit= -504;  (* calling this sets internal serial-hw to 9600 *)



(*$ EntryExitCode- *)
PROCEDURE KPutChar(char{R.D0}: LONGCARD);
BEGIN
   ASSEMBLE(
	MOVE.L	A6,-(A7)
	MOVEA.L EL(A4),A6
	JSR	LVORawPutChar(A6)  (* This is a private *)
	MOVEA.L (A7)+,A6
	RTS
	END);
END KPutChar;


PROCEDURE KPutStr(s: StrPtr);
VAR
   x{R.D7}: INTEGER;
BEGIN
   x:= 0;
   WHILE s^[x] # 0C DO
      KPutChar(ORD(s^[x]));
      INC(x);
   END;
END KPutStr;


(*$ EntryExitCode- *)
PROCEDURE KPrintF(str{R.A0}: StrPtr; values{R.A1}: ADDRESS);
BEGIN
   ASSEMBLE(
	MOVEM.L  A2/A6,-(A7)
	LEA      KPutChar(PC),A2
	MOVEA.L  EL(A4),A6
	JSR      EL.RawDoFmt(A6)
	MOVEM.L  (A7)+,A2/A6
	RTS
	END);
END KPrintF;


(*$ EntryExitCode- *)
PROCEDURE KMayGetChar(): LONGINT;
BEGIN
   ASSEMBLE(
	MOVE.L  A6,-(A7)
	MOVEA.L EL(A4),A6
	JSR     LVORawMayGetChar(A6)  (* This is a private *)
	MOVEA.L (A7)+,A6
	RTS
	END);
END KMayGetChar;


PROCEDURE KGetChar(): LONGINT;
VAR
   c{R.D7}: LONGINT;
BEGIN
   c:= KMayGetChar();
   WHILE c < 0 DO
      c:= KMayGetChar();
   END;
   RETURN c;
END KGetChar;


(* Only for complete interface. Do not use *)
PROCEDURE KCmpStr(s1{R.A0}, s2{R.A1}: StrPtr): LONGINT;
VAR
   x{R.D7}: INTEGER;
BEGIN
   x:= 0;
   WHILE (s1^[x] # 0C) & (s1^[x] = s2^[x]) DO
      INC(x);
   END;

   RETURN ORD(s1^[x] # s2^[x]);
END KCmpStr;


(* Code is taken from InOut.ReadLongInt. No backspace handling. *)
PROCEDURE KGetNum(): LONGINT;
VAR
  ch{R.D6}: CHAR;
  d{R.D5}: INTEGER;
  neg: BOOLEAN;
  x{R.D7}: LONGINT;
BEGIN
  x := 0;
  neg := FALSE;
  ch:= CHAR(KGetChar());
  WHILE ch#Ascii.cr DO
     IF ch="-" THEN neg := TRUE;
     ELSIF (ch>="0") AND (ch<="9") THEN
       d := ORD(ch)-ORD("0");
       IF (MAX(LONGINT)-d) DIV 10 >= x THEN x := 10*x+d END;
     END;
     ch:= CHAR(KGetChar());
  END;
  IF neg THEN x := -x END;
  RETURN x;
END KGetNum;


(* Code from "Guru Book" p. 193 *)
PROCEDURE SetSerial(Baud: LONGCARD);
CONST
   SerclkNtsc= 3579545;
   SerclkPal= 3546895;
BEGIN
   IF GD.pal IN GL.graphicsBase^.displayFlags THEN
      HW.custom.serper:= SerclkPal DIV Baud -1;
   ELSE
      HW.custom.serper:= SerclkNtsc DIV Baud -1;
   END;
END SetSerial;


END DebugLib.
