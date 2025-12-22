/*==========================================================================+
| filter_splane.e                                                           |
| various filters for OctaMED SoundStudio                                   |
|                                                                           |
| s-plane filter design                                                     |
|                                                                           |
| Based on mkfilter/mkshape/genplot:                                        |
|   A. J. Fisher                                                            |
|   fisher@minster.york.ac.uk                                               |
+--------------------------------------------------------------------------*/

OPT MODULE, PREPROCESS, OSVERSION=37

MODULE '*complex', '*debug', '*filter_specification'

#define PI 3.14159265
#define FLOAT LONG
#define C1 [1.0,0.0]:complex

/*-------------------------------------------------------------------------*/

EXPORT OBJECT splane
	spec      : PTR TO filterspecification
	zeros     : LONG
	poles     : LONG
	zero[256] : ARRAY OF complex
	pole[256] : ARRAY OF complex
ENDOBJECT

/*-------------------------------------------------------------------------*/

-> constructors

PROC bessel(spec : PTR TO filterspecification, order : LONG) OF splane
	DEF i, pole : PTR TO complex, bpole : PTR TO complex
	IF order > 10 THEN Throw("args", 'BESSEL needs ORDER <= 10')
	bpole := [  -> mkfilter.c has original (float64) table
				-1.00000000, 0.00000000, -1.10160133, 0.63600982,
				-1.32267580, 0.00000000, -1.04740916, 0.99926444,
				-1.37006783, 0.41024972, -0.99520876, 1.25710574,
				-1.50231627, 0.00000000, -1.38087733, 0.71790959,
				-0.95767655, 1.47112432, -1.57149040, 0.32089637,
				-1.38185810, 0.97147189, -0.93065652, 1.66186327,
				-1.68436818, 0.00000000, -1.61203877, 0.58924451,
				-1.37890322, 1.19156678, -0.90986778, 1.83645135,
				-1.75740840, 0.27286758, -1.63693942, 0.82279563,
				-1.37384122, 1.38835658, -0.89286972, 1.99832584,
				-1.85660050, 0.00000000, -1.80717053, 0.51238373,
				-1.65239648, 1.03138957, -1.36758831, 1.56773371,
				-0.87839928, 2.14980052, -1.92761969, 0.24162347,
				-1.84219624, 0.72725760, -1.66181024, 1.22110022,
				-1.36069228, 1.73350574, -0.86575690, 2.29260483
			]
	self.spec := spec
	self.zeros := 0
	self.poles := order
	pole := self.pole
	bpole := bpole + (((order * order) / 4) * SIZEOF complex)
	IF order AND 1
		ccopy(bpole++, pole++)
	ENDIF
	FOR i := 0 TO order/2
		ccopy(bpole,   pole++)
		cconj(bpole++, pole++)
	ENDFOR
ENDPROC

PROC butterworth(spec : PTR TO filterspecification, order : LONG) OF splane
	DEF i : LONG, polecount : LONG, forder : FLOAT, pole : PTR TO complex
	self.spec := spec
	self.zeros := 0
	self.poles := order
	polecount := Shl(self.poles, 1) - 1
	forder := order !
	pole := self.pole
	FOR i := 0 TO polecount
        ->                      \/ odd   \/ even
		cexpj(! (IF order AND 1 THEN i ! ELSE i ! + 0.5) * PI / forder, pole)
		IF ! pole.re < 0.0 THEN pole++
	ENDFOR
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Butterworth\n')
WriteF('+   order = \d\n', order)
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
ENDPROC

PROC chebyshev(spec : PTR TO filterspecification, order : LONG, ripple : FLOAT) OF splane
	DEF factor : FLOAT, sinh : FLOAT, cosh : FLOAT, i : LONG,
	    polecount : LONG, pole : PTR TO complex, rip, eps
	self.butterworth(spec, order)
	rip := Fpow(! ripple / -10.0, 10.0)         -> NB: Fpow(a,b) = b^a
	eps := Fsqrt(! rip - 1.0)
	factor := ! fasinh(! 1.0 / eps) / (order !) -> NB: factor must be > 0
	sinh := fsinh(factor)                       -> Fsinh() crashes ?
	cosh := fcosh(factor)
	polecount := self.poles - 1
	pole := self.pole
	FOR i := 0 TO polecount
		pole.re := ! pole.re * sinh
		pole.im := ! pole.im * cosh
		pole++
	ENDFOR
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Chebyshev\n')
WriteF('+   order  = \d\n', order)
WriteF('+   ripple = \s\n', float2string(ripple))
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

-> modifiers (call on constructed; w is prewarped -> 0..PI)

PROC lowpass(w : FLOAT) OF splane
	DEF i : LONG, polecount : LONG, pole : PTR TO complex
	polecount := self.poles - 1
	pole := self.pole
	FOR i := 0 TO polecount DO csmul(w,pole,pole++)
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Lowpass\n')
WriteF('+   w      = \s\n', float2string(w))
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

PROC highpass(w : FLOAT) OF splane
	DEF i : LONG, polecount : LONG, pole : PTR TO complex->, r2 : FLOAT
	polecount := self.poles - 1
	pole := self.pole
	FOR i := 0 TO polecount DO csdiv(w,pole,pole++)
	self.zeros := self.poles -> at 0+0i
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Highpass\n')
WriteF('+   w      = \s\n', float2string(w))
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

PROC bandpass(w1,w2) OF splane
	DEF w0 : FLOAT, bw : FLOAT, i : LONG, polecount : LONG, pole0 : PTR TO complex,
	    pole1 : PTR TO complex, hba : complex, temp : complex->, r2 : FLOAT
	w0 := Fsqrt(! w1 * w2)
	bw := ! w2 - w1
	pole0 := self.pole
	pole1 := pole0 + (self.poles*SIZEOF complex)
	polecount := self.poles-1
	FOR i := 0 TO polecount
		csmul(!bw*0.5,pole0,hba)            -> hba = bw * pole[i] / 2
		csdiv(w0,hba,temp)                  -> temp = sqrt(1 - (w0/hba)^2)
		cmul(temp,temp,temp)
		csub(C1,temp,temp)
		csqrt(temp, temp)
		cmul(hba,cadd(C1,temp,pole0),pole0) -> pole[i]   = hba * (1 + temp)
		cmul(hba,csub(C1,temp,pole1),pole1) -> pole[i+n] = hba * (1 - temp)
		pole0++
		pole1++
	ENDFOR
	self.zeros := self.poles        -> at 0+0i
	self.poles := Shl(self.poles,1) -> poles *:= 2
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Bandpass\n')
WriteF('+   w1     = \s\n', float2string(w1))
WriteF('+   w2     = \s\n', float2string(w2))
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

PROC bandstop(w1,w2) OF splane
	DEF w0 : FLOAT, bw : FLOAT, i : LONG, polecount : LONG, pole0 : PTR TO complex,
	    pole1 : PTR TO complex, hba : complex, temp : complex,
	    zero0 : PTR TO complex, zero1 : PTR TO complex
	w0 := Fsqrt(! w1 * w2)
	bw := ! w2 - w1
	pole0 := self.pole
	pole1 := pole0 + (self.poles*SIZEOF complex)
	zero0 := self.zero
	zero1 := zero0 + (self.poles*SIZEOF complex)
	polecount := self.poles-1
	FOR i := 0 TO polecount
		csdiv(!bw*0.5,pole0,hba)            -> hba = bw / pole[i] / 2
		csdiv(w0,hba,temp)                  -> temp = sqrt(1 - (w0/hba)^2)
		cmul(temp,temp,temp)
		csub(C1,temp,temp)
		csqrt(temp, temp)
		cmul(hba,cadd(C1,temp,pole0),pole0) -> pole[i]   = hba * (1 + temp)
		cmul(hba,csub(C1,temp,pole1),pole1) -> pole[i+n] = hba * (1 - temp)
		zero0.im := !  w0
		zero1.im := ! -w0
		pole0++
		pole1++
		zero0++
		zero1++
	ENDFOR
	self.poles := Shl(self.poles,1) -> poles *:= 2
	self.zeros := self.poles
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Bandstop\n')
WriteF('+   w1     = \s\n', float2string(w1))
WriteF('+   w2     = \s\n', float2string(w2))
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

PROC end() OF splane IS EMPTY

/*-------------------------------------------------------------------------*/

-> prewarp frequencies; input freq, rate; output is normalised w : 0..PI

EXPORT PROC prebilinear(f : FLOAT, r : FLOAT) IS ! 2.0 * Ftan(! PI * f / r)

EXPORT PROC prematchedz(f : FLOAT, r : FLOAT) IS ! 2.0 * PI * f / r

/*-------------------------------------------------------------------------*/

PROC fsinh(x) IS ! Fexp(x) - Fexp(! -x) / 2.0
PROC fcosh(x) IS ! Fexp(x) + Fexp(! -x) / 2.0

/*--------------------------------------------------------------------------+
| END: filter_splane.e                                                      |
+==========================================================================*/
