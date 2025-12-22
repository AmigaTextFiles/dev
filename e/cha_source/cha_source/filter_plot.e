/*==========================================================================+
| filter_plot.e                                                             |
| various filters for OctaMED SoundStudio                                   |
|                                                                           |
| various graphs, implemented as EasyGUI plugins                            |
|                                                                           |
| Based on mkfilter/mkshape/genplot:                                        |
|   A. J. Fisher                                                            |
|   fisher@minster.york.ac.uk                                               |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37, PREPROCESS
OPT MODULE

MODULE '*filter_splane', '*filter_zplane', '*complex',
       'tools/easygui', 'intuition/intuition'

RAISE "^C" IF CtrlC() = TRUE

#define PI 3.14159265

/*-------------------------------------------------------------------------*/

EXPORT OBJECT drawplane OF plugin
PRIVATE
	poles : LONG
	zeros : LONG
	pole  : PTR TO complex
	zero  : PTR TO complex
	isz   : LONG    -> used in drawaxes()
	minx  : LONG    -> used in real(x|y)()
	miny  : LONG
	w     : LONG
	h     : LONG
	dx    : LONG    -> used in render()
	dy    : LONG
ENDOBJECT

PROC drawsplane(s : PTR TO splane) OF drawplane
	DEF i, minx = 2000000.0, miny = 2000000.0,
	    maxx = -2000000.0, maxy = -2000000.0
	self.isz := FALSE
	self.poles := s.poles
	self.zeros := s.zeros
	self.pole  := s.pole
	self.zero  := s.zero
	FOR i := 0 TO s.zeros-1
		IF ! s.zero[i].re > maxx THEN maxx := s.zero[i].re
		IF ! s.zero[i].re < minx THEN minx := s.zero[i].re
		IF ! s.zero[i].im > maxy THEN maxy := s.zero[i].im
		IF ! s.zero[i].im < miny THEN miny := s.zero[i].im
	ENDFOR
	FOR i := 0 TO s.poles-1
		IF ! s.pole[i].re > maxx THEN maxx := s.pole[i].re
		IF ! s.pole[i].re < minx THEN minx := s.pole[i].re
		IF ! s.pole[i].im > maxy THEN maxy := s.pole[i].im
		IF ! s.pole[i].im < miny THEN miny := s.pole[i].im
	ENDFOR
	self.minx := ! minx * 2.0
	self.miny := ! miny * 2.0
	self.w := ! maxx * 2.0 - self.minx
	self.h := ! maxy * 2.0 - self.miny
ENDPROC

PROC drawzplane(z : PTR TO zplane) OF drawplane
	self.isz := TRUE
	self.poles := z.poles
	self.zeros := z.zeros
	self.pole  := z.pole
	self.zero  := z.zero
	self.minx := ! -1.2
	self.miny := ! -1.2
	self.w := ! 2.4
	self.h := ! 2.4
ENDPROC

PROC min_size(unref1,unref2) OF drawplane IS 150,75

PROC render(unref3, unref4, unref5, unref6, unref7, win : PTR TO window) OF drawplane HANDLE
	DEF i, rp
	self.dx := self.realx(0.1) - self.realx(0.0)
	self.dy := self.realy(0.1) - self.realy(0.0)
	rp := win.rport
	SetAPen(rp,1)
	self.drawaxes(rp)
	FOR i := 0 TO self.zeros-1 DO self.drawzero(rp, self.zero[i])
	FOR i := 0 TO self.poles-1 DO self.drawpole(rp, self.pole[i])
EXCEPT
ENDPROC

PROC drawaxes(rp) OF drawplane
	DEF rx0, ry0
	rx0 := self.realx(0.0)
	ry0 := self.realy(0.0)
	Move(rp, rx0, self.y)
	Draw(rp, rx0, self.y + self.ys)
	Move(rp, self.x,           ry0)
	Draw(rp, self.x + self.xs, ry0)
	IF self.isz THEN DrawEllipse(rp, rx0, ry0, self.realx(1.0) - rx0, self.realy(1.0) - ry0)
ENDPROC

PROC drawzero(rp, z : PTR TO complex) OF drawplane
	DEF rx, ry
	rx := self.realx(z.re)
	ry := self.realy(z.im)
	DrawEllipse(rp, rx, ry, self.dx, self.dy)
ENDPROC

PROC drawpole(rp, z : PTR TO complex) OF drawplane
	DEF rx, ry
	rx := self.realx(z.re)
	ry := self.realy(z.im)
	Move(rp, rx + self.dx, ry + self.dy)
	Draw(rp, rx - self.dx, ry - self.dy)
	Move(rp, rx + self.dx, ry - self.dy)
	Draw(rp, rx - self.dx, ry + self.dy)
ENDPROC

PROC realx(x) OF drawplane IS Bounds(self.x +           (self.xs ! * (! x - self.minx) / self.w !), self.x, self.x + self.xs)
PROC realy(y) OF drawplane IS Bounds(self.y + self.ys - (self.ys ! * (! y - self.miny) / self.h !), self.y, self.y + self.ys)

/*-------------------------------------------------------------------------*/

EXPORT OBJECT drawfreq OF plugin
PRIVATE
	isz
	z    : PTR TO zplane
	flog
	fmin
	fmax
	vlog
	vmin
	vmax
	f0
	f1
	v0
	v1
	fa
	fb
	va
	vb
ENDOBJECT

#define F0_0 $00000000
#define F0_5 $3F000000
#define F1_0 $3F800000
#define F2_0 $40000000
#define F4_0 $40800000

PROC min_size(unref1,unref2) OF drawfreq IS 150,75

PROC drawzfreq(zplane : PTR TO zplane,
               f0 = F0_0, f1 = F0_0, v0 = F1_0, v1 = F0_5,
               flog = TRUE, fmin = F0_0, fmax = F0_5,
               vlog = TRUE, vmin = F0_0, vmax = F4_0) OF drawfreq
	self.isz  := TRUE
	self.z    := zplane
	IF ! fmin <= 0.0 THEN fmin := (IF flog THEN ! fmax / 1000.0 ELSE 0.0)
	IF ! vmin <= 0.0 THEN vmin := (IF vlog THEN ! vmax / 1000.0 ELSE 0.0)
	IF ! fmax >= 0.5 THEN fmax := 0.5
	self.flog := flog
	self.fmin := fmin
	self.fmax := fmax
	self.vlog := vlog
	self.vmin := vmin
	self.vmax := vmax
	self.f0   := f0
	self.f1   := f1
	self.v0   := v0
	self.v1   := v1
ENDPROC

PROC render(unref3, unref4, unref5, unref6, unref7, win : PTR TO window) OF drawfreq HANDLE

	DEF x, rp

	IF self.flog
		self.fa := self.fmin
		self.fb := ! Flog(! self.fmax / self.fmin) / (self.xs - 1 !)
	ELSE
		self.fa := self.fmin
		self.fb := !     (! self.fmax - self.fmin) / (self.xs - 1 !)
	ENDIF

	IF self.vlog
		self.va := self.vmin
		self.vb := ! Flog(! self.vmax / self.vmin) / (self.ys - 1 !)
	ELSE
		self.va := self.vmin
		self.vb := !     (! self.vmax - self.vmin) / (self.ys - 1 !)
	ENDIF

	rp := win.rport

	SetAPen(rp, 2)
	IF self.f0
		Move(rp, self.gadx(self.f2x(self.f0)), self.gady(0))
		Draw(rp, self.gadx(self.f2x(self.f0)), self.gady(self.ys - 1))
	ENDIF
	IF self.f1
		Move(rp, self.gadx(self.f2x(self.f1)), self.gady(0))
		Draw(rp, self.gadx(self.f2x(self.f1)), self.gady(self.ys - 1))
	ENDIF
	IF self.v0
		Move(rp, self.gadx(0),           self.gady(self.v2y(self.v0)))
		Draw(rp, self.gadx(self.xs - 1), self.gady(self.v2y(self.v0)))
	ENDIF
	IF self.v1
		Move(rp, self.gadx(0),           self.gady(self.v2y(self.v1)))
		Draw(rp, self.gadx(self.xs - 1), self.gady(self.v2y(self.v1)))
	ENDIF

	SetAPen(rp, 1)
	Move(rp,self.gadx(0),self.gady(self.v2y(self.evaluatea(self.x2f(0)))))
	FOR x := 0 TO self.xs - 1
		CtrlC()
		Draw(rp,self.gadx(x),self.gady(self.v2y(self.evaluatea(self.x2f(x)))))
	ENDFOR

	SetAPen(rp, 3)
	Move(rp,self.gadx(0),self.gady(self.p2y(self.evaluatep(self.x2f(0)))))
	FOR x := 0 TO self.xs - 1
		CtrlC()
		Draw(rp,self.gadx(x),self.gady(self.p2y(self.evaluatep(self.x2f(x)))))
	ENDFOR

EXCEPT
ENDPROC

PROC x2f(x) OF drawfreq
	IF self.flog
		RETURN ! self.fa * Fexp(x ! * self.fb)
	ELSE
		RETURN ! self.fa +     (x ! * self.fb)
	ENDIF
ENDPROC

PROC y2v(y) OF drawfreq
	IF self.vlog
		RETURN ! self.va * Fexp(y ! * self.vb)
	ELSE
		RETURN ! self.va +     (y ! * self.vb)
	ENDIF
ENDPROC

PROC f2x(f) OF drawfreq
	IF self.flog
		RETURN ! Flog(! f / self.fa) / self.fb !
	ELSE
		RETURN !     (! f - self.fa) / self.fb !
	ENDIF
ENDPROC

PROC v2y(v) OF drawfreq
	IF self.vlog
		RETURN ! Flog(! v / self.va) / self.vb !
	ELSE
		RETURN !     (! v - self.va) / self.vb !
	ENDIF
ENDPROC

PROC p2y(p) OF drawfreq IS self.ys ! * (! p + PI) / (! 2.0 * PI) !

PROC gadx(x) OF drawfreq IS Bounds(self.x +           x, self.x, self.x + self.xs - 1)
PROC gady(y) OF drawfreq IS Bounds(self.y + self.ys - y, self.y, self.y + self.ys - 1)

PROC evaluatea(f) OF drawfreq
	DEF a
	IF self.isz
		a := ! self.z.gain (! 2.0 * PI * f) / self.z.fgain
	ELSE
		Throw("bug", 'drawfreq.evaluate')
	ENDIF
ENDPROC a

PROC evaluatep(f) OF drawfreq
	DEF p
	IF self.isz
		p := self.z.phase(! 2.0 * PI * f)
	ELSE
		Throw("bug", 'drawfreq.evaluate')
	ENDIF
ENDPROC p

/*--------------------------------------------------------------------------+
| END: filter_plot.e                                                        |
+==========================================================================*/
