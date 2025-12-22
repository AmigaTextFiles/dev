MODULE 'Fabio/rxobj_oo'

DEF quit = FALSE

PROC main()
  DEF rx:PTR TO rxobj
  DEF rxsig
  DEF sig

  NEW rx.rxobj('FabioSoft')

  WriteF('Host: "FabioSoft" Alive AND Kicking!\n')
  WriteF('Send a QUIT message TO the port!\n')

  rxsig:=rx.signal()
  REPEAT
    sig:=Wait(rxsig)
    rx.get({parse})
  UNTIL quit=TRUE

  WriteF('This is the end...\n')
  END rx
ENDPROC

PROC parse(t)
  WriteF('Parsing:\s\n', t)
  IF StrCmp(t, 'QUIT')
    quit:= TRUE
  ENDIF
ENDPROC TRUE, 0,NIL

