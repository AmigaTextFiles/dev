OPT OSVERSION=37
MODULE 'dos/var'
PROC main()
DEF rdargs,name,buf[256]:ARRAY,ret=10
IF (rdargs:=ReadArgs('NAME/A',{name},NIL))
   IF GetVar(name,buf,255,GVF_GLOBAL_ONLY)>=0
      Fputs(stdout,buf)
      FputC(stdout,"\n")
      ret:=0
   ELSE
      error()
   ENDIF
   FreeArgs(rdargs)
ELSE
   error()
ENDIF
ENDPROC ret

CHAR '$VER: GetEnv 37.0 (26.03.2002) by Grio',0

PROC error() IS PrintFault(IoErr(),NIL)
