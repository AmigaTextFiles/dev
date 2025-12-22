*************************************************
*						*
*		 (C)opyright 1991		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version: See info from main source code	*
*						*
*************************************************


	INCLUDE "JMPLibs.i"
	INCLUDE "exec/types.i"
	INCLUDE "libraries/reqbase.i"
	INCLUDE "libraries/gadtools.i"

	INCLUDE "XREF:2.0.xref"
	INCLUDE "XREF:dos.xref"
	INCLUDE "XREF:exec.xref"
	INCLUDE "XREF:gfx.xref"
	INCLUDE "XREF:intuition.xref"

	XDEF	Help
	XDEF	HWin1
	XDEF	SToW7
	XDEF	glist3
	XDEF	mlist3
	XDEF	GadMagic3
	XDEF	MenuMagic3

	XREF	Screen1
	XREF	_DosBase
	XREF	MenuNull
	XREF	_IntuitionBase
	XREF	_GfxBase
	XREF	_GadToolsBase
	XREF	MenusOff
	XREF	MenusOn
	XREF	SleepPointer
	XREF	NormalPointer
	XREF	Topaz
	XREF	NoHelpWin1
	XREF	CheckIDCMP
	XREF	ClearMSGs
	XREF	Window1IDCMP
	XREF	vi
	XREF	Window1
	XREF	Speaker
	XREF	SetActivation
	XREF	OthActivation
	XREF	OthActivation1
	XREF	SS_Help
	XREF	SS_HelpHelp
	XREF	SS_Next2
	XREF	SS_Prev2
	XREF	SS_Quit
	XREF	SS_Page1
	XREF	SS_Page2
	XREF	SS_Page3
	XREF	SS_Page4
	XREF	SS_Page5
	XREF	SS_Page6
	XREF	SS_Page7
	XREF	SS_Page8
	XREF	SS_Page9
	XREF	SS_Page10
	XREF	SS_Page11
	XREF	SS_Page12
	XREF	SS_Page13
	XREF	SS_Page14
	XREF	SS_Page15
	XREF	SS_Page16
	XREF	SS_Page17
	XREF	SS_Page18
	XREF	SS_Page19
	XREF	SS_Page20
	XREF	MainMGad1
	XREF	MainMenu
	XREF	Mode
	XREF	NumQ

Help:		jsr	SleepPointer

		cmp.w	#$00,Mode
		bne	HelpCont0.01
		move.l	Window1,a0
		lea.l	MainMGad1,a1
		move.l	#-1,d0
		lib	Intuition,RemoveGList
		jmp	HelpCont0.1

HelpCont0.01:	cmp.w	#$02,Mode
		bne	HelpCont0.1
		move.w	NumQ,d6
		clr.w	NumQ

		jsr	SetActivation
		jsr	OthActivation
		move.w	d6,NumQ

HelpCont0.1:	jsr	MenusOff
		lea.l	SS_Help,a0
		jsr	Speaker

		tst.b	GadMagic3
		bne	HelpCont0.2

		lea.l	glist3,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad3
		beq	HelpCont0.2

		move.b	#1,GadMagic3

		move.l	glist3,a0
		lea.l	NGPrevGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadgetTagList1,a2
		lib	GadTools,CreateGadgetA
		move.l	d0,a0

		add.w	#GRELBOTTOM,$c(a0)

		lea.l	NGQuitGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadgetTagList1,a2
		lib	GadTools,CreateGadgetA
		move.l	d0,a0

		add.w	#GRELBOTTOM,$c(a0)

		lea.l	NGNextGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadgetTagList1,a2
		lib	GadTools,CreateGadgetA
		move.l	d0,a0

		add.w	#GRELBOTTOM+GRELRIGHT,$c(a0)

HelpCont0.2:	tst.b	MenuMagic3
		bne	HelpCont
		lea.l	MNMainMenu1,a0
		lea.l	HMenuTagList,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist3

		move.l	mlist3,a0
		move.l	vi,a1
		lea.l	HMenuTagList,a2
		lib	GadTools,LayoutMenusA
		move.b	#1,MenuMagic3

HelpCont:	lea.l	NewHelpWin1,a0
		lea.l	NHelpTL,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,HWin1
		beq	NoHelpWin1

		move.l	d0,a0
		move.l	$32(a0),HWin1RP

		move.l	HWin1,a0
		move.l	mlist3,a1
		lib	Intuition,SetMenuStrip

		move.l	HWin1,a0
		move.l	glist3,a1
		move.l	#-1,d0
		move.l	#-1,d1
		move.l	#$00,a2
		lib	Intuition,AddGList

		move.l	glist3,a0
		move.l	HWin1,a1
		move.l	#$00,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	HWin1,a0
		move.l	#$00,a1
		lib	GadTools,GT_RefreshWindow

HelpCont1:	cmp.w	#00,HelpPage
		beq	HelpHelp
		cmp.w	#01,HelpPage
		beq	HelpPage1
		cmp.w	#02,HelpPage
		beq	HelpPage2
		cmp.w	#03,HelpPage
		beq	HelpPage3
		cmp.w	#04,HelpPage
		beq	HelpPage4
		cmp.w	#05,HelpPage
		beq	HelpPage5
		cmp.w	#06,HelpPage
		beq	HelpPage6
		cmp.w	#07,HelpPage
		beq	HelpPage7
		cmp.w	#08,HelpPage
		beq	HelpPage8
		cmp.w	#09,HelpPage
		beq	HelpPage9
		cmp.w	#10,HelpPage
		beq	HelpPage10
		cmp.w	#11,HelpPage
		beq	HelpPage11
;		cmp.w	#12,HelpPage
;		beq	HelpPage12
;		cmp.w	#13,HelpPage
;		beq	HelpPage13
;		cmp.w	#14,HelpPage
;		beq	HelpPage14
		move.w	#$00,HelpPage
						;Change
HelpWinIDCMP:	move.l	HWin1,a0
		jsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2
		beq	HelpQuit
		cmp.l	#VANILLAKEY,d2
		beq	HelpVKeys
		cmp.l	#RAWKEY,d2
		beq	HelpRKeys
		cmp.l	#GADGETUP,d2
		beq	HGads
		cmp.l	#MENUPICK,d2
		beq	HMenus
		jmp	HelpWinIDCMP

HMenus:		jsr	MenuNull
		cmp.l	#$00,d6
		beq	HMenus1
		cmp.l	#$01,d6
		beq	HMenus2
		jmp	HelpWinIDCMP
HMenus1:	cmp.l	#$00,d5
		beq	HelpHelp
		cmp.l	#$02,d5			;01 is a sep-bar
		beq	HelpQuit
		jmp	HelpWinIDCMP
HMenus2:	cmp.l	#$00,d5
		beq	SubPage
		cmp.l	#$01,d5
		beq	AddPage
		jmp	HelpWinIDCMP

HelpVKeys:	cmp.w	#$1b,d3
		beq	HelpQuit
		cmp.w	#"p",d3
		beq	SubPage
		cmp.w	#"P",d3
		beq	SubPage
		cmp.w	#"n",d3
		beq	AddPage
		cmp.w	#"N",d3
		beq	AddPage
		cmp.w	#"q",d3
		beq	HelpQuit
		cmp.w	#"Q",d3
		beq	HelpQuit
		cmp.w	#"?",d3
		beq	HelpHelp
		jmp	HelpWinIDCMP

HelpRKeys:	cmp.w	#$5f,d3		;help
		beq	HelpHelp
		cmp.w	#$4f,d3		;arrow back
		beq	SubPage
		cmp.w	#$4e,d3		;arrow forward
		beq	AddPage
		cmp.w	#$4d,d3		;arrow down
		beq	SubPage
		cmp.w	#$4c,d3		;arrow up
		beq	AddPage
		jmp	HelpWinIDCMP

HelpQuit:	lea.l	SS_Quit,a0
		jsr	Speaker

		move.l	HWin1,a0
		lib	Intuition,ClearMenuStrip
		move.l	HWin1,a0
		jsr	ClearMSGs
		move.l	#$00,HWin1
		jsr	MenusOn
		jsr	NormalPointer

		cmp.w	#$00,Mode
		bne	HelpQuit1
		jsr	MainMenu
		jmp	Window1IDCMP
HelpQuit1:	cmp.w	#$02,Mode
		bne	Window1IDCMP
		jsr	SetActivation
		jsr	OthActivation1
		jmp	Window1IDCMP

HelpHelp:	lea.l	SS_HelpHelp,a0
		jsr	Speaker
		move.w	#$00,HelpPage
		lea.l	HelpPage0Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle0,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage1:	lea.l	SS_Page1,a0
		jsr	Speaker
		lea.l	HelpPage1Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle1,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage2:	lea.l	SS_Page2,a0
		jsr	Speaker
		lea.l	HelpPage2Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle2,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage3:	lea.l	SS_Page3,a0
		jsr	Speaker
		lea.l	HelpPage3Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle3,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage4:	lea.l	SS_Page4,a0
		jsr	Speaker
		lea.l	HelpPage4Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle4,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage5:	lea.l	SS_Page5,a0
		jsr	Speaker
		lea.l	HelpPage5Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle5,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage6:	lea.l	SS_Page6,a0
		jsr	Speaker
		lea.l	HelpPage6Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle6,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage7:	lea.l	SS_Page7,a0
		jsr	Speaker
		lea.l	HelpPage7Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle7,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage8:	lea.l	SS_Page8,a0
		jsr	Speaker
		lea.l	HelpPage8Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle8,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage9:	lea.l	SS_Page9,a0
		jsr	Speaker
		lea.l	HelpPage9Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle9,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage10:	lea.l	SS_Page10,a0
		jsr	Speaker
		lea.l	HelpPage10Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle10,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage11:	lea.l	SS_Page11,a0
		jsr	Speaker
		lea.l	HelpPage11Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle11,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage12:	lea.l	SS_Page12,a0
		jsr	Speaker
;		lea.l	HelpPage12Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle12,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage13:	lea.l	SS_Page13,a0
		jsr	Speaker
;		lea.l	HelpPage13Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle13,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HelpPage14:	lea.l	SS_Page14,a0
		jsr	Speaker
;		lea.l	HelpPage14Txts,a1
		move.l	#$00,d0
		move.l	#-10,d1
		lea.l	HelpTitle14,a2
		jsr	DoPage
		jmp	HelpWinIDCMP

HGads:		cmp.w	#98,$26(a5)
		beq	HelpQuit
		cmp.w	#20,$26(a5)
		beq	SubPage
		cmp.w	#30,$26(a5)
		beq	AddPage
		jmp	HelpWinIDCMP

SubPage:	lea.l	SS_Prev2,a0
		jsr	Speaker
		sub.w	#1,HelpPage
		bmi	SubPage1
		jmp	HelpCont1
SubPage1:	move.w	#11,HelpPage		;change to max page
		jmp	HelpCont1
AddPage:	lea.l	SS_Next2,a0
		jsr	Speaker
		add.w	#1,HelpPage
		cmp.w	#12,HelpPage		;change to max page +1
		beq	AddPage1
		jmp	HelpCont1
AddPage1:	move.w	#$00,HelpPage
		jmp	HelpCont1


;d0 = xOffSet
;a1 = pointer to Text
;a2 = pointer WinTitle

DoPage:		movem.l d0-d1/a0-a2,-(sp)
		move.l	HWin1RP,a1		;clear page
		move.l	#$00,d0
		move.l	_GfxBase,a6
		jsr	_LVOSetAPen(a6)
		move.l	HWin1RP,a1
		move.l	#$05,d0			;Left
		move.l	#$01,d1			;Top
		move.l	#616,d2			;Right
		move.l	#166,d3			;Bottom
		jsr	_LVORectFill(a6)
		move.l	_IntuitionBase,a6	;draw image
		move.l	glist3,a0
		move.l	HWin1,a1
		move.l	#$00,a2
		jsr	_LVORefreshGadgets(a6)
		move.l	HWin1RP,a0
		lea.l	HelpImage,a1
		move.l	#32,d0			;x offset
		move.l	#60,d1			;y offset
		jsr	_LVODrawImage(a6)
		movem.l (sp)+,d0-d1/a0-a2
		move.l	HWin1RP,a0
		jsr	_LVOPrintIText(a6)
		move.l	HWin1,a0
		move.l	a2,a1
		move.l	#-1,a2
		jsr	_LVOSetWindowTitles(a6)		
		rts

;-------------------- STRUCTURES --------------------

HWin1:		dc.l	0
HWin1RP:	dc.l	0
HelpPage:	dc.w	1		;0=Help help...

;GadTools stuff

mlist3:		dc.l	0
ContextGad3:	dc.l	0
GadMagic3:	dc.b	0
MenuMagic3:	dc.b	0

;Window

NewHelpWin1	dc.w	10,21			;X,Y POS
		dc.w	620			;WIDTH
		dc.w	169			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+VANILLAKEY+RAWKEY+GADGETUP+MENUPICK	;IDCMP FLAGS
		dc.l	GIMMEZEROZERO+WINDOWDRAG+WINDOWDEPTH+WINDOWCLOSE+ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	HelpTitle1		;TITLE
SToW7:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	192
		dc.w	11,400,43		;MINIMUM SIZE
		dc.w	$f			;TYPE

NHelpTL:	dc.l	WA_InnerWidth,620
		dc.l	WA_InnerHeight,157
		dc.l	TAG_DONE,0

HelpTitle0:	dc.b	"Help on help",0
HelpTitle1:	dc.b	"Help page #1 - Contents",0
HelpTitle2:	dc.b	"Help page #2 - Main screen options...",0
HelpTitle3:	dc.b	"Help page #3 - ...Main screen options...",0
HelpTitle4:	dc.b	"Help page #4 - ...Main screen options...",0
HelpTitle5:	dc.b	"Help page #5 - ...Main screen options...",0
HelpTitle6:	dc.b	"Help page #6 - ...Main screen options...",0
HelpTitle7:	dc.b	"Help page #7 - ...Main screen options",0
HelpTitle8:	dc.b	"Help page #8 - Student mode...",0
HelpTitle9:	dc.b	"Help page #9 - ...Student mode",0
HelpTitle10:	dc.b	"Help page #10 - Teacher mode",0
HelpTitle11:	dc.b	"Help page #11 - Preferences",0
HelpTitle12:	dc.b	"Help page #12",0
HelpTitle13:	dc.b	"Help page #13",0
HelpTitle14:	dc.b	"Help page #14",0
HelpTitle15:	dc.b	"Help page #15",0
HelpTitle16:	dc.b	"Help page #16",0
HelpTitle17:	dc.b	"Help page #17",0
HelpTitle18:	dc.b	"Help page #18",0
HelpTitle19:	dc.b	"Help page #19",0
HelpTitle20:	dc.b	"Help page #20",0

;Imagery, Borders etc.

HelpImage:	dc.w 0,0,20,26,1
		dc.l HelpImageData
		dc.b 1,0
		dc.l 0

;Texts, used in menus and gadgets

HelpText1:	dc.b	"Help",0
PrevGadText1:	dc.b	"_Prev",0
QuitGadText1:	dc.b	"_"
QuitText1:	dc.b	"Quit",0
NextGadText1:	dc.b	"_"
NextText1:	dc.b	"Next",0
PrevText1:	dc.b	"Previous",0
		ds.l	0

Menu1Name:	dc.b	"Main",0
Menu2Name:	dc.b	"Move",0
HelpCommKey:	dc.b	"H",0
PrevCommKey:	dc.b	"P",0
NextCommKey:	dc.b	"N",0
QuitCommKey:	dc.b	"Q",0

HMenuTagList:	dc.l	GTMN_TextAttr,Topaz
		dc.l	GTMN_Menu,MNMainMenu1
		dc.l	TAG_DONE,0

MNMainMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNHelpMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	HelpText1		;gnm_Label
		dc.l	HelpCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNHSepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNQuitMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	QuitText1		;gnm_Label
		dc.l	QuitCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNMoveMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu2Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPrevMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrevText1		;gnm_Label
		dc.l	PrevCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNNextMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NextText1		;gnm_Label
		dc.l	NextCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;ITEM_END?

;Gagdet Taglists

GadgetTagList1: dc.l	GT_Underscore,'_'
		dc.l	TAG_DONE,0

;Gadget list header

glist3:		dc.l	0		;Next Gadget
		dc.w	0		;"hit-box" left edge
		dc.w	0		;"hit-box" top	edge
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

;New gadget structures

NGPrevGad:	dc.w	13		;gng_LeftEdge
		dc.w	-15		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	PrevGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	20		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGQuitGad:	dc.w	260		;gng_LeftEdge
		dc.w	-15		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	QuitGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	98		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNextGad:	dc.w	-113		;gng_LeftEdge
		dc.w	-15		;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	NextGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	30		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

HelpPage0Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	170,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpTitle0		;TEXT
		dc.l	HP1Txt0.11		;NEXTTEXT
HP1Txt0.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	171,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpTitle0		;TEXT
		dc.l	HPage0Txt2		;NEXTTEXT
HPage0Txt2:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	70,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.1		;TEXT
		dc.l	HPage0Txt3		;NEXTTEXT
HPage0Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,38			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.2		;TEXT
		dc.l	HPage0Txt4		;NEXTTEXT
HPage0Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,46			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.3		;TEXT
		dc.l	HPage0Txt5		;NEXTTEXT
		ds.l	0
HPage0Txt5:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	70,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.4		;TEXT
		dc.l	HPage0Txt6		;NEXTTEXT
HPage0Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,68			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.5		;TEXT
		dc.l	HPage0Txt7		;NEXTTEXT
HPage0Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,76			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.6		;TEXT
		dc.l	HPage0Txt8		;NEXTTEXT
HPage0Txt8:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	70,92			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.7		;TEXT
		dc.l	HPage0Txt9		;NEXTTEXT
HPage0Txt9:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.8		;TEXT
		dc.l	HPage0Txt10		;NEXTTEXT
HPage0Txt10:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,108			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.9		;TEXT
		dc.l	0			;NEXTTEXT

HText0.1:	dc.b	"To view the next page press the:",0
HText0.2:	dc.b	"N-key or '->'-key (arrow right)",0
HText0.3:	dc.b	"'Next' gadget in the lower right corner",0
HText0.4:	dc.b	"To view the previous page press the:",0
HText0.5:	dc.b	"P-key or '<-'-key (arrow left)",0
HText0.6:	dc.b	"'Prev' gadget in the lower left corner",0
HText0.7:	dc.b	"To leave the help, press the:",0
HText0.8:	dc.b	"Q-key or ESC-key (Escape)",0
HText0.9:	dc.b	"'Quit' gadget in middle",0
		ds.l	0

HelpPage1Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	180,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.1		;TEXT
		dc.l	HP1Txt1.11		;NEXTTEXT
HP1Txt1.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	181,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.1		;TEXT
		dc.l	HPage1Txt2		;NEXTTEXT
HPage1Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.2		;TEXT
		dc.l	HPage1Txt3		;NEXTTEXT
HPage1Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.3		;TEXT
		dc.l	HPage1Txt4		;NEXTTEXT
HPage1Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.4		;TEXT
		dc.l	HPage1Txt5		;NEXTTEXT
		ds.l	0
HPage1Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.5		;TEXT
		dc.l	0 ;HPage1Txt6		;NEXTTEXT
HPage1Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.6		;TEXT
		dc.l	HPage1Txt7		;NEXTTEXT
HPage1Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.7		;TEXT
		dc.l	0			;NEXTTEXT

HText1.1:	dc.b	"Main Page - Contents",0
HText1.2:	dc.b	"1. Main screen",0
HText1.3:	dc.b	"2. Student mode",0
HText1.4:	dc.b	"3. Teacher mode",0
HText1.5:	dc.b	"4. Preferences",0
HText1.6:	dc.b	"(5. )",0
HText1.7:	dc.b	"(6. )",0
		ds.l	0

HelpPage2Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.3		;TEXT
		dc.l	HPage2Txt4		;NEXTTEXT
HPage2Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.4		;TEXT
		dc.l	HPage2Txt5		;NEXTTEXT
HPage2Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.5		;TEXT
		dc.l	HPage2Txt6		;NEXTTEXT
HPage2Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.6		;TEXT
		dc.l	HPage2Txt7		;NEXTTEXT
HPage2Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.7		;TEXT
		dc.l	HPage2Txt8		;NEXTTEXT
HPage2Txt8:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.8		;TEXT
		dc.l	HPage2Txt9		;NEXTTEXT
HPage2Txt9:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.9		;TEXT
		dc.l	HPage2Txt10		;NEXTTEXT
HPage2Txt10:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,110			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.10		;TEXT
		dc.l	HPage2Txt11		;NEXTTEXT
HPage2Txt11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,120			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.11		;TEXT
		dc.l	HPageHeader1		;NEXTTEXT
HPageHeader1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	150,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.1		;TEXT
		dc.l	HPageHeader1.1		;NEXTTEXT
HPageHeader1.1: dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	151,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.1		;TEXT
		dc.l	HPageHeader1.2		;NEXTTEXT
HPageHeader1.2: dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.2		;TEXT
		dc.l	0			;NEXTTEXT

HText2.1:	dc.b	"In the main screen you have these options.",0
HText2.2:	dc.b	"These include the following (from the menus):",0
HText2.3:	dc.b	"Main Menu",0
HText2.4:	dc.b	"Start      - Start quiz",0
HText2.5:	dc.b	"Enter name - Enter players name",0
HText2.6:	dc.b	"Load       - Load a quiz",0
HText2.7:	dc.b	"Save       - Save a quiz (Teacher Mode)",0
HText2.8:	dc.b	"Save as    - Select name for a quiz and save it (Teacher Mode)",0
HText2.9:	dc.b	"About      - About this program",0
HText2.10:	dc.b	"Help       - This help section",0
HText2.11:	dc.b	"Quit       - Quit program or return to Student Mode",0
		ds.l	0

HelpPage3Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.1		;TEXT
		dc.l	HPage3Txt2		;NEXTTEXT
HPage3Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.2		;TEXT
		dc.l	HPage3Txt3		;NEXTTEXT
HPage3Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.3		;TEXT
		dc.l	HPage3Txt4		;NEXTTEXT
HPage3Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.4		;TEXT
		dc.l	HPage3Txt5		;NEXTTEXT
HPage3Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.5		;TEXT
		dc.l	HPageHeader1		;NEXTTEXT

HText3.1:	dc.b	"Edit Menu (Teacher Mode)",0
HText3.2:	dc.b	"Add        - Add a Question",0
HText3.3:	dc.b	"Delete     - Delete this question (No undo)",0
HText3.4:	dc.b	"Clear      - Clear this question",0
HText3.5:	dc.b	"Undo       - Undo changes to this question",0
		ds.l	0

HelpPage4Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText4.1		;TEXT
		dc.l	HPage4Txt2		;NEXTTEXT
HPage4Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText4.2		;TEXT
		dc.l	HPageHeader1		;NEXTTEXT

HText4.1:	dc.b	"Edit All Menu (Teacher Mode)",0
HText4.2:	dc.b	"Clear      - Clear all questions and answers",0
		ds.l	0

HelpPage5Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.1		;TEXT
		dc.l	HPage5Txt2		;NEXTTEXT
HPage5Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.2		;TEXT
		dc.l	HPage5Txt3		;NEXTTEXT
HPage5Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.3		;TEXT
		dc.l	HPage5Txt4		;NEXTTEXT
HPage5Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.4		;TEXT
		dc.l	HPage5Txt5		;NEXTTEXT
HPage5Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.5		;TEXT
		dc.l	HPageHeader1		;NEXTTEXT

HText5.1:	dc.b	"Move Menu (Teacher Mode)",0
HText5.2:	dc.b	"First      - Go to first question",0
HText5.3:	dc.b	"Last       - Go to last question",0
HText5.4:	dc.b	"Previous   - Go to previous question",0
HText5.5:	dc.b	"Next       - Go to next question",0
		ds.l	0

HelpPage6Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText6.1		;TEXT
		dc.l	HPage6Txt2		;NEXTTEXT
HPage6Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText6.2		;TEXT
		dc.l	HPage6Txt3		;NEXTTEXT
HPage6Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText6.3		;TEXT
		dc.l	HPageHeader1		;NEXTTEXT

HText6.1:	dc.b	"Mode Menu",0
HText6.2:	dc.b	"Student    - Activate student mode",0
HText6.3:	dc.b	"Teacher    - Activate teacher mode",0
		ds.l	0

HelpPage7Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText7.1		;TEXT
		dc.l	HPage7Txt2		;NEXTTEXT
HPage7Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText7.2		;TEXT
		dc.l	HPage7Txt3		;NEXTTEXT
HPage7Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText7.3		;TEXT
		dc.l	HPage7Txt4		;NEXTTEXT
HPage7Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText7.4		;TEXT
		dc.l	HPageHeader1		;NEXTTEXT

HText7.1:	dc.b	"Preferences Menu",0
HText7.2:	dc.b	"Set prefs  - Set preferences",0
HText7.3:	dc.b	"Load prefs - Load preferences",0
HText7.4:	dc.b	"Save prefs - Save preferences",0
		ds.l	0

HelpPage8Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	70,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.1		;TEXT
		dc.l	HPage8Txt2		;NEXTTEXT
HPage8Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.2		;TEXT
		dc.l	HPage8Txt3		;NEXTTEXT
HPage8Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.3		;TEXT
		dc.l	HPage8Txt4		;NEXTTEXT
HPage8Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.4		;TEXT
		dc.l	HPage8Txt5		;NEXTTEXT
HPage8Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.5		;TEXT
		dc.l	HPage8Txt6		;NEXTTEXT
HPage8Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.6		;TEXT
		dc.l	HPage8Txt7		;NEXTTEXT
HPage8Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.7		;TEXT
		dc.l	HPage8Txt8		;NEXTTEXT
HPage8Txt8:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.8		;TEXT
		dc.l	HPage8Txt9		;NEXTTEXT
HPage8Txt9:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.9		;TEXT
		dc.l	HPage8Txt10		;NEXTTEXT
HPage8Txt10:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,110			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.10		;TEXT
		dc.l	HPage8Txt11		;NEXTTEXT
HPage8Txt11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,120			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.11		;TEXT
		dc.l	HPage8Txt12		;NEXTTEXT
HPage8Txt12:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,130			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText8.12		;TEXT
		dc.l	0 ;HPage8Txt13		;NEXTTEXT

HText8.1:	dc.b	"STUDENT MODE",0
HText8.2:	dc.b	" This mode is the mode the student uses.  While in this mode, the",0
HText8.3:	dc.b	"questions in  memory  or  the ones loaded  into memory will asked",0
HText8.4:	dc.b	"from the student.",0
HText8.5:	dc.b	" The screen is  divided into five parts. The first, starting from",0
HText8.6:	dc.b	"the top,  describes  the  current question set.  It also normally",0
HText8.7:	dc.b	"gives an  example  to help get started.  There is also a box with",0
HText8.8:	dc.b	"the words PUNC., CASE and ORDER.  PUNCtuation when lit, indicates",0
HText8.9:	dc.b	"the need  of correct punctuation. CASE indicates, again when lit,",0
HText8.10:	dc.b	"the need for correct capitalization.  ORDER tells whether the an-",0
HText8.11:	dc.b	"swers have to be in  the correct order  (valid only with multiple",0
HText8.12:	dc.b	"correct answers).",0
		ds.l	0

HelpPage9Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.1		;TEXT
		dc.l	HPage9Txt2		;NEXTTEXT
HPage9Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.2		;TEXT
		dc.l	HPage9Txt3		;NEXTTEXT
HPage9Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.3		;TEXT
		dc.l	HPage9Txt4		;NEXTTEXT
HPage9Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.4		;TEXT
		dc.l	HPage9Txt5		;NEXTTEXT
HPage9Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.5		;TEXT
		dc.l	HPage9Txt6		;NEXTTEXT
HPage9Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.6		;TEXT
		dc.l	HPage9Txt7		;NEXTTEXT
HPage9Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText9.7		;TEXT
		dc.l	0 ;HPage9Txt8		;NEXTTEXT

HText9.1:	dc.b	" The next part informs of score,  number of questions and whether",0
HText9.2:	dc.b	"or not there is a timer, and if is, the time left to answer ques-",0
HText9.3:	dc.b	"tion. After this comes the question box in which the question ap-",0
HText9.4:	dc.b	"pears.  Below the question box is  the answer box,  in  which the",0
HText9.5:	dc.b	"correct answers are  given.  If in multiple select mode,  this is",0
HText9.6:	dc.b	"where answers are  chosen from.  The last part is  an  input box.",0
HText9.7:	dc.b	"Written answers are entered here.",0
		ds.l	0

HelpPage10Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	70,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.1		;TEXT
		dc.l	HPage10Txt2		;NEXTTEXT
HPage10Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.2		;TEXT
		dc.l	HPage10Txt3		;NEXTTEXT
HPage10Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.3		;TEXT
		dc.l	HPage10Txt4		;NEXTTEXT
HPage10Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.4		;TEXT
		dc.l	HPage10Txt5		;NEXTTEXT
HPage10Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.5		;TEXT
		dc.l	HPage10Txt6		;NEXTTEXT
HPage10Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.6		;TEXT
		dc.l	HPage10Txt7		;NEXTTEXT
HPage10Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.7		;TEXT
		dc.l	HPage10Txt8		;NEXTTEXT
HPage10Txt8:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.8		;TEXT
		dc.l	HPage10Txt9		;NEXTTEXT
HPage10Txt9:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.9		;TEXT
		dc.l	HPage10Txt10		;NEXTTEXT
HPage10Txt10:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,110			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.10		;TEXT
		dc.l	HPage10Txt11		;NEXTTEXT
HPage10Txt11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,120			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText10.11		;TEXT
		dc.l	0 ;HPage10Txt12		;NEXTTEXT

HText10.1:	dc.b	"TEACHER MODE",0
HText10.2:	dc.b	" In this mode you are able to make your question sets. The screen",0
HText10.3:	dc.b	"is almost the same as  in the student mode.  The only differences",0
HText10.4:	dc.b	"are  the extra gadgets and written answer gadget  is missing from",0
HText10.5:	dc.b	"the bottom of the screen. The gadgets are, starting from the left",0
HText10.6:	dc.b	"and top, First, Last, Prev, Next.  The next four are,  again from",0
HText10.7:	dc.b	"the  top  left,  Add, Undo,  Del and Clear.  The one by itself is",0
HText10.8:	dc.b	"Clear.",0
HText10.9:	dc.b	" ",0
HText10.10:	dc.b	" ",0
HText10.11:	dc.b	" ",0
		ds.l	0

HelpPage11Txts:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	70,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText11.1		;TEXT
		dc.l	HPage11Txt2		;NEXTTEXT
HPage11Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText11.2		;TEXT
		dc.l	HPage11Txt3		;NEXTTEXT
HPage11Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText11.3		;TEXT
		dc.l	HPage11Txt4		;NEXTTEXT
HPage11Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText11.4		;TEXT
		dc.l	HPage11Txt5		;NEXTTEXT
HPage11Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText11.5		;TEXT
		dc.l	0 ;HPage11Txt6		;NEXTTEXT

HText11.1:	dc.b	"PREFERENCES ",0
HText11.2:	dc.b	" The preferences in this program are  a  lot like the ones in the",0
HText11.3:	dc.b	"Workbench  enviroment.  You can change the colors  of  the screen,",0
HText11.4:	dc.b	"the SPEAK: device and all other things related to speech, to start",0
HText11.5:	dc.b	"of with. These are all explained later.",0
		ds.l	0

		Section Help,DATA,CHIP

HelpImageData:	dc.w	$0,$0,$1fc,$0,$fff,$0,$3fff,$8000
		dc.w	$7f0f,$e000,$7f07,$e000,$3f07,$e000,$1e07,$e000
		dc.w	$f,$e000,$f,$c000,$1f,$0,$3e,$0
		dc.w	$7c,$0,$78,$0,$f0,$0,$f0,$0
		dc.w	$e0,$0,$0,$0,$0,$0,$0,$0
		dc.w	$f0,$0,$1f8,$0,$3fc,$0,$1f8,$0
		dc.w	$f0,$0,$0,$0

		END

Preferences:

 - Set prefs

This opens up a window, in which you can change certain things that
affect the way the program behaves. You can change whether or not you
would like speech, what the speech file is (will be changed to allow use
of different devices), what to say, and screen colors.

- Gadgets
  - boxes with a checkmark when active

Speech                  - Speech on/off. Default OFF
System messages         - Say programs actions, disk errors etc. Default
                          ON
Descriptions            - Say descriptions. Default ON
Questions               - Say questions. Default OFF
Answers                 - Say answers. Default OFF
Score                   - Say score. Default OFF

  - boxes with text in it (string gadget)

Speech 'file'           - to which 'file' or 'device' to direct speech
                          to. Default 'SPEAK:'

  - normal 'click-on' gadgets

Set colors              - opens a requester in which you can change the
                          colors used.
Defaults                - changes all preferences to the defaults
                          programmed into the program
Save                    - saves the preferences with the current name,
                          again given by 'load' or 'save as'.

- Menus

        Menu    Item            Short cut       Explanation
        ----    ----            ---------       -----------
        Preferences
                Load...         Amiga-L         Load prefs
                Save            Amiga-S         Save with current name
                Save as...      Amiga-W         Save given with name
                Get defaults    Amiga-D         Use defaults
                Quit            Amiga-Q         Go to main program
        Edit
                Colors          Amiga-C         Edit colors

Preferences-menu:

 - Load

This allows the user to load saved preferences. A requester (a box with
filenames in it) appears onscreen waiting for input. The default
directory for the preferences file is ENVARC:. All other system
preferences are stored here, so so are the Questions programs. The
default name for the file is 'Questions.prefs'. Again like with the
question files, other files are not shown. In this case only files which
have the extension '.prefs' are shown. Using the requester is not
explained here, it should be taught along with other basics of using the
Amiga computer.
                                                              
 - Save

After making changes to the preferences, you will most likely want
to save them for later use. This option saves the questions with the
current filename (i.e. the file name given via 'Save as' earlier, or
via 'Load').

 - Save as

This is basically the same as 'Save' except it prompts for the filename
first. The same type of requester that is used with load pops up asking
for the file name. The program does not add the extension '.prefs' which
indicates that this file is a preferences file. It is not nessesary, but
prefered since the load requester normally shows only files that have
the extension. NOTE: Since the program loads its preferences on startup,
in order the program to use your preferences, the name of the file must
be (including path) 'ENVARC:Questions.prefs', i.e. the default.

 - Get defaults

This resets all options to the preferences that are programmed into the
program. The colors are changed to standard Kickstart/Workbench colors
(version 37.175(KS)/37.59(WB)) and the speech gadgets to preferable
configurations.

 - Quit

Quits back to the main program.


Edit-menu:

 - Colors

This function brings up a so called 'color requester'. In it you can see
fours boxes, three sliders and a few other gadgets. To choose the color
to edit, click on one of the four colored boxes. After that simply use
the sliders to change the color components of that color. The first
slider changes the color component red, the second green and the last
blue.

- Keys

TO QUIT PREFERENCES:
Q, ESCape



To Quit from teacher mode, while a string gadget is activated, use right-
Amiga-Escape.

Main screen options
-------------------
This sections describes all the functions available from the main
screen. Some of the functions are available at certain times (like the
save functions are available only in the teacher mode).

Main-menu:

 - Start

This starts the asking of questions. If the student hasn't given there
name yet, the program will ask for it first. If there is no question set
loaded, again the program will ask the user for it first and load it.


 - Enter name

When this is selected, the screen is cleared and a box appears in the
middle of the screen. The user is asked to type in their name for
further references (saving it to disk). It will not allow a blank name.
You must input something.


 - Load

This allows the user to load a question set. A requester (a box with
filenames in it) appears onscreen waiting for input. The question files
usually have the ending '.QUE'. By default, no other files will be
shown, making it easier to find the question files. Using the
requester is not explained here, it should be taught along with other
basics of using the Amiga computer.


 - Save (teacher mode only)

After making changes to questions or after writing them, you will most
likely want to save them for later use. This option saves the questions
with the current filename (i.e. the file name given via 'Save as'
earlier, or via 'Load').


 - Save as (teacher mode only)

This is basically the same as 'Save' except it prompts for the filename
first. The same type of requester that is used with load pops up asking
for the file name. The program does not add the extension '.QUE' which
indicates that this file is a question file. It is not nessesary, but
prefered since the load requester normally shows only files that have
the extension.


 - Help

The help function built into the program is simply a reference to help
the user check what a function does or how it works. Using the help
utility is simple. If in need of help on help, press the help key. Could
it be simpler? Below is a list of functions available under help:

 - About

This simply brings up a requester with a copyright notice, version
number and tells the author. Future versions may have information on the
state of available memory, but this is uncertain.


 - Quit

While in the student mode, this function quits the program. It will ask
if you are sure or not and if so quits. If however, you are in the teacher
mode, it will return you back to student mode, thus it acts the same as
selecting 'Student' from the 'Mode'-menu.


Edit-Menu: (Teacher mode only)


 - Add

This will add a question to the begining of all questions (NOTE: This WILL
change! In future versions the question will be inserted after the
current question). It prepares an empty question and answer and goes to it.

 - Undo

Selecting this causes changes made to the description and current
question, after any other action (like Previous, Next, First, etc.), to
be erased, returning the questions and description to its previous
states.

Edit all-menu: (Teacher mode only)

 - Clear

The name of this function may change. It actually should be something
like RESET. Selecting this causes all questions and answers and
the description to be cleared.


Move-menu: (Teacher mode only)

 - First

This searches the first question, goes to it and displays it onscreen.

 - Last

This does same as 'First' except it goes to the last question.

 - Previous

Goes to the previous question.

 - Next

Goes to the next question.


Mode-menu:

 - Student

This changes the mode to student mode. If already in student mode, this
has no effect.

 - Teacher

This changes the mode to teacher mode. If already in teacher mode, this
has no effect.


