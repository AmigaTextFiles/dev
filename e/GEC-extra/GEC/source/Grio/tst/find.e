
OPT OSVERSION=36

MODULE 'dospath'


PROC main()
DEF path,lock=NIL,buf[104]:ARRAY

IF arg[]
   IF (dospathbase:=OpenLibrary('dospath.library',1))
      path:=GetProcessPathList(FindTask(NIL))
      IF (lock:=FindFileInPathList({path},arg))
         NameFromLock(lock,buf,102)
         Vprintf('file {\s} is located in dir [\s]\n',[arg,buf])
      ELSE
         Vprintf('can\at find file {\s}\n',[arg])
      ENDIF
      CloseLibrary(dospathbase)
   ENDIF
ELSE
   Vprintf('USAGE: <name>\n',NIL)
ENDIF

ENDPROC

