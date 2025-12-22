-> sptrans.e - Math SP IEEE Transcendental example of SPCos().

->>> Header (globals)
MODULE 'mathieeesingtrans'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL

CONST STRSIZE=10, ACC=5
->>>

->>> PROC main()
PROC main() HANDLE
  -> E-Note: IEEE single is the format used for reals in E
  -> E-Note: C version gets it wrong: 30 degrees in radians is PI/6=0.52359878
  DEF num1=0.52359878, result, s[STRSIZE]:STRING
  mathieeesingtransbase:=OpenLibrary('mathieeesingtrans.library', 34)
  result:=IeeeSPCos(num1)
  -> E-Note: alternatively, no need to open library, use:  result:=Fcos(num1)
  WriteF('The single precision cosine of 30 degrees is \s\n',
         RealF(s, result, ACC))
EXCEPT DO
  IF mathieeesingtransbase THEN CloseLibrary(mathieeesingtransbase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: could not open mathieeesingtrans library\n')
  ENDSELECT
ENDPROC
->>>

