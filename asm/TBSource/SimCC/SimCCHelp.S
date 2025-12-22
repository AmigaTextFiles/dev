;EQUs

VANILLAKEY:	EQU	$00200000
RAWKEY:		EQU	$00000400
CLOSEWINDOW:	EQU	$00000200
GADGETUP:	EQU	$00000040
WINDOWDRAG:	EQU	$0002
WINDOWDEPTH:	EQU	$0004
WINDOWCLOSE:	EQU	$0008
ACTIVATE:	EQU	$1000
WBENCHSCREEN:	EQU	$0001

;Includes

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"LWF:SimCC/SimCC2.0.i"

;xrefs

	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:gfx.xref"
	INCLUDE	"XREF:exec.xref"


;XDEFs

	XDEF	Help
	XDEF	HWin1

;XREFs

	XREF	_IntuitionBase
	XREF	_GfxBase
	XREF	MenusOff
	XREF	MenusOn
	XREF	Kick
	XREF	YOffset
	XREF	Topaz
	XREF	NoWin
	XREF	CheckIDCMP
	XREF	ClearMSGs
	XREF	Window1IDCMP
	XREF	wd_RPort
	XREF	CLOSEWINDOW
	XREF	VANILLAKEY
	XREF	RAWKEY

Help:		bsr	MenusOff
		move.l	_IntuitionBase,a6
		cmp.w	#$01,Kick
		beq	HelpUnder20
		lea.l	NewHelpWin1(pc),a0
		jsr	_LVOOpenWindow(a6)
		move.l	d0,HWin1
		bne	HelpCont
		bra	NoWin
HelpUnder20:	lea.l	NewHelpWin1(pc),a0
		lea.l	HWin1TagList(pc),a1
		jsr	_LVOOpenWindowTagList(a6)
		move.l	d0,HWin1
		bne	HelpCont
		bra	NoWin
HelpCont:	move.l	d0,a0
		move.l	$32(a0),HWin1RP
HelpCont1:	cmp.w	#$00,HelpPage
		beq	HelpHelp
		cmp.w	#$01,HelpPage
		beq	HelpPage1
		cmp.w	#$02,HelpPage
		beq	HelpPage2
		cmp.w	#$03,HelpPage
		beq	HelpPage3
		cmp.w	#$04,HelpPage
		beq	HelpPage4
		cmp.w	#$05,HelpPage
		beq	HelpPage5
		move.w	#$00,HelpPage
						;Change

;Add the stuff for different pages (subroutines please!)

HelpWinIDCMP:	move.l	HWin1(pc),a0
		bsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2
		beq	HelpQuit
		cmp.l	#VANILLAKEY,d2
		beq	HelpVKeys
		cmp.l	#RAWKEY,d2
		beq	HelpRKeys
		cmp.l	#GADGETUP,d2
		beq	HGads
		bra	HelpWinIDCMP

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
		bra	HelpWinIDCMP

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
		bra	HelpWinIDCMP

HelpQuit:	move.l	HWin1,a0
		bsr	ClearMSGs
		move.l	#$00,HWin1
		bsr	MenusOn
		bra	Window1IDCMP

HelpHelp:	move.w	#$00,HelpPage
		lea.l	HelpPage0Txts(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lea.l	HelpTitle0(pc),a2
		bsr	DoPage
		bra	HelpWinIDCMP

HelpPage1:	lea.l	HelpPage1Txts(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lea.l	HelpTitle1(pc),a2
		bsr	DoPage
		bra	HelpWinIDCMP

HelpPage2:	lea.l	HelpPage2Txts(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lea.l	HelpTitle2(pc),a2
		bsr	DoPage
		bra	HelpWinIDCMP

HelpPage3:	lea.l	HelpPage3Txts(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lea.l	HelpTitle3(pc),a2
		bsr	DoPage
		bra	HelpWinIDCMP

HelpPage4:	lea.l	HelpPage4Txts(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lea.l	HelpTitle4(pc),a2
		bsr	DoPage
		bra	HelpWinIDCMP

HelpPage5:	lea.l	HelpPage5Txts(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		lea.l	HelpTitle5(pc),a2
		bsr	DoPage
		bra	HelpWinIDCMP

HGads:		cmp.w	#$2,$26(a5)
		beq	HelpQuit
		cmp.w	#$1,$26(a5)
		beq	SubPage
		cmp.w	#$3,$26(a5)
		beq	AddPage
		bra	HelpWinIDCMP

SubPage:	sub.w	#1,HelpPage
		bmi	SubPage1
		bra	HelpCont1
SubPage1:	move.w	#$05,HelpPage		;change to max page
		bra	HelpCont1
AddPage:	add.w	#1,HelpPage
		cmp.w	#$06,HelpPage		;change to max page +1
		beq	AddPage1
		bra	HelpCont1
AddPage1:	move.w	#$00,HelpPage
		bra	HelpCont1


;d0 = xOffSet
;d1 = yOffSet
;a1 = pointer to Text
;a2 = pointer WinTitle

DoPage:		movem.l	d0-d1/a0-a2,-(sp)
		move.l	HWin1RP(pc),a1		;clear page
		move.l	#$00,d0
		move.l	_GfxBase,a6
		jsr	_LVOSetAPen(a6)
		move.l	HWin1RP(pc),a1
		move.l	#$05,d0
		move.l	#$0a,d1
		add.b	YOffset,d1
		move.l	#399,d2
		move.l	#128,d3
		add.b	YOffset,d3
		jsr	_LVORectFill(a6)
		move.l	_IntuitionBase,a6	;draw image
		lea.l	PrevGad1(pc),a0
		move.l	HWin1(pc),a1
		move.l	#$00,a2
		jsr	_LVORefreshGadgets(a6)
		move.l	HWin1RP(pc),a0
		lea.l	HelpImage(pc),a1
		move.l	#$20,d0
		move.l	#$40,d1
		jsr	_LVODrawImage(a6)
		movem.l	(sp)+,d0-d1/a0-a2
		move.l	HWin1RP(pc),a0
		add.b	YOffset,d1
		jsr	_LVOPrintIText(a6)
		move.l	HWin1(pc),a0
		move.l	a2,a1
		move.l	#-1,a2
		jsr	_LVOSetWindowTitles(a6)		
		rts

;-------------------- STRUCTURES --------------------

HWin1:		dc.l	0
HWin1RP:	dc.l	0
HelpPage:	dc.w	1		;0=Help help...
		ds.l	0

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
HPage0Txt8:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,84			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.7		;TEXT
		dc.l	HPage0Txt9		;NEXTTEXT
HPage0Txt9:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,92			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText0.8		;TEXT
		dc.l	HPage0Txt10		;NEXTTEXT
HPage0Txt10:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,100			;LEFT+TOPEDGE
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
		dc.w	170,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText1.1		;TEXT
		dc.l	HP1Txt1.11		;NEXTTEXT
HP1Txt1.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	171,15			;LEFT+TOPEDGE
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
		dc.l	0			;NEXTTEXT

HText1.1:	dc.b	"Main Page",0
		ds.l	0                          
HText1.2:	dc.b	"1. Select game (from the menus).",0
		ds.l	0                          
HText1.3:	dc.b	"2. Give amount of money.",0
		ds.l	0                          
HText1.4:	dc.b	"3. Choose CHEAT! from the menus.",0
		ds.l	0                          
HText1.5:	dc.b	"4. Give filename.",0
		ds.l	0                          

HelpPage2Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	150,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.1		;TEXT
		dc.l	HP1Txt2.11		;NEXTTEXT
HP1Txt2.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	151,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.1		;TEXT
		dc.l	HPage2Txt2		;NEXTTEXT
HPage2Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.2		;TEXT
		dc.l	HPage2Txt3		;NEXTTEXT
HPage2Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText2.3		;TEXT
		dc.l	HPageSpecial		;NEXTTEXT

HText2.1:	dc.b	"Game: SimCity",0
HText2.2:	dc.b	"Min. amount: $ 0",0
HText2.3:	dc.b	"Max. amount: $ 16, 777 215",0
		ds.l	0

HelpPage3Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	150,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.1		;TEXT
		dc.l	HP1Txt3.11		;NEXTTEXT
HP1Txt3.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	151,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.1		;TEXT
		dc.l	HPage3Txt2		;NEXTTEXT
HPage3Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.2		;TEXT
		dc.l	HPage3Txt3		;NEXTTEXT
HPage3Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.3		;TEXT
		dc.l	HPage3Txt4		;NEXTTEXT
HPage3Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.4		;TEXT
		dc.l	HPage3Txt5		;NEXTTEXT
HPage3Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.5		;TEXT
		dc.l	HPage3Txt6		;NEXTTEXT
HPage3Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.6		;TEXT
		dc.l	HPage3Txt7		;NEXTTEXT
HPage3Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	70,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText3.7		;TEXT
		dc.l	HPageSpecial		;NEXTTEXT

HText3.1:	dc.b	"Game: Ports of Call",0
HText3.2:	dc.b	"Min. amount: $ 0",0
HText3.3:	dc.b	"Max. amount: $ 2, 147 483 63",0
HText3.4:	dc.b	"There is no use taking the  full  amount.",0
HText3.5:	dc.b	"If you do, and your funds go over the max",0
HText3.6:	dc.b	"amount, the amount  will  'roll-over'  to",0
HText3.7:	dc.b	"a negative number, and the game will end.",0
		ds.l	0

HelpPage4Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	150,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText4.1		;TEXT
		dc.l	HP1Txt4.11		;NEXTTEXT
HP1Txt4.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	151,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText4.1		;TEXT
		dc.l	HPage4Txt2		;NEXTTEXT
HPage4Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText4.2		;TEXT
		dc.l	HPage4Txt3		;NEXTTEXT
HPage4Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText4.3		;TEXT
		dc.l	HPageSpecial		;NEXTTEXT

HText4.1:	dc.b	"Game: Oil Imperium",0
HText4.2:	dc.b	"Min. amount: $ 0",0
HText4.3:	dc.b	"Max. amount: $ --",0
		ds.l	0

HelpPage5Txts:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	150,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.1		;TEXT
		dc.l	HP1Txt5.11		;NEXTTEXT
HP1Txt5.11:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	151,15			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.1		;TEXT
		dc.l	HPage5Txt2		;NEXTTEXT
HPage5Txt2:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.2		;TEXT
		dc.l	HPage5Txt3		;NEXTTEXT
HPage5Txt3:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	90,40			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.3		;TEXT
		dc.l	HPage5Txt4		;NEXTTEXT
HPage5Txt4:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,70			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.4		;TEXT
		dc.l	HPage5Txt5		;NEXTTEXT
HPage5Txt5:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,80			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.5		;TEXT
		dc.l	HPage5Txt6		;NEXTTEXT
HPage5Txt6:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,90			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.6		;TEXT
		dc.l	HPage5Txt7		;NEXTTEXT
HPage5Txt7:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	65,100			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HText5.7		;TEXT
		dc.l	HPageSpecial		;NEXTTEXT

HText5.1:	dc.b	"Game: RailRoad Tycoon",0
HText5.2:	dc.b	"Min. amount: $ -32, 767(, 000)",0
HText5.3:	dc.b	"Max. amount: $ 32, 767(, 000)",0
HText5.4:	dc.b	"Beware of 'roll-over'. If a large negative",0
HText5.5:	dc.b	"amount taken, the game might not show the",0
HText5.6:	dc.b	"amount in a red color, but still considers",0
HText5.7:	dc.b	"it a negative amount.",0
		ds.l	0

HPageSpecial:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	60,60			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HSpecialText		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
HSpecialText:	dc.b	"Special:",0
		ds.l	0

;Window

NewHelpWin1	dc.w	100,21			;X,Y POS
		dc.w	410			;WIDTH
		dc.w	143			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+VANILLAKEY+RAWKEY+GADGETUP	;IDCMP FLAGS
		dc.l	WINDOWDRAG+WINDOWDEPTH+WINDOWCLOSE+ACTIVATE	;FLAGS
		dc.l	PrevGad1,0		;GADGETS, CHECKMARK
		dc.l	HelpTitle1		;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	192
		dc.w	11,400,43		;MINIMUM SIZE
		dc.w	WBENCHSCREEN		;TYPE

HWin1TagList	dc.l	WA_AutoAdjust,0
		dc.l	WA_InnerWidth,400
		dc.l	WA_InnerHeight,130
		dc.l	TAG_DONE,0

HelpTitle0:	dc.b	"Help on help",0
HelpTitle1:	dc.b	"Help page #1",0
HelpTitle2:	dc.b	"Help page #2",0
HelpTitle3:	dc.b	"Help page #3",0
HelpTitle4:	dc.b	"Help page #4",0
HelpTitle5:	dc.b	"Help page #5",0

;Imagery, Borders etc.

HelpImage:	dc.w 0,0,20,26,1
		dc.l HelpImageData
		dc.b 1,0
		dc.l 0

HGadBorder1:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	HGadBorderXY1	;XY's
		dc.l	HGadBorder2	;Next Border
		dc.b	0
		ds.l	0
HGadBorderXY1:	dc.w	0,0
		dc.w	52,0		
		dc.w	52,11
		dc.w	0,11
		dc.w	0,0
		dc.b	0
		ds.l	0

HGadBorder2:	dc.w	-2		;Initial offsets from the origin
		dc.w	-3		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	HGadBorderXY2	;XY's
		dc.l	HGadBorder3	;Next Border
		dc.b	0
		ds.l	0
HGadBorderXY2:	dc.w	0,0
		dc.w	54,0		
		dc.w	54,15
		dc.w	0,15
		dc.w	0,0
		dc.b	0
		ds.l	0

HGadBorder3:	dc.w	-3		;Initial offsets from the origin
		dc.w	-4		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	HGadBorderXY3	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
HGadBorderXY3:	dc.w	0,0
		dc.w	56,0		
		dc.w	56,17
		dc.w	0,17
		dc.w	0,0
		dc.b	0
		ds.l	0

;Gadgets

PrevGad1:	dc.l	QuitGad1	;Next Gadget
		dc.w	13		;"hit-box" left edge
		dc.w	-18		;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	$0008		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;gadget type
		dc.l	HGadBorder1	;gadget renderingg
		dc.l	0		;select rendering
		dc.l	PrevGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

PrevGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	PrevGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
PrevGad1Text1:	dc.b	"Prev",0
		ds.l	0

QuitGad1:	dc.l	NextGad1	;Next Gadget
		dc.w	180		;"hit-box" left edge
		dc.w	-18		;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	$0008		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;gadget type
		dc.l	HGadBorder1	;gadget renderingg
		dc.l	0		;select rendering
		dc.l	QuitGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	2		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

QuitGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	QuitGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
QuitGad1Text1:	dc.b	"Quit",0
		ds.l	0

NextGad1:	dc.l	0		;Next Gadget
		dc.w	343		;"hit-box" left edge
		dc.w	-18		;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	$0008		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;gadget type
		dc.l	HGadBorder1	;gadget renderingg
		dc.l	0		;select rendering
		dc.l	NextGad1Txt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	3		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

NextGad1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NextGad1Text1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
NextGad1Text1:	dc.b	"Next",0
		ds.l	0

		Section	Help,DATA,CHIP

HelpImageData:	dc.w	$0,$0,$1fc,$0,$fff,$0,$3fff,$8000
		dc.w	$7f0f,$e000,$7f07,$e000,$3f07,$e000,$1e07,$e000
		dc.w	$f,$e000,$f,$c000,$1f,$0,$3e,$0
		dc.w	$7c,$0,$78,$0,$f0,$0,$f0,$0
		dc.w	$e0,$0,$0,$0,$0,$0,$0,$0
		dc.w	$f0,$0,$1f8,$0,$3fc,$0,$1f8,$0
		dc.w	$f0,$0,$0,$0

		END
