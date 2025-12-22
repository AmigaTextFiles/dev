***********************************************
*                                             *
*              (C)opyright 1991               *
*                                             *
*             by  Tomi Blinnikka              *
*                                             *
*      Don´t try to understand the code       *
*                                             *
*		  NBBS IISUP		      *
*    (Intuition Interfaced SetUp Program)     *
*                                             *
***********************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/io.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/reqbase.i"
	INCLUDE	"devices/serial.i"
	INCLUDE	"intuition/intuition.i"

	INCLUDE	"XREF:dos.xref"
	INCLUDE	"XREF:gfx.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"

	XREF	_CreatePort
	XREF	_DeletePort
	XREF	_CreateExtIO
	XREF	_DeleteExtIO
	XREF	_printf

	XDEF	_DOSBase
	XDEF	_SysBase
	XDEF	_stdout

DReq		set	1

		section	NBBS,CODE
	
Start:		move.l	a0,ConfigAddress	;Get Config filename
		clr.b	-1(a0,d0.l)		;add null to end of filename
		openlib	Dos,ShutDown
		move.l	_DosBase,_DOSBase
		move.l	$4,_SysBase

		lib	Dos,Output
		move.l	d0,_stdout

		move.l	ConfigAddress,a0
		tst.b	(a0)
		bne	GotFileName
		jmp	StartMain

GotFileName:

;Move filename to FRPathName so if user saves straight away it goes into
;the correct file, and not the default one.

		move.l	ConfigAddress,a0
		lea.l	FRPathName,a1
		cmp.b	#"?",(a0)
		beq	CommandLineHelp
CopyFName:	move.b	(a0)+,(a1)+
		cmp.b	#$00,(a0)
		bne	CopyFName
		clr.b	(a1)

		move.l	ConfigAddress,a0
		lea.l	FRFile,a1
CopyFName1:	move.b	(a0)+,(a1)+
		cmp.b	#$00,(a0)
		bne	CopyFName1
		clr.b	(a1)

		move.l	ConfigAddress,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,ConfigFile
		beq	ConfigNotOpen

		move.l	ConfigFile,d1
		lea.l	CONFIG,a0
		move.l	a0,d2
		lea.l	CONFIG,a1
		lea.l	CONFIG_END,a2
		sub.l	a1,a2
		move.l	a2,d3
		lib	Dos,Read

		jsr	SetGads

;Close config file, we've got what we want

		move.l	ConfigFile,d1
		lib	Dos,Close
		move.l	#$00,ConfigFile
		move.l	#$01,CheckSum

StartMain:	move.l	#2,d0
		move.l	$4,a6
		lea.l	_ReqLib,a1
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_ReqBase
		beq	ShutDown

;Reset checksum so we can tell if the user has played with any of the
;gadgets, and later if (s)he has, warn him/her about it before quitting

		move.l	#$00,CheckSum
	
		openlib	Intuition,ShutDown
		openlib	Gfx,ShutDown

;Find our task

		move.l	#$00,a1
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a0
		move.l	$b8(a0),OldTaskWinPtr

;Open Screen
		lea.l	NewScreen1,a0
		lib	Intuition,OpenScreen
		move.l	d0,Screen1
		beq	ShutDown
		move.l	d0,SToW1
		move.l	d0,SToW2
		move.l	d0,SToW3
		move.l	d0,SToW4
		move.l	d0,SToW5
		move.l	d0,SToW6
		move.l	d0,SToW7
		add.l	#$2c,d0
		move.l	d0,ViewPort1

;Open Window1

StartWin1:	lea.l	NewWindow1,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window1
		beq	ShutDown
		move.l	d0,a0
		move.l	$32(a0),RP1

;Close the second, third or fourth window

		move.l	Window2,a0
		jsr	ClearMSGs
		move.l	#$00,Window2
		move.l	Window3,a0
		jsr	ClearMSGs
		move.l	#$00,Window3
		move.l	Window4,a0
		jsr	ClearMSGs
		move.l	#$00,Window4

;move requesters to Window1

		move.l	OurTask,a0
		move.l	Window1,$b8(a0)

;Add Menus to Window1

		move.l	Window1,a0
		lea.l	Menu1,a1
		lib	Intuition,SetMenuStrip

;Add all the texts to Window1 of course

		move.l	RP1,a0
		lea.l	Win1Txt1,a1
		move.l	#$00,d0
		move.l	#$00,d1
		lib	Intuition,PrintIText

;Read page 215 Paragraph 3 of the RKRM L&D, activate string 1st Gad!

		lea.l	SerBRKTGad,a0
		move.l	Window1,a1
		move.l	#$00,a2
		lib	Intuition,ActivateGadget

;Reset ActiveWinNum

		move.w	#$01,ActiveWinNum

Window1IDCMP:	cmp.w	#$01,ActiveWinNum
		beq	Window1IDCMP1
		cmp.w	#$02,ActiveWinNum
		beq	Window2IDCMP1
		cmp.w	#$03,ActiveWinNum
		beq	Window3IDCMP1
		cmp.w	#$04,ActiveWinNum
		beq	Window4IDCMP1

		INCLUDE	"LWF:NBBS/SetProg/SPWin1IDCMP.i"
		INCLUDE "LWF:NBBS/SetProg/SPSetGads.i"
		INCLUDE	"LWF:NBBS/SetProg/SPSetSer.i"

StartWin2:

;Open Window2

		lea.l	NewWindow2,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window2
		beq	ShutDown
		move.l	d0,a0
		move.l	$32(a0),RP2

;Move the requesters to the window now active

		move.l	OurTask,a0
		move.l	Window2,$b8(a0)

;Close the first, third or fourth window

		move.l	Window1,a0
		jsr	ClearMSGs
		move.l	#$00,Window1
		move.l	Window3,a0
		jsr	ClearMSGs
		move.l	#$00,Window3
		move.l	Window4,a0
		jsr	ClearMSGs
		move.l	#$00,Window4

Win2Start1:

;Add Menus to Window2

		move.l	Window2,a0
		lea.l	Menu1,a1
		lib	Intuition,SetMenuStrip
		move.w	#$02,ActiveWinNum

;Activate 1st string gad.

;		lea.l	Gad,a0
		move.l	Window2,a1
		move.l	#$00,a2
;		lib	Intuition,ActivateGadget
		jmp	Window1IDCMP

StartWin3:

;Open Window3

		lea.l	NewWindow3,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window3
		beq	ShutDown
		move.l	d0,a0
		move.l	$32(a0),RP3

;Move the requesters to the window now active

		move.l	OurTask,a0
		move.l	Window3,$b8(a0)

;Close the first, second or fourth window

		move.l	Window1,a0
		jsr	ClearMSGs
		move.l	#$00,Window1
		move.l	Window2,a0
		jsr	ClearMSGs
		move.l	#$00,Window2
		move.l	Window4,a0
		jsr	ClearMSGs
		move.l	#$00,Window4

Win3Start1:

;Add Menus to Window3

		move.l	Window3,a0
		lea.l	Menu1,a1
		lib	Intuition,SetMenuStrip
		move.w	#$03,ActiveWinNum

;Activate 1st string gad.

;		lea.l	Gad,a0
		move.l	Window3,a1
		move.l	#$00,a2
;		lib	Intuition,ActivateGadget
		jmp	Window1IDCMP

StartWin4:

;Open Window4

		lea.l	NewWindow4,a0
		lib	Intuition,OpenWindow
		move.l	d0,Window4
		beq	ShutDown
		move.l	d0,a0
		move.l	$32(a0),RP4

;Move the requesters to the window now active

		move.l	OurTask,a0
		move.l	Window4,$b8(a0)

;Close the first, second or third window

		move.l	Window1,a0
		jsr	ClearMSGs
		move.l	#$00,Window1
		move.l	Window2,a0
		jsr	ClearMSGs
		move.l	#$00,Window2
		move.l	Window3,a0
		jsr	ClearMSGs
		move.l	#$00,Window3

Win4Start1:

;Add Menus to Window4

		move.l	Window4,a0
		lea.l	Menu1,a1
		lib	Intuition,SetMenuStrip
		move.w	#$04,ActiveWinNum

;Activate 1st string gad.

;		lea.l	Gad,a0
		move.l	Window4,a1
		move.l	#$00,a2
;		lib	Intuition,ActivateGadget
		jmp	Window1IDCMP

NoReq:		print	<"You need req.library ver.2.5 or higher!",13,10>,_stdout
		jmp	ShutDown

ShutDown:	move.l	OurTask,a0
		move.l	OldTaskWinPtr,$b8(a0)

		tst.l	ConfigFile
		beq	ShutDown9000
		move.l	ConfigFile,d1
		lib	Dos,Close
		move.l	#$00,ConfigFile

ShutDown9000:
ShutDown5000:	tst.l	Window1
		beq	ShutDown4900
		move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1,a0
		jsr	ClearMSGs
ShutDown4900:	move.l	Window2,a0
		jsr	ClearMSGs
		move.l	Window3,a0
		jsr	ClearMSGs
		move.l	Window4,a0
		jsr	ClearMSGs
		move.l	AbWin,a0
		jsr	ClearMSGs
		move.l	QuitWin1,a0
		jsr	ClearMSGs
		move.l	HelpWin1,a0
		jsr	ClearMSGs

ShutDown4500:	tst.l	Screen1
		beq	ShutDown3000
		move.l	Screen1,a0
		lib	Intuition,CloseScreen

ShutDown3000:	tst.l	_ReqBase
		beq	ShutDown2000
		lea.l	FileRequest1,a0
		lib	Req,PurgeFiles

ShutDown2000:
ShutDown1100:	tst.l	_IntuitionBase
		beq	ShutDown1000
		lib	Intuition,OpenWorkBench		;For that xtra touch
ShutDown1000:	closlib	Intuition
		closlib	Gfx
		closlib	Dos
		closlib	Req
ShutDownOut:	move.l	#RETURN_OK,d0
		rts

		INCLUDE	"LWF:NBBS/DosError.i"
		INCLUDE	"LWF:NBBS/SetProg/SPCommandLineHelp.i"
	
MenusOn:	lea.l	Menu1,a1
		cmp.w	#$01,ActiveWinNum
		beq	MenusOn1
		cmp.w	#$02,ActiveWinNum
		beq	MenusOn2
		cmp.w	#$03,ActiveWinNum
		beq	MenusOn3
		cmp.w	#$04,ActiveWinNum
		beq	MenusOn4
		rts
MenusOn1:	move.l	Window1,a0
		lib	Intuition,SetMenuStrip
		rts
MenusOn2:	move.l	Window2,a0
		lib	Intuition,SetMenuStrip
		rts
MenusOn3:	move.l	Window3,a0
		lib	Intuition,SetMenuStrip
		rts
MenusOn4:	move.l	Window4,a0
		lib	Intuition,SetMenuStrip
		rts


MenusOff:	cmp.w	#$01,ActiveWinNum
		beq	MenusOff1
		cmp.w	#$02,ActiveWinNum
		beq	MenusOff2
		cmp.w	#$03,ActiveWinNum
		beq	MenusOff3
		cmp.w	#$04,ActiveWinNum
		beq	MenusOff4
		rts
MenusOff1:	move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		rts
MenusOff2:	move.l	Window2,a0
		lib	Intuition,ClearMenuStrip
		rts
MenusOff3:	move.l	Window3,a0
		lib	Intuition,ClearMenuStrip
		rts
MenusOff4:	move.l	Window4,a0
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

;Structures

;Display stuff

Screen1		dc.l	0
ViewPort1	dc.l	0
Window1		dc.l	0
RP1		dc.l	0
Window2		dc.l	0
RP2		dc.l	0
Window3		dc.l	0
RP3		dc.l	0
Window4		dc.l	0
RP4		dc.l	0
HelpWin1	dc.l	0
HRP1		dc.l	0
AbWin		dc.l	0
AbRP		dc.l	0
QuitWin1	dc.l	0

;Library stuff (well what's needed anymore)

		libnames

_DOSBase	dc.l	0
_SysBase	dc.l	0

;File stuff

_stdout		dc.l	0
ConfigAddress	dc.l	0
ConfigFile	dc.l	0

;Task stuff

OurTask		dc.l	0
OldTaskWinPtr	dc.l	0

;req.lib stuff/requester stuff

		INCLUDE	"LWF:NBBS/SetProg/SPFileRequester.i"

;Other stuff XIV

CheckSum	dc.l	0
ActiveWinNum	dc.w	1		;Active SetUp-Page Number


;Texts, Part I

NBBSName	dc.b	"NBBS (C)opyright 1991 Tomi Blinnikka",0
LoadName	dc.b	"Load config...",0
SaveName	dc.b	"Save config file as...",0
PositiveText1	dc.b	"Yes",0
NegativeText1	dc.b	"No",0
		ds.l	0

;New screen & new window structures

NewScreen1
		dc.w	0,0			;X,Y POS
Screen1MaxCol	dc.w	640			;WIDTH
Screen1MaxRow	dc.w	256			;HEIGHT
		dc.w	2			;DEPTH
		dc.b	0,1			;COLORS
		dc.w	$8000			;VIEWMODES
		dc.w	$000F			;TYPE
		dc.l	Screen1Font		;FONT
		dc.l	NBBSName		;DEFULT TITLE
		dc.l	0			;GADGETS
		dc.l	0			;CUSTOMBITMAP

Screen1Font	dc.l	Screen1FontN		;NAME
		dc.w	8			;SIZE
		dc.b	0			;STYLE
		dc.b	0			;FLAGS
		ds.l	0
Screen1FontN	dc.b	"topaz.font",0
		ds.l	0

NewWindow1
		dc.w	0,11			;X,Y POS
		dc.w	640			;WIDTH
		dc.w	245			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+GADGETDOWN+GADGETUP+VANILLAKEY+RAWKEY+MENUPICK	;IDCMP FLAGS
		dc.l	$100A			;FLAGS
		dc.l	StopB1Gad,0		;GADGETS, CHECKMARK
		dc.l	WindowTitle1		;TITLE
SToW1		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	640,256,640,256		;MINIMUM SIZE
		dc.w	$000f			;TYPE

WindowTitle1	dc.b	"SetUp Page 1",0
		ds.l	0
NewWindow2
		dc.w	0,11			;X,Y POS
		dc.w	640			;WIDTH
		dc.w	245			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+GADGETDOWN+GADGETUP+VANILLAKEY+RAWKEY+MENUPICK	;IDCMP FLAGS
		dc.l	$100A			;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	WindowTitle2		;TITLE
SToW2		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	640,256,640,256		;MINIMUM SIZE
		dc.w	$000f			;TYPE

WindowTitle2	dc.b	"SetUp Page 2",0
		ds.l	0
NewWindow3
		dc.w	0,11			;X,Y POS
		dc.w	640			;WIDTH
		dc.w	245			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+GADGETDOWN+GADGETUP+VANILLAKEY+RAWKEY+MENUPICK	;IDCMP FLAGS
		dc.l	$100A			;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	WindowTitle3		;TITLE
SToW3		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	640,256,640,256		;MINIMUM SIZE
		dc.w	$000f			;TYPE

WindowTitle3	dc.b	"SetUp Page 3",0
		ds.l	0
NewWindow4
		dc.w	0,11			;X,Y POS
		dc.w	640			;WIDTH
		dc.w	245			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+GADGETDOWN+GADGETUP+VANILLAKEY+RAWKEY+MENUPICK	;IDCMP FLAGS
		dc.l	$100A			;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	WindowTitle4		;TITLE
SToW4		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	640,256,640,256		;MINIMUM SIZE
		dc.w	$000f			;TYPE

WindowTitle4	dc.b	"SetUp Page 4",0
		ds.l	0

NewHelpWin1
		dc.w	10,6,400,250		;POSITION, SIZE
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+GADGETUP+VANILLAKEY	;IDCMP FLAGS
		dc.l	$1006+WINDOWCLOSE	;FLAGS
		dc.l	YNGad1,0		;GADGETS, CHECKMARK
		dc.l	NBBSName		;TITLE
SToW5		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	400,250,400,250		;MINIMUM+MAX SIZE
		dc.w	$000f			;TYPE

HelpWin1Txt1	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,3			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	HWin1Text1		;TEXT
		dc.l	HWin1Txt2		;NEXTTEXT

HWin1Text1	dc.b	"Help:",0
		ds.l	0

HWin1Txt2	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	5,22			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	HWin1Text2		;TEXT
		dc.l	0			;NEXTTEXT

HWin1Text2	dc.b	"Sorry, help is not availible yet.",0
		ds.l	0

NewQuitWin1
		dc.w	0,0,320,75		;POSITION, SIZE
		dc.b	0,1			;PENS
		dc.l	GADGETUP+VANILLAKEY	;IDCMP FLAGS
		dc.l	$1006			;FLAGS
		dc.l	YNGad1,0		;GADGETS, CHECKMARK
		dc.l	NBBSName		;TITLE
SToW6		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP
		dc.w	320,75,320,75		;MINIMUM+MAX SIZE
		dc.w	$000f			;TYPE

QuitWin1Txt1	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,3			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	QuitWin1Text1		;TEXT
		dc.l	QuitWin1Txt2		;NEXTTEXT
QuitWin1Text1	dc.b	"Message:",0
		ds.l	0

QuitWin1Txt2	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	5,22			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	QuitWin1Text2		;TEXT
		dc.l	0			;NEXTTEXT
QuitWin1Text2	dc.b	"Is it O.K. to loose changes?",0
                ds.l	0

NewAbWindow1:
		dc.w	128,50			;X,Y POS
		dc.w	400			;WIDTH (orig.704)
		dc.w	100			;HEIGHT
		dc.b	1,2			;PENS
		dc.l	GADGETUP+VANILLAKEY	;IDCMP FLAGS
		dc.l	ACTIVATE+BORDERLESS	;FLAGS 
		dc.l	YNGad1,0		;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW7:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	128,50,128,50		;MINIMUM SIZE
		dc.w	$000f			;TYPE
		ds.l	0


;Gadget structures

YNGad1		dc.l	YNGad2		;Next Gadget
		dc.w	10		;"hit-box" left edge
		dc.w	-15		;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
YN1Flag		dc.w	$0008		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;gadget type
		dc.l	YNGadgetBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	YNGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	2		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

YNGadTxt1	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	13,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PositiveText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
		
YNGad2		dc.l    0		;Next Gadget
		dc.w	-61		;"hit-box" left edge
		dc.w	-15		;"hit-box" top  edge
		dc.w	51		;"hit-box" Width
		dc.w	10		;"hit-box" Height
YNG2Flag	dc.w	$0018		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;gadget type
		dc.l	YNGadgetBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	YNGadTxt2	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	3		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

YNGadTxt2	dc.b	1,2			;PENS
                dc.w	0			;MODE
                dc.w	17,1			;LEFT+TOPEDGE
                dc.l	0			;FONT
                dc.l	NegativeText1		;TEXT
                dc.l	0			;NEXTTEXT

		INCLUDE	"LWF:NBBS/SetProg/SPPage1Gads.i"

;Now for all the imagery and borders etc.

YNGadgetBorder1 dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	YNBorderXY1	;XY's
		dc.l	YNGadgetBorder2	;Next Border
		dc.b	0
		ds.l	0
YNBorderXY1	dc.w	0,0
		dc.w	52,0		
		dc.w	52,11
		dc.w	0,11
		dc.w	0,0
		dc.b	0
		ds.l	0

YNGadgetBorder2 dc.w	-2		;Initial offsets from the origin
		dc.w	-3		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	YNBorderXY2	;XY's
		dc.l	YNGadgetBorder3	;Next Border
		dc.b	0
		ds.l	0
YNBorderXY2	dc.w	0,0
		dc.w	54,0		
		dc.w	54,15
		dc.w	0,15
		dc.w	0,0
		dc.b	0
		ds.l	0

YNGadgetBorder3 dc.w	-3		;Initial offsets from the origin
		dc.w	-4		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	YNBorderXY3	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
YNBorderXY3	dc.w	0,0
		dc.w	56,0		
		dc.w	56,17
		dc.w	0,17
		dc.w	0,0
		dc.b	0
		ds.l	0

AbBorder1:	dc.w	2		;Initial offsets from the origin
		dc.w	1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	9		;Line Count (XY)
		dc.l	AbBorderXY	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
AbBorderXY:	dc.w	0,0
		dc.w	395,0		
		dc.w	395,77
		dc.w	331,77
		dc.w	331,97
		dc.w	64,97
		dc.w	64,77
		dc.w	0,77
		dc.w	0,0
		dc.b	0
		ds.l	0

ButtonImage1:	dc.w	0,0			;Left,Top
		dc.w	16,11			;Sizes
		dc.w	1			;Depth
		dc.l	ButtonImg1		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

ButtonImage2:	dc.w	0,0			;Left,Top
		dc.w	16,11			;Sizes
		dc.w	1			;Depth
		dc.l	ButtonImg2		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

BorderImage1:	dc.w	-1,-1			;Left,Top
		dc.w	234,10			;Sizes
		dc.w	1			;Depth
		dc.l	BorderImg1		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

BorderImage2:	dc.w	-1,-1			;Left,Top
		dc.w	26,10			;Sizes
		dc.w	1			;Depth
		dc.l	BorderImg1		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

BorderImage3:	dc.w	-1,-1			;Left,Top
		dc.w	114,10			;Sizes
		dc.w	1			;Depth
		dc.l	BorderImg1		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

;Menus

Menu1:		dc.l	Menu2			;NEXT MENU
		dc.w	0,1			;LEFT+TOP EDGE
		dc.w	100,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu1Name		;NAME
		dc.l	Menu1Item1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu1Name:	dc.b	"Project",0
		ds.l	0

Menu1Item1:	dc.l	Menu1Item2		;NEXT ITEM
		dc.w	1,1			;LEFT+TOP EDGE
		dc.w	116,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I1			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"L",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu1I1Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I1Text:	dc.b	"Load...",0
		ds.l	0

Menu1Item2:	dc.l	Menu1Item3		;NEXT ITEM
		dc.w	1,10			;LEFT+TOP EDGE
		dc.w	116,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I2			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"S",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu1I2Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I2Text:	dc.b	"Save",0
		ds.l	0

Menu1Item3:	dc.l	Menu1Item4		;NEXT ITEM
		dc.w	1,19			;LEFT+TOP EDGE
		dc.w	116,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I3			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"A",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		ds.l	0
		
Menu1I3:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu1I3Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I3Text:	dc.b	"Save as...",0
		ds.l	0

Menu1Item4:	dc.l	Menu1Item5		;NEXT ITEM
		dc.w	1,41			;LEFT+TOP EDGE
		dc.w	116,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I4			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"?",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I4:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu1I4Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I4Text:	dc.b	"About...",0
		ds.l	0

Menu1Item5:	dc.l	0			;NEXT ITEM
		dc.w	1,51			;LEFT+TOP EDGE
		dc.w	116,9			;WIDTH+HEIGHT
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
		dc.l	0			;FONT
		dc.l	Menu1I5Text		;TEXT
		dc.l	0			;NEXTTEXT
	
Menu1I5Text:	dc.b	"Quit",0
		ds.l	0

Menu2:		dc.l	0			;NEXT MENU
		dc.w	101,1			;LEFT+TOP EDGE
		dc.w	100,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu2Name		;NAME
		dc.l	Menu2Item1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu2Name:	dc.b	"Page",0
		ds.l	0

Menu2Item1:	dc.l	Menu2Item2		;NEXT ITEM
		dc.w	1,1			;LEFT+TOP EDGE
		dc.w	90,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu2I1			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"1",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		ds.l	0
		
Menu2I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu2I1Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1Text:	dc.b	"Page 1",0
		ds.l	0

Menu2Item2:	dc.l	Menu2Item3		;NEXT ITEM
		dc.w	1,10			;LEFT+TOP EDGE
		dc.w	90,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu2I2			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"2",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu2I2Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I2Text:	dc.b	"Page 2",0
		ds.l	0

Menu2Item3:	dc.l	Menu2Item4		;NEXT ITEM
		dc.w	1,19			;LEFT+TOP EDGE
		dc.w	90,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu2I3			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"3",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I3:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu2I3Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I3Text:	dc.b	"Page 3",0
		ds.l	0

Menu2Item4:	dc.l	0			;NEXT ITEM
		dc.w	1,28			;LEFT+TOP EDGE
		dc.w	90,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu2I4			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"4",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I4:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu2I4Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I4Text:	dc.b	"Page 4",0
		ds.l	0

;Texts, Part II

AboutTxt1:	dc.b	3,1			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT
		ds.l	0
		
AboutTxt2:	dc.b	3,2			;PENS
		dc.w	4			;MODE
		dc.w	10,20			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT
		ds.l	0

AboutTxt3:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,30			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT
		ds.l	0

AboutTxt4:	dc.b	1,1			;PENS
		dc.w	4			;MODE
		dc.w	10,50			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	AboutTxt5		;NEXTTEXT
		ds.l	0

AboutTxt5:	dc.b	1,1			;PENS
		dc.w	4			;MODE
		dc.w	10,60			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText5		;TEXT
		dc.l	AboutTxt6		;NEXTTEXT
		ds.l	0

AboutTxt6:	dc.b	1,1			;PENS
		dc.w	4			;MODE
		dc.w	10,69			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText6		;TEXT
		dc.l	AboutTxt7		;NEXTTEXT
		ds.l	0

AboutTxt7:	dc.b	1,1			;PENS
		dc.w	4			;MODE
		dc.w	10,78			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	AboutText7		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

AboutText1:	dc.b	"NBBS Intuition Interfaced SetUp Program v.0.01a",0
AboutText2:	dc.b	"                       by",0
AboutText3:	dc.b	"                 Tomi Blinnikka",0
AboutText4:	dc.b	"  (C)opyright 1991. Contact author at:",0,0
AboutText5:	dc.b	"                  Syystie 10",0
AboutText6:	dc.b	"                  00780 Helsinki",0
AboutText7:	dc.b	"                  Finland",0
		ds.l	0

Win1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	20,12			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Win1Text1		;TEXT
		dc.l	Win1Txt2		;NEXTTEXT
		ds.l	0
Win1Text1:	dc.b	"Stop bits",0
		ds.l	0
Win1Txt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	20,50			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Win1Text2		;TEXT
		dc.l	Win1Txt3		;NEXTTEXT
		ds.l	0
Win1Text2:	dc.b	"Data bits",0
		ds.l	0
Win1Txt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	120,12			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Win1Text3		;TEXT
		dc.l	Win1Txt4		;NEXTTEXT
		ds.l	0
Win1Text3:	dc.b	"Parity",0
		ds.l	0
Win1Txt4:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	220,12			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Win1Text4		;TEXT
		dc.l	0 ;Win1Txt5		;NEXTTEXT
		ds.l	0
Win1Text4:	dc.b	"Duplex",0
		ds.l	0

;Now the most boring stuff.. The Gadget buffers, most of which are 30 bytes

GadUnBuf:	ds.b	30

;Newest version of the .config-file in Config.i

		INCLUDE	"LWF:NBBS/Config.i"

;Now for the stuff that needs to be in CHIP-RAM

		section	NBBS_CHIP_STUFF,DATA,CHIP

ButtonImg1:	dc.w	$1f80,$30c0,$6060,$c030,$c030,$c030,$c030,$c030,$6060,$30c0,$1f80
ButtonImg2:	dc.w	$1f80,$30c0,$6660,$cf30,$cf30,$cf30,$cf30,$cf30,$6660,$30c0,$1f80

BorderImg1:	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
		END
			;1234567890123456, 1234567890123456,       1234567890123456
