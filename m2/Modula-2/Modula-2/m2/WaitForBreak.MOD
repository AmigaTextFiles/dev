(********************************************************************************

Name         : WaitForBreak.MOD
Version      : 1.0
Purpose      : Demo for use of Breaks
Author       : ms
Modified     : 13.3.86  18:55  ms

********************************************************************************)

MODULE WaitForBreak;

FROM Terminal  IMPORT Write, WriteString, WriteLn, Read;
FROM AMIGADos  IMPORT Delay;
FROM Breaks    IMPORT BreakFlags, DetectBreak;

BEGIN
  LOOP
    Delay(25);
    Write('.');
    IF DetectBreak(breakC) THEN
      WriteString('ctrl-c detected'); WriteLn; EXIT
    ELSIF DetectBreak(breakD) THEN
      WriteString('ctrl-d detected'); WriteLn
    ELSIF DetectBreak(breakE) THEN
      WriteString('ctrl-e detected'); WriteLn
    ELSIF DetectBreak(breakF) THEN
      WriteString('ctrl-f detected'); WriteLn
    END
  END
END WaitForBreak.
