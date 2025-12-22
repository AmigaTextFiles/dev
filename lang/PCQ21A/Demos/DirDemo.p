PROGRAM DirDemo;

{ A simple demo to demostrate some of the new stuff
  in pcq.lib.

  PCQLists, sprintf and to check if the new memoryhandling is
  working.

  All the freeing of memory in CleanUp is not necessery. Since
  the demo is using pcqmemory all memory will be released
  when the program quits.
}

{$I "Include:DOS/Dos.i"}
{$I "Include:DOS/Exall.i"}
{$I "Include:PCQUtils/PCQList.i"}
{$I "Include:Utils/Stringlib.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:PCQUtils/cstrings.i"}
{$I "Include:Utils/PCQMemory.i"}
{$I "Include:PCQUtils/Args.i"}

CONST BufferSize = 2048;

VAR ExData       : ExAllDataPtr;
    PData        : ExAllDataPtr;
    EAC          : ExAllControlPtr;
    MyLock       : FileLock;
    AnyMore      : BOOLEAN;
    FileList     : ListPtr;
    DirList      : ListPtr;
    tempnode     : PCQNodePtr;
    Buffer       : STRING;
    TheDir       : STRING;
    i,temp       : INTEGER;
    TotalSize    : INTEGER;

PROCEDURE CleanUp(TheMsg : STRING; ErrCode : INTEGER);
BEGIN
    IF EAC <> NIL THEN FreeDosObject(DOS_EXALLCONTROL,EAC);
    IF MyLock <> NIL THEN UnLock(MyLock);
    IF ExData <> NIL THEN FreePCQMem(ExData,BufferSize);
    IF DirList <> NIL THEN DestroyList(DirList);
    IF FileList <> NIL THEN DestroyList(FileList);
    IF TheDir <> NIL THEN FreeString(TheDir);
    IF Buffer <> NIL THEN FreeString(Buffer);
    IF TheMsg <> NIL THEN WriteLN(TheMsg);
    Exit(ErrCode);
END;

PROCEDURE Usage;
BEGIN
    Write("\c1mDirDemo\c0m\nFor PCQ Pascal USAGE: DirDemo ThePath\n");
    CleanUp(NIL,0);
END;

BEGIN
    TheDir := AllocString(108);
    Buffer := AllocString(255);
    IF ParamCount <> 1 then Usage;
    TheDir := ParamStr(1);
    CreateList(FileList);
    CreateList(DirList);
    TotalSize := 0;

    EAC := AllocDosObject(DOS_EXALLCONTROL,NIL);
    IF EAC = NIL THEN CleanUp("No AllocDosObject",10);

    GetMem(ExData,BufferSize);
    EAC^.eac_LastKey := 0;
    EAC^.eac_MatchString := NIL;
    EAC^.eac_MatchFunc := NIL;
    MyLock:=Lock(TheDir,SHARED_LOCK);
    IF MyLock=NIL THEN CleanUp("No lock on directory",10);

    REPEAT
        AnyMore := ExAll(MyLock,ExData,BufferSize,ED_SIZE,EAC);
        temp := IOErr;
        PData := ExData;
        FOR i := 1 TO EAC^.eac_Entries DO BEGIN
            IF PData^.ed_Type >= 0 THEN BEGIN
                tempnode := AddNewNode(DirList,PData^.ed_Name);
            END ELSE BEGIN
                tempnode := AddNewNode(FileList,PData^.ed_Name);
                tempnode^.ns_User1 := PData^.ed_Size;
            END;
            PData := PData^.ed_Next;
        END;
    UNTIL (AnyMore=FALSE) AND (temp=ERROR_NO_MORE_ENTRIES);

    SortList(DirList);
    SortList(FileList);

    Write("\c1m");
    Write("\c32m");
    WriteLN("Directory of: '",TheDir,"'");
    tempnode := GetFirstNode(DirList);
    FOR i := 1 TO NodesInList(DirList) DO BEGIN
        sprintf(Buffer,"%-30s  <DIR>",GetNodeData(tempnode));
        WriteLN(Buffer);
        tempnode := GetNextNode(tempnode);
    END;
    Write("\c0m");
    tempnode := GetFirstNode(FileList);
    FOR i := 1 TO NodesInList(FileList) DO BEGIN
        sprintf(Buffer,"%-30s%7ld",GetNodeData(tempnode),tempnode^.ns_User1);
        WriteLN(Buffer);
        TotalSize := TotalSize + tempnode^.ns_User1;
        tempnode := GetNextNode(tempnode);
    END;

    WriteLN("The total size is ",TotalSize," Byte.");
    CleanUp(NIL,0);
END.

