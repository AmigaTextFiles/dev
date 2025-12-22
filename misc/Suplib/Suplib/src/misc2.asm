

		section DATA,DATA

		xref	_SysBase

		section CODE

		include "exec/types.i"
		include "exec/ports.i"
		include "exec/tasks.i"
		include "exec/execbase.i"
		include "exec/ables.i"
		include "exec/memory.i"


		;   NOTE:   LockAddr/UnLockAddr referenced elsewhere in
		;	    this library
		;   MISC2.ASM

		xref	_LVOPutMsg
		xdef	_DoSyncMsg
		xdef	_WaitMsg

_DoSyncMsg:	movem.l 4(sp),A0/A1
		movem.l A2/A3/A6,-(sp)              ; A0=port, A1=msg
		move.l	_SysBase,A6		    ; A6=execbase

		sub.w	#MP_SIZE,sp		    ; initialize reply port
		move.b	#NT_MSGPORT,LN_TYPE(sp)
		move.b	#PA_SIGNAL,MP_FLAGS(sp)
		move.b	#4,MP_SIGBIT(sp)            ; EXEC semaphore signal
		move.l	ThisTask(A6),MP_SIGTASK(sp)
		lea	MP_MSGLIST(sp),A2
		lea	MP_MSGLIST+4(sp),A3
		move.l	A3,(A2)                     ; &tail -> head
		move.l	#0,(A3)                     ; NULL  -> tail
		move.l	A2,8(A2)                    ; &head -> tailpred

		move.l	sp,MN_REPLYPORT(A1)
		move.l	A1,A2			    ; save message
		jsr	_LVOPutMsg(A6)              ; send the message

		move.l	A2,-(sp)
		bsr	_WaitMsg
		addq.l	#4,sp

		add.w	#MP_SIZE,sp
		movem.l (sp)+,A2/A3/A6
		rts

		xdef	_CheckMsg

_CheckMsg:	move.l	4(sp),A0
		moveq.l #0,D0
		cmp.b	#NT_MESSAGE,LN_TYPE(A0) ;NT_MESSAGE == not replied
		beq	.lcm1
		move.l	A0,D0
.lcm1		rts

		xdef	_CheckPort

_CheckPort:	move.l	4(sp),A0
		moveq.l #0,D0
		move.l	MP_MSGLIST+LH_HEAD(A0),A0
		tst.l	(A0)                    ;list empty?
		beq	.lcp1
		move.l	A0,D0			;no, return first element
.lcp1		rts

		xref	_LVOWait
		xref	_LVORemove
		xref	_LVODisable
		xref	_LVOEnable

		xdef	_WaitMsg

_WaitMsg:	move.l	4(sp),A0
		movem.l A2/A3/A6,-(sp)
		move.l	A0,A2			;A2 = message
		move.l	MN_REPLYPORT(A0),A3     ;A3 = replyport
		move.l	_SysBase,A6		;A6 = execbase
.wmloop 	cmp.b	#NT_MESSAGE,LN_TYPE(A2) ;while msg not replied
		bne	.wm1
		move.b	MP_SIGBIT(A3),D1        ;Wait on port signal
		moveq.l #0,D0
		bset.l	D1,D0
		jsr	_LVOWait(A6)
		bra	.wmloop
.wm1		jsr	_LVODisable(A6)         ;remove from port
		move.l	A2,A1			;A1 = message (A2)
		jsr	_LVORemove(A6)
		jsr	_LVOEnable(A6)
		move.l	A2,D0			;return message
		movem.l (sp)+,A2/A3/A6
		rts

		;WILDCMP(wild:D0, name:D1)
		;
		;   Handles * and ?
		;
		;result:  D0, 0 = no match, 1 = match
		;
		;auto:
		;   D2	bi
		;   A2	wildcard string
		;   A3	name	 string
		;   A4	back-array (of size MAXB * 2 * 4)

MAXB		EQU	8

		xdef	_WildCmp

_WildCmp:	movem.l 4(sp),D0/D1
		movem.l D2/A2-A4,-(sp)
		move.l	D0,A2
		move.l	D1,A3
		sub.l	#MAXB*2*8,sp
		move.l	sp,A4

		moveq.l #0,D2

.wcloop 	moveq.l #1,D0
		move.b	(A2),D1
		bne	.w1
		tst.b	(A3)
		beq	.wcdone

.w1		cmp.b	#'*',D1
		bne	.w10
		cmp.w	#MAXB,D2
		bne	.w2
		moveq.l #-1,D0		; error
		bra	.wcdone
.w2		move.w	D2,D0		; back[bi][0] = w  i.e. back+bi*8
		asl.w	#3,D0		; back[bi][1] = n
		move.l	A2,0(A4,D0.w)
		move.l	A3,4(A4,D0.w)
		addq.w	#1,D2
		addq.l	#1,A2
		bra	.wcloop

.wgoback	subq.w	#1,D2
		bmi	.w5
		move.w	D2,D0
		asl.w	#3,D0
		move.l	4(A4,D0.w),A0
		tst.b	(A0)
		beq	.wgoback
.w5		tst.w	D2
		bmi	.wcret0
		move.w	D2,D0
		asl.w	#3,D0
		move.l	0(A4,D0.w),A2
		addq.l	#1,A2
		add.l	#1,4(A4,D0.w)
		move.l	4(A4,D0.w),A3
		addq.l	#1,D2
		bra	.wcloop

.w10		cmp.b	#'?',D1
		bne	.w20
		tst.b	(A3)
		bne	.wcbreak
		tst.w	D2
		bne	.wgoback
		bra	.wcret0

.w20		move.b	(A3),D0
		cmp.b	#'A',D0
		bcs	.w21
		cmp.b	#'Z',D0
		bhi	.w21
		or.b	#$20,D0
.w21		move.b	(A2),D1
		cmp.b	#'A',D1
		bcs	.w22
		cmp.b	#'Z',D1
		bhi	.w22
		or.b	#$20,D1
.w22		cmp.b	D0,D1
		beq	.wcbreak
		tst.w	D2
		bne	.wgoback
		bra	.wcret0

.wcbreak	tst.b	(A2)+
		bne	.wcb1
		subq.l	#1,A2
.wcb1		tst.b	(A3)+
		bne	.wcb2
		subq.l	#1,A3
.wcb2		bra	.wcloop

.wcret0 	moveq.l #0,D0
.wcdone 	add.l	#MAXB*2*8,sp
		movem.l (sp)+,D2/A2-A4
		rts

		;			LOCKS
		;
		;   {			    LOCKADDR STRUCTURE
		;	ulong	Link;	    dynamic linking of blocked requests
		;	ubyte	LockByte;   bset to here
		;	ubyte	Reserved;   reserved for future use (flags?)
		;			    EXTENSIONS FOR TASKLOCK
		;	uword	Refs;	    reference count same-task has-locked
		;	ulong	Task;	    task address
		;   }
		;
		;   long var[3] = { 0, 0, 0 };
		;
		;   These routines work exactly like the lockaddr but maintain
		;   an additional reference count, allowing the same task to
		;   lock the same lock any number of times (the same number of
		;   unlocks are required to unlock the lock)
		;
		;   Only one lock is available per structure
		;
		;   TaskLock(&var[0]:A0)
		;   TaskUnlock(&var[0]:A0)

_lTaskLock:
		move.l	_SysBase,A1	; task address used for ident
		move.l	ThisTask(A1),A1
		bset.b	#0,4(A0)        ; try to get lock fast
		beq	.tl10		; beq success
		cmp.l	8(A0),A1        ; failure, but is it the same task?
		beq	.tl11		; yes, success
		movem.l A0/A1,-(sp)     ; failure, different task, block.
		moveq.l #0,D0		; D0 = bit#, A0 = lock ptr
		bsr	LA0		; get lock the hard way
		movem.l (sp)+,A0/A1
.tl10		move.l	A1,8(A0)        ; success, store owner
.tl11		add.w	#1,6(A0)        ; success, bump ref count
		rts

;;BREAKUP   lockaddr.asm

		;   long var[2] = { 0, 0 };
		;
		;   These routines provide fast exclusive
		;   locks.  Up to 8 independant locks may be used for
		;   each 4 byte address.
		;
		;   LockAddr(&var[0]:A0)
		;   LockAddrB(bit:D0, &var[0]:A0)
		;   UnlockAddr(&var[0]:A0)
		;   UnlockAddrB(bit:D0, &var[0]:A0)
		;   TryLockAddr(&var[0]:A0)
		;   TryLockAddrB(bit:D0, &var[0]:A0)

		xref	_LVOWait
		xref	_LVOForbid
		xref	_LVOPermit

		xdef	_LockAddr
		xdef	_LockAddrB
		xdef	_TryLockAddr
		xdef	_TryLockAddrB
	       IFD LATTICE
		xdef	@LockAddr
		xdef	@LockAddrB
		xdef	@TryLockAddr
		xdef	@TryLockAddrB
	       ENDC

_TryLockAddrB:	movem.l 4(sp),D0/A0
		bra	TLA0
_TryLockAddr:
		move.l	4(sp),A0

	       IFD LATTICE
@TryLockAddr:
	       ENDC
		moveq.l #0,D0
	       IFD LATTICE
@TryLockAddrB:
	       ENDC

TLA0:		bset.b	D0,4(A0)                ; attempt to gain lock
		bne	.tla10			; failure
		moveq.l #1,D0
		rts				; success, return 1
.tla10		moveq.l #-1,D0			; failure, return -1
		rts



_LockAddrB:	movem.l 4(sp),D0/A0             ; bit: D0    lock: A0
		bra	LA0
_LockAddr:					; bit: 0     lock: A0
		move.l	4(sp),A0

		;	MAIN LOCK CODE

	       IFD LATTICE
@LockAddr:
	       ENDC
		moveq.l #0,D0
	       IFD LATTICE
@LockAddrB:
	       ENDC
LA0:		bset.b	D0,4(A0)                ; attempt to gain lock
		bne	.la10			; failure
		rts				; success, done, rts (FAST)

.la10		movem.l A2/A6,-(sp)             ; failure (SLOW) (BLOCK)
		move.l	_SysBase,A6		; A6 = SYSBase
		FORBID
		bset.b	D0,4(A0)                ; try again after FORBID
		beq	.la20			; got it!

		;   Put linked list structure on stack

		move.w	D0,-(sp)                ; bit#    12(sp)
		move.l	ThisTask(A6),-(sp)      ; task#    8(sp)
		move.l	A0,-(sp)                ; &var     4(sp)
		move.l	(A0),-(sp)              ; Next      (sp)
		move.l	sp,(A0)                 ; (put at head of list)

		;   Loop Wait/re-attempt lock

.la15		moveq.l #$10,D0 		; wait (semaphore signal)
		jsr	_LVOWait(A6)

		move.w	12(sp),D0               ; try for lock
		move.l	4(sp),A0
		bset.b	D0,4(A0)
		bne	.la15			; loop until get it

.la16		cmp.l	(A0),sp                 ; unlink, find our node!
		beq	.la18
		move.l	(A0),A0
		bra	.la16
.la18		move.l	(sp),(A0)
		add.w	#14,sp
.la20
		PERMIT
		movem.l (sp)+,A2/A6
		rts

;;BREAKUP   unlockaddr.asm

		;   TaskUnlock() works on an expanded lock (see TaskLock() above)
		;   while UnlockAddr[B] works on a basic lock.

		xdef	_TaskUnlock

_TaskUnlock:	move.l	4(sp),A0

		sub.w	#1,6(A0)    ; decrement reference count
		bne	.tu10	    ; non-zero, do not release lock yet
		moveq.l #0,D0	    ; D0 = 0 (needed for ULW)
		move.l	D0,8(A0)    ; clear the owner field

				    ; this repeats some of the unlock code
		bclr.b	#0,4(A0)    ; clear the lock
		move.l	(A0),D1     ; Anybody waiting to get the lock?
		bne	ULW	    ; yes, branch to unlock code
.tu10		rts		    ; no, return immediately.

		xref	_LVOSignal
		xref	_LVOForbid
		xref	_LVOPermit

		xdef	_UnlockAddr
		xdef	_UnlockAddrB
	       IFD LATTICE
		xdef	@UnlockAddr
		xdef	@UnlockAddrB
	       ENDC

_UnlockAddrB:	movem.l 4(sp),D0/A0
		bra.s	UL0
_UnlockAddr:	move.l	4(sp),A0
	       IFD LATTICE
@UnlockAddr:
	       ENDC
		moveq.l #0,D0
	       IFD LATTICE
@UnlockAddrB:
	       ENDC

UL0:		bclr.b	D0,4(A0)                ; clear lock bit
		move.l	(A0),D1                 ; anybody waiting?
		beq	.ulrts			; no, rts
ULW:
		movem.l D2/A2/A6,-(sp)          ; yes, wake 'm all up
		move.b	D0,D2			; D2 = bit#
		move.l	_SysBase,A6		; A6 = SYSBase
		FORBID

		move.l	(A0),D1                 ; get pointer again after FORBID
		beq	.ul20			; no, rts (close a window)

.ul10		move.l	D1,A2			; A2 = node
		cmp.b	13(A2),D2               ; waiting on our bit #?
		bne	.ul18			; no
		move.l	8(A2),A1                ; yes, signal the node
		moveq.l #$10,D0
		jsr	_LVOSignal(A6)          ; signal EVERYONE waiting
.ul18		move.l	(A2),D1                 ; next
		bne	.ul10

.ul20
		PERMIT
		movem.l (sp)+,D2/A2/A6
.ulrts		rts


		;   FindName2(list:D0, name:A0)
		;
		;   Search the node list as in FindName(), but also ignore
		;   NULL ln_name entries, which FindName() does not do.  This
		;   routine will also return NULL if given an uninitialized
		;   list header (completely zero'd).  Finally, it will not
		;   bother to do a string compare if the two pointers are
		;   the same.

		xdef	_FindName2

_FindName2:	movem.l 4(sp),D0/A0
		movem.l A2/A3,-(sp)
		move.l	D0,A1
		tst.l	(A1)                        ; uninitialized list header
		beq	.fn2fail
.fn2loop	move.l	(A1),A1                     ; get first/next node
		tst.l	(A1)                        ; end of list?
		beq	.fn2fail
		move.l	LN_NAME(A1),D0              ; name
		beq	.fn2loop		    ; NULL, skip
		cmp.l	D0,A0			    ; pointers are the same!
		beq	.fn2succ		    ;  don't bother w/cmp.
		move.l	D0,A2
		move.l	A0,A3
.fn2l2		cmpm.b	(A2)+,(A3)+
		bne	.fn2loop
		tst.b	-1(A2)
		bne	.fn2l2
.fn2succ	move.l	A1,D0
		movem.l (sp)+,A2/A3
		rts
.fn2fail	moveq.l #0,D0
		movem.l (sp)+,A2/A3
		rts

		END
