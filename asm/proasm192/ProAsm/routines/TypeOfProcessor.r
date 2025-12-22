
;---;  TypeOfProcessor  ;------------------------------------------------------
*
*	****	TYPEOFPROCESSOR ROUTINE    ****
*
*	Author		Daniel Weber
*	Version		1.62
*	Start		1992
*	Last Revision	22.12.94
*	Identifier	top_defined
*       Prefix		top_	(TypeOfProcessor)
*				 ¯   ¯ ¯
*	Functions	TypeOfProcessor
*
*	Note		- The result is not compatible with the exec AttnFlags!
*			- About 220 bytes of stack needed.
*			- Don't use TypeOfProcessor() in the supervisor state!
*			- LC060/EC060 dedection same as the LC/EC040.
*
*	Flags		MC.68EC030	- enable special MC68EC030 recognision
*
*	Processors	MC68000
*			MC68010
*			MC68020
*			MC68030
*			MC68040
*			MC68060
*
*			(MC68EC030)	EC
*			MC68EC040
*			MC68EC060
*
*			MC68LC040	LC
*			MC68LC060
*
*			FPU40		Software emulation
*			FPU60		(not supported yet)
*			SP60
*
;------------------------------------------------------------------------------

;------------------
	ifnd	top_defined
top_defined	equ 1

;------------------
top_oldbase	equ __BASE
	base	top_base
top_base:

;------------------

	opt	sto,o+,q+,ow-,qw-
	super
	relax
	mcrelax
	mc68882
	mc68851

;------------------

	IFGT	__PRO,137
	FAILAT	1
	FAIL	*** ProAsm version 0.89 or higher required! ***
	ENDC

	WARN	*** TypeOfProcessor(): FPU60 recognition not implemented.


;------------------------------------------------------------------------------
*
* the most of the below defined symbols are compatible to the C= include files
*
;------------------------------------------------------------------------------

top_def		MACRO			;smart macro to define a symbol
		IFND	TOPB_\1
TOPB_\1		EQU	\2
		ENDC
		IFND	TOPF_\1
TOPF_\1		EQU	1<<TOPB_\1
		ENDC
		ENDM



	IFND	TOPF_68000
TOPF_68000	EQU	0
	ENDC

	top_def	68010,0			;also set for 68020
	top_def	68020,1			;also set for 68030
	top_def	68030,2			;also set for 68040
	top_def	68040,3			;also set for 68060
	top_def	68881,4			;also set for 68881
	top_def	68882,5
	top_def	FPU40,6			;set for 68040FPSP (software emulation)
	top_def	68851_MMU,7		;not supported by exec
	top_def	68851,7			;not supported by exec
	top_def	68060,8			;not supported by exec
	top_def	FPU60,9			;not supported by exec
	top_def	SP60,10			;not supported by exec
	top_def	68LC060,11		;not supported by exec
	top_def	68LC040,12		;not supported by exec
	top_def	68EC030,13		;not supported by exec
	top_def	68EC040,14		;not supported by exec
	top_def	68EC060,15		;not supported by exec



	IFND	TOPF_MASK
top_TOPF_MASK	equ	TOPF_68010|TOPF_68020|TOPF_68030
top_TOPF_MASK	set	top_TOPF_MASK|TOPF_68040|TOPF_68EC030|TOPF_68EC040
top_TOPF_MASK	set	top_TOPF_MASK|TOPF_68060
top_TOPF_MASK	set	top_TOPF_MASK|TOPF_68LC040
;top_TOPF_MASK	set	top_TOPF_MASK|TOPF_FPU60|TOPF_SP60|TOPF_68EC060|TOPF_68LC060

TOPF_MASK	equ	top_TOPF_MASK
	ENDC



*
* The TOPB_FPU40 bit is set when a working 68040 FPU
* is in the system.  If this bit is set and both the
* TOPB_68881 and TOPB_68882 bits are not set, then the 68040
* math emulation code has not been loaded and only 68040
* FPU instructions are available.  This bit is valid *ONLY*
* if the TOPB_68040 bit is set.
*





;------------------------------------------------------------------------------
*
* TypeOfProcessor  - Get the current CPU/FPU/MMU
*
* INPUT:	none
*
* RESULT:	D0:  attn flags (more or less V37 compatible,
*				 except the MMU and 'ECs flags)
*
;------------------------------------------------------------------------------

TypeOfProcessor:
	movem.l	d1-a6,-(a7)
	move.l	(4).w,a6
	moveq	#1,d2			;delete upper word of d2 for later use
	
	move.b (.top_flager-1.b,pc,d2*2),d0
	bne.s  .turbo

;------------------
	move.l	(276,a6),a1		;*thistask
	move.l	(50,a1),a2		;save old tc_trapcode
	mea	(\ProcExHd10,pc),(50,a1) ;new tc_trapcode
	moveq	#0,d2

	move	ccr,d0			;68010 only instruction
	moveq	#TOPF_68010,d2		;set to 68010

	move.l	a2,(50,a1)		;set handler back
	bra.s	\gotit

;------------------
.top_flager:	dc.b 0,-1		;flags for the 32/16 bit processor test


;----------------------------
.turbo:	lea	(\cacher,pc),a5		;68020/30/40/60
	jsr	(-30,a6)		;supervisor()

	move.w	#TOPF_68060|TOPF_68040|TOPF_68030|TOPF_68020|TOPF_68010,d2
	btst	#14,d0				;test NAI
	bne.s	\gotit
	moveq	#TOPF_68040|TOPF_68030|TOPF_68020|TOPF_68010,d2
	tst.w	d0
	bmi.s	\gotit
	moveq	#TOPF_68030|TOPF_68020|TOPF_68010,d2
	btst	#8,d0			;ED, 68030 only
	bne.s	\gotit
	moveq	#TOPF_68020|TOPF_68010,d2	;68020! must be...


;------------------------------------------------
*
* recognise a possible 68851 & 68060
*
\gotit:	move.l	(276,a6),a1
	move.l	(50,a1),a2		;save old tc_trapcode
	mea	(\MMUExHd,pc),(50,a1)	;new tc_trapcode

	btst	#TOPB_68040,d2		;68040? (following PMOVE'll be sensless)
	bne.s	.68060

	subq.l	#4,a7
	pmove	tc,(sp)			;try MMU exception (f-line/priviledge)
	nop
	nop
	addq.l	#4,sp
	btst	#TOPB_68030,d2		;68030?
	bne.s	\cpummu
	tst.w	d0
	beq.s	.68851
;	move.w	#TOPF_68851,d0		;68EC030/040 (not supported by the exec)
\pmmu:	or.w	d0,d2			;set 68851 bit (or 68EC0x0 bit)


	IFD	MC.68030
	bra.s	\endEC030	
\cpummu:				;68030 only
	bsr	top_EC030
	tst.l	d0
	beq.s	\endEC030
	eor.w	#TOPF_68030|TOPF_68EC030,d2 ;(before: 030 set / EC cleared)
\endEC030:
	ELSE
\cpummu:
	ENDC


;------------------
.68060:	btst	#TOPB_68060,d2		;only if 68060 dedected yet...
	beq.s	.68851
.60SP:	moveq	#1,d0
	moveq	#1,d1
	mulu.l	d1,d0:d1		;unimplemented integer instruction
	nop				;\MMUExHd still installed
	nop				;means: d0: 0 -> no SP60 installed
	tst.w	d0			;       d0: - -> SP60 installed
	beq.s	.68851
	or.w	#TOPF_SP60,d2		;68060 software-supported instructions

;------------------
.68851:	btst	#TOPB_68851_MMU,d2	;may i dedect a 68EC0x0 togehter
	bne.s	.68851			;with a 68851?
\tst68851:
	psbc	d1			;68851 only instr. psr not affected
	nop
	nop				;one would be enough!!!
	tst.w	d0			;PScc is a priviledged instruction
	beq.s	0$
	or.w	#TOPF_68851,d2		;it's a 68851 installed!!!
0$:


;------------------------------------------------
*
* recognise a FPU...
*
* a1: taskstructure
* a2: old trapcode
*
	moveq	#-1,d0
	fnop				;detect a FPU (same handler like MMU)
	nop
	nop
	tst.l	d0
	bne.s	\fpu1
	bclr	#TOPB_68040,d2
	beq.s	\nofpu

\LC_EC:	lea	(\getLCEC,pc),a5
	move.l	(4).w,a6
	jsr	(-30,a6)		;_LVOSupervisor

	bclr	#TOPB_68060,d2
	bne.s	2$
	tst.w	d0			;M68040
	bne.s	1$
	bset	#TOPB_68EC040,d2	;68EC040 (no MMU available)
	bra.s	\nofpu
1$:	bset	#TOPB_68LC040,d2	;68LC040 (MMU available)
	bra.s	\nofpu

2$:	tst.w	d0			;M68060
	bne.s	21$
	bset	#TOPB_68EC060,d2	;68EC060 (no MMU available)
	bra.s	\nofpu
21$:	bset	#TOPB_68LC060,d2	;68LC060 (MMU available)
	bra.s	\nofpu


;------------------
\fpu1:	moveq	#0,d1			;get FPU type (68881/2/68040)
	lea	(\getFPU,pc),a5
	move.l	(4).w,a6
	jsr	(-30,a6)		;supervisor()
	or.w	d0,d2			;set the reckon FPU

;------------------
	btst	#TOPB_68040,d2		;check for a software emulation
	beq.s	\nofpu
	and.w	#~(TOPF_68881|TOPF_68882),d2
	moveq	#-1,d0
	fmove.s	#1.23123123,fp0
	fsin	fp0			;or use 'fmovecr #$00,fp0 ;(PI)'
	fnop				;force exception
	nop
	nop	
	tst.l	d0			;d0=0 no 68040FPSP
	beq.s	\nofpu
	or.w	#TOPF_68881|TOPF_68882,d2

;------------------------------------------------
\nofpu:	move.l	a2,(50,a1)		;restore tc_trapcode
	move.l	a4,a5			;restore database
	move.l	d2,d0
	movem.l	(a7)+,d1-a6
	rts






;------------------------------------------------------------------------------
*
* subroutines, exception handlers,...
*
;------------------------------------------------------------------------------

;----------------------------------------------------------
*
* use cache to reckon the 68020/30/40/60 processors
*
* => d0: $0000	--> 68020 installed	no data cache etc.
*	 $0100	--> 68030 installed	68030 data cache
*	 $8000	--> 68040 installed	68040 instruction cache
*	 $4000	--> 68060 installed	68060 no alloc. mode (instruction cache)
*
\cacher:
	movec	cacr,d1			;save cacr
	move.l	d1,d0
	bclr	#0,d0			;disable instruction cache
	or.w	#$c100,d0		;enable data cache (8), 68040 cache (15), 68060 NAI (14)
	movec	d0,cacr			;for processor testing only...
	movec	cacr,d0
	movec	d1,cacr			;restore cacr
	rte

;------------------------------------------------
*
* hadle the excpetion for the processor test (68010: move ccr,d0)
*
\ProcExHd10:
	addq.l	#4,a7			;must be an illegal....
	moveq	#TOPF_68000,d0		;68000
	addq.l	#4,(2,a7)		;back after the 'moveq #1,d2'
	rte 


;------------------------------------------------
*
* handle the line-f exception for the pmove/fnop/... instructions,
* returns the TOPF_68851 bit for the MMU-instruction and
* D0=0 for a none existing FPU.
*
* => d0: 0: failed (line-f)   TOPF_68851: successful
*
\MMUExHd:
	move.l	(a7)+,d0		;exception
	cmp.w	#11,d0			;line-f or higher (for FPU stuff)
	bge.s	\nommu
	moveq.l	#TOPF_68851,d0
	addq.l	#4,(2,sp)		;skip an MMU instruction
	rte

\nommu:	moveq	#0,d0
	addq.l	#4,(2,sp)		;skip MMU instruction or FNOP
	rte


;------------------------------------------------
*
* get the FPU type...
*
* => d0: TOPF_(FPUtype)
*
\getFPU:
	fsave	-(a7)			;save internal state
	fmove.x	fp0,-(a7)
	fmove.s	#1.99319921991E2,fp0	;just a nice number
	fsqrt	fp0			;just another nice number
	fsave	-(a7)

.f81:	moveq	#TOPF_68881,d0
	move.b	1(a7),d1
	cmp.b	#$18,d1			;state frame size: idle state '81
	beq.s	.xfpu
	cmp.b	#$b4,d1			;busy state '81
	beq.s	.xfpu
.f82:	moveq	#TOPF_68882|TOPF_68881,d0
	cmp.b	#$38,d1			;idle state '82
	beq.s	.xfpu
	cmp.b	#$d4,d1			;busy state '82
	beq.s	.xfpu
.f40:	moveq	#TOPF_FPU40,d0		;internal 68040 FPU
	cmp.b	#$40,(a7)		;version...
	beq.s	.xfpu
	cmp.b	#$41,(a7)		;version...
	beq.s	.xfpu

	moveq	#TOPF_68881,d0		;not sure... -> MC68881

.xfpu:	frestore (a7)+
	fmove.x  (a7)+,fp0
	frestore (a7)+			;restore internal state
	rte


;------------------------------------------------
*
* 68LC040 or 68EC040
* 68LC060 or 68EC060
*
* ???
*
* The code assumes that if the MMU is not on that the ITTx/DTTx registers
* are set up like from the OS to map all of memory such that they override
* any MMU settings (thus making the turn-on of the MMU a "NO-OP")
*
* => d0:  0: EC040, -: LC040
*
\getLCEC:
	or.w	#$0700,sr		;don't get interrupted...
	movec	tc,d1
	move.l	d1,d0			;keep the page size...
	bne.s	\LC_
	or.w	#$8000,d0		;turn on MMU
	movec	d0,tc
	movec	tc,d0
	movec	d1,tc			;restore MMU (turn off MMU)
\LC_:	rte


;--------------------------------------------------------------------

	IFD	MC.68EC030
	include	EC030.r
	ENDC

;--------------------------------------------------------------------

	base	top_oldbase
	opt	rcl

;------------------
	endif

 end

