	.seg	"text"
	.global	.myumul
.myumul:
	mov	%o0, %y
	andcc	%g0, %g0, %o4
	nop
	nop
	mulscc	%o4, %o1, %o4	! first iteration of 17
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

	rd	%y, %o5
	sll	%o4, 16, %o4
	srl	%o5, 16, %o5
	or	%o5, %o4, %o0
	retl
	addcc	%g0, %g0, %o1
