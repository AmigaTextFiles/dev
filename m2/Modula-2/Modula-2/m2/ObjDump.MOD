(********************************************************************************

Name         : ObjDump.MOD
Version      : 1.0
Purpose      : decode Amiga object files
Author       : cn/ms
Modified     : 9.4.86 14:30 ms
Comment      : ported from cn's basic program and extended with dec68k
 
********************************************************************************)

MODULE ObjDump;

FROM SYSTEM     IMPORT ADR, LONG, WORD;
FROM InOut      IMPORT OpenOutput, CloseOutput, 
                       ReadString, WriteHex, WriteString, Write, WriteLn;
FROM FileSystem IMPORT File, Response,
                       Lookup, Close, ReadWord, ReadChar, Length;
FROM dec68k     IMPORT Decode;
                IMPORT TerminalBase;

CONST cr=15C; esc=33C; can=30C; csi=233C;

VAR obj: File;
    ch: CHAR;
    lo, hi, pc, decLen: CARDINAL;
    filename, st: ARRAY [0..63] OF CHAR;
    lc, hunk:  LONGCARD;

PROCEDURE GetChar(VAR ch: CHAR);
BEGIN
  IF pc<decLen THEN
    ReadChar(obj, ch);
    INC(pc);
  ELSE
    ch:=0C
  END
END GetChar;

PROCEDURE GetWord(VAR w: WORD);
VAR ch1, ch2: CHAR;
BEGIN
  GetChar(ch1);
  GetChar(ch2);
  w:=WORD(256*ORD(ch1)+ORD(ch2));
END GetWord;

PROCEDURE GetLong(VAR lc: LONGCARD);
VAR hi, lo: CARDINAL;
BEGIN
  ReadWord(obj, hi);
  ReadWord(obj, lo);
  IF (obj.res#done) OR obj.eof THEN
    lc:=0D
  ELSE
    lc:=LONG(hi, lo)
  END
END GetLong;

PROCEDURE PrintName(len: CARDINAL);
VAR trick:RECORD CASE :INTEGER OF
                 | 1: lc: LONGCARD
                 | 2: st: ARRAY [0..3] OF CHAR
                 END
          END;
     i: CARDINAL;
BEGIN
  WITH trick DO
    IF len#0 THEN
      FOR i:=1 TO len DO
        GetLong(lc);
        WriteString(st)
      END
    ELSE
      WriteString('no name')
    END
  END
END PrintName;

PROCEDURE DecodeBlock;
VAR i: CARDINAL; lc: LONGCARD;
BEGIN
  GetLong(lc);
  WriteHex(lc, 8);
  pc:=0; decLen:=SHORT(SHIFT(lc, 2)); (* #bytes *)
  WriteLn;
  WHILE pc<decLen DO
    WriteHex(pc, 4); Decode(GetWord)
  END
END DecodeBlock;

PROCEDURE DataBlock;
VAR i: CARDINAL; lc: LONGCARD;
BEGIN
  GetLong(lc);
  WriteHex(lc, 8);
  FOR i:=1 TO SHORT(lc) DO
    GetLong(lc)
  END
END DataBlock;

PROCEDURE Relocation;
VAR lc: LONGCARD;
    i, len: CARDINAL;
BEGIN
  LOOP
    GetLong(lc);
    IF lc=0D THEN EXIT END;
    len:=SHORT(lc);
    GetLong(lc);
    WriteLn; WriteString('hunk: '); WriteHex(lc, 8);
    FOR i:=0 TO len-1 DO
      WriteLn; WriteHex(i, 3); Write(':'); GetLong(lc); WriteHex(lc, 8);
    END
  END
END Relocation;

PROCEDURE External;
VAR type, len, i: CARDINAL;
    lc: LONGCARD;
BEGIN
  LOOP
    GetLong(lc);
    IF lc=0D THEN EXIT END;
    type:=SHORT(SHIFT(lc, -24));
    len:=SHORT(lc);
    WriteLn;
    IF type=0 THEN
      WriteString('ext_symb: ');
      GetLong(lc); PrintName(SHORT(lc)); WriteString('   ');
      GetLong(lc); WriteHex(lc, 8);
    ELSIF type=1 THEN
      WriteString('ext_def: '); PrintName(len); WriteString('   ');
      GetLong(lc); WriteHex(lc, 8)
    ELSIF type=2 THEN
      WriteString('ext_abs: '); PrintName(len); WriteString('   ');
      GetLong(lc); WriteHex(lc, 8)
    ELSIF type=3 THEN
      WriteString('ext_res: '); PrintName(len); WriteString('   ');
      GetLong(lc); WriteHex(lc, 8)
    ELSIF type=129  THEN
      WriteString('ext_ref32: '); PrintName(len);
      GetLong(lc); len:=SHORT(lc);
      FOR i:=0 TO len-1 DO
        WriteLn; WriteHex(i, 3); Write(':'); GetLong(lc); WriteHex(lc, 8)
      END;
    ELSIF type=130  THEN
      WriteString('ext_common: '); PrintName(len);
      GetLong(lc); WriteLn; WriteString('common block size: '); WriteHex(lc, 8);
      GetLong(lc); len:=SHORT(lc);
      FOR i:=0 TO len-1 DO
        WriteLn; WriteHex(i, 3); Write(':'); GetLong(lc); WriteHex(lc, 8)
      END;
    ELSIF type=131  THEN
      WriteString('ext_ref16: '); PrintName(len);
      GetLong(lc); len:=SHORT(lc);
      FOR i:=0 TO len-1 DO
        WriteLn; WriteHex(i, 3); Write(':'); GetLong(lc); WriteHex(lc, 8)
      END;
    ELSIF type=132 THEN
      WriteString('ext_ref8: '); PrintName(len);
      GetLong(lc); len:=SHORT(lc);
      FOR i:=0 TO len-1 DO
        WriteLn; WriteHex(i, 3); Write(':'); GetLong(lc); WriteHex(lc, 8)
      END;
    ELSE
      WriteString('unknown external reference type')
    END
  END
END External;

PROCEDURE Symbols;
VAR lc: LONGCARD;
BEGIN
  LOOP
    GetLong(lc);
    IF lc=0D THEN EXIT END;
    WriteLn;
    PrintName(SHORT(lc)); WriteString('   '); GetLong(lc); WriteHex(lc, 8)
  END
END Symbols;

PROCEDURE Debug;
BEGIN
  DataBlock;
END Debug;

PROCEDURE Header;
VAR lc, f, l: LONGCARD;
    len, i: CARDINAL;
BEGIN
  LOOP
    GetLong(lc);
    IF lc=0D THEN EXIT END;
    WriteLn; PrintName(SHORT(lc))
  END;
  WriteLn;
  GetLong(lc); WriteString('table size: '); WriteHex(lc, 8); WriteLn;
  GetLong(f); WriteString('first hunk: '); WriteHex(f, 8); WriteLn;
  GetLong(l); WriteString('last  hunk: '); WriteHex(l, 8); WriteLn;
  WriteString('hunk sizes:');
  FOR i:=0 TO SHORT(l-f) DO
    GetLong(lc); WriteLn; WriteHex(i, 3); Write(':'); WriteHex(lc, 8)
  END
END Header;

PROCEDURE Overlay;
BEGIN
  DataBlock
END Overlay;
   
PROCEDURE WriteHunk(hunk: LONGCARD);
BEGIN
  IF hunk=999D THEN
    WriteString('hunk_unit: '); GetLong(lc); PrintName(SHORT(lc)); WriteLn
  ELSIF hunk=1000D THEN
    WriteString('hunk_name: '); GetLong(lc); PrintName(SHORT(lc)); WriteLn
  ELSIF hunk=1001D THEN
    WriteString('hunk_code: '); DecodeBlock; (* WriteLn *)
  ELSIF hunk=1002D THEN
    WriteString('hunk_data: '); DataBlock; WriteLn
  ELSIF hunk=1003D THEN
    WriteString('hunk_bss: '); GetLong(lc); WriteHex(lc, 8); WriteLn
  ELSIF hunk=1004D THEN
    WriteString('hunk_reloc32: '); Relocation; WriteLn
  ELSIF hunk=1005D THEN
    WriteString('hunk_reloc16: '); Relocation; WriteLn
  ELSIF hunk=1006D THEN
    WriteString('hunk_reloc8: '); Relocation; WriteLn
  ELSIF hunk=1007D THEN
    WriteString('hunk_ext: '); External; WriteLn
  ELSIF hunk=1008D THEN
    WriteString('hunk_symbol: '); Symbols; WriteLn
  ELSIF hunk=1009D THEN
    WriteString('hunk_debug: '); Debug; WriteLn
  ELSIF hunk=1010D THEN
    WriteString('hunk_end'); WriteLn; WriteLn
  ELSIF hunk=1011D THEN
    WriteString('hunk_header: '); Header; WriteLn
  ELSIF hunk=1012D THEN
    WriteString('hunk_overlay: '); Overlay; WriteLn
  ELSIF hunk=1013D THEN
    WriteString('hunk_break'); WriteLn
  ELSE
    WriteString('no hunk: '); WriteHex(hunk, 8); WriteLn
  END;
END WriteHunk;

BEGIN
  WriteString('ObmDump              Version 1.0  9.4.86/ms'); WriteLn;
  WriteString('======='); WriteLn; WriteLn;
  LOOP
    WriteString('in> '); ReadString(filename);
    IF filename[0]#0C THEN
      Lookup(obj, filename, FALSE);
      IF obj.res=done THEN  WriteLn;
        OpenOutput('DEC');
        WriteString('ObmDump: '); WriteString(filename); WriteLn; WriteLn;
        Length(obj, hi, lo);
        IF obj.res#done THEN
          WriteString('f.res#done  !!!'); WriteLn
        END;
        WriteString('File is '); WriteHex(LONG(hi, lo), 8);
        WriteString(' bytes long'); WriteLn;
        LOOP
          GetLong(hunk);
          TerminalBase.StandardBusyRead(ch);
          IF ch#0C THEN
            st:='xxx?: esc to exit, other key to continue';
            st[0]:=csi; st[1]:='7'; st[2]:='m';
            TerminalBase.StandardWrite(ADR(st), 40D);
            REPEAT
              TerminalBase.BusyRead(ch);
            UNTIL ch#0C;
            st[0]:=csi; st[1]:='0'; st[2]:='m';
            st[3]:=cr; st[4]:=csi; st[5]:='K';
            TerminalBase.StandardWrite(ADR(st), 6);
            IF ch=esc THEN
              EXIT
            END
          END;
          IF obj.eof OR (obj.res#done) THEN
            EXIT
          ELSE 
            WriteHunk(hunk)
          END
        END;
        CloseOutput;
        Close(obj)
      ELSE
        WriteString(' --- not opend'); WriteLn
      END
    ELSE
      WriteString(' --- no file'); WriteLn;
      EXIT
    END
  END
END ObjDump.
