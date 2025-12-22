	 	output	work:scypmon
;Used Assembler: Devpac 3.02 by HiSoft
		OPT o+,ow-
RSave		macro
		movem.l	a0-a6/d0-d7,-(sp)
		endm
RLoad		macro
		movem.l	(sp)+,a0-a6/d0-d7
		endm
Push		macro
		movem.l	\1,-(sp)
		endm
Pull		macro
		movem.l	(sp)+,\1
		endm
CALL		macro
		jsr	_LVO\1(a6)
		endm
FlushCursor	macro
		move.w	rp_cp_x(a5),FlushCursorX(a4)
		endm

;		KNOWN BUGS:
;		Slowdown (Scrolling) bei laengerer Benutzung?

;		IDEAS:
;		More Windows
;		(Own Pubscreen?)
;		f3: wie f1, doch adressen*4 (BPTR)


		incdir	"system:devpac/include/"
		;include	"exec/io.i"
		;include	"exec/memory.i"
		;include	"devices/console_lib.i"
		;include "exec/exec_lib.i"
		;include	"exec/execbase.i"
		;include	"devices/inputevent.i"
		;include "intuition/intuition.i"
		;include	"intuition/intuition_lib.i"
		;include "libraries/dos_lib.i"
		;include	"libraries/dosextens.i"
		;include	"libraries/dos.i"
		;include	"graphics/graphics_lib.i"
		;include	"graphics/gfxbase.i"
		;include	"df0:source/dis_lib.i"
		include	"other/dis_lib.i"
		include	"libraries/diskfont_lib.i"
		include	"dos/filehandler.i"

StackSize	equ	4000
MInPos		equ	11
DInPos		equ	11
DirAdress	equ	60
DOpPos		equ	23
SmallestHeight	equ	5*8-2
HistorySize	equ	$400
MyDisPrefs	equ	DF_68030!DF_68020!DF_68851!DF_68881!DF_HexMode0!DF_HexMode1!DF_ShortInst!DF_LineX!DF_LowerInst!DF_LowerHex!DF_LowerReg!DF_AdrPC!DF_NoEACheck!DF_Bcc_S!DF_UseFlags

Startup		cmp.b	#"?",(a0)
		bne	NoInfoPrint
		suba.l	a1,a1
		move.l	$0004.w,a6
		CALL	FindTask
		move.l	d0,a0
		move.l	pr_COS(a0),d7
		lea	DosName,a1
		moveq	#0,d0
		CALL	OpenLibrary
		move.l	d0,a6
		move.l	d7,d1
		lea	ShortHelp,a0
		move.l	a0,d2
		move.l	#ShortHelpe-ShortHelp,d3
		CALL	Write
		move.l	a6,a1
		move.l	$0004.w,a6
		CALL	CloseLibrary
		moveq.l	#0,d0
		rts

NoInfoPrint	movem.l	d0-d7/a0-a7,RegisterSave
		move.l	$0004.w,a6
		move.l	ThisTask(a6),a1
		tst.l	pr_CLI(a1)
		bne.s	CliStart
		lea	pr_MsgPort(a1),a2
		move.l	a2,a0
		CALL	WaitPort
		move.l	a2,a0
		CALL	GetMsg
		move.l	d0,d2
		jmp	MainWB

CliStart	moveq	#RETURN_FAIL,d7
		lea	DosName,a1
		moveq	#0,d0
		CALL	OpenLibrary
		move.l	d0,d6
		beq	DetError1
		move.l	#ML_SIZE+ME_SIZE,d0
		move.l	#MEMF_CLEAR,d1
		CALL	AllocMem
		tst.l	d0
		beq	DetError2
		clr.l	d5	;test
		move.l	d0,a2
		move.l	ThisTask(a6),a0
		move.l	pr_CurrentDir(a0),d1
		beq	NoDupLock	;test
		exg	d6,a6
		CALL	DupLock
		exg	d6,a6
		move.l	d0,d5
		beq.s	DetError4
NoDupLock	move.w	#1,ML_NUMENTRIES(a2)
		lea	PARTII-8,a3
		move.l	a3,(ML_ME+ME_ADDR)(a2)
		move.l	(a3),(ML_ME+ME_LENGTH)(a2)
		lea	ProgramName,a0
		move.l	a0,d1
		moveq	#0,d2
		lea	MainCLI-4,a0
		move.l	a0,d3
		lsr.l	#2,d3
		move.l	#StackSize,d4
		CALL	Forbid
		exg	d6,a6	; DOSBase/SysBase umtauschen
		CALL	CreateProc
		exg	d6,a6
		tst.l	d0
		beq.s	DetError3
		clr.l	(Startup-4)		;2.ten Teil anhaengen
		move.l	d0,a0
		move.l	d5,(pr_CurrentDir-pr_MsgPort)(a0)
		lea	(TC_MEMENTRY-pr_MsgPort)(a0),a0
		move.l	a2,a1
		CALL	AddHead
		CALL	Permit
		moveq	#RETURN_OK,d7
		bra.s	DetachOK
DetError3	CALL	Permit
		exg	d6,a6
		move.l	d5,d1	;test
		beq	NoDup2
		CALL	UnLock
NoDup2		exg	d6,a6
DetError4	move.l	a2,a1
		moveq	#ML_SIZE+ME_SIZE,d0
		CALL	FreeMem
DetError2	;
DetachOK	move.l	d6,a1
		CALL	CloseLibrary
DetError1	tst.w	StatusLine ;auf Auswertung der paramter warten
		beq.s	DetError1
		move.l	d7,d0
		rts

		section	Program

PARTII		;

DoNotDetach	;
MainCLI		moveq	#0,d2
MainWB		moveq	#RETURN_FAIL,d3

		;*** Installations ***
MonitorStart	move.l	$0004.w,a6
		move.l	a7,d0
		sub.l	#$800,d0	;Damit echter und Trace-Stack nicht
		move.l	d0,USPstack	;so leicht kollidieren
		lea	MonStart(pc),a5
		CALL	Supervisor
		bra.s	MainProgramm
MonStart	move.w	SR,d0
		and.w	#$dfff,d0
		move.w	d0,SRregister
		move.l	a7,SSPstack
		moveq	#0,d0
		btst.b	#AFB_68010,(AttnFlags+1)(A6)
		beq.s	StandardVBR
		dc.w	$4e7a,$0801	;movec	VBR,d0
StandardVBR	move.l	d0,VBRreg
		rte
MainProgramm	move.l	$0004.w,a6
		move.l	#GesLen,d0
		move.l	#MEMF_CLEAR,d1
		CALL	AllocMem	;Speicher für Zeropage
		move.l	d0,ZeroSpeicher
		beq	ErrorTotal2
		move.l	d0,d1
		add.l	#ZeroPage,d0
		move.l	d0,ZeroPageMem
		move.l	ZeroPageMem,a4
		move.l	ThisTask(a6),a0
		move.l	a0,OwnTask(a4)
		move.l	d2,WBMessage(a4)
		move.l	d3,ReturnCode(a4)
		move.l	VBRreg,a0
		move.l	$bc(a0),OLDTRAP15(a4)
		move.l	a7,BaseStack(a4)
		move.l	d1,d7
		lea	ConName(pc),a0
		moveq.l #-1,d0
                lea	IORequest(a4),a1
                moveq.l #0,d1
                CALL	OpenDevice
                tst.l   d0
                bne     ErrorTotal
                move.l  (IO_DEVICE+IORequest)(a4),ConDevice(a4)
		move.l	d7,d1
		move.l	d1,FileLocker(a4)
		add.l	#FindBufferR,d1
		move.l	d1,FindBuffer(a4)
		add.l	#MaskBufferR-FindBufferR,d1
		move.l	d1,MaskBuffer(a4)
		add.l	#OutDeviceR-MaskBufferR,d1
		move.l	d1,a0
		move.l	d1,OutDevice(a4)
		add.l	#VariableBuff-OutDeviceR,d1
		move.l	d1,VarBuff(a4)
		add.l	#CommandHist-VariableBuff,d1
		move.l	d1,HistoryMem(a4)
		move.l	d1,HistPointStart(a4)
		move.l	d1,HistPointAct(a4)
		addq.l	#1,d1
		move.l	d1,HistPointEnd(a4)
		add.l	#HistorySize-1,d1
		move.l	d1,HistoryEnd(a4)

		lea	OutDeviceTx(pc),a1
		move.w	#$04,d0
InstallNames	move.b	(a1)+,(a0)+		;prt:
		dbf	d0,InstallNames
		;Test for Batchfile
		move.l	RegisterSave+32,a0
		move.w	#8000,TextWidth2(a4)	;Nur damit GetTextString geht
LetCross	tst.b	(a0)
		beq	NoBatchFile
RetryOption	cmp.b	#" ",(a0)
		bne.s	GotChar
		addq.l	#1,a0
		bra.s	LetCross
GotChar		cmp.b	#"-",(a0)	;Test for options
		bne	Normalmake
OtherOptions	addq.l	#1,a0
		tst.b	(a0)
		beq	NoBatchFile
		cmp.b	#"b",(a0)
		beq	ScreenToBackOpt
		cmp.b	#"p",(a0)
		beq	Dontpatch
		cmp.b	#"f",(a0)
		beq.s	ParseFont
		cmp.b	#"P",(a0)
		beq	NewPosition
		cmp.b	#"S",(a0)
		beq	NewSize
		cmp.b	#"s",(a0)
		beq	PubScreen
		cmp.b	#"d",(a0)
		beq	UseDisLib
		cmp.b	#"-",(a0)
		beq.s	OtherOptions
		cmp.b	#" ",(a0)
		bne	NoBatchFile	;Option Error=> Ignore Rest!
		addq.l	#1,a0
		tst.b	(a0)
		beq	NoBatchFile
		bra.s	RetryOption

ParseFont	Push	d0-d7/a1-a6
		clr.b	NewFontName(a4)
		move.l	a0,-(sp)
		moveq.l	#1,d5
		move.l	a0,a1
		bsr	GetTextString
		beq	WrongOp
		cmp.w	#40,d0
		bcc	WrongOp
		lea	NewFontName(a4),a3
		bsr	InsertText
WrongOp		move.l	(sp)+,a0
		add.l	d5,a0
		move.l	a0,-(sp)
		moveq.l	#0,d5
		move.l	a0,a1
		bsr	GetDezNum
		move.w	d0,NewFontSize(a4)
		move.l	(sp)+,a0
		add.l	d5,a0
		Pull	d0-d7/a1-a6
		bra	RetryOption


FirstChar	cmp.b	#" ",(a0)
		bne.s	FCharFound
		tst.b	(a0)
		beq.s	FCharFound
		addq	#1,a0
		bra.s	FirstChar
FCharFound	rts

NewPosition	Push	d0-d7/a1-a6
		addq	#1,a0
		bsr	FirstChar
		move.l	a0,-(sp)
		moveq.l	#0,d5
		move.l	a0,a1
		bsr	GetDezNum
		move.w	d0,WindowDefs
		move.w	d0,WindowDefs2
		move.l	(sp)+,a0
		add.l	d5,a0
		bsr	FirstChar
		move.l	a0,-(sp)
		moveq.l	#0,d5
		move.l	a0,a1
		bsr	GetDezNum
		move.w	d0,WindowDefs+2
		move.w	d0,WindowDefs2+2
		move.l	(sp)+,a0
		add.l	d5,a0
		Pull	d0-d7/a1-a6
		bra	RetryOption

NewSize		Push	d0-d7/a1-a6
		addq	#1,a0
		bsr	FirstChar
		move.l	a0,-(sp)
		moveq.l	#0,d5
		move.l	a0,a1
		bsr	GetDezNum
		move.w	d0,WindowDefs+4
		move.l	(sp)+,a0
		add.l	d5,a0
		bsr	FirstChar
		move.l	a0,-(sp)
		moveq.l	#0,d5
		move.l	a0,a1
		bsr	GetDezNum
		move.w	d0,WindowDefs+6
		move.l	(sp)+,a0
		add.l	d5,a0
		Pull	d0-d7/a1-a6
		bra	RetryOption


PubScreen	Push	d0-d7/a1-a6
		clr.b	PubName(a4)
		move.l	a0,-(sp)
		moveq.l	#1,d5
		move.l	a0,a1
		bsr	GetTextString
		beq	WrongOps
		cmp.w	#40,d0
		bcc	WrongOps
		lea	PubName(a4),a3
		bsr	InsertText
WrongOps	move.l	(sp)+,a0
		add.l	d5,a0
		Pull	d0-d7/a1-a6
		bra	LetCross

ScreenToBackOpt move.l	WindowFlags,d0
		and.l	#~ACTIVATE,d0
		move.l	d0,WindowFlags
		bra	OtherOptions
Dontpatch	move.w	#1,PatchFlag(a4)
		lea	PatchitFlag(pc),a1
		or.w	#CHECKED,(a1)
		bra	OtherOptions
UseDisLib	lea	UseDisFlag(pc),a1
		eor.w	#CHECKED,(a1)
		bsr	SwitchDislib
		bra	OtherOptions
SwitchDislib	RSave
		lea	UseDisFlag(pc),a1
		move.w	(a1),d0
		and.w	#CHECKED,d0
		bne.s	DisUse
OtherOptionsx	tst.l	DislibBase(a4)
		beq.s	DunnoClose
		move.l	DislibBase(a4),a1
		CALL	CloseLibrary
DunnoClose	clr.l	DislibBase(a4)
		lea	UseDisFlag(pc),a1
		and.w	#$ffff-CHECKED,(a1)
		lea	ConfigVal(pc),a1
		and.w	#~ITEMENABLED,(a1)
		RLoad
		rts
DisUse		move.l	a0,-(sp)
		lea	DisLibText(pc),a1
		move.l	$0004.w,a6
		moveq	#2,d0
		CALL	OpenLibrary
		move.l	(sp)+,a0
		tst.l	d0
		beq.s	OldVersion
		move.l	d0,DislibBase(a4)
		move.l	d0,a6
		CALL 	GetDisPrefs
		lea	DisStruct(a4),a3
		move.l	d0,dl_InFlags(a3)
		lea	ConfigVal(pc),a1
		or.w	#ITEMENABLED,(a1)
		RLoad
		rts
OldVersion	move.l	a0,-(sp)
		lea	DisLibText(pc),a1
		move.l	$0004.w,a6
		moveq	#1,d0
		CALL	OpenLibrary
		move.l	(sp)+,a0
		tst.l	d0
		beq.s	OtherOptionsx
		move.l	d0,DislibBase(a4)
		lea	DisStruct(a4),a3
		move.l	#MyDisPrefs,dl_InFlags(a3)
		RLoad
		rts
		

Normalmake	move.l	FindBuffer(a4),a3
		clr.b	(a3)
		moveq.l	#0,d5
		move.l	a0,a1
		bsr	GetTextString
		beq	NoBatchFile
		cmp.w	#80,d0
		bcc	NoBatchFile
		bsr	InsertText
		move.l	FindBuffer(a4),a3
		tst.b	(a3)
		beq.s	NoBatchFile
		move.l	a3,BatchFile(a4)

NoBatchFile	move.w	#1,StatusLine	;jetzt kann der andere Proc weg!


Skippy		move.l	$0004.w,a6
		lea	IntuitionName(pc),a1
		moveq.l	#36,d0
		CALL	OpenLibrary
		tst.l	d0
		beq.s	OpenOlder
		move.w	#1,V36OK(a4)
		bra.s	V36Done

OpenOlder	lea	IntuitionName(pc),a1
		moveq.l	#0,d0
		CALL	OpenLibrary
V36Done		move.l	d0,IntBase(a4)

		bsr	OpenDisplay

		move.l	$0004.w,a6
		lea	DosName(pc),a1
		moveq.l	#0,d0
		CALL	OpenLibrary
		move.l	d0,DosBase(a4)

		move.l	#StackBase+64,RoundStackPos(a4)

		bsr	InitVektors
		FlushCursor
		move.b	#$0c,d0
		bsr	Print
		lea	EinschaltTxt(pc),a2
		bsr	PrintText

		tst.l	BatchFile(a4)
		beq.s	NoOpenBatch
		bset	#2,SetError(a4)
		move.l	DosBase(a4),a6
		move.l	FindBuffer(a4),d1
		move.l	#MODE_OLDFILE,d2
		CALL	Open
		tst.l	d0
		beq.s	NoOpenBatch
		move.l	d0,a1
		CALL	Close
		bclr	#2,SetError(a4)

NoOpenBatch	move.b	SetError(a4),d6
		beq.s	NoErrorsSet
		lea	ErrorsOccured(pc),a2
		bsr	PrintText
		ror.b	#1,d6
		bcc.s	SkipEE1
		lea	StartError1(pc),a2
		bsr	PrintText
		lea	NewFontName(a4),a2
		bsr	PrintText

SkipEE1		ror.b	#1,d6
		bcc.s	SkipEE2
		lea	StartError2(pc),a2
		bsr	PrintText
		lea	NewFontName(a4),a2
		bsr	PrintText

SkipEE2		ror.b	#1,d6
		bcc.s	SkipEE3
		lea	StartError3(pc),a2
		bsr	PrintText
		move.l	FindBuffer(a4),a2
		bsr	PrintText

SkipEE3		ror.b	#1,d6
		bcc.s	SkipEE4
		lea	StartError4(pc),a2
		bsr	PrintText
SkipEE4		

		move.b	#$0a,d0
		bsr	Print

NoErrorsSet	or.l	#SIGBREAKF_CTRL_C,SignalMask(a4)
		tst.l	BatchFile(a4)
		beq	RegisterComm
		
		move.l	DosBase(a4),a6
		move.l	FindBuffer(a4),d1
		move.l	#MODE_OLDFILE,d2
		CALL	Open
		move.l	d0,BatchHandle(a4)
		beq	RegisterComm

		;*** Mainroutine ***

EmptyLine	move.l	WDRastPort(a4),a5
		tst.w	PrinterFlag(a4)
		beq.s	NOCLOSE
		bmi.s	NOCLOSE
		bsr	PrExecute
NOCLOSE		clr.w	PrinterFlag(a4)
		bsr	PrintReturn
		move.b	#".",d0
		bsr	Print
ReKey		move.l	BaseStack(a4),a7
		tst.l	BatchHandle(a4)
		beq.s	NoBatch
		move.l	BatchHandle(a4),d1
		move.l	FindBuffer(a4),d2
		moveq.l	#1,d3
		move.l	DosBase(a4),a6
		CALL	Read
		move.l	d0,d1
		move.l	FindBuffer(a4),a0
		move.b	(a0),d0
		tst.l	d1
		bne.s	DoBatch
		move.l	BatchHandle(a4),d1
		CALL	Close
		clr.l	BatchHandle(a4)
NoBatch		bsr	ExorCursor
		bsr	WaitForKey
		bsr	ExorCursor
DoBatch		lea	SpecialFunkt(pc),a0
		bsr	SearchCodea0
		beq.s	NoSpecial
		lea	SpecialJMP(pc),a0
		jmp	(a0,d1)
NoSpecial	bsr	PrintInsPoss
		bra.s	ReKey

SpecialFunkt	dc.b	$0a,$90,$91,$81,$82,$94,$95,$83,$84,$9c,0	;SpecialTasten
		even
SpecialJMP	bra.w	LineAuswertung
		bra.w	CursorUpSpecial
		bra.w	CursorDnSpecial
		bra.w	BlaetternUp
		bra.w	BlaetternDn
		bra.w	JsrDissIn
		bra.w	JsrDissOut
		bra.w	HistUP
		bra.w	HistDN
		bra.w	ChangeVMode

HistDN		move.l	HistPointAct(a4),a0
ScanForw	bsr	IncIt
		cmp.l	HistPointEnd(a4),a0
		beq	ReKey
		tst.b	(a0)
		bne.s	ScanForw
		bra	BothHister

HistUP		move.l	HistPointAct(a4),a0
DoScanBack	cmp.l	HistPointStart(a4),a0
		beq	ReKey
		cmp.l	HistoryMem(a4),a0
		bne.s	CanScan
		move.l	HistoryEnd(a4),a0
CanScan		subq.l	#1,a0
		tst.b	(a0)
		bne	DoScanBack
BothHister	move.l	a0,HistPointAct(a4)
		bsr	IncIt
		move.l	a0,-(sp)
		bsr	Return
		bsr	ClearRight
		move.b	#".",d0
		bsr	Print
		move.l	(sp)+,a0
		cmp.l	HistPointEnd(a4),a0
		beq	ReKey
HistPLoop	move.b	(a0),d0
		beq.s	PrintHiste
		bsr	Print
		bsr	IncIt
		bra.s	HistPLoop
PrintHiste	bsr	TextFlush
		bsr	Return
		bsr	CursorRight
		bsr	TextFlush
		bra	ReKey

BlaetternUp	bsr	GetScrollCodeUp
		lea	BlaetterJMP(pc),a0
		moveq.l	#-1,d4
		jmp	(a0,d1)

CursorUpSpecial	move.w	Y0Pos(a4),d4
		cmp.w	rp_cp_y(a5),d4
		bne	NoSpecial
		bsr	Print
		bsr	GetScrollCodeUp
		moveq.l	#-1,d4	;Sign For Up
OtherSCR	move.w	rp_cp_x(a5),-(sp)
		lea	ScrollJMP(pc),a0
		jsr	(a0,d1)
		bsr	TextFlush
		move.w	(sp)+,rp_cp_x(a5)
		FlushCursor
		bra	ReKey

GetScrollCodeUp	moveq.l	#1,d5
		moveq.l	#0,d4
		move.l	TextScreen(a4),a1
TryAnother	move.b	(a1,d5),d0
		lea	ScrollCodes(pc),a0
		bsr	SearchCodea0
		bne.s	ScrollCodeFound
TryAnother1	add.w	TextWidth(a4),d5
		addq	#1,d4
		cmp.w	TextHeight(a4),d4
		bcs.s	TryAnother
		move.l	(sp)+,d0
		bra	ReKey
ScrollCodeFound	move.l	d5,-(sp)
		addq	#1,d5
		bsr	TestAdressGueltig
		move.l	(sp)+,d5
		tst.l	d0
		bne.s	TryAnother1
		subq	#1,d5
		add.l	d5,a1
		moveq	#2,d5
		rts

BlaetternDn	bsr	GetScrollCodeDn
		lea	BlaetterJMP(pc),a0
		moveq	#1,d4
		jmp	(a0,d1)

CursorDnSpecial	move.w	rp_cp_y(a5),d4
		add.w	Y0Rest(a4),d4
		cmp.w	maxY(a4),d4
		bne	NoSpecial
		bsr	Print
		bsr	GetScrollCodeDn
		moveq.l	#1,d4	;Sign for Down
		bra	OtherSCR

GetScrollCodeDn	moveq.l	#0,d5
		move.w	TextHeight(a4),d5
		subq.l	#1,d5
		mulu	TextWidth(a4),d5
		addq	#1,d5
		moveq.l	#0,d4
		move.l	TextScreen(a4),a1
TryAnother2	move.b	(a1,d5),d0
		lea	ScrollCodes(pc),a0
		bsr	SearchCodea0
		bne.s	ScrollCodeF2
TryAnother3	sub.w	TextWidth(a4),d5
		addq	#1,d4
		cmp.w	TextHeight(a4),d4
		bcs.s	TryAnother2
		move.l	(sp)+,d0
		bra	ReKey
ScrollCodeF2	move.l	d5,-(sp)
		addq	#1,d5
		bsr	TestAdressGueltig
		move.l	(sp)+,d5
		tst.l	d0
		bne.s	TryAnother3
		subq	#1,d5
		add.l	d5,a1
		moveq	#2,d5
		rts

GetAMemAdr	suba.l	a3,a3
		cmp.b	#":",d0
		bne	OverParse
		addq	#1,d5
		bsr	GetHexAdress
		move.l	d0,a3
		move.w	rp_cp_x(a5),d5
		divu	FontX(a4),d5
		bsr	GetHexAdress
		lsl.l	#8,d0
		lsl.l	#8,d0
		move.l	d0,d4
		bsr	GetHexAdress
		move.w	d0,d4
		move.l	d4,a2
		moveq	#0,d7
		bra	Formem
OverParse	move.w	rp_cp_x(a5),d5
		divu	FontX(a4),d5
		bsr	GetHexAdress
		move.l	d0,a0
		bra	DochM

ChangeVMode	bsr	SearchFirstChar
		beq	ReKey
		cmp.b	#",",d0
		beq	SwitchToMem
		cmp.b	#":",d0
		bne	SwitchToDiss
		addq	#1,d5
		bsr	GetHexAdress
		move.l	d0,a0
		bra	LikeOtherDXX
SwitchToMem	addq	#1,d5
		bsr	GetHexAdress
		move.l	d0,a0
		bra	DochM
SwitchToDiss	move.w	rp_cp_x(a5),d5
		divu	FontX(a4),d5
		bsr	GetHexAdress
		move.l	d0,a0
		bra	LikeOtherDXX
		

JsrDissIn	bsr	SearchFirstChar
		beq	ReKey
		cmp.b	#",",d0
		bne	GetAMemAdr
		addq	#1,d5
		bsr	GetHexAdress
		move.l	d0,a3
		move.w	#DOpPos,d5
		bsr	SearchNextChar
		beq	ReKey
		cmp.b	#"#",d0
		bne.s	NormNum
		addq	#1,d5
NormNum		cmp.b	#"-",d0
		bne.s	PosNum
		addq	#1,d5
		moveq.l	#0,d0
		bsr	GetHexNum
		neg.l	d0
		bra.s	NegNum
PosNum		moveq.l	#0,d0
		bsr	GetHexNum
NegNum		move.l	d0,a2
		bsr	SearchNextChar
		cmp.b	#"(",d0
		bne.s	EhKlar
		addq	#1,d5
		bsr	SearchNextChar
		cmp.b	#"p",d0
		beq.s	EhKlar
		cmp.b	#"a",d0
		bne.s	EhKlar
		addq	#1,d5
		bsr	GetHexNum
		and.l	#$07,d0
		lsl.w	#2,d0
		lea	RegisterSave(pc),a0
		add.l	32(a0,d0),a2
		bsr	SearchNextChar
		cmp.b	#",",d0
		bne.s	EhKlar
		addq	#1,d5
		bsr	SearchNextChar
		move.l	d0,d4
		addq	#1,d5
		bsr	GetHexNum
		and.l	#$07,d0
		lsl.w	#2,d0
		cmp.b	#"a",d4
		beq.s	AdressJsr
		add.l	#8*4,d0
AdressJsr	add.l	(a0,d0),a2
EhKlar		moveq	#-1,d7
Formem		move.l	RoundStackPos(a4),a0
		move.l	a3,-(a0)
		cmp.l	#StackBase,a0
		bne.s	BaseNotReached
		move.l	#StackBase+64,a0
BaseNotReached	move.l	a0,RoundStackPos(a4)
		move.l	a0,d1
		sub.l	#StackBase,d1
		lsr.w	#2,d1
		move.l	StackKind(a4),d2
		bclr	d1,d2
		tst	d7
		bmi.s	KeepCleard
		bset	d1,d2
KeepCleard	move.l	d2,StackKind(a4)
		move.l	a2,d0
		and.l	#$fffffffe,d0
		move.l	d0,a0
		cmp.b	#"b",DInPos(a1)
		beq.s	LikeOtherD
		cmp.b	#"j",DInPos(a1)
		beq.s	LikeOtherDXX
DochM		move.w	#$0c,d0
		bsr	Print
		move.l	a0,d1
		and.l	#$fffffffe,d1
		move.l	d1,a0
		moveq.l	#0,d0
		move.w	TextHeight(a4),d0
		subq	#1,d0
		lsl.w	#4,d0
		add.l	d0,d1
		move.l	d1,OutPutStop(a4)
PrintNextDD	bsr	PrintMemLine
		bsr	PrintReturn
		cmp.l	OutPutStop(a4),a0
		bcs.s	PrintNextDD
		bsr	TextFlush
		move.w	#MInPos,d0
		bsr	SetCursorX
		bra.s	LikeOtherD2
LikeOtherD	cmp.b	#".",(DInPos+3)(a1)
		bne.s	DochM
LikeOtherDXX	bsr	OneDissPage
		bsr	TextFlush
		move.w	#DInPos,d0
		bsr	SetCursorX
LikeOtherD2	FlushCursor
		move.w	Y0Pos(a4),rp_cp_y(a5)
		bra	ReKey

JsrDissOut	move.l	RoundStackPos(a4),a1
		cmp.l	#StackBase+64,a1
		bcs.s	KeepJsrDiss
		move.l	#StackBase,a1
KeepJsrDiss	tst.l	(a1)
		beq	ReKey
		move.l	(a1),a0
		move.l	a1,d0
		clr.l	(a1)+
DoView		sub.l	#StackBase,d0
		lsr.w	#2,d0
		move.l	a1,RoundStackPos(a4)
		move.l	StackKind(a4),d1
		btst.l	d0,d1
		beq.s	LikeOtherDXX
		bra	DochM


LineAuswertung	bsr	SearchFirstChar
		beq	EmptyLine
		bsr	InsertHistLine
SecondAuswert	lea	BefehlsCodes(pc),a0
		bsr	SearchCodea0
		beq	FrageZeichen
		addq	#1,d5
		lea	BefehlsJMP(pc),a0
		jmp	(a0,d1)

ScrollCodes	dc.b	":;,",0
		even
ScrollJMP	bra.w	SMemory
		bra.w	SASCII
		bra.w	SDizzy

BlaetterJMP	bra.w	BMemory
		bra.w	BASCII
		bra.w	BDizzy

BefehlsCodes	dc.b	"x^$#%&m?i:dwflLs,aoDtgr'c<>VBTAFSCbOpPeMh",0
		even
BefehlsJMP	bra.w	EndeDesPrg
		bra.w	EvalVar
		bra.w	CalcExpression
		bra.w	CalcExpression
		bra.w	CalcExpression
		bra.w	CalcExpression
		bra.w	MemoryBefehl
		bra.w	CalcExpression2
		bra.w	ASCIIOutput
		bra.w	ChangeMemory
		bra.w	DisAssemble
		bra.w	WriteASCII
		bra.w	FindSomething
		bra.w	LoadFile
		bra.w	LoadFile
		bra.w	SaveFile
		bra.w	Assemble
		bra.w	InstAssembler
		bra.w	Occupy
		bra.w	DirectoryLoad
		bra.w	Transfer
		bra.w	GotoCommand
		bra.w	RegisterComm
		bra.w	GetRegister
		bra.w	CompareSth
		bra.w	DiskLoad
		bra.w	DiskSave
		bra.w	ChangeDevice
		bra.w	BreakCommand
		bra.w	TraceCommand
		bra.w	AllocSegment
		bra.w	FreeSegment
		bra.w	SegmentList
		bra.w	BlockCheckSumm
		bra.w	BootCheckSumm
		bra.w	OutPutDevice
		bra.w	PrintThemOut
		bra.w	PrintThatText
		bra.w	ExamineTask
		bra.w	CheckFreeMem
		bra.w	ShowHistory

ShowHistory	move.l	HistPointStart(a4),a0
HistL1		cmp.l	HistPointEnd(a4),a0
		beq	ReKey
		bsr	TestBreak
		move.b	(a0),d0
		beq	CNEXT
		bsr	Print
		bsr	IncIt
		bra.s	HistL1
CNEXT		move.b	#$0a,d0
		bsr	Print
		move.b	#".",d0
		bsr	Print
		bsr	IncIt
		bra	HistL1

InsertHistLine	RSave
		move.w	TextWidth2(a4),d7
FindSize	subq	#1,d7
		cmp.b	#" ",(a1,d7)
		dbne	d7,FindSize
		addq	#2,d7
		move.l	HistPointEnd(a4),a3
CopH		move.b	(a1,d5),d0
		bsr	PutHistByte
		addq	#1,d5
		cmp.w	d7,d5
		bcs.s	CopH
		move.l	a3,HistPointAct(a4)
		clr.l	d0
		bsr	PutHistByte
		move.l	a3,HistPointEnd(a4)
		RLoad
		rts

PutHistByte	cmp.l	HistoryEnd(a4),a3
		bne.s	NoOverHist
		move.l	HistoryMem(a4),a3
NoOverHist	cmp.l	HistPointStart(a4),a3
		beq.s	PushOnStart
GotHist		move.b	d0,(a3)+
		rts
PushOnStart	move.l	a3,a0
SeekOn		bsr	IncIt
		tst.b	(a0)
		bne.s	SeekOn
		move.l	a0,HistPointStart(a4)
		bra.s	GotHist

IncIt		lea	1(a0),a0
		cmp.l	HistoryEnd(a4),a0
		bcs.s	NoOverHist2
		move.l	HistoryMem(a4),a0
NoOverHist2	rts

		
		; *** Calculation-Befehle ***

CalcExpression	subq	#1,d5
CalcExpression2	bsr	CalcRoutine

ZuweisungOut	bsr	PrintReturn
		move.b	#"$",d0
		bsr	Print
		move.l	RechenSpeicher(a4),d0
		bsr	PrintLong
		move.b	#"=",d0
		bsr	Print
		move.l	RechenSpeicher(a4),d0
		bsr	PrintDezimal
		move.b	#"=",d0
		bsr	Print
		move.b	#"%",d0
		bsr	Print
		move.l	RechenSpeicher(a4),d0
		bsr	PrintBinaer32
		move.b	#"=",d0
		bsr	Print
		move.b	#$22,d0
		bsr	Print
		lea	RechenSpeicher(a4),a0
		moveq	#3,d4
		bsr	CharacLoop
		move.b	#$22,d0
		bsr	Print
		bra	EmptyLine

CalcRoutine	move.l	FileLocker(a4),a2;Buffer für die Berechnung
		move.b	#1,(a2)+
GetCalcStream	bsr	GetAnyExpression ;Stream umkopieren
		bsr	SearchNextChar
		bne.s	GetCalcStream
		move.b	#2,(a2)+
		move.l	FileLocker(a4),a0
		sub.l	a0,a2
		move.l	a2,d7		;Laenge des Buffers
		moveq.l	#0,d0
		moveq.l	#0,d1
		moveq.l	#0,d2
CheckKlammer	move.b	(a0,d0),d2	;Klammer Auf/Zu pruefen
		bne.s	StandardTok
		addq	#4,d0
StandardTok	cmp.b	#1,d2		;=Klammer auf
		bne.s	NoKlOn
		addq	#1,d1
NoKlOn		cmp.b	#2,d2		;=Klammer zu
		bne.s	NoKlOff
		subq	#1,d1
NoKlOff		addq	#1,d0
		cmp.w	d7,d0
		bcs.s	CheckKlammer
		tst.w	d1
		bne	FrageZeichen	;Klammer Mismatch

		moveq.l	#0,d0
		moveq.l	#0,d3
		bsr	CalculateEx
		move.l	d3,RechenSpeicher(a4)	;Ergebnis
		rts

CalculateEx	move.b	(a0,d0),d2
		bne.s	Anders
		addq	#1,d0
		bsr	GetValueD3
		bra.s	CalculateEx
Anders		cmp.b	#1,d2
		bne.s	ParseOn
		moveq.l	#0,d3
		moveq.w	#5,d2
		bra.s	IntoPlus
ParseOn		cmp.b	#2,d2
		bne.s	ParseOn1
		addq	#1,d0
		rts
ParseOn1	cmp.b	#3,d2		;mal
		bne.s	ParseOn2
		move.l	d3,-(sp)
		bsr	GetNextVal
		move.l	(sp)+,d4
		movem.l	d0-d2/d4,-(sp)
		move.l	d4,d0
		move.l	d3,d1
		bsr	Mult32Bit
		bra.s	CalMDEnd

ParseOn2	cmp.b	#4,d2		;geteilt
		bne.s	ParseOn3
		move.l	d3,-(sp)
		bsr	GetNextVal
		move.l	(sp)+,d4
		movem.l	d0-d2/d4,-(sp)
		move.l	d4,d0
		move.l	d3,d1
		bsr	Div32Bit
CalMDEnd	move.l	d0,d3
		movem.l	(sp)+,d0-d2/d4
		cmp.b	#5,(a0,d0)
		bcs.s	CalculateEx
		rts
IntoPlus	;
ParseOn3	move.w	d2,-(sp)	;+ and -
		move.l	d3,-(sp)
		bsr	GetNextVal
		cmp.b	#4,(a0,d0)
		beq.s	SpecC
		cmp.b	#3,(a0,d0)
		bne.s	NoSpecC
SpecC		bsr	CalculateEx

		move.l	(sp)+,d4
		move.w	(sp)+,d2
		cmp.b	#5,d2		;plus
		bne.s	ParseOn4_
		add.l	d4,d3
		bra.s	BothMiPl_
ParseOn4_	cmp.b	#6,d2		;minus
		bne	FrageZeichen	;won't happen
		sub.l	d3,d4
		move.l	d4,d3
BothMiPl_	cmp.b	#2,-1(a0,d0)
		bne	CalculateEx
		rts

NoSpecC		move.l	(sp)+,d4
		move.w	(sp)+,d2
		cmp.b	#5,d2		;plus
		bne.s	ParseOn4
		add.l	d4,d3
		bra.s	BothMiPl
ParseOn4	cmp.b	#6,d2		;minus
		bne	FrageZeichen	;won't happen
		sub.l	d3,d4
		move.l	d4,d3
BothMiPl	bra	CalculateEx

GetNextVal	addq	#1,d0
		move.b	(a0,d0),d2
		cmp.b	#1,d2
		bne.s	MustVal2
		bsr	CalculateEx
LikeMiBev	rts
MustVal2	tst.b	d2
		bne	FrageZeichen
		addq	#1,d0
		bsr	GetValueD3
		bra.s	LikeMiBev

GetValueD3	move.b	3(a0,d0),d3
		lsl.l	#8,d3
		move.b	2(a0,d0),d3
		lsl.l	#8,d3
		move.b	1(a0,d0),d3
		lsl.l	#8,d3
		move.b	(a0,d0),d3
		addq	#4,d0
		rts

PushD1ToRight	move.w	d7,d3
PushD1To	move.b	(a0,d3),1(a0,d3)
		subq	#1,d3
		cmp.w	d1,d3
		bcc.s	PushD1To
		addq.w	#1,d7
		rts

;d0*d1 in 32 Bit
Mult32Bit	move.l	d0,d2
		move.l	d0,d3
		move.l	d1,d4
		swap	d3
		swap	d4
		mulu	d1,d0
		mulu	d3,d1
		mulu	d4,d2
		mulu	d4,d3
		swap	d0
		add.w	d1,d0
		moveq.l	#0,d4
		addx.l	d4,d3
		add.w	d2,d0
		addx.l	d4,d3
		swap	d0
		move.l	d0,d4
		rts

;d0/d1 in 32 Bit
Div32Bit	tst.l	d1
		beq	FrageZeichen
		moveq.l	#0,d3
		divu	d1,d0
		bvc.s	V_Null
		move.l	d0,d2
		clr.w	d0
		swap	d0
		divu	d1,d0
		move.w	d0,d3
		move.w	d2,d0
		divu	d1,d0
V_Null		move.l	d0,d1
		swap	d0
		move.w	d3,d0
		swap	d0
		clr.w	d1
		swap	d1
		rts

GetAnyExpression	;
		bsr	SearchNextChar
		cmp.b	#"0",d0
		bcs.s	NoNumberNN
		cmp.b	#"9"+1,d0
		bcc.s	NoNumberNN
		moveq.l	#0,d1
		bra.s	GetDezNumDo
NoNumberNN	lea	ZahlenFormate(pc),a0
		bsr	SearchCodea0
		beq	FrageZeichen
		addq	#1,d5
		cmp.w	#$1c,d1
		bcc.s	Arithmics
GetDezNumDo	lea	ZahlenJSR(pc),a0
		jsr	(a0,d1)
		clr.b	(a2)+
PutLong		move.b	d0,(a2)+
		lsr.l	#8,d0
		move.b	d0,(a2)+
		lsr.l	#8,d0
		move.b	d0,(a2)+
		lsr.l	#8,d0
		move.b	d0,(a2)+
		rts
Arithmics	sub.w	#$18,d1
		lsr.w	#2,d1
		move.b	d1,(a2)+
		rts

ZahlenFormate	dc.b	"#$%&'",$22,"^()*/+-",0
		even
ZahlenJSR	bra.w	GetDezNum
		bra.w	GetHexNum
		bra.w	GetBinNum
		bra.w	GetHexNumAdr
		bra.w	GetMax4Char
		bra.w	GetMax4Char
		bra.w	GetVarVal

GetHexNumAdr	bsr	GetHexNum
		and.l	#$fffffffe,d0
		move.l	d0,a0
		move.l	(a0),d0
		rts

GetMax4Char	moveq.l	#0,d4
		moveq.l	#4,d3
GetMax4C	bsr	SearchNextChar
		addq	#1,d5
		cmp.b	#$22,d0
		beq.s	Strover
		cmp.b	#"'",d0
		beq.s	Strover
		lsl.l	#8,d4
		move.b	d0,d4
		dbf	d3,GetMax4C
		bra	FrageZeichen
Strover		move.l	d4,d0
		rts		

GetVarVal	bsr	SearchNextChar
		addq	#1,d5
		;bclr	#5,d0
		cmp.b	#"a",d0		;Kleinbuchstaben: normale Variablen
		bcs.s	SpecialVars
		cmp.b	#"z"+1,d0
		bcc.s	SpecialVars
		subq	#1,d0
GetVald0	and.l	#$1f,d0
		lsl.l	#2,d0
		move.l	VarBuff(a4),a0
		add.l	d0,a0
		move.l	(a0),d0
		rts
SpecialVars	cmp.b	#"S",d0
		beq.s	SegmentVars
		cmp.b	#"L",d0
		beq.s	SegmentLens
		cmp.b	#"A",d0
		beq.s	AdrRegVars
		cmp.b	#"D",d0
		beq.s	DatRegVars
		bra	FrageZeichen
SegmentVars	bsr	SearchNextChar
		addq	#1,d5
		cmp.b	#"0",d0
		bcs	FrageZeichen
		cmp.b	#"8",d0
		bcc	FrageZeichen
		sub.w	#"0",d0
		lsl.w	#3,d0
		move.l	d7,-(sp)
		move.l	d0,d7
		move.l	AllocSegs(a4,d7.w),d0
		tst.l	AllocLength(a4,d7.w)
		bpl.s	NormalSegX
		addq.l	#1,d0
		lsl.l	#2,d0
NormalSegX	suba.l	a0,a0	;keine Zuweisung moeglich
		move.l	(sp)+,d7
		rts
SegmentLens	bsr	SearchNextChar
		addq	#1,d5
		cmp.b	#"0",d0
		bcs	FrageZeichen
		cmp.b	#"8",d0
		bcc	FrageZeichen
		sub.w	#"0",d0
		lsl.w	#3,d0
		move.l	d7,-(sp)
		move.l	d0,d7
		move.l	AllocSegs(a4,d7.w),d0
		tst.l	AllocLength(a4,d7.w)
		bpl.s	NormalLenX
		lsl.l	#2,d0
		move.l	d0,a0
		move.l	-4(a0),d0
		subq	#8,d0	;Len und NextHunk zaehlen nicht
		bra.s	SpecialAL
NormalLenX	move.l	AllocLength(a4,d7.w),d0
SpecialAL	suba.l	a0,a0	;keine Zuweisung moeglich
		move.l	(sp)+,d7
		rts
AdrRegVars	;	-ni-
DatRegVars	bra	FrageZeichen

EvalVar		bsr	GetVarVal
		move.l	a0,-(sp)
		bsr	SearchNextChar
		cmp.b	#"=",d0
		beq	Zuweisung
BackOneMore	subq	#1,d5
		bsr	SearchNextChar
		cmp.b	#"^",d0
		bne.s	BackOneMore
		addq	#1,d5
		bra	CalcExpression
Zuweisung	addq	#1,d5
		bsr	CalcRoutine
		move.l	(sp)+,a0
		move.l	d3,(a0)
		bra	ZuweisungOut


	;******** Examine Task - based on ZZAs printtask *******

ExamineTask	move.l	$0004.w,a6
		bsr	SearchNextChar
		beq	FrageZeichen
		cmp.b	#$22,d0
		bne.s	HexedTask
		bsr	GetNameToBuffer
		move.l	FindBuffer(a4),a1
		CALL	Forbid
		CALL	FindTask
		move.l	D0,D4
		bne.s	DoPrintTask
		CALL	Permit
TaskUnfound	lea	TaskNotFound(pc),a0
		bsr	PrintText0
		bra	EmptyLine

HexedTask	bsr	GetHexAdress
		and.l	#$ffffffe,d0
		move.l	d0,d4
		CALL	Forbid
DoPrintTask	move.l	D4,A0
		bsr	GetTaskInfo
		CALL	Permit
		tst.l	d0
		bmi.s	TaskUnfound
		bra	EmptyLine

GetTaskInfo	RSave
		move.l	A0,A2
		lea	ProcessName(pc),a0
		cmp.b	#NT_PROCESS,LN_TYPE(a2)
		beq.s	TypeOKP
		cmp.b	#NT_TASK,LN_TYPE(A2)
		beq.s	TypeOKT
		RLoad
		moveq	#-1,D0
		rts

TypeOKT		lea	TaskNameTxt(pc),a0
TypeOKP		bsr	PrintText0
		move.l	LN_NAME(A2),a0
		move.l	a0,d0
		bne.s	HasName
		lea	Str_Unset(PC),A0
HasName		bsr	PrintText0
		lea	AdressTxt(pc),a0
		bsr	PrintText0
		move.l	A2,D0
		bsr	PrintLong
		lea	PriorityTxt(pc),a0
		bsr	PrintText0
		move.b	LN_PRI(A2),D0
		ext.w	D0
		ext.l	d0
		RSave
		bsr	PrintDezimal
		RLoad

		lea	Sign1(pc),a0
		bsr	PrintText0
		move.l	TC_SIGRECVD(A2),d0
		bsr	PrintBinaer32
		lea	Sign2(pc),a0
		bsr	PrintText0
		move.l	TC_SIGWAIT(A2),d0
		bsr	PrintBinaer32
		lea	Sign3(pc),a0
		bsr	PrintText0
		move.l	TC_SIGALLOC(A2),d0
		bsr	PrintBinaer32
		lea	Stack1(pc),a0
		bsr	PrintText0
		move.l	TC_SPUPPER(A2),d0
		bsr	PrintLong
		lea	Stack2(pc),a0
		bsr	PrintText0
		move.l	TC_SPREG(A2),d0
		bsr	PrintLong
		lea	Stack3(pc),a0
		bsr	PrintText0
		move.l	TC_SPLOWER(A2),d0
		bsr	PrintLong

	;	CLI
		cmp.b	#NT_PROCESS,LN_TYPE(a2)
		bne.s	NoCLI
		move.l	pr_CLI(A2),D0
		beq.s	NoCLI
		lea	Str_Command(PC),A0
		bsr	PrintText0
PrtCmdL		move.l	D0,A0
		add.l	A0,A0
		lea	Str_None(PC),A1
		move.l	cli_CommandName(A0,A0.l),D0
		beq.s	HasNoCmd
		move.l	D0,A1
		add.l	A1,A1
		add.l	A1,A1
HasNoCmd	moveq	#0,D1
		move.b	(A1)+,D1
		bra.s	EnterPrtCNL
PrtCNL		move.b	(A1)+,d0
		bsr	Print
EnterPrtCNL	dbf	D1,PrtCNL
		move.b	#"'",d0
		bsr	Print
		bsr	PrintReturn
NoCLI		RLoad
		clr.l	d0
		rts

BLIINK		Push	d0-d1
		move.w	#$001,d0
Blink2		move.w	#$ffff,d1
Blink1		move.w	d1,$dff180
		dbf	d1,Blink1
		dbf	d0,Blink2
		Pull	d0-d1
		rts

	;******** DISK - I/O  ************

		;*** SAVE ***

SaveFile	bsr	GetNameToBuffer
		bsr	GetHexAdress
		move.l	d0,OutPutStart(a4)
		bsr	GetHexAdress
		sub.l	OutPutStart(a4),d0
		move.l	d0,OutPutStop(a4)
		bmi	FrageZeichen
		lea	SavingText(pc),a2
		bsr	PrintText
		move.l	OutPutStart(a4),d0
		bsr	PrintLong
		move.w	#"-",d0
		bsr	Print
		move.l	OutPutStop(a4),d0
		add.l	OutPutStart(a4),d0
		bsr	PrintLong
		bsr	TextFlush
		move.l	DosBase(a4),a6
		move.l	FindBuffer(a4),d1
		move.l	#MODE_NEWFILE,d2
		CALL	Open
		move.l	d0,d7
		beq	FileError
		move.l	d0,d1
		move.l	OutPutStart(a4),d2
		move.l	OutPutStop(a4),d3
		CALL	Write
		tst.l	d0
		bmi	FileError
		move.l	d7,d1
		CALL	Close
		bra	EmptyLine

		;*** LOAD ***

LoadFile	cmp.b	#"d",(a1,d5)
		beq	AmDosLoad
		bsr	SearchNextChar
		beq	FrageZeichen
		bsr	GetNameToBuffer
		bsr	GetHexAdress
		move.l	d0,OutPutStart(a4)
		move.l	#$7fffffff,d6	;load all
		bsr	SearchNextChar
		cmp.b	#"!",d0
		beq.s	UnControlledX
		move.l	OutPutStart(a4),a0
		bsr	TopsRoutine
		move.l	d0,d6
UnControlledX	move.l	OutPutStart(a4),d0
		lea	LoadingText(pc),a2
		bsr	PrintText
		moveq.l	#"S"-"A",d0
		bsr	GetVald0
		move.l	OutPutStart(a4),d0
		move.l	d0,(a0)
		bsr	PrintLong
		move.w	#"-",d0
		bsr	Print
		bsr	TextFlush
		move.l	DosBase(a4),a6
		move.l	FindBuffer(a4),d1
		move.l	#MODE_OLDFILE,d2
		CALL	Open
		move.l	d0,d7
		beq	FileNotFound
		move.l	d0,d1
		move.l	OutPutStart(a4),d2
		move.l	d6,d3
		CALL	Read
		tst.l	d0
		bmi	FileError
		add.l	OutPutStart(a4),d0
		move.l	d0,OutPutStop(a4)
		move.l	d7,d1
		move.l	FileLocker(a4),d2
		move.l	#1,d3
		CALL	Read
		tst.l	d0
		bmi	FileError
		move.l	d0,d6
		move.l	d7,d1
		CALL	Close

		moveq.l	#"E"-"A",d0
		bsr	GetVald0
		move.l	OutPutStop(a4),d0
		move.l	d0,(a0)
		bsr	PrintLong
		tst.l	d6
		bne	Incomplete
		bra	EmptyLine
Incomplete	lea	ExceededText(pc),a2
		bsr	PrintText
		bra	EmptyLine

FileNotFound	move.l	d7,d1
		CALL	Close
		lea	FILENFText(pc),a2
IntoFNF		bsr	PrintText
		bra	EmptyLine
FileError	move.l	d7,d1
		CALL	Close
DiskError2_	lea	FileErrText(pc),a2
		bra.s	IntoFNF

DiskError2	lea	FileErrText(pc),a2
StandardNumErr	bsr	PrintText
		move.l	d7,d0
		bsr	PrintDezimal
		bra	EmptyLine
CouldNotOpenDev	lea	OpenDevErr(pc),a2
		bra.s	StandardNumErr


		;*** DIRECTORY ***

DirectoryLoad	move.l	FindBuffer(a4),a3
		clr.b	(a3)
		bsr	SearchNextChar
		beq.s	CurrentMake
		bsr	GetTextString
		beq.s	CurrentMake
		bsr	InsertText
CurrentMake	movem.l	d0-d7/a0-a2/a4-a6,-(sp)
		move.l	DosBase(a4),a6
		moveq.l	#ACCESS_READ,d2
		move.l	FindBuffer(a4),d1
		CALL	Lock
		move.l	d0,d7
		beq	DiskError2
		cmp.b	#":",-2(a3)
		beq.s	KeepSo
		cmp.b	#"/",-2(a3)
		beq.s	KeepSo
		move.b	#"/",-1(a3)
		clr.b	(a3)
KeepSo		move.l	d0,d1
		move.l	FileLocker(a4),d2
		CALL	Examine
		tst.l	d0
		beq	DirEnde
		move.l	FileLocker(a4),a0
		tst.l	4(a0)
		bmi.s	DirEnde2
		moveq.l	#0,d0
		bsr	PrintReturn
DirectoryLoop	suba.l	a0,a0
		move.l	d7,d1
		move.l	FileLocker(a4),d2
		CALL	ExNext
		tst.l	d0
		beq	DirEnde
		bsr	PrintDirLine
		bsr	TestBreak2
		bra.s	DirectoryLoop
DirEnde2	bsr	PrintReturn
		move.b	#" ",d0
		bsr	Print
		bsr	Print
		move.l	FindBuffer(a4),a2
		clr.b	-(a3)
		bsr	PrintText
		move.l	FileLocker(a4),a2
		bsr	OverName
DirEnde		move.l	d7,d1
		CALL	UnLock
		movem.l	(sp)+,d0-d7/a0-a2/a4-a6
		bra	EmptyLine

PrintDirLine	moveq.l	#0,d0
		move.b	#$05,d0	;Clear rest of line
		bsr	Print
		move.b	#" ",d0
		bsr	Print
		bsr	Print
		move.l	FindBuffer(a4),a2
		bsr	PrintText
		move.l	FileLocker(a4),a2
		moveq.l	#0,d4
PrintDirName	move.b	8(a2,d4),d0
		beq.s	OverName
		bsr	Print
		addq	#1,d4
		bra.s	PrintDirName
OverName	bsr	TextFlush
		move.w	#DirAdress,d0
		bsr	SetCursorX
		FlushCursor
		tst.l	4(a2)
		bmi.s	ItsAFile
		lea	DirTXT(pc),a2
		bsr	PrintText
		bra.s	ThisWasDir
ItsAFile	move.b	124(a2),d1
		bsr	PrintHex
		move.b	125(a2),d1
		bsr	PrintHex
		move.b	126(a2),d1
		bsr	PrintHex
		move.b	127(a2),d1
		bsr	PrintHex
ThisWasDir	bra	PrintReturn

ChangeDirectory	addq	#1,d5
		bsr	SearchNextChar
		beq.s	PrintCurrentDir
		bsr	GetTextString
		beq.s	PrintCurrentDir
		move.l	FindBuffer(a4),a3
		bsr	InsertText
		movem.l	d0-d7/a0-a2/a4-a6,-(sp)
		move.l	DosBase(a4),a6
		moveq.l	#ACCESS_READ,d2
		move.l	FindBuffer(a4),d1
		CALL	Lock
		move.l	d0,d7
		beq	DiskError2
		move.l	d0,d1
		CALL	CurrentDir
		move.l	d0,d1
		CALL	UnLock
		movem.l	(sp)+,d0-d7/a0-a2/a4-a6
		bra	EmptyLine

PrintCurrentDir	bra	EmptyLine

	;*** DIRECT DISK ACCESS ***

DiskLoad	bsr	CheckDevThere
		bsr	SearchNextChar
		beq	FrageZeichen
		addq	#1,d5
		cmp.b	#"b",d0
		beq.s	ByBlockNrRead
		cmp.b	#"o",d0
		beq.s	ByOffsetRead
		cmp.b	#"t",d0
		bne	FrageZeichen
		bsr	GetHexAdress
		cmp.w	TextWidth2(a4),d5
		bcc	FrageZeichen
		move.l	d0,d6
		mulu	DESurfaces(a4),d6
		mulu	DEBlocksPerTrack(a4),d6
		bsr	GetHexAdress
		cmp.w	DESurfaces(a4),d0
		bcc	FrageZeichen
		mulu	DEBlocksPerTrack(a4),d0
		add.l	d0,d6
		bsr	GetHexAdress
		cmp.w	DEBlocksPerTrack(a4),d0
		bcc	FrageZeichen
		add.l	d0,d6
		bra.s	InsideRead
ByOffsetRead	bsr	GetHexAdress
		divu	DESizeBlock(a4),d0
		move.l	d0,d6
		bra.s	InsideRead
ByBlockNrRead	bsr	GetHexAdress
		move.l	d0,d6
InsideRead	bsr	GetThemTwo2
		move.l	OutPutStop(a4),d4
		move.l	OutPutStart(a4),a3
		tst.l	d4
		bne.s	DoLoadb
		clr.l	d0
		move.w	DESizeBlock(a4),d4
DoLoadb		bsr	LoadBlock
		bra	EmptyLine

DiskSave	bsr	CheckDevThere
		bsr	SearchNextChar
		beq	FrageZeichen
		addq	#1,d5
		cmp.b	#"b",d0
		beq.s	ByBlockNrWrite
		cmp.b	#"o",d0
		beq.s	ByOffsetWrite
		cmp.b	#"t",d0
		bne	FrageZeichen
		bsr	GetHexAdress
		cmp.w	TextWidth2(a4),d5
		bcc	FrageZeichen
		move.l	d0,d6
		mulu	DESurfaces(a4),d6
		mulu	DEBlocksPerTrack(a4),d6
		bsr	GetHexAdress
		cmp.w	DESurfaces(a4),d0
		bcc	FrageZeichen
		mulu	DEBlocksPerTrack(a4),d0
		add.l	d0,d6
		bsr	GetHexAdress
		cmp.w	DEBlocksPerTrack(a4),d0
		bcc	FrageZeichen
		add.l	d0,d6
		bra.s	InsideBlockW
ByOffsetWrite	bsr	GetHexAdress
		divu	DESizeBlock(a4),d0
		move.l	d0,d6
		bra.s	InsideBlockW
ByBlockNrWrite	bsr	GetHexAdress
		move.l	d0,d6
InsideBlockW	bsr	GetThemTwo
		move.b	#1,Uncontrolled(a4)
		move.l	OutPutStop(a4),d4
		move.l	OutPutStart(a4),a3
		tst.l	d4
		bne.s	DoSaveb
		clr.l	d4
		move.w	DESizeBlock(a4),d4
DoSaveb		bsr	SaveBlock
		bra	EmptyLine

; Block laden, Blocknummer in d6, d4:Len a3:Adr
LoadBlock	move.w	#CMD_READ,d5
		bra.s	DiskDoings
; Block speichern, Blocknummer in d6, d4:Len a3:Adr
SaveBlock	move.w	#CMD_WRITE,d5

DiskDoings	clr.l	d0
		move.w	DESizeBlock(a4),d0
		neg.l	d0
		and.l	d0,d4	;auf volle Blocks anden
		move.l	d6,d0
		divu	DEBlocksPerTrack(a4),d0	;Ganze Seiten
		swap	d0
		tst.w	d0	;Rest = Sectoren
		beq.s	GanzerTrack
		clr.l	d2
		move.w	DEBlocksPerTrack(a4),d2
		sub.w	d0,d2
		mulu	DESizeBlock(a4),d2
		cmp.l	d2,d4
		bcs.s	GanzerTrack
		sub.l	d2,d4
		bra.s	LSF2

GanzerTrack	move.l	d4,d2
		cmp.l	DEBytesPerTrack(a4),d2
		bcs.s	LessThanFull
		move.l	DEBytesPerTrack(a4),d2
LessThanFull	sub.l	DEBytesPerTrack(a4),d4
LSF2		RSave
		move.l	d2,d7
		bsr	PrintReturn
		lea	TrackTxt(pc),a2
		bsr	PrintText
		move.l	d6,d0
		divu	DEBlocksPerTrack(a4),d0
		and.l	#$ffff,d0
		divu	DESurfaces(a4),d0
		bsr	PrintWord
		bsr	PrintSpace
		move.l	d6,d0
		divu	DEBlocksPerTrack(a4),d0
		and.l	#$ffff,d0
		divu	DESurfaces(a4),d0
		swap	d0
		bsr	PrintWord
		bsr	PrintSpace
		move.l	d6,d0
		divu	DEBlocksPerTrack(a4),d0
		swap	d0
		bsr	PrintWord
		tst.b	Uncontrolled(a4)
		bne	MemOK
		movem.l	d1-d7/a0-a6,-(sp)
		move.l	a3,a0
		bsr	TopsRoutine
		movem.l	(sp)+,d1-d7/a0-a6
		cmp.l	d0,d7
		bcs.s	MemOK
		lea	ExceededText(pc),a2
		bsr	PrintText
		bra	EmptyLine

MemOK		lea	AtTEXT(pc),a2
		bsr	PrintText
		move.l	a3,d0
		bsr	PrintLong
		move.b	#"-",d0
		bsr	Print
		move.l	a3,d0
		add.l	d7,d0
		bsr	PrintLong
		RLoad
		move.l	$0004.w,a6
		lea	Readreply(a4),a1
		move.l	OwnTask(a4),MP_SIGTASK(a1)
		CALL    AddPort
		lea	DiskIO(a4),a1
		move.l	DeviceUnit(a4),d0
		move.l	DeviceFlags(a4),d1
		move.l	DeviceName(a4),a0
		CALL	OpenDevice
		move.l	d0,d7
		bne	CouldNotOpenDev
		lea	DiskIO(a4),a1
		lea	Readreply(a4),a0
		move.l	a0,MN_REPLYPORT(a1)
		move.w	d5,IO_COMMAND(a1)
		move.l	a3,IO_DATA(a1)
		move.l	d2,IO_LENGTH(a1)
		move.l	d6,d1
		lsl.l	#8,d1
		lsl.l	#1,d1
		move.l	d1,IO_OFFSET(a1)
		CALL	DoIO
		move.l	d0,d7
		bne.s	DoError
		lea	DiskIO(a4),a1
		move.w	#CMD_UPDATE,IO_COMMAND(a1)
		CALL	DoIO
		move.l	d0,d7
		bne.s	DoError
		lea	DiskIO(a4),a1
		move.w	#TD_MOTOR,IO_COMMAND(a1)
		move.l	#0,IO_LENGTH(a1)
		CALL	DoIO
DoError		lea	Readreply(a4),a1
		CALL	RemPort
		lea	DiskIO(a4),a1
		CALL	CloseDevice
		tst.l	d7
		bne	DiskError2
		bsr	TestBreak2
		add.l	d2,a3
		lsr.l	#8,d2
		lsr.l	#1,d2
		add.l	d2,d6
		tst.l	d4
		beq.s	Overtooo
		bpl	DiskDoings
Overtooo	rts

df0name		dc.b	"df0"
		even
diskio		ds.l 20
;readreply	ds.l 8

CheckDevThere	tst.l	DeviceName(a4)
		beq.s	NeedToSet
		rts
NeedToSet	move.w	#3,d0
		lea	df0name(pc),a0
		bsr	DII
		bsr	TextFlush
		bsr	CursorUp
		bsr	CursorUp
		bsr	SearchFirstChar
		addq	#1,d5
		bsr	CursorDown
		bsr	CursorDown
		rts

ChangeDevice	bsr	GetTextString
		beq	FrageZeichen
		bsr	DII
		bra	EmptyLine

DII		move.l	FindBuffer(a4),a3
		bsr	InsertText
		move.l	DosBase(a4),a0
		move.l	dl_Root(a0),a0
		move.l	rn_Info(a0),d0
		lsl.l	#2,d0
		move.l	d0,a0
		move.l	di_DevInfo(a0),d0
		lsl.l	#2,d0
		move.l	d0,a0
FindThemLoop	cmp.l	#DLT_DEVICE,dvi_Type(a0)
		bne	NoFoundMe
		move.l	dvi_Name(a0),d0
		lsl.l	#2,d0
		move.l	d0,a1
		move.l	FindBuffer(a4),a3
		move.b	(a1)+,d2	;Len
		beq	NoFoundMe
RetryDevC	move.b	(a1)+,d3
		move.b	(a3)+,d1
		or.w	#$20,d3
		or.w	#$20,d1
		cmp.b	d3,d1
		bne	NoFoundMe
		subq	#1,d2
		bne.s	RetryDevC
		tst.b	(a3)
		bne	NoFoundMe
		move.l	dvi_Startup(a0),d0	;FSSM
		lsl.l	#2,d0
		move.l	d0,a0
		move.l	fssm_Unit(a0),DeviceUnit(a4)
		move.l	fssm_Device(a0),d0
		lsl.l	#2,d0
		addq	#1,d0
		move.l	d0,DeviceName(a4)
		move.l	fssm_Flags(a0),DeviceFlags(a4)
		move.l	fssm_Environ(a0),d0
		lsl.l	#2,d0
		move.l	d0,a0
		move.l	de_SizeBlock(a0),d0
		lsl.l	#2,d0
		move.w	d0,DESizeBlock(a4)
		move.l	de_BlocksPerTrack(a0),d1
		move.w	d1,DEBlocksPerTrack(a4)
		mulu	d0,d1
		move.l	d1,DEBytesPerTrack(a4)
		move.l	de_Surfaces(a0),d0
		move.w	d0,DESurfaces(a4)
		move.l	de_LowCyl(a0),DELowCyl(a4)
		move.l	de_HighCyl(a0),DEHighCyl(a4)
		lea	DevInf1(pc),a2
		bsr	PrintText
		move.l	DeviceName(a4),a2
		bsr	PrintText
		lea	DevInf2(pc),a2
		bsr	PrintText
		move.l	DeviceUnit(a4),d0
		bsr	PrintDezimal
		lea	DevInf3(pc),a2
		bsr	PrintText
		clr.l	d0
		move.w	DESizeBlock(a4),d0
		bsr	PrintDezimal
		lea	DevInf4(pc),a2
		bsr	PrintText
		clr.l	d0
		move.w	DESurfaces(a4),d0
		bsr	PrintDezimal
		lea	DevInf5(pc),a2
		bsr	PrintText
		clr.l	d0
		move.w	DEBlocksPerTrack(a4),d0
		bsr	PrintDezimal
		lea	DevInf6(pc),a2
		bsr	PrintText
		move.l	DELowCyl(a4),d0
		bsr	PrintDezimal
		lea	DevInf7(pc),a2
		bsr	PrintText
		move.l	DEHighCyl(a4),d0
		bsr	PrintDezimal
		rts
		
NoFoundMe	move.l	dol_Next(a0),d0
		beq.s	DevSearchOver
		lsl.l	#2,d0
		move.l	d0,a0
		bra	FindThemLoop

DevSearchOver	lea	DeviceNotFound(pc),a2
		bra	PrintText


BlockCheckSumm	cmp.b	#"D",(a1,d5)
		beq	ChangeDirectory

		bsr	GetHexAdress
		move.l	d0,a0
		move.l	d0,a2
		clr.l	$14(a2)
		moveq.l	#0,d1
		move.w	#$7f,d0
BlockCheck2	add.l	(a0)+,d1
		dbf	d0,BlockCheck2
		neg.l	d1
		move.l	d1,$14(a2)
		bsr	PrintReturn
		move.w	#"=",d0
		bsr	Print
		move.l	d1,d0
		bsr	PrintLong
		bra	EmptyLine

BootCheckSumm	bsr	GetHexAdress
		move.l	d0,a0
		move.l	d0,a2
		clr.l	$04(a2)
		moveq.l	#0,d1
		move.b	#$10,CCR
		move.w	#$ff,d0
BootCheck3	move.l	(a0)+,d2
		addx.l	d2,d1
		dbf	d0,BootCheck3
		moveq.l	#0,d2
		addx.l	d2,d1
		neg.l	d1
		move.l	d1,$04(a2)
		bsr	PrintReturn
		move.w	#"=",d0
		bsr	Print
		move.l	d1,d0
		bsr	PrintLong
		bra	EmptyLine

	;*** Printer Output ***

OutPutDevice	bsr	SearchNextChar
		bne.s	NewDefined
		bsr	PrintReturn
		move.l	OutDevice(a4),a2
		bsr	PrintText
		bra	EmptyLine
NewDefined	RSave
		move.l	DosBase(a4),a6
		move.l	OutDHandle(a4),d1
		beq.s	NoFileYet
		CALL	Close
		clr.l	OutDHandle(a4)
NoFileYet	RLoad
		bsr	GetTextString
		move.l	OutDevice(a4),a3
		bsr	InsertText
		bra	EmptyLine

PrintThemOut	move.w	#-1,PrinterFlag(a4)
		bsr	SearchNextChar
		beq	EmptyLine
		bra	SecondAuswert

	;*** Amiga-Dos-Things ***

CheckFreeMem	move.l	$0004.w,a6
		bsr	GetHexAdress
		beq	FrageZeichen
		move.l	d0,a0
		bsr	TopsRoutine
		move.l	d0,-(sp)
		lea	FreeBText(pc),a2
		bsr	PrintText
		move.l	(sp)+,d0
		bsr	PrintLong
		bra	EmptyLine

TopsRoutine	move.l	$0004.w,a1
		move.l	MemList(a1),a1
		bra.b	.HeaderLoopS
.HeaderLoop	cmp.l	MH_LOWER(a1),a0
		blo.b	.NextHeader
		cmp.l	MH_UPPER(a1),a0
		blo.b	.FoundHeader
.NextHeader	move.l	d0,a1
.HeaderLoopS	move.l	(a1),d0
		bne.b	.HeaderLoop
		bra.b	.End
.FoundHeader	move.l	MH_FIRST(a1),d0
		beq.b	.End
.ChunkLoop	cmp.l	d0,a0
		blo.b	.Fail
		move.l	d0,a1
		add.l	MC_BYTES(a1),d0
		sub.l	a0,d0
		bhs.s	.End
		move.l	(a1),d0
.ChunkLoopS	bne.b	.ChunkLoop
.Fail		moveq	#0,d0
.End		rts


AllocSegment	move.l	$0004.w,a6
		bsr	GetHexAdress
		cmp.w	#08,d0		;segmente 0-7
		bcc	FrageZeichen
		lsl.w	#3,d0
		move.w	d0,d7
		bsr	GetHexAdress
		move.l	d0,OutPutStart(a4)
		tst.l	AllocSegs(a4,d7.w)
		beq.s	SegmentUnUsed
		bsr	DeAllocSeg
SegmentUnUsed	bsr	SearchNextChar
		beq.s	AllocGeneral
		cmp.b	#"C",d0
		beq.s	DoAllocChip
		cmp.b	#"F",d0
		beq.s	DoAllocFast
		cmp.b	#"P",d0
		beq.s	DoAllocPublic
		bsr	GetHexNum
		beq	FrageZeichen
		move.l	d0,OutPutStop(a4)
		move.l	OutPutStart(a4),a1
		CALL	AllocAbs
		tst.l	d0
		beq	MemoryError
		move.l	d0,AllocSegs(a4,d7.w)
		move.l	OutPutStop(a4),AllocLength(a4,d7.w)
		bra	EmptyLine
DoAllocFast	move.l	#MEMF_FAST,d1
		bra.s	AllocGen2
DoAllocChip	move.l	#MEMF_CHIP,d1
		bra.s	AllocGen2
DoAllocPublic	;
AllocGeneral	move.l	#MEMF_PUBLIC,d1
AllocGen2	move.l	OutPutStart(a4),d0
		CALL	AllocMem
		tst.l	d0
		beq	MemoryError
		move.l	d0,AllocSegs(a4,d7.w)
		move.l	OutPutStart(a4),AllocLength(a4,d7.w)
		bra	EmptyLine
MemoryError	lea	MemError(pc),a2
		bsr	PrintText
		bra	EmptyLine

DeAllocSeg	move.l	$0004.w,a6
		move.l	AllocSegs(a4,d7.w),d1
		beq.s	NoDeAlloc
		move.l	AllocLength(a4,d7.w),d0
		cmp.l	#-1,d0
		beq.s	UnLoadSegment
		move.l	d1,a1
		CALL	FreeMem
ClearFromMM	clr.l	AllocSegs(a4,d7.w)
		clr.l	AllocLength(a4,d7.w)
NoDeAlloc	rts
UnLoadSegment	move.l	DosBase(a4),a6
		CALL	UnLoadSeg
		bra.s	ClearFromMM

FreeSegment	bsr	GetHexAdress
		cmp.w	#$08,d0
		bcc	FrageZeichen
		move.l	d0,d7
		lsl.w	#3,d7
		bsr	DeAllocSeg
		bra	EmptyLine		
		
SegmentList	bsr	SearchNextChar
		beq.s	TotalList
		bsr	GetHexAdress
		cmp.w	#$08,d0
		bcc	FrageZeichen
		lea	SegTxt2(pc),a2
		bsr	PrintText
		move.l	d0,d7
		lsl.w	#3,d7
		tst.l	AllocLength(a4,d7.w)
		bmi.s	SpecialList
		bsr	OneSegLine
		bra	EmptyLine
SpecialList	move.l	AllocSegs(a4,d7.w),d0
		lsl.l	#2,d0
		move.l	d0,a2
		moveq.l	#0,d6
NextADLine	bsr	PrintReturn
		move.w	d6,d1
		bsr	PrintHex
		bsr	PrintSpace
		move.l	a2,d0
		addq	#4,d0
		bsr	PrintLong
		bsr	PrintSpace
		move.l	-4(a2),d0
		bsr	PrintLong
		move.l	(a2),d0
		beq.s	LastSegment
		lsl.l	#2,d0
		addq	#1,d6
		move.l	d0,a2
		bsr	TestBreak2
		bra.s	NextADLine
		
LastSegment	bra	EmptyLine
		

TotalList	lea	SegTxt2(pc),a2
		bsr	PrintText
		moveq.l	#0,d7
PrintSegs	bsr	OneSegLine
		addq	#8,d7
		cmp.l	#8*8,d7
		bcs.s	PrintSegs
		bra	EmptyLine

OneSegLine	bsr	PrintReturn
		move.l	d7,d1
		lsr.w	#3,d1
		bsr	PrintHex
		bsr	PrintSpace
		move.l	AllocSegs(a4,d7.w),d0
		tst.l	AllocLength(a4,d7.w)
		bpl.s	NormalSeg
		addq.l	#1,d0
		lsl.l	#2,d0
		bsr	PrintLong
		lea	SegTxt(pc),a2
		bsr	PrintText
		bra.s	SpecialSeg
NormalSeg	bsr	PrintLong
		bsr	PrintSpace
		move.l	AllocLength(a4,d7.w),d0
		bsr	PrintLong
SpecialSeg	rts



AmDosLoad	addq	#1,d5
		bsr	SearchNextChar
		beq	FrageZeichen
		bsr	GetNameToBuffer
		bsr	GetHexAdress
		cmp.w	#$08,d0
		bcc	FrageZeichen
		move.l	d0,d7
		lsl.w	#3,d7
		bsr	DeAllocSeg
		move.l	FindBuffer(a4),d1
		move.l	DosBase(a4),a6
		CALL	LoadSeg
		tst.l	d0
		beq	DiskError2_
		move.l	d0,AllocSegs(a4,d7.w)
		move.l	#-1,AllocLength(a4,d7.w)
		bra	EmptyLine

PrintThatText	bsr	GetHexAdress
		move.l	d0,a2
PrintLimited	move.b	(a2)+,d0
		beq.s	EndeOfText
		cmp.b	#$c0,d0
		bcs.s	TakeNN
		sub.b	#$20,d0
TakeNN		bsr	Print
		bsr	TestBreak2
		bra.s	PrintLimited
EndeOfText	bra	EmptyLine

InsertText	subq	#1,d0
InsertString1	move.b	(a0)+,(a3)+
		dbf	d0,InsertString1
		clr.b	(a3)+
		rts

	;*** Error und Ausnahmeroutinen ***

InitVektors	tst.w	PatchFlag(a4)
		beq.s	StopTHAT
		lea	$08.w,a0
		add.l	VBRreg,a0
		lea	Vektors(pc),a1
		move.w	#$09,d1
MakeAntiGuru	tst.l	(a1)
		beq.s	LeaveOut
		move.l	(a0),d0
		move.l	(a1),(a0)
		move.l	d0,(a1)
LeaveOut	tst.l	(a0)+
		tst.l	(a1)+
		dbf	d1,MakeAntiGuru
StopTHAT	rts

FrageZeichen	move.l	BaseStack(a4),a7
		mulu	FontX(a4),d5		;Weil Zeiger im Textspeicher
		bsr	TextFlush
		move.l	d5,d0
		bsr	SetCursorX
		bsr	CursorRight
		FlushCursor
		move.b	#"?",d0
		bsr	Print
		bra	EmptyLine

Guru2		move.w	#2,d1
		bra.s	AllGuru
Guru3		move.w	#3,d1
		bra.s	AllGuru
Guru4		move.w	#4,d1
		bra.s	AllGuru
Guru5		move.w	#5,d1
		bra.s	AllGuru
Guru6		move.w	#6,d1
		bra.s	AllGuru
Guru7		move.w	#7,d1
		bra.s	AllGuru
Guru8		move.w	#8,d1
		bra.s	AllGuru
Guru9		move.w	#9,d1
		bra.s	AllGuru
Gurua		move.w	#$a,d1
		bra.s	AllGuru
Gurub		move.w	#$b,d1
AllGuru		move.l	ZeroPageMem,a4
		move.l	WDRastPort(a4),a5
		lea	ExceptionTX(pc),a2
		bsr	PrintText
		bsr	PrintHex
		lea	AtTEXT(pc),a2
		bsr	PrintText
		move.l	2(sp),d0
		bsr	PrintLong
		bsr	PrintSpace
		;move.l	USP,a0
		;move.l	(a0),d0
		;bsr	PrintLong
		;bsr	PrintSpace
		move.l	$0004.w,a6
		move.l	ThisTask(a6),a0
		move.l	OwnTask(a4),ThisTask(a6)
		bsr	GetTaskInfo
		tst.w	(sp)+
		tst.l	(sp)+
		move.w	#0,SR
		move.l	BaseStack(a4),a7
		move.l	IntBase(a4),a6
		move.l	MainWindow(a4),a0
		move.l	wd_WScreen,a0
		CALL	ScreenToFront
		move.l	MainWindow(a4),a0
		CALL	WindowToFront
		bra	EmptyLine

GotoCommand	bsr	SearchNextChar
		beq.s	NoFixAdress
		bsr	GetHexAdress
		and.l	#$fffffffe,d0
		move.l	d0,PCregister
NoFixAdress	move.l	PCregister,StartJsr+2
		lea	ChangeMon1(pc),a5
		move.l	$0004.w,a6
		move.l	USPstack,a0
		move.l	a7,USPstack
		move.l	a0,a7
		jmp	_LVOSupervisor(a6)
ChangeMon1	tst.l	(a7)+
		tst.w	(a7)+
		move.l	SSPstack,a0
		move.l	a7,SSPstack
		move.l	a0,a7
		move.w	SRregister,d0
		move.w	SR,d1
		and.w	#$dfff,d0	;Supervisor off!
		move.w	d0,SR
		move.w	d1,SRregister
		movem.l	RegisterSave,d0-d7/a0-a7
StartJsr	jsr	$fffffff0.l
		movem.l	d0-d7/a0-a7,RegisterSave
		move.l	$0004.w,a6
		lea	ChangeMon2(pc),a5
		jmp	_LVOSupervisor(a6)
ChangeMon2	move.w	(sp),d1
		tst.l	(a7)+
		tst.w	(a7)+
		move.l	SSPstack,a0
		move.l	a7,SSPstack
		move.l	a0,a7
		move.w	SRregister,d0
		and.w	#$dfff,d0	;clear supervisor
		move.w	d0,SR
		move.w	d1,SRregister
		move.l	USPstack,a0
		move.l	a7,USPstack
		move.l	a0,a7
		move.l	ZeroPageMem,a4
		bra	EmptyLine

BreakCommand	bsr	GetHexAdress
		and.l	#$fffffffe,d0
		move.l	d0,a0
		move.w	(a0),RememberTrap(a4)
		move.l	a0,RememberAdress(a4)
		move.w	#$4e4f,(a0)	;Trap #15
		cmp.w	#$4e4f,(a0)	;ROM ?
		bne	FrageZeichen
		lea	$bc.w,a2
		add.l	VBRreg,a2
		move.l	#BreakBack,ComeBackToMe
		bra	ExecuteTrace
BreakBack	sub.l	#2,PCregister
		move.l	RememberAdress(a4),a0
		move.w	RememberTrap(a4),(a0)
		bra	RegisterComm

TraceCommand	move.l	VBRreg,a0
		move.l	$24(a0),TraceSave
		bsr	SearchNextChar
		beq	TracePC
		bsr	GetHexAdress
		and.l	#$fffffffe,d0
		move.l	d0,PCregister
		lea	TraceStartText(pc),a2
		bsr	PrintText
TracePC		RSave
		bsr	PrintReturn
		move.l	PCregister,a0
		bsr	PrintDisLine
		bsr	TextFlush
WaitOnT		bsr	WaitForKey
		cmp.b	#$0a,d0		;Naechsten Befehl ausführen
		beq	DoNextLine
		cmp.b	#"r",d0		;Register anzeigen
		beq	RegisterSpec
		cmp.b	#"x",d0		;Trace Beenden
		beq	ExitTrace
		cmp.b	#"j",d0		;Jsr ausführen
		beq.s	JsrTracer	
		cmp.b	#"g",d0
		beq	GotoTrace
		cmp.b	#"n",d0		;Einen Befehl überspringen
		bne.s	WaitOnT
		move.l	PCregister,a0
		add.l	d7,a0
JsrTrace2	move.w	(a0),RememberTrap(a4)
		move.l	a0,RememberAdress(a4)
		move.w	#$4e4f,(a0)	;Trap #15
		cmp.w	#$4e4f,(a0)	;ROM ?
		bne.s	WaitOnT
		RLoad
		lea	$bc.w,a2
		add.l	VBRreg,a2
		move.l	(a2),OLDTRAP15(a4)
		move.l	#TraceBack2,ComeBackToMe
		bra	ExecuteTrace
TraceBack2	move.l	VBRreg,a0
		move.l	OLDTRAP15(a4),$bc(a0)
		sub.l	#2,PCregister
		move.l	RememberAdress(a4),a0
		move.w	RememberTrap(a4),(a0)
		bra	TracePC
JsrTracer	lea	$24.w,a2
		add.l	VBRreg,a2
		or.w	#$8000,SRregister	;TraceModeOn
		move.l	#TraceBack3,ComeBackToMe
		bra	ExecuteTrace
TraceBack3	move.l	VBRreg,a0
		move.l	TraceSave,$24(a0)
		move.l	USPstack,a0
		move.l	(a0),a0
		bra	JsrTrace2
GotoTrace	RLoad
		bra	NoFixAdress

RegisterSpec	bsr	PrintRegister
		bsr	TextFlush
		bra	WaitOnT
DoNextLine	RLoad
		lea	$24.w,a2
		add.l	VBRreg,a2
		or.w	#$8000,SRregister	;TraceModeOn
		move.l	#TraceBack,ComeBackToMe
		bra	ExecuteTrace
TraceBack	move.l	VBRreg,a0
		move.l	TraceSave,$24(a0)
		bra	TracePC
ExitTrace	RLoad
		bra	EmptyLine

ExecuteTrace	move.l	$0004.w,a6
		lea	ChangeMon1br(pc),a5
		move.l	USPstack,a0
		move.l	a7,USPstack
		move.l	a0,a7
		jmp	_LVOSupervisor(a6)
ChangeMon1br	tst.l	(a7)+
		tst.w	(a7)+
		move.l	SSPstack,a0
		move.l	a7,SSPstack
		move.l	a0,a7
		move.l	PCregister,-(a7)
		move.w	SRregister,-(a7)
		move.w	SR,d1
		move.w	d1,SRregister
		move.l	#ReturnToMon,(a2)
		movem.l	RegisterSave,d0-d7/a0-a6
		rte

ReturnToMon	movem.l	d0-d7/a0-a7,RegisterSave
		move.w	(sp)+,d1
		move.l	(sp)+,PCregister
		move.l	SSPstack,a0
		move.l	a7,SSPstack
		move.l	a0,a7
		move.l	USP,a0
		move.l	a0,RegisterSave+60
		move.l	USPstack,a1
		move.l	a0,USPstack
		move.w	SRregister,d0
		and.w	#$0fff,d0	;clear supervisor and trace
		and.w	#$7fff,d1
		move.w	d0,SR
		move.w	d1,SRregister
		move.l	a1,a7
		move.l	ZeroPageMem,a4
		move.l	WDRastPort(a4),a5
		move.l	ComeBackToMe,-(sp)
		rts
ComeBackToMe	dc.l	0

RegisterComm	bsr.s	PrintRegister
		bra	EmptyLine

PrintRegister	lea	RegisterSave(pc),a0
		move.w	#"d",d2
		bsr	DoRegLine
		move.w	#"a",d2
		bsr	DoRegLine2
		lea	RegText(pc),a2
		bsr	PrintText
		move.l	USPstack,d0
		bsr	PrintLong
		move.w	#" ",d0
		bsr	Print
		move.l	SSPstack,d0
		bsr	PrintLong
		move.w	#" ",d0
		bsr	Print
		move.l	PCregister,d0
		bsr	PrintLong
		bsr	PrintSpace
		move.w	SRregister,d0
		bra	PrintBinaer16

DoRegLine	move.w	#"0",d3
		bsr	PrintReturn
DDPrinter2	move.w	#6,d7
		bsr	PrintSpaces
		move.w	#"r",d0
		bsr	Print
		move.w	d3,d0
		bsr	Print
		addq	#1,d3
		cmp.w	#$38,d3
		bcs.s	DDPrinter2
DoRegLine2	bsr	PrintReturn
		move.w	#".",d0
		bsr	Print
		move.w	#"'",d0
		bsr	Print
		move.w	d2,d0
		bsr	Print
		move.w	#" ",d0
		bsr	Print
		move.w	#7,d7
		bra.s	SkipFirstspace
AdressRegs	move.b	#" ",d0
		bsr	Print
SkipFirstspace	move.l	(a0)+,d0
		bsr	PrintLong
		dbf	d7,AdressRegs
		rts

PrintSpaces	move.b	#$20,d0
		bsr	Print
		dbf	d7,PrintSpaces
		rts

GetRegister	bsr	SearchNextChar
		addq	#1,d5
		cmp.b	#"d",d0
		beq.s	DataMaker
		cmp.b	#"a",d0
		beq.s	AdressMaker
		cmp.b	#"p",d0
		bne	FrageZeichen
ProcessMaker	bsr	SearchNextChar
		beq	EmptyLine
		bsr	GetHexNum
		move.l	d0,USPstack
		bsr	SearchNextChar
		beq	EmptyLine
		bsr	GetHexNum
		move.l	d0,SSPstack
		bsr	SearchNextChar
		beq	EmptyLine
		bsr	GetHexNum
		move.l	d0,PCregister
		bsr	SearchNextChar
		beq	EmptyLine
		bsr	GetBinNum
		move.w	d0,SRregister
		bra	EmptyLine

DataMaker	lea	RegisterSave(pc),a0
		move.w	#7,d7
DataM2		bsr	SearchNextChar
		beq	EmptyLine
		bsr	GetHexNum
		move.l	d0,(a0)+
		dbf	d7,DataM2
		bra	EmptyLine

AdressMaker	lea	RegisterSave2(pc),a0
		move.w	#7,d7
AdrM2		bsr	SearchNextChar
		beq	EmptyLine
		bsr	GetHexNum
		move.l	d0,(a0)+
		dbf	d7,AdrM2
		bra	EmptyLine

		;*** TRANSFER ***

Transfer	bsr	GetStartAndEnd
		move.l	d0,a2
		bsr	GetHexAdress
		move.l	d0,a3	;Ziel
		move.l	OutPutStart(a4),a0
		move.w	#$ff,d6
TransLoop	move.b	(a0)+,(a3)+
		dbf	d6,NoBreakTry4
		bsr	TestBreak
		move.w	#$ff,d6
NoBreakTry4	cmp.l	a2,a0
		bcs.s	TransLoop
		bra	EmptyLine

		;*** OCCUPY ***

Occupy		bsr	GetStartAndEnd
		move.l	FindBuffer(a4),a0
		moveq.l	#0,d7	;Counter
		moveq.l	#0,d6	;Actual Byte
ByteNotReady2	move.b	(a1,d5),d0
		cmp.b	#" ",d0
		bne.s	CharFoundoc
		addq	#1,d5
		cmp.w	TextWidth2(a4),d5
		bcs.s	ByteNotReady2
		bra.s	StringTakeOver2
CharFoundoc	bsr	TestAdressG2
		bne	FrageZeichen
		move.b	(a1,d5),d3
		moveq	#1,d1	;One Nibble
		moveq.l	#0,d0
		bsr	ConvertNibble
		lsl.w	#4,d6
		or.w	d0,d6	;InsertNibble
		lsl.w	#4,d4
		or.w	#$0f,d4
		addq	#1,d7
		btst	#0,d7
		bne.s	ByteNotReady2
		cmp.w	#$20,d7
		bcc.s	StringTakeOver2
		move.b	d6,(a0)+
		moveq.l	#0,d6
		bra.s	ByteNotReady2
StringTakeOver2	btst	#0,d7
		beq.s	JustFinishedB2
		lsl.w	#4,d6
		move.b	d6,(a0)+
		addq	#1,d7
JustFinishedB2	lsr.w	#1,d7	;Real Number of Bytes
		move.l	FindBuffer(a4),a1
		move.l	OutPutStart(a4),a0
OccupyOn2	move.w	#$ff,d6
OccupyOn	moveq.l	#0,d1
OccupyThrough	move.b	(a1,d1),(a0)+
		cmp.l	OutPutStop(a4),a0
		bcc	EmptyLine
		addq	#1,d1
		cmp.w	d7,d1
		bcs.s	OccupyThrough
		dbf	d6,OccupyOn
		bsr	TestBreak
		bra.s	OccupyOn2


		;*** FIND ***

FindSomething	bsr	SearchNextChar
		beq	FrageZeichen
		cmp.b	#"r",d0
		beq	FindRelative
		clr.w	SpecialFind(a4)
		cmp.b	#"d",d0
		bne.s	NormalFind
		addq	#1,d5
		move.w	#1,SpecialFind(a4)
NormalFind	bsr	GetStartAndEnd
		move.l	FindBuffer(a4),a0
		move.l	MaskBuffer(a4),a2
		moveq.l	#0,d7	;Counter
		moveq.l	#0,d6	;Actual Byte
		moveq.l	#0,d4	;Actual Mask

ByteNotReady	bsr	SearchNextChar
		beq.s	StringTakeOver
CharFound	bsr	TestAdressG2
		bne.s	OtherCause
		move.b	(a1,d5),d3
		moveq	#1,d1	;One Nibble
		moveq.l	#0,d0
		bsr	ConvertNibble
		lsl.w	#4,d6
		or.w	d0,d6	;InsertNibble
		lsl.w	#4,d4
		or.w	#$0f,d4
		bra.s	NextNibble

OtherCause	cmp.b	#"*",(a1,d5)
		beq.s	JokerDO
		cmp.b	#$22,(a1,d5)
		beq.s	StringDo
		cmp.b	#"!",(a1,d5)
		bne	FrageZeichen
		move.b	(a1,d5),d0
		bra.s	StringTakeOver
StringDo	addq	#1,d5
StringLoopG	move.b	(a1,d5),d0
		addq	#1,d5
		cmp.b	#$22,d0
		beq.s	ByteNotReady
		move.b	d0,(a0)+
		move.b	#$ff,(a2)+
		addq	#2,d7
		cmp.w	#$30,d7
		bcc.s	StringTakeOver
		bra.s	StringLoopG
JokerDO		addq	#1,d5
Joker		lsl.w	#4,d6
		lsl.w	#4,d4
NextNibble	addq	#1,d7
		btst	#0,d7
		bne.s	ByteNotReady
		cmp.w	#$30,d7
		bcc.s	StringTakeOver
		move.b	d6,(a0)+
		move.b	d4,(a2)+
		moveq.l	#0,d6
		moveq.l	#0,d4
		bra	ByteNotReady
StringTakeOver	btst	#0,d7
		beq.s	JustFinishedB
		lsl.w	#4,d6
		lsl.w	#4,d4
		move.b	d6,(a0)+
		move.b	d4,(a2)+
		addq	#1,d7
JustFinishedB	lsr.w	#1,d7	;Real Number of Bytes
		move.l	d0,-(sp)
		bsr	PrintReturn
		move.l	(sp)+,d0
		move.l	FindBuffer(a4),a1
		move.l	MaskBuffer(a4),a2
		move.l	OutPutStart(a4),a0
		move.w	#$ff,d6
		cmp.b	#"!",d0
		beq.s	NotSearch
CompareOn	moveq.l	#0,d1
CompareThrough	move.b	(a0,d1),d0
		and.b	(a2,d1),d0
		cmp.b	(a1,d1),d0
		bne.s	NotFound
		addq	#1,d1
		cmp.w	d7,d1
		bcs.s	CompareThrough
		tst.w	SpecialFind(a4)
		beq.s	NormalFind2
		move.l	a0,d0
		btst	#0,d0
		bne.s	NotFound
		RSave
		bsr	PrepareForLine
		bsr	PrintDisLine
		bsr	TextFlush
		RLoad
		bsr	WaitForKey
		cmp.b	#$03,d0
		beq	EmptyLine
		bra.s	NotFound
NormalFind2	bsr	PrintSpace
		bsr	PrintSpace
		move.l	a0,d0
		bsr	PrintLong
		bsr	TextFlush
		bsr	TestBreakDown
NotFound	addq.l	#1,a0
		dbf	d6,NoBreakTry
		bsr	TestBreak
		move.w	#$ff,d6
NoBreakTry	cmp.l	OutPutStop(a4),a0
		bcs.s	CompareOn
		bra	EmptyLine

NotSearch	moveq.l	#0,d1
CompareThrough3	move.b	(a0,d1),d0
		and.b	(a2,d1),d0
		cmp.b	(a1,d1),d0
		beq.s	NotFoundxx
		addq	#1,d1
		cmp.w	d7,d1
		bcs.s	CompareThrough3
		bsr	PrintSpace
		bsr	PrintSpace
		move.l	a0,d0
		bsr	PrintLong
NotFoundxx	addq.l	#1,a0
		dbf	d6,NoBreakTry2
		bsr	TestBreak
		move.w	#$ff,d6
NoBreakTry2	cmp.l	OutPutStop(a4),a0
		bcs.s	NotSearch
		bra	EmptyLine

FindRelative	addq	#1,d5
		bsr	GetStartAndEnd
		bsr	GetHexAdress
		move.l	d0,d6
		move.l	OutPutStart(a4),d0
		and.l	#$fffffffe,d0
		move.l	d0,a0
		bsr	PrintReturn
		move.w	#$ff,d4
FRelLoop	move.w	(a0),d0
		ext.l	d0
		add.l	a0,d0
		cmp.l	d6,d0
		bne.s	NoRelFound
		bsr	PrintSpace
		bsr	PrintSpace
		move.l	a0,d0
		bsr	PrintLong
		bsr	TestBreakDown
NoRelFound	dbf	d4,NoBreakTry3
		bsr	TestBreak
		move.w	#$ff,d4
NoBreakTry3	tst.w	(a0)+
		cmp.l	OutPutStop(a4),a0
		bcs.s	FRelLoop
		bra	EmptyLine	

TestBreakDown	Push	d0-d1
		clr.l	d0
		clr.l	d1
		move.w	rp_cp_x(a5),d0
		divu	FontX(a4),d0
		move.w	TextWidth2(a4),d1
		sub.w	#10,d1
		cmp.w	d0,d1
		bcc.s	CarrRet
		move.b	#$0a,d0
		bsr	Print
		bsr	TestBreak
CarrRet		Pull	d0-d1
		rts

		;*** COMPARE ***

CompareSth	bsr	GetStartAndEnd
		bsr	SearchNextChar
		beq	FrageZeichen
		bsr	GetHexAdress
		move.l	d0,a0
		move.l	OutPutStart(a4),a1
		move.w	#$ff,d6
		bsr	PrintReturn
CompareThrough2	move.b	(a1),d0
		cmp.b	(a0)+,d0
		bne.s	CompareFound
CompT2		tst.b	(a1)+
		dbf	d6,NoBreakTry5
		bsr	TestBreak
		move.w	#$ff,d6
NoBreakTry5	cmp.l	OutPutStop(a4),a1
		bcs.s	CompareThrough2
		bra	EmptyLine

CompareFound	bsr	PrintSpace
		bsr	PrintSpace
		move.l	a1,d0
		bsr	PrintLong
		bsr	TestBreakDown
		bra.s	CompT2

		; *** Memory - Befehle ***

BMemory		move.w	TextHeight(a4),d6
		subq	#1,d6
		lsl.w	#4,d6
		bsr	GetScrollParas
		bmi	ReKey
		move.l	d0,d1
		move.b	#$0c,d0
		bsr	Print
		move.l	a0,d0
		cmp.l	d0,d1
		bcc	RightBMem
		exg.l	d0,d1
RightBMem	move.l	d0,a0
		move.l	d1,OutPutStop(a4)
		bra	PrintNextLine2

SMemory		move.w	#$10,d6
		bsr	GetScrollParas
		bmi.s	ReKey2
		bsr	PrintMemLine
ReKey2		rts

MemoryBefehl	bsr	GetThemTwo
PrintNextLine	bsr	PrintReturn
		moveq.l	#0,d4
PrintNextLine2	tst.l	d4
		bpl.s	NoOverJ
		moveq.l	#0,d4
		lea	$10(a0),a0
		add.l	#$10,OutPutStop(a4)
NoOverJ		bsr	PrintMemLine
		bsr	TestBreak
		cmp.l	OutPutStop(a4),a0
		bcs.s	PrintNextLine
		bra	EmptyLine

PrintMemLine	move.w	#".",d0
		bsr	Print
		move.w	#":",d0
		bsr	Print
		move.l	a0,d0
		bsr	PrintLong
		moveq.l	#0,d4
MemOutDo	move.w	(a0,d4),d0
		bsr	PrintWord
		addq	#2,d4
		cmp.w	#$10,d4
		bcs.s	MemOutDo
		move.w	#$0f,d4
		bra	CharPartd4

ChangeMemory	bsr	GetHexAdress
		and.l	#$fffffffe,d0
		moveq	#$0f,d4
		move.l	d0,a2
		move.l	d0,a0
ChangMem2	bsr	SearchNextChar
		beq	RePrintLine
		bsr	GetHexByte
		beq	FrageZeichen
		move.b	d0,(a2)+
		dbf	d4,ChangMem2
RePrintLine	move.b	#$0d,d0
		bsr	Print
		bsr	PrintMemLine
		bra	EmptyLine

		; *** ASCII - OUTPUT ***

BASCII		move.w	TextHeight(a4),d6
		subq	#1,d6
		lsl.w	#6,d6
		bsr	GetScrollParas
		bmi	ReKey
		move.l	d0,d1
		move.b	#$0c,d0
		bsr	Print
		move.l	a0,d0
		cmp.l	d0,d1
		bcc	RightBMem2
		exg.l	d0,d1
RightBMem2	move.l	d0,a0
		move.l	d1,OutPutStop(a4)
		bra	PrintNextAline2

SASCII		move.w	#$40,d6
		bsr	GetScrollParas
		bmi.s	ReKey3
		bsr	PrintASCIILine
ReKey3		rts

ASCIIOutput	bsr	GetThemTwo
PrintNextAline	bsr	PrintReturn
		moveq.l	#0,d4
PrintNextAline2	tst.l	d4
		bpl.s	NoOverJ2
		moveq.l	#0,d4
		lea	$40(a0),a0
		add.l	#$40,OutPutStop(a4)
NoOverJ2	bsr	PrintASCIILine
		bsr	TestBreak
		cmp.l	OutPutStop(a4),a0
		bcs.s	PrintNextAline
		bra	EmptyLine

PrintASCIILine	move.w	#".",d0
		bsr	Print
		move.w	#";",d0
		bsr	Print
		move.l	a0,d0
		bsr	PrintLong
		move.w	#$3f,d4
		bra	CharPartd4

CharPartd4	bsr	PrintSpace
CharacLoop	move.b	(a0)+,d0
		cmp.b	#$a0,d0
		bcc.s	NormPrint
		cmp.b	#$20,d0
		bcs.s	UnNormPrint
		cmp.b	#$7f,d0
		bcs.s	NormPrint
UnNormPrint	move.b	#$2e,d0
NormPrint	bsr	Print
		dbf	d4,CharacLoop
		rts

		;*** WRITE ***

WriteASCII	bsr	GetHexAdress
		move.l	d0,a2
		bsr	GetTextString
		beq	FrageZeichen
		subq	#1,d0
InsertString	move.b	(a0)+,(a2)+
		dbf	d0,InsertString
		bsr	PrintReturn
		move.l	a2,d0
		bsr	PrintLong
		bra	EmptyLine

	;*** Allgemeine Unterroutinen ***

;back: d1: negative = up, positive = down
GetScrollParas	move.b	#$0d,d0
		bsr	Print
		bsr	SearchNextChar
		beq.s	ReKeyx2
		bsr	GetHexNum
		beq.s	ReKeyx2
		move.l	d4,-(sp)
		and.l	#$fffffffe,d0
		muls	d6,d4
		move.l	d4,d1
		add.l	d0,d4
		move.l	d4,a0
		move.l	d4,OutPutStop(a4)
		moveq.l	#0,d4
OtherO		movem.l	(sp)+,d4
		rts
ReKeyx2		moveq.l	#-1,d4
		bra.s	OtherO

GetNameToBuffer	bsr	SearchNextChar
		beq	FrageZeichen
		bsr	GetTextString
		beq	FrageZeichen
		move.l	FindBuffer(a4),a3
		bra	InsertText

GetThemTwo2	clr.b	Uncontrolled(a4)
		clr.l	OutPutStop(a4)
		bsr	GetHexAdress
		and.l	#$fffffffe,d0
		move.l	d0,OutPutStart(a4)
		bsr	SearchNextChar
		beq.s	MemoryDo
		cmp.b	#"!",d0
		beq.s	UncontLine
		bsr	GetHexNum
		move.l	d0,OutPutStop(a4)
		bsr	SearchNextChar
		cmp.b	#"!",d0
		bne.s	MemoryDo
UncontLine	move.b	#1,Uncontrolled(a4)
		bra.s	MemoryDo

GetThemTwo	bsr	GetHexAdress
		and.l	#$fffffffe,d0
		move.l	d0,OutPutStart(a4)
		bsr	SearchNextChar
		beq.s	OnlyOneLine
		bsr	GetHexAdress
		move.l	d0,OutPutStop(a4)
		bra.s	MemoryDo
OnlyOneLine	move.l	OutPutStart(a4),OutPutStop(a4)
MemoryDo	move.l	OutPutStart(a4),a0
		rts

GetStartAndEnd	bsr	GetHexAdress
		move.l	d0,OutPutStart(a4)
		bsr	SearchNextChar
		beq	FrageZeichen
		bsr	GetHexAdress
		move.l	d0,OutPutStop(a4)
		rts

GetTextString	bsr	SearchNextChar
		move.l	a1,a0
		cmp.b	#$22,d0	;Anführungszeichen
		bne.s	NoQuotation
		addq	#1,d5
		add.l	d5,a0
		move.l	d5,d2
StringNotOver	move.b	(a1,d5),d0
		cmp.b	#$22,d0
		beq.s	EndeDesStrings
		cmp.b	#$0a,d0
		beq.s	EndeDesStrings
		addq	#1,d5
		cmp.w	TextWidth2(a4),d5
		bcs.s	StringNotOver
		bra	FrageZeichen
EndeDesStrings	move.w	d5,d0
		sub.w	d2,d0
		addq	#1,d5
		tst.w	d0
		rts
NoQuotation	add.l	d5,a0
		move.l	d5,d2
StringNO2	move.b	(a1,d5),d0
		cmp.b	#$20,d0
		beq.s	EndeDesStrings
		cmp.b	#$0a,d0
		beq.s	EndeDesStrings
		addq	#1,d5
		cmp.w	TextWidth2(a4),d5
		bcs.s	StringNO2
		bra	FrageZeichen

SearchFirstChar	Push	a0
		bsr	GetTextPos
		move.l	a0,a1
		Pull	a0
		moveq.l	#0,d5
SearchNextChar	move.l	d5,d2
LineNotOver	move.b	(a1,d5),d0
		cmp.b	#$20,d0
		beq.s	NextChar
		cmp.b	#$2e,d0
		beq.s	NextChar
		tst.b	d0
		rts
NextChar	addq	#1,d5
		cmp.w	TextWidth2(a4),d5
		bcs.s	LineNotOver
		move.l	d2,d5
		moveq.l	#0,d0
		rts

SearchCodea0	moveq.l	#0,d1
CodeRoutine	tst.b	(a0)
		beq.s	NoCode
		cmp.b	(a0)+,d0
		beq.s	CodeFound
		addq	#1,d1
		bra.s	CodeRoutine
CodeFound	lsl.w	#2,d1
		tst.b	d0
NoCode		rts

		;***  Exit Befehl ***

EndeDesPrg	bsr	CloseHelp2
		tst.l	OutDHandle(a4)
		beq.s	NoClose2
		move.l	DosBase(a4),a6
		move.l	OutDHandle(a4),d1
		CALL	Close
NoClose2	tst.l	BatchHandle(a4)
		beq.s	EndeDes2
		move.l	DosBase(a4),a6
		move.l	BatchHandle(a4),d1
		CALL	Close

EndeDes2	moveq.l	#0,d7
FreeAll		bsr	DeAllocSeg
		addq	#8,d7
		cmp.l	#8*8,d7
		bcs.s	FreeAll
		bsr	InitVektors

Error3		bsr	CloseDisplay

ErrorScreen	move.l	$0004.w,a6
		tst.l	DislibBase(a4)
		beq.s	NoDislib
		move.l	DislibBase(a4),a1
		CALL	CloseLibrary
NoDislib	move.l	IntBase(a4),a1
		CALL	CloseLibrary
		move.l	GraphicsBase(a4),a6
		tst.w	FontOpen(a4)
		beq.s	Error1
		move.l	FontBase(a4),a1
		CALL	CloseFont
Error1		move.l	GraphicsBase(a4),a1
		move.l	$0004.w,a6
		CALL	CloseLibrary
		lea	IORequest(a4),a1
                move.l	$0004.w,a6
                CALL	CloseDevice
ErrorTotal	move.l	BaseStack(a4),a7
		move.l	WBMessage(a4),d2
		move.l	ReturnCode(a4),d3
		move.l	ZeroSpeicher,a1
		move.l	#GesLen,d0
		CALL	FreeMem
ErrorTotal2	tst.l	d2	; WB-Start?
		beq.s	FromCLI
		move.l	d2,a1
		move.l	$0004.w,a6
		CALL	Forbid
		CALL	ReplyMsg
		rts
FromCLI		move.l	$0004.w,a6
		lea	DosName(pc),a1
		moveq	#0,d0
		CALL	OpenLibrary
		tst.l	d0
		beq.s	.NoDos
		move.l	ThisTask(a6),a0
		move.l	d0,d6
		exg	d6,a6
		move.l	pr_CurrentDir(a0),d1
		CALL	UnLock
		move.l	a6,a1
		move.l	d6,a6
		CALL	CloseLibrary
.NoDos		move.l	d3,d0
		rts

CloseDisplay	tst.l	TextScreen(a4)
		beq.s	Error2_1
		move.l	TextScreen(a4),a1
		move.l	TextSize(a4),d0
		move.l	$0004.w,a6
		CALL	FreeMem
		clr.l	TextScreen(a4)
Error2_1	tst.l	MainWindow(a4)
		beq.s	Error2
		move.l	IntBase(a4),a6
		move.l	MainWindow(a4),a0
		CALL	ClearMenuStrip
		move.l	MainWindow(a4),a0
		bsr	RemoveSignal
		CALL	CloseWindow
		clr.l	MainWindow(a4)
Error2		rts

OpenMyFont	move.l	a0,d5
		move.l	$0004.w,a6
		lea	GraphicsName(pc),a1
		moveq.l	#0,d0
		CALL	OpenLibrary
		move.l	d0,GraphicsBase(a4)
		move.l	d0,a6
		move.l	d5,d0
		tst.b	NewFontName(a4)
		beq	TakeThisFont
		lea	NewFontName(a4),a0
		move.l	a0,FontDefs
		move.w	NewFontSize(a4),FontSize

NoInsertNewF	move.l	$0004,a6
		lea	DiskFontName(pc),a1
		moveq.l	#0,d0
		CALL	OpenLibrary
		move.l	d0,a6
		beq.s	TryOrdinary
		lea	FontDefs(pc),a0
		CALL	OpenDiskFont
		move.l	d0,FontBase(a4)
		move.l	a6,a1
		move.l	$0004,a6
		CALL	CloseLibrary
		move.l	GraphicsBase(a4),a6
		move.l	FontBase(a4),d0
		bne	FontIsOk
		bra.s	ReTakeTopaz2

TryOrdinary	lea	FontDefs(pc),a0
		CALL	OpenFont
		move.l	d0,FontBase(a4)
		bne	FontIsOk
ReTakeTopaz2	bset	#0,SetError(a4)
ReTakeTopaz	lea	FontName(pc),a0
		move.l	a0,FontDefs
		move.w	#8,FontSize
		bra.s	TryOrdinary

FontIsOk	move.w	#1,FontOpen(a4)
		move.l	d0,a0
		btst.b	#FPB_PROPORTIONAL,tf_Flags(a0)
		beq.s	TakeThisFont
		bset	#1,SetError(a4)
ScreenErrorF	tst.w	FontOpen(a4)
		beq.s	ReTakeTopaz
		move.l	d0,a1
		CALL	CloseFont
		clr.w	FontOpen(a4)
		bra.s	ReTakeTopaz

TakeThisFont	move.l	d0,a0
		move.w	tf_YSize(a0),FontY(a4)
		move.w	tf_XSize(a0),FontX(a4)
		move.w	tf_Baseline(a0),Y0Pos(a4)
		move.w	FontY(a4),d0
		sub.w	tf_Baseline(a0),d0
		move.w	d0,Y0Rest(a4)
		rts

OpenDisplay	move.l	IntuitionBase(a4),a6
		tst.b	PubName(a4)
		beq.s	OpenWB
		tst.w	V36OK(a4)
		beq.s	OpenWB
		lea	PubName(a4),a0
		CALL	LockPubScreen
		tst.l	d0
		beq.s	OpenWB
		move.l	d0,WD_Screen
		move.w	#PUBLICSCREEN,SC_Type
		move.w	#PUBLICSCREEN,SC_Type2
		move.l	d0,WD_Screen2
OpenWB		lea	WindowDefs(pc),a0
		CALL	OpenWindow
		move.l	d0,MainWindow(a4)
		Push	d0/a0-a1
		tst.l	WD_Screen
		beq.s	DontUnlock
		move.l	WD_Screen,a1
		sub.l	a0,a0
		CALL	UnlockPubScreen
DontUnlock	Pull	d0/a0-a1
		tst.l	d0
		beq	Error3
		move.l	d0,a0
		move.l	wd_WScreen(a0),a1
		move.w	sc_Width(a1),wd_MaxWidth(a0)
		move.w	sc_Height(a1),wd_MaxHeight(a0)
		move.l	sc_Font(a1),ScreenFont(a4)

		RSave
		move.l	wd_RPort(a0),a1
		move.l	rp_Font(a1),a0
		move.l	a0,FontBase(a4)
		bsr	OpenMyFont
		RLoad
	
		move.w	FontX(a4),d0
		mulu	#76,d0			;78 Zeichen solltens schon sein
		add.w	#24,d0	;RAND
		cmp.w	wd_MaxWidth(a0),d0
		ble.s	ScreenReicht

		RSave
		move.l	GraphicsBase(a4),a6
		bset	#3,SetError(a4)
		move.l	FontBase(a4),d0
		bsr	ScreenErrorF
		RLoad
		move.w	FontX(a4),d0
		mulu	#76,d0
		add.w	#24,d0	;RAND

ScreenReicht	move.w	d0,d6
		cmp.w	wd_Width(a0),d0

		bcs.s	WidthIsOk

		RSave
		sub.w	wd_Width(a0),d0
		clr.l	d1
		CALL	SizeWindow
		move.l	$0004,a6
NotThat2	move.l	MainWindow(a4),a0
		move.l	wd_UserPort(a0),a0
		CALL	WaitPort
		move.l	MainWindow(a4),a0
		move.l	wd_UserPort(a0),a0
		CALL	GetMsg
		tst.l	d0
		beq	NotThat2
		move.l	d0,a1
		CALL	ReplyMsg
		RLoad

WidthIsOk	move.w	d6,wd_MinWidth(a0)

		lea	WindowDefs2(pc),a2
		move.w	wd_Width(a0),d0
		move.w	d0,nw_Width(a2)
		move.w	d0,nw_MinWidth(a2)
		move.w	d0,nw_MaxWidth(a2)
		move.w	FontY(a4),d0
		mulu	#24,d0
		add.w	#16,d0
		move.w	d0,nw_Height(a2)
		move.w	d0,nw_MinHeight(a2)
		move.w	d0,nw_MaxHeight(a2)

		bsr	SetupScreen

		move.l	wd_RPort(a0),WDRastPort(a4)
		move.l	WDRastPort(a4),a5
		bsr	EnterSignal

		move.l	a0,-(sp)
		move.l	a5,a1
		move.l	FontBase(a4),a0
		move.l	GraphicsBase(a4),a6
		CALL	SetFont
		move.l	FontBase(a4),a0
		

		lea	FirstItem(pc),a2
		bsr	RepairMenues

		lea	HelpItem(pc),a2
		bsr	RepairMenues

		move.l	(sp)+,a0
		move.l	IntuitionBase(a4),a6
		lea	FirstMenu(pc),a1
		CALL	SetMenuStrip

		move.l	$0004.w,a6
		moveq.l	#0,d0
		move.l	MainWindow(a4),a0
		move.w	wd_MaxWidth(a0),d0
		divu	FontX(a4),d0
		move.w	d0,TextWidth(a4)
		move.w	wd_MaxHeight(a0),d1
		divu	FontY(a4),d1
		mulu	d1,d0
		move.l	d0,TextSize(a4)
		move.l	#MEMF_CLEAR,d1
		CALL	AllocMem
		move.l	d0,TextScreen(a4)
		beq	Error3
		bsr	ShowInsMode
		rts

RepairMenues	move.l	ScreenFont(a4),a0
		CALL	OpenFont
		move.l	d0,a1

		move.w	tf_XSize(a1),d3
		move.w	tf_YSize(a1),d4
		sub.w	tf_Baseline(a1),d4
		add.w	tf_YSize(a1),d4
ManageMenues	move.w	6(a2),d1
		mulu	d4,d1
		move.w	d1,6(a2)	;Position
		move.w	d4,10(a2)	;Height
		move.w	8(a2),d1
		mulu	d3,d1
		move.w	d1,8(a2)
		move.l	(a2),a2
		cmp.l	#0,a2
		bne.s	ManageMenues
		CALL	CloseFont
		rts

	;******* Zahlenunterroutinen ******

TestAdressGueltig
		bsr	SearchNextChar
TestAdressG2	cmp.b	#"a",d0
		bcc.s	BuchSTT
		cmp.b	#"0",d0
		bcs.s	Ungueltig
		cmp.b	#"9"+1,d0
		bcc.s	Ungueltig
BuchSTTok	moveq.l	#0,d0
		rts
BuchSTT		cmp.b	#"g",d0
		bcs.s	BuchSTTok
Ungueltig	moveq	#1,d0
		rts

GetHexAdress	bsr	SearchNextChar
		beq	FrageZeichen
		cmp.b	#"^",d0
		beq.s	ScanVar
		cmp.b	#"&",d0
		beq.s	ScanRela
		bsr.s	GetHexNum
		beq	FrageZeichen
		rts
ScanVar		move.l	a0,-(sp)
		addq	#1,d5
		bsr	GetVarVal
		move.l	(sp)+,a0
		rts
ScanRela	move.l	a0,-(sp)
		addq	#1,d5
		bsr	GetHexNumAdr
		move.l	(sp)+,a0
		rts

GetHexNum	moveq.l	#0,d0
		moveq.l	#0,d1
GetHexNum2	move.b	(a1,d5),d3
		cmp.b	#" ",d3
		beq.s	StringOver
		cmp.b	#"A",d3
		bcc.s	BuchStb
		cmp.b	#"0",d3
		bcs.s	StringOver
		cmp.b	#"9"+1,d3
		bcc.s	StringOver
		sub.b	#"0",d3
		bra.s	Puttin
BuchStb		cmp.b	#"G",d3
		bcc.s	TakeTwo
		sub.b	#"A"-10,d3
Puttin		lsl.l	#4,d0
		or.b	d3,d0
		addq	#1,d1
		addq	#1,d5
		bra.s	GetHexNum2
StringOver	tst.l	d1
		rts
TakeTwo		cmp.b	#"a",d3
		bcs.s	StringOver
		cmp.b	#"g",d3
		bcc.s	StringOver
		sub.b	#"a"-10,d3
		bra.s	Puttin

GetHexByte	moveq.l	#0,d0
		moveq.l	#0,d1
GetHexByte2	move.b	(a1,d5),d3
		cmp.b	#" ",d3
		beq.s	StringOver3
ConvertNibble	cmp.b	#"a",d3
		bcc.s	BuchStb2
		cmp.b	#"0",d3
		bcs.s	StringOver3
		cmp.b	#"9"+1,d3
		bcc.s	StringOver3
		sub.b	#"0",d3
		bra.s	Puttin2
BuchStb2	cmp.b	#"g",d3
		bcc.s	StringOver3
		sub.b	#$57,d3
Puttin2		lsl.l	#4,d0
		or.b	d3,d0
		addq	#1,d1
		addq	#1,d5
		cmp.w	#$02,d1
		bcs.s	GetHexByte2
StringOver3	tst.l	d1
		rts

GetDezNum	moveq.l	#0,d0
		moveq.l	#0,d1
		moveq.l	#0,d2
GetDezNr	move.b	(a1,d5),d1
		cmp.b	#"0",d1
		bcs	StringOver2
		cmp.b	#"9"+1,d1
		bcc	StringOver2
		sub.w	#$30,d1
		movem.l	d1-d5,-(sp)
		move.l	#$0a,d1
		bsr	Mult32Bit
		movem.l	(sp)+,d1-d5
		add.l	d1,d0
		addq	#1,d5
		addq	#1,d2
		bra.s	GetDezNr
StringOver2	rts	

GetBinNum	moveq.l	#0,d1
GetBinLoop	bsr	SearchNextChar
		beq.s	NumOver
		lsl.l	#1,d1
		cmp.b	#"0",d0
		beq.s	PutNone
		cmp.b	#"1",d0
		bne.s	NumOver
		bset	#0,d1
PutNone		addq	#1,d5
		bra.s	GetBinLoop		
NumOver		move.l	d1,d0
		rts

PrintHex	move.b	d1,d2
		lsr.b	#4,d1
		bsr.s	GetNibble
		move.l	d1,d0
		bsr	Print
		move.b	d2,d1
		and.b	#$0f,d1
		bsr.s	GetNibble
		move.l	d1,d0
		bra	Print

GetNibble	cmp.b	#$0a,d1
		bcs.s	Number
		add.b	#"a"-$0a,d1
		rts
Number		add.b	#$30,d1
		rts

PrintWord	move.w	d0,d3
		bsr	PrintSpace
PrintWordN	move.l	d1,-(sp)
		move.w	d3,d1
		lsr.w	#8,d1
		bsr	PrintHex
		move.w	d3,d1
		bsr	PrintHex
		move.l	(sp)+,d1
		rts

PrintLong	movem.l	a0/d0-d2,-(sp)
		move.l	d0,LongTween(a4)
		moveq.l	#0,d1
		lea	LongTween(a4),a0
		move.b	0(a0),d1
		bsr	PrintHex
		move.b	1(a0),d1
		bsr	PrintHex
		move.b	2(a0),d1
		bsr	PrintHex
		move.b	3(a0),d1
		bsr	PrintHex
		movem.l	(sp)+,a0/d0-d2
		rts

PrintLongWithout movem.l	a0/d0-d2,-(sp)
		move.l	d3,LongTween(a4)
		moveq.l	#0,d1
		lea	LongTween(a4),a0
		move.b	0(a0),d1
		beq.s	PLW1
		bsr	PrintHex
PLW1		move.b	1(a0),d1
		tst.w	0(a0)
		beq.s	PLW2
		bsr	PrintHex
PLW2		move.b	2(a0),d1
		bne.s	PLW3
		tst.w	0(a0)
		beq.s	PLW4
PLW3		bsr	PrintHex
PLW4		move.b	3(a0),d1
		bsr	PrintHex
		movem.l	(sp)+,a0/d0-d2
		rts

PrintBinaer16	move.w	#15,d1
		swap	d0
		bra.s	PrintBinaerAll
PrintBinaer32	move.w	#31,d1
PrintBinaerAll	move.l	d0,d2
PrintBinaerLoop	move.w	#"0",d0
		lsl.l	#1,d2
		bcc.s	PrintAZero
		move.w	#"1",d0
PrintAZero	bsr	Print
		dbf	d1,PrintBinaerLoop
		rts

PrintDezimal	lea	DezTab(pc),a0
		move.l	d0,d1
		tst.l	d0
		bpl.s	PrDez0
		move.b	#"-",d0
		bsr	Print
		neg.l	d1
PrDez0		moveq.l	#0,d4	;leading zeroes
PrDez		moveq.l	#0,d0
		move.l	(a0)+,d2
		beq.s	DivEnde
		move.l	d1,d3
PrDez2		sub.l	d2,d3
		bmi.s	ZifferOver
		move.l	d3,d1
		addq	#1,d0
		bra.s	PrDez2
ZifferOver	tst.w	d0
		bne.s	PrintAnyWay
		tst.w	d4
		beq.s	PrDez
PrintAnyWay	moveq	#1,d4
		add.w	#$30,d0
		bsr	Print
		bra.s	PrDez
DivEnde		tst.w	d4
		bne.s	DivE2
		move.b	#"0",d0
		bsr	Print
DivE2		rts

DezTab		dc.l	1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0


;****************** Dissassembler *****************

BDizzy		tst.w	d4
		bmi.s	ComplexOne
		bsr	GetScrollParas
		bmi	ReKey
		move.l	d0,a0
		bsr.s	OneDissPage
		bra	EmptyLine

OneDissPage	move.b	#$0c,d0
		bsr	Print
		move.w	TextHeight(a4),d7
		subq	#2,d7
		bra.s	OnePD2
OnePageDown	bsr	PrintReturn
OnePD2		move.l	d7,-(sp)
		bsr	PrintDisLine
		move.l	(sp)+,d7
		dbf	d7,OnePageDown
		rts

ComplexOne	bsr	GetScrollParas
		bmi	ReKey
		move.l	d0,-(sp)
		move.b	#$0c,d0
		bsr	Print
		move.w	maxY(a4),d0
		sub.w	FontY(a4),d0
		sub.w	Y0Rest(a4),d0
		bsr	TextFlush
		move.w	d0,rp_cp_y(a5)
		move.l	(sp)+,d0
		addq.l	#2,d0
NextLineUPD	move.l	d0,d1
		sub.l	#$24,d0
TryToGetIt2	move.l	d0,a0
		movem.l	d0-d6/a0-a6,-(sp)
		bsr	GetCommandData
		movem.l	(sp)+,a0-a6/d0-d6
		ext.l	d7
		add.l	d7,d0
		cmp.l	d1,d0
		blt.s	TryToGetIt2
		move.l	a0,d0
		move.l	d0,OutPutStop(a4)
		RSave
		bsr	PrintDisLine
		move.b	#$0d,d0
		bsr	Print
		RLoad
		move.w	FontY(a4),d1
		sub.w	d1,rp_cp_y(a5)
		tst.w	rp_cp_y(a5)
		bpl.s	NextLineUPD
		move.w	maxY(a4),d1
		sub.w	FontY(a4),d1
		sub.w	Y0Rest(a4),d1
		move.w	d1,rp_cp_y(a5)
		bra	EmptyLine

SDizzy		move.b	#$0d,d0
		bsr	Print
		bsr	SearchNextChar
		beq.s	eKey2
		bsr	GetHexNum
		beq.s	eKey2
		and.l	#$fffffffe,d0
		tst.w	d4
		bpl.s	NormalDown
		move.l	d0,d1
		sub.l	#$24,d0
TryToGetIt	move.l	d0,a0
		movem.l	d0-d6/a0-a6,-(sp)
		bsr	GetCommandData
		movem.l	(sp)+,a0-a6/d0-d6
		ext.l	d7
		add.l	d7,d0
		cmp.l	d1,d0
		blt.s	TryToGetIt
		move.l	a0,d0
		bra.s	NewOne

NormalDown	movem.l	d0-d6/a0-a6,-(sp)
		move.l	d0,a0
		bsr	GetCommandData
		movem.l	(sp)+,a0-a6/d0-d6
		ext.l	d7
		add.l	d7,d0
		move.l	d0,a0
NewOne		move.l	d0,OutPutStop(a4)
		bsr	PrintDisLine
eKey2		rts

DisAssemble	bsr	GetThemTwo
PrintGain	bsr	PrepareForLine
		bsr	PrintDisLine
		bsr	TestBreak
		cmp.l	OutPutStop(a4),a0
		bcs.s	PrintGain
		bra	EmptyLine

PrepareForLine	bsr	PrintReturn
		Push	d0-d7/a0-a6
		bsr	ClearRight
		Pull	d0-d7/a0-a6
		rts

PrintDisLine	move.b	#".",d0
		bsr	Print
		move.b	#",",d0
		bsr	Print
		move.l	a0,d0
		and.l	#$fffffffe,d0
		move.l	d0,a0
		bsr	PrintLong
		bsr	TextFlush
		bsr	PrintSpace
		bsr	GetCommandData
		and.l	#$ff,d7
		add.l	d7,a0
		bsr	TextFlush
		move.w	#DInPos,d0
		bsr	SetCursorX
		FlushCursor
		move.l	d7,-(sp)
		bsr	PrintCommand
		move.l	(sp)+,d7
		rts

GetCommandData	tst.l	DislibBase(a4)
		beq.s	DoAsUsual
		movem.l	d0-d2/a0-a2/a6,-(sp)
		move.l	DislibBase(a4),a6
		move.l	a0,a1
		lea	DisStruct(a4),a2
		CALL	DisAsm
		clr.l	d7
		move.b	dl_ByteLen(a2),d7
		movem.l	(sp)+,d0-d2/a0-a2/a6
		rts

DoAsUsual	moveq.l	#0,d0
		move.b	(a0),d0
		move.w	d0,d2
		lea	DisJumpTab(pc),a2
		lsr.w	#4,d0
		lsl.w	#2,d0
		move.w	(a0),d1
		moveq.l	#0,d3
		moveq.l	#0,d5
		moveq.l	#0,d7
		jmp	(a2,d0)

DisJumpTab	bra.w	Code0000
		bra.w	Code0001
		bra.w	Code0010
		bra.w	Code0011
		bra.w	Code0100
		bra.w	Code0101
		bra.w	Code0110
		bra.w	Code0111
		bra.w	Code1000
		bra.w	Code1001
		bra.w	Code1010
		bra.w	Code1011
		bra.w	Code1100
		bra.w	Code1101
		bra.w	Code1110
		bra.w	Code1111

Code0000	tst.w	d1
		beq	SpecialORIB
NormalAsOne	lea	CommandList5(pc),a1
		bra	IdentifyCommand

SpecialORIB	move.w	2(a0),d0
		and.w	#$ff00,d0
		beq.s	NormalAsOne
		lea	DCW(pc),a2
		moveq	#AbsWordAdr,d3
		move.w	d1,d4
		moveq	#-1,d5
		moveq	#3,d2
		moveq.l	#2,d7		;len 2
		rts

Code0001	;	
Code0011	;
Code0010	lea	CommandList4(pc),a1
		bra	IdentifyCommand

Code0100	lea	CommandList(pc),a1	
		bra	IdentifyCommand

Code0101	move.w	d1,d0
		and.w	#$c0,d0
		cmp.w	#$c0,d0
		beq	DecBranch
		lea	CommandList6(pc),a1
		bra	IdentifyCommand
		
Code0110	move.w	d1,d0
		lsr.w	#8,d0
		and.l	#$0f,d0
		lea	BranchText(pc),a2
		lea	Branches(pc),a1
		lsl.w	#1,d0
		add.l	d0,a1
		move.b	(a1),1(a2)
		move.b	1(a1),2(a2)	;name
		moveq	#3,d2		;no size
		moveq	#-1,d5		;no dest
		move.w	d1,d0
		and.w	#$ff,d0
		move.l	a0,d4
		tst.w	d0
		beq.s	FarBranch
		moveq	#2,d7
		move.b	#"s",4(a2)
		ext.w	d0
BranchTogether	ext.l	d0
		add.l	d0,d4		;source data
		addq.l	#2,d4
		moveq	#AbsLongAdr,d3	;adr source
		rts
FarBranch	move.w	2(a0),d0
		move.b	#"w",4(a2)
		moveq	#4,d7
		bra.s	BranchTogether

Code0111	lea	CommandList10(pc),a1
		bra	IdentifyCommand

Code1000	lea	CommandList9(pc),a1
		bra	IdentifyCommand

Code1001	lea	CommandList11(pc),a1
		bra	IdentifyCommand
		
Code1010	lea	LineA(pc),a2
		bra	LineOther

Code1011	lea	CommandList8(pc),a1
		bra	IdentifyCommand	

Code1100	lea	CommandList7(pc),a1
		bra	IdentifyCommand

Code1101	lea	CommandList3(pc),a1
		bra	IdentifyCommand

Code1110	lea	CommandList2(pc),a1
		bra	IdentifyCommand

Code1111	lea	LineF(pc),a2
LineOther	move.w	#AbsWordAdr,d3	;adr source
		move.w	(a0),d4		;source data
LineOther2	moveq	#3,d2		;no size
		moveq.l	#-1,d5		;no destination
		moveq.l	#2,d7		;len 2
		rts

Unknown		lea	UnknownCommand(pc),a2
		bra	LineOther

DecBranch	move.w	d1,d2
		lsr.w	#3,d2
		and.w	#$07,d2
		cmp.w	#$1,d2
		bne.s	SComm
		lea	DBranchText(pc),a2
		bsr	DBAndStext
		move.w	d1,d4
		move.w	#DirDataAdr,d3
		move.w	2(a0),d6
		ext.l	d6
		add.l	a0,d6
		addq.l	#2,d6
		move.w	#AbsLongAdr,d5
		moveq.l	#4,d7
		moveq.l	#3,d2
		rts
SComm		lea	Stext(pc),a2
		bsr	DBAndStext
		addq.l	#1,a2
		move.w	d1,d3
		moveq	#2,d7
		moveq	#3,d2
		moveq.l	#-1,d5
		and.l	#$3f,d3
		move.w	d3,d1
		bsr	CalcDataAndLen
		add	d0,d7
		move.l	d1,d4
		rts

DBAndStext	move.w	d1,d2
		lsr.w	#8,d2
		and.w	#$0f,d2
		cmp.w	#$02,d2
		bcc.s	OkBleib
		add.w	#$10,d2
OkBleib		lsl.w	#1,d2
		lea	Branches(pc),a1
		move.b	(a1,d2),2(a2)
		move.b	1(a1,d2),3(a2)
		rts

;Label			Bin-Wert	  Bezeichnung   printed as:
DirDataAdr	=	%000000		; DataReg	dn
DirAdrsAdr	=	%001000		; AdressReg	an
IndAdrsAdr	=	%100000		; Adr Ind Pred	-(an)
IndAdrD16	=	%101000
AbsWordAdr	=	%111000		; absolut kurz: xxxx
AbsLongAdr	=	%111001		; absolut lang: xxxxxxxx
ImmAdr		=	%111100		; unmittelbar : #xxxx

CalcDataAndLen	movem.l	a2/d7,-(sp)
		lea	AdressModes1(pc),a2
		move.w	d1,d0
		bmi.s	ThisNegSpecials
		and.w	#$38,d0
		cmp.w	#$38,d0
		bne.s	NormalAdrModes
		lea	AdressModes2(pc),a2
		move.w	d1,d0
		and.w	#$07,d0
		lsl.w	#3,d0
NormalAdrModes	lsr.w	#1,d0
		jsr	(a2,d0)
		movem.l	(sp)+,a2/d7
		rts
ThisNegSpecials	and.w	#$0f,d0
		lsl.w	#3,d0
		lea	AdressModes3(pc),a2
		bra.s	NormalAdrModes

AdressModes1	bra.w	ModdxDirect
		bra.w	ModaxDirect
		bra.w	ModaxIndirect
		bra.w	ModaxIndirectplus
		bra.w	ModaxIndirectmin
		bra.w	ModaxIndirectd16
		bra.w	ModaxIndirectd8rg

AdressModes2	bra.w	ModabsShort
		bra.w	ModabsLong
		bra.w	ModindPC
		bra.w	ModindPCreg
		bra.w	Modimmed
		bra.w	ModimmedSpec	;101 !
		bra.w	Modimmed	;110 ! unknowm usage
		bra.w	Modimmed	;111 !

AdressModes3	bra.w	Modimmed	;unused
		bra.w	ModdxDirect	;CCR
		bra.w	ModdxDirect	;SR
		bra.w	ModdxDirect	;USP
		bra.w	ModMovem	;Movem

ModdxDirect		;	"
ModaxDirect		; no extended data !
ModaxIndirect		;	"
ModaxIndirectplus	;	"
ModaxIndirectmin	moveq.l	#0,d0
			rts
ModindPC		move.w	(a0,d7),d1
			ext.l	d1
			ext.l	d7
			add.l	a0,d1
			add.l	d7,d1
			moveq	#2,d0
			rts
ModaxIndirectd8rg	;
ModaxIndirectd16	;
ModindPCreg		;
ModabsShort		move.w	(a0,d7),d1
			moveq	#2,d0
			rts
ModabsLong		move.l	(a0,d7),d1
			moveq	#4,d0
			rts
Modimmed		cmp.w	#$02,d2
			beq.s	ModabsLong
			bra.s	ModabsShort
ModimmedSpec		move.w	#%111100,d3
			moveq.l	#0,d1
			move.w	d4,d1
			moveq.l	#0,d0
			rts
ModMovem		move.w	MovemRemember(a4),d1
			moveq.l	#0,d0
			rts


PrintCommand
;a2 : Name des Befehls
;d2 : Laenge des Operanden
;d3 : Adressmodus Quelle
;d4 : Daten für Quelle (falls nötig)
;d5 : Adressmodus Ziel
;d6 : Daten für Ziel (falls nötig)
;d7 : ByteLänge des Befehls
		tst.l	DislibBase(a4)
		beq.s	Nodislibinst
		lea	DisStruct(a4),a1
		lea	dl_Instruction(a1),a2
		bsr	PrintText
		bsr	TextFlush
		move.w	#DOpPos,d0
		bsr	SetCursorX
		FlushCursor
		lea	dl_Operands(a1),a2
		bsr	PrintText
		rts

Nodislibinst	bsr	PrintText
		and.w	#$03,d2
		cmp.w	#$03,d2
		beq.s	NoLength
		move.w	#".",d0
		bsr	Print
		tst.b	d2
		beq.s	PointB
		cmp.w	#$01,d2
		beq.s	PointW
		move.w	#"l",d0
		bra	Further
PointW		move.w	#"w",d0
		bra	Further
PointB		move.w	#"b",d0
Further		bsr	Print
NoLength	bsr	TextFlush
		move.w	#DOpPos,d0
		bsr	SetCursorX
		FlushCursor
		move.w	d3,d0
		cmp.w	#$ffff,d0
		beq.s	NOSOURCE
		move.l	d3,d1
		move.l	d4,d7
		bsr	ExecuteMode
		tst.w	d5
		cmp.w	#$ffff,d5
		beq.s	NODEST
		move.w	#",",d0
		bsr	Print
NOSOURCE	move.w	d5,d0
		cmp.w	#$ffff,d0
		beq.s	NODEST
		move.l	d5,d1
		move.l	d6,d7
		bsr	ExecuteMode
NODEST		rts

ExecuteMode	lea	ModusTab1(pc),a2
		tst.w	d0
		bpl.s	Normals
		and.w	#$0f,d0
		lsl.w	#3,d0
		lea	ModusTab3(pc),a2
		bra.s	NormalAdrMod
Normals		and.w	#$3f,d0
		cmp.w	#%111000,d0
		bcc.s	SpecialMode
		and.w	#$38,d0
		bra.s	NormalAdrMod
SpecialMode	lea	ModusTab2(pc),a2
		and.w	#$07,d0
		lsl.w	#3,d0
NormalAdrMod	lsr.w	#1,d0
		jmp	(a2,d0)

ModusTab1	bra.w	dxDirect
		bra.w	axDirect
		bra.w	axIndirect
		bra.w	axIndirectplus
		bra.w	axIndirectmin
		bra.w	axIndirectd16
		bra.w	axIndirectd8rg
ModusTab2	bra.w	absShort
		bra.w	absLong
		bra.w	indPC
		bra.w	indPCreg
		bra.w	immed
		bra.w	immed	;101 !
		bra.w	immed	;110 ! unknowm usage
		bra.w	immed	;111 !
ModusTab3	bra.w	immed	; unused
		bra.w	ToCCRSpecial
		bra.w	ToSRSpecial
		bra.w	ToUSPSpecial
		bra.w	MovemSpezial

dxDirect	move.w	#"d",d0
		bsr	Print
		and.w	#$07,d7
		add.w	#$30,d7
		move.w	d7,d0
		bra	Print
axDirect	move.w	#"a",d0
		bsr	Print
		and.w	#$07,d7
		add.w	#$30,d7
		move.w	d7,d0
		bra	Print
axIndirect	move.w	#"(",d0
		bsr	Print
		bsr	axDirect
		move.w	#")",d0
		bra	Print
axIndirectplus	bsr	axIndirect
		move.w	#"+",d0
		bra	Print
axIndirectmin	move.w	#"-",d0
		bsr	Print
		bra	axIndirect
axIndirectd16	move.w	d7,d3
		bsr	PRWordNeg
		move.w	d1,d7
		bra	axIndirect
axIndirectd8rg	movem.l	d3/d4,-(sp)
		move.w	d1,d4
		move.w	d7,d1
		bsr	PRByteNeg
		move.w	#"(",d0
		bsr	Print
		exg.l	d7,d4
		bsr	axDirect
		move.l	d4,d7
InJumpPC	move.w	#",",d0
		bsr	Print
		lsr.w	#8,d7
		lsr.w	#4,d7
		btst	#3,d7
		bne.s	AdrReg
		bsr	dxDirect
		bra.s	Further2
AdrReg		bsr	axDirect
Further2	move.b	#".",d0
		bsr	Print
		btst	#11,d4
		beq.s	WordInside
		move.b	#"l",d0
		bra.s	FurtherX
WordInside	move.b	#"w",d0
FurtherX	bsr	Print
		move.w	#")",d0
		bsr	Print
		movem.l	(sp)+,d3/d4
		rts
		
immed		move.w	#"#",d0
		bsr	Print
		bra	PrintNumber
		
absShort	move.w	d7,d3
		bra	PrintWordN

absLong		move.l	d7,d0
		bra	PrintLong

indPC		movem.l	d3/d4,-(sp)
		move.l	d7,d0
		bsr	PrintLong
		move.b	#"(",d0
		bsr	Print
		move.b	#"p",d0
		bsr	Print
		move.b	#"c",d0
		bsr	Print
		move.b	#")",d0
		bsr	Print
		movem.l	(sp)+,d3/d4
		rts

indPCreg	movem.l	d3/d4,-(sp)
		move.w	d7,d1
		bsr	PrintHex
		move.b	#"(",d0
		bsr	Print
		move.b	#"p",d0
		bsr	Print
		move.b	#"c",d0
		bsr	Print
		move.w	d7,d4
		bra	InJumpPC

ToSRSpecial	move.w	#"s",d0
		bsr	Print
		move.w	#"r",d0
		bra	Print
ToUSPSpecial	move.w	#"u",d0
		bsr	Print
		move.w	#"s",d0
		bsr	Print
		move.w	#"p",d0
		bra	Print
ToCCRSpecial	move.w	#"c",d0
		bsr	Print
		bsr	Print
		move.w	#"r",d0
		bra	Print

MovemSpezial	movem.l	d0-d7,-(sp)
		move.w	d5,d0
		move.w	d7,d4
		and.w	#$38,d0
		cmp.w	#%100000,d0
		bne.s	NormalWayRound

		move.w	d4,d2		;bits spiegeln für -(ax) adr- art
		move.w	#15,d0
umshift		roxr.w	d2
		roxl.w	d4
		dbra	d0,umshift

;d2 : bitcounter
;d4 : bits
;d5 : flag for "/"

NormalWayRound	clr.w	d5
		moveq	#-1,d6
		moveq	#-1,d3
		clr.w	d2
PrintDRegs	btst	d2,d4
		beq.s	UnUsedD
		tst.w	d5
		beq.s	ErstesReg
		move.w	d2,d0
		subq	#1,d0
		cmp.w	d0,d6
		beq.s	FollowerD
		bsr	PrintSelected
		move.w	#"/",d0
		bsr	Print
ErstesReg	move.w	d2,d7
		move.w	d2,d3
		moveq	#1,d5
		bsr	PrintRightReg
FollowerD	move.w	d2,d6		;Anfangs-Reg merken
UnUsedD		addq	#1,d2
		cmp.w	#8,d2
		beq.s	DataOver
		cmp.w	#16,d2
		bcs.s	PrintDRegs
DataOver	bsr	PrintSelected
		moveq	#-1,d6
		cmp.w	#16,d2
		bcs.s	PrintDRegs
		movem.l	(sp)+,d0-d7
		rts

PrintSelected	tst.w	d6
		bmi.s	NoPreFollow
		cmp.w	d6,d3
		beq.s	NoPreFollow
		move.w	#"-",d0
		bsr	Print
		move.w	d6,d7
PrintRightReg	cmp.w	#8,d7
		bcc	axDirect
		bra	dxDirect
NoPreFollow	rts

PrintNumber	movem.l	d0-d7/a0-a6,-(sp)
		tst.b	d2
		bne.s	SeemsNoByte
		and.l	#$ff,d7
SeemsNoByte	cmp.b	#$02,d2
		beq.s	LongWord
Word		bsr.s	PRWordNeg
		bra.s	EndNum
LongWord	bsr.s	PRLongNeg
EndNum		movem.l	(sp)+,d0-d7/a0-a6
		rts
		
PRByteNeg	move.l	d7,d1
		tst.b	d1
		bpl.s	NormalBB
		neg.b	d1
		move.b	#"-",d0
		bsr	Print
NormalBB	bra	PrintHex

PRWordNeg	move.l	d7,d3
		and.l	#$ffff,d3
		tst.w	d3
		bpl.s	NormalWW
		neg.w	d3
		move.w	#"-",d0
		bsr	Print
NormalWW	bra	PrintLongWithout

PRLongNeg	move.l	d7,d3
		tst.l	d3
		bpl.s	NormalLL
		neg.l	d3
		move.w	#"-",d0
		bsr	Print
NormalLL	bra	PrintLongWithout

IdentifyCommand	;
NextCommand	move.w	d1,d0
		and.w	CAnd(a1),d0	;Ausmaskieren
		cmp.w	CWord(a1),d0	;Befehl erkannt ?
		beq.s	CommandFound
NextCommander	lea	CLen(a1),a1	;add.l	;Naechster Befehl
		tst.l	CName(a1)	;Name Vorhanden?
		bne.s	NextCommand	;dann naechster Befehl
CommandsOver	lea	DCW(pc),a2
		move.w	#AbsWordAdr,d3	;adr source
		move.w	(a0),d4		;source data
		moveq	#3,d2		;no size
		moveq.l	#-1,d5		;no destination
		moveq.l	#2,d7		;len 2
		rts
CommandFound	move.l	CName(a1),a2	;Name holen
		move.b	CModLen(a1),d0
		beq.s	NoLenHere
		move.w	d1,d2
		move.b	d0,d3
		and.w	#$0f,d3
		lsr.w	d3,d2
		and.w	#$03,d2
		lsr.b	#4,d0
		cmp.b	#1,d0
		beq.s	MurxLen
		cmp.b	#2,d0
		bne.s	OtherLens
		and.w	#1,d2
		addq	#1,d2
		bra.s	OtherLens
MurxLen		move.w	d2,d0
		moveq.l	#0,d2
		cmp.w	#1,d0
		beq.s	OtherLens
		move.w	#2,d2
		cmp.w	#2,d0
		beq.s	OtherLens
		move.w	#1,d2
		bra.s	OtherLens
NoLenHere	moveq	#3,d2
OtherLens	moveq.l	#2,d7	;Grundlen = 2
		move.b	CSpecial(a1),d0
		cmp.b	#4,d0
		bne.s	NoMovemHere
		move.w	(a0,d7),MovemRemember(a4)
		addq	#2,d7
NoMovemHere	move.b	CModSource(a1),d0	;SourceMode Byte
		beq	NoSource	;no source = no dest
		bsr	OutMaskModes
		move.w	d1,d5	;d1 retten 
		move.w	d3,d1
		bsr	CalcDataAndLen	;Data and Len holen
		add	d0,d7
		move.l	d1,d4	;data for source
		move.b	CModDest(a1),d0		;DestMode Byte
		beq	NoDest
		movem.l	d3/d4,-(sp)
		move.l	d5,d3
		bsr	OutMaskModes2
		move.w	d3,d1
		move.w	d3,d5
		bsr	CalcDataAndLen
		add	d0,d7
		move.l	d1,d6
		movem.l	(sp)+,d3/d4
		rts

OutMaskModes	move.w	d1,d3
OutMaskModes2	move.b	d0,d4
		and.w	#$0f,d0
		lsr.w	d0,d3
		lsr.b	#2,d4
		and.w	#$3c,d4
		jmp	DissAssModes(pc,d4)

DissAssModes	bra.w	NormalMode
		bra.w	NormalMode
		bra.w	DatenMode
		bra.w	AdressMode
		bra.w	ImmedMode
		bra.w	TrapMode
		bra.w	CCRSRMovem
		bra.w	MoveSpecialTurn
		bra.w	ImmedInWord
		bra.w	Minusa0
		bra.w	a0Plus
		bra.w	MoveqSpec
		bra.w	MovepSpec

MoveSpecialTurn	and.w	#$3f,d3
		move.w	d3,d0
		lsr.w	#3,d0
		and.w	#$07,d3
		lsl.w	#3,d3
		or.w	d0,d3
		rts
MovepSpec	and.w	#$07,d3
		or.w	#%101000,d3
		rts
MoveqSpec	and.w	#$ff,d3
		bra.s	OtherWin
TrapMode	and.w	#$0f,d3
		bra.s	OtherWin
ImmedInWord	and.w	#$07,d3
		bne.s	OtherWin
		move.w	#$08,d3
OtherWin	move.w	d3,d4
		move.w	#%111101,d3
		rts
CCRSRMovem	moveq.l	#0,d3
		move.b	CSpecial(a1),d3
		or.w	#$8000,d3
		rts
Minusa0		and.w	#$07,d3
		or.w	#%100000,d3
		rts
a0Plus		and.w	#$07,d3
		or.w	#%011000,d3
		rts
ImmedMode	move.w	#ImmAdr,d3
		rts
AdressMode	and.w	#$07,d3
		or.w	#%001000,d3
		rts
DatenMode	and.w	#$07,d3
		rts
NormalMode	and.w	#$3f,d3
		rts
		
NoSource	moveq.l	#-1,d3
		moveq.l	#-1,d5
		moveq.l	#2,d7
		rts

NoDest		moveq.l	#-1,d5
		rts

TestHelp	move.l	$0004.w,a6
		tst.l	HelpWindow(a4)
		beq.s	NoMess
		move.l	HelpWindow(a4),a0
		move.l	wd_UserPort(a0),a0
		CALL	GetMsg
		tst.l	d0
		beq	NoMess
		move.l	d0,a1
		cmp.l	#CLOSEWINDOW,im_Class(a1)
		beq	CloseHelp
		cmp.l	#MOUSEBUTTONS,im_Class(a1)
		beq	CloseHelp
		CALL	ReplyMsg
		bra.s	TestHelp
NoMess		rts

PrintHelpScreen	RSave
		move.l	IntuitionBase(a4),a6
		lea	WindowDefs2(pc),a0
		CALL	OpenWindow
		move.l	d0,HelpWindow(a4)
		beq	HelpError
		move.l	d0,a0
		move.l	wd_RPort(a0),a5
		bsr	EnterSignal
		move.l	a5,a1
		move.l	FontBase(a4),a0
		move.l	GraphicsBase(a4),a6
		CALL	SetFont
		lea	HelpScreen(pc),a3
		bsr	Home
		move.w	#23,d7
PrintTheHelp	move.l	a3,a0
		move.w	#76,d0
		move.l	a5,a1
		move.l	GraphicsBase(a4),a6
		CALL	Text
		lea	76(a3),a3	;add.l
		clr.w	rp_cp_x(a5)
		move.w	FontY(a4),d0
		add.w	d0,rp_cp_y(a5)
		dbf	d7,PrintTheHelp
HelpError	RLoad
		rts

CloseHelp	CALL	ReplyMsg
		bsr	CloseHelp2
NoClHelp	bra	TestHelp

CloseHelp2	
		tst.l	HelpWindow(a4)
		beq.s	NoClHelp
		move.l	HelpWindow(a4),a0
		bsr	RemoveSignal
		move.l	IntuitionBase(a4),a6
		CALL	CloseWindow
		clr.l	HelpWindow(a4)
		rts

EnterSignal	Push	d0-d1/a0
		move.l	wd_UserPort(a0),a0
		move.b	MP_SIGBIT(a0),d0
		moveq.l	#1,d1
		lsl.l	d0,d1
		or.l	d1,SignalMask(a4)
		Pull	d0-d1/a0
		rts

RemoveSignal	Push	d0-d1/a0
		move.l	wd_UserPort(a0),a0
		move.b	MP_SIGBIT(a0),d0
		moveq.l	#1,d1
		lsl.l	d0,d1
		eor.l	#$ffffffff,d1
		and.l	d1,SignalMask(a4)
		Pull	d0-d1/a0
		rts

	;****** Bildschirm Routinen ******

TextFlush	movem.l	d0-d3/a0-a1/a6,-(sp)
		moveq.l	#0,d0
		move.w	FlushCursorX(a4),d0
		cmp.w	rp_cp_x(a5),d0
		beq.s	FlushNothing
		bsr	GetTextPos
		divu	FontX(a4),d0
		and.l	#$ffff,d0
		add.l	d0,a0
		moveq.l	#0,d2
		move.w	rp_cp_x(a5),d2
		move.w	FlushCursorX(a4),rp_cp_x(a5)
		divu	FontX(a4),d2
		and.l	#$ffff,d2
		sub.w	d0,d2	;Anzahl der Zeichen
		move.w	d2,d0
		move.l	a5,a1
		move.l	GraphicsBase(a4),a6
		CALL	Text
FlushNothing	FlushCursor
		movem.l	(sp)+,d0-d3/a0-a1/a6
		rts

ExorCursor	bsr	TextFlush
		movem.l	d0-d3/a0/a6,-(sp)
		move.l	GraphicsBase(a4),a6
		move.l	a5,a1
		move.l	#RP_COMPLEMENT!RP_INVERSVID,d0
		CALL	SetDrMd
		move.l	a5,a1
		lea	AtTEXT(pc),a0	;ist Space!
		moveq.l	#1,d0
		CALL	Text
		bsr	CursorLeft
		FlushCursor
		move.l	a5,a1
		move.l	#RP_JAM2,d0
		CALL	SetDrMd
		movem.l	(sp)+,d0-d3/a0/a6
		rts

PrintText0	movem.l	a2/d0,-(sp)
		move.l	a0,a2
		bra.s	PrintTextx2
PrintText	movem.l	a2/d0,-(sp)
PrintTextx2	moveq.l	#0,d0
PrintText2	move.b	(a2)+,d0
		beq.s	PrintTexte
		bsr	Print
		bra.s	PrintText2
PrintTexte	movem.l	(sp)+,a2/d0
		rts

		;*print*
PrintInsPoss	tst.b	InsertMode(a4)
		beq.s	Print
		movem.l	d0-d5/a0-a2/a6,-(sp)
		and.l	#$ff,d0
		beq	Printe
		cmp.w	#$20,d0
		bcs.s	NormalChars2
		cmp.w	#$a0,d0
		bcc.s	NormalIns
		cmp.w	#$7f,d0
		bcc.s	NormalChars2
NormalIns	bsr	InsertChar
		bra.s	NormalChars
PrintReturn	move.w	#$0a,d0
		bra.s	Print
PrintSpace	move.w	#" ",d0
Print		movem.l	d0-d5/a0-a2/a6,-(sp)
		and.l	#$ff,d0
		beq	Printe
		cmp.w	#$20,d0
		bcs.s	NormalChars2
		cmp.w	#$a0,d0
		bcc.s	NormalChars
		cmp.w	#$7f,d0
		bcs.s	NormalChars
NormalChars2	lea	SpecialKeyTab(pc),a0
		bsr	SearchCodea0
		beq.s	Printe
		lea	SpecialKeyBra(pc),a0
		bsr	TextFlush
		jsr	(a0,d1)
		FlushCursor
		bra	Printe
NormalChars	bsr	GetTextPos
		move.b	d0,(a0,d1)
		bsr	CursorRight
Printe		movem.l	(sp)+,d0-d5/a0-a2/a6
CursorEnde	;
		rts

CursorRight	move.w	FontX(a4),d0
		add.w	d0,rp_cp_x(a5)
ControlCRight	move.w	rp_cp_x(a5),d4
		cmp.w	maxX(a4),d4
		bcs.s	CursorEnde
		bra	CReturn

CursorLeft	move.w	FontX(a4),d0
		sub.w	d0,rp_cp_x(a5)
		bpl.s	CursorEnde
		move.w	maxX(a4),rp_cp_x(a5)
		move.w	FontX(a4),d0
		sub.w	d0,rp_cp_x(a5)
		bra	CursorUp

CursorUp	move.w	FontY(a4),d0
		sub.w	d0,rp_cp_y(a5)
		tst.w	rp_cp_y(a5)
		bpl.s	CursorEnde
		move.w	Y0Pos(a4),rp_cp_y(a5)
		bra	ScrollUp

CursorDown	move.w	FontY(a4),d0
		add.w	d0,rp_cp_y(a5)
		move.w	rp_cp_y(a5),d0
		sub.w	Y0Pos(a4),d0
		cmp.w	maxY(a4),d0
		bcs.s	CursorEnde
		move.w	FontY(a4),d0
		sub.w	d0,rp_cp_y(a5)
		bra	ScrollDown

CReturn		bsr	TextFlush
		tst.w	PrinterFlag(a4)
		beq.s	TotallyNormal
		bpl.s	PrintLineOut
		RSave
		move.w	#1,PrinterFlag(a4)
		tst.l	OutDHandle(a4)
		bne.s	FileAlreadyOpen
		move.l	DosBase(a4),a6
		move.l	OutDevice(a4),d1
		move.l	#MODE_NEWFILE,d2
		CALL	Open
		move.l	d0,OutDHandle(a4)
FileAlreadyOpen	RLoad
		bne.s	TotallyNormal
PrintError	clr.w	PrinterFlag(a4)
TotallyNormal	bsr.s	CursorDown
Return		move.w	#0,rp_cp_x(a5)
		FlushCursor
		rts
PrintLineOut	bsr	PrExecute
		bmi.s	PrintError
		bra.s	TotallyNormal

ShiftCRight	Push	d0/a0
		bsr	GetTextPos
		move.w	TextWidth2(a4),d0
		subq	#1,d0
		cmp.b	#" ",(a0,d0)
		bne.s	IsLast
SpaceDown	subq	#1,d0
		beq.s	KeepDown
		cmp.b	#" ",(a0,d0)
		beq.s	SpaceDown
KeepDown	addq	#1,d0
IsLast		bsr	SetCursorX
		Pull	d0/a0
		rts

;BACK: a0: Adresse der Zeile, d1:Offset auf Cursor
GetTextPos	Push	d0
		moveq.l	#0,d0
		move.w	rp_cp_y(a5),d0
		divu	FontY(a4),d0
		mulu	TextWidth(a4),d0
		moveq	#0,d1
		move.w	rp_cp_x(a5),d1
		divu	FontX(a4),d1
		and.l	#$ffff,d1
		add.l	TextScreen(a4),d0
		move.l	d0,a0
		Pull	d0
		rts

;d0:TextPos of Cursor
SetCursorX	Push	d0
		mulu	FontX(a4),d0
		move.w	d0,rp_cp_x(a5)
		Pull	d0
		rts

PrExecute	RSave
		move.l	OutDHandle(a4),d1
		beq.s	NoFileOpenNow
		bsr	GetTextPos
		move.l	a0,d2
		move.w	TextWidth2(a4),d3
SearchEnd	subq	#1,d3
		bmi.s	GiveAnyway
		cmp.b	#" ",(a0,d3)
		beq.s	SearchEnd
GiveAnyway	addq	#1,d3
		move.l	DosBase(a4),a6
		CALL	Write
		move.l	OutDHandle(a4),d1
		move.l	#Break,d2	;'cause its a $0a
		move.l	#1,d3
		CALL	Write
NoFileOpenNow	tst.l	d0
		RLoad
		rts

DoTab		bsr	GetTextPos
		and.w	#$fff8,d0	;alle 8 Zeichen ein Tab
		add.w	#8,d0
		bra	SetCursorX

BackSpace	bsr	CursorLeft
DeleteChar	bsr	GetTextPos
BackSpLoop	cmp.w	TextWidth2(a4),d1
		bcc.s	OutSloper
		move.b	1(a0,d1),(a0,d1)
		addq	#1,d1
		bra.s	BackSpLoop
OutSloper	move.b	#" ",(a0,d1)
		move.l	GraphicsBase(a4),a6
		move.l	a5,a1
		bsr	ClearReg
		move.w	FontX(a4),d0
		moveq.l	#0,d1
		move.w	rp_cp_x(a5),d2
		move.w	rp_cp_y(a5),d3
		sub.w	Y0Pos(a4),d3
		move.w	d3,d5
		add.w	FontY(a4),d5
		subq	#1,d5
		move.w	maxX(a4),d4
		CALL	ScrollRaster
		rts		

InsertModeSwitch eor.b	#$01,InsertMode(a4)

ShowInsMode	lea	Mode1(pc),a2
		tst.b	InsertMode(a4)
		bne.s	PrintMode1
		lea	Mode2(pc),a2
PrintMode1	lea	ScreenNameMode(pc),a0
InsertSName	move.b	(a2)+,(a0)+
		tst.b	(a2)
		bne.s	InsertSName
		move.l	IntuitionBase(a4),a6
		move.l	MainWindow(a4),a0
		lea	WindowName(pc),a1
		lea	ScreenName(pc),a2
		CALL	SetWindowTitles
		rts

InsertChar	move.l	d0,-(sp)
		bsr	GetTextPos
		move.w	TextWidth2(a4),d0
InsertCLoop	move.b	-1(a0,d0),(a0,d0)
		subq	#1,d0
		cmp.w	d1,d0
		bge.s	InsertCLoop
		move.b	#" ",(a0,d1)
		move.l	GraphicsBase(a4),a6
		move.l	a5,a1
		bsr	ClearReg
		move.w	FontX(a4),d0
		neg.l	d0
		moveq.l	#0,d1
		move.w	rp_cp_x(a5),d2
		move.w	rp_cp_y(a5),d3
		sub.w	Y0Pos(a4),d3
		move.w	d3,d5
		add.w	FontY(a4),d5
		subq	#1,d5
		move.w	maxX(a4),d4
		CALL	ScrollRaster
		move.l	(sp)+,d0
		rts		

ClearRight	bsr	GetTextPos
ClRightLoop	move.b	#" ",(a0,d1)
		addq	#1,d1
		cmp.w	TextWidth(a4),d1
		bcs.s	ClRightLoop
		move.l	GraphicsBase(a4),a6
		move.l	a5,a1
		CALL	ClearEOL
Dummy		rts

ScrollDown	movem.l	d0-d1/a0-a1,-(sp)
		clr.l	d1
		move.w	FontY(a4),d1
		bsr	DoScrolling
		moveq.l	#0,d0
		move.w	TextWidth(a4),d0
		move.l	TextScreen(a4),a0
		move.w	TextHeight(a4),d1
		subq	#1,d1
		mulu	d0,d1
		;lsr.w	#2,d1 now move.b
		subq	#1,d1
MoveIt		move.b	(a0,d0),(a0)+
		dbf	d1,MoveIt
		move.w	TextWidth(a4),d1
		subq	#1,d1
ClearIt		move.b	#$20,(a0)+
		dbf	d1,ClearIt
		movem.l	(sp)+,d0-d1/a0-a1
		rts

ScrollUp	movem.l	d0-d1/a0-a1,-(sp)
		clr.l	d1
		move.w	FontY(a4),d1
		neg.l	d1
		bsr	DoScrolling
		moveq	#0,d0
		move.w	TextWidth(a4),d0
		move.l	TextScreen(a4),a0
		move.w	TextHeight(a4),d1
		subq	#1,d1
		mulu	d0,d1
		subq	#4,d1
		add.l	d1,a0
		;lsr	#2,d1 now move.b
MoveIt2		move.b	-(a0),(a0,d0)
		dbf	d1,MoveIt2
		lea	(a0,d0),a0	;add.l
		move.w	TextWidth(a4),d1
		subq	#1,d1
ClearIt2	move.b	#$20,-(a0)
		dbf	d1,ClearIt2
		movem.l	(sp)+,d0-d1/a0-a1
		rts

DoScrolling	move.l	GraphicsBase(a4),a6
		move.l	a5,a1
		moveq.l	#0,d0
		bsr	ClearReg
		move.w	#0,d2
		move.w	#0,d3
		move.w	maxX(a4),d4
		add.w	FontX(a4),d4
		move.w	maxY(a4),d5
		subq	#1,d5
		CALL	ScrollRaster
		rts

ClearPage	bsr	ClearGraph
		bsr	ClearTextScreen
Home		move.w	#0,rp_cp_x(a5)
		move.w	Y0Pos(a4),rp_cp_y(a5)
		rts
End		move.w	maxY(a4),rp_cp_y(a5)
		move.w	Y0Rest(a4),d0
		sub.w	d0,rp_cp_y(a5)
		rts

ClearGraph	move.l	GraphicsBase(a4),a6
		move.l	a5,a1
		moveq.l	#0,d0
		CALL	SetAPen
		move.l	a5,a1
		bsr	ClearReg
		move.w	#0,d0
		move.w	#0,d1
		move.l	MainWindow(a4),a0
		move.w	wd_GZZWidth(a0),d2
		move.w	wd_GZZHeight(a0),d3
		CALL	RectFill
		move.l	a5,a1
		moveq.l	#1,d0
		CALL	SetAPen
		rts

ClearReg	and.l	#$ffff,d0
		and.l	#$ffff,d1
		and.l	#$ffff,d2
		and.l	#$ffff,d3
		and.l	#$ffff,d4
		and.l	#$ffff,d5
		rts

ClearTextScreen	move.l	TextScreen(a4),a0
		move.l	TextSize(a4),d0
		subq	#1,d0
ClearScreenTX	move.b	#$20,(a0)+
		dbf	d0,ClearScreenTX
		rts

SpecialKeyTab	dc.b	$90,$91,$92,$93,$0b,$99,$9a,$08,$09,$0a,$7f,$0c,$0d
		dc.b	$9b,$01,$05,$00
		even
SpecialKeyBra	bra.w	CursorUp	;$90
		bra.w	CursorDown	;$91
		bra.w	CursorRight	;$92
		bra.w	CursorLeft	;$93
		bra.w	ClearRight	;$0b
		bra.w	End		;$99
		bra.w	Home		;$9a
		bra.w	BackSpace	;$08
		bra.w	DoTab		;$09
		bra.w	CReturn		;$0a
		bra.w	DeleteChar	;$7f
		bra.w	ClearPage	;$0c
		bra.w	Return		;$0d
		bra.w	InsertChar	;$9b
		bra.w	InsertModeSwitch;$01
		bra.w	ShiftCRight	;$06
		

	; ********** Keyboard Routinen **********

WaitForKey	movem.l	d1-d3/d7/a0-a4/a6,-(sp)
		tst.w	InBuffLen(a4)
		beq	WaitForKey3
		sub.w	#1,InBuffLen(a4)
		move.l	InBuffPoint(a4),a0
		move.b	(a0)+,d0
		move.l	d0,InBuffPoint(a4)
DoneForKey	movem.l	(sp)+,d1-d3/d7/a0-a4/a6
		rts
WaitForKey3	bsr	TestHelp
		moveq.l	#0,d7
		bsr	GetAMessage
		tst.l	d0
		bmi.s	WaitForKey3
		bne.s	DoneForKey
		move.l	$0004.w,a6
		move.l	SignalMask(a4),d0
		CALL	Wait
		btst	#SIGBREAKB_CTRL_C,d0
		bne	EndeDesPrg
		bra.s	WaitForKey3


GetAMessage	move.l	$0004.w,a6
		move.l	MainWindow(a4),a0
		move.l	wd_UserPort(a0),a0
		CALL	GetMsg
		tst.l	d0
		beq	WaitForKey2
		move.l	d0,a1
		cmp.l	#NEWSIZE,im_Class(a1)
		beq	VerifySize
		;cmp.l	#REFRESHWINDOW,im_Class(a1)
		;beq	RefreshMe
		cmp.l	#CLOSEWINDOW,im_Class(a1)
		beq	EndeDesPrg
		cmp.l	#MOUSEBUTTONS,im_Class(a1)
		beq	MouseToCursor
		cmp.l	#MENUPICK,im_Class(a1)
		beq	MenuPicked
		cmp.l	#RAWKEY,im_Class(a1)
		bne	ShutItUp
		moveq.l	#0,d3
		moveq.l	#0,d2
		move.w	im_Code(a1),ActRaw(a4)
		move.w	im_Qualifier(a1),ActQual(a4)
		move.l	im_IAddress(a1),a0
		move.l	(a0),ActIAdress(a4)
		CALL	ReplyMsg
		cmp.w	#$60,ActRaw(a4)
		bcc.s	WaitForKey4
		lea	KeyConv(pc),a0
		move.w	ActQual(a4),d2
		move.w	#$80,d0
		btst	#0,d2
		bne.s	ShiftPressed
		btst	#1,d2
		bne.s	ShiftPressed
		moveq.l	#0,d0
ShiftPressed	or.w	ActRaw(a4),d0
		btst	#4,d2
		bne	Alternate
		btst	#5,d2
		bne	Alternate
FindConv	tst.b	(a0)
		beq.s	ConvertKey
		cmp.b	(a0)+,d0
		beq.s	ConvertIt
		tst.b	(a0)+
		bra.s	FindConv
ConvertIt	moveq.l	#0,d0
		move.b	(a0)+,d0				
Arts		rts
WaitForKey2	moveq.l	#0,d0
		rts
WaitForKey4	moveq.l	#-1,d0
		rts
Alternate	cmp.b	#$4c,d0
		bne.s	OtherCK
		move.w	#$83,d0
		rts
OtherCK		cmp.b	#$4d,d0
		bne	ConvertKey
		move.w	#$84,d0
		rts

ConvertKey	move.l	ConDevice(a4),a6
		lea	InputEventStr(a4),a0	;InputEvent
		move.l	FileLocker(a4),a1
		move.l	a1,a3
		move.w	ActQual(a4),ie_Qualifier(a0)
		move.w	ActRaw(a4),ie_Code(a0)
		move.b	#IECLASS_RAWKEY,ie_Class(a0)
		move.l	ActIAdress(a4),ie_EventAddress(a0)
		move.l	#256,d1
		sub.l	a2,a2
		CALL	RawKeyConvert
		tst.w	d0
		beq.s	WaitForKey4
		sub.w	#1,d0
		move.w	d0,InBuffLen(a4)
		move.b	(a3)+,d0
		move.l	a3,InBuffPoint(a4)
		rts

OnlyBreak	move.w	im_Code(a1),d4
		CALL	ReplyMsg
		cmp.w	#SELECTDOWN,d4
		bne.s	IgnoreIt
WaitOtherMsg	move.l	MainWindow(a4),a0
		move.l	wd_UserPort(a0),a0
		CALL	WaitPort
		move.l	MainWindow(a4),a0
		move.l	wd_UserPort(a0),a0
		CALL	GetMsg
		move.l	d0,a1
		move.w	im_Code(a1),d4
		move.l	20(a1),d2
		CALL	ReplyMsg
		cmp.l	#MOUSEBUTTONS,d2
		bne.s	WaitOtherMsg
		cmp.w	#SELECTUP,d4
		bne.s	WaitOtherMsg
		bra	GetAMessage

MouseToCursor	tst.l	d7
		bmi.s	OnlyBreak
		move.l	MainWindow(a4),a2
		clr.l	d0
		move.w	im_MouseX(a1),d2
		move.b	wd_BorderLeft(a2),d0
		sub.w	d0,d2
		move.w	im_MouseY(a1),d3
		move.b	wd_BorderTop(a2),d0
		sub.w	d0,d3
		move.w	im_Code(a1),d4
		CALL	ReplyMsg
		cmp.w	#SELECTDOWN,d4
		bne.s	IgnoreIt
		tst.w	NoCursorToMouseFlag(a4)
		beq.s	NoNoCursorToMouse
		sub.w	#1,NoCursorToMouseFlag(a4)
IgnoreIt	bra	GetAMessage

NoNoCursorToMouse 
		divu	FontX(a4),d2
		mulu	FontX(a4),d2
		divu	FontY(a4),d3
		addq	#1,d3
		mulu	FontY(a4),d3
		sub.w	Y0Rest(a4),d3
		bsr	ExorCursor
		move.w	d2,rp_cp_x(a5)
		move.w	d3,rp_cp_y(a5)
		FlushCursor
		cmp.w	maxY(a4),d3
		bcs.s	MTC2
		move.w	maxY(a4),rp_cp_y(a5)
MTC2		cmp.w	#0,d3
		bcc.s	MTC3
		move.w	#0,rp_cp_y(a5)
MTC3		bsr	ExorCursor
		;bsr	ShowInsMode
		moveq.l	#0,d0
		rts


SetupScreen	RSave
		move.l	MainWindow(a4),a0
		clr.l	d0
		move.w	wd_GZZWidth(a0),d0
		subq	#1,d0
		divu	FontX(a4),d0
		move.w	d0,TextWidth2(a4)
		mulu	FontX(a4),d0
		move.w	d0,maxX(a4)
		clr.l	d0
		move.w	wd_GZZHeight(a0),d0
		divu	FontY(a4),d0
		move.w	d0,TextHeight(a4)
		mulu	FontY(a4),d0
		move.w	d0,maxY(a4)
		RLoad
		rts

VerifySize	bsr	SetupScreen
		bsr	ReDrawScreen
ShutItUp	CALL	ReplyMsg
		bra	GetAMessage

;RefreshMe	bsr	SetupScreen
;		bsr	ReDrawScreen
;		bra.s	ShutItUp


ReDrawScreen	RSave
		move.w	rp_cp_x(a5),-(sp)
		move.w	rp_cp_y(a5),-(sp)
		bsr	ExorCursor
		bsr	ClearGraph
		clr.l	d7
		move.l	GraphicsBase(a4),a6
		move.l	TextScreen(a4),a3
		move.w	Y0Pos(a4),rp_cp_y(a5)
ReDrawLoop	move.w	#0,rp_cp_x(a5)
		move.l	a5,a1
		move.l	a3,a0
		clr.l	d0
		move.w	TextWidth2(a4),d0
		CALL	Text
		clr.l	d0
		move.w	TextWidth(a4),d0
		add.l	d0,a3
		move.w	FontY(a4),d0
		add.w	d0,rp_cp_y(a5)
		addq	#1,d7
		cmp.w	TextHeight(a4),d7
		bcs.s	ReDrawLoop

		move.w	(sp)+,rp_cp_y(a5)
		move.w	(sp)+,rp_cp_x(a5)
		move.w	rp_cp_y(a5),d0
		sub.w	Y0Pos(a4),d0
		cmp.w	maxY(a4),d0
		bcs.s	NoOUT
		move.w	maxY(a4),rp_cp_y(a5)
		move.w	Y0Rest(a4),d0
		sub.w	d0,rp_cp_y(a5)
NoOUT		bsr	ExorCursor
		RLoad
		rts

MenuPicked	move.w	im_Code(a1),d0
		move.w	d0,-(sp)
		CALL	ReplyMsg
		move.w	(sp)+,d0
		move.w	d0,d1
		and.w	#$1f,d0	;Menu-nr
		lsr.w	#5,d1
		and.w	#$3f,d1	;Item-nr
		tst.w	d0
		bne	HelpMenu
		tst.w	d1
		beq	InsertInterlace
		cmp.w	#1,d1
		beq	NowUseDislib
		cmp.w	#2,d1
		beq	NowPatchVektors
		cmp.w	#3,d1
		beq	ConfigDislib
		cmp.w	#4,d1
		beq	EndeDesPrg
		bra	IgnoreIt
InsertInterlace	;any dummy here!
		bra	IgnoreIt
ConfigDislib	tst.l	DislibBase(a4)
		beq	IgnoreIt
		RSave
		move.l	DislibBase(a4),a6
		move.l	DisStruct(a4),a0
		lea	dl_InFlags(a0),a0
		clr.l	d0
		move.l	MainWindow(a4),a0
		move.l	wd_WScreen(a0),a1
		suba.l	a2,a2
		CALL	ConfigReq
		RLoad
		bra	IgnoreIt
NowUseDislib	bsr	SwitchDislib
		bra	IgnoreIt
NowPatchVektors	bsr	InitVektors
		eor.w	#1,PatchFlag(a4)
		bsr	InitVektors
		bra	IgnoreIt
HelpMenu	cmp.w	#1,d0
		bne	IgnoreIt
		tst.l	HelpWindow(a4)
		bne	IgnoreIt
		bsr	PrintHelpScreen
		bra	IgnoreIt

TestBreak	RSave
		moveq.l	#0,d7
		bra.s	TestBreak3
TestBreak2	RSave
		moveq	#-1,d7
TestBreak3	movem.l	d1-d7/a0-a6,-(sp)
		moveq.l	#-1,d7
		bsr	GetAMessage
		movem.l	(sp)+,a0-a6/d1-d7
		tst.l	d0
		beq.s	NothingThere2
		cmp.b	#" ",d0
		beq.s	WaitCauseSpace
		cmp.b	#$03,d0	;ctrl-c
		bne.s	TestBreak3	;Alle tasten aus dem Buffer holen!
		tst.l	d7
		beq.s	ComplexEnd
		RLoad
		move.l	BaseStack(a4),a7
		lea	Break(pc),a2
		bsr	PrintText
		bra	EmptyLine
NothingThere2	clr.l	d0
NothingThere	RLoad	
		rts
ComplexEnd	RLoad
		move.l	BaseStack(a4),a7
		lea	Break(pc),a2
		bsr	PrintText
		lea	AtTEXT(pc),a2
		bsr	PrintText
		move.l	a0,d0
		bsr	PrintLong
		bra	EmptyLine
WaitCauseSpace	bsr	WaitForKey
		bra.s	NothingThere2

	;********** ASSEMBLER *************

InstAssembler	bsr	GetHexAdress
		move.l	d0,a3
		bra	AssembleStart

Assemble	bsr	GetHexAdress
		and.l	#$fffffffe,d0
		move.l	d0,AssembleAdr(a4)
		;move.w	#DInPos,d5
		bsr	SearchNextChar
		beq	FrageZeichen
		move.l	FindBuffer(a4),a0
		moveq.l	#0,d1
NextCharA	move.b	(a1,d5),d0
		cmp.b	#".",d0
		beq.s	BefehlOver
		cmp.b	#" ",d0
		beq.s	WordSize	;Bei Nichtangabe wird Word angenommen
		move.b	d0,(a0)+
		addq	#1,d1
		addq	#1,d5
		cmp.w	#20,d1
		bcs.s	NextCharA
		bra	FrageZeichen
BefehlOver	tst.w	d1
		beq	FrageZeichen
		addq	#1,d5
		move.b	(a1,d5),d0
		cmp.b	#"b",d0
		beq.s	ByteSize
		cmp.b	#"s",d0
		beq.s	ShortSize
		cmp.b	#"w",d0
		beq.s	WordSize
		cmp.b	#"l",d0
		bne	FrageZeichen
LongSize	move.w	#%10,d2
		bra.s	AllSizes
ShortSize	move.w	#%11,d2
		bra.s	AllSizes
ByteSize	moveq.l	#0,d2
		bra.s	AllSizes
WordSize	move.w	#%01,d2
AllSizes	move.w	d2,CommandSize(a4)
		clr.b	(a0)
		addq	#1,d5
		move.w	#-1,AdrModeSource(a4)
		move.w	#-1,AdrModeDest(a4)
		bsr	SearchNextChar
		beq	NothingFollows
		bsr	DissExpression
		bmi	FrageZeichen
		move.l	d6,AdrDataSource(a4)
		move.w	d7,AdrModeSource(a4)
		bsr	SearchNextChar
		beq	NothingFollows
		cmp.b	#",",d0
		bne	FrageZeichen
		addq	#1,d5
		bsr	SearchNextChar
		beq	FrageZeichen
		bsr	DissExpression
		bmi	FrageZeichen
		move.l	d6,AdrDataDest(a4)
		move.w	d7,AdrModeDest(a4)

NothingFollows	move.w	AdrModeSource(a4),d0
		bsr	CalcAdrMBit
		move.w	d1,ModeBitSource(a4)
		move.w	AdrModeDest(a4),d0
		bsr	CalcAdrMBit
		move.w	d1,ModeBitDest(a4)
		moveq.l	#0,d3
		move.l	FindBuffer(a4),a0
		cmp.b	#"b",(a0)
		beq	PossibleBranch
		cmp.b	#"d",(a0)
		beq	PossibleDBranch
		cmp.b	#"s",(a0)
		beq	PossibleSCond
ThisIsNoBr	lea	CommandList(pc),a2
CompareList	tst.l	(a2)
		bne.s	NextAvaible
		addq.l	#4,a2
		tst.l	(a2)		;DoppelNuller = Echtes Ende
		beq	FrageZeichen	;Unknown Command
NextAvaible	move.l	(a2),a3
		moveq.l	#0,d0
CompareString	move.b	(a0,d0),d1
		beq.s	StringEqual
		cmp.b	(a3,d0),d1
		bne.s	NextString
		addq	#1,d0
		bra.s	CompareString
NextString	lea	CLen(a2),a2	;add.l
		bra.s	CompareList
StringEqual	cmp.b	(a3,d0),d1
		bne.s	NextString
		move.w	ModeBitSource(a4),d0
		move.w	CAdrSource(a2),d1	
		tst.w	d0
		bpl.s	SourceThere
		tst.w	d1
		bmi.s	NewSMode
		bne.s	NextString
		bra.s	Control1
NewSMode	cmp.b	CSpecial(a2),d0
		bne.s	NextString
		cmp.b	#4,d0
		bne.s	Control1
		cmp.w	#7,ModeBitDest(a4)
		bne.s	Control1
		move.l	AdrDataSource(a4),d0
		move.w	#15,d2
TurnItMV	roxr.w	d0
		roxl.w	d1
		dbf	d2,TurnItMV
		move.l	d1,AdrDataSource(a4)
		bra.s	Control1
SourceThere	btst	d0,d1
		beq.s	NextString
		bsr	TestByteAdr
		beq.s	NextString
Control1	
		move.w	ModeBitDest(a4),d0
		move.w	CAdrDest(a2),d1
		tst.w	d0
		bpl.s	DestThere
		tst.w	d1
		bmi.s	NewDMode
		bne.s	NextString
		bra.s	Control2
NewDMode	cmp.b	CSpecial(a2),d0
		bne	NextString
		bra.s	Control2
DestThere	btst	d0,d1
		beq	NextString
		bsr	TestByteAdr
		beq	NextString
Control2	move.b	CModLen(a2),d0
		beq.s	NoSizeAtAll
		move.w	CommandSize(a4),d6
		and.w	#$03,d6
		lsr.b	#4,d0
		tst.b	d6
		bne.s	Control3
		tst.b	d0
		beq.s	NoSizeAtAll
		cmp.b	#1,d0
		bne	NextString
LikeThis01	addq	#1,d6
		bra.s	NoSizeAtAll
Control3	cmp.b	#%01,d6
		beq.s	Control3a
		cmp.b	#%10,d6
		bne.s	Control4
Control3a	tst.b	d0
		beq.s	NoSizeAtAll
		cmp.b	#1,d0
		bne.s	Control3b
		cmp.b	#%10,d6
		beq.s	NoSizeAtAll
		moveq	#%11,d6
		bra.s	NoSizeAtAll
Control3b	cmp.b	#2,d0
		bne	NextString
		addq	#1,d6
		and.w	#1,d6	;Angleichen für w,l sizes
Control4	cmp.b	#%11,d6
		bne.s	Control5
		cmp.b	#3,d0
		bne	NextString
Control5	;
NoSizeAtAll	move.l	AssembleAdr(a4),a3
		addq.l	#2,a3
		cmp.w	#$8004,AdrModeDest(a4)
		bne.s	KeepNormalWay
		move.l	AdrDataDest(a4),d0
		move.w	d0,(a3)+
		move.w	#$8003,ModeBitDest(a4)
KeepNormalWay	move.w	CWord(a2),d7
		move.b	CModSource(a2),d0
		move.w	AdrModeSource(a4),d1
		move.l	AdrDataSource(a4),d2
		move.w	ModeBitSource(a4),d3
		bsr	GenerateOR
		move.b	CModDest(a2),d0
		move.w	AdrModeDest(a4),d1
		move.l	AdrDataDest(a4),d2
		move.w	ModeBitDest(a4),d3
		bsr	GenerateOR
		move.b	CModLen(a2),d0
		beq.s	NoSizeDoings
		and.w	#$0f,d0
		lsl.w	d0,d6
		or.w	d6,d7
NoSizeDoings	move.l	AssembleAdr(a4),a0
		move.w	d7,(a0)
		bsr	CursorUp
		bsr	GetCommandData
		bsr	PrepareForLine
		bsr	PrintDisLine
AssembleStart	bsr	PrintReturn
		move.b	#".",d0
		bsr	Print
		move.b	#",",d0
		bsr	Print
		move.l	a3,d0
		bsr	PrintLong
		bsr	TextFlush
		move.w	#DInPos,d0
		bsr	SetCursorX
		FlushCursor
		bra	ReKey

TestByteAdr	tst.w	CommandSize(a4)
		bne.s	SchonMalGut
		cmp.b	#10,d0
SchonMalGut	rts

GenerateOR	move.b	d0,d4
		lsr.b	#2,d4
		and.w	#$3c,d4
		lea	ModeBase(pc),a0
		jsr	(a0,d4)
		and.w	#$0f,d0
		lsl.w	d0,d1
		or.w	d1,d7
		move.w	d3,d4	
		bpl.s	KeepTruth
		moveq	#1,d4
		cmp.w	#$8004,d3
		beq.s	KeepTruth
		move.w	#10,d4
KeepTruth	lsl.w	#2,d4
		and.w	#$3c,d4
		lea	AdrMBase(pc),a0
		jsr	(a0,d4)
		rts

ModeBase	bra.w	NothingTH
		bra.w	Normal6
		bra.w	Normal3
		bra.w	Normal3
		bra.w	ImmediateToNext
		bra.w	Special9
		bra.w	CCRetc
		bra.w	Special6
		bra.w	Special8
		bra.w	Normal3
		bra.w	Normal3
		bra.w	Specialb
		bra.w	Normal3

ImmediateToNext	;
CCRetc		;
NothingTH	moveq.l	#0,d1
		rts
Normal6		and.w	#$3f,d1
		rts
Normal3		and.w	#$07,d1
		rts

Special6	and.w	#$3f,d1
		move.w	d1,d4
		lsr.w	#3,d4
		and.w	#$07,d1
		lsl.w	#3,d1
		or.w	d4,d1
		rts
Special8	move.w	d2,d1
		and.w	#$07,d1
LikeSpec8	and.w	#$0f,d0
		lsl.w	d0,d1
		or.w	d1,d7
		move.l	(sp)+,d0	;Rücksprung Adress
		rts
Specialb	move.w	d2,d1
		and.w	#$ff,d1
		bra.s	LikeSpec8
Special9	move.w	d2,d1
		and.w	#$0f,d1
		bra.s	LikeSpec8

AdrMBase	bra.w	PutLikeLen	;Immediate
		bra.w	PutAWord	;xx(pc,xn)
		bra.w	PutAWord	;xx(pc)
		bra.w	PutALong	;$xxxxxxxx
		bra.w	PutAWord	;$xxxx
		bra.w	PutAWord	;xx(ax,xn)
		bra.w	PutAWord	;xx(an)
		bra.w	NoExtraBB	;-(an)
		bra.w	NoExtraBB	;(an)+
		bra.w	NoExtraBB	;(an)
		bra.w	NoExtraBB	;an
		bra.w	NoExtraBB	;dn

		bra.w	NoExtraBB
		bra.w	NoExtraBB
		bra.w	NoExtraBB
		bra.w	NoExtraBB

PutLikeLen	move.w	CommandSize(a4),d0
		and.w	#$03,d0
		cmp.b	#%10,d0
		beq.s	PutALong
PutAWord	move.w	d2,(a3)+
		rts
PutALong	move.l	d2,(a3)+
NoExtraBB	rts

AnalyseBranch	moveq.l	#0,d0
AnalyseBranch2	lea	Branches(pc),a2
BranchTryer	move.b	1(a0),d1
		cmp.b	(a2,d0),d1
		bne.s	NextBTry
		move.b	2(a0),d1
		cmp.b	1(a2,d0),d1
		beq.s	BranchFound
NextBTry	addq	#2,d0
		cmp.w	#$24,d0
		bcs.s	BranchTryer
NoBranch	moveq	#-1,d0
		rts
BranchFound	lsl.w	#7,d0
		rts


PossibleBranch	bsr.s	AnalyseBranch
		bmi	ThisIsNoBr
		cmp.w	#$1000,d0
		bcc	ThisIsNoBr
		or.w	#$6000,d0
		move.w	d0,d7
		tst.w	AdrModeDest(a4)
		bpl	ThisIsNoBr
		tst.b	3(a0)
		bne	ThisIsNoBr
		move.w	AdrModeSource(a4),d1
		move.l	AdrDataSource(a4),d0
OtherIBR	cmp.w	#%111000,d1
		beq.s	ReallyFound2
		cmp.w	#%111001,d1
		bne	ThisIsNoBr
ReallyFound2	move.l	AssembleAdr(a4),a3
		addq.l	#2,a3
		sub.l	a3,d0
		cmp.l	#-$7fff,d0
		bcc.s	TakeOkSoS
		cmp.l	#$8000,d0
		bcc	ThisIsNoBr
TakeOkSoS	and.l	#$ffff,d0
		cmp.w	#%11,CommandSize(a4)
		beq.s	ShortBranchTry
TakeItAsLong	move.w	d0,(a3)+
		bra	NoSizeDoings
ShortBranchTry	cmp.w	#-$7f,d0
		bcc	TakeOkSoL
		cmp.w	#$80,d0
		bcc.s	TakeItAsLong
TakeOkSoL	and.w	#$ff,d0
		or.w	d0,d7
		bra	NoSizeDoings

PossibleSCond	moveq	#2,d0
		bsr	AnalyseBranch2
		bmi	ThisIsNoBr
		and.w	#$f00,d0
	 	or.w	#$50c0,d0
		move.w	d0,d7
		tst.w	AdrModeDest(a4)
		bpl	ThisIsNoBr
		move.w	#%0000101111111000,d0
		move.w	ModeBitSource(a4),d3
		btst	d3,d0
		beq	ThisIsNoBr
		move.w	AdrModeSource(a4),d1
		or.w	d1,d7
		move.l	AssembleAdr(a4),a3
		move.w	d7,(a3)+
		move.b	CModSource(a2),d0
		move.l	AdrDataSource(a4),d2
		bsr	GenerateOR
		bra	NoSizeDoings

PossibleDBranch	cmp.b	#"b",1(a0)
		bne	ThisIsNoBr
		addq.l	#1,a0
		moveq	#2,d0
		bsr	AnalyseBranch2	
		bmi	ThisIsNoBr
		and.w	#$f00,d0
		subq.l	#1,a0
		or.w	#$50c8,d0
		move.w	d0,d7
		move.w	AdrModeSource(a4),d0
		cmp.w	#%001000,d0
		bcc	ThisIsNoBr
		or.w	d0,d7
		cmp.w	#%11,CommandSize(a4)
		beq	ThisIsNoBr
		move.w	AdrModeDest(a4),d1
		move.l	AdrDataDest(a4),d0
		bra	OtherIBR	

CalcAdrMBit	tst.w	d0
		bmi.s	NoModeHere
		cmp.w	#%111000,d0
		bcc.s	Part2Do
		lsr.w	#3,d0
		bra.s	TurnWord
Part2Do		and.w	#$7,d0
		addq	#7,d0
TurnWord	move.w	#11,d1
		sub.w	d0,d1
		rts
NoModeHere	move.w	d0,d1
		rts
		
DissExpression	moveq.l	#0,d6
		moveq.l	#0,d7
		cmp.b	#"#",d0
		beq.s	Dimmediate
		cmp.b	#"(",d0
		beq	Drelative
		cmp.b	#"d",d0
		beq	DdataRegPoss
		cmp.b	#"u",d0
		beq	USPposs
		cmp.b	#"c",d0
		beq	CCRposs
		cmp.b	#"s",d0
		beq	SRposs
NoSRUSPCCR	cmp.b	#"a",d0
		beq	DadressRegPoss
		cmp.b	#"-",d0
		beq	PreDekReg
		cmp.b	#"$",d0
		beq.s	Dnumber
		cmp.b	#"0",d0
		bcs.s	NoExpression
		cmp.b	#"g",d0
		bcc.s	NoExpression
		cmp.b	#"9"+1,d0
		bcs.s	Dnumber2
		cmp.b	#"a",d0
		bcc.s	Dnumber2
NoExpression	moveq	#-1,d0
		rts

Dimmediate	addq	#1,d5	;Doppelkreuz
		cmp.b	#"$",(a1,d5)
		bne.s	TakeNumberSo
		addq	#1,d5
TakeNumberSo	cmp.b	#"-",(a1,d5)
		bne.s	SuchNormal
		addq	#1,d5
		cmp.b	#"$",(a1,d5)
		bne.s	TakeN2
		addq	#1,d5
TakeN2		bsr	GetHexNum
		sub.l	d0,d6
		bra.s	GoLike
SuchNormal	bsr	GetHexNum
		move.l	d0,d6		;Data
GoLike		move.w	#ImmAdr,d7	;Adressmode
		rts			;111100 Immediate

NegativeNumber	cmp.b	#"$",(a1,d5)
		bne.s	KeepItWO
		addq	#1,d5
KeepItWO	bsr	GetHexNum
		sub.l	d0,d6
		bra.s	GoLike2
Dnumber		addq	#1,d5
Dnumber2	bsr	GetHexNum
		move.l	d0,d6		;Data
GoLike2		bsr	SearchNextChar
		cmp.b	#"(",d0
		beq	Drelative
		cmp.l	#$10000,d6
		bcs.s	DabsShort	
		move.w	#%111001,d7	
		rts			;111001	Absolut lang

DabsShort	move.w	#%111000,d7	
		rts			;111000 Absolut kurz

DdataRegPoss	bsr	TestNextOnRegEnd
		bmi.s	Dnumber2t
		move.w	#DirDataAdr,d7
		or.w	d0,d7
		rts			;000xxx Datenregister direkt

Dnumber2t	cmp.b	#"/",d0
		beq	MovemOnlyPoss
		cmp.b	#"-",d0
		bne	Dnumber2
		bra	MovemOnlyPoss

DadressRegPoss	bsr	TestNextOnRegEnd
		bmi.s	Dnumber2t
		move.w	#DirAdrsAdr,d7
		or.w	d0,d7
		rts			;001xxx Adressregister direkt

CCRposs		cmp.b	#"c",1(a1,d5)
		bne	NoSRUSPCCR
		cmp.b	#"r",2(a1,d5)
		bne	NoSRUSPCCR
		addq	#3,d5
		move.w	#$8001,d7		;CCR
		moveq.l	#0,d0
		rts

SRposs		cmp.b	#"r",1(a1,d5)
		bne	NoSRUSPCCR
		addq	#2,d5
		move.w	#$8002,d7		;SR
		moveq.l	#0,d0
		rts

USPposs		cmp.b	#"s",1(a1,d5)
		bne	NoSRUSPCCR
		cmp.b	#"p",2(a1,d5)
		bne	NoSRUSPCCR
		addq	#3,d5
		move.w	#$8003,d7		;USP
		moveq.l	#0,d0
		rts

Drelative	bsr	ShowNextChar
		cmp.b	#"a",d0
		beq.s	DadressRel
		cmp.b	#"p",d0
		bne	NoExpression
		bsr	ShowNextChar
		cmp.b	#"c",d0
		bne	NoExpression
		bsr	ShowNextChar
		cmp.b	#")",d0
		beq	DpcRel
		cmp.b	#",",d0
		bne	NoExpression
		move.w	#%111011,d7
		bra	PCinjump

DpcRel		move.l	AssembleAdr(a4),d0
		addq	#2,d0
		sub.l	d0,d6
		and.l	#$ffff,d6
		addq	#1,d5
		move.w	#%111010,d7
		rts			;111010 PC Relative

DadressRel	bsr	TestNextOnRegEnd
		bmi	NoExpression
		move.w	d0,d7
		bsr	ShowThisChar
		cmp.b	#")",d0
		beq.s	IndOrIndPlus
		cmp.b	#",",d0
		bne	NoExpression
		or.w	#%110000,d7
PCinjump	and.w	#$ff,d6
		bsr	ShowNextChar
		cmp.b	#"d",d0
		beq.s	DataFollows
		cmp.b	#"a",d0
		bne	NoExpression
		or.w	#$8000,d6
DataFollows	bsr	TestNextOnRegEnd
		bmi	NoExpression
		lsl.w	#8,d0
		lsl.w	#4,d0
		or.w	d0,d6
		bsr	ShowThisChar
		cmp.b	#")",d0
		bne.s	PunktFollows
		addq	#1,d5
		rts			
PunktFollows	cmp.b	#".",d0
		bne	NoExpression
		bsr	ShowNextChar
		cmp.b	#"w",d0
		beq.s	WordequStay
		cmp.b	#"l",d0
		bne	NoExpression
		or.w	#$0800,d6
WordequStay	bsr	ShowNextChar
		cmp.b	#")",d0
		bne	NoExpression
		addq	#1,d5
		rts			;110xxx Adr ind mit index + reg

IndOrIndPlus	bsr	ShowNextChar
		cmp.b	#"+",d0
		beq.s	IndPlus
		tst.w	d6
		beq.s	AdrMode3
		or.w	#%101000,d7	;101xxx Adressreg ind +d16
		rts
AdrMode3	or.w	#%010000,d7
		rts			;010xxx Adressregister indirekt

IndPlus		addq	#1,d5
		or.w	#%011000,d7
		rts			;011xxx AdrReg ind postinc

PreDekReg	bsr	ShowNextChar
		cmp.b	#"(",d0
		bne	NegativeNumber
		bsr	ShowNextChar
		cmp.b	#"a",d0
		bne	NoExpression
		bsr	TestNextOnRegEnd
		bmi	NoExpression
		move.w	d0,d7
		bsr	ShowThisChar
		cmp.b	#")",d0
		bne	NoExpression
		addq	#1,d5
		or.w	#%100000,d7
		rts			;100xxx Adressreg ind predec

ShowNextChar	addq	#1,d5
ShowThisChar	move.b	(a1,d5),d0
		rts

TestNextOnRegEnd
		bsr	ShowNextChar
		cmp.b	#"0",d0
		bcs.s	Miinuus
		cmp.b	#"8",d0
		bcc.s	Miinuus
		and.w	#$07,d0
		move.w	d0,d1
		bsr	ShowNextChar
		cmp.b	#",",d0
		beq.s	OKregTest
		cmp.b	#" ",d0
		beq.s	OKregTest
		cmp.b	#")",d0
		beq.s	OKregTest
		cmp.b	#".",d0
		beq.s	OKregTest 
Miinuus		subq	#1,d5
		moveq	#-1,d1
		rts
OKregTest	move.w	d1,d0
		rts

MovemOnlyPoss	subq	#2,d5
		moveq.l	#0,d1	;Dort Bits Setzen
HauptSchl	bsr	ShowNextChar
		cmp.b	#"a",d0
		bne.s	DataPart
		bsr	GetNumberMV
		bmi	NoExpression
		addq	#8,d0
		move.w	d0,d2
DownEnde2	bsr	ShowNextChar
		cmp.b	#"-",d0
		beq.s	BisRoutine2
		cmp.b	#"/",d0
		beq.s	SetNTryAgain
		cmp.b	#",",d0
		beq.s	SetAndEnd
		cmp.b	#" ",d0
		bne	NoExpression
		bra.s	SetAndEnd

BisRoutine2	bsr	ShowNextChar
		cmp.b	#"a",d0
		bne	NoExpression
		bsr	GetNumberMV
		bmi	NoExpression
		addq	#8,d0
		cmp.b	d0,d2
		beq.s	DownEnde2
		bcc.s	CountUPD2
MakeSchleife2	bset	d2,d1
		addq	#1,d2
		cmp.b	d0,d2
		beq.s	DownEnde2
		bra.s	MakeSchleife2
CountUPD2	bset	d2,d1
		subq	#1,d2
		cmp.b	d0,d2
		beq.s	DownEnde2
		bra.s	CountUPD2

DataPart	cmp.b	#"d",d0
		bne	NoExpression
		bsr	GetNumberMV
		bmi	NoExpression
		move.w	d0,d2
DownEnde	bsr	ShowNextChar
		cmp.b	#"-",d0
		beq.s	BisRoutine
		cmp.b	#"/",d0
		beq.s	SetNTryAgain
		cmp.b	#",",d0
		beq.s	SetAndEnd
		cmp.b	#" ",d0
		bne	NoExpression
SetAndEnd	bset	d2,d1
		move.w	d1,d6
		move.w	#$8004,d7
		moveq.l	#0,d0
		rts
SetNTryAgain	bset	d2,d1
		bra	HauptSchl
BisRoutine	bsr	ShowNextChar
		cmp.b	#"d",d0
		bne	NoExpression
		bsr	GetNumberMV
		bmi	NoExpression
		cmp.b	d0,d2
		beq.s	DownEnde
		bcc.s	CountUPD
MakeSchleife	bset	d2,d1
		addq	#1,d2
		cmp.b	d0,d2
		beq.s	DownEnde
		bra.s	MakeSchleife
CountUPD	bset	d2,d1
		subq	#1,d2
		cmp.b	d0,d2
		beq.s	DownEnde
		bra.s	CountUPD

GetNumberMV	bsr	ShowNextChar
		cmp.b	#"0",d0
		bcs.s	Miinuus2
		cmp.b	#"8",d0
		bcc.s	Miinuus2
		and.w	#$07,d0
		rts
Miinuus2	moveq	#-1,d0
		rts

;Versuch einer Tabelle mit deren Hilfe Assemble/Disassemble einfacher
;zu lösen ist :
;Aufbau
;0-3  : Pointer auf Name
;4-5  : Feste Bits
;6-7  : Maske zum erkennen der Bits
;8-9  : untere 12 bits : Adressmodes Source
;10-11: untere 12 bits : Adressmodes Dest 
;12   : Nibble 1: Mode , Nibble 2: Shift Source
;13   : Nibble 1: Mode , Nibble 2: Shift Dest
;14   : Nibble 1: LenMode , Nibble 2: Shift Len : $00 = No Len
;15   : Extension für negative Adrmodes : $00 = Keine
;					  $01 = CCR
;					  $02 = SR
;					  $03 = USP
;					  $04 = MOVEM

;Modes : 0 = No Source/Destination
;	 1 = Normale Adressierung mit effektivem Adressfeld 6 Bits
;	 2 = Datenregisterfeld mit 3 Bits
;	 3 = Adressregisterfeld mit 3 Bits
;	 4 = Immediate im naechsten Wort
;	 5 = trapspecial
;	 6 = CCR/SR
;	 7 = Special turn round for move
;	 8 = Special for addq/subq
;	 9 = -(a0)
;	 a = (a0)+
;	 b = Moveqspecial
;	 c = MovepSpecial

;LenModes	0 = Normal b,w,l
;		1 = 	   b,w,l +1
;		2 = Normal w,l
;		3 = Shortsize

CName		equ	0
CWord		equ	4
CAnd		equ	6
CAdrSource	equ	8
CAdrDest	equ	10
CModSource	equ	12
CModDest	equ	13
CModLen		equ	14
CSpecial	equ	15
CLen		equ	16

	;******* Assembler Command Data ********

		;All	%0100---- Commands
CommandList	dc.l	Lea					;4
		dc.w	%0100000111000000,%1111000111000000	;8
		dc.w	%001001111110				;10
		dc.w	%010000000000				;12
		dc.b	$10,$39,$00				;15
		dc.b	$00					;16

		dc.l	Chk
		dc.w	%0100000110000000,%1111000111000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$00
		dc.b	$00

		dc.l	Clr
		dc.w	%0100001000000000,%1111111100000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$06
		dc.b	$00

		dc.l	Nop
		dc.w	%0100111001110001,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	$00

		dc.l	move	;to SR
		dc.w	%0100011011000000,%1111111111000000
		dc.w	%101111111111
		dc.w	%1000000000000000
		dc.b	$10,$60,$00
		dc.b	2

		dc.l	Not
		dc.w	%0100011000000000,%1111111100000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$06
		dc.b	$00

		dc.l	Swap
		dc.w	%0100100001000000,%1111111111111000
		dc.w	%100000000000
		dc.w	0
		dc.b	$20,$00,$00
		dc.b	0
	
		dc.l	Pea 
		dc.w	%0100100001000000,%1111111111000000
	 	dc.w	%001001111110
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	$00

		dc.l	Ext
		dc.w	%0100100010000000,%1111111110111000
		dc.w	%100000000000
		dc.w	0
		dc.b	$20,$00,$26
		dc.b	$00

		dc.l	illegal
		dc.w	%0100101011111100,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	$00

		dc.l	Jmp
		dc.w	%0100111011000000,%1111111111000000
		dc.w	%001001111110
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Jsr
		dc.w	%0100111010000000,%1111111111000000
		dc.w	%001001111110
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Link
		dc.w	%0100111001010000,%1111111111111000
		dc.w	%010000000000
		dc.w	%000000000001
		dc.b	$30,$40,$00
		dc.b	0

		dc.l	move	;to CCR
		dc.w	%0100010011000000,%1111111111000000
		dc.w	%101111111111
		dc.w	%1000000000000000
		dc.b	$10,$60,$00
		dc.b	1

		dc.l	move	;from SR
		dc.w	%0100000011000000,%1111111111000000
		dc.w	%1000000000000000
		dc.w	%101111111000
		dc.b	$60,$10,$00
		dc.b	2

		dc.l	move	;USP
		dc.w	%0100111001100000,%1111111111111000
		dc.w	%010000000000
		dc.w	%1000000000000000
		dc.b	$30,$60,$00
		dc.b	3

		dc.l	move	;USP
		dc.w	%0100111001101000,%1111111111111000
		dc.w	%1000000000000000
		dc.w	%010000000000
		dc.b	$60,$30,$00
		dc.b	3

		dc.l	Movem
		dc.w	%0100100010000000,%1111111110000000
		dc.w	%1000000000000000	
		dc.w	%001011111000
		dc.b	$60,$10,$26
		dc.b	4

		dc.l	Movem
		dc.w	%0100110010000000,%1111111110000000
		dc.w	%001101111000
		dc.w	%1000000000000000	
		dc.b	$10,$60,$26
		dc.b	4
		
		dc.l	Nbcd
		dc.w	%0100100000000000,%1111111111000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Neg
		dc.w	%0100010000000000,%1111111100000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$06
		dc.b	0

		dc.l	NegX
		dc.w	%0100000000000000,%1111111100000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$06
		dc.b	0

		dc.l	Reset
		dc.w	%0100111001110000,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	0

		dc.l	Rte
		dc.w	%0100111001110011,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	0

		dc.l	Rtr
		dc.w	%0100111001110111,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	0

		dc.l	Rts
		dc.w	%0100111001110101,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	0

		dc.l	Stop
		dc.w	%0100111001110010,%1111111111111111
		dc.w	%000000000001
		dc.w	0
		dc.b	$40,$00,$00
		dc.b	0

		dc.l	Tas
		dc.w	%0100101011000000,%1111111111000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Trap
		dc.w	%0100111001000000,%1111111111110000
		dc.w	%000000000001
		dc.w	0
		dc.b	$50,$00,$00
		dc.b	$00

		dc.l	Trapv
		dc.w	%0100111001110110,%1111111111111111
		dc.w	0
		dc.w	0
		dc.b	$00,$00,$00
		dc.b	$00

		dc.l	Tst
		dc.w	%0100101000000000,%1111111100000000
		dc.w	%101111111000
		dc.w	0
		dc.b	$10,$00,$06
		dc.b	$00

		dc.l	UnLink
		dc.w	%0100111001011000,%1111111111111000
		dc.w	%010000000000
		dc.w	0
		dc.b	$30,$00,$00
		dc.b	0

		dc.l	0


		;All 	%1110---- Commands
CommandList2	dc.l	Asl
		dc.w	%1110000111000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Asr
		dc.w	%1110000011000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Lsl
		dc.w	%1110001111000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Lsr
		dc.w	%1110001011000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Rol
		dc.w	%1110011111000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Ror
		dc.w	%1110011011000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Roxl
		dc.w	%1110010111000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Roxr
		dc.w	%1110010011000000,%1111111111000000
		dc.w	%001111111000
		dc.w	0
		dc.b	$10,$00,$00
		dc.b	0

		dc.l	Asl
		dc.w	%1110000100000000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0

		dc.l	Asr
		dc.w	%1110000000000000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0
		
		dc.l	Asl
		dc.w	%1110000100100000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	Asr
		dc.w	%1110000000100000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	Lsl
		dc.w	%1110000100001000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0

		dc.l	Lsr
		dc.w	%1110000000001000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0
		
		dc.l	Lsl
		dc.w	%1110000100101000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	Lsr
		dc.w	%1110000000101000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0
		
		dc.l	Rol
		dc.w	%1110000100011000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0

		dc.l	Ror
		dc.w	%1110000000011000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0
		
		dc.l	Rol
		dc.w	%1110000100111000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	Ror
		dc.w	%1110000000111000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	Roxl
		dc.w	%1110000100010000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0

		dc.l	Roxr
		dc.w	%1110000000010000,%1111000100111000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$89,$20,$06
		dc.b	0
		
		dc.l	Roxl
		dc.w	%1110000100110000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	Roxr
		dc.w	%1110000000110000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$06
		dc.b	0

		dc.l	0		

		;All	%1101---- Commands
CommandList3	dc.l	Add	;adda
		dc.w	%1101000011000000,%1111000011000000
		dc.w	%111111111111
		dc.w	%010000000000
		dc.b	$10,$39,$28
		dc.b	$00
		dc.l	Addx	; -(ax),-(ay)
		dc.w	%1101000100001000,%1111000100111000
		dc.w	%000010000000
		dc.w	%000010000000
		dc.b	$90,$99,$06
		dc.b	$00

		dc.l	Addx	; dx,dy	
		dc.w	%1101000100000000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$20,$29,$06
		dc.b	$00

		dc.l	Add
		dc.w	%1101000000000000,%1111000100000000
		dc.w	%111111111111
		dc.w	%100000000000
		dc.b	$10,$29,$06
		dc.b	$00

		dc.l	Add
		dc.w	%1101000100000000,%1111000100000000
		dc.w	%100000000000
		dc.w	%001111111000
		dc.b	$29,$10,$06
		dc.b	$00
			
		dc.l	0

		;Move 	Command
CommandList4	dc.l	move
		dc.w	%0000000000000000,%1100000000000000
		dc.w	%111111111111
		dc.w	%111111111000
		dc.b	$10,$76,$1c
		dc.b	$00

		dc.l	0

		;All	%0000---- Commands
CommandList5	dc.l	Eor	;ccr
		dc.w	%0000101000111100,%1111111111111111
		dc.w	%000000000001
		dc.w	%1000000000000000
		dc.b	$40,$60,$00
		dc.b	1

		dc.l	Eor	;sr
		dc.w	%0000101001111100,%1111111111111111
		dc.w	%000000000001
		dc.w	%1000000000000000
		dc.b	$40,$60,$00
		dc.b	2

		dc.l	And	;to CCR
		dc.w	%0000001000111100,%1111111111111111
		dc.w	%000000000001
		dc.w	%1000000000000000
		dc.b	$40,$60,$00
		dc.b	1

		dc.l	And	;to SR
		dc.w	%0000001001111100,%1111111111111111
		dc.w	%000000000001
		dc.w	%1000000000000000
		dc.b	$40,$60,$00
		dc.b	2

		dc.l	Or	;to CCR
		dc.w	%0000000000111100,%1111111111111111
		dc.w	%000000000001
		dc.w	%1000000000000000
		dc.b	$40,$60,$00
		dc.b	1

		dc.l	Or	;to SR
		dc.w	%0000000001111100,%1111111111111111
		dc.w	%000000000001
		dc.w	%1000000000000000
		dc.b	$40,$60,$00
		dc.b	2

		dc.l	Add
		dc.w	%0000011000000000,%1111111100000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$06
		dc.b	$00

		dc.l	And	;andi
		dc.w	%0000001000000000,%1111111100000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$06
		dc.b	0

		dc.l	movep
		dc.w	%0000000100001000,%1111000110111000
		dc.w	%000001000000
		dc.w	%100000000000
		dc.b	$c0,$29,$26
		dc.b	0

		dc.l	movep
		dc.w	%0000000110001000,%1111000110111000
		dc.w	%100000000000
		dc.w	%000001000000
		dc.b	$29,$c0,$26
		dc.b	0

		dc.l	Bchg
		dc.w	%0000000101000000,%1111000111000000
		dc.w	%100000000000
		dc.w	%101111111000
		dc.b	$29,$10,$00
		dc.b	0

		dc.l	Bchg
		dc.w	%0000100001000000,%1111111111000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$00
		dc.b	0

		dc.l	Bclr
		dc.w	%0000000110000000,%1111000111000000
		dc.w	%100000000000
		dc.w	%101111111000
		dc.b	$29,$10,$00
		dc.b	0

		dc.l	Bclr
		dc.w	%0000100010000000,%1111111111000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$00
		dc.b	0

		dc.l	Bset
		dc.w	%0000000111000000,%1111000111000000
		dc.w	%100000000000
		dc.w	%101111111000
		dc.b	$29,$10,$00
		dc.b	0

		dc.l	Bset
		dc.w	%0000100011000000,%1111111111000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$00
		dc.b	0

		dc.l	Btst
		dc.w	%0000000100000000,%1111000111000000
		dc.w	%100000000000
		dc.w	%101111111000
		dc.b	$29,$10,$00
		dc.b	0

		dc.l	Btst
		dc.w	%0000100000000000,%1111111111000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$00
		dc.b	0

		dc.l	Cmp
		dc.w	%0000110000000000,%1111111100000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$06
		dc.b	0
		
		dc.l	Eor
		dc.w	%0000101000000000,%1111111100000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$06
		dc.b	0
		
		dc.l	Or
		dc.w	%0000000000000000,%1111111100000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$06
		dc.b	0

		dc.l	Sub
		dc.w	%0000010000000000,%1111111100000000
		dc.w	%000000000001
		dc.w	%101111111000
		dc.b	$40,$10,$06
		dc.b	0


		dc.l	0

		;All	%0101---- Commands
CommandList6	dc.l	addq
		dc.w	%0101000000000000,%1111000100000000
		dc.w	%000000000001
		dc.w	%111111111000
		dc.b	$89,$10,$06
		dc.b	$00

		dc.l	subq
		dc.w	%0101000100000000,%1111000100000000
		dc.w	%000000000001
		dc.w	%111111111000
		dc.b	$89,$10,$06
		dc.b	0
		
		dc.l	0		

		;All	%1100---- Commands
CommandList7	dc.l	Abcd
		dc.w	%1100000100000000,%1111000111111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$20,$29,$00
		dc.b	0

		dc.l	Abcd
		dc.w	%1100000100001000,%1111000111111000
		dc.w	%000010000000
		dc.w	%000010000000
		dc.b	$90,$99,$00
		dc.b	0

		dc.l	Exg
		dc.w	%1100000101000000,%1111000111111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$29,$20,$00
		dc.b	0

		dc.l	Exg
		dc.w	%1100000101001000,%1111000111111000
		dc.w	%010000000000
		dc.w	%010000000000
		dc.b	$39,$30,$00
		dc.b	0

		dc.l	Exg
		dc.w	%1100000110001000,%1111000111111000
		dc.w	%100000000000
		dc.w	%010000000000
		dc.b	$29,$30,$00
		dc.b	0

		dc.l	Muls
		dc.w	%1100000111000000,%1111000111000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$00
		dc.b	0

		dc.l	Mulu
		dc.w	%1100000011000000,%1111000111000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$00
		dc.b	0

		dc.l	And
		dc.w	%1100000000000000,%1111000100000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$06
		dc.b	$00

		dc.l	And
		dc.w	%1100000100000000,%1111000100000000
		dc.w	%100000000000
		dc.w	%001111111000
		dc.b	$29,$10,$06
		dc.b	$00


		dc.l	0

		;All	%1011---- Commands
CommandList8	dc.l	Cmp
		dc.w	%1011000011000000,%1111000011000000
		dc.w	%111111111111
		dc.w	%010000000000
		dc.b	$10,$39,$28
		dc.b	0

		dc.l	Cmp
		dc.w	%1011000000000000,%1111000100000000
		dc.w	%111111111111
		dc.w	%100000000000
		dc.b	$10,$29,$06
		dc.b	0

		dc.l	Cmp
		dc.w	%1011000100001000,%1111000100111000
		dc.w	%000100000000
		dc.w	%000100000000
		dc.b	$a0,$a9,$06
		dc.b	0

		dc.l	Eor
		dc.w	%1011000100000000,%1111000100000000
		dc.w	%100000000000
		dc.w	%101111111000
		dc.b	$29,$10,$06
		dc.b	0

		dc.l	0

		;All	%1000---- Commands
CommandList9	dc.l	Divs
		dc.w	%1000000111000000,%1111000111000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$00
		dc.b	0

		dc.l	Divu
		dc.w	%1000000011000000,%1111000111000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$00
		dc.b	0

		dc.l	Sbcd
		dc.w	%1000000100000000,%1111000111111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$20,$29,$00
		dc.b	0

		dc.l	Sbcd
		dc.w	%1000000100001000,%1111000111111000
		dc.w	%000010000000
		dc.w	%000010000000
		dc.b	$90,$99,$00
		dc.b	0


		dc.l	Or
		dc.w	%1000000000000000,%1111000100000000
		dc.w	%101111111111
		dc.w	%100000000000
		dc.b	$10,$29,$06
		dc.b	0

		dc.l	Or
		dc.w	%1000000100000000,%1111000100000000
		dc.w	%100000000000
		dc.w	%001111111000
		dc.b	$29,$10,$06
		dc.b	0
		

		dc.l	0

		;All	%0111---- Commands
CommandList10	dc.l	Moveq
		dc.w	%0111000000000000,%1111000100000000
		dc.w	%000000000001
		dc.w	%100000000000
		dc.b	$b0,$29,$00
		dc.b	0
	
		dc.l	0

		;All	%1001---- Commands
CommandList11	dc.l	Sub	;Suba
		dc.w	%1001000011000000,%1111000011000000
		dc.w	%111111111111
		dc.w	%010000000000
		dc.b	$10,$39,$28
		dc.b	0


		dc.l	Subx
		dc.w	%1001000100000000,%1111000100111000
		dc.w	%100000000000
		dc.w	%100000000000
		dc.b	$20,$29,$06
		dc.b	0

		dc.l	Subx
		dc.w	%1001000100001000,%1111000100111000
		dc.w	%000010000000
		dc.w	%000010000000
		dc.b	$90,$99,$06
		dc.b	0

		dc.l	Sub
		dc.w	%1001000000000000,%1111000100000000
		dc.w	%111111111000
		dc.w	%100000000000
		dc.b	$10,$29,$06
		dc.b	0

		dc.l	Sub
		dc.w	%1001000100000000,%1111000100000000
		dc.w	%100000000000
		dc.w	%001111111000
		dc.b	$29,$10,$06
		dc.b	0

		dc.l	0

		dc.l	0

;****** Assembler Mnemonics ******

Mnemonics	
Abcd		dc.b	"abcd",0
Add		dc.b	"add",0
addq		dc.b	"addq",0
Addx		dc.b	"addx",0
And		dc.b	"and",0
Asl		dc.b	"asl",0
Asr		dc.b	"asr",0
Chk		dc.b	"chk",0
Clr		dc.b	"clr",0
Cmp		dc.b	"cmp",0
Divs		dc.b	"divs",0
Divu		dc.b	"divu",0
Eor		dc.b	"eor",0
Exg		dc.b	"exg",0
Ext		dc.b	"ext",0
illegal		dc.b	"illegal",0
Jmp		dc.b	"jmp",0
Jsr		dc.b	"jsr",0
Lea		dc.b	"lea",0
Link		dc.b	"link",0
Lsl		dc.b	"lsl",0
Lsr		dc.b	"lsr",0
move		dc.b	"move",0
Movem		dc.b	"movem",0
movep		dc.b	"movep",0
Moveq		dc.b	"moveq",0
Muls		dc.b	"muls",0
Mulu		dc.b	"mulu",0
Nbcd		dc.b	"nbcd",0
Neg		dc.b	"neg",0
NegX		dc.b	"negx",0
Nop		dc.b	"nop",0
Not		dc.b	"not",0
Or		dc.b	"or",0
Pea		dc.b	"pea",0
Reset		dc.b	"reset",0
Rol		dc.b	"rol",0
Ror		dc.b	"ror",0
Roxl		dc.b	"roxl",0
Roxr		dc.b	"roxr",0
Rte		dc.b	"rte",0
Rtr		dc.b	"rtr",0
Rts		dc.b	"rts",0
Sbcd		dc.b	"sbcd",0
Stop		dc.b	"stop",0
Sub		dc.b	"sub",0
subq		dc.b	"subq",0
Subx		dc.b	"subx",0
Swap		dc.b	"swap",0
Tas		dc.b	"tas",0
Trap		dc.b	"trap",0
Trapv		dc.b	"trapv",0
Tst		dc.b	"tst",0
UnLink		dc.b	"unlk",0
LineA		dc.b	"linea",0
LineF		dc.b	"linef",0
DCW		dc.b	"dc.w",0
UnknownCommand	dc.b	"?????",0
		dc.b	0,0
Branches	dc.b	"rasr"	;0000
		dc.b	"hils"	;0010
		dc.b	"cccs"	;0100
		dc.b	"neeq"	;0110
		dc.b	"vcvs"	;1000
		dc.b	"plmi"	;1010
		dc.b	"gelt"	;1100
		dc.b	"gtle"	;1110
		dc.b	"t",0,"f",0	;extras for db and s
DBranchText	dc.b	"dbxx",0
BranchText	dc.b	"bxx.x",0
Stext		dc.b	" sxx",0
BitText		;
Btst		dc.b	"btst",0
Bchg		dc.b	"bchg",0
Bclr		dc.b	"bclr",0
Bset		dc.b	"bset",0
		even

;******* Amiga-Dos Definitionen ******

Xwindow		equ	640
Ywindow		equ	200

WindowDefs	dc.w	0,0,Xwindow,Ywindow
		dc.b	0,1
		dc.l	RAWKEY!MOUSEBUTTONS!MENUPICK!NEWSIZE!CLOSEWINDOW!REFRESHWINDOW
WindowFlags	dc.l	ACTIVATE!WINDOWDRAG!WINDOWSIZING!WINDOWCLOSE!WINDOWDEPTH!GIMMEZEROZERO
		dc.l	0,0,WindowName
WD_Screen	dc.l	0,0
		dc.w	640,64,2000,2000
SC_Type		dc.w	WBENCHSCREEN

WindowDefs2	dc.w	0,0,Xwindow,Ywindow
		dc.b	0,1
		dc.l	MOUSEBUTTONS!CLOSEWINDOW
		dc.l	ACTIVATE!WINDOWDRAG!WINDOWCLOSE!GIMMEZEROZERO!WINDOWDEPTH
		dc.l	0,0,WindowName2
WD_Screen2	dc.l	0,0
		dc.w	Xwindow,Ywindow,Xwindow,Ywindow
SC_Type2	dc.w	WBENCHSCREEN


ScreenName	dc.b	"Scypmon V1.8",0
WindowName	dc.b	"Scypmon V1.8 by Jörg Bublath 13-Jan-94 - Mode: "
ScreenNameMode	dc.b	"         ",0
WindowName2	dc.b	"Scypmon V1.8 - Help Window",0
		even

IntuitionName	INTNAME
GraphicsName	dc.b	"graphics.library",0
DosName		DOSNAME
ConName		dc.b    "console.device",0
DisLibText	dc.b	"dis.library",0
DiskFontName	dc.b	"diskfont.library",0
		even
FontDefs	dc.l	FontName
FontSize	dc.w	8
		dc.b	0
		dc.b	FPF_ROMFONT!FPF_DISKFONT!FPF_TALLDOT!FPF_WIDEDOT
FontName	dc.b	"topaz.font",0
		even

;******* eigene Definitionen *******

ProgramName	dc.b	"Scypmon 1.8",0
Mode1		dc.b	"Insert   ",0
Mode2		dc.b	"Overwrite",0
FILENFText	dc.b	$0a,"File not found",0
FileErrText	dc.b	$0a,"Error while disk-access #",0
LoadingText	dc.b	$0a,"Loading ",0
SavingText	dc.b	$0a,"Saving ",0
Break		dc.b	$0a,"Break",0
ExceptionTX	dc.b    $0a,"Exception #",0
DirTXT		dc.b	"dir",0
DirIs		dc.b	$0a,"directory:",0
AtTEXT		dc.b	" at ",0
RegText		dc.b	$0a,"       usp      ssp      pc    t-s--iii---xnzvc",$0a,".'p ",0
TrackTxt	dc.b	"T H S ",0
TraceStartText	dc.b	$0a,"TRACE: cr: execute, x: exit, r: register, n: next, j: execute jsr, g: go",0 
MemError	dc.b	$0a,"Memory Error",0
SegTxt		dc.b	"=PrgStart",0
SegTxt2		dc.b	$0a,"Sg Start    Len",0
EinschaltTxt	dc.b	$0a,"Scypmon Version 13-Jan-94, (c) by Jörg Bublath - This is Shareware !",$0a,0
Str_Unset	dc.b	"<unset>",0
TaskNameTxt	dc.b	$0a,"Task: '",0
ProcessName	dc.b	$0a,"Process: '",0
PriorityTxt	dc.b	"  Pri:",0
Sign1		dc.b	$0a,"Signals:",$0a,"Alloc=",0
Sign2		dc.b	$0a,"Wait =",0
Sign3		dc.b	$0a,"Set  =",0
Stack1		dc.b	$0a,"Stack:  Lower=",0
Stack2		dc.b	"  Reg=",0
Stack3		dc.b	"  Upper=",0
Str_Command	dc.b	$0a,"CLI:     Cmd  ='",0
Str_None	dc.b	6,"<none>"
TaskNotFound	dc.b	$0a,"Task not found!",0
AdressTxt	dc.b	"'  Adress:",0
FreeBText	dc.b	$0a,"Unused bytes: ",0
ExceededText	dc.b	$0a,"FreeMem exceeded - use ""!"" to override",0
ErrorsOccured	dc.b	$0a,"Errors occured:",$0
StartError1	dc.b	$0a,"Couldn't open your font: ",0
StartError2	dc.b	$0a,"Can't use proportional font: ",0
StartError3     dc.b	$0a,"Couldn't open batchfile: ",0
StartError4	dc.b	$0a,"Fontwidth too high!",0
OpenDevErr	dc.b	$0a,"Error opening device #",0
DeviceNotFound	dc.b	$0a,"Device not found!",0
DevInf1		dc.b	$0a,"Devicename: ",0
DevInf2		dc.b	"  Unit: ",0
DevInf3		dc.b	"  Blocksize: ",0
DevInf4		dc.b	$0a,"Surfaces: ",0
DevInf5		dc.b	"  Block per Track: ",0
DevInf6		dc.b	"  LowCyl: ",0
DevInf7		dc.b	"  HighCyl: ",0
VersionString	dc.b	"$VER: Scypmon 1.8 (13.1.94) by Jörg Bublath",0
ShortHelp	dc.b	$0a,"Usage: scypmon [-bdp] [-s <pubscreen>] [-f <fontname> <fontsize>]",$0a
		dc.b	    "       [-P <xpos> <ypos>] [-S <xsize> <ysize>] [batchfile]",$0a
		dc.b	"-b : Background (do not activate)",$0a
		dc.b	"-d : Use dis.library V2 for disassembling",$0a
		dc.b	"-p : Patch exception vectors to catch gurus",$0a
		dc.b	"-f : Use another font",$0a
		dc.b	"-s : Open on a specified pubscreen",$0a
		dc.b	"-P : New position for the window",$0a
		dc.b	"-S : New size for the window",$0a	
		dc.b	"batchfile : Name of textfile with scypmon-instructions",$0a,$0a
ShortHelpe
		even

OutDeviceTx	dc.b	"prt:",0
		even

RegisterSave	ds.l	8	;dataregs
RegisterSave2	ds.l	8	;adrregs
USPstack	dc.l	0
SSPstack	dc.l	0
SRregister	dc.l	0
PCregister	dc.l	0
StatusLine	dc.w	0

ZeroSpeicher	dc.l	0
ZeroPageMem	dc.l	0
VBRreg		dc.l	0
TraceSave	dc.l	0
CurrDir		dc.l	0

Vektors		dc.l	Guru2
		dc.l	Guru3
		dc.l	Guru4
		dc.l	Guru5
		dc.l	Guru6
		dc.l	Guru7
		dc.l	0
		dc.l	Guru9
		dc.l	Gurua
		dc.l	Gurub

StackBase	ds.b	64

;************ Jetzt wirds ernst..... : Menues:

FirstMenu	dc.l	SecMenu
		dc.w	10,0	;LeftEdge,TopEdge
		dc.w	110,10	;Width,Height
		dc.w	MENUENABLED	;Flags
		dc.l	MenuName	;Name
		dc.l	FirstItem
		ds.w	4		;4 reservierte Woerter

SecMenu		dc.l	0
		dc.w	400,0	;LeftEdge,TopEdge
		dc.w	100,10	;Width,Height
		dc.w	MENUENABLED	;Flags
		dc.l	HelpName	;Name
		dc.l	HelpItem
		ds.w	4		;4 reservierte Woerter


FirstItem	dc.l	MenuItem2
		dc.w	0,0
		dc.w	26,10
InterlaceFlag	dc.w	ITEMTEXT!HIGHCOMP!CHECKIT!MENUTOGGLE!COMMSEQ
		dc.l	0
		dc.l	IntuiText1,0
		dc.b	"I",0
		dc.l	0
		dc.w	0

MenuItem2	dc.l	MenuItem3
		dc.w	0,1
		dc.w	26,10
UseDisFlag	dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP!CHECKIT!MENUTOGGLE!COMMSEQ
		dc.l	0
		dc.l	IntuiText2,0
		dc.b	"D",0
		dc.l	0
		dc.w	0

MenuItem3	dc.l	MenuItem4
		dc.w	0,2
		dc.w	26,10
PatchitFlag	dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP!CHECKIT!MENUTOGGLE!COMMSEQ
		dc.l	0
		dc.l	IntuiText3,0
		dc.b	"P",0
		dc.l	0
		dc.w	0

MenuItem4	dc.l	MenuItem5
		dc.w	0,3
		dc.w	26,10
ConfigVal	dc.w	ITEMTEXT!HIGHCOMP!COMMSEQ
		dc.l	0
		dc.l	IntuiText4,0
		dc.b	"C",0
		dc.l	0
		dc.w	0

MenuItem5	dc.l	0
		dc.w	0,4
		dc.w	26,10
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP!COMMSEQ
		dc.l	0
		dc.l	IntuiText5,0
		dc.b	"Q",0
		dc.l	0
		dc.w	0

HelpItem	dc.l	0
		dc.w	0,0
		dc.w	18,0
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP!COMMSEQ
		dc.l	0
		dc.l	IntuiHelp,0
		dc.b	"H",0
		dc.l	0
		dc.w	0

IntuiText1	dc.b	0,1	;Front/back Pen
		dc.b	RP_JAM2,0
		dc.w	0,0	;Left/Topedge
		dc.l	0	;FontDefs
		dc.l	MenuText1
		dc.l	0

IntuiText2	dc.b	0,1	;Front/back Pen
		dc.b	RP_JAM2,0	;drawmode
		dc.w	0,0	;Left/Topedge
		dc.l	0	;FontDefs
		dc.l	MenuText2
		dc.l	0

IntuiText3	dc.b	0,1	;Front/back Pen
		dc.b	RP_JAM2,0	;drawmode
		dc.w	0,0	;Left/Topedge
		dc.l	0	;FontDefs
		dc.l	MenuText3
		dc.l	0

IntuiText4	dc.b	0,1	;Front/back Pen
		dc.b	RP_JAM2,0	;drawmode
		dc.w	0,0	;Left/Topedge
		dc.l	0	;FontDefs
		dc.l	MenuText4
		dc.l	0

IntuiText5	dc.b	0,1	;Front/back Pen
		dc.b	RP_JAM2,0	;drawmode
		dc.w	0,0	;Left/Topedge
		dc.l	0	;FontDefs
		dc.l	MenuText5
		dc.l	0

IntuiHelp	dc.b	0,1	;Front/back Pen
		dc.b	RP_JAM2,0	;drawmode
		dc.w	0,0	;Left/Topedge
		dc.l	0	;FontDefs
		dc.l	HelpText
		dc.l	0



MenuText1	dc.b	"   Pay Shareware",0
MenuText2	dc.b	"   Use dis.library",0
MenuText3	dc.b	"   Patch Exceptions",0
MenuText4	dc.b	"   Config dis.library",0
MenuText5	dc.b	"   Quit SCYPMON",0
MenuName	dc.b	"Options",0
HelpName	dc.b	"HELP!",0
HelpText	dc.b	"Help Window",0

HelpScreen	dc.b	"----------------------------------------------------------------------------"
		dc.b	"a=adress, l=length, s=segment(0-7), n=name, <>=required, []=optional, |=or  "
		dc.b	"DISK ACCESS-----------------------------------------------------------------"
		dc.b	"C <a>                :Block Checksum | b <a>                :BB Checksum    "
		dc.b	"<X <blockspec><a>[l] :Read Block(s)  | >X <blockspec><a>[l] :Write Block(s) "
		dc.b	"blockspecs:X=t :<track><head><sector>| D [n]                :Directory      "
		dc.b	"           X=b :<blocknumber>        | CD [n]               :Dir Change     "
		dc.b	"           X=o :<byteoffset>         | V [devicename]       :Choose Device  "
		dc.b	"INPUT/OUTPUT----------------------------------------------------------------"
		dc.b	"O [n]       :Output Dev/File | ld <n><s>   :Load Dos-File | p <comm>:Print  "
		dc.b	"l <n><a>[!] :Load File       | s <n><a><a> :Save File     | h       :History"
		dc.b	"MEMORY----------------------------------------------------------------------"
		dc.b	"F <s>       :FreeMem         | A <s><a><l>     :AllocAbs  | M <a> : Mem Free"
		dc.b	"S [s]       :Segment List    | A <s><l>[C|F|P] :AllocMem                    "
		dc.b	"MONITOR---------------------------------------------------------------------"
		dc.b	"a <a>    :Assemble     | c <a><a><a> :Compare   | d <a>[a]        :Dissass  "
		dc.b	"i <a>[a] :ASCII Dump   | m <a>[a]    :Hex Dump  | o <a><a><bytes> :Occupy   "
 		dc.b	"P <a>    :Textout      | r    :Show Registers   | t <a><a><a>     :Transfer "
		dc.b	"w <a><n> :Text to Mem  | x    :Exit Program     | ? <arith.expr>  :Calc     "
		dc.b	"TRACING---------------------------------------------------------------------"
		dc.b	"B <a>    :Breakpoint   | e <n|a> :Examine Task  | g <a> :goto | T [a] :Trace"
		dc.b	"FIND------------------------------------------------------------------------"
		dc.b	"fd <a><a><findexpr>[!] :Find and Dissassemble   | f <a><a><findexpr>[!]:Find"
		dc.b	"fr <a><a><a>           :Find Relative                                       "
		dc.b	"----------------------------------------------------------------------------"

;****** Zero-Page (Flags) ******
		rsreset
FileLockerR	rs.w	256
FindBufferR	rs.l	$20
MaskBufferR	rs.l	$20
OutDeviceR	rs.l	$20
VariableBuff	rs.l	26
CommandHist	rs.b	HistorySize

ZeroPage	rs.w	1
		rsreset

IntBase		rs.l	1
GraphicsBase	rs.l	1
DosBase		rs.l	1
DislibBase	rs.l	1
VarBuff		rs.l	1
HistoryMem	rs.l	1
HistoryEnd	rs.l	1
HistPointStart	rs.l	1
HistPointEnd	rs.l	1
HistPointAct	rs.l	1

AllocSegs	rs.l	16	;8 Alloc-Segmente Pointer,Length
AllocLength	equ	AllocSegs+4

FlushCursorX	rs.w	1
MainWindow	rs.l	1
TextScreen	rs.l	1
RechenSpeicher	rs.l	1
OutPutStart	rs.l	1
OutPutStop	rs.l	1
BaseStack	rs.l	1
AssembleAdr	rs.l	1
AdrDataSource	rs.l	1
AdrModeSource	rs.w	1
AdrDataDest	rs.l	1
AdrModeDest	rs.w	1
ModeBitSource	rs.w	1
ModeBitDest	rs.w	1
CommandSize	rs.w	1
Uncontrolled	=	CommandSize	;verwendung überschneidet nicht
MovemRemember	rs.w	1
OLDTRAP15	rs.l	1
ActIAdress	rs.l	1
DeviceUnit	rs.l	1	;default: 0
DeviceName	rs.l	1	;default: Zeiger auf trackdisk.device
DeviceFlags	rs.l	1	;default: 0
DEBlocksPerTrack rs.w	1	;default: 11
DEBytesPerTrack	rs.l	1	;default: 512*11
DESizeBlock	rs.w	1	;default: 512
DESurfaces	rs.w	1	;default: 2
RememberTrap	rs.w	1
RememberAdress	rs.l	1
FileLocker	rs.l	1
FindBuffer	rs.l	1
MaskBuffer	rs.l	1
BatchFile	rs.l	1
BatchHandle	rs.l	1
RoundStackPos	rs.l	1
OutDevice	rs.l	1
WBMessage	rs.l	1
ReturnCode	rs.l	1
OwnTask		rs.l	1
StackKind	rs.l	1
PrinterFlag	rs.w	1
OutDHandle	rs.l	1
TextSize	rs.l	1
NoCursorToMouseFlag	rs.w	1
ConDevice	rs.l	1
WDRastPort	rs.l	1
FontBase	rs.l	1
ActRaw		rs.w	1
ActQual		rs.w	1
InBuffLen	rs.w	1
InBuffPoint	rs.l	1
LongTween	rs.l	1
HelpWindow	rs.l	1
SignalMask	rs.l	1
DELowCyl	rs.l	1
DEHighCyl	rs.l	1
InsertMode	rs.w	1
PatchFlag	rs.w	1
SpecialFind	rs.w	1
maxX		rs.w	1
maxY		rs.w	1
TextWidth	rs.w	1
TextWidth2	rs.w	1
TextHeight	rs.w	1
DisStruct	rs.b	sizeof_DisLine
NewFontName	rs.b	40
NewFontSize	rs.w	1
PubName		rs.b	40
FontX		rs.w	1
FontY		rs.w	1
Y0Pos		rs.w	1
Y0Rest		rs.w	1
SetError	rs.w	1
FontOpen	rs.w	1
V36OK		rs.w	1
ScreenFont	rs.l	1
IORequest	rs.b	IOSTD_SIZE
InputEventStr	rs.b	ie_SIZEOF
DiskIO		rs.b	IOSTD_SIZE
Readreply	rs.b	MP_SIZE
RelativesLen	rs.w	1

GesLen		equ	ZeroPage+RelativesLen

;Keys without anything:
KeyConv dc.b	$41,$08	;Backspace
	dc.b	$42,$09	;Tab
	dc.b	$43,$0a ;Enter
	dc.b	$44,$0a ;Return
	dc.b	$46,$7f	;Del
	dc.b	$4c,$90	;Up
	dc.b	$4d,$91	;Down
	dc.b	$4e,$92	;Right
	dc.b	$4f,$93	;Left
	dc.b	$50,$94,$51,$95	;F1/F2
	dc.b	$52,$96	;f3!!!
	dc.b	$58,$97,$59,$98	;F9/F10-Keys
	dc.b	$5f,$0c	;Help

	;Shift:

	;Numeric Keypad
	dc.b	$d0,$9c ;Shift + F1
	dc.b	$8f,$01	;InsertMode
	dc.b	$9d,$99	;End
	dc.b	$9e,$91	;Down
	dc.b	$ad,$93	;Left
	dc.b	$af,$92	;Right
	dc.b	$bc,$7f	;Del
	dc.b	$bd,$9a	;Home
	dc.b	$be,$90	;Up

	dc.b	$c3,$0d	;Shift CR
	dc.b	$c4,$0d	;Shift CR
	dc.b	$c6,$9b	;Insert (Shift+Del)
	dc.b	$cc,$81	;Blättern Up
	dc.b	$cd,$82	;Blättern Down
	dc.b	$ce,$05	;END Of Line
	dc.b	$cf,$0d	;Start of Line
	dc.b	$df,$0b	;Clear Line Right	
	dc.w	0
