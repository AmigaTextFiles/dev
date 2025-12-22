OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'dos/dos',
       'dos/dosextens'

PROC setprogname(p:PTR TO LONG)
  DEF cli:PTR TO commandlineinterface, bstr
  IF p[]=NIL
    IF cli:=Cli()
      bstr:=BADDR(cli.commandname)
      p[]:=String(bstr[])
      IF p[] THEN StrCopy(p[],bstr+1,bstr[])
    ENDIF
  ENDIF
ENDPROC