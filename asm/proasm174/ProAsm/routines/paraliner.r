
;---;  paraliner.r  ;----------------------------------------------------------
*
*	****	UNIX like parameter line parser    ****
*
*	Author		Daniel Weber
*	Version		1.06
*	Last Revision	26.06.93
*	Identifier	prl_defined
*       Prefix		prl_	(parameter line)
*				 ¯ ¯       ¯
*	Functions	Paraliner	parameter line parser
*
*			prl_spacekiller simple space killer
*			prl_nametaker	reads the file name to a dest. buffer
*			prl_nametakerxx	line prl_nametaker but case independant
*					and accepting " " as possible end char
*
*
*	Activation	prl_<char>:	EQU	<handler routine>
*			prl_file	EQU	<file name reader routine>
*			(NOTE: <char>: A..Z UPPER CASE!!!)
*
*			f.e:	prl_A	EQU	my_A_Handler
*
*	Notes		Note that these activation flags must be defined before
*			you include this routine else the default handler
*			will be used ('errline')!
*
*			The option handlers must exit using a RTS instruction
*			and the registers A0/A4 must be kept unaffected
*			(except A0 for the file name taker)!
*
*			You may use a5 as your 'external' base, since a4
*			will not be affected.
*
*	Return values	Handler routines:	d0: +: OK for a non multi
*						       parameter
*						       (f.e.: -o <file> -d)
*						    0: OK for a multi parameter
*						       (f.e.: -bdc = -b -d -c)
*						    -: FAILED
*
*			Name reader routines:	d0: 0+: OK    -:FAILED
*
;------------------------------------------------------------------------------

;------------------
	ifnd	prl_defined
prl_defined	SET	1

;------------------
prl_oldbase	equ __BASE
	base	prl_base
prl_base:

;------------------
	opt	sto,o+,q+,ow-		;all optimisations on

;------------------------------------------------------------------------------
prl_option	MACRO			;macro to create the parameter line
		IFEQ	NARG
		FAIL	paraliner.r: option missing
		ELSE
		IFD	prl_\1
		dc.w	prl_\1%
		ELSE
		dc.w	.unknparameter%
		ENDC
		ENDC
		ENDM


;------------------------------------------------------------------------------
*
* Paraliner		- UNIX like parameter line parser
*
* INPUT:	d0:	command line length	(prl_cmdlen)
*		a0:	command line		(prl_cmdline)
*
* RESULT:	D0: 		0: valid   -: Usage/invalid (see prl_invalid)
*		prl_invalid:	0: ok	   -: invalid
*
* 		(Usage: D0<>0 and prl_inavlid=0)
*
;------------------------------------------------------------------------------

Paraliner:
;------------------
	movem.l	d1-d7/a1-a6,-(a7)
;	move.l	prl_cmdlen(pc),d0
;	move.l	prl_cmdline(pc),a0
	lea	prl_base(pc),a4
	clr.b	-1(a0,d0.l)		;last char now zero
	moveq	#2,d1
	cmp.l	d1,d0
	bcs	prl_usage

	clr.b	prl_invalid(a4)

;----------------------------	
.options:
	tst.b	prl_invalid(a4)		;error occured during parameter processing
	bne	.errline
	bsr	prl_spacekiller		;higher word cleared in spacekiller
	move.b	(a0)+,d0
	beq	.goodline
;	move.b	d0,d1
;	lsl.w	#8,d1
;	move.b	(a0),d1
;	cmp.w	#"?"<<8,d1
;	beq	.usage
;	cmp.w	#"? ",d1
;	beq	.usage
	cmp.b	#"-",d0
	bne	.name
	move.b	(a0)+,d0
	beq	.errline

.takenext:
	and.b	#$df,d0
	sub.b	#"A",d0
	cmp.b	#"Z"-"A",d0
	bhi	.errline
	add.w	d0,d0
	move.w	.paras(pc,d0.w),d0
	jsr	(a4,d0.w)
	tst.l	d0
	bmi	.errline
	bne.s	.options

.nobinfile:				;after allowed options only!!
	moveq	#0,d0			;for multiply options (-bd)
	move.b	(a0)+,d0
	beq	.goodline
	cmp.b	#" ",d0
	beq	.options
	bra	.takenext


;-----------------------
.paras:	prl_option	A
	prl_option	B
	prl_option	C
	prl_option	D
	prl_option	E
	prl_option	F
	prl_option	G
	prl_option	H
	prl_option	I
	prl_option	J
	prl_option	K
	prl_option	L
	prl_option	M
	prl_option	N
	prl_option	O
	prl_option	P
	prl_option	Q
	prl_option	R
	prl_option	S
	prl_option	T
	prl_option	U
	prl_option	V
	prl_option	W
	prl_option	X
	prl_option	Y
	prl_option	Z


;-------------------------------------------------
.name:					;get file name...
	IFD	prl_file
	subq.l	#1,a0
	jsr	prl_file(pc)
	tst.l	d0			;return value...
	bpl	.options
	bra	.errline
	ELSE
	bra.s	.errline
	ENDC

;--------------------------------------
.goodline:				;correct line format
	clr.b	prl_invalid(a4)
.ouout	bsr	prl_spacekiller
	moveq	#0,d0
	movem.l	(a7)+,d1-d7/a1-a6
	rts

;--------------------------------------
;.usage:	st	prl_invalid(a4)
;		bra.s	.ouout

;--------------------------------------
.unknparameter:
	addq.l	#4,a7			;remove return address from stack
.errline:				;error found in parameter line...
	st	prl_invalid(a4)
	moveq	#-1,d0
	movem.l	(a7)+,d1-d7/a1-a6
	rts



;------------------------------------------------
* d2: case  0: case independant  -: case dependant
* d3: poossible (accepted) end char (normally a SPC)
* d7: max. length of name (max. 65535)
* a0: source
* a1: destination
*
prl_nametakerxx:
	moveq	#0,d2			;lower case
	moveq	#" ",d3
prl_nametaker:				;d7: max number of chars to take
	bsr	prl_spacekiller		;d3: additional allowed endchar
	moveq	#0,d0
	moveq	#0,d5
	move.l	d7,d6
	subq.l	#1,d6
	cmp.b	#$22,(a0)
	beq.s	.strtname
	cmp.b	#"'",(a0)
	bne.s	.takesource
.strtname:
	move.b	(a0)+,d5
.takesource:
	move.b	(a0)+,d0
	beq.s	.ender2
	tst.b	d2
	beq.s	.lower
	cmp.b	#"a",d0			;convert to upper case
	blt.s	.lower
	cmp.b	#"z",d0
	bhi.s	.lower
	and.b	#$df,d0
.lower:	cmp.b	d0,d5
	bne.s	.setin
	cmp.b	(a0)+,d5
	bne.s	.ender2

.setin:	cmp.b	#" ",d0
	bne.s	.inloop
	tst.b	d5
	beq.s	.ender2
.inloop:
	move.b	d0,(a1)+
	dbra	d7,.takesource
	bra	.badline

.ender2:
	sub.w	d7,d6
	bmi	.badline
	clr.b	(a1)			;clr after last char
	move.b	-(a0),d0
	beq.s	.good
	cmp.b	d3,d0			;only useful for '.nametaker' entries
	beq.s	.good
	cmp.b	#" ",d0
	bne	.badline
.good:	moveq	#0,d0
	rts

.badline:
	moveq	#-1,d0
	rts


;------------------------------------------------
prl_spacekiller:
	move.b	(a0)+,d0
	cmp.b	#" ",d0
	beq.s	prl_spacekiller
	cmp.b	#$9,d0
	beq.s	prl_spacekiller
	subq.l	#1,a0
	rts


;----------------------------------------------------------
*
* Usage routine...
*
prl_usage:
	clr.b	prl_invalid(a4)
	moveq	#-1,d0
	movem.l	(a7)+,d1-d7/a1-a6
	rts


;----------------------------------------------------------
;prl_cmdlen:	dc.l	0		;command line length
;prl_cmdline:	dc.l	0		;command line
prl_invalid:	dc.b	0		;0: ok   -: invalid parameter line
		even


;--------------------------------------------------------------------

;------------------
	base	prl_oldbase

;------------------
	opt	rcl

;------------------
	endif

 end

