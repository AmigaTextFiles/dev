
;---;  patch.r  ;--------------------------------------------------------------
*
*	****	LIBRARY FUNCTION PATCH ROUTINES    ****
*
*	Author		Stefan Walter
*	Version		0.10
*	Last Revision	28.03.94
*	Identifier	plf_defined
*	Prefix		plf_	(Patch library functions)
*				 ¯     ¯       ¯
*	Functions	PatchList, UnPatchList, CheckUnPatch
*
;------------------------------------------------------------------------------

;------------------
	ifnd	plf_defined
plf_defined	=1

;------------------
plf_oldbase	equ __base
	base	plf_base
plf_base:

;------------------

;------------------------------------------------------------------------------
*
* PatchList	Patch libraries using a list.
*
* INPUT		a0	List.
*		d0	Bitfield of entries to concider.
*
;------------------------------------------------------------------------------
	IFD	xxx_PatchList
PatchList:
	movem.l	d0-a6,-(sp)
	lea	plf_base(pc),a4
	move.l	a0,a3
	move.l	d0,d7
	move.l	4.w,a6

.loop:	move.w	(a3)+,d0
	beq.s	.done
	and.w	d7,d0
	beq.s	.next

	move.w	(a3)+,a1
	add.l	a4,a1
	move.l	(a1),a1
	move.w	(a3)+,a0
	move.w	(a3)+,d0
	ext.l	d0
	add.l	a4,d0
	jsr	-420(a6)		;SetFunction()
	move.l	d0,(a3)
	subq.w	#6,a3

.next:	lea	10(a3),a3
	bra.s	.loop

.done:	movem.l	(sp)+,d0-a6
	rts		


	ENDIF

;------------------

;------------------------------------------------------------------------------
*
* UnPatchList	Remove library patches using a list. Call this under Forbid()
*		after having checked with CheckUnPatch.
*
* INPUT		a0	List.
*		d0	Bitfield of entries to concider.
*
;------------------------------------------------------------------------------
	IFD	xxx_UnPatchList
UnPatchList:
	movem.l	d0-a6,-(sp)
	lea	plf_base(pc),a4
	move.l	a0,a3
	move.l	d0,d7
	move.l	4.w,a6

.loop:	move.w	(a3)+,d0
	beq.s	.done
	and.w	d7,d0
	beq.s	.next

	move.w	(a3)+,a1
	add.l	a4,a1
	move.l	(a1),a1
	move.w	(a3)+,a0
	move.l	2(a3),d0
	jsr	-420(a6)		;SetFunction()
	subq.w	#4,a3

.next:	lea	10(a3),a3
	bra.s	.loop

.done:	movem.l	(sp)+,d0-a6
	rts		


	ENDIF

;------------------

;------------------------------------------------------------------------------
*
* CheckUnPatch	Check if all entries can be unpatched. Call under Forbid()!
*
* INPUT		a0	List.
*		d0	Bitfield of entries to concider.
*
* RESULT	d0	0 if all okay, else -1.
*		ccr	On d0.
*
;------------------------------------------------------------------------------
	IFD	xxx_CheckUnPatch
CheckUnPatch:
	movem.l	d1-a6,-(sp)
	lea	plf_base(pc),a4
	move.l	a0,a3
	move.l	d0,d7
	move.l	4.w,a6

.loop:	move.w	(a3)+,d0
	beq.s	.okay
	and.w	d7,d0
	beq.s	.next

	move.w	(a3)+,a1
	add.l	a4,a1
	move.l	(a1),a1
	move.w	(a3)+,a0
	movem.l	a0/a1,-(sp)
	move.l	2(a3),d0
	jsr	-420(a6)		;SetFunction()
	move.l	d0,d4
	movem.l	(sp)+,a0/a1
	jsr	-420(a6)		;SetFunction()
	move.w	(a3),d0
	ext.l	d0
	add.l	a4,d0
	sub.l	d4,d0			;still there?
	bne.s	.done
	subq.w	#4,a3

.next:	lea	10(a3),a3
	bra.s	.loop

.okay:	moveq	#0,d0
.done:	movem.l	(sp)+,d1-a6
	rts		


	ENDIF

;------------------

;--------------------------------------------------------------------

PLFPatch_	MACRO		;libbase, vector, new, old_label, flag
	IFC	'\5',''
	dc.w	-1
	ELSE
	dc.w	\5
	ENDC
	dc.w	\1-plf_base,\2,\3-plf_base
\4:	dc.l	0
	ENDM

PLFEnd_	MACRO
	dc.w	0
	ENDM


;--------------------------------------------------------------------

;------------------
	base	plf_oldbase

;------------------
	endif

	end

