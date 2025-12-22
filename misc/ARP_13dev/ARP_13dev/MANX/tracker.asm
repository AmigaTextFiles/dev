; Glue routines for arp.library and MANX/AZTEC 'C'
; Copyright (C) 1987, Scott Ballantyne
; Use at your own risk, etc., etc.
; May be freely used.

	INCLUDE "exec/execbase.i"
	INCLUDE "libraries/arpbase.i"
	INCLUDE "libraries/dosextens.i"

; Variables used by 'C' to access certain extra arplibrary returns

	dseg
	public	_ArpBase
	public	_AbsExecBase
	cseg

FDECL	MACRO
	public	_\1
	_\1:
LIBOFF	SET	_LVO\1
	ENDM

ARPJMP	MACRO
	move.l	_ArpBase,a6
	jmp	LIBOFF(a6)
	ENDM

ARPCALL MACRO
	move.l	_ArpBase,a6
	jsr	LIBOFF(a6)
	ENDM


	FDECL	ArpAllocMem
	movem.l 4(sp),d0-d1
	ARPCALL

Check_Save:	tst.l		d0		; Check for return error...
		beq.s		Exit_Save	; If error, skip setting...
		far data
Save_Second:	move.l		_AbsExecBase,a0
		near data
		move.l		ThisTask(a0),a0
		move.l		a1,pr_Result2(a0)
Exit_Save:	rts

	FDECL	ArpOpen
	movem.l 4(sp),d1-d2
	ARPCALL
	bra.s	Check_Save

	FDECL	ArpDupLock
	move.l	4(sp),d1
	ARPCALL
	bra.s	Check_Save

	FDECL	ArpLock
	movem.l 4(sp),d1/d2
	ARPCALL
	bra.s	Check_Save

	FDECL	ArpAlloc
	move.l	4(sp),d0
	ARPCALL
	bra.s	Check_Save

	FDECL	RListAlloc
	move.l	4(sp),a0
	move.l	8(sp),d0
	ARPCALL
	bra.s	Check_Save

	FDECL	ArpOpenLibrary
	move.l	4(sp),a1
	move.l	8(sp),d0
	ARPCALL
	bra.s	Check_Save

	FDECL	ArpAllocFreq
	ARPCALL
	bra.s	Check_Save

	FDECL	GetTracker
	ARPCALL
		beq.s		No_Tracker	; No tracker, ERROR!
		move.w		6(sp),dt_ID(a1) ; Save ID  (It was LONG)
No_Tracker:	move.l		a1,d0		; Put into return register
		bra.s		Save_Second	; Also save it...

	END

