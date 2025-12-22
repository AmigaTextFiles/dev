
;---;  intuitionlib.r  ;-------------------------------------------------------
*
*	****	INTUITION LIBRARY OPEN AND CLOSE    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	21.07.92
*	Identifier	ilb_defined
*       Prefix		ilb_	(intuition library)
*				 ¯         ¯ ¯
*	Functions	OpenIntuitionLib, GetIntuitionBase, CloseIntuitionLib
*
;------------------------------------------------------------------------------

;------------------
	ifnd	ilb_defined
ilb_defined	=0

;------------------
ilb_oldbase	equ __base
	base	ilb_base
ilb_base:

;------------------

;------------------------------------------------------------------------------
*
* OpenIntuitionLib	Open intuition.library once and use a nesting counter.
*
* RESULT:	d0	IntuitionBase.
*		a6	also.
*		ccr	On d0.
;
;------------------------------------------------------------------------------

;------------------
OpenIntuitionLib:

;------------------
; Open only if ilb_nestcnt=0.
;
\open:
	movem.l	d1-a5,-(sp)
	lea	ilb_base(pc),a4
	move.l	ilb_nestcnt(pc),d0
	bne.s	\isopen
	move.l	4.w,a6
	lea	ilb_name(pc),a1
	jsr	-408(a6)		;OldOpenLibrary()
	move.l	d0,ilb_intbase(a4)
\isopen:
	addq.l	#1,ilb_nestcnt(a4)
	move.l	ilb_intbase(pc),d0
	move.l	d0,a6
	movem.l	(sp)+,d1-a5
	rts

;------------------

;------------------------------------------------------------------------------
*
* GetIntuitionBase	Get intuitionbase in a6.
*
* RESULT:	a6	intuitionbase
*
;------------------------------------------------------------------------------

;------------------
GetIntuitionBase:

;------------------
; Intuitionbase => a6.
;
\getbase:
	move.l	ilb_intbase(pc),a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* CloseIntuitionLib	Close intuition.library if ilb_nestcnt gets zero.
*
;------------------------------------------------------------------------------

;------------------
CloseIntuitionLib:

;------------------
; Decrease dlb_nestcnt and close library if finished.
;
\close:
	movem.l	d0-a6,-(sp)
	lea	ilb_nestcnt(pc),a4
	subq.l	#1,(a4)
	bhi.s	\end
	move.l	ilb_intbase(pc),a1
	move.l	a1,d0
	beq.s	\end
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()
\end:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
; Data for library handling.
;
ilb_name:	dc.b	"intuition.library",0
ilb_intbase:	dc.l	0
ilb_nestcnt:	dc.l	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	ilb_oldbase

;------------------
	endif

 end

