MODULE 'tools/ctype'

PROC main()
  DEF rdargs=NIL, myargs[5]:ARRAY OF LONG
  DEF str[100]:STRING, i=NIL
  myargs[0]:=NIL
  myargs[1]:=NIL
  IF (rdargs:=ReadArgs('ASCII/A,NUM=NUMBER/S',myargs,NIL))
    StrCopy(str,myargs[0])
    IF myargs[1]=-1
      IF isprint(Val(str))
        PrintF('\s is\t\c\n', str, Val(str))
      ELSE
        PrintF('\s isn\at a printable character.\n', str)
      ENDIF
    ELSE
      WHILE str[i]<>NIL
        PrintF('\c is\t\d\n', str[i], str[i])
        i++
      ENDWHILE
    ENDIF
    FreeArgs(rdargs)
  ELSE
    PrintF('Bad args!\n')
  ENDIF
ENDPROC
