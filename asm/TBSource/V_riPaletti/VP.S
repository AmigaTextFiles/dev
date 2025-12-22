*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 1.00	15/04/1993			*
*	       -18/04/1993			*
*						*
* BUGS:	Command Line Option '?' caused error.	*
*	Display problems under 2.04.		*
*						*
* Version 1.01	18/04/1993			*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"graphics/rastport.i"
	INCLUDE	"libraries/gadtools.i"

	INCLUDE	"XREF:2.0.xref"

	INCLUDE	"XREF:gfx.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


MainLeft:	EQU	17
MainTop:	EQU	10
SliderWidth:	EQU	200
SliderHeight:	EQU	24
SliderTxtWidth:	EQU	160

HelpTop:	EQU	MainTop+3*(SliderHeight+INTERHEIGHT)+INTERHEIGHT
HelpHeight:	EQU	80

TRUE:		EQU	1
FALSE:		EQU	0

Depth:		EQU	3
BGPen:		EQU	4

		section	VP,CODE

Start:		push	d2-d7/a2-a6
		push	a0

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

OpenDos:	openlib	Dos,NoDos

		tst.l	WBMsg
		beq	CLIStart

		pull	a0
		lea.l	CONName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,CONFile
		move.l	d0,_stdout
		beq	NoCON

		bra	MainStart

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout

		pull	a0
		cmp.b	#'?',(a0)
		beq	Usage

MainStart:	openlib	GadTools,NoGT
		openlib	Intuition,NoInt
		openlib	Gfx,NoGfx

;Close Workbench screen

		lib	Intuition,CloseWorkBench

;Open screen and main window

		lea.l	NewScreen1,a0
		lea.l	Screen1TagList,a1
		lib	Intuition,OpenScreenTagList
		move.l	d0,Screen1
		beq	NoScreen

;Get ViewPort

		move.l	Screen1,d0
		add.l	#$2c,d0
		move.l	d0,VP1

;Set sizes etc

		lea.l	NewWindow1,a0
		move.l	Screen1,a1
		move.l	a1,nw_Screen(a0)
		move.l	sc_Width(a1),nw_Width(a0)
		clr.l	d0
		move.b	sc_BarHeight(a1),d0
		add.b	#1,d0
		add.w	d0,nw_TopEdge(a0)
		sub.w	d0,nw_Height(a0)

;Do GadTools preparations, gadgets and menus

;Get visualinfo

		move.l	Screen1,a0
		lea.l	Screen1TagList,a1
		lib	GadTools,GetVisualInfoA
		move.l	d0,vi

;Make gadget stuff

		lea.l	glist,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad
		beq	NoContextGad

		move.l	glist,a0
		lea.l	NGSliderGad1,a1
		move.l	#SLIDER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SliderTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SliderGad1
		move.l	d0,a0

		lea.l	NGSliderGad2,a1
		move.l	#SLIDER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SliderTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SliderGad2
		move.l	d0,a0

		lea.l	NGSliderGad3,a1
		move.l	#SLIDER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SliderTagList3,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SliderGad3
		move.l	d0,a0

;Do the menu stuff

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
		move.l	pr_WindowPtr(a0),OldTaskWinPtr
		move.l	Window1,$b8(a0)

;Add menus to window 1

		move.l	Window1,a0
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip

;Fill window with BGPen

		move.l	RP1,a1
		move.l	#BGPen,d0
		lib	Gfx,SetRast

;Re-draw window frame

		move.l	Window1,a0
		lib	Intuition,RefreshWindowFrame

;Set APen to background color

		move.l	RP1,a1
		clr.l	d0
		lib	Gfx,SetAPen

;Clear area for gadgets

		move.l	RP1,a1
		move.l	#MainLeft-INTERWIDTH,d0
		move.l	#MainTop-INTERHEIGHT,d1
		move.l	#MainLeft-INTERWIDTH+SliderWidth+SliderTxtWidth+INTERWIDTH-1,d2
		move.l	#MainTop-INTERHEIGHT+3*(SliderHeight+INTERHEIGHT)+INTERHEIGHT-1,d3
		lib	Gfx,RectFill

;Draw a box around sliders

		move.l	RP1,a0
		move.l	#MainLeft-INTERWIDTH,d0
		move.l	#MainTop-INTERHEIGHT,d1
		move.l	#SliderWidth+SliderTxtWidth+INTERWIDTH,d2
		move.l	#3*(SliderHeight+INTERHEIGHT)+INTERHEIGHT,d3
		move.l	vi,BevelBoxTags+4
		lea.l	BevelBoxTags,a1
		lib	GadTools,DrawBevelBoxA

;Clear area for help text

		move.l	RP1,a1
		move.l	#MainLeft-INTERWIDTH,d0
		move.l	#HelpTop,d1
		move.l	#MainLeft-INTERWIDTH+SliderWidth+SliderTxtWidth+INTERWIDTH-1,d2
		move.l	#HelpTop+HelpHeight,d3
		lib	Gfx,RectFill

;Draw a box around help text

		move.l	RP1,a0
		move.l	#MainLeft-INTERWIDTH,d0
		move.l	#HelpTop,d1
		move.l	#INTERWIDTH+SliderWidth+SliderTxtWidth,d2
		move.l	#HelpHeight+INTERHEIGHT-2,d3
		move.l	vi,BevelBoxTags+4
		lea.l	BevelBoxTags,a1
		lib	GadTools,DrawBevelBoxA

;Set APen to color 1

		move.l	RP1,a1
		move.l	#1,d0
		lib	Gfx,SetAPen
;Print help text

		move.l	RP1,a0
		lea.l	HelpTxt1,a1
		move.l	#MainLeft+2,d0
		move.l	#HelpTop+8,d1
		lib	Intuition,PrintIText

;Add gadgets to Window 1

		move.l	Window1,a0
		move.l	glist,a1
		sub.l	a2,a2
		move.l	#-1,d0
		move.l	#-1,d1
		lib	Intuition,AddGList

		bsr	RefreshGads

;Start of main loop

Window1IDCMP:	move.l	Window1,a0
		bsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2		;gets fake closewindow only...
		beq	ShutDown
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		bra	Window1IDCMP

Win1Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win1Menus1
		bra	Window1IDCMP
Win1Menus1:	cmp.w	#$00,d5
		beq	About
		cmp.w	#$02,d5
		beq	ShutDown
		bra	Window1IDCMP

SliderHook1:	push	d2-d7/a2-a6
		clr.l	d4
		move.w	d0,d4
		move.l	d4,Red
		bra	SliderHook_OUT

SliderHook2:	push	d2-d7/a2-a6
		clr.l	d4
		move.w	d0,d4
		move.l	d4,Green
		bra	SliderHook_OUT

SliderHook3:	push	d2-d7/a2-a6
		clr.l	d4
		move.w	d0,d4
		move.l	d4,Blue
		bra	SliderHook_OUT

SliderHook_OUT:	move.l	VP1,a0
		move.l	#BGPen,d0
		move.l	Red,d1
		move.l	Green,d2
		move.l	Blue,d3
		lib	Gfx,SetRGB4

		move.l	d4,d0
		pull	d2-d7/a2-a6
		rts

About:		bsr	SleepPointer
		bsr	MenusOff

		move.l	Window1,a0
		lea.l	AboutTxt1,a1
		sub.l	a2,a2		;positive text
		lea.l	OKTxt,a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#320,d2
		move.l	#$50,d3
		lib	Intuition,AutoRequest
		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

ShutDown:	tst.l	OldTaskWinPtr
		beq	ShutDown3000
		move.l	OurTask,a0
		move.l	OldTaskWinPtr,pr_WindowPtr(a0)

ShutDown3000:	tst.l	CONFile
		beq	ShutDown2000
		move.l	CONFile,d1
		lib	Dos,Close

ShutDown2000:	tst.l	_IntuitionBase
		beq	ShutDown1950
		lib	Intuition,OpenWorkBench

ShutDown1950:	tst.l	Window1
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
		closlib	Gfx
		closlib	Intuition
		closlib	Dos

		pull	d2-d7/a2-a6
		move.l	#RETURN_OK,d0
		rts

;Subroutines should be here...

RefreshGads:	move.l	glist,a0
		move.l	Window1,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	Window1,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		rts

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

;CheckIDCMP gets messages from both the CTRL_C bit and Intuition.
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

;ClearMsgs subroutine
;a3 = window structure

ClearMSGs:	lib	Exec,Forbid
		move.l	Window1,a3
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

NoDos:		pull	a0
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

Break:		lea.l	BreakText1,a0
		bsr	Printer
		move.l	#CLOSEWINDOW,d2		;fake closewindow...
		move.l	#-1,d0
		rts

Printer:	printa	a0,_stdout
		rts

;Reservations

;Library stuff

		libnames

;GadTools stuff

vi:		dc.l	0		;Visual Info
mlist:		dc.l	0
ContextGad:	dc.l	0

SliderGad1:	dc.l	0
SliderGad2:	dc.l	0
SliderGad3:	dc.l	0

;WB Stuff

WBMsg:		dc.l	0

;Display stuff

Screen1:	dc.l	0
VP1:		dc.l	0
Window1:	dc.l	0
RP1:		dc.l	0
Red:		dc.l	0
Green:		dc.l	0
Blue:		dc.l	0

;Task stuff

OurTask:	dc.l	0
OldTaskWinPtr:	dc.l	0

;File stuff

CONFile:	dc.l	0
_stdout:	dc.l	0

;Strings

BreakText1:	dc.b	"***Keskeytys: V‰riPaletti",13,10,0
NoGTText1:	dc.b	"VIRHE: Ei kyetty avaamaan: gadtools.librarya!",13,10,0
NoIntText1:	dc.b	"VIRHE: Ei kyetty avaamaan: intuition.library!",13,10,0
NoGfxText1:	dc.b	"VIRHE: Ei kyetty avaamaan: graphics.library!",13,10,0
NoScreenText1:	dc.b	"VIRHE: Ei kyetty avaamaan ruutua!",13,10,0
NoContextText1:	dc.b	"VIRHE: Ei kyetty luomaan: context gadget!",13,10,0
NoMenusText1:	dc.b	"VIRHE: Ei kyetty varaamaan valikkostruktuuria!",13,10,0
NoWindowText1:	dc.b	"VIRHE: Ei kyetty avaamaan ikkunaa!",13,10,0
NoCONText1:	dc.b	"VIRHE: Ei kyetty avaamaan: 'CON:'!",13,10,0
NoMemText1:	dc.b	"VIRHE: Ei riitt‰v‰sti muistia!",0

RMVersion:	dc.b	"$VER: "
UsageText1:	dc.b	"V‰ripaletti 1.01 (18.04.93) (C)opyright Tomi Blinnikka 1993",13,10,13,10
;		dc.b	10,"*** BETA-TESTAAJA VERSIO ***",13,10,13,10,13,10
		dc.b	"KƒYTT÷: V‰riPaletti",13,10,13,10,13,10
		dc.b	"T‰m‰ ohjelma vaati KickStart 2.04 tai uudemman.",13,10,13,10,0
TTName1:	dc.b	"V‰ripaletti, (C)opyright Tomi Blinnikka 1993.",0
AboutText1:	dc.b	"Nimi   : V‰ripaletti",0
AboutText2:	dc.b	"Versio : 1.01",0
AboutText3:	dc.b	"Tekij‰ : Tomi Blinnikka",0
AboutText4:	dc.b	"   (C)opyright  1993",0
OKText1:	dc.b	"OK",0
CancelText1:	dc.b	"Peru",0
FString1:	dc.b	"Punainen: %ld / 15 ",0
FString2:	dc.b	"Vihre‰  : %ld / 15 ",0
FString3:	dc.b	"Sininen : %ld / 15 ",0
HelpText1:	dc.b	"1. Valitse s‰‰dett‰v‰ v‰rikomponentti.",0
HelpText2:	dc.b	"2. Siirr‰ nuolta hiiren avulla liukus‰‰ti-",0
HelpText3:	dc.b	"   mess‰ olevan mustan laatikon p‰‰lle.",0
HelpText4:	dc.b	"3. Paina vasenta hiiren nappia ja pid‰",0
HelpText5:	dc.b	"   sit‰ pohjassa.",0
HelpText6:	dc.b	"4. Siirr‰ hiirt‰ vasemmalle tai oikealle.",0

;File strings

CONName:	dc.b	"CON:0/25/640/150/Output Window/AUTO/WAIT",0

		ds.w	0

;Structures

NewScreen1:	dc.w	0,0			;X,Y POS
		dc.w	-1			;WIDTH
		dc.w	-1			;HEIGHT
		dc.w	Depth			;DEPTH
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

BevelBoxTags:	dc.l	GT_VisualInfo
		dc.l	0
		dc.l	TAG_DONE,0

NewWindow1:	dc.w	0,0			;X,Y POS
		dc.w	0			;WIDTH
		dc.w	0			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	SLIDERIDCMP!MENUPICK
		dc.l	NOCAREREFRESH!ACTIVATE!BACKDROP
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
		dc.l	0			;SCREEN ADDRESS
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

NGSliderGad1:	dc.w	MainLeft	;gng_LeftEdge
		dc.w	MainTop+0*(SliderHeight+INTERHEIGHT)	;gng_TopEdge
		dc.w	SliderWidth	;gng_Width
		dc.w	SliderHeight	;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	20		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSliderGad2:	dc.w	MainLeft	;gng_LeftEdge
		dc.w	MainTop+1*(SliderHeight+INTERHEIGHT)	;gng_TopEdge
		dc.w	SliderWidth	;gng_Width
		dc.w	SliderHeight	;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	20		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSliderGad3:	dc.w	MainLeft	;gng_LeftEdge
		dc.w	MainTop+2*(SliderHeight+INTERHEIGHT)	;gng_TopEdge
		dc.w	SliderWidth	;gng_Width
		dc.w	SliderHeight	;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	20		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Gadget TagLists

GadTagList:	dc.l	GT_Underscore,'_'
		dc.l	TAG_DONE,0
SliderTagList1:	dc.l	GTSL_Min,0
		dc.l	GTSL_Max,15
		dc.l	GTSL_Level,0
		dc.l	GTSL_MaxLevelLen,20
		dc.l	GTSL_LevelFormat,FString1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	GTSL_DispFunc,SliderHook1
		dc.l	TAG_DONE,0
SliderTagList2:	dc.l	GTSL_Min,0
		dc.l	GTSL_Max,15
		dc.l	GTSL_Level,0
		dc.l	GTSL_MaxLevelLen,20
		dc.l	GTSL_LevelFormat,FString2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	GTSL_DispFunc,SliderHook2
		dc.l	TAG_DONE,0
SliderTagList3:	dc.l	GTSL_Min,0
		dc.l	GTSL_Max,15
		dc.l	GTSL_Level,0
		dc.l	GTSL_MaxLevelLen,20
		dc.l	GTSL_LevelFormat,FString3
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	GTSL_DispFunc,SliderHook3
		dc.l	TAG_DONE,0

;Menus

Menu1Name:	dc.b	"Projekti",0
AboutMenu1I1Text: dc.b	"Tietoa...",0
AboutCommKey:	dc.b	"T",0
QuitMenu1I1Text: dc.b	"Lopeta",0
QuitCommKey:	dc.b	"L",0

		ds.w	0

MNProjectMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
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

AboutTxt1:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT
		
AboutTxt2:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	10,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT

AboutTxt3:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	10,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT

AboutTxt4:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	10,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	0			;NEXTTEXT

HelpTxt1:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	0,0*11			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText1		;TEXT
		dc.l	HelpTxt2		;NEXTTEXT
		
HelpTxt2:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	0,1*11+4		;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText2		;TEXT
		dc.l	HelpTxt3		;NEXTTEXT

HelpTxt3:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	0,2*11+2		;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText3		;TEXT
		dc.l	HelpTxt4		;NEXTTEXT

HelpTxt4:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	0,3*11+4		;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText4		;TEXT
		dc.l	HelpTxt5		;NEXTTEXT

HelpTxt5:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	0,4*11+2		;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText5		;TEXT
		dc.l	HelpTxt6		;NEXTTEXT

HelpTxt6:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	0,5*11+4			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText6		;TEXT
		dc.l	0			;NEXTTEXT

OKTxt:		dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OKText1			;TEXT
		dc.l	0			;NEXTTEXT

CancelTxt:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	CancelText1		;TEXT
		dc.l	0			;NEXTTEXT

NoMemTxt1:	dc.b	1,0			;PENS
		dc.w	RP_JAM1			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	NoMemText1		;TEXT
		dc.l	0			;NEXTTEXT

		Section	VP,DATA,CHIP

		ds.w	0

ClockPointer1:	dc.w	$0000,$0000
		dc.w	$0400,$07C0,$0000,$07C0,$0100,$0380,$0000,$07E0
		dc.w	$07C0,$1FF8,$1FF0,$3FEC,$3FF8,$7FDE,$3FF8,$7FBE
		dc.w	$7FFC,$FF7F,$7EFC,$FFFF,$7FFC,$FFFF,$3FF8,$7FFE
		dc.w	$3FF8,$7FFE,$1FF0,$3FFC,$07C0,$1FF8,$0000,$07E0
		dc.w	$0000,$0000


		END
