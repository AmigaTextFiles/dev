;TOSAAAACLIPAAAADAMPAAAACGAHAAAACGAHAAAAFJACAAAADAMPAAAAEAJLAAAADMFEAAAAEAJLPPPOBADJ
;
;Tanks
;rthek/rdst/suspect
;Starts Gdynia 95 Apr 29
;95 May 19 proba narysowania górek


;RysujGorki

PUSH:	MACRO
	movem.l	\1,-(sp)
	ENDM
POP:	MACRO
	movem.l	(sp)+,\1
	ENDM


VERSION:	MACRO
		dc.b	'v0.1'
		ENDM
;$VER: Tanks v0.1

VERTICAL:	MACRO
	move.l	4(a5),d0
	and.l	#$0001ff00,d0
	cmp.l	#\1*2^8,d0
	bne.s	*-16
	ENDM

CLEARD:	MACRO
	moveq	#0,\1
	ENDM
CLEARA:	MACRO
	sub.l	\1,\1
	ENDM

EXEC:	MACRO
	move.l	4.w,a6
	ENDM

CALL:	MACRO
	jsr	_\1(a6)
	ENDM
CALLEXEC:MACRO
	move.l	4.w,a6
	jsr	_\1(a6)
	ENDM
CALLB:	MACRO
	MOVEL	\2
	CALL	\1
	ENDM

JUMP:	MACRO
	jmp	_\1(a6)
	ENDM
MOVEL:	MACRO
	move.l	\1Base(pc),a6
	ENDM
OPENLIBRARY:	MACRO
	CLEARD	d0
	lea	\1Name,a1
	CALLEXEC OpenLibrary
	move.l	d0,\1Base
	beq	Cant_Find_\1
	ENDM
CLOSELIBRARY:	MACRO
	move.l	\1Base(pc),a1
	CALLEXEC CloseLibrary
	ENDM
REQUEST: MACRO
	lea	\1,a1
	lea	\2,a2
	bsr	DoReq
	ENDM
;0 z prawej

OKREQUEST:	MACRO
	lea	\1,a1
	bsr	DoReqOK
	ENDM
WAITBLITTER:	MACRO
	tst.b	2(a5)
.\@WB
	btst	#14,2(a5)
	bne.s	.\@WB
	ENDM

*******************************************************************************
*				  PROGRAM				      *
*******************************************************************************
        ;;
RUNBACK=0

	IFNE	RUNBACK

	SECTION	"Iff Converter Runback",CODE

	AUTO		wo\

StartUp:
		movem.l	d0/a0,-(sp)

		lea	DosName,a1
		CLEARD	D0
		EXEC
		CALL	OpenLibrary
		move.l	d0,DosBase

		CLEARA	a1
		CALL	FindTask
;		move.l	d0,MessagePort+16	;task structore
;for IO

		CLEARA	a1
		move.l	d0,a2
		tst.l	pr_CLI(a2)
		bne.s	MakeMultitasking

		lea	pr_MSGPORT(a2),a0
		CALL	WaitPort
		lea	pr_MSGPORT(a2),a0
		CALL	GetMsg
		move.l	d0,a1

		move.l	sm_NUMARGS(a1),d0
		move.l	sm_ARGLIST(a1),a0

;	IFNE	WBMES
;		move.l	36(a0),a3
;		move.l	4(a3),Argss
;	ENDC
		moveq	#-1,d1
		addq.l	#8,SP	;.w ?

		movem.l	a1/a6,-(sp)

		jsr	StartSource

		movem.l	(sp)+,a1/a6

		move.l	a1,d1
		beq.s	StartUpQuit
		move.l	d0,d2
		CALL	ReplyMsg
		move.l	d2,d0
StartUpQuit:
		rts
MakeMultitasking:
		lea	ProcName(pc),A1
		move.l	a1,d1
		CLEARD	d2
		lea	StartUp(pc),a5
		move.l	-4(a5),d3
		move.l	d2,-4(a5)
		move.l	#4096,d4	;Stos ?
		move.l	DosBase,a6
		CALL	CreateProc
		movem.l	(sp)+,d0/a0

		CLEARD	D1
		CLEARD	D0
		rts

ProcName:
	dc.b	'tAnKs '
	VERSION
	dc.b	0
;tu wrzuciê twój program...

	ENDC


*******************************************************************************
	SECTION		"Tanks",CODE
*******************************************************************************
StartSource:
	move.l	a7,Stock	;save a7 if an error

	OPENLIBRARY	Gfx

	OPENLIBRARY	Dos

	OPENLIBRARY	Intui

	OPENLIBRARY	ReqTools

	lea	ScreenATR,a0
	move.l	IntuiBase,a6
	CALL	OpenScreen
	move.l	d0,ScreenBase
	beq.w	Cant_Open_Screen

	lea	NewWindowStructure1,a0
	CALL	OpenWindow
	move.l	d0,WindowBase
	beq.w	Cant_Open_Window
	move.l	d0,RTWin+4	;for req tools
	move.l	d0,RTWin2+4	;for req tools

	move.l	d0,a0
	move.l	wd_UserPort(a0),UserPort ;userport MsgPort

	lea	MenuList1,a1
	CALL	SetMenuStrip

_LoadRGB4	EQU	-$C0
sc_ViewPort	EQU	$2C

	move.l	ScreenBase,a0
	LEA	sc_ViewPort(A0),A0

	moveq	#8,d0
	LEA	Colors,A1
	MOVEA.L	GfxBase(PC),A6
	JSR	_LoadRGB4(A6)

STOP:
	move.l	WindowBase(pc),a2
;	move.l	52(a1),a2	;ActiveWindow

	move.l	50(a2),a2	;rastport
	move.l	4(a2),a2	;bitmap
	lea	8(a2),a2	;1bpl
	lea	BPL1,a0
	move.l	(a2)+,(a0)+	;1bpl
	move.l	(a2)+,(a0)+	;2
	move.l	(a2)+,(a0)+	;3
	move.l	(a2)+,(a0)+	;4
	move.l	(a2)+,(a0)+	;5


	move.l	WindowBase(pc),a1
	move.l	50(a1),a1	;rastport

	move.l	a1,-(sp)
	move.l	GfxBase,a6
	moveq	#0,d0
	CALL	SetBPen	;color tîa

	move.l	(sp)+,a1
	moveq	#1,d0
	CALL	SetAPen	;color napisu

		REM

		move.l	WindowBase(pc),a0
		moveq	#4,d0		;col1
		moveq	#7,d1
		move.w	#EKRSIZE*8-32,d2	;x0
		move.w	#12+12-1,d3	;y0
		moveq	#32,d4		;y1
		move.w	#13*16+1,d5	;dy

		bsr	ShadowBox

		ENDREM


	CLEARA	a1
	CALLEXEC FindTask
	move.l	d0,Task_ptr
	move.l	d0,a1
	move.l	pr_WindowPtr(a1),OLDWPTR	;save old..
	move.l	WindowBase(pc),pr_WindowPtr(a1)	;Window_ptr

	moveq	#-1,d0	;New task priority
	CALL	SetTaskPri	;exec

;for ReqToolsLoad
	MOVEL	ReqTools

	moveq	#RT_REQINFO,d0
	CLEARA	a0
	CALL	rtAllocRequestA
	move.l	d0,reqinfo
	beq.s	nomem

	moveq	#RT_FILEREQ,d0
	CLEARA	a0
	CALL	rtAllocRequestA
	move.l	d0,filereq ;struktóra ?dira? zaallokowana przez req tools
	beq.s	nomem

;CHANGE DIR
	move.l	d0,a1		;file req
	lea	StartTags(pc),a0
	CALL	rtChangeReqAttrA	;dziaîa

	bsr	RysujGorki

	bra	MainLoop

nomem
;jeûeli jest BARDZO maîo pamiëci..

	OKREQUEST	NoMemoryTXT

	bra.w	No_Mem_For_Load

ShowTitle:
	sub.l	a1,a1		;okno bez nazwy...
;	lea	AboutTXT,a1
	move.l	WindowBase(pc),a0
	MOVEL	Intui
	jmp	-276(a6)		;setwindowtitles

*******************************************************************************

				MainLoop:

*******************************************************************************

	lea	ReqTXT(pc),a2
	bsr	ShowTitle

	move.l	UserPort(pc),a0
	CALLEXEC WaitPort

	move.l	UserPort(pc),a0
	CALL	GetMsg
	tst.l	d0
	beq	MainLoop

Message:
		move.l	d0,a1
		move.l	im_Class(a1),d4
		move.l	im_IAddress(a1),d5
		move.w	im_Code(a1),d6
		move.w	im_MouseX(a1),PosX
		move.w	im_MouseY(a1),PosY
;		move.w	im_Qualifier(a1),Qualifier


		CALL	ReplyMsg

		cmp.l	#IDCMP_MOUSEBUTTONS,d4
		beq	SetPoint

		cmp.l	#IDCMP_MENUPICK,d4
		beq.w	MenuTest

		cmp.l	#IDCMP_VANILLAKEY,d4
		beq.s	letter

;		cmp.l	#IDCMP_RAWKEY,d4
;		beq.s	cursormove

;		cmp.l	#IDCMP_MOUSEMOVE,d4
;		beq.w	TestSetPuzzle
;		bra.w	TestSetPuzzle


		cmp.l	#IDCMP_GADGETDOWN,d4
		beq.w	GadgetTest

		cmp.l	#IDCMP_GADGETUP,d4
		beq.w	GadgetTest

		bra.w	MainLoop

letter:
		cmp.b	#'o',d6
		beq.s	SilaMinus
		cmp.b	#'p',d6
		beq.w	SilaPlus
		cmp.b	#'i',d6
		beq.w	Buum

		cmp.b	#'Q',d6
		beq.w	ChQuit

		cmp.b	#'a',d6
		beq.w	KatStrzaluMinus
		cmp.b	#'q',d6
		beq.w	KatStrzaluPlus

		cmp.b	#'w',d6
		beq.w	GravMinus
		cmp.b	#'s',d6
		beq.w	GravPlus

		cmp.b	#'e',d6
		beq.w	WiatrMinus
		cmp.b	#'d',d6
		beq.w	WiatrPlus

		cmp.b	#'c',d6
		beq.s	.clear

		bra	MainLoop
.c
.clear
		move.l	BPL1(pc),a0
		move.l	#256*80/4-1,d1
		moveq	#0,d0

.1		move.l	d0,(a0)+
		dbf	d1,.1
		
		bra	MainLoop
;;

Dokl	equ	1
SilaMinus:
		sub.w	#1<<Dokl,SilaX
		bcc.s	PokarzDzialko
		bra.w	KatPlus
PokarzDzialko:
		moveq	#0,d0
		move.w	SilaX(pc),d0
		lea	L9999(pc),a1
		lea	SilaXTXT2(pc),a0
		bsr	Przelicz_Dzies
		lea	SilaXTXT,a4
		moveq	#0,d0
		move.w	#228,d1
		bsr	Print
		bra	MainLoop
SilaPlus:
		add.w	#1<<Dokl,SilaX
		cmp.w	#400<<Dokl,SilaX
		bne.s	PokarzDzialko
		bra.w	SilaMinus


KatStrzaluMinus:
		subq.w	#1,KatStrzalu
		bpl.s	PokarzSileY
		bra.w	KatStrzaluPlus
PokarzSileY:
		moveq	#0,d0
		move.w	KatStrzalu(pc),d0
		lea	L999(pc),a1
		lea	KatStrzaluTXT2(pc),a0
		bsr	Przelicz_Dzies
		lea	KatStrzaluTXT(pc),a4
		moveq	#0,d0
		move.w	#238,d1
		bsr	Print
;Dziaîko!
		moveq	#0,d0
		move.w	KatStrzalu(pc),d0

		lea	Sin(pc),a0
		add.w	d0,d0
		move.w	(a0,d0.w),d0
		muls.w	#64,d0
		lsr.l	#7,d0
;		lsr.l	#2,d0
		move.l	d0,d1

		moveq	#0,d2
		moveq	#64,d2		;max dîugoôê dziaîka
		sub.l	d1,d2


;	d1-x1
;	d2-y1
;	d3-x2
;	d4-y2
StartY:	equ	256-16
		move.l	d1,d3
		move.l	#StartY,d4
		sub.l	d2,d4	;edn y
		moveq	#0,d1	;startx
		move.l	#StartY,d2	;starty
;		add.l	d3,d3
		add.l	d1,d3	;endx

		bsr	DrawLine


		bra	MainLoop
KatStrzaluPlus:
		addq.w	#1,KatStrzalu
		cmp.w	#90,KatStrzalu
		bne.s	PokarzSileY
		bra.w	KatStrzaluMinus
;---------------------------Grawitacja
GravMinus:
		sub.w	#1<<Dokl,Grawitacja
		bra.w	PokarzGrav
;		bra.w	GravPlus
PokarzGrav:
		moveq	#0,d0
		move.w	Grawitacja(pc),d0
		not.w	d0
		lea	L9999(pc),a1
		lea	GrawitacjaTXT2(pc),a0
		bsr	Przelicz_Dzies
		lea	GrawitacjaTXT,a4
		moveq	#100,d0
		move.w	#228,d1
		bsr	Print
		bra	MainLoop
GravPlus:
		add.w	#1<<Dokl,Grawitacja
;		cmp.w	#100<<Dokl,Grawitacja
		bra.s	PokarzGrav
;		bra.w	GravMinus
;---------------------------Grawitacja
TRACE=1
;---------------------------Wiatr
WiatrMinus:
		sub.w	#1,Wiatr
		cmp.w	#-11,Wiatr
		bne.s	PokarzWiatr
		bra.w	WiatrPlus
PokarzWiatr:
		moveq	#0,d0
		move.w	Wiatr(pc),d0
		not.w	d0
		lea	L9999(pc),a1
		lea	WiatrTXT2(pc),a0
		bsr	Przelicz_Dzies
		lea	WiatrTXT,a4
		moveq	#100,d0
		move.w	#238,d1
		bsr	Print
		bra	MainLoop
WiatrPlus:
		add.w	#1,Wiatr
		cmp.w	#10,Wiatr
		bne.s	PokarzWiatr
		bra.w	WiatrMinus
;---------------------------Wiatr



KatMinus:
		subq.b	#1,KatDzialka
		bcc.w	PokarzDzialko
		bra.s	KatPlus
;PokarzDzialko:
		moveq	#0,d0
		move.b	KatDzialka(pc),d0
		lea	L999(pc),a1
		lea	DzialkoTXT(pc),a0
		bsr	Przelicz_Dzies
		lea	DzialkoTXT,a4
		moveq	#10,d0
		move.w	#228,d1
		bsr	Print
		bra	MainLoop
KatPlus:
		addq.b	#1,KatDzialka
		cmp.b	#181,KatDzialka
		bne.w	PokarzDzialko
		bra.s	KatMinus



Buum:		;to ma byê strzaî....

		moveq	#0,d0
		move.w	KatStrzalu(pc),d0

		lea	Sin,a0
		add.w	d0,d0
		move.w	(a0,d0.w),d0
		mulu.w	SilaX(pc),d0
		lsr.l	#7,d0
		move.l	d0,d1

		moveq	#0,d2
		move.w	SilaX(pc),d2
		sub.l	d1,d2

		move.w	d0,SilaXRun
		move.w	d2,SilaYRun

;z tego policzyê sinusa... (siîe startowâ x , y

		move.l	#0<<Dokl,d0	;x	;posx
		move.l	#100<<Dokl,d1	;y	;posy

.loop
		PUSH	d0-a6
		lsr.w	#5,d0
		lsr.w	#5,d1
		move.l	d1,d2
		move.l	#256,d1
		sub.w	d2,d1

		bsr	Plot

		lea	$dff000,a5
		VERTICAL $100
		VERTICAL $101

		POP	d0-a6

		add.w	SilaXRun(pc),d0
		bmi.s	.uup
		add.w	SilaYRun(pc),d1
		bmi.s	.uup
		move.w	Wiatr(pc),d2
		add.w	d2,SilaXRun
		move.w	Grawitacja(pc),d2
		add.w	d2,SilaYRun

		bra.s	.loop
.uup

		bra	MainLoop

SilaX:		dc.w	100<<2
KatStrzalu:		dc.w	0
SilaXRun:	dc.w	40<<2
SilaYRun:	dc.w	40<<2
Grawitacja:	dc.w	-2<<2
Wiatr:		dc.w	-7
SetPoint:
;		bsr	Plot

		bra	MainLoop

Plot:
		move.l	BPL1(pc),a0
		mulu	#80,d1
		add.l	d1,a0
		move.l	d0,d1
		lsr.w	#3,d1
		add.l	d1,a0
		not.b	d0
		bset	d0,(a0)

	IFEQ	TRACE
		move.l	OldAdr(pc),d2
		beq.s	.1
		move.l	d2,a1
		move.b	OldBset(pc),d2
		bclr	d2,(a1)
.1

		move.l	a0,OldAdr
		move.b	d0,OldBset
	ENDC

		rts

GadgetTest:
		bra	MainLoop

Pallete:
	sub.l	a0,a0
	sub.l	a1,a1
	sub.l	a2,a2
	MOVEL	ReqTools
	CALL	rtPaletteRequestA
	bra	MainLoop

FreeMessage:
	move.l	UserPort(pc),a0
	CALLEXEC GetMsg

	tst.l	d0
	beq.s	nomes

	move.l	d0,a1
	CALL	ReplyMsg
	bra	FreeMessage

nomes	rts
*******************************************************************************

				ENDProg:

*******************************************************************************

		move.l	Task_ptr(pc),a1
		move.l	OLDWPTR(pc),pr_WindowPtr(a1)	;restore old pr_window

		MOVEL	ReqTools
		move.l	filereq(pc),a1
		jsr	_rtFreeRequest(a6)

		move.l	reqinfo(pc),a1
		CALL	rtFreeRequest

No_Mem_For_Load:
		MOVEL	Intui
		move.l	WindowBase(pc),a0
		CALL	CloseWindow

Cant_Open_Window:
		MOVEL	Intui
		move.l	ScreenBase(pc),a0
		CALL	CloseScreen

Cant_Open_Screen:

		CLOSELIBRARY	ReqTools
Cant_Find_ReqTools:

;		CLOSELIBRARY	Intui
Cant_Find_Intui:
;		CLOSELIBRARY	Dos

Cant_Find_Dos:

Cant_Find_Gfx:

		move.l	Stock(pc),a7
End:
		moveq	#0,d0
		rts


*******************************************************************************

				MenuTest:

*******************************************************************************

		lea	MenuList1(pc),a0
		move.l	d6,d0
		MOVEL	Intui
		jsr	-144(a6)	;item adr

		lea	MenuJumpList(pc),a0
.loop		move.l	(a0)+,d1
		cmp.l	#-1,d1
		beq.w	MainLoop
		cmp.l	d1,d0
		bne.s	.loop
		move.l	(a0)+,a0
		jmp	(a0)

MenuJumpList:
		dc.l	IQuit,ChQuit
		dc.l	-1

ChAbout:
	OKREQUEST	AboutText
	bra.w	MainLoop

DoReqOK:
	lea	OkTXT(pc),a2
DoReq:
;a1 text
;a2 response
	lea	AboutTags(pc),a0
DoTagsReq:
	move.l	reqinfo(pc),a3
	CLEARA	a4
;	lea	StringTable(pc),a4
	MOVEL	ReqTools
	JUMP	rtEZRequestA

ChQuit:
	REQUEST	QuitText,TakNieTXT

	cmp.w	#1,d0
	beq.w	ENDProg

	bra.w	MainLoop


RectEmpty:		movem.l d0-d7/a0-a6,-(sp)
			move.l	GfxBase(pc),a6
			move.l	d0,d4
			move.l	d1,d5
			move.l	50(a0),a1
			move.l	a1,a5
			moveq	#0,d0
			CALL	SetAPen
			move.l	a5,a1
			move.l	d4,d0
			move.l	d5,d1
			CALL	RectFill
			movem.l (sp)+,d0-d7/a0-a6
			rts


Print:
;Print window text

	moveq	#0,d2
	move.l	a4,a1

	bra.s	.2
.1	addq.w	#1,d2
.2	tst.b	(a1)+	;dlugosc tekstu..>d2
	bne.s	.1

	moveq	#1,d3	;col1
	moveq	#0,d4	;col0

	move.l	WindowBase(pc),a1
	move.l	50(a1),a1	;rastport


*************************************************************************
*								*
*               PRINT FAST v1.0 © 1993 Piotr Rzepka			*
*								*
*************************************************************************
PrintFast:
	move.l	d2,d5			;d5-lenght
	move.l	a1,a5			;a5-rp

	addq.l	#2,d0
	addq.l	#1,d1
;d0x d1y
	MOVEL	Gfx
	CALL	Move

	move.l	a5,a1
	move.l	a4,a0	;text adr
	move.l	d5,d0
	CALL	Text

	rts
_Text		EQU	-60
_SetDrMd		EQU	-354
_Move		EQU	-240
_Draw		EQU	-246
_RectFill	EQU	-306
_SetAPen		EQU	-342
_SetBPen		EQU	-348

*************************************************************************
*									*
*                SHADOWBOX v3.0	(C) 1992,1993 Piotr Rzepka		*
*									*
*************************************************************************
ShadowBox:
**********************************************************************
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	d0,a4		;col1
	move.l	d1,a3		;col1 secondline
	move.l	d5,d7		;y1
	move.l	d4,d6		;x1
	move.l	d3,d5		;y0
	move.l	d2,d4		;x0
	add.l	d4,d6
	add.l	d5,d7

;			move.w	(a5)+,d1	;col1
;			move.w	(a5)+,d2	;x0
;			move.w	(a5)+,d3	;y0
;			move.w	(a5)+,d4	;x1
;			move.w	(a5)+,d5	;y1


	move.l	GfxBase,a6
	move.l	50(a0),a5		;Rastport

	move.l	a4,d0
	move.l	a5,a1
	CALL	SetAPen

	move.l	a5,a1
	move.l	d4,d0
	move.l	d5,d1
	CALL	Move

	move.l	a5,a1
	move.l	d6,d0
	move.l	d5,d1
	CALL	Draw

	move.l	a5,a1
	move.l	d4,d0
	move.l	d5,d1
	CALL	Move

	move.l	a5,a1
	move.l	d4,d0
	move.l	d7,d1
	CALL	Draw

	move.l	a5,a1
	move.l	d4,d0
	addq.l	#1,d0
	move.l	d5,d1
	addq.l	#1,d1
	CALL	Move

	move.l	a5,a1
	move.l	d4,d0
	addq.l	#1,d0
	move.l	d7,d1
	subq.l	#1,d1
	CALL	Draw

	move.l	a3,d0
	move.l	a5,a1
	CALL	SetAPen

	move.l	a5,a1
	move.l	d6,d0
	move.l	d5,d1
	CALL	Move

	move.l	a5,a1
	move.l	d6,d0
	move.l	d7,d1
	CALL	Draw

	move.l	a5,a1
	move.l	d4,d0
	addq.l	#1,d0
	move.l	d7,d1
	CALL	Move

	move.l	a5,a1
	move.l	d6,d0
	move.l	d7,d1
	CALL	Draw

	move.l	a5,a1
	move.l	d6,d0
	subq.l	#1,d0
	move.l	d5,d1
	addq.l	#1,d1
	CALL	Move

	move.l	a5,a1
	move.l	d6,d0
	subq.l	#1,d0
	move.l	d7,d1
	subq.l	#1,d1
	CALL	Draw

	movem.l	(sp)+,d0-d7/a0-a6

	rts

*************************************************************************
;Draw Line by Piotr Rzepka
;	d0-kolor
;	a0-window
;	d1-x1
;	d2-y1
;	d3-x2
;	d4-y2
DrawLine:
		moveq	#2,d0	;kolor
		move.l	WindowBase(pc),a0
		move.l	d4,-(sp)
		move.l	d1,d4
		move.l	d2,d5
		move.l	d3,d6
		move.l	GfxBase(pc),a6
		move.l	50(a0),a5		;Rastport
		move.w	#3,36(a5)	;??
		move.w	#3,38(a5)	;??

		move.l	a5,a1
		CALL	SetAPen

		move.l	a5,a1
		move.l	d4,d0
		move.l	d5,d1
		CALL	Move

		move.l	a5,a1
		move.l	d6,d0
		move.l	(sp)+,d1
		JUMP	Draw


*******************************************
Przelicz_Dzies:
;wescie:
;	a0 gdze wrzucac liczbe w asci
;       a1 od jakij liczby zaczynaê
;	d0 liczba
;	d1-d3 nic uûywany
;used registers d0-d2 a0-a1
;by R.The.K./RDST

;	lea	dzes,a1
	tst.w	d0
	bpl.s	.1
	not.w	d0
	move.b	#'-',-1(a0)
	bra.s	.2
.1
	move.b	#' ',-1(a0)

.2
	moveq	#0,d3
	
L_00	moveq	#0,d2
	move.l	(a1)+,d1
	beq.s	nomore_tears
	cmp.l	#1,d1
	bne.s	.1
	moveq	#1,d3
.1
	cmp.l	d1,d0
	blt.s	l_02		;Gdy mniejszy
	sub.l	d1,d0
	addq.b	#1,d2
	bra.s	.1
l_02
	tst.b	d2
	beq.s	.1
	moveq	#1,d3
.1
	tst.b	d3
	beq.s	.pusc
	add.b	#'0',d2
	move.b	d2,(a0)+	;Wrzutka liczby
	bra.s	L_00
.pusc
	move.b	#' ',(a0)+
	bra.s	L_00

nomore_tears
	rts

dzes	;tabela dziesiatek (wykopanie divsa
	dc.l	100000
L99999:	dc.l	10000
L9999:	dc.l	1000
L999:	dc.l	100
L99:	dc.l	10,1,0,0


RysujGorki:
		move.l	BPL1(pc),a0
		

		rts


*******************************************************************************
*				DANE:
*******************************************************************************
Colors:
	dc.w	$0999,$0000,$0FFF,$036A,$0777,$0AAA,$0A97,$0FA9

StartTags:	dc.l	RTFI_DIR,Directory
		dc.l	TAG_END


AboutTags:	dc.l	RT_Underscore,'_'
RTWin2:		dc.l	RT_Window,0
		dc.l	RT_ReqPos,REQPOS_CENTERSCR
		dc.l	RT_LockWindow,1
		dc.l	RT_WaitPointer,1
		dc.l	RTEZ_ReqTitle,ReqTXT
		DC.L	RTEZ_Flags,EZREQF_CENTERTEXT
		dc.l	TAG_END
LoadTags:
RTWin:		dc.l	RT_Window,0
		dc.l	RTFI_Flags,FREQF_PATGAD
		dc.l	RT_LockWindow,1
		dc.l	RT_WaitPointer,1
		dc.l	TAG_END

UserPort:	dc.l	0
WindowBase:	dc.l	0
Stock:		dc.l	0	;dla a7
Task_ptr:	dc.l	0
DosBase:	dc.l	0
GfxBase:	dc.l	0
IntuiBase:	dc.l	0
ReqToolsBase:	dc.l	0
WindowToOpenBase:	dc.l	0
reqinfo:	ds.l	1	;reqtools requesters
filereq:	ds.l	1	;reqtools dir
OLDWPTR:	dc.l	0	;pr_WindowPtr
BPL1:		blk.l	8,0
PosX:		dc.w	0	;poz myszty na ekranie!
PosY:		dc.w	0

;>----do gry
OldAdr:		dc.l	0	;adr setu
OldBset		dc.b	0	;xxx
KatDzialka:	dc.b	0	;pod jakim kâtem strzelaê

;>----do gry


*******************************************************************************
*				TEXTY:
*******************************************************************************
DosName:	dc.b	'dos.library',0
GfxName:	dc.b	'graphics.library',0
IntuiName:	dc.b	'intuition.library',0
ReqToolsName:	dc.b	'reqtools.library',0
FontName:	dc.b	'topaz.font',0

Directory:
	dc.b	'dh0:programs/gfx/pictures/iff/',0
;	dc.b	'dh0:programs/gfx/pictures/CindyCrawford/',0

		dc.b	'$VER: '
ReqTXT:
ScreenName:	dc.b	'Tanks '
		VERSION
		dc.b	0


DzialkoTXT:	dc.b	'xxx',0
SilaXTXT:	dc.b	'Siîa X '
SilaXTXT2:	dc.b	'xxxx',0
KatStrzaluTXT:	dc.b	'Kât: '
KatStrzaluTXT2:	dc.b	'xxx',0
GrawitacjaTXT:	dc.b	'Grawitacja '
GrawitacjaTXT2:	dc.b	'xxxx',0
WiatrTXT:	dc.b	'Wiatr '
WiatrTXT2:	dc.b	'xxxx',0

;menu
ProjectTXT:	dc.b	'Project',0
InfoMTXT:	dc.b	'Info',0
MoreTXT:	dc.b	'Room',0
ClearTXT:	dc.b	'Clear',0
AboutTXT:	dc.b	'Autor',0
LoadTXT:	dc.b	'Load',0
SaveTXT:	dc.b	'Save',0
SaveASTXT:	dc.b	'Save As',0
IQuitT:		dc.b	'Quit',0
IHelpT:		dc.b	'Help',0


LoadTitle:	dc.b	"Choose file",0
AboutText:	dc.b	'Rafal Konkolewski',$a
		dc.b	'email:rkon1ar9@sunrise.pg.gda.pl',$a,$a
		dc.b	'ul.Nauczycielska 4/23',$a
		dc.b	'81-614 Gdynia',$a
		dc.b	'tel.(0-58) 24-09-59',$a
		dc.b	'Req Tools Library',$a
		dc.b	'Copyright by',$a
		dc.b	'Nico Francias',0
OkTXT:		dc.b	' _OK ',0
QuitText:	dc.b	'Quit',$a
		dc.b	'Are You sure ?',0
TakNieTXT:	dc.b	' _Yes | _No ',0
NoMemoryTXT:	dc.b	"Out of memory",0
BladTXT:	dc.b	"Read error",0
RawCode:	dc.b	'Raw Code %ld',0

;ErrorMessages
OutOfMemory_T:	dc.b	'Out Of Memory',0

		even
*******************************************************************************
ScreenATR:
*******************************************************************************
		dc.w	0	;lewy róg
		dc.w	0	;górny róg
		dc.w	640	;szerokoôê
		dc.w	256	;wyskoôê
		dc.w	3	;iloôê bitplanów
		dc.b	0	;detail pen
		dc.b	1	;block pen
		dc.w	$8000	;V_Hires
		dc.w	$10+$1000	;type
		dc.l	Font_Attr	;fonts
		dc.l	ScreenName ;nazwa okna
		dc.l	0	;gadgets
		dc.l	0	;bitmap
		dc.l	Screen_Tags

Screen_Tags:	dc.l	$80000000+58	;EITEM SA_Pens
		dc.l	dri_Pens
		dc.l	0		;tagEnd

dri_Pens:
		dc.w	0		;DetailPen
		dc.w	0		;BlockPen
		dc.w	1		;TextPen	;okno
		dc.w	2		;ShinePen	;okno
		dc.w	1		;ShadowPen	;okno
		dc.w	4		;FillPen
		dc.w	1		;FillTextPen
		dc.w	0		;BackGroundPen
		dc.w	2		;HiglightTextPen
		dc.l	-1		;EndOfTab

Font_Attr:
		dc.l	FontName
		dc.w	8	;size
		dc.b	0,0
		dc.w	8	;size

*******************************************************************************
NewWindowStructure1:
*******************************************************************************
		dc.w	0,10	;window XY origin relative to TopLeft of screen
		dc.w	640
		dc.w	256-10	;window width and height
		dc.b	2,1	;detail and block pens

WFLG_REPORTMOUSE	EQU $0200	; set this to hear every mouse move
WFLG_GIMMEZEROZERO	EQU $0400	; make extra border stuff 

 dc.l IDCMP_MENUPICK+IDCMP_GADGETUP+IDCMP_VANILLAKEY+IDCMP_MOUSEBUTTONS+IDCMP_RAWKEY+IDCMP_MOUSEMOVE
 dc.l WFLG_BORDERLESS!WFLG_BACKDROP!WFLG_ACTIVATE!WFLG_NOCAREREFRESH+WFLG_REPORTMOUSE+WFLG_GIMMEZEROZERO

		dc.l	GTest	;GUruchom	;first gadget in gadget list
		dc.l	0	;custom CHECKMARK imagery
		dc.l	0	;window title
ScreenBase:
		dc.l	0	;custom screen pointer
		dc.l	0	;custom bitmap
		dc.w	320,256-10	;minimum width and height
		dc.w	320,256-10	;maximum width and height
		dc.w	CUSTOMSCREEN	;destination screen type

GTest:		DC.L	0
		DC.W	100,100	;xy
		DC.W	95,11	;size
		DC.W	0
		DC.W	GACT_RELVERIFY
		DC.W	GTYP_BOOLGADGET
		DC.L	Border2
		DC.L	0
		DC.L	GTeTxt
		DC.L	0
		DC.L	0
		DC.W	0
		DC.L	0
GTeTxt:
		dc.b	1,0,RP_JAM2,0
		dc.w	29,2
		dc.l	0
		dc.l	.t
		dc.l	0
.t:		dc.b	'Test',0

		even
Border2:dc.w	0,0	;XY origin relative to container TopLeft
	dc.b	2,3,RP_JAM1	;front pen, back pen and drawmode
	dc.b	3	;number of XY vectors
	dc.l	BV2
	dc.l	Border2a
Border2a:dc.w	0,0
	dc.b	1,3,RP_JAM1
	dc.b	3
	dc.l	BV2a
	dc.l	0

CommSize:	equ	96
BV2:	dc.w	0,10
	dc.w	0,0
	dc.w	CommSize-2,0
BV2a:	dc.w	1,10
	dc.w	CommSize-2,10
	dc.w	CommSize-2,1

*******************************************************************************

*				     MENU:

*******************************************************************************
MenuList1:
*******************************************************************************
	dc.l	0	;next
	dc.w	0,0
	dc.w	90,0
	dc.w	MENUENABLED
	dc.l	ProjectTXT
	dc.l	IHelp
	dc.w	0,0,0,0

IHelp:	dc.l	IAbout
	dc.w	0,1
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'H'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	IHelpT
	dc.l	0

IAbout:
	dc.l	ILoad
	dc.w	0,18
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'A'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	AboutTXT
	dc.l	0

ILoad:
	dc.l	ISave
	dc.w	0,35
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'L'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	LoadTXT
	dc.l	0


ISave:
	dc.l	ISaveAS
	dc.w	0,52
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'S'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	SaveTXT
	dc.l	0
ISaveAS:
	dc.l	IInfo
	dc.w	0,72
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'W'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	SaveASTXT
	dc.l	0

IInfo:
	dc.l	IClearRoom
	dc.w	0,92
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'I'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	InfoMTXT
	dc.l	0

IClearRoom:
	dc.l	IQuit
	dc.w	0,112
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	.text
	dc.l	0
	dc.b	'C'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
.text
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	ClearTXT
	dc.l	0

IQuit:
	dc.l	0
	dc.w	0,132
	dc.w	140,8
	dc.w	ITEMENABLED+ITEMTEXT+HIGHCOMP+COMMSEQ
	dc.l	0
	dc.l	IQuitText
	dc.l	0
	dc.b	'Q'
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
IQuitText:
	dc.b	3,1,RP_COMPLEMENT,0
	dc.w	0,0
	dc.l	0
	dc.l	IQuitT
	dc.l	0


Sin:
	incdir	dh1:sources/!Nowe/
	include	'TanksWave256.720.180+'

	DC.W	$0004,$000D,$0016,$001F,$0028,$0030,$0039,$0042
	DC.W	$004A,$0053,$005B,$0064,$006C,$0074,$007C,$0083
	DC.W	$008B,$0092,$009A,$00A1,$00A7,$00AE,$00B5,$00BB
	DC.W	$00C1,$00C6,$00CC,$00D1,$00D6,$00DB,$00DF,$00E4
	DC.W	$00E8,$00EB,$00EE,$00F2,$00F4,$00F7,$00F9,$00FB
	DC.W	$00FC,$00FE,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF
	DC.W	$00FE,$00FC,$00FB,$00F9,$00F7,$00F4,$00F2,$00EE
	DC.W	$00EB,$00E8,$00E4,$00DF,$00DB,$00D6,$00D1,$00CC
	DC.W	$00C6,$00C1,$00BB,$00B5,$00AE,$00A7,$00A1,$009A
	DC.W	$0092,$008B,$0083,$007C,$0074,$006C,$0064,$005B
	DC.W	$0053,$004A,$0042,$0039,$0030,$0028,$001F,$0016
	DC.W	$000D,$0004,$FFFC,$FFF3,$FFEA,$FFE1,$FFD8,$FFD0
	DC.W	$FFC7,$FFBE,$FFB6,$FFAD,$FFA5,$FF9C,$FF94,$FF8C
	DC.W	$FF84,$FF7D,$FF75,$FF6E,$FF66,$FF5F,$FF59,$FF52
	DC.W	$FF4B,$FF45,$FF3F,$FF3A,$FF34,$FF2F,$FF2A,$FF25
	DC.W	$FF21,$FF1C,$FF18,$FF15,$FF12,$FF0E,$FF0C,$FF09
	DC.W	$FF07,$FF05,$FF04,$FF02,$FF01,$FF01,$FF01,$FF01
	DC.W	$FF01,$FF01,$FF02,$FF04,$FF05,$FF07,$FF09,$FF0C
	DC.W	$FF0E,$FF12,$FF15,$FF18,$FF1C,$FF21,$FF25,$FF2A
	DC.W	$FF2F,$FF34,$FF3A,$FF3F,$FF45,$FF4B,$FF52,$FF59
	DC.W	$FF5F,$FF66,$FF6E,$FF75,$FF7D,$FF84,$FF8C,$FF94
	DC.W	$FF9C,$FFA5,$FFAD,$FFB6,$FFBE,$FFC7,$FFD0,$FFD8
	DC.W	$FFE1,$FFEA,$FFF3,$FFFC
	DC.W	$0004,$000D,$0016,$001F,$0028,$0030,$0039,$0042
	DC.W	$004A,$0053,$005B,$0064,$006C,$0074,$007C,$0083
	DC.W	$008B,$0092,$009A,$00A1,$00A7,$00AE,$00B5,$00BB
	DC.W	$00C1,$00C6,$00CC,$00D1,$00D6,$00DB,$00DF,$00E4
	DC.W	$00E8,$00EB,$00EE,$00F2,$00F4,$00F7,$00F9,$00FB
	DC.W	$00FC,$00FE,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF
	DC.W	$00FE,$00FC,$00FB,$00F9,$00F7,$00F4,$00F2,$00EE
	DC.W	$00EB,$00E8,$00E4,$00DF,$00DB,$00D6,$00D1,$00CC
	DC.W	$00C6,$00C1,$00BB,$00B5,$00AE,$00A7,$00A1,$009A
	DC.W	$0092,$008B,$0083,$007C,$0074,$006C,$0064,$005B
	DC.W	$0053,$004A,$0042,$0039,$0030,$0028,$001F,$0016
	DC.W	$000D,$0004,$FFFC,$FFF3,$FFEA,$FFE1,$FFD8,$FFD0
	DC.W	$FFC7,$FFBE,$FFB6,$FFAD,$FFA5,$FF9C,$FF94,$FF8C
	DC.W	$FF84,$FF7D,$FF75,$FF6E,$FF66,$FF5F,$FF59,$FF52
	DC.W	$FF4B,$FF45,$FF3F,$FF3A,$FF34,$FF2F,$FF2A,$FF25
	DC.W	$FF21,$FF1C,$FF18,$FF15,$FF12,$FF0E,$FF0C,$FF09
	DC.W	$FF07,$FF05,$FF04,$FF02,$FF01,$FF01,$FF01,$FF01
	DC.W	$FF01,$FF01,$FF02,$FF04,$FF05,$FF07,$FF09,$FF0C
	DC.W	$FF0E,$FF12,$FF15,$FF18,$FF1C,$FF21,$FF25,$FF2A
	DC.W	$FF2F,$FF34,$FF3A,$FF3F,$FF45,$FF4B,$FF52,$FF59
	DC.W	$FF5F,$FF66,$FF6E,$FF75,$FF7D,$FF84,$FF8C,$FF94
	DC.W	$FF9C,$FFA5,$FFAD,$FFB6,$FFBE,$FFC7,$FFD0,$FFD8
	DC.W	$FFE1,$FFEA,$FFF3,$FFFC


			SECTION	'Text',BSS
StringBuffer:	ds.b	40
filename:	ds.b	50	;miejsce na nazwe pliku [reqtools
buforname:	ds.b	50	;nazwa aktualnie edytow komnaty...
directorybufor:	ds.b	150	;dir aktualnie edytow komnaty...


			;DOS INCLUDE
_CurrentDir:	equ	-126
_Open:	equ	-30
_Close:	equ	-36
_Read:	equ	-42
_Write:	equ	-48
_Lock:	equ	-84
_UnLock:	equ	-90
_Examine:	equ	-102
OFFSET_END	equ	1
OFFSET_BEGINNING	equ	-1
_Seek	EQU	-66
_Delay	EQU	-198

			;EXEC ICLUDE
_GetMsg	EQU	-372
_ReplyMsg	EQU	-378
_WaitPort	EQU	-384
_AllocMem	EQU	-198
_FreeMem	EQU	-210
_OpenLibrary	EQU	-552
_CloseLibrary	EQU	-414
_Disable	EQU	-120
_Enable	EQU	-126
_Forbid	EQU	-132
_Permit	EQU	-138
_FindTask	EQU	-294
_SetTaskPri	EQU	-300
MEMF_PUBLIC	=1
MEMF_CHIP	=2
MEMF_FAST	=4
MEMF_CLEAR	=$10000
MEMF_LARGEST	=$20000
_AvailMem	EQU	-216


pr_WindowPtr:	equ	184

			;INTUITION

_CloseScreen		EQU	-66
_CloseWindow		EQU	-72
_DisplayBeep		EQU	-96
_ModifyProp		EQU	-156
_OpenScreen		EQU	-198
_OpenWindow		EQU	-204
_RefreshGadgets	equ	-222
_SetMenuStrip	equ	-264
_RefreshGList	EQU	-432
_RefreshWindowFrame	equ	-456
RP_JAM1		equ	0
RP_JAM2		equ	1
RP_COMPLEMENT	equ	2
MENUENABLED	equ	1
ITEMTEXT	equ	2
COMMSEQ		equ	4
ITEMENABLED	equ	$10
HIGHCOMP	equ	$40
MENUNULL	equ	$ffff

CUSTOMSCREEN		EQU				15
V_HIRES			EQU				$8000
WFLG_BACKDROP		EQU				$0100
WFLG_BORDERLESS		EQU				$0800
WFLG_ACTIVATE		EQU				$1000
WFLG_RMBTRAP		EQU				$00010000
WFLG_NOCAREREFRESH	EQU				$00020000
WFLG_NEWLOOKMENUS	EQU				$00200000
GFLG_GADGHCOMP		EQU				$0000
GFLG_GADGHIMAGE		EQU				$0002
GFLG_GADGIMAGE		EQU				$0004
GACT_GADGIMMEDIATE	equ	2
GACT_RELVERIFY		EQU				$0001
GACT_TOPBORDER		EQU				$40
GACT_IMMEDIATE		EQU				$0002
GACT_FOLLOWMOUSE	EQU				$0008
GACT_TOGGLESELECT	equ	$100
GACT_STRINGRIGHT	equ	$400
GACT_LONGINT		equ	$800
GTYP_BOOLGADGET		EQU	1
GTYP_STRGADGET		equ	4
IDCMP_MOUSEBUTTONS	EQU				$00000008
IDCMP_MOUSEMOVE		EQU				$00000010
IDCMP_GADGETDOWN	EQU				$00000020
IDCMP_GADGETUP		EQU				$00000040
IDCMP_REQSET		EQU				$00000080
IDCMP_MENUPICK		EQU				$00000100
IDCMP_RAWKEY		EQU				$00000400
IDCMP_REQVERIFY		EQU				$00000800
IDCMP_REQCLEAR		EQU				$00001000
IDCMP_MENUVERIFY	EQU				$00002000
IDCMP_ACTIVEWINDOW	EQU				$00040000
IDCMP_INACTIVEWINDOW	EQU				$00080000
IDCMP_DELTAMOVE		EQU				$00100000
IDCMP_VANILLAKEY	EQU				$00200000
IDCMP_INTUITICKS	EQU				$00400000

SELECTUP	equ	$e8
SELECTDOWN	equ	$68
wd_RPort		EQU				$32
wd_UserPort		EQU				$56
im_Class		EQU				$14
im_IAddress		EQU				$1C
im_Code			EQU				$18
wd_LeftEdge		EQU				$04
wd_TopEdge		EQU				$06
wd_WScreen		EQU				$2E
ib_FirstScreen		EQU				$3C
sc_Width		EQU				$C
sc_NextScreen		EQU				$0
im_Qualifier	equ	$1a
im_MouseX	equ	32
im_MouseY	equ	34


			;REQTOOLS

_rtAllocRequestA		EQU	-30
_rtFreeRequest		EQU	-36
_rtFreeReqBuffer		EQU	-42
_rtFileRequestA		EQU	-54
_rtEZRequestA		EQU	-66
_rtGetStringA		EQU	-72
_rtGetLongA		EQU	-78
_rtFontRequestA		EQU	-96
_rtPaletteRequestA	EQU	-102
_rtScreenToFrontSafely	EQU	-138
_rtSetReqPosition	EQU	-126
_rtLockWindow	equ	-156
_rtUnlockWindow	equ	-162
_rtChangeReqAttrA	EQU	-48
rtfi_Dir	equ	16


RT_FILEREQ		EQU	0
RT_REQINFO		EQU	1
RT_FONTREQ		EQU	2
CALL_HANDLER		EQU	$80000000
RT_TagBase		equ	$80000000
RT_Window		equ	(RT_TagBase+1)
RT_ReqPos		equ	(RT_TagBase+3)
RT_WaitPointer		equ	(RT_TagBase+10)
RT_Underscore		equ	(RT_TagBase+11)
RT_LockWindow		equ	(RT_TagBase+13)
RT_TextAttr		equ	(RT_TagBase+15)
RTEZ_ReqTitle		equ	(RT_TagBase+20)
RTEZ_Flags		equ	(RT_TagBase+22)
RTEZ_DefaultResponse	equ	(RT_TagBase+23)
RTGL_Min		equ	(RT_TagBase+30)
RTGL_Max		equ	(RT_TagBase+31)
RTGL_Width		equ	(RT_TagBase+32)
RTGL_ShowDefault	equ	(RT_TagBase+33)
RTGL_GadFmt 		equ	(RT_TagBase+34)
RTGL_GadFmtArgs		equ	(RT_TagBase+35)
RTGL_Invisible		equ	(RT_TagBase+36)
RTGL_BackFill		equ	(RT_TagBase+37)
RTGL_TextFmt		equ	(RT_TagBase+38)
RTGL_TextFmtArgs	equ	(RT_TagBase+39)
RTFI_DIR		equ	(RT_TagBase+50)
RTGL_CenterText		equ	(RT_TagBase+100)
RTGL_Flags		equ	RTEZ_Flags
RTGS_Width		equ	RTGL_Width
RTGS_AllowEmpty		equ	(RT_TagBase+80)
RTGS_GadFmt 		equ	RTGL_GadFmt
RTGS_GadFmtArgs		equ	RTGL_GadFmtArgs
RTGS_Invisible		equ	RTGL_Invisible
RTGS_BackFill		equ	RTGL_BackFill
RTGS_TextFmt		equ	RTGL_TextFmt
RTGS_TextFmtArgs	equ	RTGL_TextFmtArgs
RTGS_CenterText		equ	RTGL_CenterText
RTGS_Flags		equ	RTEZ_Flags
RTFI_Flags		equ	(RT_TagBase+40)
RTFI_Height		equ	(RT_TagBase+41)
RTFI_OkText		equ	(RT_TagBase+42)
RTPA_Color		equ	(RT_TagBase+70)
REQPOS_POINTER		EQU	0
REQPOS_CENTERWIN	EQU	1
REQPOS_CENTERSCR	EQU	2
REQPOS_TOPLEFTWIN	EQU	3
REQPOS_TOPLEFTSCR	EQU	4
REQ_CANCEL		EQU	0
REQ_OK			EQU	1
FREQF_MULTISELECT	EQU	$1
FREQF_SAVE		EQU	$2
FREQF_NOBUFFER		EQU	$4
FREQF_NOFILES		EQU	$8
FREQF_PATGAD		EQU	$10
FREQF_FIXEDWIDTH	EQU	$20
FREQF_COLORFONTS	EQU	$40
FREQF_CHANGEPALETTE	EQU	$80
FREQF_LEAVEPALETTE	EQU	$100
FREQF_SCALE		EQU	$200
FREQF_STYLE		EQU	$400
FREQF_DOWILDFUNC	EQU	$800
FREQF_SELECTDIRS	EQU	$1000
EZREQF_NORETURNKEY	EQU	$1
EZREQF_LAMIGAQUAL	EQU	$2
EZREQF_CENTERTEXT	EQU	$4
REQHOOK_WILDFILE	EQU	0
REQHOOK_WILDFONT	EQU	1
TAG_END			equ	0

			;PROCESS
pr_MSGPORT		EQU		$5C
sm_ARGLIST		EQU		$24
sm_NUMARGS		EQU		$1C
pr_CLI			equ		172
_CreateProc	EQU	-138

_OwnBlitter:	equ	-456 ;gfx
_DisOwnBlitter:equ	-462 ;gfx
_VBeamPos	equ	-384

SCREENQUIET:	equ	$100

