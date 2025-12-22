/*
** use this to close the console tracing window if it does not close itself
** usage: CloseTrace $n
** where $n is the number that appears after the minus signs ---------
*/
MODULE 'dos'
PROC main()
  DEF con=0
  IF con:=Val(arg) THEN Close(con)
ENDPROC
