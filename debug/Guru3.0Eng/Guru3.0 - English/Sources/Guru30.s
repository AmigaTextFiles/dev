* The Guru 3.0(2)
*
* The program to make guru messages understandable !!
*
* Features :	Fully font-sensitive intuition-based front end
*		Good descriptions
*		Looks cool on ALL workbenches (2 to 256 col, palette sensitive)
*		2.0+ compatible, 680x0 compatible
*		1.2/1.3 compatible (mostly)
*		Awfully delayed
*
* Code & design: Emiel Lensink
* Created using: A3000, kick 3.1, 2Mb chip, 12Mb fast
*		 Piccolo graphics card
*		 Devpac 3.04
*		 PPaint 6.0
*		 The Ultimate Graphics Convertor (also by me, but not completely finished (yet))
*
* Created using: CyberVision Gfx card, Devpac 3.14
*
* Thanx to:	Commodore (RIP) for the AMIGA
*
**********************************************************************************************

* Version stuff
	bra.s	ProgBits
	dc.b	' $VER: TheGuru 3.02 $',10,0
	dc.b	' $COPYRIGHT: Copyright © 1996 by Emiel Lensink$',0
	cnop	0,4
ProgBits

* Includese

	include	exec/exec.i
	include exec/exec_lib.i		
	include	intuition/intuition.i		
	include	intuition/intuition_lib.i
	include graphics/graphics_lib.i
	include graphics/gfx.i
	include dos/dos.i
	include dos/dos_lib.i
	include workbench/startup.i
	include workbench/icon_lib.i
	include workbench/workbench.i
	
	include /subs/easystart.i
	
* Libraries

	move.w		#4,a0
	move.l		(a0),a1
	move.w 	LIB_VERSION(a1),Execvers
	
	moveq		#0,d0			Open Intuition
	lea		Intname,a1
	CALLEXEC	OpenLibrary
	move.l		d0,_IntuitionBase
	beq		NoInt

	moveq		#0,d0			Open Graphics
	lea		Gfxname,a1
	CALLEXEC	OpenLibrary
	move.l		d0,_GfxBase
	beq		NoGfx

	moveq		#0,d0			Open DOS
	lea		Dosname,a1
	CALLEXEC	OpenLibrary
	move.l		d0,_DOSBase
	beq		NoDos			

	moveq		#120,d0
	move.l		#MEMF_ANY!MEMF_CLEAR,d1
	CALLEXEC	AllocMem
	move.l		d0,FakeRast
	beq		NoFRast	

* setup stuff

	tst.l		returnMsg		Workbench ?
	beq		CliStart
	
	move.l		returnMsg,a3
	move.l		sm_ArgList(a3),a3
	move.l		(a3),d1		
	CALLDOS		CurrentDir		(offset 0:wa_Lock) CD to program startup dir.

	lea		Iconname,a1		Open icon library		
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	move.l		d0,_IconBase
	beq		CliStart		No icon library
	
	move.l		returnMsg,a3
	move.l		sm_ArgList(a3),a3
	move.l		wa_Name(a3),a0
	CALLICON	GetDiskObject		¯|
	move.l		d0,a5			 V
	tst.l		d0			Did we get it ?
	beq		NoDiskO

	move.l		do_ToolTypes(a5),a0	Check tooltypes
	lea		Language,a1		= [LANGUAGE]		
	CALLICON	FindToolType
	tst.l		d0
	beq.s		DefLF
	
	move.l		d0,a0			Pointer naar f'name
	bsr		LoadFile
	tst.l		d0
	beq.s		DefLF
	move.l		d0,LangSize
	move.l		a0,LangBuff
	bsr		DecodeLF

DefLF	move.l		do_ToolTypes(a5),a0	Check tooltypes
	lea		DataFile,a1		= [DATAFILE=]		
	CALLICON	FindToolType
	tst.l		d0
	beq.s		DefDF
	
	move.l		d0,a0			Pointer naar f'name
	bsr		LoadFile
	tst.l		d0
	beq.s		DefDF
	move.l		d0,DataSize
	move.l		a0,DataBuff

DefDF	move.l		do_ToolTypes(a5),a0	Check tooltypes
	lea		ForceTopaz,a1		= [TOPAZ]		
	CALLICON	FindToolType
	tst.l		d0
	beq.s		NoTOPAZ
	move.b		#1,tt_Topaz

NoTOPAZ	move.l		do_ToolTypes(a5),a0	Check tooltypes
	lea		AutoMatic,a1		= [AUTMATIC]		
	CALLICON	FindToolType
	tst.l		d0
	beq.s		NoAUTO
	move.b		#1,tt_AutoMatic
	
NoAUTO	move.l		do_ToolTypes(a5),a0	Check tooltypes
	lea		AutoFront,a1		= [AUTOTOFRONT]		
	CALLICON	FindToolType
	tst.l		d0
	beq.s		NoATFR
	move.b		#1,tt_AutoFront
	
NoATFR	cmpi.w		#36,Execvers
	blt.s		.kickskip

	move.l		do_ToolTypes(a5),a0
	lea		PubScr,a1		= [PUBSCREEN=]
	CALLICON	FindToolType
	tst.l		d0
	beq.s		NoPUBS
	move.b		#1,tt_PubScreen
	
	move.l		d0,a0
	CALLINT		LockPubScreen
	move.l		d0,ScreenLock
	beq.s		TTNoLock
	bra.s		NoPUBS

.kickskip

TTNoLock
	move.b		#0,tt_PubScreen		lock failed, use wb
		
NoPUBS	move.l		a5,a0
	CALLICON	FreeDiskObject

NoDiskO	move.l		_IconBase,a1
	CALLEXEC	CloseLibrary

CliStart
	* do we want to go on??
	cmpi.b		#1,tt_AutoMatic
	bne.s		.nomat1

	move.l		$100.w,d0		Enforcer...
	tst.l		d0			Was there a guru??
	beq		NoGuruBeen		Nope.... quit then

.nomat1	cmpi.l		#0,DataSize
	bne.s		.skip2
	lea		DefData,a0
	bsr		LoadFile
	tst.l		d0
	beq		NoDATAErr		Could load no guru data file
	move.l		d0,DataSize
	move.l		a0,DataBuff

.skip2	move.l		DataBuff,a1
	move.l		a1,a2
	add.l		DataSize,a2
	
	lea		GenAl,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,GeneralAlert
	
	lea		Sub1,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,Subsys1

	lea		Sub2,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,Subsys2

	lea		Sub3,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,Subsys3

	lea		DosAl,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,DosAlert

	lea		UnkGuru,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,UnknownGuru
	
	lea		UnkDos,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,UnknownDos
		
	lea		Dead,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,Deadend

	lea		Reco,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,Recovery

	lea		EndFile,a0
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq		ErrInDATAErr
	move.l		a0,EndOfFile
	
	bsr		FilterFile

	cmpi.b		#1,tt_PubScreen
	beq.s		.skip3
	
	cmpi.w		#36,Execvers
	blt.s		.kickskip

	lea		0.w,a0
	CALLINT		LockPubScreen
	move.l		d0,ScreenLock
	beq		NoScLock
	bra.s		.skip3

.kickskip
	lea		TempPrintBuff,a0
	move.l		#2000,d0
	moveq		#WBENCHSCREEN,d1
	lea		0.w,a1
	CALLINT		GetScreenData
	lea		TempPrintBuff,a0
	move.l		a0,ScreenLock
			
.skip3	move.l		ScreenLock,a0
	move.l		sc_Font(a0),ScreenFont		Get the font 

	cmpi.b		#1,tt_Topaz
	bne.s		.skipx
	lea		Topaz,a6
	move.l		a6,ScreenFont

.skipx	moveq		#0,d0				Get sizes of windowborders
	moveq		#0,d1
	move.b		sc_WBorTop(a0),d0
	move.b		sc_WBorLeft(a0),d1
	move.l		sc_Font(a0),a0
	move.w		ta_YSize(a0),d2
	add.w		d2,d0
	addq.w		#1,d0
	move.w		d1,LeftBorder
	move.w		d0,TopBorder

	move.l		ScreenFont,a0
	CALLGRAF	OpenFont
	move.l		d0,Font
	beq		NoFont

	move.l		FakeRast,a1
	CALLGRAF	InitRastPort

	move.l		Font,a0
	move.l		FakeRast,a1
	CALLGRAF	SetFont	

	bsr		WidestText			Find widest text
	bsr		WidestLetter			Find widest letter
	bsr		WidestArrow			Find widest arrow

	move.l		Font,a0
	moveq		#0,d0
	move.w		tf_YSize(a0),d0
	move.w		d0,FontY	
	move.w		tf_Baseline(a0),d0
	move.w		d0,FontBase

	move.l		ScreenLock,WinScreen

	lea		Window1.3,a4
	lea		WinTags,a0
	move.w		FontY,d0
	mulu.w		#13,d0
	add.w		#36,d0
	move.l		d0,28(a0)	

	add.w		TopBorder,d0
	addq.w		#3,d0
	move.w		d0,6(a4)
	subq.w		#3,d0
	
	divu.w		#2,d0
	move.l		ScreenLock,a1
	move.w		sc_Height(a1),d1
	divu.w		#2,d1
	sub.w		d0,d1
	move.w		d1,14(a0)
	move.w		d1,2(a4)

	cmpi.w		#0,d1
	blt		FontTooBig

	move.l		Widest,d0
	mulu.w		#3,d0
	add.w		#84,d0
	move.l		WidLett,d1
	mulu.w		#4,d1
	add.w		d1,d0
	move.l		d0,20(a0)
	add.w		LeftBorder,d0
	add.w		LeftBorder,d0
	move.w		d0,4(a4)
	sub.w		LeftBorder,d0
	sub.w		LeftBorder,d0

	move.l		d0,WindowWidth

	move.l		d0,d6
	divu.w		#2,d0
	add.w		LeftBorder,d0
	move.w		sc_Width(a1),d1
	divu.w		#2,d1
	sub.w		d0,d1
	move.w		d1,6(a0)	
	move.w		d1,(a4)

	cmpi.w		#0,d1
	blt		FontTooBig

	move.l		d6,d0

CalcBm	lea		FakeBitmap,a0
	sub.w		#22,d0
	move.l		d0,DisplayWidth
	divu.w		#16,d0
	move.w		d0,d1
	andi.l 		#$0000FFFF,d1
	swap		d0
	cmpi.w		#0,d0
	beq.s		.skip
	addq.l		#1,d1

.skip	mulu		#2,d1				Don't know why, bitmap HAS to be word-
	move.w		d1,(a0)				aligned with even nr of words (?)
	move.w		FontY,d0
	mulu.w		#35,d0
	move.w		d0,bm_Rows(a0)
	andi.l 		#$0000FFFF,d0
	move.l		a0,a5

	mulu		d1,d0
	move.l		d0,FakeBmSize	
	move.l		#MEMF_CHIP!MEMF_CLEAR,d1
	CALLEXEC	AllocMem
	move.l		d0,FakeBmPtr
	beq		NoFakeBm
	
	move.l		d0,8(a5)
	
	move.l		FakeRast,a1
	lea		FakeBitmap,a0
	move.l		a0,rp_BitMap(a1)

	cmpi.w		#36,Execvers
	blt.s		.kickskip

	lea		0.w,a0				Open Window 2.0	
	lea		WinTags,a1
	CALLINT		OpenWindowTagList
	move.l		d0,WindowPtr
	beq		NoWin
	bra.s		.kickskip2
	
.kickskip
	lea		Window1.3,a0
	CALLINT		OpenWindow
	move.l		d0,WindowPtr
	beq		NoWin

.kickskip2
 	move.l		WindowPtr,a0
	move.l		wd_RPort(a0),WindowRastPort
	move.l		wd_UserPort(a0),WindowUserPort

	move.l		wd_WScreen(a0),a0
	lea		sc_ViewPort(a0),a0
	move.l		vp_ColorMap(a0),ScreenColorMap
	
	move.l		WindowPtr,a0
	move.l		wd_WScreen(a0),a0
	lea		sc_RastPort(a0),a0
	move.l		rp_BitMap(a0),a0
	moveq		#0,d0
	move.b		bm_Depth(a0),d0
	move.b		d0,ScreenDepth

	move.l		Font,a0
	move.l		WindowRastPort,a1
	CALLGRAF	SetFont	

	bsr		DoBorders			Bordersize
	bsr		DoWidths			Gadget widths
	bsr		DoPositions			Position gadgets
	bsr		InsertText			Put text in them
	bsr		CenterText			Center it
	bsr		GadCol

	lea		Gad29,a1			Add gadget 29 to the list
	lea		Gad28,a0
	move.l		a1,(a0)

	bsr		InitPropGad

	move.l		WindowPtr,a0			Draw gadgets
	lea		WinGads,a1
	moveq		#-1,d0
	moveq		#-1,d1
	move.w		#0,a2
	CALLINT		AddGList

	lea		WinGads,a0
	move.l		WindowPtr,a1
	move.w		#0,a2
	moveq		#-1,d0
	CALLINT		RefreshGList

	bsr		InitIndCoords
	bsr		SubRefresh

	bsr		DrawLogo
* Main core
	* was the prog started in auto-mode?
	
	tst.b		tt_AutoMatic
	bne		Gadg24


Mainloop move.l		WindowUserPort,a0
	CALLEXEC	WaitPort

Message	move.l		WindowUserPort,a0
	CALLEXEC	GetMsg
	tst.l		d0
	beq.s		Mainloop		; no more msgs
	
	move.l		d0,a1
	move.l		im_Class(a1),d2		; Soort msg
	move.l		im_IAddress(a1),a2	; naar gadget
	move.w		im_Code(a1),d3
	move.w		im_Qualifier(a1),d4
	CALLEXEC	ReplyMsg
	
	cmpi.l		#IDCMP_CLOSEWINDOW,d2	; close gadget ?
	beq.s		Quit
	
	cmpi.l		#IDCMP_GADGETUP,d2
	beq		Gadgets
	
	cmpi.l		#IDCMP_GADGETDOWN,d2
	beq		Slider

	cmpi.l		#IDCMP_ACTIVEWINDOW,d2
	beq		ToFront

	cmpi.l		#IDCMP_NEWSIZE,d2
	beq		Refresh

	cmpi.l		#IDCMP_VANILLAKEY,d2
	beq		KeyBoard

	cmpi.l		#IDCMP_RAWKEY,d2
	beq		KeyBoard2

	bra.s		Message

* Close down


Quit	move.l		WindowPtr,a0
	CALLINT		CloseWindow

NoWin	move.l		FakeBmSize,d0
	move.l		FakeBmPtr,a1
	CALLEXEC	FreeMem
NoFakeBm
	move.l		Font,a1
	CALLGRAF	CloseFont

NoFont
NoScLock
	move.l		DataSize,d0
	move.l		DataBuff,a1
	CALLEXEC	FreeMem

NoDataFile
	cmpi.l		#0,LangSize
	beq.s		.skip
	move.l		LangSize,d0
	move.l		LangBuff,a1
	CALLEXEC	FreeMem
.skip
NoLangFile
NoGuruBeen
	tst.b		tt_AutoMatic
	beq.s		.skip

	clr.l		$100.w

.skip	cmpi.w		#36,Execvers
	blt.s		.kickskip

	tst.l		ScreenLock
	beq.s		.kickskip

	lea		0.w,a0
	move.l		ScreenLock,a1
	CALLINT		UnlockPubScreen
.kickskip

	moveq		#120,d0
	move.l		FakeRast,a1
	CALLEXEC	FreeMem
NoFRast
	move.l		_DOSBase,a1
	CALLEXEC	CloseLibrary

NoDos	move.l		_GfxBase,a1
	CALLEXEC	CloseLibrary	

NoGfx	move.l		_IntuitionBase,a1
	CALLEXEC	CloseLibrary
	
NoInt	moveq		#0,d0
	rts

** Keyboard handling
KeyBoard
	cmpi.b		#'>',d3
	beq		KeyRight
	cmpi.b		#'.',d3
	beq		KeyRight
	
	cmpi.b		#'<',d3
	beq		KeyLeft
	cmpi.b		#',',d3
	beq		KeyLeft
	
	cmpi.b		#9,d3
	beq		KeySwitch

	cmpi.b		#'0',d3		0-9
	blt.s		.skip1
	cmpi.b		#'9',d3
	bgt.s		.skip1
	moveq		#0,d2	
	sub.b		#'0',d3
	addq.b		#1,d3
	move.b		d3,d2
	bra		PrGads

.skip1	cmpi.b		#'a',d3		Upper$
	blt.s		.skip2
	cmpi.b		#'z',d3
	bgt.s		.skip2
	moveq		#0,d2	
	sub.b		#32,d3

.skip2	cmpi.b		#'A',d3		A-F
	blt.s		.skip3
	cmpi.b		#'F',d3
	bgt.s		.skip3
	moveq		#0,d2	
	sub.b		#'A',d3
	add.b		#11,d3
	move.b		d3,d2
	bra		PrGads

.skip3	cmpi.b		#13,d3		Enter = search
	beq		KeyEnter

	lea		KeyGURU,a0
	move.l		(a0),a0
	move.b		(a0),d2
	cmp.b		d2,d3
	beq		Gadg23

	lea		KeyDEFAULT,a0
	move.l		(a0),a0
	move.b		(a0),d2
	cmp.b		d2,d3
	beq		Gadg26

	lea		KeyDOS,a0
	move.l		(a0),a0
	move.b		(a0),d2
	cmp.b		d2,d3
	beq		Gadg25

	lea		KeyLAST,a0
	move.l		(a0),a0
	move.b		(a0),d2
	cmp.b		d2,d3
	beq		Gadg24

	lea		KeyABOUT,a0
	move.l		(a0),a0
	move.b		(a0),d2
	cmp.b		d2,d3
	beq		Gadg28

	lea		KeyQUIT,a0
	move.l		(a0),a0
	move.b		(a0),d2
	cmp.b		d2,d3
	beq		Quit

	bra		Message


KeyBoard2
	cmpi.b		#78,d3
	beq.s		KeyRight
	
	cmpi.b		#79,d3
	beq.s		KeyLeft

	cmpi.b		#76,d3
	beq.s		KeyUp

	cmpi.b		#77,d3
	beq.s		KeyDown

	bra		Message
	

KeyLeft
	cmpi.b		#0,DosOffset		is guru display if true
	beq		Gadg17
	bra		Gadg19

KeyRight
	cmpi.b		#0,DosOffset
	beq		Gadg18
	bra		Gadg20

KeySwitch
	cmpi.b		#0,DosOffset
	beq		Gadg22
	bra		Gadg21

KeyEnter
	cmpi.b		#0,DosOffset
	beq		Gadg23
	bra		Gadg25

KeyUp	bsr		ScrollUp
	bra		Message

KeyDown	bsr		ScrollDown
	bra		Message

** Gadget handling (not slider!)
Gadgets	move.w		gg_GadgetID(a2),d2	Which gadget
	
PrGads	cmpi.w		#0,d2
	ble		Message

	cmpi.w		#17,d2
	blt.s		NumGad		


	cmpi.w		#17,d2
	beq		Gadg17
	cmpi.w		#18,d2
	beq		Gadg18
	cmpi.w		#19,d2
	beq		Gadg19
	cmpi.w		#20,d2
	beq		Gadg20

	cmpi.w		#21,d2
	beq		Gadg21
	cmpi.w		#22,d2
	beq		Gadg22

	cmpi.w		#23,d2
	beq		Gadg23

	cmpi.w		#24,d2
	beq		Gadg24
	cmpi.w		#25,d2
	beq		Gadg25
	cmpi.w		#26,d2
	beq		Gadg26

	cmpi.w		#27,d2
	beq		Quit

	cmpi.w		#28,d2
	beq		Gadg28

	bra		Message

NumGad	subq.w		#1,d2
	cmpi.b		#0,GuruOffset
	beq.s		.dosnum	

	cmpi.w		#10,d2
	bge.s		.hexgad

	lea		GuruString,a0
	moveq		#0,d0
	move.b		GuruOffset,d0
	subq.b		#1,d0
	add.l		d0,a0

	move.b		#'0',d0
	add.b		d2,d0
	move.b		d0,(a0)
	bra.s		Gadg18
	
.hexgad	sub.w		#10,d2
	lea		GuruString,a0
	moveq		#0,d0
	move.b		GuruOffset,d0
	subq.b		#1,d0
	add.l		d0,a0

	move.b		#'A',d0
	add.b		d2,d0
	move.b		d0,(a0)
	bra.s		Gadg18

.dosnum	lea		DosString,a0
	moveq		#0,d0
	move.b		DosOffset,d0
	subq.b		#1,d0
	add.l		d0,a0
	cmpi.w		#9,d2
	bgt		Message
	
	move.b		#'0',d0
	add.b		d2,d0
	move.b		d0,(a0)
	bra.s		Gadg20
	
Gadg17	bsr		ActiGur
	subq.b		#1,GuruOffset
	cmpi.b		#0,GuruOffset
	bne.s		.skip
	move.b		#8,GuruOffset
.skip	bsr		UpdGuru
	bra		Message	

Gadg18	bsr.s		ActiGur
	addq.b		#1,GuruOffset
	cmpi.b		#9,GuruOffset
	bne.s		.skip
	move.b		#1,GuruOffset
.skip	bsr		UpdGuru
	bra		Message	

Gadg19	bsr		ActiDos
	subq.b		#1,DosOffset
	cmpi.b		#0,DosOffset
	bne.s		.skip
	move.b		#3,DosOffset
.skip	bsr		UpdDos
	bra		Message	

Gadg20	bsr.s		ActiDos
	addq.b		#1,DosOffset
	cmpi.b		#4,DosOffset
	bne.s		.skip
	move.b		#1,DosOffset
.skip	bsr		UpdDos
	bra		Message	


Gadg21	bsr.s		ActiGur
	bra		Message

ActiGur	cmpi.b		#0,GuruOffset
	bne.s		.skip
	move.b		DosOffset,DosOffsetTemp
	move.b		GuruOffsetTemp,GuruOffset
	move.b		#0,DosOffset
	move.b		#0,GuruOffsetTemp
	bsr		UpdGuru
	bsr		UpdDos
.skip	rts

Gadg22	bsr.s		ActiDos
	bra		Message

ActiDos	cmpi.b		#0,DosOffset
	bne.s		.skip
	move.b		DosOffsetTemp,DosOffset
	move.b		GuruOffset,GuruOffsetTemp
	move.b		#0,DosOffsetTemp
	move.b		#0,GuruOffset
	bsr		UpdGuru
	bsr		UpdDos
.skip	rts

* retrieves last guru number from the system
Gadg24	* take care ! ... this function works on the current
	* line of amigas (tested upto 3.1)
	* it reads a long on location $100 which is system private ...
	* it may or may not continue to work in the future
	
	* it causes 1 enforcer hit , but don't worry
	* they are only reads , so they won't hurt the system

	move.l		$100.w,d0		Enforcer...
	move.l		d0,Temp

	lea		Temp,a0
	lea		GuruString,a1
	moveq		#3,d0

.loop	move.b		(a0)+,d1
	move.b		d1,d2			
	lsr.b		#4,d1

	andi.b		#$f,d1
	andi.b		#$f,d2
	
	cmpi.b		#9,d1
	ble.s		.norm1
	addq.b		#7,d1
.norm1	add.b		#'0',d1
	move.b		d1,(a1)+

	cmpi.b		#9,d2
	ble.s		.norm2
	addq.b		#7,d2
.norm2	add.b		#'0',d2
	move.b		d2,(a1)+

	dbf		d0,.loop
	
	bsr		UpdGuru

	tst.b		tt_AutoMatic
	bne		Gadg23

	bra		Message


Gadg28	bsr		InitPrint
	lea		AboutText,a0
	bsr		Print
	bsr		ResScr
	bra		Message			


Gadg26	moveq		#7,d0
	lea		GuruString,a0
.loop1	move.b		#'0',(a0)+
	dbf		d0,.loop1

	moveq		#2,d0
	lea		DosString,a0
.loop2	move.b		#'0',(a0)+
	dbf		d0,.loop2
	
	move.b		#1,GuruOffset
	move.b		#0,GuruOffsetTemp
	move.b		#0,DosOffset
	move.b		#1,DosOffsetTemp

	bsr		DrawLogo
	bsr		UpdGuru
	bsr		UpdDos
	bra		Message

Gadg25	** Search for DOS errors
	bsr		ActiDos
	bsr		InitPrint
	
	lea		DosString,a0
	lea		DosStringTemp,a1
	move.b		(a0)+,(a1)+
	move.b		(a0)+,(a1)+
	move.b		(a0)+,(a1)+
	
	lea		SDosString,a0
	move.l		DosAlert,a1
	move.l		EndOfFile,a2
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		.notfound	
	bsr		Print
	bsr		ResScr
	bra		Message
	
.notfound
	move.l		UnknownDos,a0
	bsr		Print		
	bsr		ResScr
	bra		Message
	
Gadg23	** Search for GURU errors
	bsr		ActiGur
	bsr		InitPrint
	
	lea		GuruString,a0
	lea		GuruStringTemp,a1
	lea		SHeaderString,a2

	moveq		#7,d0
.loop	move.b		(a0)+,d1
	move.b		d1,(a1)+
	move.b		d1,(a2)+
	dbf		d0,.loop

	lea		SGuruHeader,a0
	bsr		Print

	move.b		#0,FoundErr
	lea		GuruStringTemp,a1
	move.b		(a1),d0
	cmpi.b		#'@',d0
	blt.s		.nohex
	subi.b		#7,d0
.nohex	subi.b		#'0',d0
	move.b		d0,d1
	btst		#3,d1
	beq.s		.skippie
	move.b		#1,FoundErr	
.skippie
	and.b		#$7,d1
	add.b		#'0',d1
	move.b		d1,(a1)

	cmpi.b		#1,FoundErr
	beq.s		.skip
	move.l		Recovery,a0
	bsr		Print
	bra.s		.startsearch
.skip	move.l		Deadend,a0
	bsr		Print

.startsearch
	move.b		#0,FoundErr
	lea		SGuruString,a0
	move.l		GeneralAlert,a1
	move.l		Subsys1,a2
	bsr		Search

	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		.notfound	
	bsr		Print
	bsr		ResScr
	bra		Message
	
.notfound
	lea		GuruStringTemp,a1
	addq.l		#2,a1
	moveq		#5,d0
.ss1	move.b		#'0',(a1)+
	dbf		d0,.ss1
	
	lea		SGuruString,a0
	move.l		Subsys1,a1
	move.l		Subsys2,a2
	bsr		Search

	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		.notfound2	
	bsr		Print
	move.b		#1,FoundErr

.notfound2
	lea		GuruStringTemp,a1
	moveq		#7,d0
.ss2	move.b		#'0',(a1)+
	dbf		d0,.ss2
	
	lea		GuruString,a0
	lea		GuruStringTemp,a1
	addq.l		#2,a0
	addq.l		#2,a1
	move.b		(a0)+,(a1)+
	move.b		(a0)+,(a1)+

	lea		SGuruString,a0
	move.l		Subsys2,a1
	move.l		Subsys3,a2
	bsr		Search

	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		.notfound3	
	bsr		Print
	move.b		#1,FoundErr

.notfound3
	lea		GuruStringTemp,a1
	moveq		#7,d0
.ss3	move.b		#'0',(a1)+
	dbf		d0,.ss3
	
	lea		GuruString,a0
	lea		GuruStringTemp,a1
	addq.l		#4,a0
	addq.l		#4,a1
	move.b		(a0)+,(a1)+
	move.b		(a0)+,(a1)+
	move.b		(a0)+,(a1)+
	move.b		(a0)+,(a1)+

	lea		SGuruString,a0
	move.l		Subsys3,a1
	move.l		DosAlert,a2
	bsr		Search

	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		.notfound4	
	bsr.s		Print
	move.b		#1,FoundErr

.notfound4
	bsr		ResScr
	
	cmpi.b		#1,FoundErr
	beq		Message

	move.l		UnknownGuru,a0
	bsr.s		Print		
	bsr		ResScr
	bra		Message
	
* Pop window to front

ToFront	cmpi.b		#1,tt_AutoFront
	bne		Message
	move.l		WindowPtr,a0
	CALLINT		WindowToFront
	bra		Message

* Prints a node in the main window. Inputs a0 points to BEGIN of node (@NODE...)
* Na printen bsr ResScr
Print	move.l		a0,a5
	lea		EndNode,a0
	move.l		a5,a1
	move.l		a1,a2
	lea		3000(a2),a2	Search 3 K
	bsr		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		PrintError
	move.l		a0,d6		

.loop1	move.b		(a5)+,d0
	cmpi.b		#')',d0
	bne.s		.loop1
	
	move.l		a5,d5
	sub.l		d5,d6		Length of node text
	cmpi.l		#2560,d6
	bge.s		PrintError

	subq.l		#1,d6
	move.l		a5,a0
	lea		TempPrintBuff,a1	

.copyloop
	move.b		(a0)+,d0
	cmpi.b		#1,d0
	beq.s		.skip
	move.b		d0,(a1)+
.skip	dbf		d6,.copyloop
	move.b		#0,(a1)+

	bsr.s		ActualPrint
	rts
	
PrintError
	rts	
	
ActualPrint
	lea		TempPrintBuff,a5

	moveq		#1,d0
	move.l		FakeRast,a1
	CALLGRAF	SetAPen
	
.dloop	moveq		#0,d0
	moveq		#0,d1
	move.w		CursY,d1
	move.l		FakeRast,a1
	CALLGRAF	Move
	move.b		#0,Corrected

	moveq		#0,d4
	move.l		a5,a4	
.lengthloop
	move.b		(a4)+,d0
	addq.l		#1,d4
	
	cmpi.b		#10,d0
	beq		.maybelast10

	cmpi.b		#0,d0
	beq		.maybelast0
	bra.s		.lengthloop

.ret	move.l		FakeRast,a1
	move.l		a5,a0
	move.l		d4,d0
	CALLGRAF	TextLength
	move.l		DisplayWidth,d1
	cmp.l		d1,d0
	ble.s		.drukken
	
.wordback
	move.b		#1,Corrected
	subq.l		#1,a4
	subq.l		#1,d4
	cmpi.b		#' ',(a4)
	beq.s		.ret
	bra.s		.wordback
	
.drukken
	move.l		FakeRast,a1
	move.l		a5,a0
	move.l		d4,d0
	move.l		a4,a5
	CALLGRAF	Text
	cmpi.b		#1,Corrected
	bne.s		.skp
	move.w		FontY,d1
	add.w		d1,CursY

	moveq		#0,d0
	moveq		#0,d1
	move.w		CursY,d1
	move.w		FontY,d0
	mulu.w		#32,d0
	cmp.w		d0,d1
	bge.s		.oflo	

.skp	bra		.dloop					
	
.maybelast10
	cmpi.l		#1,d4
	bne.s		.notlast

	move.w		FontY,d1
	add.w		d1,CursY

	moveq		#0,d0
	moveq		#0,d1
	move.w		CursY,d1
	move.w		FontY,d0
	mulu.w		#32,d0
	cmp.w		d0,d1
	bge.s		.oflo	

	move.l		a4,a5
	bra		.dloop

.maybelast0
	cmpi.l		#1,d4
	bne.s		.notlast
	rts

.notlast
	subq.l		#1,a4
	subq.l		#1,d4
	bra		.ret
		
.oflo	rts

InitPrint
	bsr		ClrScr
	move.w		FontBase,d0
	move.w		d0,CursY
	rts
	
** Routines, subs and other useful stuff

NoDATAErr
	move.l		ErrDTXT,a0
	move.l		ErrDRTXT,a1
	lea		0.w,a3
	bsr		Req

	cmpi.l		#0,ScreenLock
	bne.s		.skip

	lea		0.w,a0
	move.l		ScreenLock,a1
	CALLINT		UnlockPubScreen

.skip	bra		NoDataFile

ErrInDATAErr
	move.l		ErrInDTXT,a0
	move.l		ErrInDRTXT,a1
	lea		0.w,a3
	bsr.s		Req

	cmpi.l		#0,ScreenLock
	bne.s		.skip

	lea		0.w,a0
	move.l		ScreenLock,a1
	CALLINT		UnlockPubScreen

.skip	bra		NoScLock


DecodeLF
	move.l		LangSize,d0
	subq.l		#1,d0
	move.l		LangBuff,a0
	lea		IDTXT,a1
	move.l		a0,(a1)+
.loop	move.b		(a0)+,d1
	cmpi.b		#10,d1
	bne.s		.skip
	move.b		#0,-1(a0)
	move.l		a0,(a1)+
.skip	dbf		d0,.loop
	rts


* Put up a requester, a0 points to string, a1 to answer string
*                     a3 points to args
* Returns with d0=result
Req	cmpi.w		#36,Execvers
	blt.s		.kickskip

	move.l		a0,ReqBody
	move.l		a1,ReqGad

	move.l		WindowPtr,a0		screen
	lea		ReqStruct,a1		Request struct
	move.w		#0,a2			No shared IDCMP
	CALLINT		EasyRequestArgs
.kickskip
	rts

* Get the length of a string in pixels
* Input: a0 -> string
* Output: d0 -> PixelLength 
TextLength
	moveq		#0,d1
	move.l		a0,a1
.loop	addq.l		#1,d1
	move.b		(a0)+,d0
	cmpi.b		#0,d0
	bne.s		.loop
	subq.l		#1,d1
	
	move.l		d1,d0
	move.l		a1,a0
	move.l		FakeRast,a1
	CALLGRAF	TextLength
	rts	

* Find widest bit of text
WidestText
	moveq		#0,d5
	lea		SetTXT,a5
	moveq		#6,d4
.loop	move.l		(a5)+,a0
	bsr.s		TextLength
	cmp.l		d5,d0
	ble.s		.skip
	move.l		d0,d5
.skip	dbf		d4,.loop
	move.l		d5,Widest
	rts	

* Find widest letter
WidestLetter
	moveq		#0,d5
	lea		Letters,a5
	moveq		#15,d4
.loop	move.l		a5,a0		

	moveq		#1,d0
	move.l		FakeRast,a1
	CALLGRAF	TextLength
	addq.l		#1,a5

	cmp.l		d5,d0
	ble.s		.skip
	move.l		d0,d5
.skip	dbf		d4,.loop
	move.l		d5,WidLett
	rts	

* Find widest arrow
WidestArrow
	moveq		#0,d5
	lea		Arrows,a5
	moveq		#1,d4
.loop	move.l		a5,a0		

	moveq		#1,d0
	move.l		FakeRast,a1
	CALLGRAF	TextLength
	addq.l		#1,a5

	cmp.l		d5,d0
	ble.s		.skip
	move.l		d0,d5
.skip	dbf		d4,.loop
	move.l		d5,WidArrow
	rts	


* Set gadget borders
DoBorders
	lea		SmallBrdDat,a0
	lea		SmallBrdDat2,a1
	
	move.l		WidLett,d0
	addq.w		#6,d0			d0=2+width+inh
	
	move.w		d0,(a0)
	move.w		d0,12(a1)
	move.w		d0,16(a1)
	
	addq.w		#1,d0			d0=3+width+inh
	move.w		d0,4(a1)
	move.w		d0,8(a1)
	
	moveq		#0,d0	
	move.w		FontY,d0
	addq.w		#2,d0			d0=high
	
	move.w		d0,18(a0)
	move.w		d0,14(a1)
	
	addq.w		#1,d0			d0=high+1
	move.w		d0,10(a0)
	move.w		d0,2(a1)
	move.w		d0,6(a1)

	lea		MediumBrdDat,a0
	lea		MediumBrdDat2,a1
	
	move.l		WidArrow,d0
	addq.w		#6,d0			d0=2+width+inh
	
	move.w		d0,(a0)
	move.w		d0,12(a1)
	move.w		d0,16(a1)
	
	addq.w		#1,d0			d0=3+width+inh
	move.w		d0,4(a1)
	move.w		d0,8(a1)
	
	moveq		#0,d0	
	move.w		FontY,d0
	addq.w		#2,d0			d0=high
	
	move.w		d0,18(a0)
	move.w		d0,14(a1)
	
	addq.w		#1,d0			d0=high+1
	move.w		d0,10(a0)
	move.w		d0,2(a1)
	move.w		d0,6(a1)


	move.l		SetTXT,a0
	bsr		TextLength
	andi.l 		#$0000FFFF,d0
	
	lea		SetBrdDat,a0
	lea		SetBrdDat2,a1
	
	addq.w		#6,d0			d0=2+width+inh
	
	move.w		d0,(a0)
	move.w		d0,12(a1)
	move.w		d0,16(a1)
	
	addq.w		#1,d0			d0=3+width+inh
	move.w		d0,4(a1)
	move.w		d0,8(a1)
	
	moveq		#0,d0	
	move.w		FontY,d0
	addq.w		#2,d0			d0=high
	
	move.w		d0,18(a0)
	move.w		d0,14(a1)
	
	addq.w		#1,d0			d0=high+1
	move.w		d0,10(a0)
	move.w		d0,2(a1)
	move.w		d0,6(a1)

	lea		BigBrdDat,a0
	lea		BigBrdDat2,a1
	
	move.l		Widest,d0
	addq.w		#6,d0			d0=2+width+inh
	
	move.w		d0,(a0)
	move.w		d0,12(a1)
	move.w		d0,16(a1)
	
	addq.w		#1,d0			d0=3+width+inh
	move.w		d0,4(a1)
	move.w		d0,8(a1)
	
	moveq		#0,d0	
	move.w		FontY,d0
	addq.w		#2,d0			d0=high
	
	move.w		d0,18(a0)
	move.w		d0,14(a1)
	
	addq.w		#1,d0			d0=high+1
	move.w		d0,10(a0)
	move.w		d0,2(a1)
	move.w		d0,6(a1)

	lea		DispBrdDat,a0
	lea		DispBrdDat2,a1
	
	move.l		Widest,d0
	add.w		#30,d0			d0=2+width+inh
	move.l		WidLett,d1
	mulu.w		#2,d1
	add.w		d1,d0

	move.w		d0,(a0)
	move.w		d0,12(a1)
	move.w		d0,16(a1)
	
	addq.w		#1,d0			d0=3+width+inh
	move.w		d0,4(a1)
	move.w		d0,8(a1)
	
	moveq		#0,d0	
	move.w		FontY,d0
	addq.w		#2,d0			d0=high
	
	move.w		d0,18(a0)
	move.w		d0,14(a1)
	
	addq.w		#1,d0			d0=high+1
	move.w		d0,10(a0)
	move.w		d0,2(a1)
	move.w		d0,6(a1)

	lea		MainBrdDat,a0
	lea		MainBrdDat2,a1
	
	move.l		WindowWidth,d0
	subq.w		#6,d0			d0=winwidth-something

	move.w		d0,(a0)
	move.w		d0,12(a1)
	move.w		d0,16(a1)
	
	addq.w		#1,d0			
	move.w		d0,4(a1)
	move.w		d0,8(a1)
	
	moveq		#0,d0	
	move.w		FontY,d0
	mulu.w		#8,d0
	addq.w		#4,d0			d0=high
	
	move.w		d0,18(a0)
	move.w		d0,14(a1)
	
	addq.w		#1,d0			d0=high+1
	move.w		d0,10(a0)
	move.w		d0,2(a1)
	move.w		d0,6(a1)
	rts	

* Set gadget widths and heights
DoWidths
	move.l		WidLett,d0
	addq.w		#8,d0
	moveq		#0,d1
	move.w		FontY,d1
	addq.w		#4,d1

	moveq		#15,d2
	lea		Gad01,a0
.loop	move.w		d0,gg_Width(a0)
	move.w		d1,gg_Height(a0)
	
	move.l		(a0),a0			gg_NextGadget
	dbf		d2,.loop

Arrows	move.l		WidArrow,d0
	addq.w		#8,d0
	moveq		#0,d1
	move.w		FontY,d1
	addq.w		#4,d1

	moveq		#3,d2
	lea		Gad17,a0
.loop	move.w		d0,gg_Width(a0)
	move.w		d1,gg_Height(a0)
	
	move.l		(a0),a0			gg_NextGadget
	dbf		d2,.loop

Sets	move.l		SetTXT,a0
	bsr		TextLength
	andi.l 		#$0000FFFF,d0
	addq.w		#8,d0
	moveq		#0,d1
	move.w		FontY,d1
	addq.w		#4,d1

	moveq		#1,d2
	lea		Gad21,a0
.loop	move.w		d0,gg_Width(a0)
	move.w		d1,gg_Height(a0)
	
	move.l		(a0),a0			gg_NextGadget
	dbf		d2,.loop

Bigs	move.l		Widest,d0
	addq.w		#8,d0
	moveq		#0,d1
	move.w		FontY,d1
	addq.w		#4,d1

	moveq		#5,d2
	lea		Gad23,a0
.loop	move.w		d0,gg_Width(a0)
	move.w		d1,gg_Height(a0)
	
	move.l		(a0),a0			gg_NextGadget
	dbf		d2,.loop
	rts					

* Set gadget positions
DoPositions
	moveq		#2,d0
	lea		Gad21,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad23,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad24,a0
	move.w		d0,gg_LeftEdge(a0)
	add.w		#14,d0
	add.l		Widest,d0		X1=breedstetekst+12
	lea		Gad13,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad09,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad05,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad01,a0
	move.w		d0,gg_LeftEdge(a0)
	add.w		#10,d0
	add.l		WidLett,d0		X2=x1+breedsteletter+10
	lea		Gad14,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad10,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad06,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad02,a0
	move.w		d0,gg_LeftEdge(a0)
	add.w		#10,d0
	add.l		WidLett,d0
	lea		Gad15,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad11,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad07,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad03,a0
	move.w		d0,gg_LeftEdge(a0)
	add.w		#10,d0
	add.l		WidLett,d0
	lea		Gad16,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad12,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad08,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad04,a0
	move.w		d0,gg_LeftEdge(a0)
	add.w		#14,d0
	add.l		WidLett,d0
	lea		Gad19,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad25,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad26,a0
	move.w		d0,gg_LeftEdge(a0)
	add.w		#14,d0
	add.l		Widest,d0
	lea		Gad27,a0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad28,a0
	move.w		d0,gg_LeftEdge(a0)


	moveq		#0,d0
	move.w		FontY,d0
	mulu.w		#8,d0	
	add.w		#10,d0
	lea		Gad27,a0
	move.w		d0,gg_TopEdge(a0)
	add.w		FontY,d0
	addq.w		#5,d0
	lea		Gad13,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad14,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad15,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad16,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad21,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad22,a0
	move.w		d0,gg_TopEdge(a0)
	add.w		FontY,d0
	addq.w		#5,d0
	lea		Gad09,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad10,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad11,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad12,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad17,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad18,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad19,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad20,a0
	move.w		d0,gg_TopEdge(a0)
	add.w		FontY,d0
	addq.w		#5,d0
	lea		Gad05,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad06,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad07,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad08,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad23,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad25,a0
	move.w		d0,gg_TopEdge(a0)
	add.w		FontY,d0
	addq.w		#5,d0
	lea		Gad01,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad02,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad03,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad04,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad24,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad26,a0
	move.w		d0,gg_TopEdge(a0)
	lea		Gad28,a0
	move.w		d0,gg_TopEdge(a0)

	lea		Gad19,a0
	move.w		gg_LeftEdge(a0),d1
	move.w		gg_Width(a0),d0
	add.w		d1,d0
	addq.w		#2,d0
	lea		Gad20,a0
	move.w		d0,gg_LeftEdge(a0)

	lea		Gad09,a0
	move.w		gg_LeftEdge(a0),d0
	lea		Gad18,a0
	move.w		gg_Width(a0),d1
	sub.w		d1,d0
	subq.w		#6,d0
	move.w		d0,gg_LeftEdge(a0)
	lea		Gad17,a0
	sub.w		d1,d0
	subq.w		#2,d0
	move.w		d0,gg_LeftEdge(a0)

	lea		Gad27,a0
	move.w		gg_LeftEdge(a0),d0
	lea		Gad22,a0
	move.w		gg_Width(a0),d1
	sub.w		d1,d0
	subq.w		#6,d0
	move.w		d0,gg_LeftEdge(a0)

	lea		WinGads,a0

.loop	move.w		gg_TopEdge(a0),d0
	add.w		TopBorder,d0
	move.w		d0,gg_TopEdge(a0)
	move.w		gg_LeftEdge(a0),d0
	add.w		LeftBorder,d0
	move.w		d0,gg_LeftEdge(a0)

	move.l		(a0),d0
	cmpi.l		#0,d0
	beq.s		.done
	move.l		(a0),a0				gg_NextGadget
	bra.s		.loop
		
.done	rts

* Center gadget text
CenterText
	lea		WinGads,a0

.loop	move.l		a0,a5
	move.l		gg_GadgetText(a0),a1

	cmpi.b		#1,tt_Topaz
	bne.s		.skip
	lea		Topaz,a6
	move.l		a6,it_ITextFont(a1)

.skip	move.l		it_IText(a1),a0
	bsr		TextLength
	andi.l 		#$0000FFFF,d0
	divu.w		#2,d0
	move.l		d0,d3				d3=halve breedte
	
	move.w		FontY,d0
	andi.l 		#$0000FFFF,d0
	divu.w		#2,d0
	move.l		d0,d4				d4=halve hoogte	
	
	move.l		a5,a0
	moveq		#0,d0
	moveq		#0,d1
	move.w		gg_Width(a0),d0
	move.w		gg_Height(a0),d1
	divu.w		#2,d0
	divu.w		#2,d1

	sub.w		d3,d0
	sub.w		d4,d1

	move.l		gg_GadgetText(a0),a1
	move.w		d0,it_LeftEdge(a1)
	move.w		d1,it_TopEdge(a1)	
		
	move.l		(a0),d0
	cmpi.l		#0,d0
	beq.s		.done
	move.l		(a0),a0				gg_NextGadget
	bra.s		.loop
		
.done	rts

* Set text of gadgets
InsertText
	lea		Gad21Txt,a0
	move.l		SetTXT,it_IText(a0)

	lea		Gad23Txt,a0
	move.l		GuruTXT,it_IText(a0)
	lea		Gad24Txt,a0
	move.l		LastTXT,it_IText(a0)
	lea		Gad25Txt,a0
	move.l		DosTXT,it_IText(a0)
	lea		Gad26Txt,a0
	move.l		DefaultTXT,it_IText(a0)
	lea		Gad27Txt,a0
	move.l		QuitTXT,it_IText(a0)
	lea		Gad28Txt,a0
	move.l		InfoTXT,it_IText(a0)
	rts

* Refresh window on a resize
Refresh
	move.l		WindowPtr,a0		Window sized bigger ?
	move.w		wd_Width(a0),d0
	andi.l 		#$0000FFFF,d0
	cmp.l		WindowWidth,d0
	blt		Message
	bsr.s		SubRefresh
	bra		Message

SubRefresh
	moveq		#0,d0
	move.b		DarkPen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	lea		Gad27,a5
	move.w		gg_LeftEdge(a5),d0
	move.w		gg_TopEdge(a5),d1
	subq.w		#4,d0
	move.l		WindowRastPort,a1
	CALLGRAF	Move
	lea		Gad28,a5
	move.w		gg_LeftEdge(a5),d0
	move.w		gg_TopEdge(a5),d1
	subq.w		#4,d0
	move.w		gg_Height(a5),d2
	add.w		d2,d1
	subq.w		#1,d1
	move.l		WindowRastPort,a1
	CALLGRAF	Draw

	moveq		#0,d0
	move.b		ShinePen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	lea		Gad27,a5
	move.w		gg_LeftEdge(a5),d0
	move.w		gg_TopEdge(a5),d1
	subq.w		#3,d0
	move.l		WindowRastPort,a1
	CALLGRAF	Move
	lea		Gad28,a5
	move.w		gg_LeftEdge(a5),d0
	move.w		gg_TopEdge(a5),d1
	subq.w		#3,d0
	move.w		gg_Height(a5),d2
	add.w		d2,d1
	subq.w		#1,d1
	move.l		WindowRastPort,a1
	CALLGRAF	Draw

	move.l		Indicator1X,d0
	move.l		Indicator1Y,d1
	move.l		WindowRastPort,a0
	lea		DispBorder,a1
	CALLINT		DrawBorder
	
	move.l		Indicator2X,d0
	move.l		Indicator2Y,d1
	move.l		WindowRastPort,a0
	lea		DispBorder,a1
	CALLINT		DrawBorder

	moveq		#2,d0
	moveq		#2,d1
	add.w		LeftBorder,d0
	add.w		TopBorder,d1
	move.l		WindowRastPort,a0
	lea		MainBorder,a1
	CALLINT		DrawBorder

	bsr		UpdGuru
	bsr		UpdDos
	bsr		RefMain
	rts		

* InitIndCoords
InitIndCoords
	lea		Gad27,a5
	move.w		gg_TopEdge(a5),d1
	andi.l 		#$0000FFFF,d1
	moveq		#2,d0
	add.w		LeftBorder,d0
	move.l		d0,Indicator1X
	move.l		d1,Indicator1Y

	lea		Gad27,a5
	move.w		gg_TopEdge(a5),d1
	andi.l 		#$0000FFFF,d1
	lea		Gad15,a5
	move.w		gg_LeftEdge(a5),d0
	andi.l 		#$0000FFFF,d0
	move.l		d0,Indicator2X
	move.l		d1,Indicator2Y
	rts

* Initialize slider
InitPropGad
	lea		Gad29,a0

	move.w		FontY,d0
	mulu.w		#8,d0
	addq.w		#4,d0
	move.w		d0,gg_Height(a0)
	
	lea		Gad27,a1
	move.w		gg_LeftEdge(a1),d0
	move.w		gg_Width(a1),d1
	add.w		d1,d0
	sub.w		#12,d0
	move.w		d0,gg_LeftEdge(a0)

	moveq		#3,d0
	add.w		TopBorder,d0
	move.w		d0,gg_TopEdge(a0)
	rts
		 
* Clear Temporary screen
ClrScr	moveq		#0,d0
	move.l		FakeRast,a1
	CALLGRAF	SetRast
	rts

* Reset Display in Guru window
* = slider to zero, copy contents of temp to display.
ResScr	lea		Gad29,a0
	move.l		WindowPtr,a1
	lea		0.w,a2
	move.w		#AUTOKNOB!FREEVERT!PROPNEWLOOK,d0
	moveq		#0,d1
	moveq		#0,d2
	move.w		#-1,d3
	move.w		#16384,d4
	moveq		#1,d5
	CALLINT		NewModifyProp
	bsr		RefMain
	rts

ScrollUp
	lea		PropInfo29,a0
	moveq		#0,d1
	move.w		pi_VertPot(a0),d1		SY
	cmpi.l		#3000,d1
	blt.s		.skip
	sub.w		#3000,d1
	move.l		d1,d2
	bra.s		.upd
.skip	moveq		#0,d2
.upd	lea		Gad29,a0
	move.l		WindowPtr,a1
	lea		0.w,a2
	move.w		#AUTOKNOB!FREEVERT!PROPNEWLOOK,d0
	moveq		#0,d1
	move.w		#-1,d3
	move.w		#16384,d4
	moveq		#1,d5
	CALLINT		NewModifyProp
	bsr.s		RefMain
	rts

ScrollDown
	lea		PropInfo29,a0
	moveq		#0,d1
	move.w		pi_VertPot(a0),d1		SY
	cmpi.l		#62535,d1
	bgt.s		.skip
	add.w		#3000,d1
	move.l		d1,d2
	bra.s		.upd
.skip	move.w		#$FFFF,d2
.upd	lea		Gad29,a0
	move.l		WindowPtr,a1
	lea		0.w,a2
	move.w		#AUTOKNOB!FREEVERT!PROPNEWLOOK,d0
	moveq		#0,d1
	move.w		#-1,d3
	move.w		#16384,d4
	moveq		#1,d5
	CALLINT		NewModifyProp
	bsr.s		RefMain
	rts

* Copy contents of temp. image to main display
RefMain	move.l		#65536,d0
	move.w		FontY,d1
	andi.l 		#$0000FFFF,d1
	mulu.w		#24,d1
	divu.w		d1,d0				D0=offspp
	moveq		#0,d7
	move.w		d0,d7				D7=offspp
	
	moveq		#0,d0				SX
	moveq		#0,d0
	lea		PropInfo29,a0
	moveq		#0,d1
	move.w		pi_VertPot(a0),d1		SY
	divu.w		d7,d1
	swap 		d0
	move.w		#0,d0
	swap		d0
		
	moveq		#5,d2
	add.w		LeftBorder,d2			DX
	moveq		#5,d3
	add.w		TopBorder,d3			DY

	move.l		DisplayWidth,d4			SiX

	move.w		FontY,d5
	mulu.w		#8,d5
	andi.l 		#$0000FFFF,d5			SiY
	
	lea		FakeBitmap,a0
	move.l		WindowRastPort,a1
	
	moveq		#0,d0
	move.b		#$C0,d6
	CALLGRAF	BltBitMapRastPort
	rts		
	
* DrawLogo
DrawLogo
	bsr		ClrScr
	move.l		FakeRast,a0
	lea		GuruLogoImg,a1

	move.l		DisplayWidth,d0
	divu.w		#2,d0
	sub.w		#103,d0
	cmpi.w		#0,d0
	blt.s		.done	
	andi.l		#$0000FFFF,d0	

	moveq		#0,d1
	move.w		FontY,d1	
	mulu.w		#4,d1
	sub.w		#25,d1
	cmpi.w		#0,d1
	blt.s		.done	
	andi.l		#$0000FFFF,d1	

	CALLINT		DrawImage

.done	bsr		ResScr
	rts

* Slider movements update
Slider	move.w		gg_GadgetID(a2),d2		Which gadget
	cmpi.w		#29,d2
	bne		Message				Not da slider

.loop	CALLGRAF	WaitTOF
	bsr		RefMain	

	move.l		WindowUserPort,a0
	CALLEXEC	WaitPort

.msg	move.l		WindowUserPort,a0
	CALLEXEC	GetMsg
	tst.l		d0
	beq.s		.loop
	
	move.l		d0,a1
	move.l		im_Class(a1),d2		; Soort msg
	move.l		im_IAddress(a1),a2	; naar gadget
	CALLEXEC	ReplyMsg
	
	cmpi.l		#IDCMP_GADGETUP,d2
	beq.s		.Released
	
	bra.s		.msg

.Released
	bra		Message

* Update Guru display
UpdGuru	moveq		#0,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	
	move.l		Indicator1X,d0
	move.l		Indicator1Y,d1
	addq.l		#2,d0
	addq.l		#1,d1

	lea		DispBrdDat,a0
	move.w		(a0),d2	
	andi.l		#$0000FFFF,d2
	subq.l		#3,d2
	add.l		d0,d2

	move.l		d0,d6
	move.l		d2,d7

	move.l		d1,d3
	add.w		FontY,d3
	addq.l		#1,d3
	move.l		WindowRastPort,a1
	CALLGRAF	RectFill
	
	lea		GuruString,a0
	bsr		TextLength
	
	sub.l		d6,d7
	divu.w		#2,d7
	divu.w		#2,d0
	andi.l		#$0000FFFF,d0
	andi.l		#$0000FFFF,d7
	sub.l		d0,d7
	
	move.l		d7,d0
	add.l		Indicator1X,d0
	addq.l		#2,d0
	move.l		Indicator1Y,d1
	addq.l		#2,d1
	add.w		FontBase,d1

	move.l		WindowRastPort,a1
	CALLGRAF	Move

	moveq		#0,d0
	move.b		DarkPen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	
	moveq		#7,d7
	moveq		#0,d6
	lea		GuruString,a5
.loop	addq.w		#1,d6
	move.b		GuruOffset,d5
	cmp.b		d6,d5
	beq.s		.skip
	bra.s		.skip2	

.skip	moveq		#0,d0
	move.b		ShinePen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	bra.s		.skip3	

.skip2	moveq		#0,d0
	move.b		DarkPen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen

.skip3	move.l		WindowRastPort,a1
	move.l		a5,a0
	moveq		#1,d0
	CALLGRAF	Text

	addq.l		#1,a5	
	dbf		d7,.loop
	rts

* Update Dos display
UpdDos	moveq		#0,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	
	move.l		Indicator2X,d0
	move.l		Indicator2Y,d1
	addq.l		#2,d0
	addq.l		#1,d1

	lea		DispBrdDat,a0
	move.w		(a0),d2	
	andi.l		#$0000FFFF,d2
	subq.l		#3,d2
	add.l		d0,d2

	move.l		d0,d6
	move.l		d2,d7

	move.l		d1,d3
	add.w		FontY,d3
	addq.l		#1,d3
	move.l		WindowRastPort,a1
	CALLGRAF	RectFill
	
	lea		DosString,a0
	bsr		TextLength
	
	sub.l		d6,d7
	divu.w		#2,d7
	divu.w		#2,d0
	andi.l		#$0000FFFF,d0
	andi.l		#$0000FFFF,d7
	sub.l		d0,d7
	
	move.l		d7,d0
	add.l		Indicator2X,d0
	addq.l		#2,d0
	move.l		Indicator2Y,d1
	addq.l		#2,d1
	add.w		FontBase,d1

	move.l		WindowRastPort,a1
	CALLGRAF	Move

	moveq		#0,d0
	move.b		DarkPen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	
	moveq		#2,d7
	moveq		#0,d6
	lea		DosString,a5
.loop	addq.w		#1,d6
	move.b		DosOffset,d5
	cmp.b		d6,d5
	beq.s		.skip
	bra.s		.skip2	

.skip	moveq		#0,d0
	move.b		ShinePen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen
	bra.s		.skip3	

.skip2	moveq		#0,d0
	move.b		DarkPen,d0
	move.l		WindowRastPort,a1
	CALLGRAF	SetAPen

.skip3	move.l		WindowRastPort,a1
	move.l		a5,a0
	moveq		#1,d0
	CALLGRAF	Text

	addq.l		#1,a5	
	dbf		d7,.loop
	rts

* Search for a given text string
* Note: THIS IS CASE SENSITIVE
* Inputs: a0 -> string, ends with $0
*	  a1 -> startaddress
*	  a2 -> end address
* Output: a0 -> address of BEGIN of string
*	  a1 -> address at END of string
*	  if not found, a0 = 0
Search	movem.l		d0-d3/a2-a4,-(SP)
	moveq		#0,d0
	move.l		a0,a4
.loop	move.b		(a4)+,d1
	addq.l		#1,d0
	cmpi.b		#0,d1
	bne.s		.loop
	subq.l		#2,d0		d0 contains string length-1
	
.loop2	move.l		d0,d1		Init match loop
	move.l		a0,a3
	move.l		a1,a4
	
.loop3	move.b		(a3)+,d2
	move.b		(a4)+,d3
	cmp.b		d2,d3
	bne.s		.nomatch
	dbf		d1,.loop3
	bra.s		.found
	
.nomatch
	addq.l		#1,a1		Search from next char
	
	move.l		a2,d2
	move.l		a1,d3
	cmp.l		d2,d3
	beq.s		.notfound
	bra.s		.loop2

.found	move.l		a1,a0
	move.l		a4,a1
	movem.l		(SP)+,d0-d3/a2-a4
	rts
	
.notfound
	lea		0.w,a0
	lea		0.w,a1
	movem.l		(SP)+,d0-d3/a2-a4
	rts
	
* Filter all bit 31's from data file guru nums
* Alter texts to s'th' printable
FilterFile
	move.l		GeneralAlert,a1		
	move.l		DosAlert,a2

.loop	lea		Node,a0
	bsr.s		Search
	move.l		a0,d0
	cmpi.l		#0,d0
	beq.s		.done

	move.b		(a1),d0
	cmpi.b		#'@',d0
	blt.s		.nohex
	subi.b		#7,d0
.nohex	subi.b		#'0',d0
	move.b		d0,d1
	and.b		#$7,d1
	add.b		#'0',d1
	move.b		d1,(a1)
	
	bra.s		.loop
	
.done	move.l		DataBuff,a0
	move.l		DataSize,d0
	subq.l		#1,d0		
.loop2	move.b		(a0),d1
	cmpi.b		#10,d1			Erase all lf's
	beq.s		.wis1
	addq.l		#1,a0
	dbf		d0,.loop2
	bra.s		.done2
.wis1	move.b		#1,(a0)+		Code must not print chr$(1) !!
	dbf		d0,.loop2			

.done2	move.l		DataBuff,a0
	move.l		DataSize,d0
	subq.l		#1,d0		
.loop3	move.b		(a0),d1
	move.b		1(a0),d2
	cmpi.b		#'\',d1			Erase all newlines & replace them
	beq.s		.wis2
	addq.l		#1,a0
	dbf		d0,.loop3
	bra.s		.done3

.wis2	cmpi.b		#'n',d2
	beq.s		.wis3
	addq.l		#1,a0
	dbf		d0,.loop3
	bra.s		.done3
	
.wis3	move.b		#1,(a0)+
	move.b		#10,(a0)
	dbf		d0,.loop3

.done3	rts


* Modify gadget structures according to colormap
* -> correct 3d look on ALL systems (?)
GadCol	cmpi.b		#1,ScreenDepth
	beq		.scheme2

	move.l		ScreenColorMap,a0	Get RGB values of pen 1 & 2
	moveq		#1,d0
	CALLGRAF	GetRGB4
	moveq		#0,d1
	move.w		d0,d1

	divu		#256,d1
	move.w		d1,d4
	move.w		#0,d1
	swap 		d1

	divu		#16,d1
	move.w		d1,d5
	move.w		#0,d1
	swap 		d1
	move.w		d1,d6
	
	moveq		#0,d0
	add.w		d4,d0
	add.w		d5,d0
	add.w		d6,d0
	divu		#3,d0
	move.w		d0,d2
	
	move.l		ScreenColorMap,a0
	moveq		#2,d0
	CALLGRAF	GetRGB4
	moveq		#0,d1
	move.w		d0,d1

	divu		#256,d1
	move.w		d1,d4
	move.w		#0,d1
	swap 		d1

	divu		#16,d1
	move.w		d1,d5
	move.w		#0,d1
	swap 		d1
	move.w		d1,d6
	
	moveq		#0,d0
	add.w		d4,d0
	add.w		d5,d0
	add.w		d6,d0
	divu		#3,d0
	move.w		d0,d3
	
	cmp.b		d2,d3
	bgt.s		.scheme1
	
	moveq		#1,d2
	moveq		#2,d3
	bra.s		.domod
	
.scheme1 moveq		#2,d2
	moveq		#1,d3
	bra.s		.domod
	
.scheme2 moveq		#1,d2
	moveq		#1,d3
	
.domod	move.b		d2,ShinePen
	move.b		d3,DarkPen

	lea		WinGads,a0		Modify structures
.loop	move.l		gg_GadgetRender(a0),a1
	move.b		d2,bd_FrontPen(a1)
	move.l		bd_NextBorder(a1),a1
	move.b		d3,bd_FrontPen(a1)

	move.l		gg_SelectRender(a0),a1
	move.b		d3,bd_FrontPen(a1)
	move.l		bd_NextBorder(a1),a1
	move.b		d2,bd_FrontPen(a1)
	
	move.l		(a0),d0
	cmpi.l		#0,d0
	beq.s		.done1
	move.l		(a0),a0
	bra.s		.loop
		
.done1	lea		DispBorder,a1
	move.b		d3,bd_FrontPen(a1)
	move.l		bd_NextBorder(a1),a1
	move.b		d2,bd_FrontPen(a1)

	lea		MainBorder,a1
	move.b		d3,bd_FrontPen(a1)
	move.l		bd_NextBorder(a1),a1
	move.b		d2,bd_FrontPen(a1)

	cmp.b		#1,ScreenDepth
	bne.s		.done2

	lea		WinGads,a0		
.loop2	move.w		#GFLG_GADGHCOMP,gg_Flags(a0)

	move.l		(a0),d0
	cmpi.l		#0,d0
	beq.s		.done2
	move.l		(a0),a0
	bra.s		.loop2
		
.done2	rts	

** EMERGENCY, window too big, force topaz
FontTooBig
	cmpi.w		#36,Execvers
	blt.s		.kickskip

	lea		0.w,a0
	move.l		ScreenLock,a1
	CALLINT		UnlockPubScreen
.kickskip
	move.l		Font,a1
	CALLGRAF	CloseFont
	move.b		#1,tt_Topaz
	bra		CliStart


	include		/subs/loadfileallmem.s

_DOSBase	dc.l	0

	SECTION DataZone,Data

taggie		dc.l	WA_Left,100
		dc.l	WA_Top,50
		dc.l	WA_InnerWidth,344
		dc.l	WA_InnerHeight,176
		dc.l	TAG_DONE

ReqStruct	dc.l	EasyStruct_SIZEOF
		dc.l	0
		dc.l	ReqTitle
ReqBody		dc.l	0
ReqGad		dc.l	0

WinTags		dc.l	WA_Left,0
		dc.l	WA_Top,0
		dc.l	WA_InnerWidth,0
		dc.l	WA_InnerHeight,0
		dc.l	WA_Title,WinTitle
		dc.l	WA_ScreenTitle,ScrTitle
		dc.l	WA_IDCMP,IDCMP_GADGETUP!IDCMP_GADGETDOWN!IDCMP_CLOSEWINDOW!IDCMP_ACTIVEWINDOW!IDCMP_NEWSIZE!IDCMP_VANILLAKEY!IDCMP_MOUSEMOVE!IDCMP_RAWKEY
		dc.l	WA_AutoAdjust,-1
		dc.l	WA_CloseGadget,-1
		dc.l	WA_DragBar,-1
		dc.l	WA_Activate,-1
		dc.l	WA_SmartRefresh,-1
		dc.l	WA_DepthGadget,-1
		dc.l	WA_Zoom,ZoomSize
		dc.l	WA_RMBTrap,-1
		dc.l	WA_NoCareRefresh,-1
		dc.l	WA_PubScreen
WinScreen	dc.l	0
		dc.l	TAG_DONE

Window1.3	dc.w	0,0
		dc.w	0,0
		dc.b	0,1
		dc.l	IDCMP_GADGETUP!IDCMP_CLOSEWINDOW!IDCMP_ACTIVEWINDOW!IDCMP_GADGETDOWN!IDCMP_VANILLAKEY!IDCMP_MOUSEMOVE
		dc.l	WFLG_CLOSEGADGET!WFLG_DRAGBAR!WFLG_DEPTHGADGET!WFLG_RMBTRAP!WFLG_NOCAREREFRESH
		dc.l	0
		dc.l	0
		dc.l	WinTitle
		dc.l	0
		dc.l	0
		dc.w	0,0,0,0
		dc.w	WBENCHSCREEN

IDTXT		dc.l	0
ByTXT		dc.l	0
Dummy1		dc.l	0
SetTXT		dc.l	SetTXTDat
GuruTXT		dc.l	GuruTXTDat
LastTXT		dc.l	LastTXTDat
DefaultTXT	dc.l	DefaultTXTDat
DosTXT		dc.l	DosTXTDat
InfoTXT		dc.l	InfoTXTDat
QuitTXT		dc.l	QuitTXTDat
Dummy2		dc.l	0
ErrDTXT		dc.l	ErrDTXTDat
ErrDRTXT	dc.l	ErrDRTXTDat
ErrInDTXT	dc.l	ErrInDTXTDat
ErrInDRTXT	dc.l	ErrInDRTXTDat
KeyGURU		dc.l	KeyGURUKey
KeyLAST		dc.l	KeyLASTKey
KeyDEFAULT	dc.l	KeyDEFAULTKey
KeyDOS		dc.l	KeyDOSKey
KeyABOUT	dc.l	KeyABOUTKey
KeyQUIT		dc.l	KeyQUITKey
Dummy3		dc.l	0
Dummy4		dc.l	0

ZoomSize	dc.w	50
		dc.w	0
		dc.w	200
TopBorder	dc.w	0

FakeBitmap	dc.w    0
		dc.w    0
		dc.b	0
		dc.b	1
		dc.w	0
		dc.l	0
		
Topaz		dc.l	TopazFont
		dc.w	8
		dc.b	0
		dc.b	1
		
GuruOffset	dc.b	1
DosOffsetTemp	dc.b	1

WinTitle	dc.b	'The Guru 3.02',0
ScrTitle	dc.b	'The Guru 3.02 ©1996 by E.Lensink',0

ReqTitle	dc.b	'Guru 3.0',0

Intname		dc.b	'intuition.library',0
Gfxname		dc.b	'graphics.library',0
Dosname		dc.b	'dos.library',0
Iconname	dc.b	'icon.library',0

AutoFront	dc.b	'AUTOFRONT',0
AutoMatic	dc.b	'AUTOMATIC',0
PubScr		dc.b	'PUBSCREEN',0	
Language	dc.b	'LANGUAGE',0
DataFile	dc.b	'DATAFILE',0
ForceTopaz	dc.b	'TOPAZ',0
DefLanguage	dc.b	'English.lang',0
DefData		dc.b	'Error.data',0

SetTXTDat	dc.b	'SET',0
GuruTXTDat	dc.b	'GURU',0
LastTXTDat	dc.b	'LAST',0
DefaultTXTDat	dc.b	'DEFAULT',0
DosTXTDat	dc.b	'DOS',0
InfoTXTDat	dc.b	'ABOUT',0
QuitTXTDat	dc.b	'QUIT',0
ErrDTXTDat	dc.b	'Error: Couldn''t open data file...',0
ErrDRTXTDat	dc.b	'OK',0
ErrInDTXTDat	dc.b	'Error in data file...',0
ErrInDRTXTDat	dc.b	'OH NO!',0
KeyGURUKey	dc.b	'G',0
KeyLASTKey	dc.b	'L',0
KeyDEFAULTKey	dc.b	'R',0
KeyDOSKey	dc.b	'O',0
KeyABOUTKey	dc.b	'U',0
KeyQUITKey	dc.b	'Q',0

Letters		dc.b	'1234567890ABCDEF'
GuruString	dc.b	'00000000',0
DosString	dc.b	'000',0

SGuruString	dc.b	'@NODE('
GuruStringTemp	dc.b	'00000000'
		dc.b	')',0
		
SGuruHeader	dc.b	' )',1
		dc.b	'Guru: '
SHeaderString	dc.b	'00000000',10
		dc.b	'@ENDNODE  '

SDosString	dc.b	'@NODE('
DosStringTemp	dc.b	'000'
		dc.b	')',0

GenAl		dc.b	'@GENERAL',0
Sub1		dc.b	'@SUBSYS1',0
Sub2		dc.b	'@SUBSYS2',0
Sub3		dc.b	'@SUBSYS3',0
DosAl		dc.b	'@DOS',0
EndFile		dc.b	'@ENDFILE',0
Node		dc.b	'@NODE(',0
UnkGuru		dc.b	'@NODE(UNKNOWNGURU)',0
UnkDos		dc.b	'@NODE(UNKNOWNDOS)',0
Dead		dc.b	'@NODE(DEADEND)',0
Reco		dc.b	'@NODE(RECOVERY)',0
EndNode		dc.b	'@ENDNODE',0

AboutText	dc.b	' )',1
		dc.b	'The Guru, version 3.02',10
		dc.b	'Compile date: February 10, 1996',10,10
		dc.b	'Created by E.Lensink entirely in assembly using '
		dc.b	'HiSoft Devpac 3.',10,10
		dc.b	'If you want to contact me for any reason, don''t hesitate '
		dc.b	'to write to:',10
		dc.b	'Emiel Lensink',10
		dc.b	'Notengaarde 33',10
		dc.b	'3992 JR, Houten',10
		dc.b	'Holland',10,10
		dc.b	'Or through e-mail at: emiell@odie.et.fnt.hvu.nl',10,10
		dc.b	'This program is postware, so if you like it, send '
		dc.b	'me a postcard of your hometown.',10
		dc.b	' ',10
		dc.b	'@ENDNODE  '

TopazFont	dc.b	'topaz.font',0

	SECTION BSSZone,Bss

_IntuitionBase	ds.l	1
_GfxBase	ds.l	1
_IconBase	ds.l	1

WindowPtr	ds.l	1
WindowRastPort	ds.l	1
WindowUserPort	ds.l	1
ScreenLock	ds.l	1
ScreenFont	ds.l	1
WindowWidth	ds.l	1
DisplayWidth	ds.l	1

GeneralAlert	ds.l	1
Subsys1		ds.l	1
Subsys2		ds.l	1
Subsys3		ds.l	1
DosAlert	ds.l	1
EndOfFile	ds.l	1
UnknownDos	ds.l	1
UnknownGuru	ds.l	1
Recovery	ds.l	1
Deadend		ds.l	1


FakeBmSize	ds.l	1
FakeBmPtr	ds.l	1

Indicator1X	ds.l	1
Indicator1Y	ds.l	1
Indicator2X	ds.l	1
Indicator2Y	ds.l	1

Font		ds.l	1
FontY		ds.w	1
FontBase	ds.w	1

FakeRast	ds.l	1
Temp		ds.l	1

Widest		ds.l	1
WidLett		ds.l	1
WidArrow	ds.l	1

LangSize	ds.l	1
LangBuff	ds.l	1
DataSize	ds.l	1
DataBuff	ds.l	1
PrintHandle	ds.l	1

LeftBorder	ds.w	1
Execvers	ds.w	1	
CursY		ds.w	1
ScreenColorMap	ds.l	1

tt_AutoFront	ds.b	1
tt_PubScreen	ds.b	1
tt_Topaz	ds.b	1
tt_AutoMatic	ds.b	1
GuruOffsetTemp	ds.b	1
DosOffset	ds.b	1
FoundErr	ds.b	1
Corrected	ds.b	1
TempPrintBuff	ds.b	2560
ShinePen	ds.b	1
DarkPen		ds.b	1
ScreenDepth	ds.b	1

	SECTION	Gadgets,Data
	
WinGads	include	Gadgets.i

	SECTION	Logo,Data_C
	
	include	GuruLogo.i