** EInclude macro 1.0   © 1996 Szymon Pura

	ifnd	EINCLUDE_MACRO
EInclude	macro
	ifnd	\1_\2_E
	ifnd	\1_\2_I
	include	'\1/\2.i'
	endc
\1_\2_E	set	1
	endc
	endm
EINCLUDE_MACRO	set	1

JSRL	macro	
	jsr	_LVO\1(a6)
	endm

JMPL	macro
	jmp	_LVO\1(a6)
	endm
	endc
