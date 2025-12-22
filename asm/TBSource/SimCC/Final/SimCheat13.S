***********************************************
*                                             *
*              (C)opyright 1991               *
*                                             *
*             by  Tomi Blinnikka              *
*                                             *
*             SimCity 1.1  Cheat              *
*                                             *
* Version 0.00a - 0.99a  18/4/1991            *
*                                             *
* BUGS: Didn't work through DOS               *
*                                             *
* Version 1.00  19/4/1991                     *
*                                             *
* BUGS: No WB Stuff + some font stuff         *
*                                             *
* Version 1.01  26-27/4/1991                  *
*                                             *
* BUGS: No font stuff + WB Stuff didn't work  *
*       from directories                      *
*                                             *
* Version 1.02  27-29/4/1991                  *
*                                             *
* BUGS: Doesn't work with CShell	      *
*                                             *
* Version 1.03  29/4/1991	              *
*                                             *
* BUGS: Unknown				      *
*                                             *
***********************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/reqbase.i"
	INCLUDE "workbench/startup.i"
	INCLUDE	"intuition.i"

	INCLUDE	"dos.xref"
	INCLUDE	"intuition.xref"
	INCLUDE	"exec.xref"

	INCLUDE	"FH1:Language/WF/SimCC/SimCC2.0.i"

		section	SimCityCheat,CODE

Start:		move.l	a0,SCCAddress		;Get SimCity filename
		move.l	d0,SCCLength		;Get length

		move.l	#0,a1
		lib	Exec,FindTask
		move.l	d0,SCCTask
		move.l	d0,a4

		move.l	pr_CLI(a4),d0
		bne	Start1
		jsr	WBStart

Start1:		openlib	Dos,ShutDown

		lib	Dos,Output
		move.l	d0,_stdout

;		move.l	SCCTask(pc),a4
		move.l	pr_CLI(a4),d0
		beq	WBInput

;CLI Inputs

		move.l	SCCAddress,a0
		move.l	SCCLength,d0
		clr.b	-1(a0,d0.l)		;add null to end of filename

		move.l	SCCAddress(pc),a0
		tst.b	(a0)
		bne	GotFileName
		jmp	StartMain

WBStart:	lea.l	pr_MsgPort(a4),a0
		lib	Exec,WaitPort
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,GetMsg
		move.l	d0,WBMsg
WBStart1:	rts

GotFileName:
		move.w	#1,Mode
		move.l	SCCAddress(pc),a0
		lea.l	FRPathName(pc),a1
		cmp.b	#"?",(a0)
		beq	CommandLineHelp
CopyFName:	move.b	(a0)+,(a1)+
		cmp.b	#$00,(a0)
		bne	CopyFName
		clr.b	(a1)

		move.l	SCCAddress(pc),a0
		lea.l	FRFile(pc),a1
CopyFName1:	move.b	(a0)+,(a1)+
		cmp.b	#$20,(a0)
		beq	CopyFName2
		cmp.b	#160,(a0)
		beq	CopyFName2
		cmp.b	#$00,(a0)
		bne	CopyFName1
CopyFName2:	clr.b	(a1)

		lea.l	FRFile(pc),a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,SCCFile
		bne	DOSCheat
		jsr	SCCNotOpen
		jmp	ShutDown
;WB Inputs

WBInput:

;Open NIL:

		lea.l	NILName(pc),a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
		beq	ShutDown
		move.l	NILFile(pc),_stdout
	
		move.l	#$00,d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock
		move.l	WBMsg(pc),a2
		move.l	sm_NumArgs(a2),ArgsLeft
		move.l	sm_ArgList(a2),ArgList

WBInputIn:	sub.l	#1,ArgsLeft
		add.l	#8,ArgList
		cmp.l	#$00,ArgsLeft
		beq	WBInputOut

WBInput1:	move.l	ArgList(pc),a0
		move.l	wa_Name(a0),d1
		move.l	d1,a1
		tst.b	(a1)
		bne	WBInput2
WBInput1.1:	move.l	ArgList(pc),a0
		move.l	wa_Lock(a0),d1
		beq	WBInputIn
		lib	Dos,CurrentDir
		move.l	#$00,FRDir
		jmp	WBInputIn

WBInput2:	move.l	d1,a0
		lea.l	FRFile(pc),a1
WBInput2.1:	move.b	(a0)+,(a1)+
		cmp.b	#$00,(a0)
		bne	WBInput2.1
		clr.b	(a1)
		jmp	WBInput1.1

WBInputOut:	move.l	FRDir(pc),a0
		lea.l	FRPathName(pc),a1
		cmp.b	#$00,(a0)
		beq	WBInputOut1.1
WBInputOut1:	move.b	(a0)+,(a1)+
		cmp.b	#$00,(a0)
		bne	WBInputOut1
WBInputOut1.1:	lea.l	FRFile(pc),a0
WBInputOut2:	move.b	(a0)+,(a1)+
		cmp.b	#$00,(a0)
		bne	WBInputOut2
		clr.b	(a1)

StartMain:	move.w	#0,Mode
		moveq.l	#2,d0
		openlib	Req,NoReq
		openlib	Intuition,NoInt
		openlib	Gfx,NoGfx

		move.l	#$31363737,AmountBuf
		move.l	#$37323135,AmountBuf+4
		move.l	#16777215,AmountInt

;test for 2.0

		move.l	_IntuitionBase(pc),a0
		move.w	$14(a0),d0
		cmp.w	#36,d0
		bcs	StartWin1

;under 2.0
		move.l	#$00,a0
		lib	Intuition,LockPubScreen
		move.l	d0,PubScreen
		beq	NoPub

;Get DragBar size

		move.w	#40,Win1YSize
		move.l	d0,a0
		move.b	$1e(a0),d0
		move.w	#$00,Win1ZoomY
		move.b	d0,Win1ZoomY+1
		add.b	d0,Gad1YPos+1

;use new OpenWindow (OpenWindowTagList)

		lea.l	NewWindow1(pc),a0
		lea.l	Win1TagList(pc),a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window1
		beq	NoWin1
		move.l	#$00,a0
		move.l	PubScreen(pc),a1
		lib	Intuition,UnlockPubScreen
		move.l	#$00,PubScreen
		jmp	GetRP1

;under 1.3

StartWin1:	add.w	#10,Gad1YPos
		lea.l	NewWindow1(pc),a0
		lib	Intuition,OpenWindow
		move.l	d0,Window1
		beq	NoWin1
GetRP1:		move.l	d0,a0
		move.l	$32(a0),RP1
		move.w	#$01,Gad1On

;Add Menus to Window1

		move.l	Window1(pc),a0
		lea.l	Menu1(pc),a1
		lib	Intuition,SetMenuStrip

;Add gadget

		lea.l	AmountGad1(pc),a1
		move.l	Window1(pc),a0
		move.l	#$00,d0
		lib	Intuition,AddGadget

;Refresh gad list

		lea.l	AmountGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,RefreshGadgets

;Activate string gad

		lea.l	AmountGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget

Window1IDCMP:	move.l	Window1(pc),a0
		jsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2
		beq	ShutDown
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#RAWKEY,d2
		beq	RawKeys
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#MOUSEBUTTONS,d2
		beq	ActivateGad1
		jmp	Window1IDCMP

VanillaKeys:	cmp.w	#$1b,d3
		beq	ShutDown
		jmp	Window1IDCMP
RawKeys:	cmp.w	#$5f,d3
		beq	Help
		jmp	Window1IDCMP

ActivateGad1:	cmp.l	#IECODE_LBUTTON,d3
		bne	ActivateGadOut
		lea.l	AmountGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget
ActivateGadOut:	jmp	Window1IDCMP

Win1Menus:	jsr	MenuNull
		cmp.l	#$00,d5
		beq	GetN
		cmp.l	#$01,d5
		beq	Help
		cmp.l	#$02,d5
		beq	About
		cmp.l	#$03,d5
		beq	ShutDown
		jmp	Window1IDCMP

GetN:
		cmp.l	#16777216,AmountInt
		bcs	GetN0.1
		move.l	Window1(pc),a0
		move.l	$2e(a0),a0
		lib	Intuition,DisplayBeep
		move.l	Window1(pc),a0
		lea.l	AmountGad1(pc),a1
		lib	Intuition,RemoveGadget
		move.l	#$31363737,AmountBuf
		move.l	#$37323135,AmountBuf+4
		move.l	#16777215,AmountInt
		move.l	Window1(pc),a0
		lea.l	AmountGad1(pc),a1
		move.l	#$00,d0
		lib	Intuition,AddGadget
		lea.l	AmountGad1(pc),a0
		move.l	Window1(pc),a1
		move.l	#$00,a2
		lib	Intuition,RefreshGadgets
CheckAmountOut:	jmp	Window1IDCMP

GetN0.1:	jsr	MenusOff
		lea.l	GetNName(pc),a5
		move.l	#FRQABSOLUTEXYM+FRQLOADINGM,d5
		jsr	FileRequester
		tst.l	d0
		beq	GetNOut

		lea.l	FRPathName(pc),a1
		move.l	a1,d1
		cmp.b	#$00,(a1)
		beq	GetNOut
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,SCCFile
		bne	GetN1
		jsr	FileError
		jmp	GetNOut

GetN1:		jsr	MenusOff
		move.l	Window1(pc),a0
		lea.l	Cheat?Txt(pc),a1
		lea.l	OKTxt(pc),a2
		lea.l	CancelTxt(pc),a3
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$100,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		cmp.l	#00,d0
		beq	GetN1.1
		jsr	TestForCity
GetN1.1:	jsr	MenusOn
	
GetN2:		move.l	SCCFile(pc),d1
		lib	Dos,Close
		move.l	#$00,SCCFile

GetNOut:	jsr	MenusOn
		jmp	Window1IDCMP

FileRequester:	move.l	a5,FRTitle
		move.l	d5,FRFlags
		lea.l	FileRequest1(pc),a0
		lib	Req,FileRequester
FROut:		rts

About:		jsr	MenusOff
		move.l	Window1(pc),a0
		lea.l	AboutTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$134,d2
		move.l	#$50,d3
		lib	Intuition,AutoRequest
		jsr	MenusOn
		jmp	Window1IDCMP

Help:		jsr	MenusOff
		move.l	Window1(pc),a0
		lea.l	HelpTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$190,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		jsr	MenusOn
		jmp	Window1IDCMP

Finished:	move.l	Window1(pc),a0
		lea.l	FinitoTxt1(pc),a1
		move.l	#$00,a2		;positive text
		lea.l	OKTxt(pc),a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$190,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		rts

TestForCity:	move.l	SCCFile(pc),d1
		move.l	#65,d2
		move.l	#-1,d3
		lib	Dos,Seek
		move.l	SCCFile(pc),d1
		lea.l	FileBuf(pc),a0
		move.l	a0,d2
		move.l	#$04,d3
		lib	Dos,Read
		tst.l	d0
		bne	TestForCity1	
		jsr	FileError
		jmp	Seek_Out
TestForCity1:	move.l	FileBuf(pc),d0
		cmp.l	#$43495459,d0
		bne	TestForCity2
		jsr	CheatCity
		jmp	Seek_Out
TestForCity2:	cmp.w	#1,Mode
		beq	TestForCity3
		move.l	Window1(pc),a0
		lea.l	WrongTxt1(pc),a1
		lea.l	OKTxt(pc),a2
		lea.l	CancelTxt(pc),a3
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$100,d2
		move.l	#$40,d3
		lib	Intuition,AutoRequest
		cmp.l	#00,d0
		beq	Seek_Out
		jsr	CheatCity
		jmp	Seek_Out
TestForCity3:	print	<"***Break",13,10,"This is not a SimCity city-file, exiting!",13,10>,_stdout
Seek_Out:	rts	

CheatCity:	move.l	SCCFile(pc),d1
		move.l	#3108,d2
		move.l	#-1,d3
		lib	Dos,Seek
		move.l	SCCFile(pc),d1
		lea.l	AmountInt(pc),a0
		move.l	a0,d2
		move.l	#$04,d3
		lib	Dos,Write
		cmp.w	#1,Mode
		bne	CheatCity1
		print	<"Your city now has $16, 777 215.",13,10>,_stdout
		rts
CheatCity1:	jsr	Finished
		rts

DOSCheat:	move.l	#16777215,AmountInt
		jsr	TestForCity
		jmp	ShutDown

NoReq:		print	<"You need req.library ver.2.5 or higher!",13,10>,_stdout
		jmp	ShutDown
NoInt:		print	<"Can't open intuition.library!",13,10>,_stdout
		jmp	ShutDown
NoGfx:		print	<"Can't open graphics.library!",13,10>,_stdout
		jmp	ShutDown
NoWin1:		print	<"Can't open Window!",13,10>,_stdout
		jmp	ShutDown
NoPub:		print	<"Can't lock PubScreen!",13,10>,_stdout
		jmp	ShutDown

ShutDown:	tst.l	PubScreen
		beq	ShutDown9000
		move.l	#$00,a0
		move.l	PubScreen(pc),a1
		lib	Intuition,UnlockPubScreen
		move.l	#$00,PubScreen

ShutDown9000:	tst.l	SCCFile
		beq	ShutDown8000
		move.l	SCCFile(pc),d1
		lib	Dos,Close
		move.l	#$00,SCCFile
ShutDown8000:	tst.l	NILFile
		beq	ShutDown5000
		move.l	NILFile(pc),d1
		lib	Dos,Close
		move.l	#$00,NILFile

ShutDown5000:	tst.l	Window1
		beq	ShutDown4000
		move.l	Window1(pc),a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1(pc),a0
		jsr	ClearMSGs
		move.l	#$00,Window1
		
ShutDown4000:
ShutDown3000:	tst.l	_ReqBase
		beq	ShutDown2000
		lea.l	FileRequest1(pc),a0
		lib	Req,PurgeFiles

;Check if launched from WB

ShutDown1999:	move.l	SCCTask,a4
		move.l	pr_CLI(a4),d0
		beq	ShutDownWB

ShutDown2000:	closlib	Dos
		closlib	Req
		closlib	Intuition
		closlib	Gfx

ShutDownOut:	move.l	#RETURN_OK,d0
		rts

ShutDownWB:	move.l	SCCTask(pc),a4
		lib	Exec,Forbid
		move.l	WBMsg(pc),a1
		lib	Exec,ReplyMsg
		move.l	OldLock(pc),d1
		lib	Dos,CurrentDir
		jmp	ShutDown2000

		INCLUDE	"FH1:Language/WF/SimCC/DosError.i"
		INCLUDE	"FH1:Language/WF/SimCC/SCCCommandLineHelp.i"
	
MenusOn:	lea.l	Menu1(pc),a1
		move.l	Window1(pc),a0
		lib	Intuition,SetMenuStrip
		rts

MenusOff:	move.l	Window1(pc),a0
		lib	Intuition,ClearMenuStrip
		rts

MenuNull:	move.l	d3,d6	
				
		ror.l	#5,d6	
		lsr.l	#8,d6	
		lsr.l	#8,d6
		lsr.l	#8,d6
		lsr.l	#3,d6

		move.l	d3,d5

		ror.l	#5,d5	
		ror.l	#6,d5	
		lsr.l	#8,d5
		lsr.l	#8,d5
		lsr.l	#8,d5
		lsr.l	#2,d5
				
		move.l	#$00,d4
		move.w	d3,d4
		lsr.l	#5,d4
		lsr.l	#6,d4
		rts

CheckIDCMP:	move.l	$4,a6			;made this a SubRoutine...
		move.l	$56(a0),a2		;Give it the window structure in a0
		move.l	#0,d1
		move.b	$0f(a2),d1
		move.l	#0,d0
		bset.l	d1,d0
		jsr	_LVOWait(a6)	
	
GetMsg1:	move.l	a2,a0	
		jsr	_LVOGetMsg(a6)
		tst.l	d0
		beq	GetMsg2
	
		move.l	d0,a1 
		move.l	$14(a1),d2		;answers with Class in d2,
		move.w	$18(a1),d3		;Code in d3 and
		move.w	$1a(a1),a4		;Qualifier in a4
		move.l	$1c(a1),a5		;IAddress in a5
		jsr	_LVOReplyMsg(a6)
		jmp	GetMsg1
GetMsg2:	move.l	#-1,d0
		rts

ClearMSGs:	move.l	a0,d0
		tst.l	d0
		beq	ClearMsg3
		move.l	a0,a3
		lib	Exec,Forbid
		move.l	$56(a3),a2		;Give it the window structure in a0
ClearMsg1:	move.l	a2,a0	
		lib	Exec,GetMsg
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1 
		lib	Exec,ReplyMsg
		jmp	ClearMsg1
ClearMsg2:	move.l	a3,a0
		lib	Intuition,CloseWindow
		lib	Exec,Permit
ClearMsg3:	rts

		ds.l	0

;--------------------Structures------------------

;Display stuff

Window1		dc.l	0
RP1		dc.l	0
PubScreen	dc.l	0

;Library stuff (well what's needed anymore)

		libnames

;Task stuff

SCCTask		dc.l	0

;WB Stuff

WBMsg		dc.l	0
ArgList		dc.l	0
ArgsLeft	dc.l	0
OldLock		dc.l	0

;File stuff

_stdout		dc.l	0
SCCAddress	dc.l	0
SCCLength	dc.l	0
SCCFile		dc.l	0
FileBuf		dc.l	$ffffffff
NILName:	dc.b	"NIL:",0
		ds.l	0
NILFile:	dc.l	0

;req.lib stuff/requester stuff

		INCLUDE	"FH1:Language/WF/SimCC/SCCFileRequester.i"

;Other stuff XIV

Mode		dc.w	0		;0=Intuition, 1=dos
Gad1On		dc.w	1		;0=Off, 1=On

;Texts, Part I

SCCName		dc.b	"SimCity 1.1 cheat by Tomi Blinnikka",0
		ds.l	0
GetNName	dc.b	"Get city file name...",0
		ds.l	0
PositiveText1	dc.b	"Yes",0
		ds.l	0
NegativeText1	dc.b	"No",0
		ds.l	0

;File stuff II

FInfo		dcb.b	260,0
		ds.l	0
;Font thing

Topaz		dc.l	FontName
		dc.w	8
		dc.b	0
		dc.b	0
FontName	dc.b	"topaz.font",0
		ds.l	0

;New screen & new window structures

NewWindow1
		dc.w	200,31			;X,Y POS
		dc.w	300			;WIDTH
Win1YSize	dc.w	43			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	MOUSEBUTTONS+CLOSEWINDOW+GADGETDOWN+GADGETUP+VANILLAKEY+RAWKEY+MENUPICK	;IDCMP FLAGS
		dc.l	WINDOWDRAG+WINDOWDEPTH+WINDOWCLOSE+ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	WindowTitle1		;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
Win1MinX	dc.w	192
Win1MinY	dc.w	11,300,43		;MINIMUM SIZE
		dc.w	WBENCHSCREEN		;TYPE
		dc.l	Win1TagList

Win1TagList	dc.l	WA_AutoAdjust,0
		dc.l	WA_InnerWidth,300
		dc.l	WA_InnerHeight,30
		dc.l	WA_Zoom,Win1ZoomXY
		dc.l	TAG_DONE,0

Win1ZoomXY	dc.w	0,20,192
Win1ZoomY	dc.w	11

WindowTitle1	dc.b	"SimCity cheat program",0
		ds.l	0

;Gadget structures

		INCLUDE "FH1:Language/WF/SimCC/SCCGads.i"
		
;Now for all the imagery and borders etc.

GadgetBorder1	dc.w	-1		;Initial offsets from the origin
		dc.w	-2		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY1	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
BorderXY1	dc.w	0,0
		dc.w	90,0		
		dc.w	90,11
		dc.w	0,11
		dc.w	0,0
		dc.b	0
		ds.l	0

;Menus

Menu1:		dc.l	0			;NEXT MENU
		dc.w	0,1			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu1Name		;NAME
		dc.l	Menu1Item2		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu1Name:	dc.b	"Project",0
		ds.l	0

Menu1Item2:	dc.l	Menu1Item3		;NEXT ITEM
		dc.w	1,1			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I2			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"C",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I2Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I2Text:	dc.b	"CHEAT!...",0
		ds.l	0

Menu1Item3:	dc.l	Menu1Item4		;NEXT ITEM
		dc.w	1,11			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I3			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"H",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I3:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I3Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I3Text:	dc.b	"Help...",0
		ds.l	0

Menu1Item4:	dc.l	Menu1Item5		;NEXT ITEM
		dc.w	1,21			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I4			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"A",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I4:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I4Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I4Text:	dc.b	"About...",0
		ds.l	0

Menu1Item5:	dc.l	0			;NEXT ITEM
		dc.w	1,31			;LEFT+TOP EDGE
		dc.w	110,9			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I5			;ITEMFILL (IMAGE, ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b 	"Q",0			;COMMAND
		dc.l	0			;IF<>0SubItem Shows ->
		dc.w	$ffff			;NextSelect

Menu1I5:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I5Text		;TEXT
		dc.l	0			;NEXTTEXT
	
Menu1I5Text:	dc.b	"Quit",0
		ds.l	0

;Texts, Part II

AboutTxt1:	dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT
		ds.l	0
		
AboutTxt2:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT
		ds.l	0

AboutTxt3:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT
		ds.l	0

AboutTxt4:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,50			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

AboutText1:	dc.b	"SimCity 1.1 cheat program v.1.02",0
		ds.l	0                          
AboutText2:	dc.b	"               by",0
		ds.l	0
AboutText3:	dc.b	"         Tomi Blinnikka",0
		ds.l	0
AboutText4:	dc.b	"        (C)opyright 1991",0
		ds.l	0

HelpTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText1		;TEXT
		dc.l	HelpTxt2		;NEXTTEXT
		ds.l	0

HelpTxt2:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,19			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText2		;TEXT
		dc.l	HelpTxt3		;NEXTTEXT
		ds.l	0

HelpTxt3:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,28			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	HelpText3		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

HelpText1:	dc.b	"1. Select amount of money ($0 - $16,777 215).",0
		ds.l	0
HelpText2:	dc.b	"2. Choose CHEAT!.",0
		ds.l	0
HelpText3:	dc.b	"3. Give SimCity CITY-file's filename.",0
		ds.l	0

FinitoTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	FinitoText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
FinitoText1:	dc.b	"Wow! I just donated your city a lot of money!",0
		ds.l	0

OKTxt:		dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	6,3			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	OKText1			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
OKText1:	dc.b	"OK",0
		ds.l	0
CancelTxt:	dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	6,3			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	CancelText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
CancelText1:	dc.b	"CANCEL!",0
		ds.l	0

Cheat?Txt:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	CheatText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

CheatText1:	dc.b	"Cheat on this city?",0
		ds.l	0                          

WrongTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	FWrongText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

FWrongText1:	dc.b	"Incorrect file! Try anyway?",0
		ds.l	0

Win1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	-103,-18		;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Win1Text1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
Win1Text1:	dc.b	"Amount of money? ($0 - $16, 777 215)",0
		ds.l	0

		END
