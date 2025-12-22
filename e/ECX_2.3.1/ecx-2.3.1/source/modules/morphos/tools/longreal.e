-> longreal module!

-> longreal module for ECX PPC mode, we basically just use the private internal
-> mathieeedoub#? bases.

-> DO NOT USE IN NEW CODE !!

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

EXPORT PROC dTst(x:PTR TO longreal) IS IeeeDPTst(x.a,x.b)

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

/*********************************************************************/
/* Converts a longreal x to ascii in buffer s with num digits        */
/* Only for fraction numbers                                         */
/*                                                                   */
/* PARAM IN    s   - buffer for ascii representation [STRING]        */
/*             x   - longreal to be converted                        */
/*             num - number of digits                                */
/* RETURN      s   - buffer for ascii representation [STRING]        */
/* COMMENT     Buffer s must be large enough to contain the string   */
/*********************************************************************/

EXPORT PROC dFormat(s,x,num)
  DEF c:longreal, d:longreal, e, f[1]:ARRAY, fmt
  IF dTst(x)<0
    dNeg(x)
    fmt:='-\d.'
  ELSE
    fmt:='\d.'
  ENDIF
  StringF(s,fmt,dFix(x))
  dCopy(c,x)
  FOR e:=1 TO num
    dCopy(d,c)
    dRound(d)
    dSub(c,d)
    dFloat(10,d)
    dMul(c,d)
    f[]:="0"+Abs(dFix(c))
    StrAdd(s,f,1)
  ENDFOR
ENDPROC s

/*********************************************************************/
/* Converts a longreal x to ascii in buffer s with num digits        */
/* Also for 'large' numbers                                          */
/*                                                                   */
/* PARAM IN    s   - buffer for ascii representation [STRING]        */
/*             x   - longreal to be converted                        */
/*             num - number of digits                                */
/* RETURN      s   - buffer for ascii representation [STRING]        */
/* COMMENT     Buffer s must be large enough to contain the string   */
/*********************************************************************/

EXPORT PROC dLFormat(s,x:PTR TO longreal,num)
  DEF power,a:longreal
  DEF one:longreal,ten:longreal
  DEF buffer[30]:STRING
  DEF sign

  sign:=1
  dDouble(10.0,ten)
  dDouble(1.0,one)
  dCopy(a,x)
  power:=0
  IF dTst(a)=0
    dFormat(s,a,num)
    RETURN s
  ENDIF
  IF (dTst(a)=-1)
    sign:=-1
    dNeg(a)
  ENDIF
  IF dCompare(a,one)=-1
    WHILE dCompare(a,one)=-1
      dMul(a,ten)
      power--
    ENDWHILE
  ELSE
    WHILE dCompare(a,ten)=1
      dDiv(a,ten)
      power++
    ENDWHILE
  ENDIF
  dFormat(buffer,a,num)
  IF (sign=1)
    StringF(s,'\sE\d',buffer,power)
  ELSE
    StringF(s,'-\sE\d',buffer,power)
  ENDIF
ENDPROC s

/*********************************************************************/
/* Converts an ascii representation to a longreal                    */
/*                                                                   */
/* PARAM IN    buffer - buffer with longreal in ascii [STRING]       */
/*             x      - converted longreal                           */
/*********************************************************************/

EXPORT PROC a2d(buffer,x:PTR TO longreal)
 DEF divider:longreal
 DEF fraction:longreal
 DEF ten:longreal
 DEF tmp:longreal
 DEF longexp:longreal

 DEF i,exp,expsign,sign

 DEF tmpbuffer[256]:STRING

 dFloat(0,x)
 dFloat(10,ten)
 i:=0
 sign:=1
 IF buffer[i]="-"
   sign:=-1
   i++
 ELSE
   IF buffer[i]="+" THEN i++
 ENDIF

 WHILE ((buffer[i]>="0") AND (buffer[i]<="9") AND (buffer[i]<>0))
  dFloat(buffer[i]-"0",tmp)
  dMul(x,ten)
  dAdd(x,tmp)
  i++
 ENDWHILE


 IF (buffer[i]="." AND (buffer[i+1]>="0") AND (buffer[i+1]<="9"))
   i++
   dFloat(1,divider)
   dFloat(0,fraction)
   WHILE ((buffer[i]>="0") AND (buffer[i]<="9") AND (buffer[i]<>0))
    dMul(fraction,ten)
    dFloat(buffer[i]-"0",tmp)
    dAdd(fraction,tmp)
    dMul(divider,ten)
    i++
   ENDWHILE
   dDiv(fraction,divider)
   dAdd(x,fraction)
  ENDIF
  dFloat(sign,tmp)
  dMul(x,tmp)

  IF ((buffer[i]="E") OR (buffer[i]="e"))
    i++
    IF buffer[i]="-"
      expsign:=-1
      i++
    ELSE
      expsign:=1
      IF (buffer[i]="+") THEN i++
    ENDIF
    exp:=0
    WHILE ((buffer[i]>="0") AND (buffer[i]<="9") AND (buffer[i]<>0))
      exp:=Mul(exp,10)+buffer[i]-"0"
      i++
    ENDWHILE
    dFloat(exp*expsign,longexp)
    dPow(ten,longexp)
    dMul(x,ten)
  ENDIF
ENDPROC


/* Converts an IEEE single to a longreal */

EXPORT PROC dDouble(x,to:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFieee(x)
  to.a:=a
  to.b:=b
ENDPROC


/* Converts a longreal to an IEEE single */

EXPORT PROC dSingle(x:PTR TO longreal) IS IeeeDPTieee(x.a,x.b)


EXPORT PROC dSqrt(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSqrt(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC


/* Return longreal PI in x */

EXPORT PROC dPi(x:PTR TO longreal)
 x.a:=$400921FB            /* Dirty but quick 8-) */
 x.b:=$54442D18
ENDPROC x

/* Converts x from degrees to radians */

EXPORT PROC dRad(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF s:longreal,t:longreal

  dPi(t)
  dDouble(180.0,s)

  dDiv(t,s)
  dMul(t,x)
  IF to
    to.a:=t.a
    to.b:=t.b
    RETURN to
  ELSE
    x.a:=t.a
    x.b:=t.b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dSin(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSin(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dCos(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCos(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dTan(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPTan(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dASin(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAsin(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


EXPORT PROC dACos(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAcos(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


EXPORT PROC dATan(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAtan(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dSinh(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSinh(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dCosh(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCosh(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dTanh(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPTanh(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


EXPORT PROC dExp(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPExp(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dLn(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPLog(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

EXPORT PROC dLog(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPLog10(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

/* Calculates x^y */

EXPORT PROC dPow(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPPow(y.a,y.b,x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


