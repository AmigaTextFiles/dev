LIBRARY "dos.library"
DECLARE FUNCTION Execute&(c&,i&,o&) LIBRARY
LIBRARY OPEN "dos.library"

DECLARE SUB shell(BYVAL cmd$)

REM *** Test **************************************************
shell "sys:utilities/multiview ppaint:pictures/tutankhamon.pic"
REM ***********************************************************

SUB shell(BYVAL cmd$)
'This SUB executes a program.
  cmd$=cmd$+CHR$(0)
  cmd&=SADD(cmd$)
  s&=Execute&(cmd&,0,0)
END SUB
