IMPLEMENTATION MODULE InOut;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT WORD,ADR,ASSEMBLE,SETREG,ADDRESS     ;
FROM Convert IMPORT IntToStr,CardToStr; 
FROM String IMPORT Length;
FROM Ascii IMPORT nul, lf, eof;
FROM ModulaLib IMPORT Assert, wbStarted, kickVersion, wbenchMsg;
IMPORT DosD,DosL,wb:Workbench;


CONST
  InOutErr='Cannot open InOut window!';
  StrLen=99;
  RetMsg="\n<< RETURN >>";

TYPE 
  String=ARRAY [0..StrLen] OF CHAR;

VAR 
  inF, outF: DosD.FileHandlePtr;
  wbm:wb.WBStartupPtr;
  c:CHAR;

PROCEDURE Read( VAR ch :CHAR );
(*
    read a character
*)
BEGIN
 IF DosL.Read(inF,ADR(ch),1)#1 THEN ch := eof END;
END Read;


PROCEDURE ReadString( VAR s :ARRAY OF CHAR );
VAR i:LONGINT;
BEGIN
  i := 0;
  REPEAT
    Read(s[i]);
    IF s[i]=lf THEN s[i] := 0C; RETURN END;
    INC(i);
  UNTIL i=HIGH(s);
END ReadString;


PROCEDURE ReadLongInt( VAR x :LONGINT );
VAR
  ch: CHAR;
  d: INTEGER;
  neg: BOOLEAN;
BEGIN
  x := 0; 
  neg := FALSE;
  Read(ch);
  WHILE (ch#lf) AND (ch#eof) AND (ch#0C) DO
    IF ch="-" THEN neg := TRUE;
    ELSIF (ch>="0") AND (ch<="9") THEN
      d := ORD(ch)-ORD("0");
      IF (MAX(LONGINT)-d) DIV 10 >= x THEN x := 10*x+d END;
    END;
    Read(ch);
  END;
  IF neg THEN x := -x END;
END ReadLongInt;


PROCEDURE ReadInt( VAR x :INTEGER );
VAR l:LONGINT;
BEGIN
  ReadLongInt(l);
  x := l MOD MAX(INTEGER);
END ReadInt;

PROCEDURE ReadLongCard( VAR x :LONGCARD);
(* Doesn't see minus sign!
   LONGCARD Cannot be signed!!
 *)
VAR
  ch: CHAR;
  d: CARDINAL;
BEGIN
  x := 0;
  Read(ch);
  WHILE (ch#lf) AND (ch#eof) AND (ch#0C) DO
    IF (ch>="0") AND (ch<="9") THEN
      d := ORD(ch)-ORD("0");
      IF (MAX(LONGCARD)-d) DIV 10 >= x THEN x := 10*x+d END;
    END;
    Read(ch);
  END;
END ReadLongCard;


PROCEDURE ReadCard(VAR x :CARDINAL);
VAR 
 l:LONGCARD;
BEGIN
  ReadLongCard(l);
  x := l MOD MAX(CARDINAL);
END ReadCard;


PROCEDURE Write( ch :CHAR );
(*
    write the character
*)
BEGIN
 Done:=DosL.Write(outF,ADR(ch),1)=1;
END Write;


PROCEDURE WriteLn;
(*
    same as: Write( ASCII.EOL )
*)
BEGIN
 Write(lf);
END WriteLn;


PROCEDURE WriteString( s :ARRAY OF CHAR );
(*$ CopyDyn- *)
(*
    write the string out
*)
VAR i:INTEGER;
BEGIN
 i:=Length(s);
 Done:=DosL.Write(outF,ADR(s),i)=i;
END WriteString;


PROCEDURE WriteLine( s :ARRAY OF CHAR );
(*$ CopyDyn- *)
BEGIN
 WriteString(s); WriteLn;
END WriteLine;


PROCEDURE WriteInt( x : LONGINT; n :CARDINAL );
(*
    write the LONGINT right justified in a field of at least n characters.
*)
VAR s:String;
BEGIN
 IntToStr(x,s,n,Done);
 WriteString(s);
END WriteInt;


PROCEDURE WriteCard( x : LONGCARD; n : CARDINAL);
(*
    write the CARDINAL right justified in a field of at least n characters.
*)
VAR s:String;
BEGIN
 CardToStr(x,s,n,Done);
 WriteString(s);
END WriteCard;


PROCEDURE WriteOct( x, n :CARDINAL );
(*
    write x in octal format in a right justified field of at least n characters.
*)
BEGIN
  IF x<0 THEN Write("-"); x := -x; DEC(n) END;
  IF n>1 THEN WriteOct(x DIV 8,n-1); x := x MOD 8; END;
  Write(CHAR(x+ORD("0")));
END WriteOct;


PROCEDURE WriteHex( x : LONGINT; n :CARDINAL );
(*
    write x in hexadecimal in a right justified field of at least n characters.
    IF (n <= 2) AND (x < 100H) THEN 2 digits are written
    ELSE 4 digits are written
*)
BEGIN
  IF x<0 THEN Write("-"); x := -x; DEC(n) END;
  IF n>1 THEN WriteHex(x DIV 16,n-1); x := x MOD 16; END;
  IF x>9 THEN Write(CHAR(x+55)) ELSE Write(CHAR(x+ORD("0"))) END;
END WriteHex;

PROCEDURE WriteFormat(template : ARRAY OF CHAR;
                      data : ADDRESS);

  BEGIN
    IGNORE DosL.VFPrintf(outF,ADR(template),data);
    IGNORE DosL.Flush(outF);
  END WriteFormat;


PROCEDURE ConfigWB;
CONST
  ConName='CON:010/030/620/100/';
  ExtStr37='/AUTO/CLOSE';
VAR 
  str:String;
BEGIN
  wbm:=wbenchMsg;
  ASSEMBLE(
    LEA str(A5),A1
    LEA ConName(PC),A0
lp:
    MOVE.B  (A0)+,(A1)+
    TST.B   (A0)
    BNE     lp
  	MOVEA.L wbm(A4),A2
	  MOVEA.L 36(A2),A3
	  MOVEA.L 4(A3),A0
lp1:
    MOVE.B  (A0)+,(A1)+
    TST.B   (A0)
    BNE     lp1
    CMPI.W  #37,kickVersion(A4)
    BLT.S   cont
    LEA     ExtStr37(PC),A0
lp2:
    MOVE.B  (A0)+,(A1)+
    TST.B   (A0)
    BNE     lp2
cont:
    CLR.B   (A1)
  END);    
  inF:=DosL.Open(ADR(str),DosD.oldFile);
  Assert(inF#NIL,ADR(InOutErr));
  outF:=inF;
END ConfigWB;

BEGIN
 IF wbStarted THEN
  ConfigWB;
 ELSE
  inF := DosL.Input(); 
  outF:= DosL.Output();
 END;
CLOSE
 IF wbStarted THEN
  IF inF#NIL THEN 
    IGNORE DosL.Write(outF,ADR(RetMsg),SIZE(RetMsg));
    IGNORE DosL.Read(inF,ADR(c),1);
    DosL.Close(inF); 
  END;
 END;
END InOut.mod
