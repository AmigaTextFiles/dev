-> dptrans.e - Math Double-Precision Transcendental example of dSin().

->>> Header (globals)
MODULE 'tools/longreal'

CONST STRSIZE=20
CONST FRACTSIZE=STRSIZE-8
->>>

->>> PROC main()
PROC main() HANDLE
  -> E-Note: use the longreals from 'tools/longreal' for double precision IEEE
  DEF num1:longreal, result:longreal, four:longreal, s[STRSIZE]:STRING
  dInit()
  dDiv(dPi(num1), dFloat(4, four), num1)
  -> E-Note: or alternatively use dRad(dFloat(45, num1), num1)

  dSin(num1, result)
  WriteF('The double precision sine of 45 degrees is \s\n',
         dFormat(s, result, FRACTSIZE))

EXCEPT DO
  dCleanup()
  SELECT exception
  CASE "DLIB";  WriteF('Error: could not open mathieeedoubbas library\n')
  ENDSELECT
ENDPROC
->>>



