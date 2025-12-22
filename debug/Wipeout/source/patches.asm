*
* $Id: patches.asm 1.4 1998/04/12 19:08:06 olsen Exp olsen $
*
* :ts=8
*
* Wipeout -- Traces and munges memory and detects memory trashing
*
* Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
* Public Domain
*

	include "exec/types.i"
	include "exec/macros.i"

	section	text,code

*****************************************************************************

PATCH	macro

	xdef	_New\1FrontEnd
	xref	_New\1

_New\1FrontEnd:
	move.l	(sp),-(sp)		; Save the caller return address

	movem.l	d0-d7/a0-a7,-(sp)	; Save all registers

	move.l	sp,a2			; Save a pointer to the register dump

	JSRLIB	Forbid
	bsr	_New\1			; Call the new routine
	JSRLIB	Permit

	addq.l	#4,sp			; Skip register D0 on the stack
	movem.l	(sp)+,d1-d7/a0-a6	; Restore everything but D0 and A7
	addq.l	#4+4,sp			; Skip register A7 and SP on the stack

	move.l	#$D100DEAD,d1		; As a side-effect, this patch would
	move.l	#$A000DEAD,a0		; preserve the contents of the scratch
	move.l	#$A100DEAD,a1		; registers, which is not what we would
					; want to do; so we scratch them
	rts

	endm

*****************************************************************************

	PATCH	AllocMem
	PATCH	FreeMem

	PATCH	AllocVec
	PATCH	FreeVec

	PATCH	CreatePool
	PATCH	DeletePool

	PATCH	AllocPooled
	PATCH	FreePooled

*****************************************************************************

	end
