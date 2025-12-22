*pasm -F 2 -mo -O -1 -I re:lib/ re:lib/PPC/getA7.pasm
	.include	ppcmacros.pasm
	.text
	.align	3
	.global	_getA7
_getA7:	mr	a7,d0
	blr
	.type	_getA7,2
	.size	_getA7,$-_getA7
	