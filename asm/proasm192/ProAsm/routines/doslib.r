
;---;  doslib.r  ;-------------------------------------------------------------
*
*	****	DOS LIBRARY OPEN AND CLOSE    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	23.08.92
*	Identifier	dlb_defined
*       Prefix		dlb_	(dos library)
*				 ¯   ¯ ¯
*	Functions	OpenDosLib, GetDosBase, CloseDosLib
*
*	NOTE:		dlb_dosver is -1 if V36+, else 0. Can be used.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	dlb_defined
dlb_defined	=0

;------------------
dlb_oldbase	equ __base
	base	dlb_base
dlb_base:

;------------------

;------------------------------------------------------------------------------
*
* OpenDosLib	Open dos.library once and use a nesting counter.
*
* RESULT:	d0	Dosbase.
*		a6	Dosbase.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
OpenDosLib:

;------------------
; Open only if dlb_nestcnt=0.
;
\open:
	movem.l	d1-a5,-(sp)
	lea	dlb_base(pc),a4
	move.l	dlb_nestcnt(pc),d0
	bne.s	\isopen
	move.l	4.w,a6
	lea	dlb_name(pc),a1
	jsr	-408(a6)		;OldOpenLibrary()
	move.l	d0,dlb_dosbase(a4)
	beq.s	\isopen
	move.l	d0,a1
	cmp.w	#$24,20(a1)
	sge	dlb_dosver(a4)
\isopen:
	addq.l	#1,dlb_nestcnt(a4)
	move.l	dlb_dosbase(pc),d0
	move.l	d0,a6
	movem.l	(sp)+,d1-a5
	rts

;------------------

;------------------------------------------------------------------------------
*
* GetDosBase	Get dosbase in a6.
*
* RESULT:	a6	Dosbase.
*
;------------------------------------------------------------------------------

;------------------
GetDosBase:

;------------------
; Dosbase => a6.
;
\getbase:
	move.l	dlb_dosbase(pc),a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* CloseDosLib	Close dos.library if dlb_nestcnt gets zero.
*
;------------------------------------------------------------------------------

;------------------
CloseDosLib:

;------------------
; Decrease dlb_nestcnt and close library if finished.
;
\close:
	movem.l	d0-a6,-(sp)
	lea	dlb_nestcnt(pc),a4
	subq.l	#1,(a4)
	bhi.s	\end
	move.l	dlb_dosbase(pc),a1
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
dlb_name:	dc.b	"dos.library",0
dlb_dosbase:	dc.l	0
dlb_nestcnt:	dc.l	0
dlb_dosver:	dc.b	0	;-1 if V36+, else 0
		dc.b	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	dlb_oldbase

;------------------
	endif

 end

