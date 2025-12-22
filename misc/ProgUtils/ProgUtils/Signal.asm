			opt	c+,l-

	;***
	;Signal a task
	;© J.Tyberghein (C version				30 sep 89)
	;© J.Tyberghein (Conversion to ML	 2 oct 89)
	;***

			incdir	include/
			include	libraries/dosextens.i
			include	exec/execbase.i

SysBase			equ	4
	;ExecBase routines
_LVOOldOpenLibrary	equ	-408
_LVOCloseLibrary		equ	-414
_LVOForbid				equ	-132
_LVOPermit				equ	-138
_LVOSignal				equ	-324
	;DosBase routines
_LVOWrite				equ	-48
_LVOOutput				equ	-60


CALLEXEC	macro
			move.l (SysBase).w,a6
			jsr _LVO\1(a6)
			endm

CALLDOS	macro
			move.l DosBase,a6
			jsr _LVO\1(a6)
			endm

	;Main program
		move.l	a0,ArgPointer
		move.l	d0,ArgLen
	;Open libraries
		lea		DosLib,a1
		CALLEXEC	OldOpenLibrary
		move.l	d0,DosBase
	;Get outputhandle
		CALLDOS	Output
		move.l	d0,OutputHandle
		bsr		Main
	;Close libraries
		move.l	DosBase,a1
		CALLEXEC	CloseLibrary
		rts

	;*** String length ***
	;a0 = string address
	;-> d0 = length
	;***
StrLen:
		moveq		#-1,d0
LoopSL:
		addq.l	#1,d0
		tst.b		(a0)+
		bne.s		LoopSL
		rts

	;*** Put a message on the screen ***
	;a0 = message
	;***
Message:
		movem.l	a0,-(a7)
		bsr		StrLen
		movem.l	(a7)+,a0
		move.l	d0,d3
		move.l	OutputHandle,d1
		move.l	a0,d2
		CALLDOS	Write
		rts

	;*** Compare a BSTR with an CSTR ***
	;a2 = BSTR
	;a1 = CSTR
	;-> d0 = 0 if equal
	;***
CompareBC:
		tst.b		(a2)
		beq.s		NotEqualBC
		moveq		#0,d0
LoopBC:
		cmp.b		(a2),d0
		bgt.s		EqualBC
		move.b	(a1,d0),d1
		cmp.b		1(a2,d0),d1
		bne.s		NotEqualBC
		addq.w	#1,d0
		bra.s		LoopBC
EqualBC:
		moveq		#0,d0
		rts
NotEqualBC:
		moveq		#-1,d0
		rts

	;*** Search for a task ***
	;d0 = Process number
	;a0 = Task pointer
	;-> a0 = task pointer or NULL if not found
	;***
Search:
		cmp.l		#0,a0					;Not the end of the tasks ?
		beq.s		TheEndS
		cmp.b		#NT_PROCESS,LN_TYPE(a0)
		bne.s		NextTaskS
		cmp.l		pr_TaskNum(a0),d0
		beq.s		TheEndS
NextTaskS:
		move.l	LN_SUCC(a0),a0
		bra.s		Search
TheEndS:
		rts

	;*** Search a task when the loaded commandname is given ***
	;a1 = Pointer to name
	;a0 = Task pointer
	;-> a0 = task pointer or NULL if not found
	;***
SearchS:
		cmp.l		#0,a0
		beq.s		TheEndSS
		cmp.b		#NT_PROCESS,LN_TYPE(a0)
		bne.s		NextTaskSS
		move.l	pr_CLI(a0),a2
		add.l		a2,a2
		add.l		a2,a2
		cmp.l		#0,a2
		beq.s		NextTaskSS
		move.l	cli_CommandName(a2),a2
		add.l		a2,a2
		add.l		a2,a2
		bsr		CompareBC
		beq.s		TheEndSS
NextTaskSS:
		move.l	LN_SUCC(a0),a0
		bra.s		SearchS
TheEndSS:
		rts

	;*** Skip spaces ***
	;a0 = string
	;-> a0 = after last space
	;***
SkipSpace:
		tst.b		(a0)
		beq.s		EndOfString
		cmp.b		#' ',(a0)+
		beq.s		SkipSpace
		sub.l		#1,a0
EndOfString:
		rts

	;*** Skip non spaces ***
	;a0 = string
	;-> a0 = points to first space
	;***
SkipNSpace:
		tst.b		(a0)
		beq.s		EndOfString
		cmp.b		#' ',(a0)+
		bne.s		SkipNSpace
		sub.l		#1,a0
		rts

	;*** Check if a byte is a digit ***
	;(a0) byte to check
	;-> d0 = 0 if digit
	;***
IsDigit:
		cmp.b		#'0',(a0)
		blt.s		NoDigitID
		cmp.b		#'9',(a0)
		bgt.s		NoDigitID
		moveq		#0,d0
		rts
NoDigitID:
		moveq		#-1,d0
		rts

	;***==============***
	;*** Main program ***
	;***==============***
Main:
		move.l	ArgPointer,a0
		move.b	#0,Number			;Assume no process number is given
		bsr		SkipSpace
		tst.b		(a0)
		beq		Error
		bsr		IsDigit
		bne.s		NoDigit
	;A digit so a process number must be given
		move.b	#1,Number			;Sorry, I was wrong. It was a process number
		moveq		#0,d2
		move.b	(a0),d2
		sub.b		#'0',d2
		lea		1(a0),a0
		bsr		IsDigit
		bne.s		NoDigitA
		mulu		#10,d2
		add.b		(a0),d2
		sub.b		#'0',d2				;We stop here, maximum 2 digits
		lea		1(a0),a0
NoDigitA:
		move.l	d2,ProcNum
		cmp.b		#' ',(a0)
		bne		Error
		bra.s		Contin
	;No digit so a loaded command name is given
NoDigit:
		move.l	a0,CommAdd
		bsr		SkipNSpace
		tst.b		(a0)
		beq		Error
		move.b	#0,(a0)				;End the string here
		lea		1(a0),a0
Contin:
		bsr		SkipSpace
		tst.b		(a0)
		beq		Error
	;Now we must scan the signal number
		moveq		#0,d2
		bsr		IsDigit
		bne		Error
		move.b	(a0),d2
		sub.b		#'0',d2
		lea		1(a0),a0
		bsr		IsDigit
		bne.s		Continue
		mulu		#10,d2
		add.b		(a0),d2
		sub.b		#'0',d2
		lea		1(a0),a0
		bsr		IsDigit
		bne.s		Continue
		mulu		#10,d2
		add.b		(a0),d2
		sub.b		#'0',d2
Continue:
		move.l	d2,SigNum
	;Search the task
		CALLEXEC	Forbid
		tst.b		Number
		bne.s		SearchNum
		move.l	CommAdd,a1
		move.l	(SysBase).w,a0
		add.l		#TaskReady,a0
		bsr		SearchS
		cmp.l		#0,a0
		bne.s		FoundIt
		move.l	(SysBase).w,a0
		add.l		#TaskWait,a0
		bsr		SearchS
		cmp.l		#0,a0
		beq.s		NotFound
		bra.s		FoundIt
SearchNum:
		move.l	ProcNum,d0
		move.l	(SysBase).w,a0
		add.l		#TaskReady,a0
		bsr		Search
		cmp.l		#0,a0
		bne.s		FoundIt
		move.l	(SysBase).w,a0
		add.l		#TaskWait,a0
		bsr		Search
		cmp.l		#0,a0
		beq.s		NotFound
FoundIt:
		move.l	a0,a2
		CALLEXEC	Permit
	;Signal the task
		move.l	a2,a1
		move.l	SigNum,d0
		CALLEXEC	Signal
		rts
NotFound:
		CALLEXEC	Permit
		move.l	OutputHandle,d1
		move.l	#ProcessStr,d2
		move.l	#ProcessStrLen,d3
		CALLDOS	Write
		rts
Error:
		move.l	OutputHandle,d1
		move.l	#UsageStr,d2
		move.l	#UsageStrLen,d3
		CALLDOS	Write
		rts


	EVEN

DosBase:			dc.l	0
OutputHandle:	dc.l	0
ArgPointer:		dc.l	0				;Argument pointer given by DOS
ArgLen:			dc.l	0				;Length of ArgPointer
ProcNum:			dc.l	0				;Process number to search
CommAdd:			dc.l	0				;Command string to search
SigNum:			dc.l	0				;Number to signal

Number:			dc.b	0				;1 if a process number is given

	;Library names
DosLib:			dc.b	"dos.library",0

UsageStr:		dc.b	"Usage: Signal <Process ID>|<Program Name> <Signal Number>",10,0
UsageStrLen		equ	*-UsageStr

ProcessStr:		dc.b	"Process does not exist !",10,0
ProcessStrLen	equ	*-ProcessStr

	END

