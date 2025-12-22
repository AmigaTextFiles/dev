		********************************
		*                              *
		*            FarCom            *
		*       Part I - SendText      *
		*                              *
		*     by Torsten Jürgeleit     *
		*                              *
		********************************

	NOLIST
	INCLUDE "exec/types.i"
	INCLUDE "exec/memory.i"
	INCLUDE "exec/ports.i"
	INCLUDE "exec/nodes.i"
	INCLUDE "exec/libraries.i"
	INCLUDE "libraries/dosextens.i"
	INCLUDE "farcom.i"
	LIST

;---------------------------------------------------------------------------
; External references
;---------------------------------------------------------------------------

	XREF	_SendIt

;---------------------------------------------------------------------------
; VOID SendText(BYTE *format, ...)
;
; Builds an argument string and passes it to SendIt()
;---------------------------------------------------------------------------
	XREF	_SendText
_SendText:
	PUSH	d0-d1/d7/a0-a4/a6

	; --- alloc buffer for argument string
	move.l	#MAX_ARG_STRING_LEN+1,d0	; d0 := buffer size
	move.l	#MEMF_PUBLIC|MEMF_CLEAR,d1	; d1 := mem attr
	move.l	(4).w,a6			; a6 := exec base
	CALLSYS	AllocMem
	tst.l	d0
	beq	st_exit
	move.l	d0,a4				; a4 := arg string buffer

	; --- build argument string
	move.l	4+9*4(sp),a0			; a0 := format
	lea	8+9*4(sp),a1			; a1 := args
	lea	put_char(pc),a2			; a2 := put char routine
	move.l	a4,a3				; a3 := arg string buffer
	moveq	#0,d7				; d7 := char count
	CALLSYS	RawDoFmt

	; --- pass argument string to SendIt()
	move.w	#FM_ADDTXT,-(sp)		; cmd
	clr.l	-(sp)				; ident
	move.l	a4,-(sp)			; text
	CALL	_SendIt
	lea	10(sp),sp			; stack correction

	; --- free argument string buffer
	move.l	a4,a1				; a1 := buffer
	move.l	#MAX_ARG_STRING_LEN+1,d0	; d0 := buffer size
	CALLSYS	FreeMem

st_exit:
	PULL	d0-d1/d7/a0-a4/a6
	rts

;---------------------------------------------------------------------------
; Put chararcter in string
;
; Input: d0.b = char
;        d7.w = char count
;	 a3   = string ptr
;---------------------------------------------------------------------------

put_char:
	tst.b	d0
	beq	pc_put_char
	cmp.w	#MAX_ARG_STRING_LEN,d7		; check char count
	bge	pc_exit

pc_put_char:
	move.b	d0,(a3)+			; put char
	addq.w	#1,d7				; inc char count

pc_exit:
	rts

	END
