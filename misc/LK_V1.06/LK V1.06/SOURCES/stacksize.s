;	OPT	O+,OW-,L+
;--------------------------------------------------
;	lk V1.01 stack header.
;	$VER: stack.s 1.00 (18.07.94)
;	Written by Alexis WILKE (c) 1994.
;
;	This code will be used to ensure a specific
;	stack size at the startup of a command.
;--------------------------------------------------

	INCDIR	"INCLUDE:INCLUDE.STRIP/"
	INCLUDE	"EXEC/execbase.i"
	INCLUDE	"EXEC/tasks.i"
	INCLUDE	"INCLUDE:sw.i"

	XDEF	__Startup

	XREF	__STACKSIZE
	XREF	__autostartup

	SECTION	ENTRYHUNK,CODE
;--------------------------------------------------
__Startup
	MoveM.L	D0-D1/A0-A1/A6,-(A7)		;Keep all registers
	MoveA.L	4.W,A6
	Move.L	#__STACKSIZE,D0
	MoveA.L	ThisTask(A6),A1
	Move.L	TC_SPUPPER(A1),D1		;Enough stack already
	Sub.L	TC_SPLOWER(A1),D1
	Cmp.L	D1,D0
	Bls.B	.stackok
	MoveQ	#$00,D1
	SYS	AllocMem
	Tst.L	D0
	Bne.B	.setstack
	Lea	DName(PC),A1
	SYS	OldOpenLibrary
	Tst.L	D0
	Beq.B	.error
	SYS	Output,D0
	Move.L	D0,D1
	Beq.B	.close
	Lea	Message(PC),A0
	Move.L	A0,D2
	Move.L	#MessageEnd-Message,D3
	SYS	Write
.close
	MoveA.L	A6,A1
	MoveA.L	4.W,A6
	SYS	CloseLibrary
.error
	MoveM.L	(A7)+,D0-D1/A0-A1/A6
	Rts
.setstack
	Lea	__lowerstack(PC),A0
	Move.L	D0,__newstack-__lowerstack(A0)
	Move.L	A7,__oldstack-__lowerstack(A0)
	MoveA.L	ThisTask(A6),A1
	Move.L	TC_SPLOWER(A1),__lowerstack-__lowerstack(A0)
	Move.L	TC_SPUPPER(A1),__upperstack-__lowerstack(A0)
	SYS	Disable
	Move.L	D0,TC_SPLOWER(A1)
	Add.L	#__STACKSIZE,D0
	Move.L	D0,TC_SPUPPER(A1)
	MoveA.L	A7,A0				;Save old stack in A0
	MoveA.L	D0,A7				;Get new stack pointer
	SYS	Enable
	MoveM.L	(A0),D0-D1/A0-A1/A6		;The stack has been saved in A0
	Bra.B	.start
.stackok
	MoveM.L	(A7)+,D0-D1/A0-A1/A6
.start
	Jsr	__autostartup			;Go to your startup
	Move.L	__newstack(PC),D7
	Beq.B	.nostack
	Move.L	D0,D6
	MoveA.L	4.W,A6
	MoveA.L	ThisTask(A6),A5
	SYS	Disable
	Move.L	__lowerstack(PC),TC_SPLOWER(A5)
	Move.L	__upperstack(PC),TC_SPUPPER(A5)
	MoveA.L	__oldstack(PC),A7		;Restore previous stack
	SYS	Enable
	AddA.W	#4*5,A7
	MoveA.L	D7,A1
	Move.L	#__STACKSIZE,D0
	SYS	FreeMem
	Move.L	D6,D0
.nostack
	Rts

__newstack	DS.L	1
__oldstack	DS.L	1
__lowerstack	DS.L	1
__upperstack	DS.L	1

DName		Dc.B	"dos.library",0
Message		Dc.B	"Cannot allocate correct stack."
MessageEnd
	EVEN

