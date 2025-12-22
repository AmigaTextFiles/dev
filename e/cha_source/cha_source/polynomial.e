/*==========================================================================+
| polynomial.e                                                              |
| polynomials of complex numbers                                            |
| NB: OBJECT polynomial allows up to 256 poles/zeros in filters             |
+--------------------------------------------------------------------------*/

OPT MODULE

MODULE '*complex'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT polynomial
	power    : LONG
	c[257]   : ARRAY OF complex
ENDOBJECT

/*-------------------------------------------------------------------------*/

-> constructors (note - these do not depend on the object being cleared, so
-> the same allocated object can be reused, for efficiency)

-> empty polynomial
PROC polynomial() OF polynomial
	DEF i : LONG, c : PTR TO complex
	self.power := 0
	c := self.c
	ccopy([1.0,0.0]:complex, c++)
	FOR i := 1 TO 256 DO ccopy([0.0,0.0]:complex,c++) -> NB: to length-1
ENDPROC

-> made up of zeros
PROC expand(zeros : LONG, zeroarray : PTR TO complex) OF polynomial
	DEF i : LONG
	self.polynomial()
	FOR i := 1 TO zeros DO self.addzero(zeroarray++)
ENDPROC

/*-------------------------------------------------------------------------*/

-> add a zero at z=w (multiply by (z-w))

PROC addzero(w : PTR TO complex) OF polynomial
	DEF t : complex, i : LONG, c : PTR TO complex
	c := self.c
	FOR i := self.power + 1 TO 1 STEP -1 DO csub(c[i-1],cmul(w,c[i],t),c[i])
	cmul(cneg(w,t),c[0],c[0])
	self.power := self.power + 1
ENDPROC

-> evaluate polynomial at z=w; to can be same as w

PROC evaluate(w : PTR TO complex, to : PTR TO complex) OF polynomial
	DEF c : PTR TO complex, ww : complex, i : LONG
	-> sum(c[n] z^n) = (c[n] z + c[n-1]) z +... + c[0]
	c := self.c
	ccopy(w,ww)
	ccopy(c[self.power], to)
	FOR i := self.power TO 1 STEP -1 DO cadd(cmul(to,ww,to),c[i-1],to)
ENDPROC to

/*-------------------------------------------------------------------------*/

-> destructor

PROC end() OF polynomial IS EMPTY

/*--------------------------------------------------------------------------+
| END: polynomial.e                                                         |
+==========================================================================*/
