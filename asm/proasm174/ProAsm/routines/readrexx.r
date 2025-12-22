
;---;  readrexx.r  ;-----------------------------------------------------------
*
*	****	ROUTINES FOR A PASSIVE AREXX PORT    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	31.03.93
*	Identifier	rrx_defined
*	Prefix		rrx_	(Read ARexx)
*				 ¯     ¯ ¯
*	Functions	InitEasyARexx, ResetEasyARexx, GetARexxMsg,
*			ReplyARexxMsg
*
;------------------------------------------------------------------------------

;------------------
	ifnd	rrx_defined
rrx_defined	=1

;------------------
rrx_oldbase	equ	__base
	base	rrx_base
rrx_base:

;------------------------------------------------------------------------------
*
* InitEasyARexx		Initialize everything.
*
* INPUT		a0	Port structure, not initialized yet.
*
* RESULT:	d0	0: Failed, -1: Okay
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
InitEasyARexx:

;------------------
; Open lib and init port.
;
\open:	movem.l	d1-a6,-(sp)
	lea	rrx_base(pc),a4
	move.l	a0,a3

	move.l	4.w,a6
	move.l	10(a0),a1
	Forbid_
	jsr	-390(a6)		;FindPort()
	Permit_
	tst.l	d0			;does port exist?
	bne.s	rrx_f1

	move.l	a3,a0
	bsr	MakePort		;make public port
	beq.s	rrx_f1
	move.l	d0,rrx_rexxport(a4)

	lea	rrx_rexxname(pc),a1
	jsr	-408(a6)		;OpenLibrary
	move.l	d0,rrx_rexxbase(a4)
	beq.s	rrx_f2

	moveq	#-1,d0
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* ResetEasyARexx	Reset everything.
*
* RESULT:	d0	0
*
;------------------------------------------------------------------------------

;------------------
ResetEasyARexx:

;------------------
; Close.
;
\close:	movem.l	d1-a6,-(sp)
	move.l	rrx_rexxbase(pc),a1
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()

rrx_f2:	move.l	rrx_rexxport(pc),a0
	bsr	UnMakePort

rrx_f1:	moveq	#0,d0
	movem.l	(sp)+,d1-a6
	rts
	
;------------------

;------------------------------------------------------------------------------
*
* GetARexxMsg	Get an ARexx msg from port. Returns 0 if there is none or
*		if it wasn't an ARexx msg. NonARess msgs are dumped.
*
* RESULT:	d0	MSG or 0.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
GetARexxMsg:

;------------------
; Get.
;
\get:	movem.l	d1-a6,-(sp)
	move.l	rrx_rexxport(pc),a0
	move.l	4.w,a6
	jsr	-372(a6)		;GetMsg()
	move.l	d0,d7
	beq.s	\exit

	move.l	d0,a0
	move.l	rrx_rexxbase(pc),a6
	jsr	-168(a6)		;IsRexxMsg()
	tst.l	d0
	beq.s	\exit

	move.l	d7,d0

\exit:	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* ReplyARexxMsg	Reply a previously received ARex message.
*
* INPUT:	a0	Message.
*		d0	Result 1	
*		d1	Result 2 (a text)
*
;------------------------------------------------------------------------------

;------------------
ReplyARexxMsg:

;------------------
; Reply.
;
\get:	movem.l	d0-a6,-(sp)
	move.l	rrx_rexxbase(pc),a6
	move.l	d0,d4
	move.l	d1,d5
	move.l	a0,d7
	move.l	28(a0),d2
	btst	#17,d2			;result wanted?
	bne.s	\gen
	moveq	#0,d4
	moveq	#0,d5
	bra.s	\send

\gen:	tst.l	d5			;2. result there?
	beq.s	\send
	move.l	d5,a0
	moveq	#0,d0
\loop:	tst.b	(a0)+
	beq.s	2$
	addq.l	#1,d0
	bra.s	\loop
2$:	move.l	d5,a0
	jsr	-126(a6)		;CreateArgString()
	move.l	d0,d5

\send:	move.l	d7,a1
	move.l	d4,32(a1)
	move.l	d5,36(a1)
	move.l	4.w,a6
	jsr	-378(a6)		;ReplyMsg()

\exit:	movem.l	(sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------

;------------------
; Data.
;
rrx_rexxbase:	dc.l	0
rrx_rexxport:	dc.l	0
rrx_rexxname:	dc.b	"rexxsyslib.library",0
	even

;------------------

;------------------------------------------------------------------------------

;------------------
	base	rrx_oldbase

;------------------
	endif
	end

