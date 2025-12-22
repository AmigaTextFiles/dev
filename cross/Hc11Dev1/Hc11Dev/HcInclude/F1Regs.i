*	$VER: XC68Hc11F1_Registers 2.2 (22-Nov-93)

*	*************************************************
*	* Include: XC68Hc11F1_Registers v2.2		*
*	* Copyright ©1991, 1993, Richard Karlsson	*
*	*-----------------------------------------------*
*	* During august to may:				*
*	* Phone:	+46 13 173423			*
*	* E-Mail:	d93ricka@und.ida.liu.se		*
*	*						*
*	* And the rest of the year:			*
*	* Phone:	+358 28 22441			*
*	*-----------------------------------------------*
*	* Set "RegBase" to the register base address of *
*	* your system.					*
*	*						*
*	* Eg. "RegBase Equ $1000"			*
*	*						*
*	* Define "RegIndirect" if you mostly use the	*
*	* registers indirect to an index register.	*
*	*						*
*	* Eg. "Ldx #RegBase"				*
*	*     "Ldaa PORTA,x"				*
*	*************************************************

	ifnd	RegsDefined

RegsDefined	=	1

	ifd	RegIndirect

DefReg	macro	Name
\1	=	RegDisp
a\1	=	RegBase+RegDisp
RegDisp	Set	RegDisp+1
	endm

DefRegW	macro	Name
\1	=	RegDisp
a\1	=	RegBase+RegDisp
\1H	=	RegDisp
a\1H	=	RegBase+RegDisp
\1L	=	RegDisp+1
a\1L	=	RegBase+RegDisp+1
RegDisp	Set	RegDisp+2
	endm

	else

DefReg	macro	Name
i\1	=	RegDisp
\1	=	RegBase+RegDisp
RegDisp	Set	RegDisp+1
	endm

DefRegW	macro	Name
i\1	=	RegDisp
\1	=	RegBase+RegDisp
i\1H	=	RegDisp
\1H	=	RegBase+RegDisp
i\1L	=	RegDisp+1
\1L	=	RegBase+RegDisp+1
RegDisp	Set	RegDisp+2
	endm

	endc

RegDisp	set	0

	DefReg	PORTA
	DefReg	DDRA
	DefReg	PORTG
	DefReg	DDRG
	DefReg	PORTB
	DefReg	PORTF
	DefReg	PORTC
	DefReg	DDRC
	DefReg	PORTD
	DefReg	DDRD
	DefReg	PORTE
	DefReg	CFORC
	DefReg	OC1M
	DefReg	OC1D
	DefRegW	TCNT
	DefRegW	TIC1
	DefRegW	TIC2
	DefRegW	TIC3
	DefRegW	TOC1
	DefRegW	TOC2
	DefRegW	TOC3
	DefRegW	TOC4
	DefRegW	TI4O5
	DefReg	TCTL1
	DefReg	TCTL2
	DefReg	TMSK1
	DefReg	TFLG1
	DefReg	TMSK2
	DefReg	TFLG2
	DefReg	PACTL
	DefReg	PACNT
	DefReg	SPCR
	DefReg	SPSR
	DefReg	SPDR
	DefReg	BAUD
	DefReg	SCCR1
	DefReg	SCCR2
	DefReg	SCSR
	DefReg	SCDR
	DefReg	ADCTL
	DefReg	ADR1
	DefReg	ADR2
	DefReg	ADR3
	DefReg	ADR4
	DefReg	BPROT

RegDisp	set	$38

	DefReg	OPT2
	DefReg	OPTION
	DefReg	COPRTS
	DefReg	PPROG
	DefReg	HPRIO
	DefReg	INIT
	DefReg	TEST1
	DefReg	CONFIG

RegDisp	set	$5c

	DefReg	CSSTRH
	DefReg	CSCTL
	DefReg	CSGADR
	DefReg	CSGSIZ

	endc

	END
