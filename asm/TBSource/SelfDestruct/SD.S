*************************************************
*						*
*		 (C)opyright 1991-92		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
*  SelfDestruct. Intuition version, of course	*
*						*
* Version 1.00	19/09/1991			*
*						*
* - Made for private use			*
*						*
* Version 1.01	25/12/1991			*
*						*
* - Others wanted it!				*
*						*
* Version 1.02	01/01/1992			*
*						*
* - Release version				*
*						*
* BUGS:	Version string incompatible.		*
*						*
* Version 1.03	05/06/1992			*
*						*
* - Bug fixes, minor optimization		*
*						*
* BUGS:	What?					*
*						*
*************************************************
	
	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"intuition/intuition.i"

	INCLUDE	"XREF:dos.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:2.0.xref"

DIntuition:	set	1

Win1Width:	EQU	18
Placebo:	EQU	5+Win1Width
MaxSDLength:	EQU	32

		section	SD,CODE

		push	d2-d7/a2-a6

		push	d0-a0
		openlib	Dos,ShutDown
		pull	d0-a0

		cmp.b	#"?",(a0)
		beq	Usage
		cmp.w	#'-?',(a0)
		beq	Usage
		cmp.w	#'-h',(a0)
		beq	Usage

Cont1:		clr.b	-1(a0,d0.l)
		bsr	ConvASCII
		tst.w	d0
		beq	Cont1.1
		move.w	d0,ClickAmount
		add.l	#1,a0
Cont1.1:	tst.b	(a0)
		beq	Cont1.2
		move.l	a0,SDText1
Cont1.2:	move.l	#37,d0
		lea.l	_IntuitionLib,a1
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_IntuitionBase
		beq	NoKS20

;Have to be under 2.0 to use this

		sub.l	a0,a0
		lib	Intuition,LockPubScreen
		move.l	d0,PubScreen
		beq	NoPub

		move.l	d0,a3
		move.l	sc_Font(a3),Font
		move.w	sc_Width(a3),d2
		move.b	sc_BarHeight(a3),W1Height+1
		add.w	#1,W1Height

		lea.l	SDTxt1,a0
		move.l	a0,d0
		flib	Intuition,IntuiTextLength

		add.w	#6,d0
		move.w	d0,W1Width
		sub.w	d0,d2
		sub.w	#Placebo,d2
		move.w	d2,NewWin1

		add.l	#sc_BitMap,a3
		cmp.b	#$01,$5(a3)
		bne	Cont1.3
		move.b	#$1,BorderPen1
		move.b	#$1,BorderPen2
		move.w	#GADGHCOMP,FGadFlags
		clr.l	FGadRender1
		clr.l	FGadRender2

		add.w	#1,NewWin1+2
		sub.w	#2,W1Height
		sub.w	#1,SDTxtLeft+2
;		sub.w	#1,W1Width

Cont1.3:	move.w	W1Height,FGadHeight
		move.w	W1Width,FGadWidth

		move.w	W1Height,Y1.1
		sub.w	#2,Y1.1
		move.w	W1Height,Y3.1
		sub.w	#2,Y3.1

		move.w	W1Width,X1.3
		move.w	W1Width,X3.3

		sub.w	#1,W1Width
		move.w	W1Width,X2.2
		move.w	W1Width,X2.2
		move.w	W1Width,X4.2
		move.w	W1Width,X2.3
		move.w	W1Width,X4.3
		sub.w	#1,W1Height
		move.w	W1Height,Y2.1
		move.w	W1Height,Y4.1
		move.w	W1Height,Y2.2
		move.w	W1Height,Y4.2
		add.w	#1,W1Width
		add.w	#1,W1Height

		lea.l	NewWin1,a0
		flib	Intuition,OpenWindow
		move.l	d0,Win1
		beq	NoWin1

		sub.l	a0,a0
		move.l	PubScreen,a1
		flib	Intuition,UnlockPubScreen
		clr.l	PubScreen

		move.l	Win1,a0
		flib	Intuition,WindowToFront

Win1IDCMP:	move.l	Win1,a0
		bsr	CheckIDCMP
		tst.l	d0
		beq	ShutDown
		cmp.l	#VANILLAKEY,d2
		beq	VKeys
		cmp.l	#GADGETUP,d2
		beq	AddCount
		cmp.l	#REFRESHWINDOW,d2
		beq	ToFront
		cmp.l	#INACTIVEWINDOW,d2
		bne	Win1IDCMP
		clr.w	Counter
		bra	Win1IDCMP

ToFront:	add.w	#1,Ticker
		cmp.w	#2,Ticker
		bne	Win1IDCMP
		clr.w	Ticker
		move.l	Win1,a0
		lib	Intuition,WindowToFront
		lea.l	FakeGad1,a0
		move.l	Win1,a1
		sub.l	a2,a2
		flib	Intuition,RefreshGadgets
ToFront_OUT:	bra	Win1IDCMP

VKeys:		cmp.w	#"q",d3
		beq	ShutDown
		cmp.w	#"Q",d3
		beq	ShutDown
		clr.w	Counter
		bra	Win1IDCMP

AddCount:	add.w	#1,Counter
		move.w	Counter,d0
		cmp.w	ClickAmount,d0
		beq	SelfDestruct
		bra	Win1IDCMP

SelfDestruct:	lea.l	KillerName,a0
		move.l	a0,d1
		clr.l	d2
		clr.l	d3
		lib	Dos,Execute

;		print	<"Dead-oh-la!",10>

;Whaz 'is for? We're dead!

ShutDown:	tst.l	Win1
		beq	ShutDown9000
		move.l	Win1,a0
		lea.l	FakeGad1,a1
		lib	Intuition,RemoveGadget
		bsr	ClearMSGs

ShutDown9000:	tst.l	PubScreen
		beq	ShutDown8000
		sub.l	a0,a0
		move.l	PubScreen,a1
		lib	Intuition,UnlockPubScreen
		clr.l	PubScreen

ShutDown8000:	closlib	Intuition
		closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

Usage:		lea.l	UsageETCText1,a0
		bsr	Printer
		bra	ShutDown

NoKS20:		lea.l	NoKS20Text1,a0
		bsr	Printer
		bra	ShutDown

NoPub:		lea.l	NoPubText1,a0
		bsr	Printer
		bra	ShutDown

NoWin1:		lea.l	NoWin1Text1,a0
		bsr	Printer
		bra	ShutDown

Printer:	printa	a0
		rts

ConvASCII:	clr.l	d0
		clr.l	d1
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

CheckIDCMP:	move.l	$4,a6			;made this a SubRoutine...
		move.l	$56(a0),a2		;Give it the window structure in a0
		clr.l	d1
		move.b	$0f(a2),d1
		clr.l	d0
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0
		jsr	_LVOWait(a6)	

		cmp.l	#SIGBREAKF_CTRL_C,d0
		bne	GetMsg1
		clr.l	d0
		rts
	
GetMsg1:	move.l	a2,a0	
		jsr	_LVOGetMsg(a6)
		tst.l	d0
		beq	GetMsg2
	
		move.l	d0,a1 
		move.l	$14(a1),d2		;answers with Class in d2,
		move.w	$18(a1),d3		;Code in d3 and
		jsr	_LVOReplyMsg(a6)
		bra	GetMsg1
GetMsg2:	move.l	#-1,d0
		rts

ClearMSGs:	lib	Exec,Forbid
		move.l	Win1,a3
		move.l	$56(a3),a2		;Give it the window structure in a0
ClearMsg1:	move.l	a2,a0	
		flib	Exec,GetMsg
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1 
		flib	Exec,ReplyMsg
		bra	ClearMsg1
ClearMsg2:	move.l	a3,a0
		lib	Intuition,CloseWindow
		lib	Exec,Permit
ClearMsg3:	rts

;Reservations

Ticker:		dc.w	0
ClickAmount:	dc.w	3
PubScreen:	dc.l	0
Win1:		dc.l	0

Counter:	dc.w	0
SDTxt1:		dc.b	1,2		;PENS
		dc.w	0		;DRAW MODE
SDTxtLeft:	dc.w	3,2		;LEFT & TOP EDGE
Font:		dc.l	0		;FONT
SDText1:	dc.l	SDText2		;TEXT
		dc.l	0		;NEXT TEXT

Borders1:	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
BorderPen1:	dc.b	2,0		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY1	;XY's
		dc.l	Borders2	;Next Border

Borders2:	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
		dc.b	1,0		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY2	;XY's
		dc.l	0		;Next Border

Borders3:	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
		dc.b	1,0		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY3	;XY's
		dc.l	Borders4	;Next Border

Borders4:	dc.w	0		;Initial offsets from the origin
		dc.w	0		;LeftEdge and TopEdge
BorderPen2:	dc.b	2,0		;Pens
		dc.b	1		;Draw Mode
		dc.b	3		;Line Count (XY)
		dc.l	BorderXY4	;XY's
		dc.l	0		;Next Border

KillerName:	dc.b	"KillLKick",0
		dc.b	"$VER: "
UsageETCText1:	dc.b	"SelfDestruct 1.03 (5.6.92). (C)opyright Tomi Blinnikka.",13,10,13,10
		dc.b	"USAGE: SelfDestruct [Number] [String]",13,10
		dc.b	"       Where: [Number] is a number from 1 to 4096",13,10
		dc.b	"              [String] is the text to be displayed",13,10,13,10
		dc.b	"Defaults are: NN = 3, XXX = SD",13,10,0
NoPubText1:	dc.b	"ERROR: Couldn't lock on PublicScreen!",13,10,0
NoKS20Text1:	dc.b	"ERROR: This program requires Kickstart 2.0 or higher!",13,10,0
NoWin1Text1:	dc.b	"ERROR: Couldn't open window!",13,10,0
SDText2:	dc.b	"SD",0
		ds.w	0

;Library stuff

		libnames

;Structures

NewWin1:	dc.w	0,0			;X,Y POS
W1Width:	dc.w	0			;WIDTH
W1Height:	dc.w	0			;HEIGHT
		dc.b	0,0			;PENS
		dc.l	REFRESHWINDOW!GADGETUP!VANILLAKEY!INACTIVEWINDOW	;IDCMP FLAGS
		dc.l	BACKDROP!BORDERLESS!SIMPLE_REFRESH	;FLAGS
		dc.l	FakeGad1,0		;GADGETS, CHECKMARK
		dc.l	0			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	18,10,18,10		;MINIMUM SIZE
		dc.w	WBENCHSCREEN		;TYPE

FakeGad1:	dc.l	0		;Next Gadget
FGadLeft:	dc.w	0		;"hit-box" left edge
FGadTop:	dc.w	0		;"hit-box" top  edge
FGadWidth:	dc.w	0		;"hit-box" Width
FGadHeight:	dc.w	0		;"hit-box" Height
FGadFlags:	dc.w	GADGHIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
FGadRender1:	dc.l	Borders1	;gadget rendering
FGadRender2:	dc.l	Borders3	;select rendering
		dc.l	SDTxt1		;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	0		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

		section	SD,BSS

BorderXY1:
X1.1:		ds.w	1
Y1.1:		ds.w	1
X1.2:		ds.w	1
Y1.2:		ds.w	1
X1.3:		ds.w	1
Y1.3:		ds.w	1

BorderXY2:
X2.1:		ds.w	1
Y2.1:		ds.w	1
X2.2:		ds.w	1
Y2.2:		ds.w	1
X2.3:		dc.w	1
Y2.3:		dc.w	1

BorderXY3:
X3.1:		ds.w	1
Y3.1:		ds.w	1
X3.2:		ds.w	1
Y3.2:		ds.w	1
X3.3:		ds.w	1
Y3.3:		ds.w	1

BorderXY4:
X4.1:		ds.w	1
Y4.1:		ds.w	1
X4.2:		ds.w	1
Y4.2:		ds.w	1
X4.3:		ds.w	1
Y4.3:		ds.w	1

		end
