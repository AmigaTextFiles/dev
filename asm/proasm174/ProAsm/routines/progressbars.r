
;---;  ProgressBars.r  ;-------------------------------------------------------
*
*	****	GTFACE ADDENDUM FOR PROGRESSBARS    ****
*
*	Author		Daniel Weber
*	Version		1.00
*	Last Revision	19.04.95
*	Identifier	pgb_defined
*       Prefix		pbg_	(Progressbars)
*				 ¯  ¯    ¯
*	Functions	InitProgressBar, ClearProgressBar,
*			UpdateProgressBar, SetProgressBar,
*
*			NEED_ pgb_fakedbitmap:	for a custom bitmap (only
*						1 plane will be inverted).
*
*
*	Requirements	- graphics.library needed (in GfxBase(pc))
*			- library function offsets for graphics.library included
*			  (e.g. lvo.s)
*
;------------------------------------------------------------------------------

	IFND	pgb_defined
pgb_defined	SET	1

;------------------
pgb_oldbase	EQU __BASE
	base	pgb_base
pgb_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on

*	incdir	'include:'

	include	'basicmac.r'
;	include	'graphics/gfx.i'
	include	'graphics/rastport.i'


;------------------------------------------------------------------------------
*
* needed macros and structure definitions
*
;------------------------------------------------------------------------------
		RSRESET
pgb_x		RS.W	1	; PRIVAT
pgb_y		RS.W	1	; PRIVAT
pgb_width	RS.W	1	; PRIVAT
pgb_height	RS.W	1	; PRIVAT
pgb_last	RS.W	1	; PRIVAT
pgb_window	RS.L	1	; pointer to window structure
pgb_value	RS.L	1	; current value
pgb_max		RS.L	1	; maximum value for pgp_value
pgb_SIZEOF	RSVAL


;
; ProgressStruct_  basename[,maxvalue[,currentvalue]]
;
; NOTE: the window pointer must be set manually
;
ProgressStruct_	MACRO
		dc.w	\1_x
		dc.w	\1_y
		dc.w	\1_width
		dc.w	\1_height
		dc.w	0
		dc.l	0		; window

		IFNC	'\3',''
		dc.l	\3
		ELSE
		dc.l	0
		ENDC
		IFNC	'\2',''
		dc.l	\2
		ELSE
		dc.l	0
		ENDC
		ENDM



;------------------------------------------------------------------------------
*
* InitProgressBar	- initialize the progress bar
*
* INPUT:	a0:	pointer to a ProgressStruct
*		a1:	window pointer
*
* RESULT:	d0:	-: ok	0: structure invalid (max<value) (CCR)
*
;------------------------------------------------------------------------------
	IFD	xxx_InitProgressBar
InitProgressBar:
	movem.l	d1-a6,-(a7)
	moveq	#0,d0
	clr.w	pgb_last(a0)
	move.l	a1,pgb_window(a0)	; no window!?! -> error
	beq.s	.out
	move.l	pgb_value(a0),d1
	bne.s	1$
	CALL_	ClearProgressBar	; empty progressbar
	bra.s	.ok
1$:	cmp.l	pgb_max(a0),d1
	bhi.s	.out
	CALL_	SetProgressBar		; set bar to an initial value

.ok:	moveq	#1,d0
.out:	movem.l	(a7)+,d1-a6
	tst.l	d0
	rts
	ENDC





;--------------------------------------------------------------------
*
* SetProgressBar	- set progress bar (absolute)
*
* INPUT:	a0:	pointer to a ProgressStruct
*
* RESULT:	d0:	-: ok   0: failed (no window, bar too large,...) (CCR)
*
;--------------------------------------------------------------------
	IFD	xxx_SetProgressBar
SetProgressBar:
	movem.l	d1-a6,-(a7)
	CALL_	ClearProgressBar
	tst.l	d0
	beq.s	.out
	CALL_	UpdateProgressBar
.out:	movem.l	(a7)+,d1-a6
	tst.l	d0
	rts
	ENDC




;--------------------------------------------------------------------
*
* ClearProgressBar	- clear progress bar
*
* INPUT:	a0:	pointer to a ProgressStruct
*
* RESULT:	d0:	-: ok   0: failed (no window) (CCR)
*
;--------------------------------------------------------------------
	IFD	xxx_ClearProgressBar
ClearProgressBar:
	movem.l	d1-a6,-(a7)
	clr.w	pgb_last(a0)
	move.l	pgb_window(a0),d0
	beq.s	.out
	move.l	d0,a1
	moveq	#0,d0
	moveq	#0,d1
	move.w	pgb_x(a0),d2
	move.w	pgb_y(a0),d3
	move.w	pgb_width(a0),d4
	move.w	pgb_height(a0),d5
	moveq	#0,d6			; clear destination
	move.l	50(a1),a1		; wd_RPort
	IFD	xxx_pgb_fakedbitmap
	lea	pgb_fakedbitmap(pc),a0
	ELSE
	move.l	rp_BitMap(a1),a0
	ENDC
	move.l	GfxBase(pc),a6
	jsr	_LVOBltBitMapRastPort(a6)
	moveq	#1,d0
.out:	movem.l	(a7)+,d1-a6
	tst.l	d0
	rts
	ENDC



;--------------------------------------------------------------------
*
* UpdateProgressBar	- update progress bar (relativ from pgb_last)
*
* INPUT:	a0:	pointer to a ProgressStruct
*
* RESULT:	d0:	-: ok   0: failed (no window, bar too large,...) (CCR)
*
;--------------------------------------------------------------------
	IFD	xxx_UpdateProgressBar
UpdateProgressBar:
	movem.l	d1-a6,-(a7)
	move.l	pgb_window(a0),d0
	beq.s	.out
	move.l	d0,a1

	move.l	pgb_max(a0),d0
	bne.s	1$
	moveq	#1,d0			; to prevent division by zero exceptions
1$:
	move.l	pgb_value(a0),d1
	move.w	pgb_width(a0),d4
	ext.l	d4
	mulu	d1,d4
	divu	d0,d4
	cmp.w	pgb_width(a0),d4
	bhi.s	.err			; bar gets larger than allowed -> error

	move.w	pgb_last(a0),d2		; update last field...
	move.w	d4,pgb_last(a0)		;
	sub.w	d2,d4
	beq.s	.ok			; no changes
	bpl.s	2$
.dec:	neg.w	d4			; decrease bar
	sub.w	d4,d2			;
	bmi.s	.err			; negative x offset -> error

2$:	add.w	pgb_x(a0),d2
	move.w	pgb_y(a0),d3
	move.w	pgb_height(a0),d5
	moveq	#$50,d6			; invert destination (source not affected)
	moveq	#0,d0
	moveq	#0,d1
	move.l	50(a1),a1		; wd_RPort
	IFD	xxx_pgb_fakedbitmap
	lea	pgb_fakedbitmap(pc),a0
	ELSE
	move.l	rp_BitMap(a1),a0
	ENDC
	move.l	GfxBase(pc),a6
	jsr	_LVOBltBitMapRastPort(a6)

.ok:	moveq	#1,d0
.out:	movem.l	(a7)+,d1-a6
	tst.l	d0
	rts
.err:	moveq	#0,d0
	bra.s	.out
	ENDC


;--------------------------------------------------------------------
	IFD	xxx_pgb_fakedbitmap
pgb_fakedbitmap:
	dc.w	2,1
	dc.b	0,1
	dc.w	0
	ds.b	8*4,0
	EVEN
	ENDC

	base	pgb_oldbase
	opt	rcl

;------------------
	ENDIF

 end

