/*==========================================================================+
| filter_zplane.e                                                           |
| various filters for OctaMED SoundStudio                                   |
|                                                                           |
| z-plane filter design and conversion from s-plane                         |
|                                                                           |
| NB: "frequency" is 0 .. PI                                                |
|                                                                           |
| Based on mkfilter/mkshape/genplot:                                        |
|   A. J. Fisher                                                            |
|   fisher@minster.york.ac.uk                                               |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

MODULE '*filter_design', '*filter_splane', '*filter_specification',
       '*complex', '*polynomial', '*debug'

#define PI  3.14159265
#define EPS 0.00000001
#define C2 [2.0,0.0]:complex

/*-------------------------------------------------------------------------*/

EXPORT OBJECT zplane OF filterdesign
	spec      : PTR TO filterspecification
	fgain     : LONG
	zeros     : LONG
	poles     : LONG
	zero[256] : ARRAY OF complex
	pole[256] : ARRAY OF complex
PRIVATE
	top    : PTR TO polynomial
	bottom : PTR TO polynomial
ENDOBJECT

/*-------------------------------------------------------------------------*/

-> constructors

PROC bilinear(splane : PTR TO splane) OF zplane
	DEF i : LONG, pz0 : PTR TO complex, pz1 : PTR TO complex, pzcount : LONG
	self.filterdesign()
	self.spec := splane.spec
	pz0 := splane.pole
	pz1 := self.pole
	pzcount := splane.poles-1
	FOR i := 0 TO pzcount DO blt(pz0++,pz1++)
	pz0 := splane.zero
	pz1 := self.zero
	pzcount := splane.zeros-1
	FOR i := 0 TO pzcount DO blt(pz0++,pz1++)
	pzcount := splane.poles - splane.zeros - 1
	FOR i := 0 TO pzcount
		pz1.re := -1.0
		pz1++
	ENDFOR
	self.poles := splane.poles
	self.zeros := splane.poles
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Bilinear\n')
WriteF('+   zeros  = \d\n', self.zeros)
FOR i := 0 TO self.zeros - 1
WriteF('+       \s\n', complex2string(self.zero[i]))
ENDFOR
WriteF('+   poles  = \d\n', self.poles)
FOR i := 0 TO self.poles - 1
WriteF('+       \s\n', complex2string(self.pole[i]))
ENDFOR
WriteF('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
#endif
ENDPROC

PROC blt(pz : PTR TO complex, to : PTR TO complex)
	DEF t1 : complex, t2 : complex
ENDPROC cdiv(cadd(C2,pz,t1),csub(C2,pz,t2),to)

PROC matchedz(splane : PTR TO splane) OF zplane
	DEF i : LONG, pz0 : PTR TO complex, pz1 : PTR TO complex, pzcount : LONG
	self.filterdesign()
	self.spec := splane.spec
	pz0 := splane.pole
	pz1 := self.pole
	pzcount := splane.poles-1
	FOR i := 0 TO pzcount DO cexp(pz0++,pz1++)
	pz0 := splane.zero
	pz1 := self.zero
	pzcount := splane.zeros-1
	FOR i := 0 TO pzcount DO cexp(pz0++,pz1++)
	self.poles := splane.poles
	self.zeros := splane.zeros
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Matched Z\n')
WriteF('+   zeros  = \d\n', self.zeros)
FOR i := 0 TO self.zeros - 1
WriteF('+       \s\n', complex2string(self.zero[i]))
ENDFOR
WriteF('+   poles  = \d\n', self.poles)
FOR i := 0 TO self.poles - 1
WriteF('+       \s\n', complex2string(self.pole[i]))
ENDFOR
WriteF('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
#endif
ENDPROC

PROC bandpass(spec, frequency, qfactor) OF zplane HANDLE
	DEF top    = NIL : PTR TO polynomial,
	    bottom = NIL : PTR TO polynomial,
	    theta, r, thm, th1, th2, cvg, phi, i,
	    w : complex, t : complex, b : complex
	self.spec := spec
	NEW top.polynomial()
	NEW bottom.polynomial()
	self.poles := 2
	self.zeros := 2
	self.zero[0].re :=  1.0
	self.zero[1].re := -1.0
	theta := frequency
	r := Fexp(! theta / (! -2.0 * qfactor))
	thm := theta
	th1 := 0.0
	th2 := PI
	cvg := FALSE
	FOR i := 1 TO 50
	EXIT cvg
		cexpj(thm, t)               -> t = r * expj(thm)
		csmul(r, t, t)
		ccopy(t, self.pole[0])      -> pole[0] = t
		cconj(t, self.pole[1])      -> pole[1] = conj(t)
		bottom.expand(self.poles, self.pole)
		cexpj(theta, w)             -> w = expj(theta)
		top.evaluate(w, t)
		bottom.evaluate(w, b)
		cdiv(t, b, w)               -> gain = top(w) / bottom(w)
		phi := ! w.im / w.re        -> approx to arg(gain)
		IF ! phi > 0.0 THEN th2 := thm ELSE th1 := thm
		thm := ! th1 + th2 * 0.5
		IF ! Fabs(phi) < EPS THEN cvg := TRUE
	ENDFOR
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Bandpass Resonator\n')
WriteF('+   frequency = \s\n', float2string(frequency))
WriteF('+   qfactor   = \s\n', float2string(qfactor))
WriteF('+   zeros = \d\n', self.zeros)
FOR i := 0 TO self.zeros - 1
WriteF('+       \s\n', complex2string(self.zero[i]))
ENDFOR
WriteF('+   poles = \d\n', self.poles)
FOR i := 0 TO self.poles - 1
WriteF('+       \s\n', complex2string(self.pole[i]))
ENDFOR
WriteF('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
#endif
	IF cvg = FALSE THEN Throw("zres", 'resonator generation failed')
EXCEPT DO
	END bottom
	END top
ENDPROC

PROC allpass(spec, frequency, qfactor) OF zplane
#ifdef DEBUG
	DEF i
#endif
	self.bandpass(spec, frequency, qfactor)
	reflect(self.pole[0], self.zero[0])
	reflect(self.pole[1], self.zero[1])
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Allpass\n')
WriteF('+   zeros  = \d\n', self.zeros)
FOR i := 0 TO self.zeros - 1
WriteF('+       \s\n', complex2string(self.zero[i]))
ENDFOR
WriteF('+   poles  = \d\n', self.poles)
FOR i := 0 TO self.poles - 1
WriteF('+       \s\n', complex2string(self.pole[i]))
ENDFOR
WriteF('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
#endif
ENDPROC

PROC reflect(pz : PTR TO complex, to : PTR TO complex) IS csmul(! 1.0 / cabs2(pz), pz, to)

PROC notch(spec, frequency, qfactor) OF zplane
#ifdef DEBUG
	DEF i
#endif
	self.bandpass(spec, frequency, qfactor)
	cexpj(frequency, self.zero[0])
	cconj(self.zero[0], self.zero[1])
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Notch\n')
WriteF('+   zeros  = \d\n', self.zeros)
FOR i := 0 TO self.zeros - 1
WriteF('+       \s\n', complex2string(self.zero[i]))
ENDFOR
WriteF('+   poles  = \d\n', self.poles)
FOR i := 0 TO self.poles - 1
WriteF('+       \s\n', complex2string(self.pole[i]))
ENDFOR
WriteF('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
#endif
ENDPROC

/*-------------------------------------------------------------------------*/

-> destructor

PROC end() OF zplane IS EMPTY

/*-------------------------------------------------------------------------*/

-> filter stuff

PROC compile() OF zplane
	DEF shape, f
	IF self.top    = NIL THEN NEW self.top
	IF self.bottom = NIL THEN NEW self.bottom
	self.top   .expand(self.zeros, self.zero)
	self.bottom.expand(self.poles, self.pole)
	shape := self.spec.shape
	SELECT 7 OF shape
	CASE FILTERSHAPE_LOWPASS
		self.fgain := self.gain(0.0)
	CASE FILTERSHAPE_HIGHPASS
		self.fgain := self.gain(PI)
	CASE FILTERSHAPE_BANDPASS,
	     FILTERSHAPE_ALLPASS
		IF self.spec.type <> FILTERTYPE_RESONATOR
			f := ! PI * (! self.spec.lfreq + self.spec.hfreq) / self.spec.rate
		ELSE
			f := ! 2.0 * PI * self.spec.freq / self.spec.rate
		ENDIF
		self.fgain := self.gain(f)
	CASE FILTERSHAPE_BANDSTOP,
	     FILTERSHAPE_NOTCH
		self.fgain := Fsqrt(! self.gain(0) * self.gain(PI))
	DEFAULT
		Throw("bug", 'zplane.compile.shape')
	ENDSELECT
ENDPROC

PROC cgain(w, z : PTR TO complex) OF zplane
	DEF t : complex
	cexpj(w, t)
ENDPROC cdiv(self.top.evaluate(t, z), self.bottom.evaluate(t, t), z)

PROC gain(w)  OF zplane
	DEF z : complex
ENDPROC cabs(self.cgain(w, z))

PROC phase(w) OF zplane
	DEF z : complex
ENDPROC carg(self.cgain(w, z))

PROC m()  OF zplane IS self.zeros
PROC n()  OF zplane IS self.poles
PROC a(i) OF zplane IS !  self.top   .c[self.zeros-i].re / self.bottom.c[self.poles].re / self.fgain
PROC b(i) OF zplane IS ! -self.bottom.c[self.poles-i].re / self.bottom.c[self.poles].re

EXPORT PROC preresonator(f, r) IS ! 2.0 * PI * f / r

/*--------------------------------------------------------------------------+
| END: filter_zplane.e                                                      |
+==========================================================================*/
