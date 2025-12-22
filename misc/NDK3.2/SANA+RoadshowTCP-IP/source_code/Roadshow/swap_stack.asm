*
*	:ts=8
*
*	Copyright © 2017-2018 by Olaf Barthel. All Rights Reserved.
*
 
	include "exec/macros.i"
 
*----------------------------------------------------------------------
 
	section text,code
 
*----------------------------------------------------------------------
 
	xdef	_swap_stack_and_call
 
	;	long __asm swap_stack_and_call(register __a0 APTR parameter,
	;	                               register __a1 APTR function,
	;	                               register __a2 struct StackSwapStruct * stk,
	;	                               register __a6 struct Library * SysBase);
 
_swap_stack_and_call:
 
	movem.l	d2/d3/d4,-(sp)
 
	move.l	a0,d2		; Save these two as StackSwap() will end up
	move.l	a1,d3		; clobbering their contents.
 
	move.l	a2,a0
	JSRLIB	StackSwap
 
	move.l	d2,a0		; Restore the parameter
	move.l	d3,a1
	jsr	(a1)		; Invoke the routine to be called with A6=SysBase.
	move.l	d0,d4		; Save the return value
 
	move.l	a2,a0		; Restore the original stack.
	JSRLIB	StackSwap

	move.l	d4,d0		; Restore the return value
 
	movem.l	(sp)+,d2/d3/d4
	rts
 
*----------------------------------------------------------------------
 
	xdef	_get_sp
	xdef	@get_sp

	;	APTR get_sp(void);

_get_sp:
@get_sp:

	move.l	sp,d0
	rts
 
*----------------------------------------------------------------------
 
	end
