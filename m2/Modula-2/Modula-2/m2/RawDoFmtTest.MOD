(********************************************************************************

Name         : RawDoFmtTest.MOD
Version      : 1.0
Purpose      : Access To Exec's Private Procedure RawDoFmt
Author       : ms
Created      : 12.4.86 11:15 ms
Modified     : 
Comment      : Used to implement c-procedure  [s, f] printf
               not all standard types are supported! no floating point args!

********************************************************************************)

MODULE RawDoFmtTest;

FROM Terminal  IMPORT WriteString, Write, WriteLn;
FROM AMIGABase IMPORT Regs, LibCall, ExecBase;
FROM SYSTEM    IMPORT ADR, LONG, ADDRESS;

TYPE Arguments = ARRAY [0..15] OF CARDINAL;

VAR s, st: ARRAY [0..127] OF CHAR;
    args: Arguments;

PROCEDURE RawDoFmt(VAR s: ARRAY OF CHAR; format: ARRAY OF CHAR; args: ADDRESS);
VAR r: Regs; stuffChar: LONGCARD;
BEGIN
  format[HIGH(format)]:=0C;
  stuffChar:=LONG(16C0H,    (*  MOVE.B D0, (A3)+ *)
                  4E75H);   (*  RTS              *)
  r.d[0]:=32;
  r.a[3]:=ADR(s);
  r.a[0]:=ADR(format);
  r.a[1]:=args;
  r.a[2]:=ADR(stuffChar);
  LibCall(ExecBase(), -522, r);
END RawDoFmt;

BEGIN
  WriteString('Using RawDoFmt to get formatted output'); WriteLn;
  WriteString('======================================'); WriteLn; WriteLn;

  args[0]:=000FFH;
  args[1]:=0AAAAH;
  args[2]:=01234H;
  args[3]:=05678H;
  RawDoFmt(s, "Hex Long: %8lx  Hex Short: %5x  Hex Leading Nulls: %08x ",
           ADR(args));
  WriteString(s); WriteLn;

  args[0]:=SHORT(SHIFT(7777777D, -16));
  args[1]:=SHORT(      7777777D);
  args[2]:=1001;
  args[3]:=1002;
  RawDoFmt(s, "Dec Long: %8ld  Dec Short: %5d  Dec Leading Nulls: %08d  ",
           ADR(args));
  WriteString(s); WriteLn; WriteLn;

  st:="Dies ist ein Test";
  args[0]:=SHORT(SHIFT(ADR(st), -16));
  args[1]:=SHORT(ADR(st));

  RawDoFmt(s, "string left adj  >%-30s< ", ADR(args));
  WriteString(s); WriteLn;

  RawDoFmt(s, "string right adj >%30s< ", ADR(args));
  WriteString(s); WriteLn;

  RawDoFmt(s, "string as it is  >%s< ", ADR(args));
  WriteString(s); WriteLn; WriteLn;

END RawDoFmtTest.  
   
