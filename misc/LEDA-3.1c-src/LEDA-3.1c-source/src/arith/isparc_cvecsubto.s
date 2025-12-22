	.seg	"text"			! [internal]
	.global	_cvecsubto
_cvecsubto:
	tst	%o2			! count
	ble	L77095
	mov	0,%o5			! carry
L77093:
	ld	[%o0],%g1		! *a
	ld	[%o1],%g2		! *b
	inc	4, %o1			! b++
	subcc	%g1, %g2, %g1		! *a - *b
	addx	%g0, %g0, %g3
	subcc	%g1, %o5, %g1		! -carry
	addx	%g3, %g0, %o5		! new carry
	st	%g1, [%o0]		! *a
	subcc	%o2, 1, %o2		! count--
	bg	L77093
	inc	4, %o0			! a++
L77095:
	tst	%o5			! carry
	be	L77100
	nop
L77097:
	ld	[%o0],%g1		! *a
	subcc	%g1, %o5, %g1		! *a - carry
	addxcc	%g0, %g0, %o5		! new carry
	st	%g1, [%o0]		! *a
	bne	L77097
	inc	4,%o0			! a++
L77100:
	retl
	nop
	.seg	"data"			! [internal]
