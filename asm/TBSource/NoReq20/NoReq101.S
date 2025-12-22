***********************************************
*					      *
*              (C)opyright 1991               *
*					      *
*             by  Tomi Blinnikka              *
*					      *
*      Don´t try to understand the code       *
*					      *
*					      *
*      Get those requesters outta here!       *
*					      *
* Version 0.00a	20/05/1991		      *
*					      *
* BUGS: Didn't open intuition.library version *
*       36 and up only.		      	      *
*					      *
* Version 0.00b	05/06/1991		      *
*					      *
* BUGS: If wrong kickstart, made change any-  *
*	way.				      *
*					      *
* Version 1.00	05/06/1991		      *
*					      *
* BUGS: Port name got messed up by other pro- *
*	grams				      *
*					      *
* Version 1.01	06,08/06/1991		      *
* (I was riding my bike on 7th, got 1000km    *
* on the meter...)			      *
*					      *
***********************************************
	

		INCLUDE	"JMPLibs.i"
		INCLUDE	"exec/types.i"
		INCLUDE	"exec/ports.i"
		INCLUDE	"exec/memory.i"
		INCLUDE	"intuition.xref"
		INCLUDE	"exec.xref"

_LVOEasyRequestArgs:	EQU	-$024c
_LVOAutoRequest:	EQU	-$015c
_LVOSetFunction:	EQU	-$01a4
_LVOOpenLibrary:	EQU	-$0228
_LVOCloseLibrary:	EQU	-$019e
_LVOAllocMem:		EQU	-$00c6
_LVOCopyMem:		EQU	-$0270
_LVOOutput:		EQU	-$003c
_LVOWrite:		EQU	-$0030

;a4 = Port address, when available

Start:		move.l	a0,a2
		openlib	Dos
		tst.l	d0
		bne	Start1
		moveq	#20,d0
		rts
Start1:		lib	Dos,Output
		move.l	d0,_stdout

		cmp.b	#"?",(a2)
		beq	CommandLineHelp

		print	<"NoReq20 v1.01",13,10>,_stdout
		print	<"(C)opyright 1991 Tomi Blinnikka",13,10>,_stdout

		move.l	#36,d0
		move.l	$4,a6
		lea.l	_IntuitionLib(pc),a1
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_IntuitionBase
		bne	CheckInstalled
		print	<"ERROR: Couldn't open intuition.library.",13,10>,_stdout
		print	<"       This program requires Kickstart 2.0 or higher.",13,10>,_stdout
		jmp	ShutDown

;See if already installed

CheckInstalled:	flib	Exec,Forbid
		lea.l	PublicPortName(pc),a1
		flib	Exec,FindPort
		move.l	d0,a4
		beq	NotInstalled
		cmp.b	#"q",(a2)
		beq	RemoveNoReq
		cmp.w	#'-q',(a2)
		beq	RemoveNoReq
		cmp.b	#"Q",(a2)
		beq	RemoveNoReq
		cmp.w	#'-Q',(a2)
		beq	RemoveNoReq
		print	<"ERROR: NoReq20 already installed!",13,10>,_stdout
		jmp	ShutDown

RemoveNoReq:	flib	Exec,Forbid
		lea.l	NewCodeAdd(a4),a0
		move.l	_IntuitionBase(pc),a1
		cmp.l	_LVOEasyRequestArgs+2(a1),a0
		bne	ErrorCantQuit
		cmp.l	_LVOAutoRequest+2(a1),a0
		bne	ErrorCantQuit		
		flib	Exec,Enable

		move.l	_IntuitionBase(pc),a1
		move.l	OldEasyReq(a4),d0
		move.l	#_LVOEasyRequestArgs,a0
		flib	Exec,SetFunction
		move.l	_IntuitionBase(pc),a1
		move.l	OldAutoReq(a4),d0
		move.l	#_LVOAutoRequest,a0
		flib	Exec,SetFunction

;remove port
		flib	Exec,Forbid
		move.l	a4,a1
		flib	Exec,RemPort
		flib	Exec,Enable
		move.l	a4,a1
		move.l	#PublicPort_SIZE,d0
		flib	Exec,FreeMem

		print	<"NoReq20 removed.",13,10>,_stdout
		jmp	ShutDown

NotInstalled:	cmp.b	#"q",(a2)
		beq	ErrorNotIns
		cmp.w	#'-q',(a2)
		beq	ErrorNotIns
		cmp.b	#"Q",(a2)
		beq	ErrorNotIns
		cmp.w	#'-Q',(a2)
		beq	ErrorNotIns

AllocingPort:	move.l	#PublicPort_SIZE,d0
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
		jsr	_LVOAllocMem(a6)
		tst.l	d0
		beq	ErrorNoMem
		move.l	d0,a4

		lea.l	PublicPortName-NewCode+NewCodeAdd(a4),a0
		move.l	a0,LN_NAME(a4)
		move.b	#PA_IGNORE,MP_FLAGS(a4)

		lea.l	MP_MSGLIST(a4),a0
		NEWLIST	a0

		lea.l	NewCode(pc),a0
		lea.l	NewCodeAdd(a4),a1
		move.l	a1,d6
		move.l	#CODE_SIZE,d0
		lib	Exec,CopyMem

		move.l	a4,a1
		flib	Exec,AddPort

		move.l	_IntuitionBase(pc),a1
		move.l	d6,d0
		move.l	#_LVOEasyRequestArgs,a0
		flib	Exec,SetFunction
		move.l	d0,OldEasyReq(a4)
		move.l	_IntuitionBase(pc),a1
		move.l	d6,d0
		move.l	#_LVOAutoRequest,a0
		flib	Exec,SetFunction
		move.l	d0,OldAutoReq(a4)
		print	<"NoReq20 installed.",13,10>,_stdout
ShutDown:	closlib	Intuition
		closlib	Dos
		move.l	#$00,d0
		rts

		INCLUDE	"FH1:Language/WF/NoReq20/NRCommandLineHelp.i"

ErrorNotIns:	print	<"ERROR: NoReq20 not installed!",13,10>,_stdout
		jmp	ShutDown
ErrorNoMem:	print	<"ERROR: Couldn't get memory!",13,10>,_stdout
		jmp	ShutDown

ErrorCantQuit:	flib	Exec,Enable
		print	<"ERROR: NoReq20 can NOT quit!",13,10>,_stdout
		print	<'Due to: Vectors have been changed afterwards.',13,10>,_stdout
		jmp	ShutDown

;All other library stuff needed

DIntuition	set	1

		libnames

;File stuff

_stdout:	dc.l	0

;new code and other stuff here

NewCode:	move.l	#$00,d0
		rts
PublicPortName:	dc.b	"NoReq20_Port",0
NewCode_END:	ds.l	0

CODE_SIZE:		EQU	NewCode_END-NewCode

;Our port structure and other port stuff

		STRUCTURE PublicPort,0
		STRUCT	MessagePort,MP_SIZE
		APTR	OldEasyReq
		APTR	OldAutoReq
		STRUCT	NewCodeAdd,CODE_SIZE
		LABEL PublicPort_SIZE

		END
