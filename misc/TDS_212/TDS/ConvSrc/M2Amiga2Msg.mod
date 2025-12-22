(*
 * M2Amiga2Msg
 * Error converter M2Amiga/TDS - ©1994 by Matthias Bock (public domain)
 * Bugs? Suggestions? Write to starfox@incubus.sub.org
 *)

MODULE M2Amiga2Msg;

FROM SYSTEM IMPORT ADR;
FROM Arts IMPORT Assert;
FROM InOut IMPORT WriteString,WriteInt,WriteLn,Read;
FROM Conversions IMPORT StrToVal;
FROM String IMPORT CopyPart,Concat;
FROM ASCII IMPORT ht,lf; (* horizontal tab *)
FROM FileSystem IMPORT Lookup,Close,File,ReadChar,Response;

FROM DosL IMPORT System,DeleteFile;
FROM DosD IMPORT SysTags;
FROM UtilityD IMPORT tagEnd;

TYPE
  String=ARRAY SHORTCARD OF CHAR;

PROCEDURE ReadLn(VAR file:File; VAR string:ARRAY OF CHAR; VAR l:INTEGER);
  VAR
    char:CHAR;
    cPtr:POINTER TO CHAR;
  BEGIN
    string[0]:=0C;
    cPtr:=ADR(string);
    l:=0;
    REPEAT
      ReadChar(file,char);
      cPtr^:=char;
      INC(cPtr);
      INC(l);
    UNTIL (char=lf) OR file.eof;
    cPtr^:=0C;
    DEC(l);
  END ReadLn;

VAR
  name,string:String;
  long,longMem:LONGINT;
  pos,parent,length:INTEGER;
  dummy,which:BOOLEAN;
  switch:ARRAY BOOLEAN OF String; (* 2 lines of buffer *)
  char:CHAR;
  file:File;

BEGIN
  
  (* Get full(!) name of file *)
  REPEAT
    REPEAT Read(char) UNTIL char=">"; Read(char);
    name:=""; pos:=0;
    REPEAT Read(char); name[pos]:=char; INC(pos) UNTIL char=lf;
    name[pos-1]:=0C;
    Read(char);
  UNTIL char<>"(";
  (* Call M2Error *)
  string:="M2:M2Error ";
  Concat(string,name); Concat(string," >T:M2Amiga2Msg.tmp");
  long:=System(ADR(string),NIL);
  
  (* Convert the errors *)
  Lookup(file,"T:M2Amiga2Msg.tmp",16384,FALSE);
  Assert(file.res=done,ADR("M2Amiga2Msg: FileError"));
  length:=0; which:=TRUE; switch[TRUE]:=""; switch[FALSE]:="";
  REPEAT
    parent:=length;
    ReadLn(file,switch[which],length);
    IF switch[which][0]=ht THEN
      pos:=0; WHILE switch[~which][pos]=" " DO INC(pos) END;
      CopyPart(string,switch[~which],pos,5-pos);
      longMem:=long; StrToVal(string,long,dummy,10,dummy);
      IF long=0 THEN long:=longMem END;
      pos:=2; WHILE switch[which][pos]<>"^" DO INC(pos) END;
      ReadLn(file,switch[which],length);
      CopyPart(string,switch[which],9,length-9);
      WriteString("<"); WriteString(name); WriteString("> ");
      WriteInt(long,0); WriteString(" "); WriteInt(pos,0); 
      WriteString(" E <"); WriteString(string); WriteString(">"); WriteLn;
    END;
    which:=~which;
  UNTIL (length=0)&(parent=0);
  Close(file);
  IF DeleteFile(ADR("T:M2Amiga2Msg.tmp")) THEN END;
END M2Amiga2Msg.
