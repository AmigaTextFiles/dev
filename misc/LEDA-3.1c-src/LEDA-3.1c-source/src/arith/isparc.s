	.seg	"text"			! [internal]

	.global	_PLACEadd
_PLACEadd:
	addcc	%o0,%o1,%o1
	addx	%g0, %g0, %o0
	addcc	%o1,%o2,%o1
	addx	%o0, %g0, %o0
	retl
	st	%o1,[%o3]

	.global	_PLACEsub
_PLACEsub:
	subcc	%o0,%o1,%o1
	addx	%g0, %g0, %o0
	subcc	%o1,%o2,%o1
	addx	%o0, %g0, %o0
	retl
	st	%o1,[%o3]

	.global	_PLACEmuladd
_PLACEmuladd:
	mov	%o0, %y
	ld      [%o3],%o5		! *paccu
	andcc	%g0, %g0, %o4		! reset N and V
	nop
	mulscc	%o4, %o1, %o4	! first iteration of 33
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %g0, %o4

	tst	%o1			! sign correction
	bge	Lpma1
	nop
	add	%o4, %o0, %o4		! sign correction
Lpma1:
	rd	%y, %o0			! prod (low)

	addcc	%o5, %o2, %o2		! carry + *paccu
	addx	%g0,%g0,%o5
	addcc	%o0, %o2, %o1		! prod + ...
	addx	%o4, %o5, %o0
	retl
	st      %o1,[%o3]

	.global	_PLACEmul
_PLACEmul:
	mov	%o0, %y
	andcc	%g0, %g0, %o4		! reset N and V
	nop
	nop
	mulscc	%o4, %o1, %o4	! first iteration of 33
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %g0, %o4

	tst	%o1			! sign correction
	bge	Lpm1
	nop
	add	%o4, %o0, %o4		! sign correction
Lpm1:
	rd	%y, %o0			! prod (low)

	addcc	%o0, %o2, %o1		! prod + carry
	addx	%o4, %g0, %o0
	retl
	st      %o1,[%o3]

	.global	_PLACEmulsub
_PLACEmulsub:
	mov	%o0, %y
	ld      [%o3],%o5		! *paccu
	andcc	%g0, %g0, %o4		! reset N and V
	nop
	mulscc	%o4, %o1, %o4	! first iteration of 33
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4
	mulscc	%o4, %o1, %o4

	mulscc	%o4, %g0, %o4

	tst	%o1			! sign correction
	bge	Lpms1
	nop
	add	%o4, %o0, %o4		! sign correction
Lpms1:
	rd	%y, %o0			! prod (low)

	addcc	%o0, %o2, %o2		! carry + prod (low)
	addx	%o4,%g0,%o0		! (high)
	subcc	%o5, %o2, %o1		! *paccu -  ...
	addx	%o0, %g0, %o0
	retl
	st      %o1,[%o3]

	.seg	"data"			! [internal]
