***********************************************
*                                             *
*              (C)opyright 1991               *
*                                             *
*             by  Tomi Blinnikka              *
*                                             *
*      Don´t try to understand the code       *
*                                             *
*                                             *
*      Get those requesters outta here!       *
*                                             *
***********************************************
	

	INCLUDE	"JMPLibs.i"

_LVOEasyRequestArgs:	EQU	-$024c
_LVOAutoRequest:	EQU	-$015c
_LVOSetFunction:	EQU	-$01a4
_LVOOpenLibrary:	EQU	-$0228
_LVOCloseLibrary:	EQU	-$019e
_LVOAllocMem:		EQU	-$00c6
_LVOCopyMem:		EQU	-$0270
_LVOOutput:		EQU	-$003c
_LVOWrite:		EQU	-$0030

Start:		move.l	a0,a2
		openlib	Dos,ShutDown
		lib	Dos,Output
		move.l	d0,_stdout

		cmp.b	#"?",(a2)
		beq	CommandLineHelp

		move.l	#36,d0
		openlib	Intuition,ShutDown
		move.l	#16,d0
		move.l	#01,d1
		lib	Exec,AllocMem
		move.l	d0,d6
		beq	NewCode
		lea.l	NewCode(pc),a0
		move.l	d0,a1
		move.l	#6,d0
		lib	Exec,CopyMem

		move.l	_IntuitionBase(pc),a1
		move.l	d6,a0
		move.l	a0,d0
		move.l	#_LVOEasyRequestArgs,a0
		lib	Exec,SetFunction
		move.l	_IntuitionBase(pc),a1
		lea.l	NewCode(pc),a0
		move.l	a0,d0
		move.l	#_LVOAutoRequest,a0
		lib	Exec,SetFunction
		print	<"NoReq20 v0.01a.",13,10>,_stdout
		print	<"(C)opyright 1991 Tomi Blinnikka",13,10>,_stdout
		print	<"Requesters will be canceled automatically.",13,10>,_stdout
ShutDown:	closlib	Intuition
		closlib	Dos

NewCode:	move.l	#$00,d0
		rts

		INCLUDE	"FH1:Language/WF/NoReq20/NRCommandLineHelp.i"

		libnames

;File stuff

_stdout:	dc.l	0

		END

