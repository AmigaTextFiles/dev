PROC main()
  DEF myargs[3]:LIST, rdargs, template:PTR TO LONG
  myargs[0]:=0
  myargs[1]:=0
  myargs[2]:=0
  template:='QUIET/S,DELAY/K/N,NOW/S,?/S'
  rdargs:=ReadArgs(template,myargs,NIL)
  IF myargs[3]=-1
    about()
  ELSE
    IF (myargs[1]) AND (myargs[2]=-1) THEN Delay(Long(myargs[1])*50)
    IF myargs[0]=-1
    IF (myargs[1]) AND (myargs[2]<>-1) THEN Delay(Long(myargs[1])*50)
      ColdReboot()
    ELSE
      IF EasyRequestArgs(0,[20,0,0,'¡Reboot!\nAre you sure?','YEAH|OOPS!'],0,0)=1
IF (myargs[1]) AND (myargs[2]<>-1) THEN Delay(Long(myargs[1])*50)
        ColdReboot()
      ENDIF
    ENDIF
  ENDIF
  FreeArgs(rdargs)
ENDPROC

PROC about()
  PrintF('Reboot by \e[32mSteven Goodgrove\e[0m\n')
  PrintF('\nUSAGE:-\eDQUIET/S,DELAY/K/N\n')
ENDPROC
