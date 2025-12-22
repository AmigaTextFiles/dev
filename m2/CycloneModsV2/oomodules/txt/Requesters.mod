IMPLEMENTATION MODULE Requesters;

FROM SYSTEM IMPORT TAG,ADDRESS,CAST,ADR,SETREG;
FROM Objects IMPORT TObject;
FROM UtilityD IMPORT TagItemPtr,tagEnd;
IMPORT rt:ReqTools;

CONSTRUCTOR TFileListBox.Init;
BEGIN
 filereq:=rt.AllocRequestA(rt.TypeFileReq,NIL);
 x:=0; y:=0;
 FDir:=NIL; FTitle:=NIL; win:=NIL;
 FName:="";
END TFileListBox.Init;

PROCEDURE TFileListBox.Do(save:BOOLEAN):BOOLEAN;
VAR
  tagbuf: ARRAY[0..5] OF LONGINT;
  result:BOOLEAN;
  Win:ADDRESS;
BEGIN
  Win:=win;
  rt.ChangeReqAttrA(filereq,TAG(tagbuf,rt.fiDir,FDir,tagEnd));
  IF save THEN INCL(filereq^.flags,rt.fReqSave); END;
  result:=(rt.FileRequest(filereq,ADR(FName),FTitle,TAG(tagbuf,rt.Window,Win,rt.LockWindowTag,TRUE,tagEnd)) # NIL);
  RETURN result;
END TFileListBox.Do;

PROCEDURE TFileListBox.GetName(VAR str:ARRAY OF CHAR);
BEGIN
END TFileListBox.GetName;

PROCEDURE TFileListBox.GetPath(VAR path:ARRAY OF CHAR);
BEGIN
 SETREG(10,ADR(path));
 SETREG(9,filereq^.dir);
END TFileListBox.GetPath;

DESTRUCTOR TFileListBox.Done;
BEGIN
 IF filereq#NIL THEN rt.FreeRequest(filereq); END;
END TFileListBox.Done;

END Requesters.
