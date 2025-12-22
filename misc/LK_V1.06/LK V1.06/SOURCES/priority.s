;	OPT	O+,OW-,L+
;--------------------------------------------------
;	lk V1.01 priority header.
;	$VER: priority.s 1.00 (18.07.94)
;	Written by Alexis WILKE (c) 1994.
;
;	This code will be used to ensure a specific
;	priority at the startup of a command.
;--------------------------------------------------

	INCDIR	"INCLUDE:","INCLUDE:INCLUDE.STRIP/"
	INCLUDE	"EXEC/execbase.i"
	INCLUDE	"sw.i"

	XDEF	__Startup

	XREF	__autostartup
	XREF	PRIORITY

	SECTION	ENTRYHUNK,CODE
;--------------------------------------------------
__Startup
	MoveM.L	D0-D1/A0-A1/A6,-(A7)		;Keep all registers
	MoveA.L	4.W,A6
	MoveA.L	ThisTask(A6),A1
	Move.B	#PRIORITY,D0
	SYS	SetTaskPri			;Set my priority
	MoveM.L	(A7)+,D0-D1/A0-A1/A6		;Restore registers
	Jmp	__autostartup			;Go to your startup

