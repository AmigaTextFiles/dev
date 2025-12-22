-> dpieee.e - Math DP IEEE example of dTst().

->>> Header (globals)
MODULE 'tools/longreal'

CONST STRSIZE=20
CONST FRACTSIZE=STRSIZE-8
->>>

->>> PROC main()
PROC main() HANDLE
  -> E-Note: use the longreals from 'tools/longreal' for double precision IEEE
  DEF num1:longreal, result, six:longreal, s[STRSIZE]:STRING
  dInit(FALSE)  -> E-Note: only use mathieeedoubbas library
  dDiv(dPi(num1), dFloat(-6,six), num1)  -> -30 degrees in radians
  -> E-Note: or alternatively use dInit(TRUE) and dRad(dFloat(-30,num1), num1)

  result:=dTst(num1)
  WriteF('Num1 = \s and result = \d\n', dFormat(s, num1, FRACTSIZE), result)

EXCEPT DO
  dCleanup()
  SELECT exception
  CASE "DLIB";  WriteF('Error: could not open mathieeedoubbas library\n')
  ENDSELECT
ENDPROC
->>>


