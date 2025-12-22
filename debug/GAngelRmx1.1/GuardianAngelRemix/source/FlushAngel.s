
;Blind	equ	0

	super
;	addsym
	MC68040
	bopt	f+,x+,O+,wo-,OG+
;	output	yo:FlushAngel
	output	ram:GuardianAngelRemix/FlushAngel

	incdir	includes:
	include	exec/exec.i
	include	offsets/exec_lib.i
	include	offsets/dos_lib.i
	include	dos/dos.i
	include	dos/dosextens.i
	include	macros:macros


GETURP	macro
	ifnd	mmu030
		movec	TC,\1
		tst.w	\1
		bmi.b	.ok\@

		sub.l	\1,\1
		bra.b	.nogo\@
.ok\@
		move.l	\1,-(sp)
		btst.b	#6,2(sp)	; TCR bit 14
		addq.l	#4,sp
		beq.b	.ok2\@

		sub.l	\1,\1
		bra.b	.nogo\@
.ok2\@
		movec	URP,\1
.nogo\@
	else
		subq.l	#8,sp
		pmove.q	CRP,(sp)
		and.b	#$f0,7(sp)
		move.l	4(sp),\1
		addq.l	#8,sp
	endc					; -1
	endm

UP	macro
	add.l	 #$fff,\1
	ifeq	NARG-2
	add.l	 #$fff,\2
	endc
	and.w	#~$fff,\1
	ifeq	NARG-2
	and.w	#~$fff,\2
	endc
	endm

DOWN	macro
	and.w	#~$fff,\1
	endm

CodeStart
	move.l	4.w,a6
	moveq	#1,d7
	btst.b	#AFB_68040,AttnFlags+1(a6)
	beq.b	ExitAngel

	sub.l	a1,a1
	jsr	_LVOFindTask(a6)

	move.l	d0,a4
	tst.l	pr_CLI(a4)	; was it called from CLI?
	bne	.fromCLI	; if so, skip out this bit...

	lea	pr_MsgPort(a4),a0
	jsr	_LVOWaitPort(A6)
	lea	pr_MsgPort(a4),a0
	jsr	_LVOGetMsg(A6)
	lea	(returnMsg,pc),a0
	move.l	d0,(a0)

.fromCLI

	lea	(EXECBase,pc),a0
	move.l	a6,(a0)

	lea	(.super,pc),a5
	SYS	Supervisor
	bra	.goturp
.super	GETURP	d0
	rte
.goturp
	moveq	#2,d7
	tst.l	d0
	beq	ExitAngel

	move.l	d0,d6

	moveq	#3,d7

	ifnd	Blind
	SYS	Forbid

	move.l	#MEMF_REVERSE,d1
	move.l	#$4000,d0
	SYS	AllocMem
	move.l	d0,d2
	beq.b	.out

	move.l	d2,a1
	move.l	#$4000,d0
	SYS	FreeMem

	add.l	#$2000,d2
	clr.w	d2
	move.l	d2,d0
	move.l	d6,a0
	bsr	FindDescriptor
	clr.w	d0
	cmp.l	d0,d2
	beq.b	.out
	endc

;	moveq	#0,d7
	move.l	a6,a1
	SYS	RemTask

	ifnd	Blind
.out
	SYS	Permit
	endc

ExitAngel
	bsr	WB_Exit

	lea	(Needs040,pc),a2
	cmp.l	#1,d7
	beq.b	.info

	lea	(MMUproblem,pc),a2
	cmp.l	#2,d7
	beq.b	.info

	lea	(PatchProb,pc),a2
	cmp.l	#3,d7
;	beq.b	.info
	bne.b	.exit

.info
	bsr	UserFeedback
.exit
	moveq	#20,d0
	rts

UserFeedback
	OpenLib	Dos,.window_done
	lea	(windowname,pc),a0
	move.l	a0,d1
	move.l	#MODE_NEWFILE,d2
	DOS	Open
	move.l	d0,d4
	beq.b	.window_done

	move.l	d4,d1
	move.l	a2,d2
	move.l	a2,a0
.loop	tst.b	(a0)+
	bne.b	.loop

	sub.l	a2,a0
	move.l	a0,d3

	SYS	Write

	move.l	d4,d1
	SYS	Close
.window_done
	move.l	(EXECBase,pc),a6
	rts

windowname	dc.b	"CON:000/000/640/100/Error information/AUTO/CLOSE/WAIT/SMART",0
Needs040	dc.b	"This program only works on a 68040.",0
MMUproblem	dc.b	"MMU is not in use. Please run SetPatch/Enforcer.",0
DosName		dc.b	"dos.library",0
PatchProb	dc.b	"Could not restore all Exec functions.",0
	even

WB_Exit
	move.l	(returnMsg,pc),d0	; Is there a message?
	beq	.exitToDOS		; if not, skip...

        jsr	_LVOForbid(a6)          ; note! No Permit needed!
	move.l	d0,a1
	jsr	_LVOReplyMsg(a6)
	jsr	_LVOPermit(a6)

.exitToDOS
	rts


returnMsg	dc.l	0

EXECBase	dc.l	0
DosBase		dc.l	0


FindDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = address	no alignment needed
;	a0 = URP
;-Output:----------------------------------------------------------------------
;	d0 = page descriptor for address
;	a0 = address of page descriptor
;------------------------------------------------------------------------------
	move.l	d0,d1
	swap	d1
	lsr.w	#7,d1		; top 7 bits
	and.b	#%11111100,d1	; d1 = root index	;clear bit 0,1
* level 1
	move.l	(a0,d1.w),d1	; root level tables
	and.w	#$fe00,d1	; clear lower 9 bits
	move.l	d1,a0
	move.l	d0,d1
	swap	d1
	and.w	#%0000000111111100,d1	; pointer index
* level 2
	move.l	(a0,d1.w),d1	; pointer level tables
	clr.b	d1		; clear lower  8 bits
	move.l	d1,a0

	move.l	d0,d1
	lsl.l	#6,d1
	swap	d1
	and.w	#%0000000011111100,d1	; d1 = table offset
* level 3
	lea	(a0,d1.w),a0
	move.l	(a0),d0		; page descriptor

	rts

End
