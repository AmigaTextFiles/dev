
	.global	_vecmuladd
_vecmuladd:
	tst	%o3
	ble	Lvma1
	mov	0, %g5		! carry
Lvma2:
	mov	%o2, %y
	andcc	%g0, %g0, %g3
	ld	[%o1], %g2	! *a
	ld	[%o0], %g4	! *paccu

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3
	mulscc	%g3, %g2, %g3

	mulscc	%g3, %g0, %g3		! 33rd iteration, prod high

	tst	%g2			! sign correction
	bge	Lvma3
	rd	%y, %g2			! prod low
	add	%g3, %o2, %g3		! sign correction
Lvma3:
	addcc	%g5, %g4, %g4		! carry + *paccu
	addx	%g0,%g0,%g5		! new carry
	addcc	%g2, %g4, %g2		! result low
	addx	%g3, %g5, %g5		! result high
	st	%g2, [%o0]		! *paccu
	inc	4, %o1			! a++
	subcc	%o3, 1, %o3		! count--
	bg	Lvma2			! loop
	inc	4, %o0
Lvma1:
	retl
	mov	%g5, %o0		! return carry


