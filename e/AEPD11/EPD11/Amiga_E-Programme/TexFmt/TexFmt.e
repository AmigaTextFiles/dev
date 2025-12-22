MODULE 'workbench/startup', 'workbench/workbench',
       'icon', 'dos/dostags', 'dos/dos'

CONST NUMARGS=1024

DEF y=11


PROC main()
  DEF i, wb:PTR TO wbstartup, args:PTR TO wbarg, olddir,
      templ, rdargs=NIL, arglist[NUMARGS]:LIST
  iconbase:=OpenLibrary('icon.library', 33)
  IF wb:=wbmessage
    IF iconbase=NIL
      CleanUp(10)
    ENDIF
    args:=wb.arglist
    IF wb.numargs<>1
      args++
      FOR i:=2 TO wb.numargs
        IF args[].lock
          olddir:=CurrentDir(args[].lock)
          dofile(args[].name++)
          CurrentDir(olddir)
        ELSE
          dofile(args[].name++)
        ENDIF
      ENDFOR
    ELSE

      interact(args[].name)
    ENDIF
  ELSE
    IF iconbase=NIL
      WriteF('Can''t open icon.library\n')
      CleanUp(10)
    ENDIF
    templ:='FILE/M'
    rdargs:=ReadArgs(templ,arglist,NIL)
    IF rdargs
      IF arglist AND (arglist:=arglist[])
        WHILE arglist[]
          dofile(arglist[]++)
        ENDWHILE
      ENDIF
      FreeArgs(rdargs)
    ENDIF
  ENDIF
  IF iconbase THEN CloseLibrary(iconbase)
ENDPROC

PROC dofile(file)

  DEF handle=NIL, dobj:PTR TO diskobject, fmt=NIL, 
      sysline[256]:STRING, con=NIL, tool, i=0
  handle:=Open(file, OLDFILE)
  IF handle
    IF dobj:=GetDiskObject(file)
      IF tool:=FindToolType(dobj.tooltypes, 'DOTEXFMT')
        LowerStr(tool)
        IF StrCmp(tool, 'tex', ALL)
          fmt:='plain'
        ELSEIF StrCmp(tool, 'latex', ALL)
          fmt:='lplain'
        ELSEIF tool[]
          fmt:=tool
        ENDIF
      ENDIF
    ENDIF
    IF fmt=NIL
      WHILE (i++<20) AND (ReadStr(handle, sysline)<>-1)
        IF StrCmp(sysline, '\\documentstyle', STRLEN)
          fmt:='lplain'
        ELSE
          LowerStr(sysline)

          IF StrCmp(sysline, '% latex', ALL)
            fmt:='lplain'
          ELSEIF StrCmp(sysline, '% tex', ALL)
            fmt:='plain'
          ENDIF
        ENDIF
      ENDWHILE
      IF fmt=NIL
        fmt:='plain'
      ENDIF
    ENDIF
    Close(handle)
    StringF(sysline, 'con:0/\d/640/94/DoTeX - \s/CLOSE/WAIT', y, file)
    IF con:=Open(sysline, NEWFILE)
      StringF(sysline, 'tex:bin/virtex &\s \s', fmt, file)
      SystemTagList(sysline, [SYS_INPUT, NIL, SYS_OUTPUT, con,
                              SYS_ASYNCH, TRUE, NIL])
      y:=y+11
      IF y>106 THEN y:=11
    ENDIF
    IF dobj THEN FreeDiskObject(dobj)
  ELSEIF wbmessage=NIL

    WriteF('File "\s" does not exist\n', file)
  ENDIF
ENDPROC

PROC interact(file)
  DEF name[128]:STRING, sysline[256]:STRING, fmt, handle, pos, found
  pos:=InStr(file, ':', 0)
  IF pos=-1
    pos:=0
  ELSE
    INC pos
  ENDIF
  WHILE (found:=InStr(file, '/', pos))<>-1
    pos:=found+1
  ENDWHILE
  MidStr(name, file, pos, ALL)
  StringF(sysline, 'CON:0/11/640/94/DoTeX -- \s running/CLOSE/WAIT', name)
  IF handle:=Open(sysline, NEWFILE)
    LowerStr(name)
    IF StrCmp(name, 'latex', ALL)
      fmt:='lplain'
    ELSEIF StrCmp(name, 'tex', ALL)

      fmt:='plain'
    ELSE
      fmt:=name
    ENDIF
    StringF(sysline, 'tex:bin/virtex &\s', fmt)
    SystemTagList(sysline, [SYS_INPUT, handle, SYS_OUTPUT, handle,
                            SYS_ASYNCH, FALSE, NIL])
    Close(handle)
  ENDIF
ENDPROC

