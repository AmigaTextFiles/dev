MODULE signals;
(* 2.0 / 1.5.87 / ms *)
(* Copyright 1987 by Markus Schaub/AMSoft
 * Permission granted to do anything with this program as long as nobody
 * gets hurt directly. Don't throw it out of the window! :-)
 *)
FROM SYSTEM IMPORT
 LONGSET;
FROM Exec IMPORT
 Wait;
FROM Terminal IMPORT
 WriteString,WriteLn;
VAR
 sig: LONGSET;
BEGIN
 LOOP
  sig:=Wait(LONGSET{12..15});
  (* Ctrl-C is detected by Arts the run-time system (interrupt driven)
   * Use it to stop the program!
   *)
  IF    13 IN sig THEN
   WriteString("Ctrl-D detected")
  ELSIF 14 IN sig THEN
   WriteString("Ctrl-E detected")
  ELSIF 15 IN sig THEN
   WriteString("Ctrl-F detected")
  END;
  WriteLn
 END
END signals.
