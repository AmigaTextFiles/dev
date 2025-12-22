
		;   LWP.ASM V1.03 22 December 1988
		;   Matthew Dillon
		;
		;   Light Weight Processes
		;
		;   Note:   Only AlertLWP() is asynchronously reentrant
		;	    (callable from interrupts and other tasks)

		INCLUDE "exec/types.i"
		INCLUDE "exec/ports.i"
		INCLUDE "exec/ables.i"

LW_NODE 	equ	0	    ;minimal node, 8 bytes
LW_STACK	equ	8	    ;stack ptr used when deallocating it
LW_STACKSIZE	equ	12	    ;stack size used when deallocating it
LW_ALERT	equ	16	    ;first byte used out of a short
LW_PC		equ	18	    ;pc saved on context switch
LW_REGS 	equ	22	    ;regs saved on context switch
LW_SIZE 	equ	22+48	    ;12 registers = 48 bytes (D2-D7/A2-A7) to end

LW_A2		equ	24	    ;relative to LW_REGS (D2-D7 == 24 bytes)
LW_A3		equ	LW_A2+4
LW_A4		equ	LW_A3+4
LW_A5		equ	LW_A4+4
LW_A6		equ	LW_A5+4
LW_A7		equ	LW_A6+4

LB_ALERT	equ	0
LB_LIMBO	equ	1

	    section DATA,DATA

		;   note: _LastLWPMem takes into account malloc's overhead
		;	  by guessing it is 8 bytes.  This is not entirely
		;	  correct if one changes to AllocMem()

		XDEF	_ThisLWP	; user readable (current lwp)
		XDEF	_LastLWPMem	; user readable (user information)
		XDEF	_CoreLWPStack	; user modifiable
		XDEF	_LWPAlloc	; user modifiable memory allocator
		XDEF	_LWPFree	; user modifiable memory freer
		XDEF	_LWPTask	; user modifiable 'task'

		XREF	_lmalloc	; default memory routines used
					; NOTE: must use 'lmalloc', a routine
					; which takes a LONGWORD argument,
					; so this module can be used with
					; either 16/32 bit integer compiler
					; options.
		XREF	_free

_LWPAlloc	dc.l	_lmalloc	; allocate/free function, can also
_LWPFree	dc.l	_free		;  set to AllocMem/FreeMem
_LWPTask	dc.l	0		; main task
_LastLWPMem	dc.l	0		; Last ForkLWP() allocated this much
_ThisLWP	dc.l	0		; Current LWP.	Also indicates LWPs running
_CoreLWPStack	dc.l	92+8+3		; 92 for EXEC, 8 for LWP calls if user
					;  specified 0, 3 for long word align

					; AutoAlert ptrs to LWPs for each signal bit
_LWPAutoAlert	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
_MasterStack	dc.l	0		; Global Stack (as of call to RunLWP())
_ReadyList	dc.l	_ReadyList+4	; LWPs ready to run (list header)
		dc.l	0
		dc.l	_ReadyList

	    section CODE

	    ;	All routines marked by A 'R' for 'REENTRANT' can be called
	    ;	from an LWP.  These must work even if the programmer
	    ;	specifies a 0 stack size.  In this case, currently only
	    ;	8 extra bytes are available.  Thus, these routines must
	    ;	work with only 8 bytes of stack.  These are synchronously
	    ;	reentrant only.

	    XREF    _LVOInsert
	    XREF    _LVORemove
	    XREF    _LVOSignal
	    XREF    _intena

	    XDEF    _ForkLWP		; R
	    XDEF    _SwitchLWP		; R
	    XDEF    _WaitLWP		; R
	    XDEF    _AlertLWP		; R
	    XDEF    _RunLWP		;
	    XDEF    _AutoAlertLWP	; R (set auto alert LWP for port)
	    XDEF    _CallBigStack	; R

	    ;	CallBigStack(function, argbytes, args ....)
	    ;		       8(A2)     12(A2)   16(A2)

_CallBigStack:
	    link    A2,#0
	    move.l  _MasterStack,sp	; use master stack pointer
	    move.l  12(A2),D0           ; # bytes (must be even)
	    lea     16(A2,D0.L),A0      ; A0 = points past last argument
	    lsr.l   #1,D0		; D0 = # of words to txfer
	    bra     .ms20
.ms10	    move.w  -(A0),-(sp)         ; copy args
.ms20	    dbf     D0,.ms10
	    move.l  8(A2),A0            ; function
	    jsr     (A0)                ; call it
	    unlk    A2			; restore old stack
	    rts

	    ;	AutoAlertLWP(port, lwp/NULL)
	    ;
	    ;	Port must have mp_SigBit setup
	    ;	this call modifies mp_Flags & mp_Task

_AutoAlertLWP:
	    link    A2,#0
	    tst.l   _ThisLWP			; running under an LWP?
	    beq     .aa10
	    move.l  _MasterStack,sp		; yes, use master stack
.aa10	    move.l  A6,-(sp)                    ; save A6
	    move.l  4,A6
	    move.l  ThisTask(A6),_LWPTask       ; remember the calling task!
	    lea     _LWPAutoAlert,A1
	    move.l  8(A2),A0                    ; port to modify
	    move.l  12(A2),D0                   ; lwp to alert
	    move.b  MP_SIGBIT(A0),D1            ; D1.W is signal bit
	    and.w   #31,D1
	    asl.w   #2,D1			; x 4 array index
	    move.l  D0,0(A1,D1.W)               ; save the LWP to alert
	    beq     .aa50
						; SETUP LWP
	    move.b  #2,MP_FLAGS(A0)             ; Temp. Ignore
	    move.l  #PortAlert,MP_SIGTASK(A0)   ; special call routine
	    move.b  #3,MP_FLAGS(A0)             ; call mode
	    move.l  MP_MSGLIST(A0),A1           ; get head
	    tst.l   (A1)
	    beq     .aa20			; call alert?
	    DISABLE
	    move.l  A0,A1
	    bsr     PortAlert
	    ENABLE
.aa20	    move.l  (sp)+,A6
	    unlk    A2
	    rts

.aa50
	    move.b  #2,MP_FLAGS(A0)             ; Temp. Ignore
	    move.l  ThisTask(A6),MP_SIGTASK(A0) ; setup task field
	    move.b  #0,MP_FLAGS(A0)             ; setup flags to PA_SIGNAL
	    move.l  MP_MSGLIST(A0),A1
	    tst.l   (A1)                        ; messages exist on list
	    beq     .aa60
	    move.l  MP_SIGTASK(A0),A1           ; Signal(A1,D0)
	    move.b  MP_SIGBIT(A0),D1
	    moveq.l #0,D0
	    bset    D1,D0			; D0 = 1 << mp_SigBit
	    jsr     _LVOSignal(A6)
.aa60	    move.l  (sp)+,A6                    ; restore A6
	    unlk    A2				; restore stack
	    rts

	    ;	Called by exec with interrupts disabled, port in A1, EXEC
	    ;	base reg in A6.  lookup LWP and alert it.

PortAlert:  move.b  MP_SIGBIT(A1),D0
	    tst.l   _ThisLWP			; is the LWP system running?
	    bne     .pal1
	    move.w  D0,D1			; no, set EXEC signal
	    moveq.l #0,D0
	    bset    D1,D0
	    move.w  D1,-(sp)                    ; D1 = sigbit, 0 = mask
	    move.l  _LWPTask,A1 		; A1 = destination task
	    jsr     _LVOSignal(A6)              ; Signal(A1,D0)
	    move.w  (sp)+,D0                    ; D0 = sigbit

						; yes, alert LWP and do NOT
						; set EXEC signal
.pal1	    lea     _LWPAutoAlert,A0		; array base
	    and.w   #31,D0
	    asl.w   #2,D0
	    move.l  0(A0,D0.W),D0               ; LWP to alert
	    beq     .pal50
	    move.l  D0,A0
	    bclr.b  #LB_LIMBO,LW_ALERT(A0)      ; in limbo?
	    beq     .pal10			; no, already on ready list
	    lea.l   _ReadyList,A1		; yes, add to ready list
	    move.l  (A1),(A0)                   ; node->succ = list->head
	    move.l  A1,4(A0)                    ; node->pred = &list->head
	    move.l  A0,(A1)                     ; list->head = node
	    move.l  (A0),A1                     ; node->succ ...
	    move.l  A0,4(A1)                    ; node->succ->pred = node
.pal10	    bset.b  #LB_ALERT,LW_ALERT(A0)      ; set alert bit
.pal50	    rts


	    ;	RunLWP()
	    ;
	    ;	run all active LWPs until none ready to run.  Returns 0
	    ;	if there are no LWPs ready to run, 1 if there were LWPs
	    ;	run.  This call does not return until the ReadyList is
	    ;	empty (no LWPs ready to run or all deleted)

_RunLWP:    tst.l   _ThisLWP		; can't call RunLWP from an LWP.
	    bne     .rl9
	    move.l  _ReadyList,A1
	    tst.l   (A1)
	    bne     .rl10
	    moveq.l #0,D0
.rl9	    rts 			; no lwp's ready to run
.rl10	    movem.l D2-D7/A2-A6,-(sp)   ; save registers
	    pea     _RunReturn
	    move.l  sp,_MasterStack
	    bra     CtxA1		; one sided context switch
_RunReturn: movem.l (sp)+,D2-D7/A2-A6   ; no lwp's to run, but some ran
	    clr.l   _ThisLWP		; set _ThisLWP to NULL
	    move.l  _ReadyList,A1	; then re-test if any ready to go
					; (required to close timing window)
	    tst.l   (A1)
	    bne     .rl10
	    moveq.l #1,D0		; LWP did run
	    rts

	    ;	ForkLWP(stack, arglen)
	    ;
	    ;	This call converts the subroutine that called it into an
	    ;	LWP by allocating an LWP descriptor and new stack of size
	    ;	stack+arglen+LOCAL where LOCAL is the stack required by
	    ;	the subroutine's local variables and saved registers, etc..
	    ;	(essentially, anything allocated when ForkLWP() was called).
	    ;
	    ;	Note: the subroutine that calls this routine must use the
	    ;	link/unlk convention with A5 for the link register, and
	    ;	in addition must NOT destroy any register D2-D7/A2-A6 before
	    ;	making this call because ForkLWP() will return to the caller
	    ;	of the subroutine when done rather than the subroutine itself
	    ;	(the context is setup so when the new LWP is run, it starts
	    ;	 at the point where ForkLWP() would have otherwised normally
	    ;	 returned to the subroutine.
	    ;
	    ;	ForkLWP() may be called by a LWP which effectively replaces
	    ;	that LWP's stack with another one.  In this case, since a
	    ;	create-new-delete-old sequence occurs, the addresses of
	    ;	local variables will be different and the old LWP descriptor
	    ;	will be invalid.

_ForkLWP:   link    A2,#0		; 4(A2)=ret addr 8(a2)=stk 12(a2)=arglen
	    tst.l   _ThisLWP
	    beq     .il1		; use master stack if called from a LWP
	    move.l  _MasterStack,sp

.il1	    clr.l   _LastLWPMem
	    movem.l D2-D7/A2-A6,-(sp)   ; Save regs.
	    move.l  4,A6		; ExecBase

	    move.l  8(A2),D0            ; next longword sized stack.
	    add.l   _CoreLWPStack,D0	; required minimum stack, includes 3
					;  for LW align.
	    and.b   #$FC,D0
	    move.l  D0,8(A2)
	    move.l  12(A2),D0           ; next longword sized arglen.
	    addq.l  #3,D0
	    and.b   #$FC,D0
	    move.l  D0,12(A2)

	    move.l  #LW_SIZE,D0 	; AllocMem the LWP structure
	    bsr     AllocMyMem
	    beq     .ilfail
	    move.l  D0,A3		; A3 == LWP structure pointer
	    clr.b   LW_ALERT(A3)

	    move.w  #44-4,D0		; copy 11 registers to context
.il5	    move.l  0(sp,D0.W),LW_REGS(A3,D0.W)
	    subq.w  #4,D0
	    bcc     .il5
	    move.l  (A2),LW_REGS+LW_A2(A3)

	    move.l  A5,D2
	    sub.l   A2,D2
	    add.l   12(A2),D2           ; D2 = copysize (A5 - A2 + arglen)
	    move.l  8(A2),D0
	    add.l   D2,D0		; D0 = total stack size
	    move.l  D0,LW_STACKSIZE(A3) ; save into lwp structure
	    bsr     AllocMyMem
	    beq     .ilfail2
	    move.l  LW_STACKSIZE(A3),_LastLWPMem
	    add.l   #LW_SIZE+8,_LastLWPMem
	    move.l  D0,LW_STACK(A3)     ; save into lwp structure
	    move.l  D0,A0		; A0 = pointer to stack start
	    add.l   8(A2),A0            ; A0 = start of dest copy area
	    move.l  A0,-(sp)            ; (save start of dest copy area)
	    lea     8(A2),A1            ; A1 source
	    move.l  D2,D0
	    lsr.l   #1,D0		; D0 = # of words, at least 4
.il10	    move.w  (A1)+,(A0)+
	    subq.l  #1,D0
	    bne     .il10		; when done, A0 will be at stack end.

	    move.l  A0,A1
	    sub.l   12(A2),A1           ; A1 skip back to lwp subr's ret addr
	    move.l  #_DeleteLWP,-(A1)   ; set ret addr to lwp killer
	    move.l  A0,-(A1)            ; garbage, not required
	    move.l  A1,LW_REGS+LW_A5(A3) ; lwp subr's A5 reg.

	    move.l  (sp)+,A0            ; A0 now start of copy area
	    move.l  A0,LW_REGS+LW_A7(A3) ; ..is stack ptr on lwp resume

	    move.l  4(A2),LW_PC(A3)     ; ..set pc to ret addr of this routine

	    lea     _ReadyList,A0	; list
	    move.l  A3,A1		; node
	    move.l  _ThisLWP,A2 	; insert after (ensures this is next run lwp)
	    jsr     _LVOInsert(A6)      ; now a valid lwp.

.ilret	    move.l  A3,D0		; return the LWP descriptor
	    movem.l (sp)+,D2-D7/A2-A6   ; restore registers note
	    unlk    A2			; unlink
	    rts 			; and return (lwp desc)

.ilfail2:   move.l  A3,A1		; failure, free the LWP descriptor
	    move.l  #LW_SIZE,D0
	    bsr     FreeMyMem

.ilfail:    sub.l   A3,A3		; return NULL
	    bra     .ilret

	    ;	SwitchLWP()
	    ;
	    ;	Switch to next ready LWP (used to share the CPU in tight
	    ;	loops).  Is a fast nop if no other LWPs ready.
	    ;
	    ;	returns 1 if nobody to switch to (the fast nop), 0 otherwise

_SwitchLWP: move.l  _ThisLWP,A0     ; current lwp
	    move.l  LN_SUCC(A0),A1  ; next lwp
	    tst.l   (A1)            ; end of list?
	    bne     CtxA0A1
	    move.l  -4(A1),A1       ; yes, get head
	    cmp.l   A0,A1
	    bne     CtxA0A1
	    moveq.l #1,D0
	    rts 		    ; only one lwp ready, let it run
CtxA0A1     move.l  (sp)+,LW_PC(A0) ; switch to next ready lwp
	    movem.l D2-D7/A2-A7,LW_REGS(A0)
CtxA1	    movem.l LW_REGS(A1),D2-D7/A2-A7
	    move.l  LW_PC(A1),A0
	    move.l  A1,_ThisLWP
	    moveq.l #0,D0	    ; return 0 (so ForkLWP() returns 0)
	    jmp     (A0)

	    ;	DeleteLWP() is called from an lwp context.  Since we are
	    ;	deleting it, we can trash any register but A4 which is used
	    ;	for the small data model base pointer.
	    ;
	    ;	note that we use the MasterStack because we will be making
	    ;	EXEC calls and do not know how much stack we actually have
	    ;	left in the LWP.

_DeleteLWP: move.l  _MasterStack,sp	    ; use the master stack since we
	    move.l  4,A6		    ;  will deallocate the LWPs
	    move.l  _ThisLWP,A2
	    DISABLE
	    move.l  A2,A1		    ; Remove the lwp
	    move.l  (A2),A3                 ; A3 = next lwp
	    jsr     _LVORemove(A6)
	    ENABLE
	    move.l  LW_STACK(A2),A1         ; then free its stack
	    move.l  LW_STACKSIZE(A2),D0
	    bsr     FreeMyMem
	    move.l  A2,A1
	    move.l  #LW_SIZE,D0
	    bsr     FreeMyMem

	    move.l  A3,A1
	    tst.l   (A1)                    ; valid next lwp
	    bne     CtxA1
	    move.l  _ReadyList,A1	    ; no next, get list head
	    tst.l   (A1)
	    bne     CtxA1
	    rts 			    ; RTS from MasterStack -> RunLWP

	    ;	WaitLWP()
	    ;
	    ;	Wait until alerted.  If already alerted this call is
	    ;	equivalent to a SwitchLWP().  Otherwise, unlink and
	    ;	then do a SwitchLWP().
	    ;
	    ;	Note that if there are no LWPs ready to run after unlinking,
	    ;	we return to the overall RunLWP() routine via an RTS from
	    ;	MasterStack.

_WaitLWP:   move.l  A6,-(sp)
	    move.l  4,A6
	    DISABLE
	    move.l  _ThisLWP,A0
	    bclr.b  #LB_ALERT,LW_ALERT(A0)  ; if lwp already alerted
	    beq     .wl5
	    ENABLE
	    move.l  (sp)+,A6
	    bra     _SwitchLWP

.wl5	    bset.b  #LB_LIMBO,LW_ALERT(A0)  ; not, set flag as being in limbo
	    move.l  A0,-(sp)                ; Remove(A0)
	    move.l  LN_SUCC(A0),A1          ; A1 = successor to run
	    move.l  LN_PRED(A0),A0
	    move.l  A0,LN_PRED(A1)
	    move.l  A1,LN_SUCC(A0)

	    ENABLE
	    move.l  (sp)+,A0                ; A0 = guy just removed, now in limbo
	    move.l  (sp)+,A6
	    tst.l   (A1)                    ; A1 = successor.  valid node?
	    bne     .wl10		    ; yes, switch to new context
	    move.l  -4(A1),A1               ; no, circular list, get head
	    tst.l   (A1)                    ; empty list?
	    bne     .wl10		    ; no, switch to new context
	    move.l  _MasterStack,sp	    ; yes, nobody to switch to
	    rts
.wl10	    move.l  A0,-(sp)
	    bsr     CtxA0A1
	    move.l  (sp)+,A0                ; (on return)
	    bclr.b  #LB_ALERT,LW_ALERT(A0)  ; clear LB_ALERT again for efficiency
	    rts

	    ;	AlertLWP(lwp:4(sp))
	    ;
	    ;	This routine alerts a light weight process, causing it to
	    ;	be placed on the ready list and also setting the alert
	    ;	flag so the next WaitLWP() call made by the lwp will fall
	    ;	through (if it is not already waiting)

_AlertLWP:  move.l  4(sp),D0                ; LWP to alert
	    beq     .al40
	    move.l  A6,-(sp)
	    move.l  4,A6
	    DISABLE
	    move.l  D0,A0
	    bclr.b  #LB_LIMBO,LW_ALERT(A0)  ; in limbo?
	    beq     .al10		    ; no, already on ready list
	    lea.l   _ReadyList,A1	    ; yes, add to ready list
	    move.l  (A1),(A0)               ; node->succ = list->head
	    move.l  A1,4(A0)                ; node->pred = &list->head
	    move.l  A0,(A1)                 ; list->head = node
	    move.l  (A0),A1                 ; node->succ->pred = node
	    move.l  A0,4(A1)
.al10	    bset.b  #LB_ALERT,LW_ALERT(A0)  ; set alert bit
	    ENABLE
	    move.l  (sp)+,A6
.al40	    rts

AllocMyMem: movem.l D2/D3/A6,-(sp)
	    clr.l   -(sp)               ; for AllocMem
	    move.l  D0,-(sp)            ; for malloc/AllocMem
	    move.l  _LWPAlloc,A0
	    jsr     (A0)
	    addq.l  #8,sp
	    movem.l (sp)+,D2/D3/A6
	    tst.l   D0
	    rts

FreeMyMem:  movem.l D2/D3/A6,-(sp)
	    move.l  D0,-(sp)
	    move.l  A1,-(sp)
	    move.l  _LWPFree,A0
	    jsr     (A0)
	    addq.l  #8,sp
	    movem.l (sp)+,D2/D3/A6
	    rts

	    END

