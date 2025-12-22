MODULE 'workbench/startup', 'intuition/intuition'

PROC main()
  DEF wb:PTR TO wbstartup, args:PTR TO wbarg
  DEF olddir=NIL, string[300]:STRING, fh=NIL
  DEF path[200]:STRING, file[200]:STRING
  IF wbmessage<>NIL
    wb:=wbmessage
    args:=wb.arglist
    args++
    olddir:=CurrentDir(args[].lock)
    GetCurrentDirName(string,args[].lock)
    AddPart(string,args[].name,300)
    sayme()
    PrintF(IF script_or_exe(string) THEN 'Running \a\s\a\n' ELSE 'Executing script \a\s\a\n', string)
    IF (fh:=Open('SYS:ReRun.tmp',NEWFILE))
      Write(fh,string,StrLen(string))
      Close(fh)
    ENDIF
    CurrentDir(olddir)
    Delay(150)
    ColdReboot()
  ELSE
    IF (fh:=Open('SYS:ReRun.tmp',OLDFILE))
      Read(fh,string,300)
      Close(fh)
      DeleteFile('SYS:ReRun.tmp')
      StrCopy(file,FilePart(string))
      StrCopy(path,string,StrLen(string)-StrLen(PathPart(string)))
      PrintF('\s\t\s\n', path, file)
      dofile(path,file)
    ENDIF
  ENDIF
ENDPROC

PROC script_or_exe(file:PTR TO LONG)
  DEF fh=NIL, string[10]:STRING, exe
  IF (fh:=Open(file,OLDFILE))
    Read(fh,string,5)
    Close(fh)
    IF string[3]=$f3 THEN exe:=TRUE ELSE exe:=FALSE
  ENDIF
ENDPROC exe

PROC dofile(path,file)
  DEF lock, olddir=NIL, command[200]:STRING
  DEF wn:PTR TO window
  sayme()
  IF (lock:=Lock(path,-2))
    olddir:=CurrentDir(lock)
    IF script_or_exe(file)=TRUE
      PrintF('Running \a\s\a\n', file)
      StringF(command,'"\s"', file)
      Execute(command,0,stdout)
      PrintF('\nPress mouse button.\n')
    ELSE
      PrintF('Executing script \a\s\a\n', file)
      StringF(command,'Execute "\s"', file)
      Execute(command,0,stdout)
      PrintF('\nPress mouse button.\n')
    ENDIF
    CurrentDir(olddir)
    UnLock(lock)
  ENDIF
  wn:=OpenWindowTagList(NIL,[WA_REPORTMOUSE,TRUE,WA_IDCMP,IDCMP_MOUSEBUTTONS,NIL])
  stdrast:=wn.rport
  Colour(1,0)
  TextF(20,20,'Press LEFT Mouse button')
  WaitIMessage(wn)
  CloseW(wn)
  PrintF('Rebooting!\n')
  ColdReboot()
ENDPROC

PROC sayme() IS PrintF('\c\n\e[1mReRun\e[0m\eDBy Steven Goodgrove\n\n\n', 12)

CHAR 0, '$VER:ReRun v1.0', 0
