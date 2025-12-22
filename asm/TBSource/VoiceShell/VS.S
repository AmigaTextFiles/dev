*************************************************
*						*
*		 (C)opyright 1992-93		*
*						*
*		  by Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	13/06/1992-			*
*	 -0.99v 20/06/1992			*
*						*
* Version 1.00	07/02/1993			*
*						*
* Changed parser				*
*						*
* Added: From option, generic sampler, timer	*
*	 selection, fixed lotsa bugs		*
*						*
* BUGS: Loaded wrong data file on startup	*
*						*
* Version 1.01	11/02/1993			*
*						*
* Changed name from VShell to VoiceShell	*
*						*
* BUGS:						*
*						*
* Version 1.02	14/02/1993			*
*						*
* Added load gadget				*
*						*
* BUGS:						*
*						*
* Version 1.03	18/05/1993			*
*						*
* Fixed some font stuff				*
*						*
* BUGS:						*
*						*
* Version 1.04	25/05/1993			*
*						*
* Added DSS 8 support, needs voice.library,	*
* version 7					*
*						*
* Added priority				*
*						*
* Version 1.05	30/05/1993			*
*						*
* Added priority resetting			*
*						*
* Version 1.06	02/06/1993			*
*						*
* Added channel select & mic/line select	*
* Requires voice.library, version 8.0		*
*						*
* Version 1.07	10/06/1993			*
*						*
* Fixed few things in Set(Mic/Line/Right/Left).	*
*						*
* Version 1.08	19/06/1993			*
*						*
* Optimized and searched for voice.library 8.1	*
* bug. Bug was in library, version bumped.	*
*						*
* Version 1.09	21/06/1993			*
*						*
* ARexx control added				*
*						*
* Version 1.10	17/07/1993			*
*						*
* Optimized.					*
*						*
* Version 1.11	21/07/1993			*
*						*
* Implemented ARexx LOAD command. Fixed bug	*
* with 'Vol Dwn' gad & Left channel.		*
*						*
* Version 1.12	08/08/1993			*
*						*
* Increased command string length.		*
*						*
* Version 1.13	11/08/1993			*
*						*
* Added ability to wedge fate Input Events	*
* directly.					*
*						*
* Version 1.14	13/09/1993			*
*						*
* Added PUBSCREEN tooltype and CLI option.	*
*						*
* Version 1.15	19/09/1993			*
*						*
* Added 'Get'-gadget into Command window.	*
*						*
* Version 1.16	26/09/1993			*
*						*
* Made VoiceShell a commodity.			*
*						*
* Fixed some bugs that made it crash if ARexx	*
* commands executed while editing.		*
*						*
* Quitting made safer.				*
*						*
* Version 1.17	05/10/1993			*
*						*
* Localized a few internal things.		*
*						*
* Added 'HIDE' & 'SHOW' ARexx commands.		*
*						*
* Added CX_PRI tooltype code.			*
*						*
* Version 1.18	31/10/1993			*
*						*
* Fixed bug with getting font sizes etc.	*
*						*
* Re-wrote a-hell-of-a-lot of code. The guy who	*
* gave me the idea of making VS into a 		*
* commodity should be shot :)			*
*						*
* STILL TO CHECK:				*
*						*
* - does iconify work properly?			*
* - do all the tooltypes/cli options work?	*
* -						*
* -						*
* - does it still recognize words?		*
*						*
*************************************************

;	INCDIR	"INCLUDES:"
	INCLUDE "JMPLibs.i"
	INCLUDE "exec/memory.i"
	INCLUDE "exec/io.i"
	INCLUDE "exec/tasks.i"
	INCLUDE "libraries/dosextens.i"
	INCLUDE "libraries/dos.i"
	INCLUDE "libraries/commodities.i"
	INCLUDE "libraries/gadtools.i"
	INCLUDE	"libraries/voice.i"
	INCLUDE	"libraries/asl.i"
	INCLUDE "workbench/startup.i"
	INCLUDE "intuition/gadgetclass.i"
	INCLUDE "dos/dostags.i"
	INCLUDE	"rexx/errors.i"
	INCLUDE	"rexx/storage.i"

	INCLUDE "XREF:2.0.xref"
	INCLUDE "XREF:intuition.xref"
	INCLUDE "XREF:exec.xref"
	INCLUDE "XREF:dos.xref"
	INCLUDE "XREF:icon.xref"

	XREF	_InvertString
	XREF	_FreeIEvents
	XREF	_HotKey

	XDEF	_DOSBase
	XDEF	_SysBase
	XDEF	_CxBase

DVoice		SET	1
;VS_REGISTERED	SET	1	;Set only for registered versions!

PROGVERSION:	macro
		dc.b	"1.18 (31.10.93)"
		endm


VSFileVersion:	EQU	'VS03'

ShellTop:	EQU	2
OptionTop:	EQU	46
VocabSIZE:	EQU	60
NUMGADS:	EQU	10
GADLENG1:	EQU	16
GADLENG2:	EQU	256
GADLENGTH:	EQU	(GADLENG1+GADLENG2)

AccVal1:	EQU	2000
AccVal2:	EQU	2400
AccVal3:	EQU	2700
AccVal4:	EQU	3000		;VoiceShell default
AccVal5:	EQU	3500
AccVal6:	EQU	4000
AccVal7:	EQU	5500
AccVal8:	EQU	6000

Samp1MenuN:	EQU	$0002		;0002
Samp2MenuN:	EQU	$0802		;0802
Samp3MenuN:	EQU	$1002		;1002
Samp4MenuN:	EQU	$1802		;1802
ResLoMenuN:	EQU	$0022		;0022
ResHiMenuN:	EQU	$0822		;0822

Acc1MenuN:	EQU	$0042		;0042
Acc2MenuN:	EQU	$0842		;0842
Acc3MenuN:	EQU	$1042		;1042
Acc4MenuN:	EQU	$1842		;1842
Acc5MenuN:	EQU	$2042		;2042
Acc6MenuN:	EQU	$2842		;2842
Acc7MenuN:	EQU	$3042		;3042
Acc8MenuN:	EQU	$3842		;3842

Chan1MenuN:	EQU	$0062		;0062
Chan2MenuN:	EQU	$0862		;0862

Input1MenuN:	EQU	$0082		;0082
Input2MenuN:	EQU	$0882		;0882

Timer1MenuN:	EQU	$00A2		;00A2
Timer2MenuN:	EQU	$08A2		;08A2

TRUE:		EQU	1
FALSE:		EQU	0
do_ToolTypes:	EQU	$36

		section VS,CODE

		push	d2-d7/a2-a6

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a4
		move.l	pr_CLI(a4),d0
		bne	OpenDos

		lea.l	pr_MsgPort(a4),a0
		lib	Exec,WaitPort
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,GetMsg
		move.l	d0,WBMsg

OpenDos:	openlib Dos,NoDos		;Keep at beginning

		tst.l	WBMsg
		beq	CLIStart

		lea.l	NILName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
		beq	ShutDown
		move.l	NILFile,_stdout

		openlib Icon,NoIcon

		move.l	WBMsg,a0
		move.l	sm_ArgList(a0),a1
		move.l	wa_Lock(a1),d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock

		move.l	WBMsg,a0
		move.l	sm_ArgList(a0),a1
		move.l	wa_Name(a1),a0
		lib	Icon,GetDiskObject
		move.l	d0,DiskObject
		beq	MainStart

DoToolType1:	move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	ICONIFYText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType2
		move.l	d0,a0
		lea.l	YESText1,a1
		lib	Icon,MatchToolValue
		tst.l	d0
		beq	DoToolType2
		move.l	#1,OptionIconify

DoToolType2:	move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	FROMText1,a1
		lib	Icon,FindToolType
		move.l	d0,FromFile

		move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	PUBSCREENText1,a1
		lib	Icon,FindToolType
		move.l	d0,OptPubScreen

		move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	CXPOPKEYText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType3
		move.l	d0,OptCXPopKey

DoToolType3:	move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	CXPOPUPText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType4
		move.l	d0,a0
		lea.l	NOText1,a1
		lib	Icon,MatchToolValue
		tst.l	d0
		beq	DoToolType4
		clr.w	PopUp

DoToolType4:	move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	CXPRIText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType4
		move.l	d0,a0
		bsr	ConvASCII
		tst.l	d0
		beq	DoToolType5
		move.l	d0,WBOptCXPri
		lea.l	WBOptCXPri,a0
		move.l	a0,OptCXPri

DoToolType5:	bra	MainStart

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		move.l	OptCXPopUp,a0
		cmp.l	#0,a0
		beq	MainStart		;No enforcer hits, please
		cmp.b	#'n',(a0)
		bne	CLIStart1
		clr.w	PopUp
CLIStart1:	cmp.b	#'N',(a0)
		bne	MainStart
		clr.w	PopUp

MainStart:	openlib Intuition,NoInt
		openlib	Commodities,NoCommodities
		openlib	Asl,NoAsl
		openlib	Utility,NoUtility

		move.l	$4,_SysBase
		move.l	_DosBase,_DOSBase
		move.l	_CommoditiesBase,_CxBase

		move.l	OurTask,a1
		move.l	#120,d0
		lib	Exec,SetTaskPri

		openlib GadTools,NoGadTools

;Create a message port for the voice.library

		lib	Exec,CreateMsgPort
		move.l	d0,VoicePort
		beq	NoMsgPort

;Create a message port for commodities.library (Exchange)

		lib	Exec,CreateMsgPort
		move.l	d0,CXPort
		beq	NoMsgPort
		lea.l	NewBroker1,a0
		move.l	d0,nb_Port(a0)

;Get Asl_requester

		move.l	#ASL_FileRequest,d0
		lea.l	AslReqTags,a0
		lib	Asl,AllocAslRequest
		move.l	d0,AslReq
		beq	NoAslReq

;Do CX init stuff. Create broker

		tst.l	OptCXPri
		beq	SkipSetCXPri
		move.l	OptCXPri,a0
		move.l	(a0),d0

		tst.l	d0
		bmi	SetCXPri2

		cmp.l	#127,d0
		bhi	BadPriority
		bra	SetCXPri3

SetCXPri2:	cmp.l	#-128,d0
		bcs	BadPriority

SetCXPri3:	move.b	d0,NBPri
SkipSetCXPri:	lea.l	NewBroker1,a0
		clr.l	d0			;No extra error codes wanted
		lib	Commodities,CxBroker
		move.l	d0,CXBroker1
		beq	NoCommodity

;Create Filter object

		move.l	OptCXPopKey,AboutTxt7.X		;For about window

		move.l	OptCXPopKey,a0
		sub.l	a1,a1
		move.l	#CX_FILTER,d0
		lib	Commodities,CreateCxObj
		move.l	d0,d2
		beq	NoCommodity

;Attach Filter object to Broker

		move.l	CXBroker1,a0
		move.l	d2,a1
		lib	Commodities,AttachCxObj

		move.l	d2,a0			;Check if valid descriptor
		lib	Commodities,CxObjError
		cmp.l	#COERR_BADFILTER,d0
		beq	NoFilter

;Create send object

		move.l	d2,d3
		move.l	CXPort,a0
		sub.l	a1,a1
		move.l	#CX_SEND,d0
		lib	Commodities,CreateCxObj
		move.l	d0,d2
		beq	NoCommodity

;Attach Send object to Filter

		move.l	d3,a0
		move.l	d2,a1
		lib	Commodities,AttachCxObj

;Create translate object

		move.l	d2,d3
		sub.l	a0,a0
		sub.l	a1,a1
		move.l	#CX_TRANSLATE,d0
		lib	Commodities,CreateCxObj
		move.l	d0,d2
		beq	NoCommodity

;Attach Translate object to Send

		move.l	d3,a0
		move.l	d2,a1
		lib	Commodities,AttachCxObj

;We open voice.library this late so that if we're already run the older
;copy pops up

		move.l	#8,d0
		move.l	$4,a6
		lea.l	_VoiceLib,a1
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_VoiceBase
		beq	NoVoice

;The same thing with the ARexx port...

;Check to see if a port with our name already exists

		lib	Exec,Forbid
		lea.l	ARexxPortName,a1
		flib	Exec,FindPort
		push	d0
		flib	Exec,Permit

		pull	d0
		tst.l	d0
		bne	NoMsgPort2

;Create AREXX message port

		lib	Exec,CreateMsgPort
		move.l	d0,ARexxPort
		beq	NoMsgPort

		move.l	ARexxPort,a1
		lea.l	ARexxPortName,a0
		move.l	a0,LN_NAME(a1)
		lib	Exec,AddPort

;Read preferences

		bsr	Load		;Set voice stuff

		bsr	CXDisable	;Turn off just in case

		tst.w	PopUp
		beq	SkipOpen1

		bsr	OpenWin1
		tst.l	Window1
		beq	NoWindow1

		bsr	SetModes	;Set gads/menus

SkipOpen1:	move.l	#5625242,d5	;inform user
		bsr	AddVTask

Window1IDCMP:	move.l	Window1,a0
		bsr	CheckIDCMP
		tst.l	d0			;Test for CTRL_C
		beq	ShutDown
		cmp.l	#1,d0			;Test for CTRL_D
		beq	DoCTRL_D
		cmp.l	#2,d0			;Test for CTRL_E
		beq	DoCTRL_E
		cmp.l	#3,d0
		beq	DoVoice			;Do voice command
		cmp.l	#4,d0
		beq	Window1IDCMP		;Already done ARexx or commodity
		cmp.l	#INTUITICKS,d2
		beq	DoTicks
		cmp.l	#GADGETUP,d2
		beq	DoGads
		cmp.l	#CLOSEWINDOW,d2
		beq	DoDoCXDisappear
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#ACTIVEWINDOW,d2
		beq	ActivateGads
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		bra	Window1IDCMP

Refresher:	tst.l	Window1
		beq	Refresher_OUT
		move.l	Window1,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window1,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
Refresher_OUT:	bra	Window1IDCMP

VanillaKeys:	cmp.w	#$1b,d3
		beq	Quit
		cmp.w	#'l',d3			;Lower case
		beq	DoDataLoad
		cmp.w	#'s',d3
		beq	Save
		cmp.w	#'q',d3
		beq	Quit
		cmp.w	#'u',d3
		beq	DoGainUp
		cmp.w	#'d',d3
		beq	DoGainDown
		cmp.w	#'f',d3
		beq	ActivateGads
		cmp.w	#'L',d3			;Upper case
		beq	DoDataLoad
		cmp.w	#'S',d3
		beq	Save
		cmp.w	#'Q',d3
		beq	Quit
		cmp.w	#'U',d3
		beq	DoGainUp
		cmp.w	#'D',d3
		beq	DoGainDown
		cmp.w	#'F',d3
		beq	ActivateGads
		bra	Window1IDCMP

DoGads:		cmp.w	#10,$26(a5)
		beq	DoOnOff
		cmp.w	#1,$26(a5)
		beq	ActivateGads
		cmp.w	#20,$26(a5)
		beq	DoGainUp
		cmp.w	#30,$26(a5)
		beq	DoGainDown
		cmp.w	#40,$26(a5)
		beq	DoDataLoad
		cmp.w	#98,$26(a5)
		beq	Save
		cmp.w	#99,$26(a5)
		beq	Quit
		bra	Window1IDCMP

Win1Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win1Menus1
		cmp.w	#$01,d6
		beq	Win1Menus2
		cmp.w	#$02,d6
		beq	Win1Menus3
		bra	Window1IDCMP
Win1Menus1:	cmp.w	#$00,d5
		beq	DoLoad
		cmp.w	#$01,d5
		beq	Save
		cmp.w	#$02,d5
		beq	About
		cmp.w	#$04,d5
		beq	Quit
		bra	Window1IDCMP
Win1Menus2:	cmp.w	#$00,d5
		beq	EditCmds
		bra	Window1IDCMP
Win1Menus3:	cmp.w	#$00,d5
		beq	Win1Menus3.1
		cmp.w	#$01,d5
		beq	Win1Menus3.2
		cmp.w	#$02,d5
		beq	Win1Menus3.3
		cmp.w	#$03,d5
		beq	Win1Menus3.4
		cmp.w	#$04,d5
		beq	Win1Menus3.5
		cmp.w	#$05,d5
		beq	Win1Menus3.6
		cmp.w	#$06,d5
		beq	SetPriority
		bra	Window1IDCMP
Win1Menus3.1:	cmp.w	#$00,d4
		beq	DoSetSamp1
		cmp.w	#$01,d4
		beq	DoSetSamp2
		cmp.w	#$02,d4
		beq	DoSetSamp3
		cmp.w	#$03,d4
		beq	DoSetSamp4
		bra	Window1IDCMP
Win1Menus3.2:	cmp.w	#$00,d4
		beq	DoSetResLo
		cmp.w	#$01,d4
		beq	DoSetResHi
Win1Menus3.3:	cmp.w	#$00,d4
		beq	DoSetAccLowest
		cmp.w	#$01,d4
		beq	DoSetAccLower
		cmp.w	#$02,d4
		beq	DoSetAccLow
		cmp.w	#$03,d4
		beq	DoSetAccNormal
		cmp.w	#$04,d4
		beq	DoSetAccHigh
		cmp.w	#$05,d4
		beq	DoSetAccHigher
		cmp.w	#$06,d4
		beq	DoSetAccEHigher
		cmp.w	#$07,d4
		beq	DoSetAccMaximum
Win1Menus3.4:	cmp.w	#$00,d4
		beq	DoSetLeft
		cmp.w	#$01,d4
		beq	DoSetRight
Win1Menus3.5:	cmp.w	#$00,d4
		beq	DoSetMic
		cmp.w	#$01,d4
		beq	DoSetLine
Win1Menus3.6:	cmp.w	#$00,d4
		beq	DoSetTimerA
		cmp.w	#$01,d4
		beq	DoSetTimerB
		bra	Window1IDCMP

DoTicks:	add.w	#1,TickCount
		cmp.w	#20,TickCount
		bne	Window1IDCMP
		clr.w	TickCount
		tst.w	TaskOn
		beq	DoTicks2
		lea.l	ReadyText1,a0
		bsr	GetLength
		bsr	Inform
		bra	Window1IDCMP
DoTicks2:	lea.l	InactiveText1,a0
		bsr	GetLength
		bsr	Inform
		bra	Window1IDCMP

EditCmds:	clr.w	Saved
		move.w	#1,DisActive		;Can't turn on/off
		bsr	RemVTask1
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		bsr	OpenWin2
		tst.l	d0
		beq	NoWindow1
		bsr	RemGads2
		bsr	SetStrGads
		bsr	AddGads2

		bsr	ActGad2

Window2IDCMP:	move.l	Window2,a0
		bsr	CheckIDCMP

		tst.l	d0
		beq	ShutDown
		cmp.l	#4,d0
		beq	Window2IDCMP
		cmp.l	#GADGETUP,d2
		beq	ActivateGads2
		cmp.l	#GADGETDOWN,d2
		beq	GetGadAddr2
		cmp.l	#CLOSEWINDOW,d2
		beq	EditCmds_OUT
		cmp.l	#MENUPICK,d2
		beq	Win2Menus
		cmp.l	#VANILLAKEY,d2
		beq	EditKeys
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher2
		bra	Window2IDCMP

Refresher2:	move.l	Window2,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window2,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window2IDCMP

Win2Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win2Menus1
		bra	Window2IDCMP
Win2Menus1:	cmp.w	#$00,d5
		beq	DoPage1
		cmp.w	#$01,d5
		beq	DoPage2
		cmp.w	#$02,d5
		beq	DoPage3
		cmp.w	#$03,d5
		beq	DoPage4
		cmp.w	#$04,d5
		beq	DoPage5
		cmp.w	#$05,d5
		beq	DoPage6
		cmp.w	#$07,d5
		beq	EditCmds_OUT
		bra	Window2IDCMP

DoPage1:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#0,Page
		bsr	SetStrGads
		bsr	AddGads2
		bra	Window2IDCMP

DoPage2:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#1,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage3:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#2,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage4:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#3,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage5:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#4,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage6:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#5,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

SaveStrGads:	lea.l	CmdList,a2
		move.w	Page,d0
		mulu.w	#NUMGADS*GADLENGTH,d0
		add.l	d0,a2			;a2=start of strings

		move.l	StrGadBuf1,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf2,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf3,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf4,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf5,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf6,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf7,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf8,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf9,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf10,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf11,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf12,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf13,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf14,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf15,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf16,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf17,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf18,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf19,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf20,a0
		move.l	a2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem
		rts

SetStrGads:	lea.l	CmdList,a2
		move.w	Page,d0
		mulu.w	#NUMGADS*GADLENGTH,d0
		add.l	d0,a2			;a2=start of strings

		move.l	a2,a0
		move.l	StrGadBuf1,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf2,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf3,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf4,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf5,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf6,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf7,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf8,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf9,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf10,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf11,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf12,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf13,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf14,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf15,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf16,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf17,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf18,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf19,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf20,a1
		move.l	#GADLENG2,d0
		add.l	d0,a2
		lib	Exec,CopyMem
		rts

EditCmds_OUT:	bsr	SaveStrGads
		bsr	AddVTask
		bsr	CloseWin2
		clr.w	DisActive	;Can turn on/off
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

EditKeys:	cmp.w	#$1b,d3
		beq	EditCmds_OUT
		cmp.w	#'g',d3
		beq	Get
		cmp.w	#'G',d3
		beq	Get
		bra	Window2IDCMP

GetGadAddr2:	cmp.w	#2,$26(a5)
		beq	GetGadAddr2.1
		clr.l	LastGad
		move.l	GetGad1,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lea.l	DisabledTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		bra	Window2IDCMP
GetGadAddr2.1:	move.l	a5,LastGad
		move.l	GetGad1,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lea.l	EnabledTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		bra	Window2IDCMP

Get:		tst.l	LastGad
		beq	Get_OUT2

		move.l	AslReq,a0
		lea.l	GetReqTags,a1
		lib	Asl,AslRequest
		tst.l	d0
		beq	Get_OUT1

		move.l	LastGad,a5
		bsr	RemGads2
		bsr	MakeCmd
		bsr	AddGads2

Get_OUT1:	move.l	LastGad,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget

Get_OUT2:	bra	Window2IDCMP

SetPriority:	move.w	#1,DisActive		;Can't turn on/off
		bsr	RemVTask1
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		bsr	OpenWin3
		tst.l	d0
		beq	NoWindow1

Window3IDCMP:	move.l	Window3,a0
		bsr	CheckIDCMP

		tst.l	d0
		beq	ShutDown
		cmp.l	#4,d0
		beq	Window3IDCMP
		cmp.l	#GADGETUP,d2
		beq	SetPriority2
		cmp.l	#CLOSEWINDOW,d2
		beq	SetPri_OUT
		cmp.l	#VANILLAKEY,d2
		beq	SetPriKeys
		cmp.l	#ACTIVEWINDOW,d2
		beq	GoActGads3
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher3
		bra	Window3IDCMP

Refresher3:	move.l	Window3,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window3,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window3IDCMP

SetPriority2:	move.l	StrGadInt21,a0
		move.l	(a0),d0

		tst.l	d0
		bmi	SetPriority2.1

		cmp.l	#127,d0
		bhi	SetPriority3

		move.l	d0,PrefsPriority
		bra	SetPri_OUT

SetPriority2.1:	cmp.l	#-128,d0
		bcs	SetPriority3

		move.l	d0,PrefsPriority
		bra	SetPri_OUT

SetPriority3:	sub.l	a0,a0
		lib	Intuition,DisplayBeep

		move.l	StrGad21,a0
		move.l	Window3,a1
		sub.l	a2,a2
		lea.l	StrGadTagList3,a3
		lib	GadTools,GT_SetGadgetAttrsA
		bra	GoActGads3

SetPri_OUT:	bsr	CloseWin3
		bsr	AddVTask
		clr.w	DisActive		;Can turn on/off
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

GoActGads3:	bsr	ActGad3
		bra	Window3IDCMP

SetPriKeys:	cmp.w	#$1b,d3
		beq	SetPri_OUT
		bra	Window3IDCMP

DoVoice:	cmp.w	#-1,d3
		beq	VoiceUnknown
		cmp.w	#-2,d3
		beq	VoiceClip
		cmp.w	#-3,d3
		beq	VoiceLow
		cmp.w	#-4,d3
		beq	VoiceNoisy

		cmp.w	PrefsScore,a4
		bcs	VoiceUnknown

		lea.l	CmdList,a2
		move.w	d3,d0
		mulu.w	#GADLENGTH,d0
		add.l	d0,a2			;a2=start of strings

		move.l	a2,a0

		push	a2
		bsr	GetLength
		bsr	Inform
		pull	a2

		clr.w	TickCount

		add.l	#GADLENG1,a2
		cmp.l	#0,(a2)
		beq	DoVoice2

		cmp.b	#'~',(a2)
		beq	DoSpecial

		move.l	a2,d1			;execute command
		clr.l	d2
		lib	Dos,SystemTagList

		cmp.l	#-1,d0
		beq	DoVoice3
		bra	Window1IDCMP

DoSpecial:	add.l	#1,a2
		cmp.b	#'K',(a2)
		beq	DoSpecial2
		bra	DoVoice2		;No Command

DoSpecial2:	add.l	#2,a2			;Skip shortcut and space
		move.l	a2,a0
		lea.l	StringBuffer,a1
		bsr	CopyStrs

		bsr	SendEvents
		move.l	#4,d2
		tst.l	IEvents
		beq	DoVoice3		;Command failed
		clr.l	IEvents
		bra	Window1IDCMP

DoVoice2:	lea.l	NoCMDText1,a0
		bsr	GetLength
		bsr	Inform
		clr.w	TickCount
		bra	Window1IDCMP
DoVoice3:	lea.l	CMDFailText1,a0
		bsr	GetLength
		bsr	Inform
		clr.w	TickCount
		bra	Window1IDCMP

VoiceUnknown:	lea.l	NoMatchText1,a0
		bsr	GetLength
		bsr	Inform
		clr.w	TickCount
		bra	Window1IDCMP
VoiceClip:	lea.l	ClippingText1,a0
		bsr	GetLength
		bsr	Inform
		clr.w	TickCount
		bra	Window1IDCMP
VoiceLow:	lea.l	LowVolText1,a0
		bsr	GetLength
		bsr	Inform
		clr.w	TickCount
		bra	Window1IDCMP
VoiceNoisy:	lea.l	NoisyText1,a0
		bsr	GetLength
		bsr	Inform
		clr.w	TickCount
		bra	Window1IDCMP

CX:		cmp.l	#CXM_COMMAND,d2
		beq	DoCXCommand
		cmp.l	#CXM_IEVENT,d2
		beq	DoCXAppear
		move.l	#4,d0
		rts				;Unknown command

DoCXCommand:	cmp.l	#CXCMD_APPEAR,d3
		beq	DoCXAppear
		cmp.l	#CXCMD_DISAPPEAR,d3
		beq	DoCXDisappear
		cmp.l	#CXCMD_KILL,d3
		beq	DoCXKill
		cmp.l	#CXCMD_UNIQUE,d3
		beq	DoCXAppear
		cmp.l	#CXCMD_ENABLE,d3
		beq	DoCXEnable
		cmp.l	#CXCMD_DISABLE,d3
		beq	DoCXDisable
		move.l	#4,d0
		rts				;Unknown message

DoCXKill:	clr.l	d0
		rts

DoCXAppear:	tst.l	Window1
		bne	DoCXAppear_OUT
		tst.w	DisActive
		bne	DoCXDisap_OUT
		clr.l	OptionIconify
		bsr	OpenWin1
		bsr	SetModes
		tst.l	Window1
		bne	DoCXAppear_OUT
		sub.l	a0,a0
		lib	Intuition,DisplayBeep	;Beep on error
DoCXAppear_OUT:	move.l	#4,d0
		rts

DoDoCXDisappear: bsr	DoCXDisappear
		bra	Window1IDCMP

DoCXDisappear:	tst.l	Window1
		beq	DoCXDisap_OUT
		tst.w	DisActive
		bne	DoCXDisap_OUT
		bsr	CheckModes
		bsr	CloseWin1
DoCXDisap_OUT:	move.l	#4,d0
		rts

DoCXEnable:	tst.w	DisActive
		bne	DoCXEnable1
		bsr	CLITypeOn
DoCXEnable_OUT:	move.l	#4,d0
		rts
DoCXEnable1:	bsr	CXDisable		;Can't turn on
		bra	DoCXEnable_OUT

DoCXDisable:	tst.w	DisActive
		bne	DoCXDisable1
		bsr	CLITypeOff
DoCXDis_OUT:	move.l	#4,d0
		rts
DoCXDisable1:	bsr	CXEnable		;Can't turn off
		bra	DoCXDis_OUT

CXEnable:	move.l	CXBroker1,a0
		move.l	#TRUE,d0
		lib	Commodities,ActivateCxObj
		rts

CXDisable:	move.l	CXBroker1,a0
		move.l	#FALSE,d0
		lib	Commodities,ActivateCxObj
		rts

DoSetResLo:	bsr	SetResLo
		bra	Window1IDCMP

DoSetResHi:	bsr	SetResHi
		bra	Window1IDCMP

SetResLo:	bsr	RemVTask1
		move.b	#RES_LO,PrefsSampRes
		bsr	AddVTask
		rts
SetResHi:	bsr	RemVTask1
		move.b	#RES_HI,PrefsSampRes
		bsr	AddVTask
		rts

DoSetAccLowest:	bsr	SetAccLowest
		bra	Window1IDCMP

DoSetAccLower:	bsr	SetAccLower
		bra	Window1IDCMP

DoSetAccLow:	bsr	SetAccLow
		bra	Window1IDCMP

DoSetAccNormal:	bsr	SetAccNormal
		bra	Window1IDCMP

DoSetAccHigh:	bsr	SetAccHigh
		bra	Window1IDCMP

DoSetAccHigher:	bsr	SetAccHigher
		bra	Window1IDCMP

DoSetAccEHigher: bsr	SetAccEHigher
		bra	Window1IDCMP

DoSetAccMaximum: bsr	SetAccMaximum
		bra	Window1IDCMP


SetAccLowest:	move.w	#AccVal1,PrefsScore
		rts

SetAccLower:	move.w	#AccVal2,PrefsScore
		rts

SetAccLow:	move.w	#AccVal3,PrefsScore
		rts

SetAccNormal:	move.w	#AccVal4,PrefsScore
		rts

SetAccHigh:	move.w	#AccVal5,PrefsScore
		rts

SetAccHigher:	move.w	#AccVal6,PrefsScore
		rts

SetAccEHigher:	move.w	#AccVal7,PrefsScore
		rts

SetAccMaximum:	move.w	#AccVal8,PrefsScore
		rts

DoSetLeft:	bsr	SetLeft
		bra	Window1IDCMP

DoSetRight:	bsr	SetRight
		bra	Window1IDCMP

DoCTRL_D:	tst.w	DisActive
		bne	DoCTRL_D_OUT
		bsr	CLITypeOff
DoCTRL_D_OUT:	bra	Window1IDCMP

DoCTRL_E:	tst.w	DisActive
		bne	DoCTRL_E_OUT
		bsr	CLITypeOn
DoCTRL_E_OUT:	bra	Window1IDCMP

CLITypeOff:	bsr	RemGads
		move.l	OnOffGad1,a0
		and.w	#~SELECTED,gg_Flags(a0)
		move.l	#5625242,d5		;inform user
		bsr	RemVTask1
		bsr	AddGads
		rts

CLITypeOn:	bsr	RemGads
		move.l	OnOffGad1,a0
		or.w	#SELECTED,gg_Flags(a0)
		move.l	#5625242,d5		;inform user
		bsr	AddVTask1
		bsr	AddGads
		rts

SetLeft:	move.b	#CHANNEL_LEFT,PrefsChannel
		cmp.b	#SAMP_GENERIC,PrefsSampType
		beq	SetLeft_OUT
		bsr	RemVTask1
		move.l	#CHANNEL_LEFT,d0
		lib	Voice,PickChannel
		bsr	AddVTask
SetLeft_OUT:	rts

SetRight:	move.b	#CHANNEL_RIGHT,PrefsChannel
		cmp.b	#SAMP_GENERIC,PrefsSampType
		beq	SetRight_OUT
		bsr	RemVTask1
		move.l	#CHANNEL_RIGHT,d0
		lib	Voice,PickChannel
		bsr	AddVTask
SetRight_OUT:	rts

DoSetMic:	bsr	SetMic
		bra	Window1IDCMP

DoSetLine:	bsr	SetLine
		bra	Window1IDCMP

SetMic:		move.b	#INPUT_MIC,PrefsInput
		cmp.b	#SAMP_GENERIC,PrefsSampType
		beq	SetMic_OUT
		bsr	RemVTask1
		move.l	#INPUT_MIC,d0
		lib	Voice,PickInput
		bsr	AddVTask
SetMic_OUT:	rts

SetLine:	move.b	#INPUT_LINE,PrefsInput
		cmp.b	#SAMP_GENERIC,PrefsSampType
		beq	SetLine_OUT
		bsr	RemVTask1
		move.l	#INPUT_LINE,d0
		lib	Voice,PickInput
		bsr	AddVTask
SetLine_OUT:	rts

DoSetSamp1:	bsr	SetSamp1
		bra	Window1IDCMP
DoSetSamp2:	bsr	SetSamp2
		bra	Window1IDCMP
DoSetSamp3:	bsr	SetSamp3
		bra	Window1IDCMP
DoSetSamp4:	bsr	SetSamp4
		bra	Window1IDCMP

SetSamp1:	bsr	RemVTask1
		move.b	#SAMP_PERFSND,PrefsSampType		;PerfectSound
		move.l	#SAMP_PERFSND,d0
		clr.l	d1
		lib	Voice,PickSampler
		bsr	RemGads
		move.l	GainUGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)
		bsr	AddGads
		bsr	AddVTask
		rts
SetSamp2:	bsr	RemVTask1
		move.b	#SAMP_SNDMSTR,PrefsSampType		;SoundMaster
		move.l	#SAMP_SNDMSTR,d0
		clr.l	d1
		lib	Voice,PickSampler
		bsr	RemGads
		move.l	GainUGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)
		bsr	AddGads
		bsr	AddVTask
		rts
SetSamp3:	bsr	RemVTask1
		move.b	#SAMP_DSS8,PrefsSampType		;DSS8
		move.l	#SAMP_DSS8,d0
		clr.l	d1
		move.b	PrefsGain,d1
		lib	Voice,PickSampler
		bsr	RemGads
		move.l	GainUGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)
		bsr	AddGads
		bsr	AddVTask
		rts
SetSamp4:	bsr	RemVTask1
		move.b	#SAMP_GENERIC,PrefsSampType		;Generic
		move.l	#SAMP_GENERIC,d0
		clr.l	d1
		lib	Voice,PickSampler
		bsr	RemGads
		move.l	GainUGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)
		bsr	AddGads
		bsr	AddVTask
		rts

DoSetTimerA:	bsr	SetTimerA
		bra	Window1IDCMP

DoSetTimerB:	bsr	SetTimerB
		bra	Window1IDCMP

SetTimerA:	bsr	RemVTask1
		move.b	#TIMER_A,PrefsTimer		;Timer A=1
		move.l	#TIMER_A,d0
		lib	Voice,PickTimer
		bsr	AddVTask
		rts

SetTimerB:	bsr	RemVTask1
		move.b	#TIMER_B,PrefsTimer		;Timer B=0
		move.l	#TIMER_B,d0
		lib	Voice,PickTimer
		bsr	AddVTask
		rts

ToFront:	tst.l	Window1
		beq	ToFront_OUT
		move.l	Window1,a0
		lib	Intuition,WindowToFront
ToFront_OUT:	rts

ToBack:		tst.l	Window
		beq	ToBack_OUT
		move.l	Window1,a0
		lib	Intuition,WindowToBack
ToBack_OUT:	rts

Zoom:		tst.l	Window1
		beq	Zoom_OUT
		move.l	Window1,a0
		lib	Intuition,ZipWindow
Zoom_OUT:	rts

DoLoad:		bsr	Load			;RemVTask1 in Load
		bsr	AddVTask
		move.l	#5,d1
		lib	Dos,Delay
		bra	ActivateGads

DoDataLoad:	bsr	RemGads				;RemVTask1 in Load
		bsr	Load2.1
		bsr	AddVTask
		bsr	AddGads			;Keep Add/RemGads (Load2.1)
		move.l	#5,d1
		lib	Dos,Delay
		bra	Window1IDCMP

DoOnOff:	move.l	#5625242,d5		;inform user
		bsr	AddVTask		;one or the other
		bsr	RemVTask		;will respond
		bra	Window1IDCMP

DoGainUp:	bsr	GainUp
		bra	Window1IDCMP
DoGainDown:	bsr	GainDown
		bra	Window1IDCMP

GainUp:		lib	Voice,GainUp
		cmp.b	#SAMP_DSS8,PrefsSampType
		bne	GainUp_OUT
		lib	Voice,WhatGain
		move.b	d0,PrefsGain
		move.l	d0,GainPointer

		tst.l	Window1
		beq	GainUp_OUT
		move.l	GainGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	GainGadTagList,a3
		lib	GadTools,GT_SetGadgetAttrsA
GainUp_OUT:	rts

GainDown:	lib	Voice,GainDown
		cmp.b	#SAMP_DSS8,PrefsSampType
		bne	GainDown_OUT
		lib	Voice,WhatGain
		move.b	d0,PrefsGain
		move.l	d0,GainPointer

		tst.l	Window1
		beq	GainDown_OUT
		move.l	GainGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	GainGadTagList,a3
		lib	GadTools,GT_SetGadgetAttrsA
GainDown_OUT:	rts

ActivateGads:	tst.l	Window1
		beq	ActivateGs_OUT
		move.l	DatStrGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
ActivateGs_OUT:	bra	Window1IDCMP

ActGad:		tst.l	Window1
		beq	ActGad_OUT
		move.l	DatStrGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
ActGad_OUT:	rts

ActivateGads2:	cmp.w	#55,$26(a5)
		beq	Get
		cmp.w	#1,$26(a5)
		beq	Learn
		cmp.w	#2,$26(a5)
		bne	Window2IDCMP
		cmp.l	#$00,(a5)
		beq	ActivateGads2.01
		move.l	(a5),a0
		move.l	StrGad20,a1
		cmp.l	a5,a1
		bne	ActivateGads2.1
ActivateGads2.01: move.l StrGad1,a0
ActivateGads2.1: move.l Window2,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
		bra	Window2IDCMP

ActGad2:	move.l	StrGad1,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
		rts

ActGad3:	move.l	StrGad21,a0
		move.l	Window3,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
		rts

Learn:		move.w	Page,d0
		mulu.w	#NUMGADS,d0
		move.l	$22(a5),a0
		move.l	(a0),a0
		cmp.l	StrGadBuf1,a0
		bne	Learn1
		add.w	#1,d0
		bra	Learn10
Learn1:		cmp.l	StrGadBuf3,a0
		bne	Learn2
		add.w	#2,d0
		bra	Learn10
Learn2:		cmp.l	StrGadBuf5,a0
		bne	Learn3
		add.w	#3,d0
		bra	Learn10
Learn3:		cmp.l	StrGadBuf7,a0
		bne	Learn4
		add.w	#4,d0
		bra	Learn10
Learn4:		cmp.l	StrGadBuf9,a0
		bne	Learn5
		add.w	#5,d0
		bra	Learn10
Learn5:		cmp.l	StrGadBuf11,a0
		bne	Learn6
		add.w	#6,d0
		bra	Learn10
Learn6:		cmp.l	StrGadBuf13,a0
		bne	Learn7
		add.w	#7,d0
		bra	Learn10
Learn7:		cmp.l	StrGadBuf15,a0
		bne	Learn8
		add.w	#8,d0
		bra	Learn10
Learn8:		cmp.l	StrGadBuf17,a0
		bne	Learn9
		add.w	#9,d0
		bra	Learn10
Learn9:		cmp.l	StrGadBuf19,a0
		bne	Learn10
		add.w	#10,d0

Learn10:	sub.w	#1,d0
		lea.l	MapBuffer,a0
		move.l	$22(a5),a1
		move.l	(a1),a1
		sub.l	a2,a2		;screen
		move.l	#220,d1
		move.l	#42,d2
		lib	Voice,Learn
		move.l	(a5),a0
		bra	ActivateGads2.1

Load:		bsr	RemVTask1

		move.l	FromFile,d1		;If set to something else
		bne	Load1
		lea.l	PrefsName,a0
		move.l	a0,d1
Load1:		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PrefsFile
		beq	Load_ERR1

		move.l	PrefsFile,d1
		lea.l	Prefs,a0
		move.l	a0,d2
		move.l	#4,d3
		lib	Dos,Read
		cmp.l	#4,d0
		bne	Load_ERR2

		cmp.l	#VSFileVersion,Prefs
		bne	Load_ERR3

		move.l	PrefsFile,d1
		add.l	#4,d2
		move.l	#PrefsSize-4,d3
		lib	Dos,Read
		cmp.l	#PrefsSize-4,d0
		bne	Load_ERR2

Load2:		bsr	SetModes		;fixes startup datafile bug
Load2.1:	move.l	DatStrGadBuf1,d1	;jump here to load data file
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,DataFile
		beq	Load_ERR1.1

		move.l	DataFile,d1
		lea.l	MapBuffer,a0
		move.l	a0,d2
		move.l	#DataSize,d3
		lib	Dos,Read
		cmp.l	#DataSize,d0
		bne	Load_ERR2

		move.w	#1,Saved

Load_OUT:	move.l	DataFile,d1
		beq	Load_OUT0.1
		lib	Dos,Close
		clr.l	DataFile
Load_OUT0.1:	move.l	PrefsFile,d1
		beq	Load_OUT1
		lib	Dos,Close
		clr.l	PrefsFile

Load_OUT1:	rts

Load_ERR1:	lea.l	File_ERRTxt1,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load2

Load_ERR1.1:	lea.l	File_ERRTxt4,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load_OUT

Load_ERR2:	lea.l	File_ERRTxt2,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load2

Load_ERR3:	lea.l	File_ERRTxt3,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load2

Save:		bsr	CheckModes

		move.l	FromFile,d1		;If set to something else
		bne	Save1
		lea.l	PrefsName,a0
		move.l	a0,d1
Save1:		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,PrefsFile
		beq	Save_ERR1

		move.l	#VSFileVersion,Prefs

		move.l	PrefsFile,d1
		lea.l	Prefs,a0
		move.l	a0,d2
		move.l	#PrefsSize,d3
		lib	Dos,Write
		cmp.l	#PrefsSize,d0
		bne	Save_ERR2

Save2:		move.l	DatStrGadBuf1,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,DataFile
		beq	Save_ERR1.1

		move.l	DataFile,d1
		lea.l	MapBuffer,a0
		move.l	a0,d2
		move.l	#DataSize,d3
		lib	Dos,Write
		cmp.l	#DataSize,d0
		bne	Save_ERR2

		move.w	#1,Saved

Save_OUT:	move.l	DataFile,d1
		beq	Save_OUT0.1
		lib	Dos,Close
		clr.l	DataFile
Save_OUT0.1:	move.l	PrefsFile,d1
		beq	Save_OUT1
		lib	Dos,Close
		clr.l	PrefsFile
Save_OUT1:	bra	ActivateGads

Save_ERR1:	lea.l	File_ERRTxt1,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		clr.w	Saved
		bra	Save2

Save_ERR1.1:	lea.l	File_ERRTxt4,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		clr.w	Saved
		bra	Save_OUT

Save_ERR2:	lea.l	File_ERRTxt2,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		clr.w	Saved
		bra	Save_OUT

About:		move.w	#-1,DisActive
		bsr	RemVTask1
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		move.l	Window1,a0
		lea.l	AboutTxt1,a1
		sub.l	a2,a2		;positive text
		lea.l	OKTxt,a3	;a bit the wrong way around but...
		clr.l	d0
		clr.l	d1
		move.l	#320,d2
		move.l	#$50,d3
		lib	Intuition,AutoRequest
		clr.w	DisActive
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bsr	AddVTask
		bra	Window1IDCMP

;This is an emergency exit.

Break:		lea.l	BreakText1,a0
		bsr	Printer
		clr.l	d0
		rts

AddVTask:	tst.l	Window1			;BUG: Turns on anyway
		beq	AddVTask1		;Window not open
		move.l	OnOffGad1,a0
		move.w	gg_Flags(a0),d0
		and.w	#SELECTED,d0
		cmp.w	#SELECTED,d0
		bne	AddVTask_OUT		;Already active
AddVTask1:	tst.w	TaskOn
		bne	AddVTask_OUT
		lea.l	MapBuffer,a0
		move.l	VoicePort,a1
		clr.l	d0
		clr.l	d1
		move.w	#VocabSIZE,d0
		move.b	PrefsSampRes,d1
		lib	Voice,AddVoiceTask

		move.l	PrefsPriority,d0
		lib	Voice,SetVoicePri

		move.w	#1,TaskOn

		cmp.l	#5625242,d5
		bne	AddVTask_OUT
		lea.l	TaskOnText1,a0
		bsr	GetLength
		bsr	Inform
		bsr	CXEnable
		clr.l	d5
AddVTask_OUT:	rts

RemVTask:	tst.l	Window1			;BUG: Turns off anyway?
		beq	RemVTask1		;Window not open
		move.l	#5625242,d5
		move.l	OnOffGad1,a0
		move.w	gg_Flags(a0),d0
		and.w	#SELECTED,d0
		cmp.w	#SELECTED,d0
		beq	RemVTask_OUT
RemVTask1:	tst.w	TaskOn
		beq	RemVTask_OUT

		lib	Exec,Forbid
		bsr	C3GetMsg1		;Clear messages
		lib	Exec,Permit
		lib	Voice,RemVoiceTask

		clr.w	TaskOn
		cmp.l	#5625242,d5
		bne	RemVTask_OUT
		lea.l	TaskOffText1,a0
		bsr	GetLength
		bsr	Inform
		bsr	CXDisable
RemVTask_OUT:	rts

SetModes:	tst.l	Window1
		beq	SetModes_OUT2

		bsr	RemGads

		clr.l	GainPointer
		move.b	PrefsGain,GainPointer+3

		move.l	OnOffGad1,a0
		and.w	#~SELECTED,gg_Flags(a0)

		move.l	OnOffGad1,a0
		tst.b	PrefsOnOff
		beq	SetModes1
		or.w	#SELECTED,gg_Flags(a0)

SetModes1:	move.l	mlist,a0			;UnCheck SampType1
		move.l	#Samp1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck SampType2
		move.l	#Samp2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck SampType3
		move.l	#Samp3MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck SampType4
		move.l	#Samp4MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		cmp.b	#SAMP_PERFSND,PrefsSampType		;PerfectSound
		bne	SetModes2
		move.l	mlist,a0
		move.l	#Samp1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)
		move.l	GainUGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)

SetModes2:	cmp.b	#SAMP_SNDMSTR,PrefsSampType		;SoundMaster
		bne	SetModes2.1
		move.l	mlist,a0
		move.l	#Samp2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)
		move.l	GainUGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)

SetModes2.1:	cmp.b	#SAMP_DSS8,PrefsSampType		;DSS 8
		bne	SetModes2.2
		move.l	mlist,a0
		move.l	#Samp3MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)
		move.l	GainUGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		and.w	#~GADGDISABLED,gg_Flags(a0)

SetModes2.2:	cmp.b	#SAMP_GENERIC,PrefsSampType		;Generic
		bne	SetModes3
		move.l	mlist,a0
		move.l	#Samp4MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)
		move.l	GainUGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)
		move.l	GainDGad1,a0
		or.w	#GADGDISABLED,gg_Flags(a0)

SetModes3:	move.l	mlist,a0			;UnCheck ResLo
		move.l	#ResLoMenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck ResHi
		move.l	#ResHiMenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		cmp.b	#1,PrefsSampRes
		bne	SetModes4
		move.l	mlist,a0
		move.l	#ResLoMenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes4:	tst.b	PrefsSampRes
		bne	SetModes5
		move.l	mlist,a0
		move.l	#ResHiMenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes5:	move.l	mlist,a0			;UnCheck Lowest
		move.l	#Acc1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Lower
		move.l	#Acc2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Low
		move.l	#Acc3MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Normal
		move.l	#Acc4MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck High
		move.l	#Acc5MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Higher
		move.l	#Acc6MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Even higher
		move.l	#Acc7MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Maximum
		move.l	#Acc8MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		cmp.w	#AccVal1,PrefsScore
		bne	SetModes7
		move.l	mlist,a0
		move.l	#Acc1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes7:	cmp.w	#AccVal2,PrefsScore
		bne	SetModes8
		move.l	mlist,a0
		move.l	#Acc2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes8:	cmp.w	#AccVal3,PrefsScore
		bne	SetModes9
		move.l	mlist,a0
		move.l	#Acc3MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes9:	cmp.w	#AccVal4,PrefsScore
		bne	SetModes10
		move.l	mlist,a0
		move.l	#Acc4MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes10:	cmp.w	#AccVal5,PrefsScore
		bne	SetModes11
		move.l	mlist,a0
		move.l	#Acc5MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes11:	cmp.w	#AccVal6,PrefsScore
		bne	SetModes12
		move.l	mlist,a0
		move.l	#Acc6MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes12:	cmp.w	#AccVal7,PrefsScore
		bne	SetModes13
		move.l	mlist,a0
		move.l	#Acc7MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes13:	cmp.w	#AccVal8,PrefsScore
		bne	SetModes14
		move.l	mlist,a0
		move.l	#Acc8MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes14:	move.l	mlist,a0			;UnCheck Left
		move.l	#Chan1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Right
		move.l	#Chan2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Mic
		move.l	#Input1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Line
		move.l	#Input2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		cmp.b	#CHANNEL_LEFT,PrefsChannel
		bne	SetModes15
		move.l	mlist,a0
		move.l	#Chan1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes15:	cmp.b	#CHANNEL_RIGHT,PrefsChannel
		bne	SetModes16
		move.l	mlist,a0
		move.l	#Chan2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes16:	cmp.b	#INPUT_MIC,PrefsInput
		bne	SetModes17
		move.l	mlist,a0
		move.l	#Input1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes17:	cmp.b	#INPUT_LINE,PrefsInput
		bne	SetModes18
		move.l	mlist,a0
		move.l	#Input2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes18:	move.l	mlist,a0			;UnCheck Timer A
		move.l	#Timer1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		move.l	mlist,a0			;UnCheck Timer B
		move.l	#Timer2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		and.w	#~CHECKED,$c(a0)

		cmp.b	#TIMER_A,PrefsTimer
		bne	SetModes19
		move.l	mlist,a0
		move.l	#Timer1MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes19:	cmp.b	#TIMER_B,PrefsTimer
		bne	SetModes20
		move.l	mlist,a0
		move.l	#Timer2MenuN,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		or.w	#CHECKED,$c(a0)

SetModes20:	lea.l	DatBuffer,a0
		move.l	DatStrGadBuf1,a1
		move.l	#32,d0
		lib	Exec,CopyMem

		tst.l	Window1
		beq	SetModes21
		tst.l	OptionIconify
		beq	SetModes21
		move.l	Window1,a0
		move.w	Alt1XPos,d0
		move.w	Alt1YPos,d1
		move.w	wd_Width(a0),d2
		move.w	wd_Height(a0),d3
		lib	Intuition,ChangeWindowBox
		bra	SetModes22
SetModes21:	move.l	Alt1XPos,NewWindow1

;None of the below are allowed the assume the window is open, it might not
;be!

SetModes22:	cmp.b	#SAMP_PERFSND,PrefsSampType		;PerfectSound
		bne	SetModes23

		move.l	#SAMP_PERFSND,d0
		clr.l	d1
		lib	Voice,PickSampler

SetModes23:	cmp.b	#SAMP_SNDMSTR,PrefsSampType		;SoundMaster
		bne	SetModes24

		move.l	#SAMP_SNDMSTR,d0
		clr.l	d1
		lib	Voice,PickSampler

SetModes24:	cmp.b	#SAMP_DSS8,PrefsSampType		;DSS 8
		bne	SetModes25

		move.l	#SAMP_DSS8,d0
		clr.l	d1
		move.b	PrefsGain,d1
		lib	Voice,PickSampler

SetModes25:	cmp.b	#SAMP_GENERIC,PrefsSampType		;Generic
		bne	SetModes26

		move.l	#SAMP_GENERIC,d0
		clr.l	d1
		lib	Voice,PickSampler

SetModes26:	cmp.b	#CHANNEL_LEFT,PrefsChannel
		bne	SetModes27

		move.l	#CHANNEL_LEFT,d0
		lib	Voice,PickChannel

SetModes27:	cmp.b	#CHANNEL_RIGHT,PrefsChannel
		bne	SetModes28

		move.l	#CHANNEL_RIGHT,d0
		lib	Voice,PickChannel

SetModes28:	cmp.b	#INPUT_MIC,PrefsInput
		bne	SetModes29

		move.l	#INPUT_MIC,d0
		lib	Voice,PickInput

SetModes29:	cmp.b	#INPUT_LINE,PrefsInput
		bne	SetModes30

		move.l	#INPUT_LINE,d0
		lib	Voice,PickInput

SetModes30:	cmp.b	#TIMER_A,PrefsTimer
		bne	SetModes31

		move.l	#TIMER_A,d0
		lib	Voice,PickTimer

SetModes31:	cmp.b	#TIMER_B,PrefsTimer
		bne	SetModes32

		move.l	#TIMER_B,d0
		lib	Voice,PickTimer

SetModes32:

SetModes_OUT:	bsr	AddGads
		rts

;Here we do some 'patches' when the window isn't open and then do the
;normal stuff that needs to be done.

SetModes_OUT2:	lea.l	DatBuffer,a0
		move.l	a0,DatStrGadBuf1
		bra	SetModes22

CheckModes:	tst.l	Window1
		beq	CheckModes_OUT
		move.l	OnOffGad1,a0
		move.w	gg_Flags(a0),d0
		clr.b	PrefsOnOff
		and.w	#SELECTED,d0
		cmp.w	#SELECTED,d0
		bne	CheckModes1
		move.b	#$01,PrefsOnOff

CheckModes1:	move.l	DatStrGadBuf1,a0
		lea.l	DatBuffer,a1
		move.l	#32,d0
		lib	Exec,CopyMem

		tst.l	Window1
		beq	CheckModes_OUT
		move.l	Window1,a0
		move.l	wd_LeftEdge(a0),Alt1XY
CheckModes_OUT:	rts

RemGads:	tst.l	Window1
		beq	RemGads_OUT
		move.l	Window1,a0
		lea.l	glist,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RemoveGList
RemGads_OUT:	rts

AddGads:	tst.l	Window1
		beq	AddGads_OUT
		move.l	Window1,a0
		lea.l	glist,a1
		sub.l	a2,a2
		move.l	#-1,d0
		move.l	#-1,d1
		lib	Intuition,AddGList

		lea.l	glist,a0
		move.l	Window1,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	GainGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	GainGadTagList,a3
		lib	GadTools,GT_SetGadgetAttrsA

		move.l	Window1,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
AddGads_OUT:	rts

RemGads2:	move.l	Window2,a0
		lea.l	glist2,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RemoveGList
		rts

AddGads2:	move.l	Window2,a0
		lea.l	glist2,a1
		sub.l	a2,a2
		move.l	#-1,d0
		move.l	#-1,d1
		lib	Intuition,AddGList

		lea.l	glist2,a0
		move.l	Window2,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	Window2,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		rts

Quit:		tst.w	Saved
		bne	ShutDown
		bsr	RemVTask1
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		lea.l	QuitTxt1,a1
		lea.l	OKTxt,a2
		lea.l	CancelTxt,a3
		bsr	DoAutoRequest
		tst.l	d0
		bne	Quit2
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bsr	AddVTask
		bra	Window1IDCMP

Quit2:		bsr	MenusOn
		bsr	NormalPointer
		bsr	AddGads
		bsr	AddVTask
		bra	ShutDown

ShutDown:	bsr	RemVTask1
		tst.l	PubScreen
		beq	ShutDown9000
		sub.l	a0,a0
		move.l	PubScreen,a1
		lib	Intuition,UnlockPubScreen
		clr.l	PubScreen

ShutDown9000:	tst.l	CXBroker1
		beq	ShutDown8800

		lib	Exec,Forbid			;Remove all
		move.l	CXPort,a2			;pending messages

ClearCX1:	move.l	a2,a0
		flib	Exec,GetMsg
		tst.l	d0
		beq	ClearCX2
		move.l	d0,a1
		flib	Exec,ReplyMsg
		bra	ClearCX1
ClearCX2:	move.l	CXBroker1,a0
		lib	Commodities,DeleteCxObjAll
		lib	Exec,Permit

ShutDown8800:	bsr	CloseWin1
		bsr	CloseWin2
		bsr	CloseWin3
		bsr	Clean2.0Magic

ShutDown8000:	move.l	PrefsFile,d1
		beq	ShutDown7000
		lib	Dos,Close

ShutDown7000:	tst.l	NILFile
		beq	ShutDown6000
		move.l	NILFile,d1
		lib	Dos,Close

ShutDown6000:	tst.l	DiskObject
		beq	ShutDown5000
		move.l	DiskObject,a0
		lib	Icon,FreeDiskObject

ShutDown5000:	move.l	OldLock,d1
		beq	ShutDown4050
		lib	Dos,CurrentDir

ShutDown4050:	move.l	WBMsg,d2
		beq	ShutDown3000
		lib	Exec,Forbid
		move.l	d2,a1
		flib	Exec,ReplyMsg

ShutDown3000:	move.l	RDArgs1,d1
		beq	ShutDown2500
		lib	Dos,FreeArgs

ShutDown2500:	tst.l	AslReq
		beq	ShutDown2000
		move.l	AslReq,a0
		lib	Asl,FreeFileRequest

ShutDown2000:	move.l	VoicePort,a0		;Messages cleared earlier
		lib	Exec,DeleteMsgPort

		move.l	CXPort,a0		;Messages cleared earlier
		lib	Exec,DeleteMsgPort

		move.l	ARexxPort,a1			;Remove possible
		cmp.l	#$00,a1				;ports from lists
		beq	ShutDown1000			;and then delete
		lib	Exec,RemPort			;the ports

		flib	Exec,Forbid			;Remove all
		move.l	ARexxPort,a2			;pending messages

ClearARexx1:	move.l	a2,a0
		flib	Exec,GetMsg
		tst.l	d0
		beq	ClearARexx2
		move.l	d0,a1
		move.l	#RC_FATAL,RESULT1(a1)		;Fail all requests
		flib	Exec,ReplyMsg
		bra	ClearARexx1
ClearARexx2:	move.l	ARexxPort,a0
		flib	Exec,DeleteMsgPort
		flib	Exec,Permit

ShutDown1000:	closlib Voice
		closlib	Commodities
		closlib Icon
		closlib Intuition
		closlib GadTools
		closlib	Asl
		closlib	Utility
		closlib Dos

		move.l	OurTask,a1		;reset task pri after
		clr.l	d0			;voice.lib has been
		lib	Exec,SetTaskPri		;opened and closed

		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;CheckIDCMP gets messages from keyboard (CTRL_C/D/E), Intuition and
;voice.library, commodities.library and ARexx
;
;Give it the window structure in a0

CheckIDCMP:	clr.l	d1
		clr.l	d0
		cmp.l	#0,a0			;Window open?
		beq	CheckIDCMP1		;Nope ->
		move.l	$56(a0),a2		;Get window's port
		move.b	MP_SIGBIT(a2),d1	;IntuiMessages signals
		bset.l	d1,d0
CheckIDCMP1:	clr.l	d1			;Set signals for
		move.l	VoicePort,a0		;voice.library
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		clr.l	d1
		move.l	CXPort,a0		;commodities.library
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		clr.l	d1
		move.l	ARexxPort,a0		;ARexx
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		bset.l	#SIGBREAKB_CTRL_D,d0	;and CTRL_D
		bset.l	#SIGBREAKB_CTRL_E,d0	;and CTRL_E
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break
		cmp.l	#SIGBREAKF_CTRL_D,d0	;If CTRL_D
		bne	CheckIDCMP2		;inform about it
		move.l	#1,d0
		rts
CheckIDCMP2:	cmp.l	#SIGBREAKF_CTRL_E,d0	;If CTRL_E
		bne	CheckIDCMP3		;inform about it
		move.l	#2,d0
		rts
CheckIDCMP3:	move.l	VoicePort,a0		;If voice.library
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0
		bne	C3GetMsg1

		move.l	CXPort,a0		;If commodities.library
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0
		bne	C4GetMsg1

		move.l	ARexxPort,a0		;If ARexx
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0
		beq	C2GetMsg1

		bsr	DoARexx			;Go do ARexx magic
		rts

C2GetMsg1:	move.l	a2,a0			;If Intuition
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	C2GetMsg2
	
		move.l	d0,a1 
		move.l	im_Class(a1),d2		;answers with Class in d2,
		move.w	im_Code(a1),d3		;Code in d3 and
		move.w	im_Qualifier(a1),a4	;Qualifier in a4
		move.l	im_IAddress(a1),a5	;IAddress in a5
		lib	GadTools,GT_ReplyIMsg
		bra	C2GetMsg1
C2GetMsg2:	move.l	#-1,d0
		rts

C3GetMsg1:	move.l	VoicePort,a0
		lib	Exec,GetMsg
		tst.l	d0
		beq	C3GetMsg2
	
		move.l	d0,a1
		move.l	im_Class(a1),d2		;Class in d2 and
		move.w	im_Code(a1),d3		;Code in d3
		move.w	im_Qualifier(a1),a4	;Qualifier in a4

		lib	Exec,ReplyMsg
		bra	C3GetMsg1
C3GetMsg2:	move.l	#3,d0
		rts

C4GetMsg1:	move.l	CXPort,a0
		lib	Exec,GetMsg
		tst.l	d0
		beq	C4GetMsg_OUT

		move.l	d0,a2			;Message in a2

		move.l	a2,a0
		lib	Commodities,CxMsgType
		move.l	d0,d2			;Type in d2

		move.l	a2,a0
		lib	Commodities,CxMsgID
		move.l	d0,d3			;ID in d3

		move.l	a2,a1
		lib	Exec,ReplyMsg

		bsr	CX		;Go do magic stuff
		tst.l	d0
		bne	C4GetMsg1	;Loop all messages
		rts

C4GetMsg_OUT:	move.l	#4,d0			;Return as CX
		rts

;Newer MenuNull subroutine

MenuNull:	move.w	d3,d0
		and.w	#$1f,d0
		move.w	d0,d6
		move.w	d3,d0
		lsr.w	#5,d0
		move.w	d0,d1
		and.w	#$3f,d0
		move.w	d0,d5
		lsr.w	#6,d1
		move.w	d1,d4
		rts

;ARexx interface

DoARexx:	move.l	ARexxPort,a0
		lib	Exec,GetMsg

		move.l	#4,d2			;answer to Window1IDCMP
		tst.l	d0
		beq	DoARexx_OUT

		move.l	d0,a5
		cmp.l	#RXCOMM,ACTION(a5)
		bne	DoARexxReply

		tst.l	Window2		;Don't do ARexx while other
		bne	DoARexxFail	;windows are open!
		tst.l	Window3
		bne	DoARexxFail

		lea.l	RexxFront,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxFront

		lea.l	RexxBack,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxBack

		lea.l	RexxZoom,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxZoom

		lea.l	RexxHide,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxHide

		lea.l	RexxShow,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxShow

		lea.l	RexxOn,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxOn

		lea.l	RexxOff,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxOff

		lea.l	RexxQuit,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxQuit

		lea.l	RexxPerfSnd,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxPerfSnd

		lea.l	RexxSndMstr,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxSndMstr

		lea.l	RexxDSS8,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxDSS8

		lea.l	RexxGeneric,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxGeneric

		lea.l	RexxResLo,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxResLo

		lea.l	RexxResHi,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxResHi

		lea.l	RexxLowest,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxLowest

		lea.l	RexxLower,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxLower

		lea.l	RexxLow,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxLow

		lea.l	RexxNormal,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxNormal

		lea.l	RexxHigh,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxHigh

		lea.l	RexxHigher,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxHigher

		lea.l	RexxEHigher,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxEHigher

		lea.l	RexxMaximum,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxMaximum

		lea.l	RexxLeft,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxLeft

		lea.l	RexxRight,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxRight

		lea.l	RexxLine,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxLine

		lea.l	RexxMic,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxMic

		lea.l	RexxGainUp,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxGainUp

		lea.l	RexxGainDown,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxGainDown

		lea.l	RexxTimerA,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxTimerA

		lea.l	RexxTimerB,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxTimerB

		move.l	ARG0(a5),a1
		cmp.b	#'K',(a1)+
		bne	DoARexx2
		cmp.b	#'E',(a1)+
		bne	DoARexx2
		cmp.b	#'Y',(a1)+
		bne	DoARexx2
		cmp.b	#' ',(a1)+
		beq	DoRexxKeyInput

DoARexx2:	move.l	ARG0(a5),a1
		cmp.b	#'L',(a1)+
		bne	DoARexxFail
		cmp.b	#'O',(a1)+
		bne	DoARexxFail
		cmp.b	#'A',(a1)+
		bne	DoARexxFail
		cmp.b	#'D',(a1)+
		bne	DoARexxFail
		cmp.b	#' ',(a1)+
		beq	DoRexxLoad

DoARexxFail:	move.l	#RC_FATAL,RESULT1(a5)
		move.l	#4,d2
		bra	DoARexxReply

DoARexxOK:	move.l	#RC_OK,RESULT1(a5)
DoARexxReply:	move.l	a5,a1
		lib	Exec,ReplyMsg
DoARexx_OUT:	move.l	d2,d0
		rts


DoRexxFront:	bsr	ToFront
		move.l	#4,d2
		bra	DoARexxOK

DoRexxBack:	bsr	ToBack
		move.l	#4,d2
		bra	DoARexxOK

DoRexxZoom:	bsr	Zoom
		move.l	#4,d2
		bra	DoARexxOK

DoRexxHide:	bsr	DoCXDisappear
		move.l	#4,d2
		bra	DoARexxOK

DoRexxShow:	bsr	DoCXAppear
		move.l	#4,d2
		bra	DoARexxOK

DoRexxOn:	tst.w	DisActive
		bne	DoARexxFail
		push	a5
		bsr	CLITypeOn
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxOff:	tst.w	DisActive
		bne	DoARexxFail
		push	a5
		bsr	CLITypeOff
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxQuit:	clr.l	d2
		bra	DoARexxOK

DoRexxPerfSnd:	push	a5
		bsr	SetSamp1
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxSndMstr:	push	a5
		bsr	SetSamp2
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxDSS8:	push	a5
		bsr	SetSamp3
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxGeneric:	push	a5
		bsr	SetSamp4
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxResLo:	push	a5
		bsr	SetResLo
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxResHi:	push	a5
		bsr	SetResHi
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxLowest:	push	a5
		bsr	SetAccLowest
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxLower:	push	a5
		bsr	SetAccLower
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxLow:	push	a5
		bsr	SetAccLow
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxNormal:	push	a5
		bsr	SetAccNormal
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxHigh:	push	a5
		bsr	SetAccHigh
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxHigher:	push	a5
		bsr	SetAccHigher
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxEHigher:	push	a5
		bsr	SetAccEHigher
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxMaximum:	push	a5
		bsr	SetAccMaximum
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxLeft:	push	a5
		bsr	SetLeft
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxRight:	push	a5
		bsr	SetRight
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxLine:	push	a5
		bsr	SetLine
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxMic:	push	a5
		bsr	SetMic
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxGainUp:	push	a5
		bsr	GainUp
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxGainDown:	push	a5
		bsr	GainDown
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxTimerA:	push	a5
		bsr	SetTimerA
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxTimerB:	push	a5
		bsr	SetTimerB
		bsr	SetModes
		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxLoad:	push	a5

		move.l	a1,FromFile	;Fake CLI Input :)
		bsr	Load
		bsr	AddVTask

		pull	a5
		move.l	#4,d2
		bra	DoARexxOK

DoRexxKeyInput:	move.l	a1,a0
		lea.l	StringBuffer,a1
		bsr	CopyStrs

		bsr	SendEvents
		move.l	#4,d2
		tst.l	IEvents
		beq	DoARexxFail
		clr.l	IEvents
		bra	DoARexxOK

;SendEvents converts ARexx string to lower case and converts it into input
;events and merges these events into the input chain.
;
;Inputs	StringBuffer = String to send

SendEvents:	lea.l	StringBuffer,a2
		bsr	MakeLowerCase

;Convert string into Input Events

		move.l	#0,-(sp)
		pea	StringBuffer
		jsr	_InvertString
		add.l	#8,sp
		move.l	d0,IEvents
		beq	SendEvents2

;Send Input Events

		move.l	IEvents,a0
		lib	Commodities,AddIEvents

;Free Input Events

		move.l	IEvents,-(sp)
		jsr	_FreeIEvents
		add.l	#4,sp
SendEvents2:	rts

;Compares two strings.
;
;INPUT
;
;A0 String 1
;A1 String 2
;
;OUTPUT
;
;D0 = 0 if not same
;
;BUGS
;
;String 1 has to have NULL at end!
;

CmpStrings:	bsr	GetLength
		move.l	d0,d4		;length of string1 to d4
		push	a0
		move.l	a1,a0
		bsr	GetLength
		pull	a0
		cmp.l	d4,d0		;length of string2 in d3
		bne	CmpStrings1.1
CmpStrings1:	tst.b	(a0)
		beq	CmpStrings2
		cmp.b	(a0)+,(a1)+
		beq	CmpStrings1
CmpStrings1.1:	clr.l	d0
		rts
CmpStrings2:	move.l	#-1,d0
		rts

;Get length of text in given address
;
;Input a0 = Address of null terminated text string
;
;Result d0 = Length

GetLength:	push	a0
		clr.l	d0
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a0)+
		bne	GetLength2
		sub.l	#1,d0		;don't include NULL
GetLength_OUT:	pull	a0
		rts

;Inputs	a0 = ASCII number
;Output	d0 = Hexadecimal number

ConvASCII:	clr.l	d0
		clr.l	d1
		cmp.b	#' ',(a0)
		bne	ConvASCII2
		add.l	#1,a0
ConvASCII2:	move.b	(a0),d1
		cmp.b	#'0',d1
		bcs	ConvASCII_OUT
		cmp.b	#'9',d1
		bhi	ConvASCII_OUT
		sub.b	#'0',d1
		mulu.w	#10,d0
		add.l	d1,d0
		add.l	#1,a0
		bra	ConvASCII2
ConvASCII_OUT:	rts

;Inputs	a2 = Pointer to NULL terminated string to convert

MakeLowerCase:	tst.b	(a2)
		beq	MakeLowerCase3
		move.b	(a2),d0
		lib	Utility,ToLower
		move.b	d0,(a2)

MakeLowerCase2:	add.l	#1,a2
		bra	MakeLowerCase

MakeLowerCase3: rts

;Copies bytes from a0 to a1 until NULL is reached or maximum amount of 
;255 bytes is copied. Destination will include NULL
;
;Inputs	a0 = Source
;	a1 = Destination

CopyStrs:	move.l	#255,d0

CopyStrs1:	tst.b	(a0)
		beq	CopyStrs_OUT
		move.b	(a0)+,(a1)+
		sub.l	#1,d0
		beq	CopyStrs_OUT
		bra	CopyStrs1
CopyStrs_OUT:	clr.b	(a1)
		rts

;Joins path and filename together from ASL Requester.

MakeCmd:	move.l	AslReq,a0
		move.l	rf_Dir(a0),a1		;Source 1
		move.l	rf_File(a0),a2		;Source 2

		move.l	$22(a5),a0
		move.l	(a0),a3			;Destination

		clr.l	d0

MakeCmd1:	tst.b	(a1)
		beq	MakeCmd2
		cmp.l	#GADLENG2-1,d0
		bcc	MakeCmd2
		move.b	(a1)+,(a3)+
		add.l	#1,d0
		bra	MakeCmd1

MakeCmd2:	cmp.b	#':',-1(a3)
		beq	MakeCmd3
		tst.b	-1(a3)
		beq	MakeCmd3
		move.b	#'/',(a3)+

MakeCmd3:	tst.b	(a2)
		beq	MakeCmd4
		cmp.l	#GADLENG2-1,d0
		bcc	MakeCmd3
		move.b	(a2)+,(a3)+
		add.l	#1,d0
		bra	MakeCmd3

MakeCmd4:	clr.b	(a3)		;Add NULL to destination
		rts

SleepPointer:	tst.l	Window1
		beq	SleepPoint_OUT
		move.l	Window1,a0
		lea.l	ClockPointer1,a1
		move.l	#16,d0
		move.l	#16,d1			;WHAT-THE-HECK IS THIS FOR?
		move.l	#-6,d2
		move.l	#0,d3
		lib	Intuition,SetPointer
SleepPoint_OUT:	rts

NormalPointer:	tst.l	Window1
		beq	NormPoint_OUT
		move.l	Window1,a0
		lib	Intuition,ClearPointer
NormPoint_OUT:	rts

MenusOn:	tst.l	Window1
		beq	MenusOn_OUT
		move.l	Window1,a0
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
MenusOn_OUT:	rts

MenusOff:	tst.l	Window1
		beq	MenusOff_OUT
		move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
MenusOff_OUT:	rts

;Lock PublicScreen

LockPubScr:	move.l	OptPubScreen,a0
		lib	Intuition,LockPubScreen
		move.l	d0,PubScreen
		beq	LockPubScr_OUT

;Set default sizes

		move.w	#62,Win1YSize
		move.w	#138,Win2YSize
		move.w	#30,Win3YSize

;Get some sizes

		move.l	PubScreen,a0
		move.b	sc_BarHeight(a0),d0
		add.b	#1,d0
		move.b	d0,BHeight+1
		move.w	BHeight,d5
		add.w	d5,SmallYSize
		add.w	d5,Win1YSize
		add.w	d5,Win2YSize
		add.w	d5,Win3YSize
LockPubScr_OUT: rts

UnLockPubScr:	tst.l	PubScreen
		beq	UnLPubScr_OUT

		sub.l	a0,a0
		move.l	PubScreen,a1
		lib	Intuition,UnlockPubScreen
		clr.l	PubScreen
UnLPubScr_OUT:	rts

DoLayOut:	bsr	UnLockPubScr

		bsr	LockPubScr
		tst.l	PubScreen
		beq	NoPubScreen

;Get visualinfo

		move.l	PubScreen,a0
		sub.l	a1,a1
		lib	GadTools,GetVisualInfoA
		move.l	d0,vi

;Make gadget stuff

		lea.l	glist,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad
		beq	NoContextGad

		move.l	glist,a0
		lea.l	NGOnOffGad1,a1
		move.w	#ShellTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#CHECKBOX_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,OnOffGad1
		move.l	d0,a0

		lea.l	NGGainUGad,a1
		move.w	#ShellTop+1*(10+INTERHEIGHT),gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,GainUGad1

		lea.l	NGGainDGad,a1
		move.w	#ShellTop+2*(10+INTERHEIGHT),gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,GainDGad1

		lea.l	NGGainGad,a1
		move.w	#ShellTop+2*(10+INTERHEIGHT),gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GainGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,GainGad1

		lea.l	NGSaveGad,a1
		move.w	#OptionTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,SaveGad1

		lea.l	NGQuitGad,a1
		move.w	#OptionTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,QuitGad1
		or.w	#GRELRIGHT,gg_Flags(a0)

		lea.l	NGDatStrGad1,a1
		move.w	#ShellTop+28,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	DatStrGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,DatStrGad1
		move.l	d0,a0
		move.l	$22(a0),a1
		move.l	(a1),DatStrGadBuf1

		lea.l	NGStatusGad,a1
		move.w	#ShellTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StatGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,StatusGad1

		lea.l	NGLoadGad,a1
		move.w	#ShellTop+28,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,LoadGad1
		or.w	#GRELRIGHT,gg_Flags(a0)

		lea.l	glist2,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad2
		beq	NoContextGad

		move.l	glist2,a0
		lea.l	NGStrGad1,a1
		move.w	#ShellTop+15,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad1
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf1

		lea.l	NGStrGad2,a1
		move.w	#ShellTop+15,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad2
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf2

		lea.l	NGStrGad3,a1
		move.w	#ShellTop+25,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad3
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf3

		lea.l	NGStrGad4,a1
		move.w	#ShellTop+25,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad4
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf4

		lea.l	NGStrGad5,a1
		move.w	#ShellTop+35,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad5
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf5

		lea.l	NGStrGad6,a1
		move.w	#ShellTop+35,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad6
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf6

		lea.l	NGStrGad7,a1
		move.w	#ShellTop+45,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad7
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf7

		lea.l	NGStrGad8,a1
		move.w	#ShellTop+45,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad8
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf8

		lea.l	NGStrGad9,a1
		move.w	#ShellTop+55,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad9
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf9

		lea.l	NGStrGad10,a1
		move.w	#ShellTop+55,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad10
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf10

		lea.l	NGStrGad11,a1
		move.w	#ShellTop+65,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad11
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf11

		lea.l	NGStrGad12,a1
		move.w	#ShellTop+65,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad12
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf12

		lea.l	NGStrGad13,a1
		move.w	#ShellTop+75,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad13
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf13

		lea.l	NGStrGad14,a1
		move.w	#ShellTop+75,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad14
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf14

		lea.l	NGStrGad15,a1
		move.w	#ShellTop+85,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad15
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf15

		lea.l	NGStrGad16,a1
		move.w	#ShellTop+85,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad16
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf16

		lea.l	NGStrGad17,a1
		move.w	#ShellTop+95,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad17
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf17

		lea.l	NGStrGad18,a1
		move.w	#ShellTop+95,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad18
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf18

		lea.l	NGStrGad19,a1
		move.w	#ShellTop+105,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad19
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf19

		lea.l	NGStrGad20,a1
		move.w	#ShellTop+105,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad20
		move.l	d0,a0
		or.w	#GADGIMMEDIATE,gg_Activation(a0)
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf20

		lea.l	NGDesc1Gad,a1
		move.w	#ShellTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	DescGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0

		lea.l	NGDesc2Gad,a1
		move.w	#ShellTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	DescGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		lea.l	NGGetGad1,a1
		move.w	#ShellTop+120,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,GetGad1

		lea.l	glist3,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad3
		beq	NoContextGad

		move.l	glist3,a0
		lea.l	NGStrGad21,a1
		move.w	#ShellTop,gng_TopEdge(a1)
		add.w	d5,gng_TopEdge(a1)
		move.l	#INTEGER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList3,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad21
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		add.l	#si_LongInt,a1
		move.l	a1,StrGadInt21

		move.b	#1,GadMagic		;Make worked OK

;New style menu stuff

		lea.l	MNProjectMenu1,a0
		lea.l	MenuTagList,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist
		beq	NoMenus

		move.l	mlist,a0
		move.l	vi,a1
		lea.l	MenuTagList,a2
		lib	GadTools,LayoutMenusA

		lea.l	MNPageMenu1,a0
		lea.l	MenuTagList2,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist2
		beq	NoMenus

		move.l	mlist2,a0
		move.l	vi,a1
		lea.l	MenuTagList2,a2
		lib	GadTools,LayoutMenusA
		tst.l	d0
		beq	NoMenus
		move.b	#1,MenuMagic
		move.l	#-1,d0
		rts

;Open Window 1

OpenWin1:	tst.l	Window1
		bne	OpenWin1_OUT

		bsr	DoLayOut
		tst.l	d0
		beq	OpenWin1_ERR1

		move.l	OptPubScreen,Win1TagList.1
		tst.l	OptionIconify
		beq	OpenWin1.01
		lea.l	NewWindow1,a0
		and.l	#~ACTIVATE,nw_Flags(a0)
		move.l	NewWindow1,ZoomXY
		move.l	NewWindow1+4,ZoomXY+4
		move.l	Alt1XY,nw_LeftEdge(a0)
		move.w	#160,nw_Width(a0)
		move.w	BHeight,nw_Height(a0)
OpenWin1.01:	lea.l	NewWindow1,a0
		lea.l	Win1TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window1
		beq	OpenWin1_ERR1
		move.l	Window1,AslReqTags+4
		bsr	AddGads			;Window refreshed here
		move.l	Window1,a0
		move.l	$32(a0),RP
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
		bsr	ActGad
		bsr	UnLockPubScr
OpenWin1_OUT:	move.l	#-1,d0
		rts
OpenWin1_ERR1:	clr.l	d0
		rts		

CloseWin1:	tst.l	Window1
		beq	CloseWin1_OUT
CloseWin1.1:	move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1,a3
		bsr	ClearMSGs
CloseWin1_OUT:	clr.l	Window1
		rts

;Open Window 2 (Edit commands)

OpenWin2:	move.l	OptPubScreen,Win2TagList.1
		lea.l	NewWindow2,a0
		lea.l	Win2TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window2
		beq	OpenWin2_ERR1
		move.l	Window2,a0
		move.l	mlist2,a1
		lib	Intuition,SetMenuStrip
		bsr	AddGads2		;Window refreshed here
		move.l	#-1,d0
		rts
OpenWin2_ERR1:	clr.l	d0
		rts		

CloseWin2:	tst.l	Window2
		beq	CloseWin2_OUT
		move.l	Window2,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window2,a3
		bsr	ClearMSGs
CloseWin2_OUT:	clr.l	Window2
		rts

;Open Window 3 (Priority requester)

OpenWin3:	lea.l	NewWindow3,a0
		lea.l	glist3,a1
		move.l	a1,nw_FirstGadget(a0)
		lea.l	Win2TagList,a1		;Yes, use Win2's tags...
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window3
		beq	OpenWin3_ERR1

		move.l	Window3,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		move.l	#-1,d0
		rts
OpenWin3_ERR1:	clr.l	d0
		rts		

CloseWin3:	tst.l	Window3
		beq	CloseWin3_OUT
		move.l	Window3,a3
		bsr	ClearMSGs
CloseWin3_OUT:	clr.l	Window3
		rts

;ClearMsgs subroutine
;a3 = window structure

ClearMSGs:	lib	Exec,Forbid
		move.l	$56(a3),a2
ClearMsg1:	move.l	a2,a0
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1
		flib	GadTools,GT_ReplyIMsg
		bra	ClearMsg1
ClearMsg2:	move.l	a3,a0
		lib	Intuition,CloseWindow
		lib	Exec,Permit
ClearMsg3:	rts

Clean2.0Magic:	tst.b	GadMagic
		beq	Clean2.0M2
		move.l	glist,a0
		lib	GadTools,FreeGadgets
		move.l	glist2,a0
		lib	GadTools,FreeGadgets
		move.l	glist3,a0
		lib	GadTools,FreeGadgets

Clean2.0M2:	tst.b	MenuMagic
		beq	Clean2.0M3
		move.l	mlist,a0
		lib	GadTools,FreeMenus
		move.l	mlist2,a0
		lib	GadTools,FreeMenus

Clean2.0M3:	tst.l	vi
		beq	Clean2.0_OUT
		move.l	vi,a0
		lib	GadTools,FreeVisualInfo

Clean2.0_OUT:	rts

;Error etc. messages

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

NoMsgPort:	lea.l	NoMsgPortText1,a0
		bsr	Printer
		bra	ShutDown

NoMsgPort2:	lea.l	NoMsgPortText2,a0
		bsr	Printer
		bra	ShutDown

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoInt:		lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

NoCommodities:	lea.l	NoCommoText1,a0
		bsr	Printer
		bra	ShutDown

NoAsl:		lea.l	NoAslText1,a0
		bsr	Printer
		bra	ShutDown

NoAslReq:	lea.l	NoAslReqText1,a0
		bsr	Printer
		bra	ShutDown

NoUtility:	lea.l	NoUtilityText1,a0
		bsr	Printer
		bra	ShutDown

NoVoice:	lea.l	NoVoiceText1,a0
		bsr	Printer
		bra	ShutDown

NoGadTools:	lea.l	NoGTText1,a0
		bsr	Printer
		bra	ShutDown

NoIcon:		lea.l	NoIconText1,a0
		bsr	Printer
		bra	ShutDown

NoPubScreen:	lea.l	NoPubScrText1,a0
		bsr	Printer
		clr.l	d0
		rts

NoWindow1:	lea.l	NoWindowText1,a0
		bsr	Printer
		bra	ShutDown

NoContextGad:	lea.l	NoContextText1,a0
		bsr	Printer
		clr.l	d0
		rts

NoMenus:	lea.l	NoMenusText1,a0
		bsr	Printer
		clr.l	d0
		rts

NoCommodity:	lea.l	NoCommodityText1,a0
		bsr	Printer
		bra	ShutDown

NoFilter:	lea.l	BadPopKeyText1,a0
		bsr	Printer
		bra	NoCommodity

BadPriority:	lea.l	BadPriorityText1,a0
		bsr	Printer
		bra	NoCommodity

Printer:	printa	a0,_stdout
		rts

Inform:		tst.l	Window1
		beq	Inform_OUT
		push	a0
		move.l	a0,SGTL2
		move.l	StatusGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	StatGadTagList2,a3
		lib	GadTools,GT_SetGadgetAttrsA

		pull	a1
		bsr	SetTitle
Inform_OUT:	rts

;Give this the title pointer in a1

SetTitle:	tst.l	Window1
		beq	SetTitle_OUT
		push	a2
		move.l	Window1,a0
		move.l	#-1,a2
		lib	Intuition,SetWindowTitles
		pull	a2
SetTitle_OUT:	rts

;Does a normal AutoRequest
;
;INPUT
;
;a1 = Main text body
;a2 = Pos text
;a3 = Neg text

DoAutoRequest:	clr.l	d0
		clr.l	d1
		clr.l	d2
		clr.l	d3
		sub.l	a0,a0		;No win, cos' might be here b4 anything open
		lib	Intuition,AutoRequest
		rts

;Reservations

		libnames

_SysBase:	dc.l	0
_DOSBase:	dc.l	0
_CxBase:	dc.l	0

;Options

RDArgs1:	dc.l	0

CLArray1:
FromFile:	dc.l	0		;A pointer to filename of PREFS!
OptionIconify:	dc.l	0
OptPubScreen:	dc.l	0		;A pointer to pubscreen name
OptCXPri:	dc.l	0
OptCXPopKey:	dc.l	DefaultPopKey	;A pointer to popkey string
OptCXPopUp:	dc.l	0		;A pointer to 'Yes'/'No'
WBOptCXPri:	dc.l	0

;ASL Stuff

AslReq:		dc.l	0

;GadTools stuff

vi:		dc.l	0		;Visual Info
mlist:		dc.l	0
mlist2:		dc.l	0
ContextGad:	dc.l	0
ContextGad2:	dc.l	0
ContextGad3:	dc.l	0
GadMagic:	dc.b	0
MenuMagic:	dc.b	0

;Gadgets

OnOffGad1:	dc.l	0
GainUGad1:	dc.l	0
GainDGad1:	dc.l	0
GainGad1:	dc.l	0		;Gain number
SaveGad1:	dc.l	0
QuitGad1:	dc.l	0
DatStrGad1:	dc.l	0
DatStrGadBuf1:	dc.l	0		;Only a pointer!
StatusGad1:	dc.l	0
LoadGad1:	dc.l	0
GetGad1:	dc.l	0

StrGad1:	dc.l	0
StrGadBuf1:	dc.l	0		;Only a pointer!
StrGad2:	dc.l	0
StrGadBuf2:	dc.l	0		;Only a pointer!
StrGad3:	dc.l	0
StrGadBuf3:	dc.l	0		;Only a pointer!
StrGad4:	dc.l	0
StrGadBuf4:	dc.l	0		;Only a pointer!
StrGad5:	dc.l	0
StrGadBuf5:	dc.l	0		;Only a pointer!
StrGad6:	dc.l	0
StrGadBuf6:	dc.l	0		;Only a pointer!
StrGad7:	dc.l	0
StrGadBuf7:	dc.l	0		;Only a pointer!
StrGad8:	dc.l	0
StrGadBuf8:	dc.l	0		;Only a pointer!
StrGad9:	dc.l	0
StrGadBuf9:	dc.l	0		;Only a pointer!
StrGad10:	dc.l	0
StrGadBuf10:	dc.l	0		;Only a pointer!
StrGad11:	dc.l	0
StrGadBuf11:	dc.l	0		;Only a pointer!
StrGad12:	dc.l	0
StrGadBuf12:	dc.l	0		;Only a pointer!
StrGad13:	dc.l	0
StrGadBuf13:	dc.l	0		;Only a pointer!
StrGad14:	dc.l	0
StrGadBuf14:	dc.l	0		;Only a pointer!
StrGad15:	dc.l	0
StrGadBuf15:	dc.l	0		;Only a pointer!
StrGad16:	dc.l	0
StrGadBuf16:	dc.l	0		;Only a pointer!
StrGad17:	dc.l	0
StrGadBuf17:	dc.l	0		;Only a pointer!
StrGad18:	dc.l	0
StrGadBuf18:	dc.l	0		;Only a pointer!
StrGad19:	dc.l	0
StrGadBuf19:	dc.l	0		;Only a pointer!
StrGad20:	dc.l	0
StrGadBuf20:	dc.l	0		;Only a pointer!
StrGad21:	dc.l	0
StrGadInt21:	dc.l	0		;Only a pointer!

;display stuff

PubScreen:	dc.l	0
Window1:	dc.l	0
Window2:	dc.l	0
Window3:	dc.l	0
BHeight:	dc.w	0
RP:		dc.l	0


		ds.w	0

;Other stuff, part I

OurTask:	dc.l	0
PrefsFile:	dc.l	0
DataFile:	dc.l	0
NILFile:	dc.l	0
_stdout:	dc.l	0
WBMsg:		dc.l	0
DiskObject:	dc.l	0
OldLock:	dc.l	0
TaskOn:		dc.w	0		;0=Off, 1=On
TickCount:	dc.w	10		;Delay Status update
Page:		dc.w	0		;What page are we on ?
Saved:		dc.w	1		;0=No, 1=Yes
PopUp:		dc.w	1		;0=No, 1=Yes
DisActive:	dc.w	0		;0=Yes, 1=No. Can we turn on/off?
VoicePort:	dc.l	0		;Message port for voice.library
ARexxPort:	dc.l	0		;Our ARexx port
CXPort:		dc.l	0		;Message port for commodities
IEvents:	dc.l	0		;List of Input Events to add
LastGad:	dc.l	0		;Last active string gadget
CXBroker1:	dc.l	0		;Our commodities broker list

;Strings, error & other info

BreakText1:	dc.b	"***Break: VoiceShell",13,10,0
NoMsgPortText1: dc.b	"ERROR: Couldn't open message port!",13,10,0
NoMsgPortText2: dc.b	"ERROR: An ARexx port with the name 'VOICESHELL' already exists!",13,10,0
NoIntText1:	dc.b	"ERROR: Couldn't open intuition.library!",13,10,0
NoCommoText1:	dc.b	"ERROR: Couldn't open commodities.library!",13,10,0
NoAslText1:	dc.b	"ERROR: Couldn't open asl.library!",13,10,0
NoAslReqText1:	dc.b	"ERROR: Couldn't allocate ASL requester!",13,10,0
NoUtilityText1:	dc.b	"ERROR: Couldn't open utility.library!",13,10,0
NoVoiceText1:	dc.b	"ERROR: Couldn't open voice.library, version 8.2!",13,10,13,10
		dc.b	"CHECK: 1. Is the parallel port available?",13,10
		dc.b	"       2. Is another program using the voice.library?",13,10,0
NoGTText1:	dc.b	"ERROR: Couldn't open gadtools.library!",13,10,0
NoIconText1:	dc.b	"ERROR: Couldn't open icon.library!",13,10,0
NoPubScrText1:	dc.b	"ERROR: Couldn't lock PublicScreen!",13,10,0
NoContextText1: dc.b	"ERROR: Couldn't create context gadget!",13,10,0
NoMenusText1:	dc.b	"ERROR: Couldn't allocate menus structure!",13,10,0
NoWindowText1:	dc.b	"ERROR: Couldn't open window!",13,10,0
NoCommodityText1: dc.b	"ERROR: Couldn't create commodity!",13,10
		dc.b	"       Another copy of VoiceShell is probably running.",13,10,0
BadPopKeyText1:	dc.b	"ERROR: Bad hotkey setting!",13,10,0
BadPriorityText1: dc.b	"ERROR: Bad priority value!",13,10,0
File_ERRText1:	dc.b	"Couldn't open preferences file!",0
File_ERRText2:	dc.b	"File error!",0
File_ERRText3:	dc.b	"Incorrect file type or version!",0
File_ERRText4:	dc.b	"Couldn't open data file!",0
NoMatchText1:	dc.b	"No Match",0
LowVolText1:	dc.b	"Low Volume",0
ClippingText1:	dc.b	"Too Loud",0
NoisyText1:	dc.b	"Too Noisy",0
TaskOnText1:	dc.b	"Turned On",0
TaskOffText1:	dc.b	"Turned Off",0
ReadyText1:	dc.b	"Ready",0
InactiveText1:	dc.b	"Inactive",0
NoCMDText1:	dc.b	"No Command!",0
CMDFailText1:	dc.b	"Command Failed!",0

;Strings, names

CLTemplate1:	dc.b	"FROM/K,I=ICONIFY/S,PS=PUBSCREEN/K,"	;Cont'd
		dc.b	"PRI=CX_PRIORITY/N/K,PK=CX_POPKEY/K,PU=CX_POPUP/K",0
VSVersion:	dc.b	"$VER: VoiceShell "
		PROGVERSION
		dc.b	" (c) Copyright Tomi Blinnikka 1993",0
OKText1:	dc.b	"OK",0
CancelText1:	dc.b	"Cancel",0
PrefsName:	dc.b	"ENVARC:VoiceShell.PREFS",0
NILName:	dc.b	"CON:0/10/500/70/VoiceShell_Error/CLOSE/AUTO/WAIT",0
ICONIFYText1:	dc.b	"ICONIFY",0
PUBSCREENText1:	dc.b	"PUBSCREEN",0
CXPOPUPText1:	dc.b	"CX_POPUP",0
CXPOPKEYText1:	dc.b	"CX_POPKEY",0
CXPRIText1:	dc.b	"CX_PRIORITY",0
DefaultPopKey:	dc.b	"ctrl alt v",0
YESText1:	dc.b	"YES",0
NOText1:	dc.b	"NO",0
FROMText1:	dc.b	"FROM",0
AboutText1:	dc.b	"Name   : VoiceShell",0
AboutText2:	dc.b	"Version: "
		PROGVERSION
		dc.b	0
AboutText3:	dc.b	"Author : Tomi Blinnikka",0
AboutText4:	dc.b	"  (c) Copyright  1993",0

		IFD	VS_REGISTERED
AboutText5:	dc.b	"NOTE: Registered version",0
		ENDC

		IFND	VS_REGISTERED
AboutText5:	dc.b	"NOTE: Unregistered version",0
		ENDC
AboutText6:	dc.b	"Hotkey: ",0

QuitText1:	dc.b	"The data file has not been saved!",0
QuitText2:	dc.b	"Are you sure you want to quit?",0
VSName1:	dc.b	"VoiceShell",0
VSName2:	dc.b	"VoiceShell: Edit & Learn",0
VSName3:	dc.b	"Please enter:",0
VSTitle:	dc.b	"Voice recognition:",0
VSDesc:		dc.b	"Start programs with voice commands",0
GetText1:	dc.b	"Command to run",0

;ARexx strings

ARexxPortName:	dc.b	"VOICESHELL",0

;Window control

RexxFront:	dc.b	"FRONT",0
RexxBack:	dc.b	"BACK",0
RexxZoom:	dc.b	"ZOOM",0
RexxHide:	dc.b	"HIDE",0
RexxShow:	dc.b	"SHOW",0

;Misc

RexxOn:		dc.b	"ON",0
RexxOff:	dc.b	"OFF",0
RexxQuit:	dc.b	"QUIT",0

;Sampler settings

RexxPerfSnd:	dc.b	"PERFSND",0
RexxSndMstr:	dc.b	"SNDMSTR",0
RexxDSS8:	dc.b	"DSS8",0
RexxGeneric:	dc.b	"GENERIC",0

;Resolution

RexxResLo:	dc.b	"RESLO",0
RexxResHi:	dc.b	"RESHI",0

;Accuracy

RexxLowest:	dc.b	"LOWEST",0
RexxLower:	dc.b	"LOWER",0
RexxLow:	dc.b	"LOW",0
RexxNormal:	dc.b	"NORMAL",0
RexxHigh:	dc.b	"HIGH",0
RexxHigher:	dc.b	"HIGHER",0
RexxEHigher:	dc.b	"EVENHIGHER",0
RexxMaximum:	dc.b	"MAXIMUM",0

;Channel

RexxLeft:	dc.b	"LEFT",0
RexxRight:	dc.b	"RIGHT",0

;Input gain

RexxLine:	dc.b	"LINE",0
RexxMic:	dc.b	"MIC",0

RexxGainUp:	dc.b	"GAINUP",0
RexxGainDown:	dc.b	"GAINDOWN",0

RexxTimerA:	dc.b	"TIMERA",0
RexxTimerB:	dc.b	"TIMERB",0

;Others not defined here:
;
;	LOAD
;	KEY
;

		ds.w	0

;New screen & new window structures

NewWindow1:	dc.w	200,31			;X,Y POS
		dc.w	320			;WIDTH
Win1YSize:	dc.w	0			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!INTUITICKS!ACTIVEWINDOW!CLOSEWINDOW!VANILLAKEY!MENUPICK!GADGETUP	;IDCMP FLAGS
		dc.l	SMART_REFRESH!WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	VSName1			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win1TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	WA_PubScreenName
Win1TagList.1:	dc.l	0
		dc.l	WA_Zoom,ZoomXY
		dc.l	TAG_DONE,0

ZoomXY:
SmallXPos:	dc.w	10
SmallYPos:	dc.w	21
SmallXSize:	dc.w	160
SmallYSize:	dc.w	0

NewWindow2:	dc.w	100,42			;X,Y POS
		dc.w	430			;WIDTH
Win2YSize:	dc.w	0			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!CLOSEWINDOW!VANILLAKEY!MENUPICK!GADGETUP!GADGETDOWN	;IDCMP FLAGS
		dc.l	SMART_REFRESH!WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	VSName2			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win2TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	WA_PubScreenName
Win2TagList.1:	dc.l	0
		dc.l	TAG_DONE,0

NewWindow3:	dc.w	220,42			;X,Y POS
		dc.w	200			;WIDTH
Win3YSize:	dc.w	0			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!ACTIVEWINDOW!CLOSEWINDOW!VANILLAKEY!GADGETUP	;IDCMP FLAGS
		dc.l	SMART_REFRESH!WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	VSName3			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE


;Fonts

Topaz:		dc.l	TopazName
		dc.w	8
		dc.b	0
		dc.b	0
TopazName:	dc.b	"topaz.font",0
		ds.w	0


;ASL stuff

AslReqTags:	dc.l	ASL_Window
		dc.l	0			;Move window pointer here!
		dc.l	TAG_DONE,0
GetReqTags:	dc.l	ASL_Hail,GetText1
		dc.l	ASL_Dir,0
		dc.l	ASL_File,0
		dc.l	ASL_FuncFlags,0
		dc.l	TAG_DONE,0

;ITextStructures

OKTxt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OKText1			;TEXT
		dc.l	0			;NEXTTEXT

CancelTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	CancelText1		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText1		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText2		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText3		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt4:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText4		;TEXT
		dc.l	0			;NEXTTEXT

AboutTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT

AboutTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT

AboutTxt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT

AboutTxt4:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	AboutTxt5		;NEXTTEXT

AboutTxt5:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText5		;TEXT
		dc.l	AboutTxt6		;NEXTTEXT

AboutTxt6:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText6		;TEXT
		dc.l	AboutTxt7		;NEXTTEXT

AboutTxt7:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
AboutTxt7.X:	dc.l	0			;TEXT
		dc.l	0 ;AboutTxt8		;NEXTTEXT

QuitTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	QuitText1		;TEXT
		dc.l	QuitTxt2		;NEXTTEXT

QuitTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	QuitText2		;TEXT
		dc.l	0 ;QuitTxt3		;NEXTTEXT

;Gadgets

OnOffGadText1:	dc.b	"On/Off",0
GainUGadText1:	dc.b	"Vol _Up",0
GainDGadText1:	dc.b	"Vol _Dwn",0
SaveGadText1:	dc.b	"_Save",0
QuitGadText1:	dc.b	"_Quit",0
DatGadText1:	dc.b	"Data _file",0
StatGadText1:	dc.b	"Status",0
LoadGadText1:	dc.b	"_Load",0
DescGadText1:	dc.b	"Description",0
DescGadText2:	dc.b	"Command to run",0
GetGadText1:	dc.b	"_Get",0
PriGadText1:	dc.b	"Priority",0
		ds.w	0

glist:		dcb.b	gg_SIZEOF,0
glist2:		dcb.b	gg_SIZEOF,0
glist3:		dcb.b	gg_SIZEOF,0

NGOnOffGad1:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	0		;gng_Width
		dc.w	13		;gng_Height
		dc.l	OnOffGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	10		;gng_GadgetID
		dc.l	PLACETEXT_RIGHT ;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGGainUGad:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	GainUGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	20		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGGainDGad:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	GainDGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	30		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGGainGad:	dc.w	10+60+INTERWIDTH-3	;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSaveGad:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	SaveGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	98		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGQuitGad:	dc.w	-70		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	QuitGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	99		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGDatStrGad1:	dc.w	100		;gng_LeftEdge
		dc.w	ShellTop+28	;gng_TopEdge
		dc.w	135		;gng_Width
		dc.w	12		;gng_Height
		dc.l	DatGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	PLACETEXT_BELOW ;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStatusGad:	dc.w	100		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	199		;gng_Width
		dc.w	12		;gng_Height
		dc.l	StatGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_BELOW ;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGLoadGad:	dc.w	-70		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	LoadGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	40		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Gadget TagLists

GadTagList:	dc.l	GT_Underscore,'_'
		dc.l	TAG_DONE,0

GainGadTagList:	dc.l	GTNM_Border,TRUE
		dc.l	GTNM_Number
GainPointer:	dc.l	0
		dc.l	TAG_DONE,0

StatGadTagList: dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE,0

StatGadTagList2: dc.l	GTTX_Border,TRUE
		dc.l	GTTX_Text
SGTL2:		dc.l	0
		dc.l	TAG_DONE,0

DatStrGadTagList: dc.l	GTST_String,DatBuffer
		dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,32
		dc.l	TAG_DONE,0

DisabledTags:	dc.l	GA_DISABLED,TRUE
		dc.l	TAG_DONE,0

EnabledTags:	dc.l	GA_DISABLED,FALSE
		dc.l	TAG_DONE,0

;Gadgets for edit window

NGDesc1Gad:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	DescGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGDesc2Gad:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	DescGadText2	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad1:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad2:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad3:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad4:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad5:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad6:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad7:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad8:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad9:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad10:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad11:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad12:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad13:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad14:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad15:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad16:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad17:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad18:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad19:	dc.w	10		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad20:	dc.w	120		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	300		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGGetGad1:	dc.w	185		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	GetGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	55		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

DescGadTagList: dc.l	GTTX_Border,1
		dc.l	TAG_DONE,0

StrGadTagList1: dc.l	GTST_MaxChars,GADLENG1-1
		dc.l	TAG_DONE,0
StrGadTagList2: dc.l	GTST_MaxChars,GADLENG2-1
		dc.l	TAG_DONE,0
StrGadTagList3: dc.l	GTIN_Number,120
		dc.l	TAG_DONE,0

NGStrGad21:	dc.w	60		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	80		;gng_Width
		dc.w	12		;gng_Height
		dc.l	PriGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_BELOW ;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData


;Menus

Menu1Name:	dc.b	"Project",0
Menu2Name:	dc.b	"Commands",0
Menu3Name:	dc.b	"Setup",0

LoadMenuText1:	dc.b	"Load",0
LoadCommKey:	dc.b	"L",0
SaveMenuText1:	dc.b	"Save",0
SaveCommKey:	dc.b	"S",0
AboutMenuText1: dc.b	"About...",0
AboutCommKey:	dc.b	"?",0
QuitMenuText1:	dc.b	"Quit",0
QuitCommKey:	dc.b	"Q",0
EditMenuText1:	dc.b	"Edit/Learn",0
EditCommKey:	dc.b	"E",0

TypeMenuText1:	dc.b	"Sampler",0
PerfSMenuText1: dc.b	"PerfectSound",0
Type1CommKey:	dc.b	"1",0
SoundMMenuText1: dc.b	"SoundMaster",0
Type2CommKey:	dc.b	"2",0
DSSMenuText1:	dc.b	"GVP DSS 8",0
Type3CommKey:	dc.b	"3",0
GenericMenuText1: dc.b	"Generic",0
Type4CommKey:	dc.b	"4",0

ResMenuText1:	dc.b	"Resolution",0
ResLoMenuText1: dc.b	"Low",0
Res1CommKey:	dc.b	"-",0
ResHiMenuText1: dc.b	"High",0
Res2CommKey:	dc.b	"+",0

AccMenuText1:	dc.b	"Accuracy",0
AccLo1MenuText1: dc.b	"Lowest",0
Acc1CommKey:	dc.b	"T",0
AccLo2MenuText1: dc.b	"Lower",0
Acc2CommKey:	dc.b	"W",0
AccLo3MenuText1: dc.b	"Low",0
Acc3CommKey:	dc.b	"O",0
AccNoMenuText1: dc.b	"Normal",0
Acc4CommKey:	dc.b	"N",0
AccHi1MenuText1: dc.b	"High",0
Acc5CommKey:	dc.b	"H",0
AccHi2MenuText1: dc.b	"Higher",0
Acc6CommKey:	dc.b	"I",0
AccHi3MenuText1: dc.b	"Even higher",0
Acc7CommKey:	dc.b	"G",0
AccHi4MenuText1: dc.b	"Maximum",0
Acc8CommKey:	dc.b	"M",0

ChanMenuText1:	dc.b	"Channel",0
Chan1MenuText1: dc.b	"Left",0
Chan1CommKey:	dc.b	",",0
Chan2MenuText1: dc.b	"Right",0
Chan2CommKey:	dc.b	".",0

InputMenuText1:	dc.b	"Input level",0
Input1MenuText1: dc.b	"Microphone",0
Input1CommKey:	dc.b	"/",0
Input2MenuText1: dc.b	"Line",0
Input2CommKey:	dc.b	"*",0

TimerMenuText1: dc.b	"CIA Timer",0
TimerAMenuText1: dc.b	"Timer A",0
TimerACommKey:	dc.b	"A",0
TimerBMenuText1: dc.b	"Timer B",0
TimerBCommKey:	dc.b	"B",0

PriMenuText1:	dc.b	"Priority...",0
PriCommKey:	dc.b	"P",0

Menu1Name2:	dc.b	"Page",0
EditMenu1Text1: dc.b	"Commands  1-10",0
Edit1CommKey:	dc.b	"1",0
EditMenu2Text1: dc.b	"Commands 11-20",0
Edit2CommKey:	dc.b	"2",0
EditMenu3Text1: dc.b	"Commands 21-30",0
Edit3CommKey:	dc.b	"3",0
EditMenu4Text1: dc.b	"Commands 31-40",0
Edit4CommKey:	dc.b	"4",0
EditMenu5Text1: dc.b	"Commands 41-50",0
Edit5CommKey:	dc.b	"5",0
EditMenu6Text1: dc.b	"Commands 51-60",0
Edit6CommKey:	dc.b	"6",0
		ds.l	0

MNProjectMenu1: dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNLoad1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	LoadMenuText1		;gnm_Label
		dc.l	LoadCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSave1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SaveMenuText1		;gnm_Label
		dc.l	SaveCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAbout1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AboutMenuText1		;gnm_Label
		dc.l	AboutCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP1SepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNQuit1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	QuitMenuText1		;gnm_Label
		dc.l	QuitCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNCmdMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu2Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNEdit1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenuText1		;gnm_Label
		dc.l	EditCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSetUpMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu3Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNType1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	TypeMenuText1		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTypeSub1:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PerfSMenuText1		;gnm_Label
		dc.l	Type1CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTypeSub2:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SoundMMenuText1		;gnm_Label
		dc.l	Type2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTypeSub3:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	DSSMenuText1		;gnm_Label
		dc.l	Type3CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~4			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTypeSub4:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	GenericMenuText1	;gnm_Label
		dc.l	Type4CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~8			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNRes1:		dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	ResMenuText1		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNResSub1:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	ResLoMenuText1		;gnm_Label
		dc.l	Res1CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNResSub2:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	ResHiMenuText1		;gnm_Label
		dc.l	Res2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccuracy1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccMenuText1		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccurarySub1:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccLo1MenuText1		;gnm_Label
		dc.l	Acc1CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccurarySub2:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccLo2MenuText1		;gnm_Label
		dc.l	Acc2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccurarySub3:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccLo3MenuText1		;gnm_Label
		dc.l	Acc3CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~4			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccurarySub4:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccNoMenuText1		;gnm_Label
		dc.l	Acc4CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~8			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccuracySub5:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccHi1MenuText1		;gnm_Label
		dc.l	Acc5CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~16			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccuracySub6:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccHi2MenuText1		;gnm_Label
		dc.l	Acc6CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~32			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccuracySub7:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccHi3MenuText1		;gnm_Label
		dc.l	Acc7CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~64			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAccuracySub8:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AccHi4MenuText1		;gnm_Label
		dc.l	Acc8CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~128			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNChannel1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	ChanMenuText1		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNChanSub1:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Chan1MenuText1		;gnm_Label
		dc.l	Chan1CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNChanSub2:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Chan2MenuText1		;gnm_Label
		dc.l	Chan2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNInput1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	InputMenuText1		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNInputSub1:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Input1MenuText1		;gnm_Label
		dc.l	Input1CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNInputSub2:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Input2MenuText1		;gnm_Label
		dc.l	Input2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTimer1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	TimerMenuText1		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTimerSub1:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	TimerAMenuText1		;gnm_Label
		dc.l	TimerACommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNTimerSub2:	dc.b	NM_SUB			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	TimerBMenuText1		;gnm_Label
		dc.l	TimerBCommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPriority:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PriMenuText1		;gnm_Label
		dc.l	PriCommKey		;gnm_CommKey
		dc.w	0 ;NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;NM_END?

;Menu TagList(s)

MenuTagList:	dc.l	GTMN_Menu,MNProjectMenu1
		dc.l	TAG_DONE,0

MNPageMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name2		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenu1Text1		;gnm_Label
		dc.l	Edit1CommKey		;gnm_CommKey
		dc.w	CHECKIT!CHECKED		;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenu2Text1		;gnm_Label
		dc.l	Edit2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage3:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenu3Text1		;gnm_Label
		dc.l	Edit3CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~4			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage4:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenu4Text1		;gnm_Label
		dc.l	Edit4CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~8			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage5:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenu5Text1		;gnm_Label
		dc.l	Edit5CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~16			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage6:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	EditMenu6Text1		;gnm_Label
		dc.l	Edit6CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~32			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP2SepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNQuit2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	QuitMenuText1		;gnm_Label
		dc.l	QuitCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;NM_END?

;Menu TagList(s) for Edit window

MenuTagList2:	dc.l	GTMN_Menu,MNPageMenu1
		dc.l	TAG_DONE,0

;Commodities stuff (Brokers etc..)

NewBroker1:	dc.b NB_VERSION,0		;Version, Reserved 1
		dc.l VSName1,VSTitle,VSDesc	;Name, Title, Description
		dc.w NBU_UNIQUE!NBU_NOTIFY,COF_SHOW_HIDE	;Uniq, Flags
NBPri:		dc.b 0,0			;Priority, Reserved 2
		dc.l 0				;Port
		dc.w 0				;Reserved channel

PREFS_START:

Prefs:		dc.l	VSFileVersion
PrefsOnOff:	dc.b	0		;0=Off, 1=On
PrefsSampType:	dc.b	SAMP_GENERIC	;0=Perf.Snd, 1=SndMstr, 2=Generic, 3=DSS8
PrefsSampRes:	dc.b	RES_HI		;0=High, 1=Low
PrefsTimer	dc.b	TIMER_B		;0=Timer B, 1=Timer A
PrefsGain:	dc.b	0		;DSS gain
PrefsChannel:	dc.b	CHANNEL_LEFT	;0=right, 1=left
PrefsInput:	dc.b	INPUT_LINE	;0=mic, 1=line
Pad1:		dc.b	0
PrefsPriority:	dc.l	120		;Priority
PrefsScore:	dc.w	AccVal4		;Score needed
Future1:	dc.l	0
Future2:	dc.l	0
Future3:	dc.l	0
Future4:	dc.l	0

Alt1XY:
Alt1XPos:	dc.w	200
Alt1YPos:	dc.w	31

DatBuffer:	dc.b	"S:VoiceShell.DAT"
		dcb.b	34-12,0

PREFS_END:	dc.l	0,0

PrefsSize:	EQU	(PREFS_END-PREFS_START)

		Section VS,BSS

DATA_START:

MapBuffer:	ds.b	(VocabSIZE*304)		;64 words

CmdList:	ds.b	(VocabSIZE*GADLENGTH)

DATA_END:	ds.l	1

DataSize:	EQU	(DATA_END-DATA_START)

StringBuffer:	ds.b	256

		Section VS,DATA,CHIP

		ds.w	0

ClockPointer1:	dc.w	$0000,$0000
		dc.w	$0400,$07C0,$0000,$07C0,$0100,$0380,$0000,$07E0
		dc.w	$07C0,$1FF8,$1FF0,$3FEC,$3FF8,$7FDE,$3FF8,$7FBE
		dc.w	$7FFC,$FF7F,$7EFC,$FFFF,$7FFC,$FFFF,$3FF8,$7FFE
		dc.w	$3FF8,$7FFE,$1FF0,$3FFC,$07C0,$1FF8,$0000,$07E0
		dc.w	$0000,$0000

		end
