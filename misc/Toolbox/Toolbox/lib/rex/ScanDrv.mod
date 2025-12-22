(* $Id: ScanDrv.mi,v 2.2 1992/08/07 15:29:41 grosch rel $ *)

$@ MODULE @Drv;

$@ FROM @	IMPORT BeginScanner, GetToken, GetWord, Attribute, EofToken, CloseScanner;
FROM Strings	IMPORT tString, WriteL;
FROM IO		IMPORT StdOutput, WriteI, WriteC, WriteNl, CloseIO;
FROM Positions	IMPORT WritePosition;
FROM System	IMPORT Exit;

VAR Token	: INTEGER;
    Word	: tString;
    Debug	: BOOLEAN;
    Count	: INTEGER;

BEGIN
   Debug := FALSE;
   Count := 0;
   BeginScanner;
   REPEAT
      Token := GetToken ();
      INC (Count);
      IF Debug THEN
         GetWord (Word);
	 WritePosition (StdOutput, Attribute.Position);
	 WriteI (StdOutput, Token, 5);
	 WriteC (StdOutput, ' ');
	 WriteL (StdOutput, Word);
      END;
   UNTIL Token = EofToken;
   CloseScanner;
   WriteI (StdOutput, Count, 0);
   WriteNl (StdOutput);
   CloseIO;
   Exit (0);
$@ END @Drv.
