*
* $Id: traphandler.asm 1.4 1998/04/18 15:45:53 olsen Exp olsen $
*
* :ts=8
*
* Blowup -- Catches and displays task errors
*
* Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
* Public Domain
*

	include	"exec/execbase.i"
	include	"exec/tasks.i"
	include	"exec/macros.i"

*****************************************************************************

	section	text,code

*****************************************************************************

	xref	_ShowCrashInfo

*****************************************************************************

	xdef	_TrapHandler
	xdef	@TrapHandler

_TrapHandler:
@TrapHandler:

	move.l	a0,-(sp)		; save A0, we are going to need it in a minute
	move.l	usp,a0			; as we are in supervisor mode this minute, this gets the user stack pointer
	movem.l	d0-d7/a0-a7,-(a0)	; push all registers on the user stack; A0 and A7 will need fixing
	move.l	(sp)+,8*4(a0)		; push the original contents of A0 into the stack
	move.l	a0,d0			; save this for later
	add.l	#4*16,d0		; fix the stack offset
	move.l	d0,(8+7)*4(a0)		; and push the correct user stack pointer into the stack

	move.l	_SysBase,a6		; get the ExecBase pointer, we are going to need it in a minute

	move.l	(sp)+,d2		; get the type of the trap
	cmp.l	#3,d2			; was it an address error?
	bne.b	.no_address_error	; skip the following if it isn't

	move.w	AttnFlags(a6),d0
	andi.w	#AFF_68010,d0		; is this a plain 68k machine?
	bne.b	.no_68k			; skip the following if it isn't

	addq.l	#8,sp			; skip the extra information the 68k puts into
					; the address error exception frame

.no_address_error:
.no_68k:
	moveq	#0,d3
	move.w	(sp)+,d3		; get the copy of the status register
	move.l	(sp),a2			; get the program counter of the offending command

	move.l	SysStkUpper(a6),sp	; get rid of the exception stack frame by using
					; the upper bound of the supervisor stack; this
					; is faster than walking through the entire
					; stack frame in order to find out how long it is

	move.l	a0,usp			; now get the user stack pointer ready...
	andi.w	#(~$2000),sr		; and switch back into user mode

	sub.l	a1,a1			; find the current task
	JSRLIB	FindTask		
	move.l	d0,a0
	move.l	TaskTrapCode(a6),a1	; get the exec default trap handler
	move.l	a1,TC_TRAPCODE(a0)	; patch the task trap handler so our code
					; will end in a well-defined state should
					; the crash info dump trigger another
					; trap; we don't want to rerun our custom
					; trap handler recursively

	move.l	d2,d0			; D0 = trap type
	move.l	a2,d1			; D1 = program counter
	move.l	d3,d2			; D2 = status register
	move.l	sp,a0			; A0 = register dump (d0-d7/a0-a7)

	bra	_ShowCrashInfo		; show what we got; this call never returns

*****************************************************************************

	section	data,data

*****************************************************************************

	xref	_SysBase

*****************************************************************************

	end
