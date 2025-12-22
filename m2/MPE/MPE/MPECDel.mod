(*#-- BEGIN AutoRevision header, please do NOT edit!
*
*   Program         :   MPECDel.mod
*   Copyright       :   1992 ©, By DigiSoft
*   Author          :   Marcel Timmermans
*   Address         :   A. Dekenstraat 22, 6836 RM, Arnhem, HOLLAND
*   Creation Date   :   02-09-1992
*   Current version :   1.1
*   Translator      :   M2Amiga V4.1d
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   02-09-1992     1.0            First Release
*   01-01-1993     1.1            Compiled with M2Amiga V4.1
*
*-- END AutoRevision header --*)

(* This program is public domain, so you may do with it whatever you want *)

MODULE MPECDel;

(*$ LargeVars:=FALSE
    StackChk:=FALSE
    OverflowChk:=FALSE
    RangeChk:=TRUE
    ReturnChk:=TRUE
    NilChk:=FALSE
    LongAlign:=FALSE
    Volatile:=FALSE
    StackParms:=FALSE
 *)

FROM SYSTEM 	  IMPORT ADR,ADDRESS,SHIFT,TAG;
IMPORT dl:DosL,dd:DosD,s:String,A:Arts,str:StrSupport,a:Arguments,t:Terminal,
       el:ExecL,ed:ExecD;



CONST AutoVersion = '1.1';
      DeleteTxt   = 'MPE.CFG';
      Info        = '\033[33mMPECDel\033[31m, V'+AutoVersion+', 01-01-93, © DigiSoft\n' +
                    'This program deletes all the MPE configuration files in the given directory\nand sub directories.\n' +
	            'Usage: MPECDel <directory>\n';
TYPE
  String    = ARRAY[0..255] OF CHAR;
  StringPtr = POINTER TO String;

VAR
  numArgs,arg,len: INTEGER;
  path : String;


PROCEDURE Searching(Drive:ARRAY OF CHAR;depth:INTEGER;target:ARRAY OF CHAR);
VAR info:dd.FileInfoBlockPtr;
    lock:dd.FileLockPtr;
    temp:ARRAY[0..200] OF CHAR;
    ch:ARRAY[0..1] OF CHAR;
    len:INTEGER;
BEGIN
 lock:=dl.Lock(ADR(Drive),NIL);
 IF lock=NIL THEN RETURN END;

 info:=el.AllocMem(SIZE(info^),ed.MemReqSet{ed.public});
 IF info=NIL THEN
  dl.UnLock(lock);
  RETURN;
 END;

 IF (dl.Examine(lock,info)=TRUE) THEN
  WHILE dl.ExNext(lock,info)#FALSE DO
   s.Copy(temp,Drive);
   IF (depth > 1) THEN s.ConcatChar(temp,"/"); END;
    s.Concat(temp,info^.fileName);
    IF str.StrCmp(ADR(info^.fileName),ADR(DeleteTxt))=0 THEN
     t.WriteString("\033[33mFound\033[31m ");
     t.WriteString(temp);
     t.WriteString("\nDelete (Y/N) ");
     t.ReadLn(ch,len);
     CASE ch[0] OF
      "Y","y" : IF dl.DeleteFile(ADR(temp)) THEN t.WriteString("File deleted\n");
      		ELSE t.WriteString("\033[33mError Deleting\033[31m "); END |
     ELSE
      t.WriteString("File not deleted\n");
     END;
    END;
    IF (info^.dirEntryType > 0) THEN Searching(temp,depth+1,DeleteTxt); END;
  END;
 END;
 dl.UnLock(lock);
 el.FreeMem(info,SIZE(info^));
END Searching;

BEGIN
 numArgs := a.NumArgs();
 path := "";
 IF numArgs=1 THEN
  a.GetArg(1,path,len);
  IF path[0]="?" THEN
    t.WriteString(Info);
  ELSIF path[s.Length(path)-1]=':' THEN
     t.WriteString("Searching ... \n");
     Searching(path,1,DeleteTxt);
     t.WriteString("\033[33mEverything is done.\033[31m\n");
   ELSE
     t.WriteString("Searching ... \n");
     Searching(path,2,DeleteTxt);
     t.WriteString("\033[33mEverything is done.\033[31m\n");
   END;
 ELSE
  t.WriteString(Info);
 END;
CLOSE

END MPECDel.
