OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'dos/dosextens'

DEF __dosio_files:PTR TO LONG
DEF stderr

PROC dosio_init()
  DEF p:PTR TO process
  IF stdout=NIL
    IF conout=NIL
      conout:=Open('CON:40/40/560/80/AmiTCP Output/AUTO/CLOSE', NEWFILE)
    ENDIF
    SetStdOut(conout)
  ENDIF
  IF stdin=NIL THEN SetStdIn(stdout)
  p:=FindTask(NIL)
  stderr:=IF p.ces THEN p.ces ELSE stdout
  __dosio_files:=[stdin, stdout, stderr]
ENDPROC
