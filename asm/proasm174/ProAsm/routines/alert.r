
;---;  alert.r  ;--------------------------------------------------------------
*
*	****	GRAVE ERROR ALERT SYSTEM    ****
*
*	Author		Stefan Walter
*	Version		1.01
*	Last Revision	08.09.92
*	Identifier	gea_defined
*       Prefix		gea_	(grave error alert)
*				 ¯     ¯     ¯
*	Functions	Alert, SetAlertChoices, Alert2
*	Macros		AddAlert_
*
*	NOTE:	The EQUR gea_progname must contain the name of the program as
*		String. 
*
;------------------------------------------------------------------------------

;------------------
	ifnd	gea_defined
gea_defined	=1

;------------------
gea_oldbase	equ __base
	base	gea_base
gea_base:

;------------------
	ifnd	gea_progname
	fail	gea_progname equr 'progname' not done yet!
	endif

;------------------

;------------------------------------------------------------------------------
*
* AddAlert	Macro to add a failure text related to a code number.
*
* USAGE		AddAlert_	[symbol],['error text']
*
;------------------------------------------------------------------------------

;------------------
AddAlert_	macro	

;------------------
; Give the symbol a value and put the text.
;
	ifnd	\1
\1		=	*-gea_base
	dc.b	\2,0
	even
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* SetAlertChoices	Set choice texts for Alert.
*
* INPUT:	a0	Left text (max. 20 chars)
*		a1	Right text  "    "   "
*
;------------------------------------------------------------------------------

;------------------
SetAlertChoices:

;------------------
; Start.
;
\start:
	movem.l	a0/a1/a2,-(sp)
	lea	gea_alertltext(pc),a2
	bsr.s	\copy
	exg.l	a0,a1
	lea	gea_alertrtext(pc),a2
	bsr.s	\copy
	movem.l	(sp)+,a0/a1/a2
	rts

\copy:	tst.b	(a0)
	beq.s	\done
	move.b	(a0)+,(a2)+
	bra.s	\copy
\done:	rts

;------------------

;------------------------------------------------------------------------------
*
* Alert		Display alert with a text, retry/abort choice.
* Alert2	Display alert with a text, choice last set with SetAlertChoices
*
* INPUT:	d0.w	failure symbol key
*
* OUTPUT:	d0	0 for right, -1 for left button
*		ccr	on d0
*
;------------------------------------------------------------------------------

;------------------
; Alert: Copy default choices.
;	d0=code
;
Alert:
	movem.l	a0/a1,-(sp)
	lea	gea_defalertl(pc),a0
	lea	gea_defalertr(pc),a1
	bsr	SetAlertChoices
	movem.l	(sp)+,a0/a1

;------------------
; Startup.
;	d0=code
;
Alert2:
	movem.l	d1-a6,-(sp)
	lea	gea_base(pc),a5
	move.l	d0,a4

;------------------
; Get intuition lib. If we can't get it, exit anyway.
;
\openintui:
	move.l	4.w,a6
	lea	\intuiname(pc),a1
	jsr	-408(a6)		;OldOpenLibrary()
	move.l	d0,a6
	tst.l	d0
	beq.s	\end			;no library, no requester...

;------------------
; Set in error text.
;
\setnumber:
	lea	\alertcode(pc),a0
	lea	(a5,a4.w),a4
	moveq	#50,d0
\copy:
	move.b	(a4)+,(a0)+		;copy name
	beq.s	\copied
	subq.w	#1,d0
	bne.s	\copy
	bra.s	\setalert

\copied:
	subq.w	#1,d0
	beq.s	\setalert
	move.b	#" ",(a0)+		;fill up with space
	bra.s	\copied

;------------------
; Display alert.
;
\setalert:
	moveq	#0,d0
	lea	\alerttext(pc),a0
	moveq	#32+16+4+4,d1
	jsr	-90(a6)			;DisplayAlert()
	move.l	d0,a4

;------------------
; Close lib.
;
\closeintui:
	move.l	a6,a1
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()
	move.l	a4,d0

;------------------
; Exit.
;
\end:
	movem.l	(sp)+,d1-a6
	rts

;------------------

;--------------------------------------------------------------------

;--- Alert --------
\intuiname:	dc.b	"intuition.library",0
\alerttext:	dc.b	0,32,18,gea_progname,":",0,-1
		dc.b	0,32,30,"Fatal error occured: "
\alertcode:	ds.b	50,$20
		dc.b	0,-1
		dc.b	0,32,42,"LEFT button to "

gea_alertltext:	dc.b	"retry                RIGHT button to "
gea_alertrtext:	dc.b	"abort                ",0,0

gea_defalertl:	dc.b	"retry",0
gea_defalertr:	dc.b	"abort",0
		even

;--------------------------------------------------------------------

;------------------
	base	gea_oldbase

;------------------
	endif

 end

