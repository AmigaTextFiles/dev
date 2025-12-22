IMPLEMENTATION MODULE ReqTools;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ASSEMBLE,ADDRESS,ADR,TAG,CAST;
FROM UtilityD IMPORT TagItemPtr,tagEnd;
FROM String IMPORT Concat,Copy,Length;
IMPORT ML:ModulaLib;

TYPE str110=ARRAY [0..110] OF CHAR;
     str110Ptr=POINTER TO str110;

VAR
  exec[4]:ADDRESS;

PROCEDURE CloseLibraryOwn(exec{14},n{9}: ADDRESS); CODE -414;
PROCEDURE OpenLibraryOwn(exec{14},n{9}:ADDRESS;v{0}:LONGINT):ADDRESS;CODE -552;

(*$ EntryExitCode- *)
PROCEDURE EZRequestA (bodyfmt{9}, gadfmt{10}: ADDRESS (*ARRAY OF CHAR*);
                      reqInfo{11}: ReqInfoPtr;
                      argarray{2}: ADDRESS;
                      tagList{8}: TagItemPtr): LONGINT;
BEGIN
  ASSEMBLE (
    MOVE.L A6,-(A7)
    MOVEA.L reqToolsBase(A4),A6
    EXG.L D2,A4
    JSR -$42(A6)
    EXG.L D2,A4
    MOVEA.L (A7)+,A6
    RTS
  END);
END EZRequestA;

(*$ EntryExitCode- *)
PROCEDURE EZRequestTags (bodyfmt{9}, gadfmt{10}: ADDRESS (*ARRAY OF CHAR*);
                         reqInfo{11}: ReqInfoPtr;
                         argarray{2}: ADDRESS;
                         tag1{8}: TagItemPtr):LONGINT;
BEGIN
  ASSEMBLE (
    MOVE.L A6,-(A7)
    MOVEA.L reqToolsBase(A4),A6
    EXG.L D2,A4
    JSR -$42(A6)
    EXG.L D2,A4
    MOVEA.L (A7)+,A6
    RTS
  END);
END EZRequestTags;

(*$ EntryExitCode- *)
PROCEDURE EZRequest (bodyfmt{9}, gadfmt{10}: ADDRESS (*ARRAY OF CHAR*);
                     reqInfo{11}: ReqInfoPtr;
                     tagList{8}: TagItemPtr;
                     argarray{2}: ADDRESS (*LONGINT*)): LONGINT;
BEGIN
  ASSEMBLE (
    MOVE.L A6,-(A7)
    MOVEA.L reqToolsBase(A4),A6
    EXG.L D2,A4
    JSR -$42(A6)
    EXG.L D2,A4
    MOVEA.L (A7)+,A6
    RTS
  END);
END EZRequest;

(*$ EntryExitCode- *)
PROCEDURE vEZRequestA (bodyfmt{9}, gadfmt{10}: ADDRESS (*ARRAY OF CHAR*);
                       reqInfo{11}: ReqInfoPtr;
                       argarray{2}: ADDRESS;
                       tagList{8}: TagItemPtr);
BEGIN
  ASSEMBLE (
    MOVE.L A6,-(A7)
    MOVEA.L reqToolsBase(A4),A6
    EXG.L D2,A4
    JSR -$42(A6)
    EXG.L D2,A4
    MOVEA.L (A7)+,A6
    RTS
  END);
END vEZRequestA;

(*$ EntryExitCode- *)
PROCEDURE vEZRequestTags (bodyfmt{9}, gadfmt{10}: ADDRESS (*ARRAY OF CHAR*);
                          reqInfo{11}: ReqInfoPtr;
                          argarray{2}: ADDRESS;
                          tag1{8}: TagItemPtr);
BEGIN
  ASSEMBLE (
    MOVE.L A6,-(A7)
    MOVEA.L reqToolsBase(A4),A6
    EXG.L D2,A4
    JSR -$42(A6)
    EXG.L D2,A4
    MOVEA.L (A7)+,A6
    RTS
  END);
END vEZRequestTags;

(*$ EntryExitCode- *)
PROCEDURE vEZRequest (bodyfmt{9}, gadfmt{10}: ADDRESS (*ARRAY OF CHAR*);
                      reqInfo{11}: ReqInfoPtr;
                      tagList{8}: TagItemPtr;
                      argarray{2}: ADDRESS (*LONGINT*));
BEGIN
  ASSEMBLE (
    MOVE.L A6,-(A7)
    MOVEA.L reqToolsBase(A4),A6
    EXG.L D2,A4
    JSR -$42(A6)
    EXG.L D2,A4
    MOVEA.L (A7)+,A6
    RTS
  END);
END vEZRequest;

PROCEDURE EasyFileReq(VAR fname:ARRAY OF CHAR; win:ADDRESS; title:ARRAY OF CHAR;
                       x,y:INTEGER; VAR pattern:ARRAY OF CHAR; save:BOOLEAN):BOOLEAN;
VAR filereq:FileRequesterPtr;
    ok:BOOLEAN;
    File,Dir:str110;
    tagbuf: ARRAY[0..5] OF LONGINT;
BEGIN
  ok:=TRUE;
  filereq:=AllocRequestA(TypeFileReq, NIL);
  IF filereq#NIL THEN
     File:='';
     ChangeReqAttrA(filereq,TAG(tagbuf,fiDir,ADR(""),tagEnd));
     INCL(filereq^.flags,fReqNoBuffer);
     IF save THEN INCL(filereq^.flags,fReqSave); END;
     IF x>=0 THEN filereq^.leftOffset:=x; END;
     IF y>=0 THEN filereq^.topOffset:=y; END;
     IF (x>=0) OR (y>=0) THEN filereq^.reqPos:=ReqPosTopLeftScr; END;
     IF (FileRequest(filereq,ADR(File),ADR(title),
                TAG(tagbuf,Window,win,LockWindowTag,TRUE,tagEnd)) # NIL) THEN
      Dir:=str110Ptr(filereq^.dir)^;
      IF (Length(Dir)>0) AND (Dir[Length(Dir)-1]#':') THEN
        Concat(Dir,'/');
      END;
      Concat(Dir,File);
      Copy(fname,Dir);
      ok:=TRUE;
     END;
     FreeRequest(filereq);
  END;
END EasyFileReq;

BEGIN
 reqToolsBase:=OpenLibraryOwn(exec,ADR(ReqToolsName),ReqToolsVersion);
 IF reqToolsBase=NIL THEN ML.TermOpenLib(ADR(ReqToolsName)); END;
CLOSE
 IF reqToolsBase#NIL THEN CloseLibraryOwn(exec,reqToolsBase); reqToolsBase:=NIL END;
END ReqTools.
