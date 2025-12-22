PMODULE 'PMODULES:skipNonWhite'
PMODULE 'PMODULES:cSkipNonWhite'
PMODULE 'PMODULES:eTimer'

PROC main ()
  DEF s [260] : STRING,
      i
  FOR i := 0 TO 10 DO StrAdd (s, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', ALL)

  et_startTimer (0, 'skipNonWhite')
  FOR i := 1 TO 1000 DO VOID skipNonWhite (s, 0)
  et_stopTimer ()

  et_startTimer (0, 'cSkipNonWhite')
  FOR i := 1 TO 1000 DO VOID cSkipNonWhite (s)
  et_stopTimer ()

ENDPROC
