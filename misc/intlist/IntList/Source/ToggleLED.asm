*************************************
**
** Copyright © 1997 Jörg van de Loo
**		    Hövel 15
**		    47559 Kranenburg
**		    Germany
*
** Example stuff for the use of one of the two CIA-B timers - in mind
** the RKM Hardware Reference Manual from 1989, Appendix F, page 317 - 333.
*
** By the way: This code is reentrant.
*


	IFD	__G2
		MACHINE	MC68000
		OPT	OW-
		OUTPUT	RAM:ToggleLED
	ENDC

	include	exec/exec_lib.i
	include	exec/interrupts.i
	include	exec/execbase.i

	include	dos/dos.i
	include	dos/dosextens.i

	include	resources/cia_lib.i

	include	hardware/cia.i


   STRUCTURE	__Table,0
	APTR	_SysBase
	APTR	_CIABBase
	APTR	_ThisTask

	ULONG	_Timer				CIA-B Timer A (#0) or B (#1)
	ULONG	_PAL_NTSC			PAL (#0) or NTSC (#2) machine
	ULONG	_Counter

	STRUCT	_IRQStruct,IS_SIZE		CIA-B interrupt structure
	STRUCT	_IRQCause,IS_SIZE		By Cause() required one

	ALIGNLONG
	LABEL	tb_SIZEOF


_ciaa	equ	$BFE001
_ciab	equ	$BFD000


_main
	lea	-tb_SIZEOF(sp),sp		Make some room on stack (for data area)
	movea.l	sp,A4				Store address data area into processor register A4

	movea.l	4.w,A6				Get Exec base
	move.l	A6,_SysBase(A4)


	suba.l	A1,A1
	jsr	_LVOFindTask(A6)
	move.l	D0,_ThisTask(A4)		Store address of own process structure


	cmpi.b	#50,PowerSupplyFrequency(A6)	Which power frequency?
	bne.s	_NTSC

	clr.l	_PAL_NTSC(A4)			It's PAL
	bra.s	_OpenResource

_NTSC
	move.l	#2,_PAL_NTSC(A4)		It's NTSC


_OpenResource
	lea	_CIABName(pc),A1
	moveq	#0,D0				Any version
	jsr	_LVOOpenResource(A6)		Open it...
	move.l	D0,_CIABBase(A4)
	beq.w	_ErrorOpenResource

*
** Set up CIA-B interrupt structure
*
	lea	_IRQStruct(A4),A0		Initialize IRQ structure I

	clr.l	LN_PRED(A0)			Not really required because the Resource
	clr.l	LN_SUCC(A0)			will overwrite it with its own settings

	move.b	#NT_INTERRUPT,LN_TYPE(A0)
	move.b	#-32,LN_PRI(A0)

	move.l	A4,IS_DATA(A0)

	lea	_IRQCode(pc),A1
	move.l	A1,IS_CODE(A0)

	lea	_IRQName(pc),A1
	move.l	A1,LN_NAME(A0)

*
** Set up Cause() interrupt structure
*
	lea	_IRQCause(A4),A0		Initialize IRQ structure II

	clr.l	LN_PRED(A0)			Not really required - these two are
	clr.l	LN_SUCC(A0)			dynamically changed by Exec

	move.b	#NT_UNKNOWN,LN_TYPE(A0)		Type should be un-known - type assigned by Exec!
	move.b	#-32,LN_PRI(A0)			Only -32, -16, 0, +16 and +32 supported!

	move.l	A4,IS_DATA(A0)

	lea	_IRQCauseCode(pc),A1
	move.l	A1,IS_CODE(A0)

	lea	_IRQName(pc),A1
	move.l	A1,LN_NAME(A0)

*
** Since the data area is located on the stack and we don't know which values
** the datas contain since they are uninitialized, and a call to AddICRVector
** causes immediately the interrupt code to be started and we also avoid a
** Disable() call, we have to initialize _Counter here:
*
	clr.l	_Counter(A4)


*
** Attempt to start one of the CIA-B timer interrupts...
*
	moveq	#0,D2				Start with Timer A
	movea.l	_CIABBase(A4),A6
_try
	lea	_IRQStruct(A4),A1		IRQ to execute (immediately)
	move.l	D2,D0				Timer (which one?)
	jsr	_LVOAddICRVector(A6)
	tst.l	D0
	beq.s	_GotIRQ				If the interrupt is free

	addq.b	#1,D2				Next timer
	cmpi.b	#2,D2				Timer C?
	beq.w	_ErrorTimer			Timer C does not exist!
	bra.s	_try				Else try Timer B

_GotIRQ
	move.l	D2,_Timer(A4)			Save indicator for later (0 = Timer A, 1 = Timer B)

	lea	_ciab,A0			CIA-B hardware address ($BFD000)

	move.l	_PAL_NTSC(A4),D0		0 or 2
	lea	_PAL_NTSC_Times(pc),A1
	move.w	0(A1,D0.l),D0			PAL time or NTSC time value to delay between each occurring

	tst.l	_Timer(A4)			0 or 1
	bne.s	_TimerB				1 = Timer B

_TimerA
	move.b	ciacra(A0),D1			Control register Timer A
	andi.b	#%10000000,D1			Select mode (bit 7 currently unused)
	ori.b	#1,D1				Set Timer A to start
	move.b	D1,ciacra(A0)
	move.b	#$81,ciaicr(A0)			Enable Timer A

	move.b	D0,ciatalo(A0)			Write delay time into registers
	lsr.w	#8,D0
	move.b	D0,ciatahi(A0)
	bra.s	_ok				Done

_TimerB
	move.b	ciacrb(A0),D1			Control register Timer B
	andi.b	#%10000000,D1			Select mode
	ori.b	#1,D1				Set Timer B to start
	move.b	D1,ciacrb(A0)
	move.b	#$82,ciaicr(A0)			Enable Timer B

	move.b	D0,ciatblo(A0)			Write delay time into registers
	lsr.w	#8,D0
	move.b	D0,ciatbhi(A0)

_ok
*	btst	#CIAB_GAMEPORT0,_ciaa		Left mouse button (a busy loop - a absolute tabu)
*	bne.s	_ok				- so we use the following construct:

	move.l	#SIGBREAKF_CTRL_C,D0		Wait for a control-c signal, when pressed,
	movea.l	_SysBase(A4),A6			awake us,
	jsr	_LVOWait(A6)			otherwise sleep...

	movea.l	_CIABBase(A4),A6
	lea	_IRQStruct(A4),A1
	move.l	_Timer(A4),D0
	jsr	_LVORemICRVector(A6)		Stop only the CIA-B interrupt - since the other one
*						is raised by software...

	moveq	#0,D0
_exit
	move.l	_ThisTask(A4),A0
	move.l	D0,pr_Result2(A0)		Set error code to process
	lea	tb_SIZEOF(sp),sp		Restore stack
	rts

_ErrorTimer
	moveq	#50,D0
	bra.s	_exit

_ErrorOpenResource
	moveq	#100,D0
	bra.s	_exit

_IRQCode	; Through CIA-B hardware caused interrupt...
	movea.l	A1,A5				IS_DATA

	lea	_IRQCause(A5),A1
	movea.l	_SysBase(A5),A6
	jsr	_LVOCause(A6)
	moveq	#0,D0
	rts

_IRQCauseCode	; Executed each 1/50 second - regardless what for a machine and which Power supply!
	movem.l	D2-D7/A2-A4/A6,-(sp)		Don't trash these...

	movea.l	A1,A5				IS_DATA

	move.l	_Counter(A5),D0
	addq.l	#1,D0
	cmpi.l	#50,D0
	bne.s	1$

	bchg.b	#CIAB_LED,_ciaa			Toggle Power LED
	moveq	#0,D0
1$
	move.l	D0,_Counter(A5)

	movem.l	(sp)+,D2-D7/A2-A4/A6
	moveq	#0,D0
	rts

_PAL_NTSC_Times
	dc.w	14187,14318	709379/50 = ~14187, 715909/50 = ~14318 (= 20,000 micro seconds = 50 times per second)
_IRQName
	dc.b	'LED Switcher',0
_CIABName
	dc.b	'ciab.resource',0

	END