PMODULE 'PMODULES:floatToString'

PROC main ()
  DEF s [FLOAT_MAX_STRING_LENGTH] : STRING
  floatToString (s, 2.0, 1)
  WriteF ('\d \s\n', 1, s)
  floatToString (s, 2.0, 4)
  WriteF ('\d \s\n', 2, s)
  floatToString (s, 200.00001, 5)
  WriteF ('\d \s\n', 3, s)
  floatToString (s, 2000000.0, 4)
  WriteF ('\d \s\n', 4, s)
  floatToString (s, 4.001, 3)
  WriteF ('\d \s\n', 5, s)
  floatToString (s, 0.0004, 4)
  WriteF ('\d \s\n', 6, s)
  floatToString (s, 0.0000004, FLOAT_MAX_STRING_LENGTH)
  WriteF ('\d \s\n', 7, s)
  floatToString (s, 0.4444444, FLOAT_MAX_STRING_LENGTH)
  WriteF ('\d \s\n', 8, s)
  floatToString (s, SpDiv (7.0, 22.0), 7)
  WriteF ('\d \s\n', 9, s)
ENDPROC
