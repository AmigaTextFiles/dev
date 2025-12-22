-> longreal module!

OPT MODULE
OPT EXPORT

OBJECT longreal
  PRIVATE a,b
ENDOBJECT

MODULE 'mathieeedoubbas', 'mathieeedoubtrans'

EXPORT DEF mathieeedoubbascount, mathieeedoubtranscount

RAISE "DLIB" IF OpenLibrary()=NIL

PROC dInit(trans=TRUE)
  IF mathieeedoubbascount=0
    mathieeedoubbasbase:=OpenLibrary('mathieeedoubbas.library',0)
  ENDIF
  mathieeedoubbascount++
  IF trans
    IF mathieeedoubtranscount=0
      mathieeedoubtransbase:=OpenLibrary('mathieeedoubtrans.library',0)
    ENDIF
    mathieeedoubtranscount++
  ENDIF
ENDPROC

PROC dCleanup(trans=TRUE)
  IF mathieeedoubbasbase
    IF mathieeedoubbascount--=0 THEN CloseLibrary(mathieeedoubbasb