*********************************************************************************
* HeartBeat Assembler Modules
* ---------------------------
* Written by Laurence Vanhelsuwé © April 1992
*
* This files contains the generic "patches" that are attached to selected system
* calls via their library vectors.
*
* Every patch has a little structure in front of the routine that enables 'C'
* to make a copy of the routine and patch selected pointers to create a unqique
* patch for every system call.
*********************************************************************************

		include	std

;-------------------------------------------------------------------------
		RSRESET	Context	(same as 'C' version !!)
ctxt_regvals	RS.L	16			; 16 LONGS for D0-D7/A0-A7
ctxt_regmasks	RS.L	16			; 16 MASKS for above
ctxt_freeze	RS.W	1			; should we freeze ?
ctxt_frozen	RS.W	1			; we're frozen !
ctxt_sizeof	rs.w	0
;-------------------------------------------------------------------------

		XREF	_SNOOP_TASK		;struct Task *
		XDEF	_WEDGE

XXXXXXXX	equ	$ABCDEF86		; a dummy long absolute

;-------------------------------------------------------------------------
; This is the generic system call wedge.
; First it increments the call counter (conditionally if SNOOP_TASK is set)
; Then it does a match check on the input registers and incr a second counter
; if there is a match.
;-------------------------------------------------------------------------

		dc.w	(global_tracking+2-_WEDGE)>>1	; CTXT PTR
		dc.w	(inc_global+2-_WEDGE)>>1	; CALL  CNT
		dc.w	(inc2+2-_WEDGE)>>1		; MATCH CNT
		dc.w	(chain_jmp+2-_WEDGE)>>1		; CHAIN PTR
		dc.w	(_NEXT_PATCH-_WEDGE)>>1		; LENGTH

_WEDGE:		movem.l	d0-d7/a0-a7,-(SP)	;SP-> D0..D7, A0..A7 in that order

	IFD dumpA0
		moveq	#$80-1,d7	;
		lea	$100,a1		;
dump_a0		move.b	(a0)+,(a1)+	;
		dbra	d7,dump_a0	;
	ENDC

		sf	d7			;assume not Task specific
		move.l	_SNOOP_TASK,d0		;do we have to check ONE Task?
		beq	inc_global		;yes,

		move.l	4.w,a6			;check whether caller is Task.
		cmp.l	ThisTask(a6),d0		;is it ?
		bne	global_tracking
		st	d7			;Task is target task.

inc_global	addq.l	#1,XXXXXXXX		;INCREMENT CALL COUNTER

global_tracking	lea	XXXXXXXX,a5		;GET PRIVATE CALL CONTEXT
		lea	(sp),a1			;point to saved registers
		jsr	match_regs		;check match (shared re-entrant)
		bne	no_match

inc2		addq.l	#1,XXXXXXXX		;INCREMENT MATCH COUNTER

no_match	movem.l	(SP)+,d0-d7/a0-a7
chain_jmp	jmp	XXXXXXXX		;CHAIN TO STANDARD ROUTINE

;-------------------------------------------------------------------------
_NEXT_PATCH:

******************************************************************************
** Re-entrant routine to determine template registers match.
** (this is common to all wedges to keep wedges small)
**
** A1 -> D0, D1, D2... A5, A6, A7
** A5 -> Context struct
** D7 = TRUE/FALSE Task is SNOOP_TASK
**
** RETURN EQ for match
**	  NE for no match
******************************************************************************

match_regs	lea	ctxt_regvals(a5),a2	;-> 16 register values
		lea	ctxt_regmasks(a5),a3	;-> 16 register don't care masks

		moveq	#16-1,d0		;check all 16 680x0 regs

check_register	move.l	(a3)+,d1		;get register mask
		and.l	(a1)+,d1		;mask out don't care bits
		cmp.l	(a2)+,d1		;did register match template ?

		dbne	d0,check_register	;exit as soon as match fails
		bne	didnt_match
;---------------
		tst.b	ctxt_freeze(a5)		;should we freeze SNOOP_TASK
		beq	did_match		;on match ?

		tst.b	d7			;ok, but are we sure caller is
		beq	did_match		;SNOOP_TASK ?

		move.l	4.w,a6			;yep, get signal to Wait() on
		moveq	#24,d0
		EXEC	AllocSignal
		tst.l	d0
		bmi	did_match

	; avoid nasty race conditions

	FORBID
		st	ctxt_frozen(a5)		;tell main we're frozen
		
		move.l	#1<<24,d0		;yes, freeze until HeartBeat
		EXEC	Wait			;wakes us up (signal 24)

		sf	ctxt_frozen(a5)		;we're not frozen any more...
	PERMIT

		moveq	#24,d0
		EXEC	FreeSignal		;leave SNOOP_TASK's signal free

did_match	moveq	#0,d0			;return EQ for match
		rts

didnt_match	moveq	#-1,d0			;return NE for no match
		rts
;-------------------------------------------------------------------------
		END
