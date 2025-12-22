-> module longreal!

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
    IF mathieeedoubbascount--=0 THEN CloseLibrary(mathieeedoubbasbase)
  ENDIF
  IF trans
    IF mathieeedoubtransbase
      IF mathieeedoubtranscount--=0 THEN CloseLibrary(mathieeedoubtransbase)
    ENDIF
  ENDIF
ENDPROC

PROC dFloat(int,longreal:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFlt(int)
  longreal.a:=a
  longreal.b:=b
ENDPROC longreal

PROC dFix(longreal:PTR TO longreal) IS IeeeDPFix(longreal.a,longreal.b)

PROC dCompare(x:PTR TO longreal,y:PTR TO longreal) IS IeeeDPCmp(x.a,x.b,y.a,y.b)

PROC dAdd(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAdd(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dSub(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSub(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dMul(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPMul(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dDiv(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPDiv(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dRound(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFloor(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

PROC dRoundUp(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCeil(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

PROC dNeg(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPNeg(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

PROC dAbs(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAbs(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

PROC dCopy(x:PTR TO longreal,y:PTR TO longreal)
  x.a:=y.a
  x.b:=y.b
ENDPROC x

PROC dFormat(s,x,num)
  DEF c:longreal, d:longreal, e, f[1]:ARRAY
  StringF(s,'\d.',dFix(x))
  dCopy(c,x)
  FOR e:=1 TO num
    dCopy(d,c)
    dRound(d)
    dSub(c,d)
    dFloat(10,d)
    dMul(c,d)
    f[]:="0"+dFix(c)
    StrAdd(s,f,1)
  ENDFOR
ENDPROC s

PROC dSqrt(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSqrt(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x
