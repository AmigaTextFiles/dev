(*#-- BEGIN AutoRevision header, please do NOT edit!
*
*   Program         :   Riff.mod
*   Copyright       :   1992 ©, By DigiSoft
*   Author          :   Marcel Timmermans
*   Address         :   A. Dekenstr 22, 6836 RM, Arnhem, HOLLAND
*   Creation Date   :   13-09-1992
*   Current version :   1.1
*   Translator      :   M2Amiga V4.1d
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   21-12-1992     1.0            First Release
*   26-06-1993     1.1            Make Riff more easier to use, with the
*                                 reqtools multifile requester.
*
*-- END AutoRevision header --*)

MODULE riff;

FROM SYSTEM 	  IMPORT ADR,ADDRESS,SHIFT,SHORTSET,LONGSET,TAG;

IMPORT id:IntuitionD,il:IntuitionL,a:Arguments,io:Terminal,A:Arts,ud:UtilityD,
       s:String;

FROM readiff    IMPORT ReadILBM,IFFError,IFFErrors;
FROM ReqTools   IMPORT FileListPtr,FileRequest,FileRequesterPtr,AllocRequestA,
                       FreeFileList,FreeRequest,fReqMultiSelect,TypeFileReq,fiDir,
                       ChangeReqAttrA,Window,LockWindowTag,fReqNoBuffer;

CONST
  AutoVersion = '1.1';
  AutoDate    = '26.06.1993';
  CopyRight="Riff V"+AutoVersion+", iff reader, "+AutoDate+", © DigiSoft\n";

TYPE
  String    = ARRAY[0..255] OF CHAR;
  StringPtr = POINTER TO String;

VAR
  numArgs,arg,len: INTEGER;
  path,filename,complete : String;
  filereq : FileRequesterPtr;
  flist,templist : FileListPtr;
  tagbuf:ARRAY [0..5] OF LONGINT;
  myscreen : id.ScreenPtr;

(*-------------------------------------------------------------------------*)
(*-------------------------------------------------------------------------*)

PROCEDURE WaitLMouse;
VAR Ciapra[0BFE001H]: SHORTSET;
BEGIN
 WHILE 6 IN Ciapra DO END;
 WHILE ((6 IN Ciapra)=FALSE) DO END;
END WaitLMouse;

(*-------------------------------------------------------------------------*)
(*-------------------------------------------------------------------------*)

BEGIN
 io.WriteString(CopyRight);
 filereq:= AllocRequestA(TypeFileReq,NIL);
 A.Assert(filereq#NIL,ADR("Not enough memory"));
 filereq^.flags:=LONGSET{fReqMultiSelect,fReqNoBuffer};
 ChangeReqAttrA (filereq,TAG(tagbuf,fiDir,ADR(path),ud.tagEnd));
 flist := FileRequest( filereq, ADR(filename), ADR("Pick some iff-files"),
         TAG(tagbuf,LockWindowTag,TRUE,ud.tagEnd));

 s.Copy(path,StringPtr(filereq^.dir)^);
 templist:=flist;
 WHILE templist#NIL DO
  IF s.Length(path) > 0 THEN
    s.Copy(complete,path);
    s.ConcatChar(complete,"/");
    s.Concat(complete,StringPtr(templist^.name)^);
  ELSE
    s.Copy(complete,StringPtr(templist^.name)^);
  END;
  IFFError:=ReadILBM(complete,myscreen);
  IF IFFError=iffNoErr THEN
    WaitLMouse;
  ELSE
   io.WriteString("Error in ReadIff module with filename : ");
   io.WriteString(complete);
   io.WriteString("\n");
  END;
  IF myscreen#NIL THEN il.CloseScreen(myscreen); END;
  templist:=templist^.next;
  IF templist=NIL THEN io.WriteString("Ready\n"); END;
 END;
CLOSE
 IF myscreen#NIL THEN il.CloseScreen(myscreen); END;
 IF filereq#NIL  THEN FreeRequest(filereq); filereq:=NIL; END;
END riff.
