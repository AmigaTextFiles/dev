/* here's another RealF, in case your version isn't working  */

OPT MODULE
OPT EXPORT

PROC realf(str,float,n=4)
DEF neg=FALSE, s ,p=10000.
s:='\s\d.\z\d[4]'
IF (n>7) OR (n<0) THEN n:=4
IF n<>4
  PutChar(s+8,n+48)
  PutChar(s+10,n+48)
  p:=[1., 10., 100., 1000., 10000., 100000., 1000000., 10000000.]
  p:=Long(Shl(n,2)+p)
ENDIF
IF float<0
  BCLR #31,float     /* converts ieeesp format into positive  */
  neg:=TRUE
ENDIF
   StringF(str,s,IF neg THEN '-' ELSE '',
	  (!float!),!float-(!float!!)*p!)
ENDPROC str
