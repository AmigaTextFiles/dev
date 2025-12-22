-> longreal module!

-> longrealtiny module for ECX PPC mode. We basically just reuse the private internal
-> ___mathieeedoub#?base bases...

-> DO NOT USE FOR NEW CODE!!

OPT MODULE, POWERPC, MORPHOS

EXPORT OBJECT longreal
  PRIVATE a,b
ENDOBJECT

MODULE 'mathieeedoubbas', 'mathieeedoubtrans'

DEF mathieeedoubbasbase, mathieeedoubtransbase

EXPORT PROC dInit(trans=TRUE)
   mathieeedoubbasbase := ___mathieeedoubbasbase
   mathieeedoubtransbase := ___mathieeedoubtransbase
ENDPROC

EXPORT PROC dCleanup(trans=TRUE)
ENDPROC

EXPORT PROC dFloat(int,longreal:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFlt(int)
  longreal.a:=a
  longreal.b:=b
ENDPROC longreal

EXPORT PROC dFix(longreal:PTR TO longreal) IS IeeeDPFix(longreal.a,longreal.b)

EXPORT PROC dCompare(x:PTR TO longreal,y:PTR TO longreal) IS IeeeDPCmp(x.a,x.b,y.a,y.b)

EXPORT PROC dAdd(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAdd(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

EXPORT PROC dSub(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSub(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

EXPORT PROC dMul(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPMul(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

EXPORT PROC dDiv(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPDiv(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

EXPORT PROC dRound(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFloor(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

EXPORT PROC dRoundUp(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCeil(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

EXPORT PROC dNeg(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPNeg(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

EXPORT PROC dAbs(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAbs(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

EXPORT PROC dCopy(x:PTR TO longreal,y:PTR TO longreal)
  x.a:=y.a
  x.b:=y.b
ENDPROC x

EXPORT PROC dFormat(s,x,num)
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

EXPORT PROC dSqrt(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSqrt(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x
