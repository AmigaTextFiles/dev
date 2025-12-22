;Close Cli & WorkBench by Rafik/RDST

**********************************************************************
*								     *
*	SPRAWDZENIE CZY PROGRAM STARTUJE Z WORKBENCH'A		     *
*		CZY Z CLI					     *
*								     *
**********************************************************************

VERSION	MACRO
	dc.b	'2.1a'
	ENDM

CALL:	MACRO
	jsr	_LVO\1(a6)
	ENDM

CLEAR:	MACRO
	moveq	#0,\1
	ENDM

EXEC:	MACRO
	move.l	4.w,a6
	ENDM

RUNBACK=1

_LVOOldOpenLibrary	EQU	-408
_LVOCloseLibrary	EQU	-414
_LVOOpenLibrary	EQU	-552
_LVOFindTask	EQU	-294
_LVOGetMsg	EQU	-372
_LVOReplyMsg	EQU	-378
_LVOWaitPort	EQU	-384
_LVODelay	EQU	-198
pr_CLI			equ		172
pr_MSGPORT		EQU		$5C
sm_ARGLIST		EQU		$24
sm_NUMARGS		EQU		$1C
_LVOCreateProc	EQU	-138


StartUp:
		movem.l	d0/a0,-(sp)

		lea	DosName,a1
		move.l	4.w,a6
		CALL	OldOpenLibrary
		move.l	d0,DosBase

		sub.l	a1,a1
		CALL	FindTask

		sub.l	a1,a1
		move.l	d0,a2
		tst.l	pr_CLI(a2)
		bne.s	MakeMultitasking

		lea	pr_MSGPORT(a2),a0
		CALL	WaitPort
		lea	pr_MSGPORT(a2),a0
		CALL	GetMsg
		move.l	d0,a1

		move.l	sm_NUMARGS(a1),d0
		move.l	sm_ARGLIST(a1),a0

		moveq	#-1,d1
		addq.l	#8,SP	;.w ?
		movem.l	a1/a6,-(sp)

		jsr	StartSource

		movem.l	(sp)+,a1/a6

		move.l	a1,d1
		beq.s	StartUpQuit
		move.l	d0,d2
		CALL	ReplyMsg
		move.l	d2,d0
StartUpQuit:
		rts
MakeMultitasking:
		move.l	DosBase,a6
		lea	ProcName,A1
		move.l	a1,d1
		moveq	#0,d2
		lea	StartUp(pc),a5
		move.l	-4(a5),d3
		move.l	d2,-4(a5)
		move.l	#3500,d4
		CALL	CreateProc
		movem.l	(sp)+,d0/a0

		moveq	#0,d0
		moveq	#0,d1
		rts

MesLenght:	dc.l	0
MesAdr:		dc.l	0

;tu wrzuciê twój program...

*******************************************************************************
			SECTION	"Kill Cli",CODE
*******************************************************************************

StartSource:
	CLEAR	d0
	lea	IntuiName(pc),a1
	EXEC
	jsr	-$228(a6)	;Open library
	move.l	d0,IntuBase
.await
	move.l	IntuBase(pc),a6	;Intuition Name
	move.l	60(a6),a2	;First Screen
	tst.l	(a2)		;next screen 
	bne.s	.close		;no next screen

	MOVE.L	DosBase(pc),a6
	moveq	#1,d1	;frames
	CALL	Delay
	bra.s	.await

.close
	move.l	22(a2),a3	;Defaluts title
	lea	Work(pc),a4	;find workbench screen
	moveq	#EW-Work-1,d0
.cmp	cmpm.b	(a3)+,(a4)+
	bne.s	.nextwindow
	dbf	d0,.cmp

	move.l	4(a2),a0	;First Window
	jsr	-$48(a6)	;Close Window
	jsr	-$4e(a6)	;Close WorkBench
	move.l	a6,a1
	EXEC
	CLEAR	d0
	jsr	-$19e(a6)	;Close Library

	move.w	#$fff,$dff180
.end
	CLEAR	d0
	rts
.nextwindow
	tst.l	(a2)
	beq.s	.end
	move.l	(a2),a2		;next screen
	bra.s	.close

DosBase:	dc.l	0
IntuBase:	dc.l	0
Work:		dc.b	'Workbench'
EW:
IntuiName:	dc.b	'intuition.library',0
DosName:	dc.b	'dos.library',0
		dc.b	'$VER: '
ProcName:
		dc.b	'Kill Cli '
		VERSION
		dc.b	' by RTheK/RDST',0
