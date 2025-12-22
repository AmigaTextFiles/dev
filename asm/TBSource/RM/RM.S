***********************************************
*                                             *
*              (C)opyright 1991               *
*                                             *
*             by  Tomi Blinnikka              *
*                                             *
*      Don´t try to understand the code       *
*                                             *
*	Raw-Master -The Amiga version-	      *
*                                             *
***********************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"libraries/iff.i"		;includes "XREFS"
;	INCLUDE	"graphics/gfx.i"
;	INCLUDE	"intuition/intuition.i"
;	INCLUDE	"intuition/gadgetclass.i"
	INCLUDE	"libraries/gadtools.i"

	INCLUDE	"XREF:2.0.xref"

	INCLUDE	"XREF:gfx.xref"
;	INCLUDE	"XREF:mathffp.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"
;	INCLUDE	"XREF:diskfont.xref"


MainMTop:	EQU	150

TRUE:		EQU	1
FALSE:		EQU	0

		section	RM,CODE

Start:		push	d2-d7/a2-a6
		push	a0

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a4

		move.l	pr_CLI(a4),d0
		bne	OpenDos

		add.l	#8,sp
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,WaitPort
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,GetMsg
		move.l	d0,WBMsg

OpenDos:	openlib	Dos,NoDos
		pull	a0

		cmp.b	#'?',(a0)
		beq	Usage

		tst.l	WBMsg
		beq	CLIStart

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

MainStart:	lea.l	CONName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,CONFile
		beq	NoCON

		openlib	GadTools,NoGT
		openlib	Intuition,NoInt
		openlib	Gfx,NoGfx
		oldlib	Iff,NoIff

;Open screen and main window

		lea.l	NewScreen1,a0
		lea.l	Screen1TagList,a1
		lib	Intuition,OpenScreenTagList
		move.l	d0,Screen1
		beq	NoScreen

		move.l	Screen1,d0
		move.l	d0,SToW2
		lea.l	NewWindow1,a0
		move.l	d0,nw_Screen(a0)
		move.l	d0,a1
		move.l	sc_Width(a1),nw_Width(a0)
;		sub.w	#11,nw_Height(a0)
		add.l	#$2c,d0
		move.l	d0,VP1

;Hide Title

		move.l	Screen1,a0
		move.l	#FALSE,d0
		lib	Intuition,ShowTitle

;Set colors

		move.l	VP1,a0
		lea.l	ShipColors1,a1
		move.l	#32,d0
		lib	Gfx,LoadRGB4

;load picture

		lea.l	FileName1,a0
		lib	Iff,OpenIFF
		move.l	d0,LogoFile
		beq	NoIFFPic

;get sprites and do sprite stuff

		lea	Sprite1,a0
		move.l	#-1,d0
		lib	Gfx,GetSprite
		move.l	d0,Sprite1Num
		cmp.l	#-1,d0
		beq	NoSprite

		lea	Sprite2,a0
		move.l	#-1,d0
		lib	Gfx,GetSprite
		move.l	d0,Sprite2Num
		cmp.l	#-1,d0
		beq	NoSprite

		move.l	VP1,a0
		lea.l	Sprite1,a1
		lea.l	ShipData1,a2
		lib	Gfx,ChangeSprite

		move.l	VP1,a0
		lea.l	Sprite1,a1
		move.l	#100,d0
		move.l	#50,d1
		lib	Gfx,MoveSprite

		move.l	VP1,a0
		lea.l	Sprite2,a1
		lea.l	ShipData2,a2
		lib	Gfx,ChangeSprite

		move.l	VP1,a0
		lea.l	Sprite2,a1
		move.l	#200,d0
		move.l	#50,d1
		lib	Gfx,MoveSprite

;Do GadTools preparations, gadgets and menus

		lea.l	glist,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad
		beq	NoContextGad

		move.l	Screen1,a0
		lea.l	Screen1TagList,a1
		lib	GadTools,GetVisualInfoA
		move.l	d0,vi

;		move.l	glist,a0
;		lea.l	NGGad,a1
;		move.l	#_KIND,d0
;		move.l	vi,gng_VisualInfo(a1)
;		lea.l	NumGadTagList,a2
;		lib	GadTools,CreateGadgetA

;		move.l	d0,a0
;		move.l	a0,Gad1

		lea.l	MNProjectMenu1,a0
		lea.l	MenuTagList,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist
		beq	NoMenus

		move.l	mlist,a0
		move.l	vi,a1
		lea.l	MenuTagList,a2
		lib	GadTools,LayoutMenusA

		lea.l	NewWindow1,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window1
		beq	NoWindow
		move.l	d0,a0
		move.l	$32(a0),RP1

;move requesters to Window1

		move.l	OurTask,a0
		move.l	$b8(a0),OldTaskWinPtr
		move.l	Window1,$b8(a0)

;Draw main logo

		move.l	RP1,a0
		move.l	$4(a0),a0
		move.l	LogoFile,a1
		lib	Iff,DecodePic
		tst.l	d0
		beq	NoPic


		move.l	RP1,a0
		lea.l	MainMBorder1,a1
		move.l	#50,d0			;*1
		move.l	#MainMTop,d1		;*2
		lib	Intuition,DrawBorder

;Add menus to window 1

		move.l	Window1,a0
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip

		bsr	AddMGads

;Start of main loop

Window1IDCMP:	move.l	Window1,a0
		bsr	CheckIDCMP
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#RAWKEY,d2
		beq	RawKeys
		cmp.l	#GADGETUP,d2
		beq	GadgetPick
		cmp.l	#ACTIVEWINDOW,d2
;		beq	ActivateGads
		bra	Window1IDCMP

Refresher:	move.l	Window1,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window1,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window1IDCMP

VanillaKeys:	cmp.w	#$1b,d3
		beq	ShutDown
		cmp.w	#'1',d3
;		beq	Start
		cmp.w	#'2',d3
		beq	About
		cmp.w	#'3',d3
		beq	ShutDown
		bra	Window1IDCMP
RawKeys:	cmp.w	#$5f,d3
		beq	Help
		bra	Window1IDCMP

GadgetPick:	cmp.w	#70,$26(a5)
;		beq	StartGame
		cmp.w	#71,$26(a5)
		beq	About
		cmp.w	#72,$26(a5)
		beq	ShutDown
		bra	Window1IDCMP

Win1Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win1Menus1
		cmp.w	#$01,d6
		beq	Win1Menus2
		bra	Window1IDCMP
Win1Menus1:	cmp.w	#$00,d5
;		beq	StartGame
		cmp.w	#$01,d5
		beq	About
		cmp.w	#$03,d5
		beq	ShutDown
		bra	Window1IDCMP
Win1Menus2:	bra	Window1IDCMP

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

Help:		bra	Window1IDCMP

ShutDown:	move.l	OurTask,a0
		move.l	OldTaskWinPtr,$b8(a0)

ShutDown4100:	move.l	Sprite1Num,d0
		beq	ShutDown4000
		lib	Gfx,FreeSprite

ShutDown4000:	move.l	Sprite2Num,d0
		beq	ShutDown3500
		lib	Gfx,FreeSprite

ShutDown3500:	tst.l	NILFile
		beq	ShutDown3400
		move.l	NILFile,d1
		lib	Dos,Close

ShutDown3400:	tst.l	LogoFile
		beq	ShutDown3000
		move.l	LogoFile,a1
		lib	Iff,CloseIFF

ShutDown3000:	tst.l	CONFile
		beq	ShutDown2000
		move.l	CONFile,d1
		lib	Dos,Close

ShutDown2100:	tst.l	Window2
		beq	ShutDown2000
		move.l	Window2,a0
		lib	Intuition,CloseWindow

ShutDown2000:	tst.l	Window1
		beq	ShutDown1900
		move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1,a0
		bsr	ClearMSGs

ShutDown1900:	bsr	Clean2.0Magic

		tst.l	Screen1
		beq	ShutDown1000
		move.l	Screen1,a0
		lib	Intuition,CloseScreen

ShutDown1100:
ShutDown1000:	move.l	WBMsg,d2
		beq	ShutDown_OUT
		lib	Exec,Forbid
		move.l	d2,a1
		flib	Exec,ReplyMsg

ShutDown_OUT:	closlib	GadTools
		closlib	Iff
		closlib	Gfx
		closlib	Intuition
		closlib	Dos

		pull	d2-d7/a2-a6
		move.l	#RETURN_OK,d0
		rts

;Subroutines atleast should be here...

AddMGads:	move.l	Window1,a0
		lea.l	MainMGad1,a1
		move.l	#00,a2
		move.l	#-1,d0
		move.l	#4,d1
		lib	Intuition,AddGList

;Refresh gadgets so they're drawn on the screen

		lea.l	MainMGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		move.l	#4,d0
		lib	Intuition,RefreshGList
		rts

RemMGads:	move.l	Window1,a0		;Remove Main menu's gadgets
		lea.l	MainMGad1,a1
		move.l	#4,d0
		lib	Intuition,RemoveGList
		rts

OpenWaitWin1:	lea.l	WaitWindow1,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window2
		beq	OpenWaitWin_ERR1
		move.l	d0,a0
		move.l	$32(a0),a0
		lea.l	PleaseWaitTxt1,a1
		clr.l	d0
		clr.l	d1
		lib	Intuition,PrintIText
		move.l	#-1,d0
		rts
OpenWaitWin_ERR1: clr.l	d0
		rts

CloseWaitWin1:	tst.l	Window2
		beq	CloseWaitWin2
		move.l	Window2,a0
		lib	Intuition,CloseWindow
		clr.l	Window2
CloseWaitWin2:	rts

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

Clean2.0M3:	tst.l	vi
		beq	Clean2.0_OUT
		move.l	vi,a0
		lib	GadTools,FreeVisualInfo

Clean2.0_OUT:	rts

NoDos:		add.l	#8,sp
		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

Usage:		lea.l	UsageText1,a0
		bsr	Printer
		bra	ShutDown

NoGT:		lea.l	NoGTText1,a0
		bsr	Printer
		bra	ShutDown

NoInt:		lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

NoGfx:		lea.l	NoGfxText1,a0
		bsr	Printer
		bra	ShutDown

NoIff:		lea.l	NoIffText1,a0
		bsr	Printer
		bra	ShutDown

NoScreen:	lea.l	NoScreenText1,a0
		bsr	Printer
		bra	ShutDown

NoWindow:	lea.l	NoWindowText1,a0
		bsr	Printer
		bra	ShutDown

NoSprite:	lea.l	NoSpriteText1,a0
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

NoIFFPic:	lea.l	NoIFFPicText1,a0
		bsr	Printer
		bra	ShutDown

NoPic:		lea.l	NoPicText1,a0
		bsr	Printer
		bra	ShutDown

Break:		lea.l	BreakText1,a0
		bsr	Printer
		move.l	#CLOSEWINDOW,d2		;fake closewindow...
		move.l	#-1,d0
		rts

Printer:	printa	a0
		rts

;Does an AutoRequest
;
;a1 = intuitext structure
;

DoAutoRequest:	move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$00,d2
		move.l	#$00,d3
		sub.l	a0,a0
		lib	Intuition,AutoRequest
		rts


;Reservations

;Library stuff

		libnames

;GadTools stuff

vi:		dc.l	0		;Visual Info
mlist:		dc.l	0
ContextGad:	dc.l	0
Gad1:		dc.l	0

;WB Stuff

WBMsg:		dc.l	0

;Display stuff

Screen1:	dc.l	0
VP1:		dc.l	0
Window1:	dc.l	0
Window2:	dc.l	0
RP1:		dc.l	0

;Sprite stuff (change the number things to point to sprite structures)

Sprite1Num:	dc.l	0
Sprite2Num:	dc.l	0

;Task stuff

OurTask:	dc.l	0
OldTaskWinPtr:	dc.l	0

;File stuff

CONFile:	dc.l	0
NILFile:	dc.l	0
_stdout:	dc.l	0
LogoFile:	dc.l	0

;Strings

BreakText1:	dc.b	"**Break",13,10,0
NoGTText1:	dc.b	"ERROR: Couldn't open gadtools.library",13,10,0
NoIntText1:	dc.b	"ERROR: Couldn't open intuition.library!",13,10,0
NoGfxText1:	dc.b	"ERROR: Couldn't open graphics.library!",13,10,0
NoIffText1:	dc.b	"ERROR: Couldn't open iff.library!",13,10,0
NoScreenText1:	dc.b	"ERROR: Couldn't open screen!",13,10,0
NoContextText1:	dc.b	"ERROR: Couldn't create context gadget!",13,10,0
NoMenusText1:	dc.b	"ERROR: Couldn't allocate menu-structure!",13,10,0
NoSpriteText1:	dc.b	"ERROR: Couldn't get sprite!",13,10,0
NoWindowText1:	dc.b	"ERROR: Couldn't open window!",13,10,0
NoCONText1:	dc.b	"ERROR: Couldn't open 'CON:'!",13,10,0
NoIFFPicText1:	dc.b	"ERROR: Couldn't open IFF file!",13,10,0
NoPicText1:	dc.b	"ERROR: Couldn't draw IFF file!",13,10,0
NoMemText1:	dc.b	"ERROR: Not enough memory!",0

RMVersion:	dc.b	"$VER: "
UsageText1:	dc.b	"RM v0.01. (C)opyright Tomi Blinnikka 1992-93",13,10,13,10
		dc.b	10,"*** BETA TESTER VERSION ***",13,10,13,10,13,10
		dc.b	"USAGE: RM []",13,10,13,10
		dc.b	"       Where: [] is (unused)",13,10
		dc.b	"       Default for [] is",13,10,13,10
		dc.b	"This program requires Kickstart 2.0 or higher.",13,10,13,10
		dc.b	"See docs for more information.",13,10,0
TTName1:	dc.b	"Raw-Master, (C)opyright Tomi Blinnikka 1992.",0
AboutText1:	dc.b	"Name    : Raw-Master",0
AboutText2:	dc.b	"Version : 0.01",0
AboutText3:	dc.b	"Author  : Tomi Blinnikka",0
AboutText4:	dc.b	"   (C)opyright  1992",0
OKText1:	dc.b	"OK",0
CancelText1:	dc.b	"Cancel",0
PleaseWaitText1: dc.b	"Please wait...",0
FString:	dc.b	"%ld",0

;File strings

NILName:	dc.b	"NIL:",0
CONName:	dc.b	"CON:0/25/640/150/Output Window/AUTO/WAIT",0
FileName1:	dc.b	"RM:GFX/RawMaster.MAIN",0
FileName2:	dc.b	"RM:GFX/RawMaster.BACK1",0
FileName3:	dc.b	"RM:GFX/RawMaster.BACK2",0
FileName4:	dc.b	"RM:GFX/RawMaster.BACK4",0

		ds.w	0

;Structures

NewScreen1:	dc.w	0,0			;X,Y POS
Screen1MaxCol:	dc.w	640			;WIDTH
Screen1MaxRow:	dc.w	200			;HEIGHT
		dc.w	3			;DEPTH
		dc.b	0,1			;COLORS
		dc.w	V_HIRES			;VIEWMODES
		dc.w	CUSTOMSCREEN		;TYPE
		dc.l	Topaz			;FONT
		dc.l	TTName1			;DEFULT TITLE
		dc.l	0			;GADGETS
		dc.l	0			;CUSTOMBITMAP

Screen1TagList:	dc.l	SA_Pens,default_pens
		dc.l	TAG_DONE,0
default_pens:	dc.w	~0

NewWindow1:	dc.w	0,0			;X,Y POS
		dc.w	0			;WIDTH
		dc.w	0			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!GADGETDOWN!GADGETUP!VANILLAKEY!RAWKEY!MENUPICK!ACTIVEWINDOW
		dc.l	ACTIVATE!BACKDROP!BORDERLESS
		dc.l	glist,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW1		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	CUSTOMSCREEN		;TYPE

WaitWindow1:	dc.w	240,100			;X,Y POS
		dc.w	150			;WIDTH
		dc.w	20			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	0
		dc.l	ACTIVATE
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW2		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
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

;New GadTools gadgets

NGGad:		dc.w	0		;gng_LeftEdge
		dc.w	0		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	10		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	10		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Gadget TagList(s)


;Old gadgets

MainMGad1	dc.l	MainMGad2	;Next Gadget
		dc.w	54		;"hit-box" left edge
		dc.w	MainMTop+10	;"hit-box" top  edge
		dc.w	533		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MMGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	70		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MMGadTxt1	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	3,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	MainMText1		;TEXT
		dc.l	0			;NEXTTEXT

MainMGad2	dc.l	MainMGad3	;Next Gadget
		dc.w	54		;"hit-box" left edge
		dc.w	MainMTop+20	;"hit-box" top  edge
		dc.w	533		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MMGadTxt2	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	71		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MMGadTxt2	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	3,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	MainMText2		;TEXT
		dc.l	0			;NEXTTEXT

MainMGad3	dc.l	0 ;MainMGad4	;Next Gadget
		dc.w	54		;"hit-box" left edge
		dc.w	MainMTop+30	;"hit-box" top  edge
		dc.w	533		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MMGadTxt3	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	72		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MMGadTxt3	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	3,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	MainMText3		;TEXT
		dc.l	0			;NEXTTEXT

;Menus

Menu1Name:	dc.b	"Project",0
StartMenu1I1Text: dc.b	"Start game",0
StartCommKey:	dc.b	"S",0
AboutMenu1I1Text: dc.b	"About...",0
AboutCommKey:	dc.b	"?",0
QuitMenu1I1Text: dc.b	"Quit",0
QuitCommKey:	dc.b	"Q",0

MainMText1:	dc.b	"1. Start game",0
MainMText2:	dc.b	"2. About",0
MainMText3:	dc.b	"3. Quit",0
		ds.w	0

MNProjectMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNStartMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	StartMenu1I1Text	;gnm_Label
		dc.l	StartCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
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

;Menu TagList(s)

MenuTagList:	;dc.l	GTMN_TextAttr,Topaz
		dc.l	GTMN_Menu,MNProjectMenu1
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

NoMemTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	NoMemText1		;TEXT
		dc.l	0			;NEXTTEXT

PleaseWaitTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	20,7			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PleaseWaitText1		;TEXT
		dc.l	0			;NEXTTEXT

;Borders

MainMBorder1	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
		dc.b	2,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY1	;XY's
		dc.l	MainMBorder2	;Next Border
MainMBorder2	dc.w	3		;Initial offsets from the origin
		dc.w	2		;LeftEdge and TopEdge
		dc.b	2,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY2	;XY's
		dc.l	MainMBorder3	;Next Border
MainMBorder3	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY3	;XY's
		dc.l	MainMBorder4	;Next Border
MainMBorder4	dc.w	3		;Initial offsets from the origin
		dc.w	2		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY4	;XY's
		dc.l	0		;Next Border

BorderXY1:	dc.w	0,41
		dc.w	0,0
		dc.w	540,0
BorderXY2:	dc.w	0,37
		dc.w	0,0
		dc.w	534,0
BorderXY3:	dc.w	540,1
		dc.w	540,41
		dc.w	0,41
BorderXY4:	dc.w	534,1
		dc.w	534,37
		dc.w	0,37

;Sprites

Sprite1:	dc.l	0		;posctldata
		dc.w	16		;height
		dc.w	0		;X
		dc.w	0		;Y
		dc.w	0		;num

Sprite2:	dc.l	0		;posctldata
		dc.w	16		;height
		dc.w	0		;X
		dc.w	0		;Y
		dc.w	0		;num


		Section	RM,DATA,CHIP

		ds.w	0

ClockPointer1:	dc.w	$0000,$0000
		dc.w	$0400,$07C0,$0000,$07C0,$0100,$0380,$0000,$07E0
		dc.w	$07C0,$1FF8,$1FF0,$3FEC,$3FF8,$7FDE,$3FF8,$7FBE
		dc.w	$7FFC,$FF7F,$7EFC,$FFFF,$7FFC,$FFFF,$3FF8,$7FFE
		dc.w	$3FF8,$7FFE,$1FF0,$3FFC,$07C0,$1FF8,$0000,$07E0
		dc.w	$0000,$0000

ShipData1:	DC.W	$0000,$0000
		DC.W	$0000,$0000
		DC.W	$1E00,$0000
		DC.W	$3F80,$0400
		DC.W	$7FC0,$0000
		DC.W	$73F0,$0CC0
		DC.W	$E1BC,$1E40
		DC.W	$E09F,$9F60
		DC.W	$608C,$9F78
		DC.W	$E08C,$1F78
		DC.W	$608C,$9F78
		DC.W	$E09F,$9F60
		DC.W	$E1BC,$1E40
		DC.W	$73F0,$0CC0
		DC.W	$7FC0,$0000
		DC.W	$3F80,$0400
		DC.W	$1E00,$0000
		DC.W	$0000,$0000

ShipData2:	DC.W	$0000,$0000
		DC.W	$0078,$0000
		DC.W	$01FC,$0020
		DC.W	$03FE,$0000
		DC.W	$0FCE,$0330
		DC.W	$3D87,$0278
		DC.W	$F907,$06F9
		DC.W	$3106,$1EF9
		DC.W	$3107,$1EF8
		DC.W	$3106,$1EF9
		DC.W	$F907,$06F9
		DC.W	$3D87,$0278
		DC.W	$0FCE,$0330
		DC.W	$03FE,$0000
		DC.W	$01FC,$0020
		DC.W	$0078,$0000
		DC.W	$0000,$0000
		DC.W	$0000,$0000

;Colors

ShipColors1:	dc.w	$000,$666,$999,$333	;colors 0-3
		dc.w	$23a,$fd0,$f11,$2b2	;colors 4-7
		dc.w	$000,$000,$000,$000	;colors 8-11
		dc.w	$000,$000,$000,$000	;colors 12-15
		dc.w	$000,$000,$fe0,$f00	;Ship colors (16-19)
		dc.w	$000,$000,$fe0,$f00	;ship colors (20-23)
		dc.w	$000,$000,$fe0,$f00	;ship colors (24-27)
		dc.w	$000,$000,$fe0,$f00	;ship colors (28-31)

		END
