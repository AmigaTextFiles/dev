OPT TURBO

PMODULE 'PMODULES:openFile',
        'PMODULES:closeFile',
        'PMODULES:readStr'

CONST LARGEST_TOKEN_SUPPORTED=255

RAISE "MEM" IF String()=NIL

PROC reportError(mainLineNumber) HANDLE
/*----------------------------------------------------------*
  Use map file to correct error line number reported by EC,
  and find out what the module name is.  Extracted from EPP
  and modified for reusability (EPP's reportError() function
  relies on global data).  Raises exceptions:  "MEM"=error
  allocating; "FILO"=open file; "FILR"=read file; "lmax"=line
  number out of range.
 *----------------------------------------------------------*/
  DEF defsMapFileName, defsMapFileHandle=NIL, workStr=NIL
  DEF index:PTR TO INT, moduleId=1, moduleLineNumber,
      localLineNumber, globalLineNumber, i=0
  defsMapFileName:='T:epp.map'
  index:=[0, 0, 0]:INT
  defsMapFileHandle:=openFile(defsMapFileName, OLDFILE)
  workStr:=String(LARGEST_TOKEN_SUPPORTED)
  REPEAT
    IF index[1]<=mainLineNumber
      moduleId:=index[0]
      globalLineNumber:=index[1]
      localLineNumber:=index[2]
    ENDIF
    IF Read(defsMapFileHandle, index, 6)<6 THEN Raise("FILR")
  UNTIL index[0]=0
  IF index[1]<mainLineNumber THEN Raise("lmax")
  WHILE i++<moduleId DO readStr(defsMapFileHandle, workStr)
  moduleLineNumber:=mainLineNumber-globalLineNumber+localLineNumber
  WriteF('***EPP: CORRECTED LINE \d, PMODULE ''\s''\n', moduleLineNumber, workStr)
  closeFile(defsMapFileHandle)
  DisposeLink(workStr)
EXCEPT
  closeFile(defsMapFileHandle)
  IF workStr THEN DisposeLink(workStr)
  Raise(exception)
ENDPROC
  /* reportError */

