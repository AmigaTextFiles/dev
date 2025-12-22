;	OPT	O+,OW-,L+
;--------------------------------------------------
;	lk V1.01 _stub function.
;	$VER: stub.s 1.00 (18.07.94)
;	Written by Alexis WILKE (c) 1994.
;
;	This code will be used instead of the
;	internal default:
;		MOVEQ #0,D0 : RTS
;	It displays a window with a simple
;	message.
;--------------------------------------------------

	INCDIR	"INCLUDE:INCLUDE.STRIP/"
	INCLUDE	"INTUITION/intuition.i"
	INCLUDE	"INCLUDE:sw.i"

	XDEF	_stub

KEYCODE_ESC	=	$45

WIDTH		=	420
HEIGHT		=	55

	SECTION	TEXT,CODE
;--------------------------------------------------
_stub
	MoveM.L	D2-D6/A3-A6,-(A7)
	Move.L	A0,D0
	Beq.B	.invalid
	Tst.B	(A0)
	Bne.B	.nameok
.invalid
	Lea	FuncDefault(PC),A0
.nameok
	Lea	FuncName(PC),A1
	MoveQ	#FuncNameEnd-FuncName-1,D0
.name
	Move.B	(A0)+,(A1)+
	Dbf	D0,.name
	Lea	_stub(PC),A4			;Get pointer offset

	Lea	IName(PC),A1
	SYS	OldOpenLibrary,4.W		;Open Intuition
	Move.L	D0,IBase-_stub(A4)
	Beq	.exit

	Lea	GName(PC),A1
	SYS	OldOpenLibrary,4.W		;Open Graphics
	Move.L	D0,GBase-_stub(A4)
	Beq	.exit

	MoveQ	#$01,D6
	CmpI.W	#36,LIB_VERSION(A6)
	Bcc.B	.ok
	MoveQ	#$02,D6				;Swap for 1.3 colors
.ok
	SYS	OpenWorkBench,IBase(PC)		;Ensure the workbench is open!
	Tst.L	D0
	Beq	.exit
	MoveA.L	D0,A3

	Lea	MyRPort(PC),A1
	SYS	InitRastPort,GBase(PC)

	Lea	MyNewWindow(PC),A0		;Center window
	Move.W	#WIDTH,D4
	Move.W	#HEIGHT,D5

	Move.L	#$0FF,D1
	MoveQ	#$00,D0
	Move.W	MyRPort+rp_TxHeight(PC),D0	;Resize window on text height
	Lsl.L	#$08,D0
	DivU.W	#$0008,D0
	Move.W	D0,OffsetY-_stub(A4)
	MulU.W	D0,D5
	Add.L	D1,D5
	Lsr.L	#$08,D5
	Cmp.W	sc_Height(A3),D5
	Bcs.B	.yok
	Move.W	sc_Height(A3),D5
.yok
	MoveQ	#$00,D0
	Move.W	MyRPort+rp_TxWidth(PC),D0	;Resize window on text width
	Lsl.L	#$08,D0
	DivU.W	#$0008,D0
	Move.W	D0,OffsetX-_stub(A4)
	MulU.W	D0,D4
	Add.L	D1,D4
	Lsr.L	#$08,D4
	Cmp.W	sc_Width(A3),D4
	Bcs.B	.xok
	Move.W	sc_Width(A3),D4
.xok
	Move.W	D4,nw_Width(A0)
	Move.W	D5,nw_Height(A0)

	Move.W	sc_Width(A3),D0
	Sub.W	D4,D0
	Lsr.W	#$01,D0
	Move.W	D0,nw_LeftEdge(A0)
	Move.W	sc_Height(A3),D0
	Sub.W	D5,D0
	Lsr.W	#$01,D0
	Move.W	D0,nw_TopEdge(A0)
	SYS	OpenWindow,IBase(PC)		;Open our window
	Move.L	D0,MyWindow-_stub(A4)
	Beq	.exit

	MoveA.L	D0,A5
	MoveA.L	wd_RPort(A5),A5

	MoveQ	#RP_JAM2,D0			;Ensure a correct mode to draw
	MoveA.L	A5,A1
	SYS	SetDrMd,GBase(PC)

	MoveQ	#$00,D0
	MoveQ	#5,D1
	MulU.W	OffsetY(PC),D1
	Lsr.L	#$08,D1
	Add.W	rp_TxBaseline(A5),D1
	Move.W	D4,D2
	Lea	Title(PC),A0
	Bsr	_write

	MoveQ	#$00,D0
	MoveQ	#15,D1
	MulU.W	OffsetY(PC),D1
	Lsr.L	#$08,D1
	Add.W	rp_TxBaseline(A5),D1
	Move.W	D4,D2
	Lea	Comment(PC),A0
	Move.L	D6,-(A7)
	MoveQ	#$03,D6
	Bsr	_write
	Move.L	(A7)+,D6

	MoveQ	#$00,D0
	MoveQ	#25,D1
	MulU.W	OffsetY(PC),D1
	Lsr.L	#$08,D1
	Add.W	rp_TxBaseline(A5),D1
	Move.W	D4,D2
	Lea	Function(PC),A0
	Bsr	_write

	MoveQ	#100,D0
	MulU.W	OffsetX(PC),D0
	Lsr.L	#$08,D0
	Move.W	D0,D2
	Neg.L	D0
	Add.W	D4,D0

	MoveQ	#14,D1
	MulU.W	OffsetY(PC),D1
	Lsr.L	#$08,D1
	Sub.W	rp_TxHeight(A5),D1
	Lsr.W	#$01,D1
	Neg.W	D1
	Add.W	rp_TxBaseline(A5),D1
	Sub.W	rp_TxHeight(A5),D1
	Add.W	D5,D1
	SubQ.W	#$04,D1				;The offset from bottom
	SubQ.W	#$08,D2
	Lea	OKText(PC),A0
	Bsr	_write

	MoveQ	#$00,D0
	MoveQ	#$00,D1
	Move.W	D4,D2
	Move.W	D5,D3
	Bsr	_drawrect

	MoveQ	#100,D0
	MulU.W	OffsetX(PC),D0
	Lsr.L	#$08,D0
	Neg.L	D0
	Add.W	D4,D0
	MoveQ	#14,D1
	MulU.W	OffsetY(PC),D1
	Lsr.L	#$08,D1
	Neg.W	D1
	Add.W	D5,D1
	Move.W	D4,D2
	SubQ.W	#$08,D2
	Move.W	D5,D3
	SubQ.W	#$04,D3
	SubQ.W	#$04,D1
	Bsr	_drawrect

	MoveA.L	A3,A0
	SYS	ScreenToFront,IBase(PC)		;Show the workbench screen


.wait
	MoveA.L	MyWindow(PC),A0
	MoveA.L	wd_UserPort(A0),A0
	SYS	WaitPort,4.W
	MoveA.L	MyWindow(PC),A0
	MoveA.L	wd_UserPort(A0),A0
	SYS	GetMsg
	Tst.L	D0
	Beq.B	.wait
	MoveA.L	D0,A0
	CmpI.L	#RAWKEY,im_Class(A0)
	Beq.B	.key
	Move.W	im_Code(A0),D0
	CmpI.W	#SELECTDOWN,D0
	Beq	.exit
	Bra.B	.wait
.key
	Move.W	im_Code(A0),D0
	CmpI.W	#KEYCODE_V,D0
	Beq.B	.exit
	CmpI.W	#KEYCODE_B,D0
	Beq.B	.exit
	CmpI.W	#KEYCODE_ESC,D0
	Bne.B	.wait
.exit
	Move.L	MyWindow(PC),D0
	Beq.B	.nowin
	Clr.L	MyWindow-_stub(A4)
	MoveA.L	D0,A0
	SYS	CloseWindow,IBase(PC)
.nowin
	MoveA.L	4.W,A6
	Move.L	IBase(PC),D0
	Beq.B	.noi
	Clr.L	IBase-_stub(A4)
	Move.L	D0,A1
	SYS	CloseLibrary
.noi
	Move.L	GBase(PC),D0
	Beq.B	.nog
	Clr.L	GBase-_stub(A4)
	Move.L	D0,A1
	SYS	CloseLibrary
.nog

	MoveM.L	(A7)+,D2-D6/A3-A6
	Rts


;--------------------------------------------------
;Inputs:
;	D0 as the X position
;	D1 as the Y position
;	D2 as the size of the gadget
;	A0 as the string
;	A5 as the rastport
;	A6 as the graphics.library base pointer
;--------------------------------------------------
_write
	MoveM.L	D2-D5/A2,-(A7)
	Move.L	D0,D4
	Move.L	D1,D5
	MoveA.L	A0,A2
	Move.L	A0,D3
.end
	Tst.B	(A0)+
	Bne.B	.end
	Sub.L	A0,D3
	Not.L	D3

	MoveA.L	A2,A0
	Move.L	D3,D0
	MoveA.L	A5,A1
	SYS	TextLength

	Sub.L	D2,D0
	Neg.W	D0
	Asr.W	#$01,D0
	Add.W	D4,D0
	Move.W	D5,D1

	MoveA.L	A5,A1
	SYS	Move

	Move.B	D6,D0
	MoveA.L	A5,A1
	SYS	SetAPen

	MoveA.L	A2,A0
	Move.L	D3,D0
	MoveA.L	A5,A1
	SYS	Text
	MoveM.L	(A7)+,D2-D5/A2
	Rts


;--------------------------------------------------
;Inputs:
;	D0/D1 as the top-left position
;	D2/D3 as the bottom-right position (Not included)
;	D6 color
;	A3 as the Workbench screen pointer
;	A6 as graphics.library base pointer
;--------------------------------------------------
_drawrect
	MoveM.L	D2-D6,-(A7)
	Move.L	D0,D4
	Move.L	D1,D5
	SubQ.L	#$01,D2
	SubQ.L	#$01,D3

	Bsr.B	.rect
	BTst.B	#$07,sc_ViewPort+vp_Modes(A3)		;Hires ?
	Beq.B	.nohires
	AddQ.W	#$01,D4
	SubQ.W	#$01,D2
.nohires
	BTst.B	#$02,sc_ViewPort+vp_Modes+1(A3)		;Lace ?
	Beq.B	.nolace
	AddQ.W	#$01,D5
	SubQ.W	#$01,D3
.nolace
	Bsr.B	.rect
	Bsr.B	.large
	MoveM.L	(A7)+,D2-D6
	Rts
.large
	AddQ.W	#$01,D4
	SubQ.W	#$01,D2
	AddQ.W	#$01,D5
	SubQ.W	#$01,D3
	MoveQ	#$00,D6
.rect
	Move.B	D6,D0
	MoveA.L	A5,A1
	SYS	SetAPen

	Move.L	D4,D0
	Move.L	D3,D1
	MoveA.L	A5,A1
	SYS	Move

	Move.L	D2,D0
	Move.L	D3,D1
	MoveA.L	A5,A1
	SYS	Draw

	Move.L	D2,D0
	Move.L	D5,D1
	MoveA.L	A5,A1
	SYS	Draw

	Move.B	D6,D0
	Beq.B	.clear
	Eor.B	#$03,D0
.clear
	MoveA.L	A5,A1
	SYS	SetAPen

	Move.L	D4,D0
	Move.L	D3,D1
	MoveA.L	A5,A1
	SYS	Move

	Move.L	D4,D0
	Move.L	D5,D1
	MoveA.L	A5,A1
	SYS	Draw

	Move.L	D2,D0
	Move.L	D5,D1
	MoveA.L	A5,A1
	SYM	Draw


OffsetX		Dc.W	0
OffsetY		Dc.W	0
GBase		Dc.L	0
IBase		Dc.L	0
MyWindow	Dc.L	0
MyRPort		Ds.B	rp_SIZEOF
MyNewWindow
	Dc.W	0,0,0,0
	Dc.B	1,0
	Dc.L	RAWKEY!MOUSEBUTTONS		;Close Escape or Click inside
	Dc.L	$31800
	Dc.L	0,0,0,0,0
	Dc.W	0,0,0,0
	Dc.W	WBENCHSCREEN

Title		Dc.B	"stub -- lk V1.03 by Alexis WILKE (c) 1994",0
Comment		Dc.B	"(Type ESC to continue)",0
Function	Dc.B	"Function: "
FuncName	Dc.B	"                           "
FuncNameEnd
		Dc.B	0
FuncDefault	Dc.B	"no function name available."
OKText		Dc.B	"OK",0
GName		Dc.B	"graphics.library",0
IName		Dc.B	"intuition.library",0

