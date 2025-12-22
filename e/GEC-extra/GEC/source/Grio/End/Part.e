
OPT OSVERSION=37

ENUM PATH,FILE,VAR,NUMARGS

DEF rdargs , args[NUMARGS]:LIST , x , buf[512]:STRING

PROC main()

  VOID '$VER: Part 1.1 (07.12.96) by Grio'

  FOR x:=0 TO NUMARGS-1 DO args[x]:=NIL
  IF rdargs:=ReadArgs('Path,File,Var',args,NIL)
     IF args[PATH]
        StrCopy(buf,args[PATH],ALL)
        IF args[FILE]
           AddPart(buf,args[FILE],ALL)
           x:=buf
        ELSE
           x:=FilePart(args[PATH])
        ENDIF
        IF args[VAR]
           SetVar(args[VAR],x,ALL,$200)
        ELSE
           PrintF('\s\n',x)
        ENDIF   
     ENDIF   
     FreeArgs(rdargs)
  ELSE
     PrintFault(IoErr(),NIL)
  ENDIF

ENDPROC




