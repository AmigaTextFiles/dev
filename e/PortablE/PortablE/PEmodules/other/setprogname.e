OPT POINTER

MODULE 'dos'
MODULE 'dos/dos',
       'dos/dosextens'

PROC setprogname(p:PTR TO STRING)
  DEF cli:PTR TO commandlineinterface, bstr:ARRAY OF CHAR
  IF p[]=NIL
    IF cli:=Cli()
      bstr:=Baddr(cli.commandname) !!VALUE!!ARRAY OF CHAR
      p[]:=NewString(bstr[0])
      IF p[] THEN StrCopy(p[],bstr+1,bstr[0])
    ENDIF
  ENDIF
ENDPROC
