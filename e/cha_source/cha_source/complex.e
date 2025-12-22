/*==========================================================================+
| complex.e                                                                 |
| complex number functions                                                  |
| NB: all functions allow input(s) and output to be the same object         |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

#define PI 3.14159265
#define FLOAT LONG

/*-------------------------------------------------------------------------*/

EXPORT OBJECT complex
PUBLIC
	re : FLOAT
	im : FLOAT
ENDOBJECT

EXPORT PROC ccopy(a : PTR TO complex, to : PTR TO complex)
	to.re := a.re
	to.im := a.im
ENDPROC to

EXPORT PROC cadd(a : PTR TO complex, b : PTR TO complex, to : PTR TO complex)
	to.re := ! a.re + b.re
	to.im := ! a.im + b.im
ENDPROC to

EXPORT PROC csub(a : PTR TO complex, b : PTR TO complex, to : PTR TO complex)
	to.re := ! a.re - b.re
	to.im := ! a.im - b.im
ENDPROC to

EXPORT PROC cneg(a : PTR TO complex, to : PTR TO complex)
	to.re := ! -a.re
	to.im := ! -a.im
ENDPROC to

EXPORT PROC cmul(a : PTR TO complex, b : PTR TO complex, to : PTR TO complex)
	DEF t : FLOAT
	t     := ! (! a.re * b.re) - (! a.im * b.im)
	to.im := ! (! a.re * b.im) + (! a.im * b.re)
	to.re := t
ENDPROC to

EXPORT PROC cdiv(a : PTR TO complex, b : PTR TO complex, to : PTR TO complex)
	DEF t : complex
	cconj(b, t)
	cmul(a, t, t)
	csmul(! 1.0 / cabs2(b), t, to)
ENDPROC to

EXPORT PROC csmul(a : FLOAT, b : PTR TO complex, to : PTR TO complex)
	to.re := ! a * b.re
	to.im := ! a * b.im
ENDPROC to

EXPORT PROC csdiv(a : FLOAT, b : PTR TO complex, to : PTR TO complex)
	DEF r2 : FLOAT
	r2 := cabs2(b)
	to.re := !  a * b.re / r2
	to.im := ! -a * b.im / r2
ENDPROC to

EXPORT PROC cconj(a : PTR TO complex, to : PTR TO complex)
	to.re := !  a.re
	to.im := ! -a.im
ENDPROC to

EXPORT PROC cexp(a : PTR TO complex, to : PTR TO complex)
	DEF r : FLOAT
	r := Fexp(a.re)
	to.re := ! r * Fcos(a.im)
	to.im := ! r * Fsin(a.im)
ENDPROC to

EXPORT PROC cexpj(a : FLOAT, to : PTR TO complex)
	to.re := Fcos(a)
	to.im := Fsin(a)
ENDPROC to

EXPORT PROC cabs2(a : PTR TO complex) IS ! (! a.re * a.re) + (! a.im * a.im)
EXPORT PROC cabs(a : PTR TO complex) IS Fsqrt(cabs2(a))
EXPORT PROC carg(a : PTR TO complex) IS fatan2(a.im, a.re)

EXPORT PROC ceq(a : PTR TO complex, b : PTR TO complex) IS (! a.re = b.re) AND (! a.im = b.im)

EXPORT PROC csqrt(a : PTR TO complex, to : PTR TO complex)
	DEF r : FLOAT, neg, t
	neg := (! a.im < 0)
	r := cabs(a)
	t     := Fsqrt(! 0.5 * (! r + a.re))
	to.im := Fsqrt(! 0.5 * (! r - a.re))
	to.re := t
	IF neg THEN to.im := ! -to.im
ENDPROC to

/*-------------------------------------------------------------------------*/

EXPORT PROC fatan2(y : FLOAT, x : FLOAT)
	IF y = 0
		RETURN 0
	ELSEIF x = 0
		RETURN IF y > 0 THEN !PI/2.0 ELSE !-PI/2.0
	ELSEIF x > 0
		RETURN Fatan(!y/x)
	ELSEIF y > 0
		RETURN ! Fatan(!-x/y) + (! PI / 2.0)
	ELSE
		RETURN ! Fatan(!-x/y) - (! PI / 2.0)
	ENDIF
ENDPROC

EXPORT PROC fasinh(x : FLOAT) IS Flog(! x + Fsqrt(! 1.0 + (! x * x)))

/*--------------------------------------------------------------------------+
| END: complex.e                                                            |
+==========================================================================*/
