*************************************************
*						*
*		 (C)opyright 1991		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	11/01/1992			*
*						*
* BUGS:	Version string incompatible.		*
*						*
* Version 0.02	05/06/1992			*
*						*
* BUGS:	Freezes machine sometimes when quit	*
*						*
* Version 0.03	07/12/1992			*
*						*
* BUGS:						*
*						*
*************************************************

;add prefs and config file

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"intuition/intuition.i"
	INCLUDE	"intuition/gadgetclass.i"
	INCLUDE	"libraries/gadtools.i"

	INCLUDE	"XREF:2.0.xref"

	INCLUDE	"XREF:gfx.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

TRUE:		EQU	1
DGadTools:	set	1

		section	SB,CODE

Start:		push	d2-d7/a2-a6
		push	a0

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a4
		move.l	$b8(a4),OldTaskWinPtr

		move.l	pr_CLI(a4),d0
		bne	OpenDos

		lea.l	pr_MsgPort(a4),a0
		lib	Exec,WaitPort
		lea.l	pr_MsgPort(a4),a0
		flib	Exec,GetMsg
		move.l	d0,WBMsg

OpenDos:	openlib	Dos,NoDos

		move.l	pr_CLI(a4),d0
		bne	CLIStart

		add.l	#4,sp
		lea.l	NILName,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
		beq	ShutDown
		move.l	NILFile,_stdout
		bra	MainStart

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout
		beq	ShutDown

		pull	a0
		cmp.b	#'?',(a0)
		beq	Usage
		cmp.w	#'-?',(a0)
		beq	Usage
		cmp.w	#'-h',(a0)
		beq	Usage

;To see if we have ks2.0 we'll try to open the gadtools.library

MainStart:	move.l	#37,d0
		lea.l	_GadToolsLib,a1
		lib	Exec,OpenLibrary
		move.l	d0,_GadToolsBase
		beq	NoKS20

		openlib	Intuition,NoInt

;Open screen and main window

		lea.l	NewScreen1,a0
		lea.l	Screen1TagList,a1
		lib	Intuition,OpenScreenTagList
		move.l	d0,Screen1
		beq	NoScreen

		move.l	Screen1,d0
		lea.l	NewWindow1,a0			;do stuff for win1
		move.l	d0,nw_Screen(a0)
		move.l	d0,a1
		move.b	sc_BarHeight(a1),BHeight+1
		add.w	#1,BHeight
		move.l	sc_Width(a1),nw_Width(a0)
		move.w	BHeight,d2
		move.w	d2,nw_TopEdge(a0)
		sub.w	d2,nw_Height(a0)

		lea.l	NewWindow2,a0			;do stuff for win2
		move.l	d0,nw_Screen(a0)
		add.w	d2,nw_Height(a0)

		lea.l	NewWindow3,a0			;do stuff for win3
		move.l	d0,nw_Screen(a0)
		add.w	d2,nw_Height(a0)

		add.w	d2,PubGad1Top

		add.l	#$2c,d0				;get ViewPort
		move.l	d0,VP1

		move.l	Screen1,a0
		clr.l	d0
		lib	Intuition,PubScreenStatus

		lea.l	PubName,a0
		lib	Intuition,SetDefaultPubScreen

		move.w	#SHANGHAI!POPPUBSCREEN,d0
		lib	Intuition,SetPubScreenModes
		move.l	d0,OldPubModes

;Do GadTools preparations, gadgets and menus

		lea.l	glist,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad
		beq	NoContextGad

		move.l	Screen1,a0
		lea.l	Screen1TagList,a1
		lib	GadTools,GetVisualInfoA
		move.l	d0,vi

		move.l	glist,a0
		lea.l	NGExecuteGad1,a1
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		sub.l	a2,a2
		lib	GadTools,CreateGadgetA
		move.l	d0,a0

		add.w	#GRELBOTTOM,$c(a0)

		lea.l	NGCommandGad1,a1
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	CommandGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,CommandGad1
		move.l	d0,a0
		move.l	$22(a0),a1
		move.l	(a1),CommandGadBuf
		add.w	#GRELBOTTOM,$c(a0)

		lea.l	NGOKGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA
		move.l	d0,a0

		add.w	#GRELBOTTOM,$c(a0)

		lea.l	NGCancelGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA
		move.l	d0,a0

		add.w	#GRELBOTTOM+GRELRIGHT,$c(a0)

		lea.l	MNProjectMenu1,a0
		lea.l	MenuTagList,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist
		beq	NoMenus

		move.l	mlist,a0
		move.l	vi,a1
		lea.l	MenuTagList,a2
		lib	GadTools,LayoutMenusA

		lea.l	MNProjectMenu2,a0
		lea.l	MenuTagList,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist2
		beq	NoMenus

		move.l	mlist2,a0
		move.l	vi,a1
		lea.l	MenuTagList2,a2
		lib	GadTools,LayoutMenusA

		bsr	OpenWin1
		tst.l	d0
		beq	NoWindow

;move requesters to Window1

		move.l	OurTask,a0
		move.l	Window1,$b8(a0)

		move.l	Window1,a0
		lib	Intuition,WindowToFront

;Start of main loop

Window1IDCMP:	move.l	Window1,a0
		bsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2
		beq	Quit
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#RAWKEY,d2
;		beq	RawKeys
		cmp.l	#GADGETUP,d2
		beq	GadgetSelect
		cmp.l	#ACTIVEWINDOW,d2
;		beq	ActivateGads
		bra	Window1IDCMP

GadgetSelect:	cmp.w	#51,$26(a5)
		beq	DoPubState
		bra	Window1IDCMP

DoPubState:	move.w	gg_Flags(a5),d0
		and.w	#SELECTED,d0
		cmp.w	#SELECTED,d0
		bne	DoPubState1
		lea.l	PubName,a0
		lib	Intuition,SetDefaultPubScreen
		bra	Window1IDCMP
DoPubState1:	sub.l	a0,a0
		lib	Intuition,SetDefaultPubScreen
		bra	Window1IDCMP

Refresher:	move.l	Window1,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window1,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window1IDCMP

VanillaKeys:	cmp.w	#$1b,d3
		beq	Quit
		bra	Window1IDCMP
RawKeys:	cmp.w	#$5f,d3
		beq	Help
		bra	Window1IDCMP

Win1Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win1Menus1
		cmp.w	#$01,d6
		beq	Win1Menus2
		bra	Window1IDCMP
Win1Menus1:	cmp.w	#$00,d5
		beq	DoBackDrop
		cmp.w	#$01,d5
		beq	ExecuteCommand
		cmp.w	#$02,d5
		beq	About
		cmp.w	#$04,d5
		beq	Quit
		bra	Window1IDCMP
Win1Menus2:	bra	Window1IDCMP

ExecuteCommand:	bsr	MenusOff
		bsr	SleepPointer

		bsr	OpenWin2
		tst.l	d0
		beq	NoWindow

Window2IDCMP:	move.l	Window2,a0
		bsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2
		beq	ExecuteQuit
		cmp.l	#VANILLAKEY,d2
		beq	ExecuteVKeys
		cmp.l	#MENUPICK,d2
		beq	Win2Menus
		cmp.l	#GADGETUP,d2
		beq	ExecuteGads
		bra	Window2IDCMP

ExecuteGads:	cmp.w	#10,$26(a5)
		beq	DoExecute
		cmp.w	#98,$26(a5)
		beq	DoExecute
		cmp.w	#99,$26(a5)
		beq	ExecuteQuit
		bra	Window2IDCMP

Win2Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win2Menus1
		bra	Window2IDCMP
Win2Menus1:	cmp.w	#$00,d5
		beq	DoExecute
		cmp.w	#$02,d5
		beq	ExecuteQuit
		bra	Window2IDCMP

ExecuteVKeys:	cmp.w	#$1b,d3
		beq	ExecuteQuit
		bra	Window2IDCMP

DoExecute:	lea.l	CONName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,CONFile
		beq	NoCON

		move.l	CommandGadBuf,d1
		clr.l	d2
		move.l	CONFile,d3
		lib	Dos,Execute

		tst.l	CONFile
		beq	ShutDown2000
		move.l	CONFile,d1
		lib	Dos,Close
		clr.l	CONFile
		bra	ExecuteQuit

ExecuteQuit:	bsr	CloseWin2

		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

About:		bsr	SleepPointer
		bsr	MenusOff

		move.l	Window1,a0
		lea.l	AboutTxt1,a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt,a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#320,d2
		move.l	#$50,d3
		lib	Intuition,AutoRequest
		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

DoBackDrop:	move.l	mlist,a0
		move.l	#$F800,d0
		lib	Intuition,ItemAddress
		move.l	d0,a0
		move.w	mu_Flags(a0),d0
		and.w	#CHECKED,d0
		cmp.w	#CHECKED,d0
		beq	DoBackDrop1
		bsr	CloseWin1
		lea.l	NewWindow1,a0
		and.l	#~BACKDROP!BORDERLESS,nw_Flags(a0)
		or.l	#WINDOWDEPTH!WINDOWCLOSE!WINDOWDRAG!WINDOWSIZING,nw_Flags(a0)
		lea.l	SBName1,a1
		move.l	a1,nw_Title(a0)
		bra	DoBD_OUT
DoBackDrop1:	bsr	CloseWin1
		lea.l	NewWindow1,a0
		or.l	#BACKDROP!BORDERLESS,nw_Flags(a0)
		and.l	#~WINDOWDEPTH!WINDOWCLOSE!WINDOWDRAG!WINDOWSIZING,nw_Flags(a0)
		clr.l	nw_Title(a0)
		move.l	Screen1,a1
		move.l	sc_Width(a1),nw_Width(a0)
		move.w	BHeight,d2
		move.w	d2,nw_TopEdge(a0)
		sub.w	d2,nw_Height(a0)
DoBD_OUT:	bsr	OpenWin1
		tst.l	d0
		beq	NoWindow
		bra	Window1IDCMP

Help:		bra	Window1IDCMP

Quit:		bsr	CloseWin1
Quit1:		bsr	CloseScreen1
		tst.l	d0
		beq	Quit2
;		move.l	OldPubModes,d0
;		lib	Intuition,SetPubScreenModes
		sub.l	a0,a0
		lib	Intuition,SetDefaultPubScreen
		bra	ShutDown

Quit2:		bsr	OpenWin1
		tst.l	d0
		beq	Quit1
		bsr	VisitorsOpen
		bra	Window1IDCMP

OpenWin1:	lea.l	NewWindow1,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window1
		beq	OpenWin1_ERR1
		move.l	d0,a0
		move.l	$32(a0),RP1
;		move.l	Window1,a0
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
		move.l	#-1,d0
		rts
OpenWin1_ERR1:	clr.l	d0
		rts

CloseWin1:	tst.l	Window1
		beq	CloseWin1_OUT
		move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1,a0
		bsr	ClearMSGs
CloseWin1_OUT:	clr.l	Window1
		rts

CloseScreen1:	move.l	#-1,d0	
		tst.l	Screen1
		beq	CloseScr1_OUT
		move.l	Screen1,a0
		lib	Intuition,CloseScreen
CloseScr1_OUT:	rts

OpenWin2:	lea.l	NewWindow2,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window2
		beq	OpenWin2_ERR1
		move.l	d0,a0
		move.l	$32(a0),RP1
;		move.l	Window2,a0
		move.l	mlist2,a1
		lib	Intuition,SetMenuStrip
		move.l	CommandGad1,a0
		move.l	Window2,a1
		sub.l	a2,a2
		flib	Intuition,ActivateGadget
		move.l	#-1,d0
		rts
OpenWin2_ERR1:	clr.l	d0
		rts

CloseWin2:	tst.l	Window2
		beq	CloseWin2_OUT
		move.l	Window2,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window2,a0
		bsr	ClearMSGs
CloseWin2_OUT:	clr.l	Window2
		rts

ShutDown:	move.l	OurTask,a0
		move.l	OldTaskWinPtr,$b8(a0)

ShutDown3500:	tst.l	NILFile
		beq	ShutDown3000
		move.l	NILFile,d1
		lib	Dos,Close

ShutDown3000:	tst.l	CONFile
		beq	ShutDown2000
		move.l	CONFile,d1
		lib	Dos,Close

ShutDown2000:	bsr	CloseWin2
		bsr	CloseWin1

ShutDown1900:	bsr	Clean2.0Magic
		bsr	CloseScreen1

ShutDown1000:	move.l	WBMsg,d2
		beq	ShutDown_OUT
		lib	Exec,Forbid
		move.l	d2,a1
		flib	Exec,ReplyMsg

ShutDown_OUT:
		closlib	GadTools
		closlib	Intuition
		closlib	Dos

		pull	d2-d7/a2-a6
		move.l	#RETURN_OK,d0
		rts

;Subroutines atleast should be here...

SleepPointer:	move.l	Window1,a0
		lea.l	ClockPointer1,a1
		move.l	#16,d0
		move.l	#16,d1			;WHAT-THE-HECK IS THIS FOR?
		move.l	#-6,d2
		move.l	#0,d3
		lib	Intuition,SetPointer
		rts

NormalPointer:	move.l	Window1,a0
		lib	Intuition,ClearPointer
		rts

MenusOn:	move.l	Window1,a0
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
		rts

MenusOff:	move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		rts

;CheckIDCMP gets messages from both our Input-Handler and Intuition.
; a0 = window structure

CheckIDCMP:	move.l	$56(a0),a2		;Get window's port
		move.l	#0,d1			;Set signals for
		move.b	$0f(a2),d1		;IntuiMessages
		move.l	#SIGBREAKF_CTRL_C,d0	;and for CTRL_C check
		bset.l	d1,d0
		lib	Exec,Wait	
	
		cmp.l	#SIGBREAKF_CTRL_C,d0
		beq	Break

GetMsg1:	move.l	a2,a0	
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	GetMsg2
	
		move.l	d0,a1 
		move.l	$14(a1),d2		;answers with Class in d2,
		move.w	$18(a1),d3		;Code in d3 and
		move.w	$1a(a1),a4		;Qualifier in a4
		move.l	$1c(a1),a5		;IAddress in a5
		lib	GadTools,GT_ReplyIMsg
		bra	GetMsg1
GetMsg2:	move.l	#-1,d0
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

ClearMSGs:	move.l	a0,d0
		tst.l	d0
		beq	ClearMsg3
		move.l	a0,a3
		lib	Exec,Forbid
		move.l	$56(a3),a2		;Give it the window structure in a0
ClearMsg1:	move.l	a2,a0	
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1 
		lib	GadTools,GT_ReplyIMsg
		bra	ClearMsg1
ClearMsg2:	move.l	a3,a0
		move.l	#$00,d0
		lib	Intuition,ModifyIDCMP
		lib	Exec,Permit
		move.l	a3,a0
		lib	Intuition,CloseWindow
ClearMsg3:	rts

Clean2.0Magic:	tst.l	glist
		beq	Clean2.0M2
		move.l	glist,a0
		lib	GadTools,FreeGadgets

Clean2.0M2:	tst.l	mlist
		beq	Clean2.0M3
		move.l	mlist,a0
		lib	GadTools,FreeMenus

Clean2.0M3:	tst.l	mlist2
		beq	Clean2.0M4
		move.l	mlist2,a0
		lib	GadTools,FreeMenus

Clean2.0M4:	tst.l	vi
		beq	Clean2.0_OUT
		move.l	vi,a0
		lib	GadTools,FreeVisualInfo

Clean2.0_OUT:	rts

NoDos:		add.l	#4,sp
		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

Usage:		lea.l	UsageText1,a0
		bsr	Printer
		bra	ShutDown

NoKS20:		lea.l	NoKS20Text1,a0
		bsr	Printer
		bra	ShutDown

NoInt:		lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

NoScreen:	lea.l	NoScreenText1,a0
		bsr	Printer
		bra	ShutDown

NoWindow:	lea.l	NoWindowText1,a0
		bsr	Printer
		bra	ShutDown

NoContextGad:	lea.l	NoContextText1,a0
		bsr	Printer
		bra	ShutDown

NoMenus:	lea.l	NoMenusText1,a0
		bsr	Printer
		bra	ShutDown

NoCON:		lea.l	NoCONText1,a0
		bsr	Printer
		bra	ShutDown

VisitorsOpen:	lea.l	VisitorsTxt1,a1
		bsr	DoAutoRequest
		rts

Break:		lea.l	BreakText1,a0
		bsr	Printer
		move.l	#CLOSEWINDOW,d2		;fake closewindow...
		move.l	#-1,d0
		rts

Printer:	printa	a0,_stdout
		rts

;Does a request
;
;a1 = IntuiText

DoAutoRequest:	sub.l	a2,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		clr.l	d0
		clr.l	d1
		clr.l	d2
		clr.l	d3
		sub.l	a0,a0
		lib	Intuition,AutoRequest
		rts


;Reservations

;Library stuff

		libnames

;GadTools stuff

vi:		dc.l	0		;Visual Info
mlist:		dc.l	0
mlist2:		dc.l	0
ContextGad:	dc.l	0
CommandGad1:	dc.l	0
CommandGadBuf:	dc.l	0

;WB Stuff

WBMsg:		dc.l	0

;Display stuff

Screen1:	dc.l	0
Window1:	dc.l	0
Window2:	dc.l	0
VP1:		dc.l	0
RP1:		dc.l	0
OldPubModes:	dc.l	0
BHeight:	dc.w	0

;Task stuff

OurTask:	dc.l	0
OldTaskWinPtr:	dc.l	0

;File stuff

NILFile:	dc.l	0
CONFile:	dc.l	0
_stdout:	dc.l	0


;Strings

BreakText1:	dc.b	"***Break",10,0
NoKS20Text1:	dc.b	"ERROR: Kickstart 2.0 or higher required!",10,0
NoIntText1:	dc.b	"ERROR: Couldn't open Intuition.library!",10,0
NoScreenText1:	dc.b	"ERROR: Couldn't open screen!",10,0
NoContextText1:	dc.b	"ERROR: Couldn't create context gadget!",10,0
NoMenusText1:	dc.b	"ERROR: Couldn't allocate menu structure!",10,0
NoWindowText1:	dc.b	"ERROR: Couldn't open window!",10,0
NoCONText1:	dc.b	"ERROR: Couldn't open CON: for output!",10,0
NodeNotFoundText1: dc.b	"ERROR: PubScreen node not found!",10,0
VisitorsText1:	dc.b	"ERROR: Visitor windows still open!",0

SBVersion:	dc.b	"$VER: "
UsageText1:	dc.b	"ShellBench 0.03 (7.12.92). (C)opyright Tomi Blinnikka 1992",10,10
		dc.b	10,"*** BETA TESTER VERSION ***",10,10,10
		dc.b	"USAGE: ShellBench []",10,10
		dc.b	"       Where: [] is (unused)",10
		dc.b	"       Default for [] is (unused)",10,10
		dc.b	"This program requires Kickstart 2.0 or higher!",10,10
		dc.b	"See docs for more information.",10,0
SBName1:	dc.b	"ShellBench, (C)opyright Tomi Blinnikka 1992.",0
AboutText1:	dc.b	"Name    : ShellBench",0
AboutText2:	dc.b	"Version : 0.03",0
AboutText3:	dc.b	"Author  : Tomi Blinnikka",0
AboutText4:	dc.b	"   (C)opyright  1992",0
OKText1:	dc.b	"OK",0
CancelText1:	dc.b	"Cancel",0
PubName:	dc.b	"ShellBench",0
Window2Title:	dc.b	"Execute a File",0
Window3Title:	dc.b	"Preferences",0

;File strings

NILName:	dc.b	"NIL:",0
CONName:	dc.b	"CON:0/25/640/150/Output Window/AUTO/WAIT",0
		ds.w	0

;Structures

NewScreen1:	dc.w	0,0			;X,Y POS
Screen1MaxCol:	dc.w	-1			;WIDTH
Screen1MaxRow:	dc.w	-1			;HEIGHT
		dc.w	1			;DEPTH
		dc.b	0,1			;COLORS
		dc.w	V_HIRES			;VIEWMODES
		dc.w	CUSTOMSCREEN		;TYPE
		dc.l	0			;FONT
		dc.l	SBName1			;DEFULT TITLE
		dc.l	0			;GADGETS
		dc.l	0			;CUSTOMBITMAP

Screen1TagList:	dc.l	SA_Pens,default_pens
		dc.l	SA_PubName,PubName
		dc.l	TAG_DONE,0
default_pens:	dc.w	~0

NewWindow1:	dc.w	0,11			;X,Y POS
		dc.w	0			;WIDTH
		dc.w	0			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!CLOSEWINDOW!MENUPICK!VANILLAKEY!GADGETUP
		dc.l	ACTIVATE!BACKDROP!BORDERLESS
		dc.l	PublicGad1,0		;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW1		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	100,20,0,0		;MIN/MAX SIZE
		dc.w	CUSTOMSCREEN		;TYPE

NewWindow2:	dc.w	20,20			;X,Y POS
		dc.w	460			;WIDTH
		dc.w	51			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW!MENUPICK!VANILLAKEY!GADGETUP
		dc.l	ACTIVATE!WINDOWCLOSE!WINDOWDRAG!WINDOWDEPTH
		dc.l	glist,0			;GADGETS, CHECKMARK
		dc.l	Window2Title		;TITLE
SToW2		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	460,49,460,0		;MIN/MAX SIZE
		dc.w	CUSTOMSCREEN		;TYPE

NewWindow3:	dc.w	20,20			;X,Y POS
		dc.w	620			;WIDTH
		dc.w	100			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW!MENUPICK!VANILLAKEY!GADGETUP
		dc.l	ACTIVATE!WINDOWCLOSE!WINDOWDRAG!WINDOWDEPTH
		dc.l	0,0 ;glist2,0			;GADGETS, CHECKMARK
		dc.l	Window3Title		;TITLE
SToW3		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	100,20,0,0		;MIN/MAX SIZE
		dc.w	CUSTOMSCREEN		;TYPE

;Fonts

Topaz		dc.l	TopazName
		dc.w	8
		dc.b	0
		dc.b	0
TopazName	dc.b	"topaz.font",0
		ds.w	0

;Gadgets

glist:		dc.l	0		;Next Gadget
		dc.w	0		;"hit-box" left edge
		dc.w	0		;"hit-box" top  edge
		dc.w	0		;"hit-box" Width
		dc.w	0		;"hit-box" Height
		dc.w	0		;flags
		dc.w	0		;activation
		dc.w	0		;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	0		;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	0		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

NGExecuteGad1:	dc.w	10		;gng_LeftEdge
		dc.w	-48		;gng_TopEdge
		dc.w	0		;gng_Width
		dc.w	9		;gng_Height
		dc.l	ExecuteText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_RIGHT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGCommandGad1:	dc.w	160		;gng_LeftEdge
		dc.w	-35		;gng_TopEdge
		dc.w	286		;gng_Width
		dc.w	12		;gng_Height
		dc.l	CommandText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	10		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOKGad:	dc.w	13		;gng_LeftEdge
		dc.w	-18		;gng_TopEdge
		dc.w	65		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OKGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	98		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGCancelGad:	dc.w	-78		;gng_LeftEdge
		dc.w	-18		;gng_TopEdge
		dc.w	65		;gng_Width
		dc.w	12		;gng_Height
		dc.l	CancelGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	99		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

PublicGad1:	dc.l	0		;Next Gadget
		dc.w	10		;"hit-box" left edge
PubGad1Top:	dc.w	0		;"hit-box" top  edge
		dc.w	56		;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGHCOMP!SELECTED
		dc.w	RELVERIFY!TOGGLESELECT	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	Border1		;gadget rendering
		dc.l	0		;select rendering
		dc.l	PubTxt1		;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	51		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

PubTxt1:	dc.b	1,2		;PENS
		dc.w	0		;DRAW MODE
		dc.w	3,2		;LEFT & TOP EDGE
		dc.l	Topaz		;FONT
		dc.l	PubText1	;TEXT
		dc.l	0		;NEXT TEXT

;Gadget TagList(s)

GadTagList:	dc.l	GT_Underscore,'_'
		dc.l	TAG_DONE,0

CommandGadTagList dc.l	GTST_MaxChars,126
		dc.l	TAG_DONE,0

;Menus

PubText1:	dc.b	"Public",0
Menu1Name:	dc.b	"Project",0
BDMenu1I1Text: dc.b	"Backdrop",0
BDCommKey:	dc.b	"B",0
ExecuteMenu1I1Text: dc.b "Execute Command...",0
ExecuteCommKey:	dc.b	"E",0
AboutMenu1I1Text: dc.b	"About...",0
AboutCommKey:	dc.b	"?",0
QuitMenu1I1Text: dc.b	"Quit",0
QuitCommKey:	dc.b	"Q",0

;Gadget texts (maybe a few menu strings to save space

ExecuteText1:	dc.b	"Enter Command and its Arguments:",0
CommandText1:	dc.b	"Command:",0
OKGadText1:	dc.b	"_"
OKMenu1I1Text:	dc.b	"OK",0
CancelGadText1:	dc.b	"_"
CancelMenu1I1Text: dc.b	"Cancel",0
CancelCommKey:	dc.b	"C",0
OKCommKey:	dc.b	"O",0

		ds.w	0

MNProjectMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNBDMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	BDMenu1I1Text		;gnm_Label
		dc.l	BDCommKey		;gnm_CommKey
		dc.w	CHECKED!CHECKIT!MENUTOGGLE	;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNExecuteMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	ExecuteMenu1I1Text	;gnm_Label
		dc.l	ExecuteCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAboutMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AboutMenu1I1Text	;gnm_Label
		dc.l	AboutCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNQuitNMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	QuitMenu1I1Text		;gnm_Label
		dc.l	QuitCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;ITEM_END?

MNProjectMenu2:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNOKNMenu2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	OKMenu1I1Text		;gnm_Label
		dc.l	OKCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSepMenu2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNCancelNMenu2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	CancelMenu1I1Text	;gnm_Label
		dc.l	CancelCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;ITEM_END?

;Menu TagList(s)

MenuTagList:	;dc.l	GTMN_TextAttr,Topaz
		dc.l	GTMN_Menu,MNProjectMenu1
		dc.l	TAG_DONE,0
MenuTagList2:	;dc.l	GTMN_TextAttr,Topaz
		dc.l	GTMN_Menu,MNProjectMenu2
		dc.l	TAG_DONE,0


;IntuiTexts

AboutTxt1:	dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT
		
AboutTxt2:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	10,20			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT

AboutTxt3:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,30			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT

AboutTxt4:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,50			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	0			;NEXTTEXT

OKTxt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OKText1			;TEXT
		dc.l	0			;NEXTTEXT

CancelTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	CancelText1		;TEXT
		dc.l	0			;NEXTTEXT

VisitorsTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	VisitorsText1		;TEXT
		dc.l	0			;NEXTTEXT

;Border structures

Border1:	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
		dc.b	1,0		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY1	;XY's
		dc.l	0		;Next Border

BorderXY1:	dc.w	0,0
		dc.w	55,0
		dc.w	55,10
		dc.w	0,10
		dc.w	0,0

		Section	SB,DATA,CHIP

		ds.w	0

ClockPointer1:	dc.w	$0000,$0000
		dc.w	$0400,$07C0,$0000,$07C0,$0100,$0380,$0000,$07E0
		dc.w	$07C0,$1FF8,$1FF0,$3FEC,$3FF8,$7FDE,$3FF8,$7FBE
		dc.w	$7FFC,$FF7F,$7EFC,$FFFF,$7FFC,$FFFF,$3FF8,$7FFE
		dc.w	$3FF8,$7FFE,$1FF0,$3FFC,$07C0,$1FF8,$0000,$07E0
		dc.w	$0000,$0000

		END
