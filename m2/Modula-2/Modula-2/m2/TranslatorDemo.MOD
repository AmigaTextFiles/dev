(********************************************************************************

Name         : TranslatorDemo.MOD
Version      : 1.0
Purpose      : Demo using Translator Library
Author       : ms
Modified     : 3.4.86  19:10 ms

********************************************************************************)

MODULE TranslatorDemo;

FROM Terminal   IMPORT BusyRead, Read, Write, WriteString, WriteLn;
FROM Translator IMPORT Translate;

CONST bs  = 10C;
      lf  = 12C;
      ff  = 14C;
      cr  = 15C;
      esc = 33C;
      del =177C;
      csi =233C;

VAR in, out: ARRAY [0..127] OF CHAR;
    err: LONGINT;

PROCEDURE ReadString(VAR st: ARRAY OF CHAR);
VAR pos: CARDINAL; ch: CHAR;
BEGIN
  pos:=0;
  LOOP
    Read(ch);
    IF (ch=cr) OR (ch=lf) THEN
      IF pos<=HIGH(st) THEN st[pos]:=0C END; EXIT
    ELSIF  ch=esc THEN
      st[0]:=0C; EXIT
    ELSIF ((ch=bs) OR (ch=del)) & (pos>0) THEN
      Write(bs); Write(' '); Write(bs); DEC(pos);
    ELSIF (ch>=' ') & (ch<del) & (pos<HIGH(st)) THEN
      st[pos]:=ch; Write(ch); INC(pos)
    ELSIF ch=csi THEN (* Command Sequence Introducer *)
      REPEAT BusyRead(ch) UNTIL ch=0C (* Skip Command Sequence *)
    END
  END
END ReadString;

BEGIN
  WriteString('Translator Demo'); WriteLn;
  WriteString('==============='); WriteLn; WriteLn;
  LOOP
    WriteString('text> '); ReadString(in); WriteLn;
    IF in[0]#0C THEN
      Translate(in, out, err);
      IF err=0D THEN
        WriteString('phon> '); WriteString(out); WriteLn
      ELSE
        WriteString('Translator Returns Error'); WriteLn
      END
    ELSE
      EXIT
    END;
    WriteLn
  END (* LOOP *)
END TranslatorDemo.
