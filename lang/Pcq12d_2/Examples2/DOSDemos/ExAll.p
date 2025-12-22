Program ExAllDemo;

{ ExAllDemo by Andreas Tetzl }
{ Public Domain }

{$I "Include:Exec/Memory.i"}
{$I "Dos.i"}

CONST BufferSize = 2048;

VAR ed,p,ed2 : ExAllDataPtr;
    eac : ExAllControlPtr;
    datei : FileLock;
    n, res : Integer;
    more : Boolean;

PROCEDURE CleanExit(Why : String; RC : Integer);
BEGIN
 IF eac<>NIL THEN FreeDosObject(DOS_EXALLCONTROL,eac);
 IF ed<>NIL THEN FreeMem(ed,BufferSize);
 IF datei<>NIL THEN UnLock(datei);
 IF why<>NIL THEN Writeln(Why);
 Exit(RC);
END;


BEGIN
 Writeln("ExAllDemo\nVerzeichnis Sys:\n");

 eac:=AllocDosObject(DOS_EXALLCONTROL,NIL);
 IF eac=NIL THEN CleanExit("Fehler bei AllocDosObject",10);

 ed:=AllocMem(BufferSize,0);
 IF ed=NIL THEN CleanExit("Nicht genug Speicher",10);
 eac^.eac_LastKey:=0;
 eac^.eac_MatchString:=NIL;
 eac^.eac_MatchFunc:=NIL;
 datei:=Lock("sys:",SHARED_LOCK);
 IF datei=NIL THEN CleanExit("Kein Lock auf Sys:",10);

 REPEAT
  more:=ExAll(datei,ed,BufferSize,ED_SIZE,eac);
  res:=IoErr;
  p:=ed;
  For n:=1 to eac^.eac_Entries do
   BEGIN
    Write(p^.ed_Name);
    IF p^.ed_Type>=0 THEN Writeln("(dir)":40) else Writeln(p^.ed_Size:40);
    p:=p^.ed_Next;
   END;
 UNTIL (More=FALSE) AND (res=ERROR_NO_MORE_ENTRIES);

 CleanExit(NIL,0);
END.

