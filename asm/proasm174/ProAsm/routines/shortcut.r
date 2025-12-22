
;---;  shortcut.r  ;-----------------------------------------------------------
*
*	****	WAITING FOR SHORTCUT ROUTINE    ****
*
*	Author		Stefan Walter
*	Version		0.10
*	Last Revision	01.11.92
*	Identifier	sct_defined
*	Prefix		sct_	(Shortcut)
*				 ¯    ¯ ¯
*	Functions	WaitForShortCut
*
;------------------------------------------------------------------------------

;------------------
	ifnd	sct_defined
sct_defined	=1

;------------------
sct_oldbase	equ __base
	base	sct_base
sct_base:

;------------------
	include	tasktricks.r

;------------------

;------------------------------------------------------------------------------
*
* WaitForShortCut	Waits for a shortcut and an additional signal mask.
*			Shortcut rawkey must be in sct_key.
*
* INPUT		d0	Signal mask
*
* RESULT	d0	Signals recieved
*
* NOTE	To determine if shortcut was pressed, mask out all other bits that
*	were waited for and test if the result is 0.
*
;------------------------------------------------------------------------------

;------------------
WaitForShortCut:

;------------------
; Start:
;
\start:
	movem.l	d1-a6,-(sp)
	lea	sct_base(pc),a4
	move.l	d0,d7
	moveq	#0,d6

;------------------
; Install port and open device.
;
\install:
	move.l	4.w,a6
	lea	sct_reply(pc),a0
	bsr	MakePort
	beq	\done
	lea	sct_io(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	lea	sct_inputname(pc),a0
	jsr	-444(a6)		;OpenDevice()

	tst.l	d0
	bne	\closeport

;------------------
; Send addition request.
;
\add:
	Forbid_
	lea	sct_io(pc),a1
	pea	sct_reply(pc)
	move.l	(sp)+,14(a1)
	move.w	#9,28(a1)
	pea	sct_handler(pc)
	move.l	(sp)+,40(a1)
	pea	\inputhdroutine(pc)
	move.l	(sp)+,sct_handler+18(a4)
	jsr	-456(a6)		;DoIO()
	Permit_

;------------------
; Wait.
;
\wait:
	move.b	sct_reply+15(pc),d6
	moveq	#0,d0
	moveq	#0,d1
	bset	d6,d1
	jsr	-306(a6)		;SetSignal
	move.l	d7,d0
	bset	d6,d0
	jsr	-318(a6)		;Wait
	move.l	d0,d6

;------------------
; Remove stuff.
;
\awake:
	lea	sct_io(pc),a1
	move.w	#10,28(a1)
	pea	sct_handler(pc)
	move.l	(sp)+,40(a1)
	jsr	-456(a6)		;DoIO()
	lea	sct_io(pc),a1
	jsr	-450(a6)		;CloseDevice()

\closeport:
	lea	sct_reply(pc),a0
	bsr	UnMakePort

\done:
	move.l	d6,d0
	movem.l	(sp)+,d1-a6
	rts

;------------------
; Input handler.
;
\inputhdroutine:
	cmp.b	#1,4(a0)
	bne.s	\quitinputhd
	move.l	6(a0),d0
	and.l	#$00ff73ff,d0		;MASK
	cmp.l	sct_key(pc),d0		;KEY
	bne.s	\quitinputhd

	movem.l	d1-a6,-(sp)
	move.l	sct_reply+16(pc),a1
	move.b	sct_reply+15(pc),d1
	moveq	#0,d0
	bset	d1,d0
	move.l	4.w,a6
	jsr	-324(a6)	;Signal()
	movem.l	(sp)+,d1-a6
	suba.l	a0,a0

\quitinputhd:
	move.l	a0,d0		;this event is transmitted or not
	rts

;------------------

;--------------------------------------------------------------------

;------------------
	include	ports.r

;------------------
; Data.
;
sct_key:	dc.l	$210001
sct_inputname:	dc.b	"input.device",0,0

;------------------
sct_handler:	dc.l	0,0
		dc.b 	2,80
		dc.l 	0
		dc.l 	0
		dc.l 	0		;inputhdroutine

sct_io:		ds.b 48,0
sct_reply:	ds.b 32,0

;------------------

;--------------------------------------------------------------------

;------------------
	base	sct_oldbase

;------------------
	endif

	end

