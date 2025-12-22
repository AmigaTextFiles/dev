(* A short demo for DebugLib. Make sure you have a PC or something like
   that connected to the internal serial. Should be set to 9600baud*)

MODULE DebugTest;

IMPORT IO: InOut;
IMPORT DBL: DebugLib;
FROM SYSTEM IMPORT  ADR;


VAR
   l: LONGINT;
BEGIN
   DBL.SetSerial(9600);

   DBL.KPutChar(ORD("H"));
   DBL.KPutStr(ADR("-ello world!\n"));

   DBL.KPutStr(ADR("Enter one char:\n"));
   IO.Write(CHR(DBL.KGetChar())); IO.WriteLn;

   (* See a C-manual or locale.doc/FormatString for codes *)
   DBL.KPrintF(ADR("\n\nAdding %lu to %ld gives %lu for sure.\n"), [500, -200, 300]);

   IF DBL.KCmpStr(ADR("Red"), ADR("Red")) = 0 THEN
      DBL.KPutStr(ADR("Red is equal to Red\n"));
   ELSE
      DBL.KPutStr(ADR("Red is not equal to Red\n"));
   END;
   IF DBL.KCmpStr(ADR("Red"), ADR("Green")) = 0 THEN
      DBL.KPutStr(ADR("Red is equal to Green\n"));
   ELSE
      DBL.KPutStr(ADR("Red is not equal to Green\n"));
   END;

   DBL.KPutStr(ADR("\nEnter 5 ints:\n"));
   FOR l:= 1 TO 5 DO
      IO.WriteInt(DBL.KGetNum(), 15);
      IO.WriteLn;
      DBL.KPutChar(ORD("\n"));
   END;

END DebugTest.
