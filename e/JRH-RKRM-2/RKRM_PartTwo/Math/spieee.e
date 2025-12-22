-> spieee.e - Math SP IEEE example of SPMul().

->>> Header (globals)
MODULE 'mathieeesingbas'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL

CONST STRSIZE=10, ACC=5
->>>

->>> PROC main()
PROC main() HANDLE
  -> E-Note: IEEE single is the format used for reals in E
  DEF mul1=-3.6, mul2=18.7  -> 3.6 multiplied by 18.7
  DEF result, s[STRSIZE]:STRING
  mathieeesingbasbase:=OpenLibrary('mathieeesingbas.library', 34)
  result:=IeeeSPMul(mul1, mul2)
  -> E-Note: alternatively, no need to open library, use:  result:=!mul1*mul2
  WriteF(RealF(s, mul1, ACC))
  WriteF(' multiplied by ')
  WriteF(RealF(s, mul2, ACC))
  WriteF(' = \s\n', RealF(s, result, ACC))
EXCEPT DO
  IF mathieeesingbasbase THEN CloseLibrary(mathieeesingbasbase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: could not open mathieeesingbas library\n')
  ENDSELECT
ENDPROC
->>>

