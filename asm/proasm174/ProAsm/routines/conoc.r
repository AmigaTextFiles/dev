
;---;  conoc.r  ;----------------------------------------------------------
*
*	****	SINGLE CONSOLE WINDOW OPEN/CLOSE    ****
*
*	Author		Stefan Walter
*	Version		0.10
*	Last Revision	16.09.92
*	Identifier	coc_defined
*	Prefix		coc_	(Console open and close)
*				 ¯       ¯        ¯
*	Functions	ConOpen, ConClose, GetConHandle
*
*	Flags		coc_ALTERNATIVE set 1 if alternative window used
*			coc_PRINTTITLE set 1 if title shall be printed
*
;------------------------------------------------------------------------------

;------------------
	ifnd	coc_defined
coc_defined	=1

;------------------
coc_oldbase	equ __base
	base	coc_base
coc_base:

;------------------

;------------------------------------------------------------------------------
*
* ConOpen	Open a console window with specs at label 'coc_ConWindow'.
*		If it doesn't open, try an alternative window at
*		'coc_AltConWindow'. If it opens, print a title text at
*		'coc_Title'. If first window doesn't open, and second does,
*		the text at 'coc_AltErrMsg' is printed. Multiple open
*		attempts are handled. Title printing and alternative window
*		usage can be chosen with flags.
*
* RESULT:	d0	Handle or 0
*
;------------------------------------------------------------------------------

;------------------
ConOpen:

;------------------
; Start:
;
\start:
	movem.l	d1-a6,-(sp)
	lea	coc_base(pc),a4
	move.l	coc_window(pc),d0
	bne.s	\done			;window is open...
	bsr	OpenDosLib
	beq.s	\done

;------------------
; Try to open default window.
;
\trydefault:
	pea	coc_ConWindow(pc)
	move.l	(sp)+,d1
	move.l	#1005,d2        	;old
	jsr	-30(a6)			;Open()
	move.l	d0,coc_window(a4)	
	beq.s	\trysecond
	move.l	d0,d1
	bsr	SetConHandles

;------------------
; Test if window is interactive (that means no file).
;
\testinteractive:	
	move.l	d0,d1
	jsr	-216(a6)		;IsInteractive()
	moveq	#0,d6
	tst.l	d0
	beq.s	\nogood			;it is NOT interactive

	ifd	coc_PRINTTITLE
	lea	coc_Title(pc),a0
	bsr	ConPrint
	endif

	move.l	coc_window(pc),d0
	bra.s	\done

\nogood:
	move.l	coc_window(pc),d1
	clr.l	coc_window(a4)
	jsr	-36(a6)			;Close()

;------------------
	ifd	coc_ALTERNATIVE

;------------------
; Try to open alternative window.
;	
\trysecond:
	pea	coc_AltConWindow(pc)
	move.l	(sp)+,d1
	move.l	#1005,d2        	;old
	jsr	-30(a6)			;Open()
	move.l	d0,coc_window(a4)
	beq.s	\done
	move.l	d0,d1
	bsr	SetConHandles

	ifd	coc_PRINTTITLE
	lea	coc_Title(pc),a0
	bsr	ConPrint
	endif

	lea	coc_AltErrMsg(pc),a0
	bsr	ConPrint

;------------------
	else

;------------------
; No alternate window.
;
\trysecond:
	moveq	#0,d0

;------------------
	endif

;------------------
; Done.
;
\done:
	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* ConClose	Close console window.
*
;------------------------------------------------------------------------------

;------------------
ConClose:

;------------------
; Start:
;
\start:
	movem.l	d0-a6,-(sp)
	bsr	GetDosBase
	lea	coc_window(pc),a4
	move.l	(a4),d1
	beq.s	\no
	clr.l	(a4)
	jsr	-36(a6)			;Close()
\no:
	movem.l	(sp)+,d0-a6
	rts

;------------------
	
;------------------------------------------------------------------------------
*
* GetConHandle	Get console handle.
*
* RESULT:	d1	Handle
*
;------------------------------------------------------------------------------

;------------------
GetConHandle:

;------------------
; Start.
;
\start:
	move.l	coc_window(pc),d1
	rts

;------------------

;--------------------------------------------------------------------

;------------------
	include	doslib.r
	include	conio.r

;------------------
; Data.
;
coc_window:	dc.l	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	coc_oldbase

;------------------
	endif

	end

