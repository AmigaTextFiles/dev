***********************************************
*                                             *
*              (C)opyright 1991               *
*                                             *
*             by  Tomi Blinnikka              *
*                                             *
*      Don't try to understand the code       *
*                                             *
***********************************************

;Here are the iff.library offsets

OpenIFF:	equ	-30	; (filename)			(A0)
CloseIFF:	equ	-36	; (ifffile)			(A1)
FindChunk:	equ	-42	; (ifffile,chunkname)		(A1,D0)
GetBMHD:	equ	-48	; (ifffile)			(A1)
GetColorTab:	equ	-54	; (ifffile,colortable)		(A1/A0)
DecodePic:	equ	-60	; (ifffile,bitmap)		(A1/A0)
SaveBitMap:	equ	-66	; (name,bmap,ctab,crmd)		(A0-A2,D0)
SaveClip:	equ	-72	; (name,bmap,ctab,crmd,x,y,w,h)	(A0-A2,D0-D4)
IffError:	equ	-78	; ()				()
GetViewModes:	equ	-84	; (ifffile)			(A1)

;*************** E R R O R - C O D E S ************************************

IFF_BADTASK:		equ	-1	; IffError() called by wrong task

IFF_CANTOPENFILE:	equ	16	; File not found
IFF_READERROR:		equ	17	; Error reading file
IFF_NOMEM:		equ	18	; Not enough memory for IFF file
IFF_NOTIFF:		equ	19	; File is not an IFF file
IFF_WRITEERROR:		equ	20	; Error writing file

IFF_NOILBM:		equ	24	; IFF file is not of type ILBM
IFF_NOBMHD:		equ	25	; BMHD chunk not found
IFF_NOBODY:		equ	26	; BODY chunk not found
IFF_TOOMANYPLANES:	equ	27	; Picture has more planes than BitMap
IFF_UNKNOWNCOMPRESSION:	equ	28	; Unknown compression type

;Here are the req.library offsets


Center = -$001e
SetSize = -$0024
SetLocation = -$002a
ReadLocation = -$0030
ReqFormat = -$0036
Dispatch = -$003c
FileRequester = -$0054
ColorRequester = -$005a
DrawBox = -$0060
MakeButton = -$0066
MakeScrollbar = -$006c
PurgeFiles = -$0072
GetFontHeightAndWidth = -$0078
MakeGadget = -$007e
MakeString = -$0084
MakeProp = -$008a
LinkGadget = -$0090
LinkStringGadget = -$0096
LinkPropGadget = -$009c
GetString = -$00a2
RealTimeScroll = -$00a8
TextRequest = -$00ae
GetLong = -$00b4
RawKeyToAscii = -$00ba
ExtendedColorRequester = -$00c0
NewGetString = -$00c6	

;Here lie the arp-offsets, thank God for them

ShowTitle = -$011a
Puts = -$00F0
ReadLine = -$00F6
GADS = -$00FC
Atol = -$0102
EscapeString = -$0108
CheckAbort = -$010E
CheckBreak = -$0114
Getenv = -$011A
Setenv = -$0120
FileRequest = -$0126
CloseWindowSafely = -$012C
CreatePort = -$0132
DeletePort = -$0138
SendPacket = -$013E
InitStdPacket = -$0144
PathName = -$014A
Assign = -$0150
DosAllocMem = -$0156
DosFreeMem = -$015C
BtoCStr = -$0162
CtoBStr = -$0168
GetDevInfo = -$016E
FreeTaskResList	= -$0174
ArpExit = -$017A
ArpAlloc = -$0180
ArpAllocMem = -$0186
ArpOpen = -$018C
ArpDupLock = -$0192
ArpLock = -$0198
RListAlloc = -$019E
FindCLI = -$01A4
QSort = -$01AA
PatternMatch = -$01B0
FindFirst = -$01B6
FindNext = -$01BC
FreeAnchorChain = -$01C2
CompareLock = -$01C8
FindTaskResList = -$01CE
CreateTaskResList = -$01D4
FreeResList = -$01DA
FreeTrackedItem = -$01E0
GetTracker = -$01E6
GetAccess = -$01EC
FreeAccess = -$01F2
FreeDAList = -$01F8
AddDANode = -$01FE
AddDADevs = -$0204
Strcmp = -$020A
Strncmp = -$0210
Toupper = -$0216
SyncRun = -$021C
ASyncRun = -$0222
SpawnShell = -$0222
LoadPrg = -$0228
PreParse = -$022E
StamptoStr = -$0234
StrtoStamp = -$023A
ObtainResidentPrg = -$0240
AddResidentPrg = -$0246
RemResidentPrg = -$024C
UnLoadPrg = -$0252
LMult = -$0258
LDiv = -$025E
LMod = -$0264
CheckSumPrg = -$026A
TackOn = -$0270
BaseName = -$0276
ReleaseResidentPrg = -$027C
SPrintf = -$0282
GetKeywordIndex = -$0288
ArpOpenLibrary = -$028E
ArpAllocFreq = -$0294

;Here lie the normal Amiga lib-offsets, rest in peace

Disable = -$0078
Enable = -$007e
InitGels = -$0078
InitMasks = -$007e
AddVSprite = -$0066
RemVSprite = -$008a
SortGList = -$0096
DrawGList = -$0072
DrawEllipse = -$00b4
AreaEllipse = -$00ba
AllocRaster = -$01ec
FreeRaster = -$01f2
InitTmpRas = -$01d4
InitArea = -$011a
LoadRGB4 = -$00c0
SetRGB4CM = -$0276
GetRGB4 = -$0245
CBump = -$016e
CMove = -$0174
CWait = -$017a
UCopperListInit = -$0252
FreeVPortCopLists = -$021c
OpenWorkBench = -$00d2
DisplayAlert = -$005a
FindResident = -$0060
FindName = -$0114
FindTask = -$0126
RawDoFmt = -$020a
Forbid = -$0084
Permit = -$008a
Debug = -$0072
Supervisor = -$001e
Exception = -$0042
Wait = -$013e
DoIO = -$01c8
SendIO = -$01ce
CheckIO = -$01d4
WaitIO = -$01da
AbortIO = -$01e0
AddDevice = -$01b0
RemDevice = -$01b6
OpenDevice = -$01bc
CloseDevice = -$01c2
OpenLibrary = -$0228
CloseLibrary = -$019e
Text = -$003c
SetRGB4 = -$0120
SetAPen = -$0156
SetBPen = -$015c
ScrollRaster = -$018c
Move = -$00f0
Draw = -$00f6
Flood = -$014a
RectFill = -$0132
OpenScreen = -$00c6
OpenWindow = -$00cc
CloseWindow = -$0048
CloseScreen = -$0042
InPut = -$0036
OutPut = -$003c
Delay = -$00c6
InitBitMap = -$0186
ClipBit = -$0228
AllocMem = -$00c6
FreeMem = -$00d2
CopyMem = -$0270
CopyMemQuick = -$0276
AllocSignal = -$014a
FreeSignal = -$0150
AddIntServer = -$00a8
RemIntServer = -$00ae
WaitTOF = -$010e
VBeamPos = -$0180
SetRast = -$00ea
AddGadget = -$002a
AddGList = -$01b6
RemoveGadget = -$00e4
SetFont = -$0042
OpenFont = -$0048
CloseFont = -$004e
ClearScreen = -$0030
ClearMenuStrip = -$0036
ClearPointer = -$003c
SetPrefs = -$0144
GetPrefs = -$0084
DisplayBeep = -$0060
DrawBorder = -$006c
ItemAddress = -$0090
ModifyIDCMP = -$0096
OffGadget = -$00ae
OffMenu = -$00b4
OnGadget = -$00ba
OnMenu = -$00c0
PrintIText = -$00d8
RefreshGadgets = -$00de
RefreshGList = -$01b0
RemakeDisplay = -$0180
RethinkDisplay = -$0186
SetMenuStrip = -$0108
SetPointer = -$010e
ActivateGadget = -$01ce
ActivateWindow = -$01c2
AddPort = -$0162
RemPort = -$0168
PutMsg = -$016e
GetMsg = -$0174
ReplyMsg = -$017a
WaitPort = -$0180
FindPort = -$0186
Open = -$001e
Close = -$0024
Read = -$002a
Write = -$0030
Input = -$0036
Output = -$003c
Seek = -$0042
DeleteFile = -$0048
Rename = -$004e
CreateDir = -$0078
CurrentDir = -$007e
ParentDir = -$00d2
OpenDiskFont = -$001e
AvailFonts = -$0024
	
;--------------------------------------------------
;IDCMP Classes

SIZEVERIFY 		EQU $00000001
NEWSIZE 		EQU $00000002
REFRESHWINDOW		EQU $00000004
MOUSEBUTTONS		EQU $00000008
MOUSEMOVE		EQU $00000010
GADGETDOWN		EQU $00000020
GADGETUP		EQU $00000040
REQSET			EQU $00000080
MENUPICK		EQU $00000100
CLOSEWINDOW		EQU $00000200
RAWKEY			EQU $00000400
REQVERIFY		EQU $00000800
REQCLEAR		EQU $00001000
MENUVERIFY		EQU $00002000
NEWPREFS		EQU $00004000
DISKINSERTED		EQU $00008000
DISKREMOVED		EQU $00010000
WBENCHMESSAGE		EQU $00020000
ACTIVEWINDOW		EQU $00040000
INACTIVEWINDOW		EQU $00080000
DELTAMOVE		EQU $00100000
VANILLAKEY		EQU $00200000
INTUITICKS		EQU $00400000

;--------------------------------------------------		
	
; Other Stuff

INTB_TBE		EQU 0
INTB_DSKBLK		EQU 1
INTB_SOFTINT		EQU 2
INTB_PORTS		EQU 3
INTB_COPER		EQU 4
INTB_VERTB		EQU 5
INTB_BLIT		EQU 6
INTB_AUD0		EQU 7
INTB_AUD1		EQU 8
INTB_AUD2		EQU 9
INTB_AUD3		EQU 10
INTB_RBF		EQU 11
INTB_DSKSYNC		EQU 12
INTB_EXTER		EQU 13
INTB_INTEN		EQU 14
INTB_SETCLR		EQU 15
MODE_OLDFILE		EQU 1005
MODE_NEWFILE		EQU 1006
MEMF_PUBLIC		EQU 1
MEMF_CHIP		EQU 2
MEMF_FAST		EQU 4
MEMF_CLEAR		EQU 65536
MEMF_LARGEST		EQU 131072
SHARED_LOCK		EQU -2
ACCESS_READ		EQU -2
EXCLUSIVE_LOCK		EQU -1
ACCESS_WRITE		EQU -1
DRAFT			EQU $000
NLQ			EQU $100
FANFOLD			EQU $00
SINGLE			EQU $80	
NOITEM			EQU $003F
NOMENU			EQU $001F
NOSUB			EQU $001F
MENUNULL		EQU $FFFF
MAXPOT			EQU $FFFF
wd_WINDOWSIZING		EQU $0001
wd_WINDOWDRAG		EQU $0002
wd_WINDOWDEPTH		EQU $0004
wd_WINDOWCLOSE		EQU $0008
wd_SIZEBRIGHT		EQU $0010
wd_SIZEBBOTTOM		EQU $0020
wd_SMART_REFRESH 	EQU $0000
wd_SIMPLE_REFRESH	EQU $0040
wd_SUPER_REFRESH	EQU $0080
wd_OTHER_REFRESH	EQU $00C0
wd_BACKDROP		EQU $0100
wd_REPORTMOUSE		EQU $0200
wd_GIMMEZEROZERO	EQU $0400
wd_BORDERLESS		EQU $0800
wd_ACTIVATE		EQU $1000
wd_WINDOWACTIVE		EQU $2000
wd_INREQUEST		EQU $4000
wd_MENUSTATE		EQU $8000
DAListSize		EQU 20480
FileNameBufSize		EQU 20480
FIB			EQU 260
RECOVERY_ALERT		EQU $00000000
DEADEND_ALERT		EQU $80000000
DEVICES			EQU %00000001
DISKONLY		EQU %00000010
VOLUMES			EQU %00000100
DIRS			EQU %00001000
UNIT_MICROHZ		EQU 0
UNIT_VBLANK		EQU 1
NT_UNKNOWN		EQU 0
NT_TASK			EQU 1
NT_INTERRUPT		EQU 2
NT_DEVICE		EQU 3
NT_MSGPORT		EQU 4
NT_MESSAGE		EQU 5
NT_FREEMSG		EQU 6
NT_REPLYMSG		EQU 7
NT_RESOURCE		EQU 8
NT_LIBRARY		EQU 9
NT_MEMORY		EQU 10
NT_SOFTINT		EQU 11		;Exec Private
NT_FONT			EQU 12
NT_PROCESS		EQU 13
NT_SEMAPHORE		EQU 14
NT_SIGNALSEM		EQU 15
NT_BOOTNODE		EQU 16
PA_SIGNAL		EQU 0
CMD_INVALID		EQU 0 
CMD_RESET		EQU 1
CMD_READ		EQU 2
CMD_WRITE		EQU 3
CMD_UPDATE		EQU 4
CMD_CLEAR		EQU 5
CMD_STOP		EQU 6
CMD_START		EQU 7
CMD_FLUSH		EQU 8
CMD_NONSTD		EQU 9
TR_ADDREQUEST		EQU 9
TR_GETSYSTIME		EQU 10
TR_SETSYSTIME		EQU 11

;Req.library stuff

FRQSHOWINFOB		EQU 0
FRQEXTSELECTB		EQU 1
FRQCACHINGB		EQU 2
FRQGETFONTS		EQU 3
FRQINFOGADGETB		EQU 4
FRQHIDEWILDSB		EQU 5
FRQABSOLUTEXYB		EQU 6
FRQCACHEPURGEB		EQU 7
FRQNOHALFCACHEB		EQU 8
FRQNOSORTB		EQU 9
FRQNODRAGB		EQU 10
FRQSAVINGB		EQU 11
FRQLOADINGB		EQU 12
FRQDIRONLYB		EQU 13

;Nothing to do with those ^^^

VecTab_Size		EQU 10240
TmpRas_Size		EQU ((640+15)/16*2)*256

;--------------------------------------------------		

		section	TL,code

Start:		move.l	$4,a6
		lea.l	reqname(pc),a1
		moveq.l	#2,d0
		jsr	OpenLibrary(a6)
		tst.l	d0
		bne	Start1
		lea.l	dosname(pc),a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		tst.l	d0
		beq	NoReq_ShutDown
		move.l	d0,a6
		jsr	Output(a6)
		move.l	d0,d4
		beq	NoReq_ShutDown
		lea.l	NoREQText1(pc),a0
		move.l	a0,d2
		move.l	#21,d3
		move.l	d4,d1
		jsr	Write(a6)
		lea.l	NoREQText2(pc),a0
		move.l	a0,d2
		move.l	#7,d3
		move.l	d4,d1
		jsr	Write(a6)
		move.l  a6,a1
		move.l	$4,a6
		jsr	CloseLibrary(a6)
NoReq_ShutDown:	move.l	#8,d0
		rts

Start1:		move.l	d0,reqbase
		move.l	d0,a0
		move.l	$26(a0),dosbase
		move.l	$2a(a0),intbase
		move.l	$2e(a0),gfxbase

		move.l	dosbase(pc),a6
		jsr	OutPut(a6)
		move.l	d0,OutFile

;Get MaxDisplayColumns

Start1.1:	move.l	intbase(pc),a1
		move.l	$3c(a1),a0
	
;Get memory for IORequest for timer.device

		move.l	$4,a6
		move.l	#$28,d0
		move.l	#MEMF_CLEAR+MEMF_PUBLIC,d1
		jsr	AllocMem(a6)
		tst.l	d0
		beq	ShutDown
		move.l	d0,TimeReq

;Open timer.device

		lea.l	timename(pc),a0
		move.l	#UNIT_MICROHZ,d0
		move.l	TimeReq(pc),a1
		move.l	#0,d1
		jsr	OpenDevice(a6)
		tst.l	d0
		bne	ShutDown

;Create Port

		move.l	$4,a6
		move.l	#-1,d0
		jsr	AllocSignal(a6)
		cmp.l	#-1,d0
		beq	ShutDown
		move.b	d0,TSigBit

;Get memory for Timers replyport

		move.l	#$22,d0
		move.l	#MEMF_CLEAR+MEMF_PUBLIC,d1
		jsr	AllocMem(a6)
		tst.l	d0
		beq	ShutDown
		move.l	d0,TPort

;Add Port

		move.l	TPort,a0
		lea.l	TimePName,a1
		move.l	a1,$a(a0)		;Name
		move.b	#$00,$9(a0)		;Priority = 0
		move.b	#NT_MSGPORT,$8(a0)	;Type NT_MSGPORT
		
		move.b	#PA_SIGNAL,$e(a0)
		move.b	TSigBit(pc),$f(a0)
		move.l	OurTask(pc),$10(a0)
		
		move.l	TPort(pc),a1
		jsr	AddPort(a6)

;Allocate other needed memory space

		move.l	#VecTab_Size,d0
		move.l	#MEMF_CHIP+MEMF_CLEAR,d1
		jsr	AllocMem(a6)
		tst.l	d0
		beq	ShowGuru
		move.l	d0,VecTab1

		move.l	#TmpRas_Size,d0
		move.l	#MEMF_CHIP+MEMF_CLEAR,d1
		jsr	AllocMem(a6)
		tst.l	d0
		beq	ShowGuru
		move.l	d0,TmpRas

;Open Screen
		move.l	intbase(pc),a6
		lea.l	NewScreen1(pc),a0
		jsr	OpenScreen(a6)
		tst.l	d0
		bne	OpenScreen1
		lea.l	NoScreen1(pc),a0
		jmp	ErrorPrint

OpenScreen1:	move.l	d0,Screen1
		move.l	d0,SToW1
		move.l	d0,SToW2
		move.l	d0,SToW3
		move.l	d0,SToW4
		move.l	d0,SToW7
		move.l	d0,SToW8
		move.l	d0,TLIntScreen
;Get ViewPort
		move.l	Screen1(pc),a0
		add.l	#$2c,a0
		move.l	a0,ViewPort

;Open Window2

		move.l	intbase(pc),a6
		lea.l	NewWindow2(pc),a0
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	Window2.1
		lea.l	NoWin2(pc),a0
		jmp	ErrorPrint
Window2.1:	move.l	d0,Window2

;Get RastPort2
		move.l	d0,a0
		move.l	$32(a0),RastPort2

;move requesters to Window2

		move.l	$4,a6
		move.l	#$00,a1
		jsr	FindTask(a6)
		move.l	d0,OurTask
		move.l	d0,a0
		move.l	$b8(a0),OldTaskWinPtr
		move.l	Window2(pc),$b8(a0)
		
;Set the menus for Window2

		move.l	intbase(pc),a6
		move.l	Window2(pc),a0
		lea.l	Menu1(pc),a1
		jsr	SetMenuStrip(a6)
		tst.l	d0
		beq	ShutDown

MainLoop:	jmp	Window2IDCMP
	
;Open Window1

New:		move.l	intbase(pc),a6
		move.l	Screen1(pc),a0
		move.l	#$00,d0
		jsr	ShowTitle(a6)
		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)
		move.l	Window2(pc),a0
		move.l	#$0,d0
		jsr	MenusOff
		move.l	intbase(pc),a6
		lea.l	NewWindow1(pc),a0
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	New1
		lea.l	NoWin1(pc),a0
		jmp	ErrorPrint
New1:		move.l	d0,Window1

;Get RastPort1
		move.l	d0,a0
		move.l	$32(a0),RastPort1

		move.l	gfxbase(pc),a6
		move.l	#640,d0
		move.l	#256,d1
		jsr	AllocRaster(a6)
		tst.l	d0
		bne	GetRastP0.1
		jmp	ShowGuru
GetRastP0.1:	move.l	d0,PlanePtr

		move.l	gfxbase(pc),a6
		lea.l	NewAreaInfo1(pc),a0
		move.l	VecTab1(pc),a1
		move.l	#2048,d0
		jsr	InitArea(a6)
		tst.l	d0
		bne	GetRastP1
		lea.l	NoAreaInit(pc),a0
		jmp	ErrorPrint

GetRastP1:	move.l	PlanePtr(pc),a1
		lea.l	NewTmpRas1(pc),a0
		move.l	#TmpRas_Size,d0
		jsr	InitTmpRas(a6)
		move.l	RastPort1(pc),a0
		lea.l	NewTmpRas1(pc),a1
		lea.l	NewAreaInfo1(pc),a2	
		move.l	a1,$c(a0)
		move.l	a2,$10(a0)

;Open Variable Editor window
	
		move.l	intbase(pc),a6
		lea.l	NewWindow3(pc),a0
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	VE1
		lea.l	NoWin3(pc),a0
		jmp	ErrorPrint
VE1:		move.l	d0,Window3

		move.l	intbase(pc),a6
		move.l	Window3(pc),a0
		lea.l	Menu9(pc),a1
		jsr	SetMenuStrip(a6)
		move.l	Window3(pc),a0
		move.l	#$0,d0
		jsr	MenusOff

;Get RastPort3
		move.l	Window3,a0
		move.l	$32(a0),RastPort3

;		move.l	intbase(pc),a6
;		lea.l	MapTxt1(pc),a1
;		move.l	#$00,d0
;		move.l	d0,d1
;		move	RastPort3(pc),a0
;		jsr	PrintIText(a6)

		move.l	ViewPort(pc),a0
		move.l	gfxbase(pc),a6
		lea.l	ColorMap2(pc),a1
		move.l	#8,d0
		jsr	LoadRGB4(a6)

; Draw city map

		move.l	intbase(pc),a6
		move.l	RastPort1(pc),a0
		lea.l	CityMap1(pc),a1
		move.l	#$0,d0
		move.l	#$0,d1
		jsr	DrawBorder(a6)

		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#$01,d0
		jsr	SetAPen(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#16,d1
		move.l	#3,d2
		move.l	#2,d3
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#116,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#122,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#374,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#380,d0
		move.l	#16,d1
		jsr	DrawEllipse(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#47,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#51,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#374,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#380,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#278,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#284,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#56,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#60,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#278,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#284,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#47,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#51,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#116,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#122,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#18,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#24,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#92,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#56,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#60,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#64,d1
		jsr	DrawEllipse(a6)

		move.l	RastPort1(pc),a1
		move.l	#18,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#24,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)
		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#43,d1
		jsr	DrawEllipse(a6)

		jsr	ColorLights

;Get System time for later use

		move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)

		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)

		move.l	TimeReq(pc),a0
		move.l	$20(a0),LSecs
		move.l	$20(a0),CSecs

		move.l	intbase(pc),a6
		lea.l	Gadget1(pc),a0
		move.l	Window3(pc),a1
		move.l	#$00,a2
		jsr	ActivateGadget(a6)

;add interrupt for the car movements

		move.l	$4,a6
		move.l	#INTB_VERTB,d0
		lea.l	TLInt(pc),a1
		jsr	AddIntServer(a6)

		jsr	InitCars

; Check if the window´s close button pressed

Window1IDCMP:
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		jsr	SortGList(a6)
		move.l	ViewPort(pc),a0
		move.l	RastPort1(pc),a1
		jsr	DrawGList(a6)
		move.l	intbase(pc),a6
		jsr	RethinkDisplay(a6)

		move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)

		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)

;Now compare the set times with current and then maybe change lights

CheckRLength:	cmp.l	#$00,RedLength		;See if length=0
		bne	CheckGLength
		move.l	intbase(pc),a6
		move.l	Screen1(pc),a0
		jsr	DisplayBeep(a6)
		move.l	#$30,RedLength		;If it is then reset
		move.b	#"3",Gad1Buf
		move.b	#"0",Gad1Buf+1
		move.b	#$00,Gad1Buf+2
		move.l	Window3(pc),a1
		lea.l	Gadget1(pc),a0
		move.l	#-1,d0
		jsr	RefreshGList(a6)
CheckGLength:	cmp.l	#$00,GreenLength	;See if length=0
		bne	CompareL
		move.l	intbase(pc),a6
		move.l	Screen1(pc),a0
		jsr	DisplayBeep(a6)
		move.l	#$20,GreenLength	;If it is then reset
		move.b	#"2",Gad3Buf
		move.b	#"0",Gad3Buf+1
		move.b	#$00,Gad3Buf+2
		move.l	Window3(pc),a1
		lea.l	Gadget1(pc),a0
		move.l	#-1,d0
		jsr	RefreshGList(a6)

CompareL:	move.l	TimeReq(pc),a0
		move.l	$20(a0),a3
		sub.l	GSecs,a3		;Cars crossing junction
		cmp.l	OutCarTime(pc),a3
		bhi	CarsLeave		;per z secs
CompareL0.1:	move.l	$20(a0),a3
		sub.l	CSecs,a3
		cmp.l	InCarTime(pc),a3
		bhi	Cars
		move.l	$20(a0),a3
		sub.l	LSecs,a3
		cmp.b	#$00,LStatus
		beq	CompareL1
		cmp.b	#$02,LStatus
		beq	CompareL2
CompareL0:	cmp.l	AmberLength(pc),a3
		bcs	Window1IDCMP2
		jmp	GetNewSysTime
CompareL1:	cmp.l	RedLength(pc),a3
		bcs	Window1IDCMP2
		jmp	GetNewSysTime
CompareL2:	cmp.l	GreenLength(pc),a3
		bcs	Window1IDCMP2

;Get new system time and save it

GetNewSysTime:	move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)

		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)

		move.l	TimeReq(pc),a0
		move.l	$20(a0),LSecs
		jmp	ChangeLights

Window1IDCMP2:
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		jsr	SortGList(a6)
		move.l	ViewPort(pc),a0
		move.l	RastPort1(pc),a1
		jsr	DrawGList(a6)
		move.l	Window1(pc),a0
		move.l	Window2(pc),a4
		move.l	Window3(pc),a3
		jsr	CheckIDCMP
		cmp.l	#CLOSEWINDOW,d2
		beq	CityMapQuit
		cmp.l	#GADGETUP,d2
		beq	Activategads
		cmp.l	#VANILLAKEY,d2
		beq	Keys
		cmp.l	#MENUPICK,d2
		beq	DoWin2MenusExt
		cmp.l	#RAWKEY,d2
		beq	Window2KeysExt
		cmp.l	#GADGETDOWN,d2
		beq     ButtonsDown
		jmp	Window1IDCMP

ButtonsDown:    move.l	intbase(pc),a6
                lea.l	ModeGad1(pc),a1
                cmp.l	a1,a5
                beq	ButtonsDown1
		lea.l	ModeGad2(pc),a1
		cmp.l	a1,a5
		beq	ButtonsDown2
                lea.l	ModeGad3(pc),a1
		cmp.l	a1,a5
		beq     ButtonsDown3
		jmp	Window1IDCMP
ButtonsDown1:	lea.l   ModeGad2(pc),a0
                move.w	#$6,$c(a0)
		lea.l	ModeGad3(pc),a0
		move.w	#$6,$c(a0)
		move.l	Window3(pc),a1
		lea.l	ModeGad1(pc),a0
		move.l	#3,d0
		jsr	RefreshGList(a6)
		move.l	#$2,TrafficMode
		jmp	Window1IDCMP
ButtonsDown2:	lea.l   ModeGad1(pc),a0
                move.w	#$6,$c(a0)
		lea.l	ModeGad3(pc),a0
		move.w	#$6,$c(a0)
		move.l	Window3(pc),a1
		lea.l	ModeGad1(pc),a0
		move.l	#3,d0
		jsr	RefreshGList(a6)
		move.l	#$4,TrafficMode
		jmp	Window1IDCMP
ButtonsDown3:	lea.l   ModeGad1(pc),a0
                move.w	#$6,$c(a0)
		lea.l	ModeGad2(pc),a0
		move.w	#$6,$c(a0)
		move.l	Window3(pc),a1
		lea.l	ModeGad1(pc),a0
		move.l	#3,d0
		jsr	RefreshGList(a6)
		move.l	#$5,TrafficMode
		jmp	Window1IDCMP
ButtonsDown4:	move.l	intbase(pc),a6
		lea.l	ModeGad1(pc),a0
                cmp.w	#$06,$c(a0)
		bne     ButtonsDown5
		lea.l	ModeGad2(pc),a0
		cmp.w	#$06,$c(a0)
		bne     ButtonsDown5
		lea.l	ModeGad3(pc),a0
		cmp.w	#$06,$c(a0)
		bne     ButtonsDown5
		move.w  #$86,$c(a5)
		lea.l	ModeGad1(pc),a0
		move.l	#3,d0
		move.l	Window3(pc),a1
		jsr	RefreshGList(a6)
ButtonsDown5:	jmp	Window1IDCMP

Window2KeysExt:	cmp.w	#$5f,d3
		bne	W2K0
		jsr	GrapsOff
		jsr	Help
		jsr	GrapsOn
W2K0:		jmp	Window1IDCMP
DoWin2MenusExt:	jsr	MenuNull
		cmp.l	#$01,d6		;Change this if you want more menus
;		beq	
		cmp.l	#$00,d6
		bne	ExtIsMenu1.2

ExtIsMenu1.0:	cmp.l	#$01,d5
		bne	ExtIsMenu1.01
		jsr	GrapsOff
		jsr	Help
		jsr	GrapsOn
		jmp	Window1IDCMP
ExtIsMenu1.01:	cmp.l	#$02,d5
		bne	ExtIsMenu1.02
		jsr	GrapsOff
		jsr	Load
		jsr	GrapsOn
		jmp	Window1IDCMP
ExtIsMenu1.02:	cmp.l	#$04,d5
		bne	ExtIsMenu1.03
		jsr	GrapsOff
		jsr	SaveAs
		jsr	GrapsOn
		jmp	Window1IDCMP
ExtIsMenu1.03:	cmp.l	#$05,d5
		bne	ExtIsMenu1.1
		jsr	GrapsOff
		jsr	About
		jsr	GrapsOn
ExtIsMenu1.1:	cmp.l	#$06,d5
		beq	CityMapQuit
ExtIsMenu1.2:	jmp	Window1IDCMP

GrapsOff:	
		move.l	$4,a6
		move.l	#INTB_VERTB,d0
		lea.l	TLInt(pc),a1
		jsr	RemIntServer(a6)

		cmp.b	#$01,SpritesXOn
		beq	GrapsOff1
		move.l	gfxbase(pc),a6
		lea.l	Sprite1(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite4(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite9(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite10(pc),a0
		jsr	RemVSprite(a6)
		jmp	GrapsOff2

GrapsOff1:	move.l	gfxbase(pc),a6
		lea.l	Sprite7(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite8(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite9(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite10(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite11(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite12(pc),a0
		jsr	RemVSprite(a6)

GrapsOff2:	lea.l	Sprite13(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite14(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite15(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite16(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite17(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite18(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite19(pc),a0
		jsr	RemVSprite(a6)
;		lea.l	Sprite20(pc),a0
;		jsr	RemVSprite(a6)
;		lea.l	Sprite21(pc),a0
;		jsr	RemVSprite(a6)
;		lea.l	Sprite22(pc),a0
;		jsr	RemVSprite(a6)
;		lea.l	Sprite23(pc),a0
;		jsr	RemVSprite(a6)
		lea.l	Sprite24(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite25(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite26(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite27(pc),a0
		jsr	RemVSprite(a6)
		move.l	RastPort1(pc),a1
		jsr	SortGList(a6)
		move.l	ViewPort(pc),a0
		move.l	RastPort1(pc),a1
		jsr	DrawGList(a6)

		move.l	intbase(pc),a6
		jsr	RethinkDisplay(a6)
		rts

GrapsOn:	move.l	$4,a6
		move.l	#INTB_VERTB,d0
		lea.l	TLInt(pc),a1
		jsr	AddIntServer(a6)
		jsr	InitCars
		rts

Activategads:	move.l	intbase(pc),a6
		move.l	(a5),a0
		cmp.l	#$00,a0
		bne	ActivateGads1
		lea.l	Gadget1(pc),a0
ActivateGads1:	move.l	Window3(pc),a1
		move.l	#$00,a2
		jsr	ActivateGadget(a6)
		jmp     ButtonsDown4

Keys:		cmp.w	#$1b,d3
		beq	CityMapQuit
		jmp	Window1IDCMP

CityMapQuit:

;Remove interrupt server

		move.l	$4,a6
		move.l	#INTB_VERTB,d0
		lea.l	TLInt(pc),a1
		jsr	RemIntServer(a6)

		move.l	gfxbase(pc),a6
		move.l	PlanePtr(pc),a0
		move.l	#640,d0
		move.l	#256,d1
		jsr	FreeRaster(a6)

;Change the colors to the presets so the quitting gadgets look ok

		move.l	ViewPort(pc),a0
		move.l	gfxbase(pc),a6
		lea.l	ColorMap1(pc),a1
		move.l	#8,d0
		jsr	LoadRGB4(a6)

;Remove sprites, otherwise they'll be seen in the wrong window!

		move.l	gfxbase(pc),a6
		lea.l	Sprite1(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite4(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite7(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite8(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite9(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite10(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite11(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite12(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite13(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite14(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite15(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite16(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite17(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite18(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite19(pc),a0
		jsr	RemVSprite(a6)
;		lea.l	Sprite20(pc),a0
;		jsr	RemVSprite(a6)
;		lea.l	Sprite21(pc),a0
;		jsr	RemVSprite(a6)
;		lea.l	Sprite22(pc),a0
;		jsr	RemVSprite(a6)
;		lea.l	Sprite23(pc),a0
;		jsr	RemVSprite(a6)
		lea.l	Sprite24(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite25(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite26(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite27(pc),a0
		jsr	RemVSprite(a6)
		move.l	RastPort1(pc),a1
		jsr	SortGList(a6)
		move.l	ViewPort(pc),a0
		move.l	RastPort1(pc),a1
		jsr	DrawGList(a6)

		move.l	intbase(pc),a6
		jsr	RethinkDisplay(a6)
		move.l	Screen1(pc),a0
		move.l	#$ff,d0
		jsr	ShowTitle(a6)
		move.l	Window2(pc),a0
		move.l	#$00,d0
		jsr	MenusOn
		move.l	Window1(pc),a0
		jsr	ClearMSGs
		move.l	#$0,Window1
		move.l	Window3(pc),a0
		move.l	intbase(pc),a6
		jsr	ClearMenuStrip(a6)
		move.l	Window3(pc),a0
		jsr	ClearMSGs
		move.l	#$0,Window3
GoToMainLoop1:	jmp	MainLoop

CarsLeave:	move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)
		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)

		move.l	TimeReq(pc),a0
		move.l	$20(a0),GSecs

		jsr	YLightsGreen
		jsr	XLightsGreen
		jmp	CompareL0.1

;Here starts the part with the cars themselves
;Add checking of Max Amount of cars etc.


Cars:		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#$00,d0
		jsr	SetAPen(a6)
		move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)
		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)
		move.l	TimeReq(pc),a0
		move.l	$20(a0),CSecs
		jsr	GetRandom
		cmp.l	In1(pc),d5
		bhi	Cars1
		add.w	#$01,Amount1
		jsr	CarCome1
Cars1:		jsr	GetRandom
		cmp.l	In2(pc),d5
		bhi	Cars2
		add.w	#$01,Amount2
		jsr	CarCome2
Cars2:		jsr	GetRandom
		cmp.l	In3(pc),d5
		bhi	Cars3
		add.w	#$01,Amount3
		jsr	CarCome3
Cars3:		jsr	GetRandom
		cmp.l	In4(pc),d5
		bhi	Cars4
		add.w	#$01,Amount4
		jsr	CarCome4
Cars4:		jsr	GetRandom
		cmp.l	In5(pc),d5
		bhi	Cars5
		add.w	#$01,Amount5
		jsr	CarCome5
Cars5:		jsr	GetRandom
		cmp.l	In6(pc),d5
		bhi	Cars6
		add.w	#$01,Amount6
		jsr	CarCome6
Cars6:		jsr	GetRandom
		cmp.l	In7(pc),d5
		bhi	Cars7
		add.w	#$01,Amount7
		jsr	CarCome7
Cars7:		jsr	GetRandom
		cmp.l	In8(pc),d5
		bhi	Window1IDCMP2
		add.w	#$01,Amount8
		jsr	CarCome8
		jmp	Window1IDCMP2
CarCome1:	move.w	Amount1(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#39,d0
		move.l	#12,d1
		move.l	#58,d2
		move.l	#21,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt1(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome2:	move.w	Amount2(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#301,d0
		move.l	#12,d1
		move.l	#321,d2
		move.l	#21,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt2(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome3:	move.w	Amount3(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#360,d0
		move.l	#22,d1
		move.l	#375,d2
		move.l	#31,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt3(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome4:	move.w	Amount4(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#360,d0
		move.l	#70,d1
		move.l	#375,d2
		move.l	#80,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt4(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome5:	move.w	Amount5(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#338,d0
		move.l	#88,d1
		move.l	#358,d2
		move.l	#96,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt5(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome6:	move.w	Amount6(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#78,d0
		move.l	#88,d1
		move.l	#98,d2
		move.l	#96,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt6(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome7:	move.w	Amount7(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#20,d0
		move.l	#76,d1
		move.l	#40,d2
		move.l	#86,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt7(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome8:	move.w	Amount8(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#20,d0
		move.l	#28,d1
		move.l	#40,d2
		move.l	#38,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt8(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome9:	move.w	Amount9(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#101,d0
		move.l	#22,d1
		move.l	#121,d2
		move.l	#31,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt9(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome10:	move.w	Amount10(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#280,d0
		move.l	#27,d1
		move.l	#300,d2
		move.l	#37,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt10(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome11:	move.w	Amount11(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#301,d0
		move.l	#57,d1
		move.l	#321,d2
		move.l	#67,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt11(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome12:	move.w	Amount12(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#337,d0
		move.l	#41,d1
		move.l	#357,d2
		move.l	#51,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt12(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome13:	move.w	Amount13(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#280,d0
		move.l	#77,d1
		move.l	#300,d2
		move.l	#87,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt13(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome14:	move.w	Amount14(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#101,d0
		move.l	#69,d1
		move.l	#121,d2
		move.l	#79,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt14(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome15:	move.w	Amount15(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#39,d0
		move.l	#57,d1
		move.l	#61,d2
		move.l	#67,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt15(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts
CarCome16:	move.w	Amount16(pc),DStream
		lea.l	FString(pc),a0
		lea.l	DStream(pc),a1
		lea.l	PutChProc(pc),a2
		lea.l	PutChData(pc),a3
		move.l	$4,a6
		jsr	RawDoFmt(a6)
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#75,d0
		move.l	#40,d1
		move.l	#95,d2
		move.l	#50,d3
		jsr	RectFill(a6)
		move.l	intbase(pc),a6
		lea.l	AmountTxt16(pc),a1
		move.l	RastPort1(pc),a0
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	PrintIText(a6)
		rts

;Here's the thing that checks if there is room for more cars 

CheckXMax:	rts
CheckYMax:	rts
	
;Here we have the routine that changes the lights
;
;LightStatus contains previous situation
;
;0 = "Original"	i.e. green lights in the north-south direction
;1 = Amber 1 -- 
;3 = Green lights in the east-west direction
;4 = Amber 2 --


ChangeLights:	move.b	LStatus(pc),d0
		beq	LStat1
		cmp.b	#$01,d0
		beq	LStat2
		cmp.b	#$02,d0
		beq	LStat3

;Let it go on. If LStatus <>0,1,2 then it MUST be 3 :-)
;You actually never should do this, but now even if there is an error
;the light status will be reseted. 
	
LStat0:		move.l	gfxbase(pc),a6
		cmp.b	#$01,SpritesXOn
		bne	LStat0.1
		lea.l	Sprite7(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite8(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite11(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite12(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite1(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite4(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite9(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite10(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		move.b	#$00,SpritesXOn

LStat0.1:	move.l	ViewPort(pc),a0
		move.l	#3,d0
		move.l	#$a,d1
		move.l	#$a,d2
		move.l	#$a,d3
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#6,d0
		move.l	#$a,d1
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#7,d0
		move.l	#$a,d1
		jsr	SetRGB4(a6)

		move.l	ViewPort(pc),a0
		move.l	#4,d0
		move.l	#$0,d1
		move.l	#$f,d2
		move.l	#$0,d3
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#5,d0
		move.l	#$f,d1
		move.l	#$0,d2
		move.l	#$0,d3
		jsr	SetRGB4(a6)
		move.b	#$00,LStatus
		jmp	Window1IDCMP2
		
LStat1:		cmp.l	#$00,AmberLength
		beq	LStat2
		move.l	gfxbase(pc),a6
		move.l	ViewPort(pc),a0
		move.l	#6,d0
		move.l	#$f,d1
		move.l	#$a,d2
		move.l	#$0,d3
		jsr	SetRGB4(a6)

		move.l	ViewPort(pc),a0
		move.l	#4,d0
		move.l	#$a,d1
		move.l	#$a,d2
		move.l	#$a,d3
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.b	#$1,LStatus
		jmp	Window1IDCMP2
		
LStat2:		move.l	gfxbase(pc),a6
		cmp.b	#$01,SpritesXOn
		beq	LStat2.1
		lea.l	Sprite1(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite4(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite9(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite10(pc),a0
		jsr	RemVSprite(a6)
		lea.l	Sprite7(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite8(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite11(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite12(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		move.b	#$01,SpritesXOn

LStat2.1:	move.l	ViewPort(pc),a0
		move.l	#6,d0
		move.l	#$a,d1
		move.l	#$a,d2
		move.l	#$a,d3
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#4,d0
		move.l	#$a,d1
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#5,d0
		move.l	#$a,d1
		jsr	SetRGB4(a6)

		move.l	ViewPort(pc),a0
		move.l	#3,d0
		move.l	#$0,d1
		move.l	#$f,d2
		move.l	#$0,d3
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#7,d0
		move.l	#$f,d1
		move.l	#$0,d2
		move.l	#$0,d3
		jsr	SetRGB4(a6)
		move.b	#$2,LStatus
		jmp	Window1IDCMP2

LStat3:		cmp.l	#$00,AmberLength
		beq	LStat0
		move.l	gfxbase(pc),a6
		move.l	ViewPort(pc),a0
		move.l	#6,d0
		move.l	#$f,d1
		move.l	#$a,d2
		move.l	#$0,d3
		jsr	SetRGB4(a6)
		move.l	ViewPort(pc),a0
		move.l	#3,d0
		move.l	#$a,d1
		move.l	#$a,d2
		move.l	#$a,d3
		jsr	SetRGB4(a6)
		move.b	#$3,LStatus
		jmp	Window1IDCMP2

GetRandom:	move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)
		
		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)
		
		move.l	TimeReq(pc),a0
		move.l	TrafficMode(pc),d1
		move.l	$24(a0),d0
		ror.l	#$8,d0
		ror.l	d1,d0
		move.l	#$00,d1
		move.b	d0,d1
		cmp.l	#$64,d1
		bhi	GetRandom
		move.l	#$00,DStream2
		move.b	d1,DStream2+3
		move.l	DStream2(pc),d5
		rts

GetRandom2:	move.l	TimeReq(pc),a0
		move.b	#NT_MESSAGE,$8(a0)
		move.b	#$00,$9(a0)
		move.l	#$00,$a(a0)
		move.l	TPort(pc),$e(a0)
		move.w	#TR_GETSYSTIME,$1c(a0)
		
		move.l	$4,a6
		move.l	TimeReq(pc),a1
		jsr	DoIO(a6)
		
		move.l	TimeReq(pc),a0
		move.l	$24(a0),d0
		ror.l	#$8,d0
		ror.l	#$2,d0
		move.l	#$00,d1
		move.b	d0,d1
		cmp.l	#$64,d1
		bhi	GetRandom
		move.l	#$00,DStream2
		move.b	d1,DStream2+3
		move.l	DStream2(pc),d5
		rts

YLightsGreen:	cmp.b	#$00,LStatus
		bne	YBatchOut
		lea.l	Sprite1(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch2
YBatch1:	cmp.w	#$00,Amount1
		beq	YBatch2
		jsr	GetRandom2
		cmp.l	T7(pc),d5	;if turns left
		bcs	YBatch1Right
		sub.l	T7(pc),d5
		cmp.l	T8(pc),d5	;if turns right
		bcs	YBatch1Left
YBatch1Stra:	move.b	#1,$3a(a2)
		sub.w	#$01,Amount1
		jsr	CarCome1
		jmp	YBatch2
YBatch1Right:	move.b	#2,$3a(a2)
		sub.w	#$01,Amount1
		jsr	CarCome1
		jmp	YBatch2
YBatch1Left:	move.b	#3,$3a(a2)
		sub.w	#$01,Amount1
		jsr	CarCome1
YBatch2:	lea.l	Sprite4(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch5
		cmp.w	#$00,Amount2
		beq	YBatch5
		jsr	GetRandom2
		cmp.l	T10(pc),d5	;if turns left
		bcs	YBatch2Right
		sub.l	T10(pc),d5
		cmp.l	T11(pc),d5	;if turns right
		bcs	YBatch2Left
YBatch2Stra:	move.b	#4,$3a(a2)
		sub.w	#1,Amount2
		jsr	CarCome2
		jmp	YBatch5
YBatch2Right:	move.b	#5,$3a(a2)
		sub.w	#1,Amount2
		jsr	CarCome2
		jmp	YBatch5
YBatch2Left:	move.b	#6,$3a(a2)
		sub.w	#1,Amount2
		jsr	CarCome2
YBatch5:	lea.l	Sprite9(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch6
		cmp.w	#$00,Amount5
		beq	YBatch6
		jsr	GetRandom2
		cmp.l	T46(pc),d5	;if turns left
		bcs	YBatch5Right
		sub.l	T46(pc),d5
		cmp.l	T47(pc),d5	;if turns right
		bcs	YBatch5Left
YBatch5Stra:	move.b	#7,$3a(a2)
		sub.w	#1,Amount5
		jsr	CarCome5
		jmp	YBatch6
YBatch5Right:	move.b	#8,$3a(a2)
		sub.w	#1,Amount5
		jsr	CarCome5
		jmp	YBatch6
YBatch5Left:	move.b	#9,$3a(a2)
		sub.w	#1,Amount5
		jsr	CarCome5
YBatch6:	lea.l	Sprite10(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch15
		cmp.w	#$00,Amount6
		beq	YBatch15
		jsr	GetRandom2
		cmp.l	T43(pc),d5	;if turns left
		bcs	YBatch6Right
		sub.l	T43(pc),d5
		cmp.l	T44(pc),d5	;if turns right
		bcs	YBatch6Left
YBatch6Stra:	move.b	#10,$3a(a2)
		sub.w	#1,Amount6
		jsr	CarCome6
		jmp	YBatch15
YBatch6Right:	move.b	#11,$3a(a2)
		sub.w	#1,Amount6
		jsr	CarCome6
		jmp	YBatch15
YBatch6Left:	move.b	#12,$3a(a2)
		sub.w	#1,Amount6
		jsr	CarCome6
YBatch15:	lea.l	Sprite24(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	YBatch15.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch16
YBatch15.1:	cmp.w	#$00,Amount15
		beq	YBatch16
		jsr	GetRandom2
		cmp.l	T31(pc),d5	;if turns left
		bcs	YBatch15Right
		sub.l	T31(pc),d5
		cmp.l	T32(pc),d5	;if turns right
		bcs	YBatch15Left
YBatch15Stra:	move.b	#19,$3a(a2)
		sub.w	#1,Amount15
		jsr	CarCome15
		jmp	YBatch16
YBatch15Right:	move.b	#20,$3a(a2)
		sub.w	#1,Amount15
		jsr	CarCome15
		jmp	YBatch16
YBatch15Left:	move.b	#21,$3a(a2)
		sub.w	#1,Amount15
		jsr	CarCome15
YBatch16:	lea.l	Sprite26(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	YBatch16.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch11
YBatch16.1:	cmp.w	#$00,Amount16
		beq	YBatch11
		jsr	GetRandom2
		cmp.l	T19(pc),d5	;if turns left
		bcs	YBatch16Right
		sub.l	T19(pc),d5
		cmp.l	T20(pc),d5	;if turns right
		bcs	YBatch16Left
YBatch16Stra:	move.b	#13,$3a(a2)
		sub.w	#1,Amount16
		jsr	CarCome16
		jmp	YBatch11
YBatch16Right:	move.b	#14,$3a(a2)
		sub.w	#1,Amount16
		jsr	CarCome16
		jmp	YBatch11
YBatch16Left:	move.b	#15,$3a(a2)
		sub.w	#1,Amount16
		jsr	CarCome16
YBatch11:	lea.l	Sprite16(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	YBatch11.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	YBatch12
YBatch11.1:	cmp.w	#$00,Amount12
		beq	YBatch12
		jsr	GetRandom2
		cmp.l	T22(pc),d5	;if turns left
		bcs	YBatch11Right
		sub.l	T22(pc),d5
		cmp.l	T23(pc),d5	;if turns right
		bcs	YBatch11Left
YBatch11Stra:	move.b	#16,$3a(a2)
		sub.w	#1,Amount12
		jsr	CarCome12
		jmp	YBatch12
YBatch11Right:	move.b	#17,$3a(a2)
		sub.w	#1,Amount12
		jsr	CarCome12
		jmp	YBatch12
YBatch11Left:	move.b	#18,$3a(a2)
		sub.w	#1,Amount12
		jsr	CarCome12
YBatch12:	lea.l	Sprite18(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	YBatch12.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	YBatchOut
YBatch12.1:	cmp.w	#$00,Amount11
		beq	YBatchOut
		jsr	GetRandom2
		cmp.l	T34(pc),d5	;if turns left
		bcs	YBatch12Right
		sub.l	T34(pc),d5
		cmp.l	T35(pc),d5	;if turns right
		bcs	YBatch12Left
YBatch12Stra:	move.b	#22,$3a(a2)
		sub.w	#1,Amount11
		jsr	CarCome11
		jmp	YBatchOut
YBatch12Right:	move.b	#23,$3a(a2)
		sub.w	#1,Amount11
		jsr	CarCome11
		jmp	YBatchOut
YBatch12Left:	move.b	#24,$3a(a2)
		sub.w	#1,Amount11
		jsr	CarCome11
YBatchOut:	rts

XLightsGreen:	cmp.b	#$02,LStatus
		bne	XBatchOut
XBatch3:	lea.l	Sprite7(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch4
		cmp.w	#$00,Amount3
		beq	XBatch4
		jsr	GetRandom2
		cmp.l	T16(pc),d5	;if turns left
		bcs	XBatch3Right
		sub.l	T16(pc),d5
		cmp.l	T17(pc),d5	;if turns right
		bcs	XBatch3Left
XBatch3Stra:	move.b	#43,$3a(a2)
		sub.w	#1,Amount3
		jsr	CarCome3
		jmp	XBatch4
XBatch3Right:	move.b	#44,$3a(a2)
		sub.w	#1,Amount3
		jsr	CarCome3
		jmp	XBatch4
XBatch3Left:	move.b	#45,$3a(a2)
		sub.w	#1,Amount3
		jsr	CarCome3
XBatch4:	lea.l	Sprite8(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch7
		cmp.w	#$00,Amount4
		beq	XBatch7
		jsr	GetRandom2
		cmp.l	T40(pc),d5	;if turns left
		bcs	XBatch4Right
		sub.l	T40(pc),d5
		cmp.l	T41(pc),d5	;if turns right
		bcs	XBatch4Left
XBatch4Stra:	move.b	#46,$3a(a2)
		sub.w	#1,Amount4
		jsr	CarCome4
		jmp	XBatch7
XBatch4Right:	move.b	#47,$3a(a2)
		sub.w	#1,Amount4
		jsr	CarCome4
		jmp	XBatch7
XBatch4Left:	move.b	#48,$3a(a2)
		sub.w	#1,Amount4
		jsr	CarCome4
XBatch7:	lea.l	Sprite11(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch8
		cmp.w	#$00,Amount7
		beq	XBatch8
		jsr	GetRandom2
		cmp.l	T28(pc),d5	;if turns left
		bcs	XBatch7Right
		sub.l	T29(pc),d5
		cmp.l	T30(pc),d5	;if turns right
		bcs	XBatch7Left
XBatch7Stra:	move.b	#46,$3a(a2)
		sub.w	#1,Amount7
		jsr	CarCome7
		jmp	XBatch8
XBatch7Right:	move.b	#47,$3a(a2)
		sub.w	#1,Amount7
		jsr	CarCome7
		jmp	XBatch8
XBatch7Left:	move.b	#48,$3a(a2)
		sub.w	#1,Amount7
		jsr	CarCome7
XBatch8:	lea.l	Sprite12(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch9
		cmp.w	#$00,Amount8
		beq	XBatch9
		jsr	GetRandom2
		cmp.l	T1(pc),d5	;if turns left
		bcs	XBatch8Right
		sub.l	T1(pc),d5
		cmp.l	T2(pc),d5	;if turns right
		bcs	XBatch8Left
XBatch8Stra:	move.b	#26,$3a(a2)
		sub.w	#1,Amount8
		jsr	CarCome8
		jmp	XBatch9
XBatch8Right:	move.b	#27,$3a(a2)
		sub.w	#1,Amount8
		jsr	CarCome8
		jmp	XBatch9
XBatch8Left:	move.b	#28,$3a(a2)
		sub.w	#1,Amount8
		jsr	CarCome8
XBatch9:	lea.l	Sprite13(pc),a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch10
		cmp.w	#$00,Amount9
		beq	XBatch10
		jsr	GetRandom2
		cmp.l	T13(pc),d5	;if turns left
		bcs	XBatch9Right
		sub.l	T13(pc),d5
		cmp.l	T14(pc),d5	;if turns right
		bcs	XBatch9Left
XBatch9Stra:	move.b	#26,$3a(a2)
		sub.w	#1,Amount9
		jsr	CarCome9
		jmp	XBatch10
XBatch9Right:	move.b	#27,$3a(a2)
		sub.w	#1,Amount9
		jsr	CarCome9
		jmp	XBatch10
XBatch9Left:	move.b	#28,$3a(a2)
		sub.w	#1,Amount9
		jsr	CarCome9
XBatch10:	lea.l	Sprite14(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	XBatch10.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch13
XBatch10.1:	cmp.w	#$00,Amount10
		beq	XBatch13
		jsr	GetRandom2
		cmp.l	T4(pc),d5	;if turns left
		bcs	XBatch10Right
		sub.l	T4(pc),d5
		cmp.l	T5(pc),d5	;if turns right
		bcs	XBatch10Left
XBatch10Stra:	move.b	#31,$3a(a2)
		sub.w	#1,Amount10
		jsr	CarCome10
		jmp	XBatch13
XBatch10Right:	move.b	#32,$3a(a2)
		sub.w	#1,Amount10
		jsr	CarCome10
		jmp	XBatch13
XBatch10Left:	move.b	#33,$3a(a2)
		sub.w	#1,Amount10
		jsr	CarCome10
XBatch13:	lea.l	Sprite20(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	XBatch13.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	XBatch14
XBatch13.1:	cmp.w	#$00,Amount13
		beq	XBatch14
		jsr	GetRandom2
		cmp.l	T28(pc),d5	;if turns left
		bcs	XBatch13Right
		sub.l	T28(pc),d5
		cmp.l	T29(pc),d5	;if turns right
		bcs	XBatch13Left
XBatch13Stra:	move.b	#34,$3a(a2)
		sub.w	#1,Amount13
		jsr	CarCome13
		jmp	XBatch14
XBatch13Right:	move.b	#35,$3a(a2)
		sub.w	#1,Amount13
		jsr	CarCome13
		jmp	XBatch14
XBatch13Left:	move.b	#36,$3a(a2)
		sub.w	#1,Amount13
		jsr	CarCome13
XBatch14:	lea.l	Sprite22(pc),a2
		cmp.l	#$00,$3a(a2)
		beq	XBatch14.1
		add.l	#$3e,a2
		cmp.l	#$00,$3a(a2)
		bne	XBatchOut
XBatch14.1:	cmp.w	#$00,Amount13
		beq	XBatchOut
		jsr	GetRandom2
		cmp.l	T37(pc),d5	;if turns left
		bcs	XBatch14Right
		sub.l	T37(pc),d5
		cmp.l	T38(pc),d5	;if turns right
		bcs	XBatch14Left
XBatch14Stra:	move.b	#34,$3a(a2)
		sub.w	#1,Amount14
		jsr	CarCome14
		jmp	XBatchOut
XBatch14Right:	move.b	#35,$3a(a2)
		sub.w	#1,Amount14
		jsr	CarCome14
		jmp	XBatchOut
XBatch14Left:	move.b	#36,$3a(a2)
		sub.w	#1,Amount14
		jsr	CarCome14
XBatchOut:	rts

InitCars:	lea.l	Sprite1(pc),a2
		lea.l	Sprite27(pc),a3
		add.l	#$3e,a3
InitCars1:	move.l	#$00,$3a(a2)	;Clear Current & Destination
		add.l	#$3e,a2
		cmp.l	a2,a3
		bne	InitCars1

;Batch 1

		lea.l	TLIntData(pc),a1
		lea.l	Sprite1(pc),a2
		move.w	DTJY(pc),$16(a2)
		move.w	J1XL(pc),$18(a2)
		move.l	$50(a1),$24(a2)

;Batch 2

		lea.l	Sprite4(pc),a2		;Sprite4
		move.w	DTJY(pc),$16(a2)
		move.w	J2XL(pc),$18(a2)
		move.l	$50(a1),$24(a2)

;Batch 3

		lea.l	Sprite7(pc),a2
		move.w	J1YT(pc),$16(a2)
		move.w	DRJX(pc),$18(a2)
		move.l	$58(a1),$24(a2)

;Batch 4

		lea.l	Sprite8(pc),a2
		move.w	J2YT(pc),$16(a2)
		move.w	DRJX(pc),$18(a2)
		move.l	$58(a1),$24(a2)

;Batch 5

		lea.l	Sprite9(pc),a2
		move.w	DBJY(pc),$16(a2)
		move.w	J2XR(pc),$18(a2)
		move.l	$4c(a1),$24(a2)

;Batch 6

		lea.l	Sprite10(pc),a2
		move.w	DBJY(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$4c(a1),$24(a2)

;Batch 7

		lea.l	Sprite11(pc),a2
		move.w	J2YB(pc),$16(a2)
		move.w	DLJX(pc),$18(a2)
		move.l	$54(a1),$24(a2)

;Batch 8

		lea.l	Sprite12(pc),a2
		move.w	J1YB(pc),$16(a2)
		move.w	DLJX(pc),$18(a2)
		move.l	$54(a1),$24(a2)

;Batch 9

		lea.l	Sprite13(pc),a2
		move.w	J1YT(pc),$16(a2)
		move.w	FRJX(pc),$18(a2)
		move.l	$58(a1),$24(a2)

;Batch 10

		lea.l	Sprite14(pc),a2
		move.w	J1YB(pc),$16(a2)
		move.w	FLJX(pc),$18(a2)
		move.l	$54(a1),$24(a2)
		lea.l	Sprite15(pc),a2
		move.w	J1YB(pc),$16(a2)
		move.w	FLJX(pc),$18(a2)
		move.l	$54(a1),$24(a2)

;Batch 11

		lea.l	Sprite16(pc),a2
		move.w	FBJY(pc),$16(a2)
		move.w	J2XR(pc),$18(a2)
		move.l	$4c(a1),$24(a2)
		lea.l	Sprite17(pc),a2
		move.w	FBJY(pc),$16(a2)
		move.w	J2XR(pc),$18(a2)
		move.l	$4c(a1),$24(a2)

;Batch 12

		lea.l	Sprite18(pc),a2
		move.w	FTJY(pc),$16(a2)
		move.w	J2XL(pc),$18(a2)
		move.l	$58(a1),$24(a2)
		lea.l	Sprite19(pc),a2
		move.w	FTJY(pc),$16(a2)
		move.w	J2XL(pc),$18(a2)
		move.l	$50(a1),$24(a2)

;Batch 13

		lea.l	Sprite20(pc),a2
		move.w	FLJX(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$54(a1),$24(a2)
		lea.l	Sprite21(pc),a2
		move.w	FLJX(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$54(a1),$24(a2)

;Batch 14

		lea.l	Sprite22(pc),a2
		move.w	FRJX(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$58(a1),$24(a2)
		lea.l	Sprite23(pc),a2
		move.w	FRJX(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$58(a1),$24(a2)

;Batch 15

		lea.l	Sprite24(pc),a2
		move.w	FTJY(pc),$16(a2)
		move.w	J1XL(pc),$18(a2)
		move.l	$50(a1),$24(a2)
		lea.l	Sprite25(pc),a2
		move.w	FTJY(pc),$16(a2)
		move.w	J1XL(pc),$18(a2)
		move.l	$50(a1),$24(a2)

;Batch 16

		lea.l	Sprite26(pc),a2
		move.w	FBJY(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$4c(a1),$24(a2)
		lea.l	Sprite27(pc),a2
		move.w	FBJY(pc),$16(a2)
		move.w	J1XR(pc),$18(a2)
		move.l	$4c(a1),$24(a2)


DrawSprites:	move.l	gfxbase(pc),a6
		lea.l	DummyHead(pc),a0
		lea.l	DummyTail(pc),a1
		lea.l	GelsInfo(pc),a2		
		move.l	RastPort1(pc),a3
		move.l	a2,$14(a3)
		jsr	InitGels(a6)

;Batch 1

		lea.l	Sprite1(pc),a0
		jsr	InitMasks(a6)

;Batch 2

		lea.l	Sprite4(pc),a0
		jsr	InitMasks(a6)

;Batch 3

		lea.l	Sprite7(pc),a0
		jsr	InitMasks(a6)

;Batch 4

		lea.l	Sprite8(pc),a0
		jsr	InitMasks(a6)
;Batch 5

		lea.l	Sprite9(pc),a0
		jsr	InitMasks(a6)

;Batch 6

		lea.l	Sprite10(pc),a0
		jsr	InitMasks(a6)
;Batch 7

		lea.l	Sprite11(pc),a0
		jsr	InitMasks(a6)

;Batch 8

		lea.l	Sprite12(pc),a0
		jsr	InitMasks(a6)

;Batch 9

		lea.l	Sprite13(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite13(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)

;Batch 10

		lea.l	Sprite14(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite14(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite15(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite15(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)

;Batch 11

		lea.l	Sprite16(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite16(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite17(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite17(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)

;Batch 12

		lea.l	Sprite18(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite18(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite19(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite19(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)

;Batch 13

;		lea.l	Sprite20(pc),a0
;		jsr	InitMasks(a6)
;		lea.l	Sprite20(pc),a0
;		move.l	RastPort1(pc),a1
;		jsr	AddVSprite(a6)
;		lea.l	Sprite21(pc),a0
;		jsr	InitMasks(a6)
;		lea.l	Sprite21(pc),a0
;		move.l	RastPort1(pc),a1
;		jsr	AddVSprite(a6)

;Batch 14

;		lea.l	Sprite22(pc),a0
;		jsr	InitMasks(a6)
;		lea.l	Sprite22(pc),a0
;		move.l	RastPort1(pc),a1
;		jsr	AddVSprite(a6)
;		lea.l	Sprite23(pc),a0
;		jsr	InitMasks(a6)
;		lea.l	Sprite23(pc),a0
;		move.l	RastPort1(pc),a1
;		jsr	AddVSprite(a6)

;Batch 15

		lea.l	Sprite24(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite24(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite25(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite25(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)

;Batch 16

		lea.l	Sprite26(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite26(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite27(pc),a0
		jsr	InitMasks(a6)
		lea.l	Sprite27(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)


;Add sprites 1, 2, 4, 5, 9, 10

		lea.l	Sprite1(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite4(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite9(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		lea.l	Sprite10(pc),a0
		move.l	RastPort1(pc),a1
		jsr	AddVSprite(a6)
		move.b	#$00,SpritesXOn

InitCars10:

;Might as well draw the sprites too ?

		move.l	RastPort1(pc),a1
		jsr	SortGList(a6)
		move.l	ViewPort(pc),a0
		move.l	RastPort1(pc),a1
		jsr	DrawGList(a6)

		move.l	intbase(pc),a6
		jsr	RethinkDisplay(a6)
		rts

MenuNull:	move.l	d3,d6			; 3         2         1
						;10987654321098765432109876543210
		ror.l	#5,d6			;%0000000000000000000000000011111,d6
		lsr.l	#8,d6			;%0000000000000000000000000011111,d6
		lsr.l	#8,d6
		lsr.l	#8,d6
		lsr.l	#3,d6

		move.l	d3,d5

		ror.l	#5,d5			;%0000000000000000000011111100000,d5
		ror.l	#6,d5			;%0000000000000000000000000111111,d5
		lsr.l	#8,d5
		lsr.l	#8,d5
		lsr.l	#8,d5
		lsr.l	#2,d5
						;SubItems
		move.l	#$00,d4
		move.w	d3,d4
		lsr.l	#5,d4			;%0000000000000001111100000000000,d4
		lsr.l	#6,d4			;%0000000000000000000000000011111,d5
		rts

Check2IDCMP:	move.l	$4,a6			;made this a SubRoutine...
		move.l	$56(a0),a2		;Give it the window structure in a0
		move.l	#0,d1
		move.b	$0f(a2),d1
		move.l	#0,d0
		bset.l	d1,d0
		jsr	Wait(a6)	
	
Get2Msg1:	move.l	a2,a0	
		jsr	GetMsg(a6)
		tst.l	d0
		beq	Get2Msg2
	
		move.l	d0,a1 
		move.l	$14(a1),d2		;answers with Class in d2,
		move.w	$18(a1),d3		;Code in d3 and
		move.w	$1a(a1),a4		;Qualifier in a4
		move.l	$1c(a1),a5		;IAddress in a5
		jsr	ReplyMsg(a6)
		jmp	Get2Msg1
Get2Msg2:	move.l	#-1,d0
		rts


Window2IDCMP:	move.l	Window2(pc),a0
		jsr	Check2IDCMP
PE.01:		cmp.l	#MENUPICK,d2
		beq	DoWin2Menus
		cmp.l	#RAWKEY,d2
		beq	Window2Keys
		jmp	Window2IDCMP

Window2Keys:	cmp.w	#$5f,d3
		bne	Window2Keys0
		jsr	Help
Window2Keys0:	jmp	Window2IDCMP
DoWin2Menus:	jsr	MenuNull
		cmp.l	#$01,d6		;Change this if you want more menus
;		beq	
		cmp.l	#$00,d6
		bne	IsMenu1.1

		cmp.l	#$00,d5
		beq	New
IsMenu1.0:	cmp.l	#$01,d5
		bne	IsMenu1.01
		jsr	Help
		jmp	MainLoop
IsMenu1.01:	cmp.l	#$02,d5
		bne	IsMenu1.02
		jsr	Load
		jmp	MainLoop
IsMenu1.02:	cmp.l	#$04,d5
		bne	IsMenu1.03
		jsr	SaveAs
		jmp	MainLoop
IsMenu1.03:	cmp.l	#$05,d5
		bne	IsMenu1.04
		jsr	About
IsMenu1.04:	cmp.l	#$06,d5
		beq	QuittingReq
IsMenu1.1	jmp	MainLoop

Help:		move.l	Window2(pc),a0
		move.l	#%100000,d0
		jsr	MenusOff
		lea.l	NewHelpWin1(pc),a0
		move.l	intbase(pc),a6
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	Help1
		lea.l	NoHelpWin1(pc),a0
		jmp	ShowGuru
Help1:		move.l	d0,HelpWin1
		move.l	HelpWin1,a1
		move.l	$32(a1),a0
		lea.l	Help1Txt1,a1
		move.w	#$10,d0
		move.w	#$10,d1
		jsr	PrintIText(a6)
		move.w	#$00,HelpStatus
;		move.l	Screen1,a0
;		jsr	DisplayBeep(a6)
HelpWin1IDCMP:	move.l	HelpWin1(pc),a0
		jsr	Check2IDCMP

		cmp.l	#GADGETUP,d2
		beq	HelpWin1IDCMP2
		cmp.l	#CLOSEWINDOW,d2
		beq	HelpWin1IDCMP2
		cmp.l	#VANILLAKEY,d2
		bne	HelpWin1IDCMP
		cmp.w	#$1b,d3
		beq	HelpWin1IDCMP2
		cmp.w	#"y",d3
		beq	HelpWin1IDCMP3
		cmp.w	#"Y",d3
		beq	HelpWin1IDCMP3
		cmp.w	#"n",d3
		beq	HelpWin1IDCMP2
		cmp.w	#"N",d3
		beq	HelpWin1IDCMP2
		jmp	HelpWin1IDCMP
		
HelpWin1IDCMP1:	cmp.w	#$2,$26(a5)
		beq	HelpWin1IDCMP2
		cmp.w	#$3,$26(a5)
		bne	HelpWin1IDCMP
HelpWin1IDCMP2:	move.l	Window2(pc),a0
		move.l	#%100000,d0
		jsr	MenusOn
		move.l	HelpWin1(pc),a0
		jsr	ClearMSGs
		move.l	#0,HelpWin1
		rts		

HelpWin1IDCMP3:	move.l	HelpWin1(pc),a0
		jsr	ClearMSGs
		move.l	#0,HelpWin1

		lea.l	NewHelpWin1(pc),a0
		move.l	intbase(pc),a6
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	HW3
		lea.l	NoHelpWin1(pc),a0
		jmp	ShowGuru
	
HW3:		move.l	d0,HelpWin1
		move.l	d0,a0
		move.l	$32(a0),a0
		cmp.w	#$01,HelpStatus
		beq	HW1I4
		move.w	#$01,HelpStatus
		lea.l	Help2Txt1,a1
		move.w	#$10,d0
		move.w	#$10,d1
		jsr	PrintIText(a6)
		jmp	HelpWin1IDCMP1
HW1I4:		move.w	#$00,HelpStatus
		lea.l	Help3Txt1,a1
		move.w	#$10,d0
		move.w	#$10,d1
		jsr	PrintIText(a6)
		jmp	HelpWin1IDCMP1

Load:		move.l	Window2(pc),a0
		move.l	#%1000000,d0
		jsr	MenusOff
		lea.l	LWWin1Name(pc),a5
		jsr	FReq
		tst.l	d0
		beq	LoadOut
;		move.l	dosbase(pc),a6
;		move.l	#MODE_OLDFILE,d2
;		move.l	d0,d1
;		jsr	Open(a6)
;		move.l	d0,DiskFile1
;		move.l	dosbase(pc),a6
;		move.l	DiskFile1(pc),d1
;		jsr	Close(a6)
LoadOut:	move.l	Window2(pc),a0
		move.l	#%1000000,d0
		jsr	MenusOn	
		rts
	
SaveAs:		move.l	Window2(pc),a0
		move.l	#%10000000,d0
		jsr	MenusOff
		lea.l	SWWin1Name(pc),a5
		jsr	FReq
		tst.l	d0
		beq	SaveAsOut
SaveAsOut:	move.l	Window2(pc),a0
		move.l	#%10000000,d0
		jsr	MenusOn
		rts

ColorLights:	move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#5,d0
		jsr	SetAPen(a6)

		move.l	#1,d2
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#16,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#16,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#64,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#92,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#43,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#64,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#92,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#43,d1
		jsr	Flood(a6)

		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#6,d0
		jsr	SetAPen(a6)

		move.l	RastPort1(pc),a1
		move.l	#116,d0
		move.l	#16,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#374,d0
		move.l	#16,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#47,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#374,d0
		move.l	#64,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#284,d0
		move.l	#92,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#60,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#284,d0
		move.l	#43,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#47,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#116,d0
		move.l	#64,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#24,d0
		move.l	#92,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#60,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#24,d0
		move.l	#43,d1
		jsr	Flood(a6)

		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#4,d0
		jsr	SetAPen(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#51,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#56,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#51,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#56,d1
		jsr	Flood(a6)
;	
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#7,d0
		jsr	SetAPen(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#16,d1
		move.l	#1,d2
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#16,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#43,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#368,d0
		move.l	#92,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#290,d0
		move.l	#64,d1
		jsr	Flood(a6)
		
		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#43,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#110,d0
		move.l	#92,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#30,d0
		move.l	#64,d1
		jsr	Flood(a6)
;
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		move.l	#3,d0
		jsr	SetAPen(a6)

		move.l	RastPort1(pc),a1
		move.l	#122,d0
		move.l	#16,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#380,d0
		move.l	#16,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#380,d0
		move.l	#64,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#278,d0
		move.l	#92,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#278,d0
		move.l	#43,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#122,d0
		move.l	#64,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#18,d0
		move.l	#92,d1
		jsr	Flood(a6)

		move.l	RastPort1(pc),a1
		move.l	#18,d0
		move.l	#43,d1
		jsr	Flood(a6)
		move.l	ViewPort(pc),a0
		rts

About:		move.l	Window2(pc),a0
		move.l	#%10100000,d0
		jsr	MenusOff
		lea.l	NewAbWindow1(pc),a0
		move.l	intbase(pc),a6
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	About1
		lea.l	NoAbWin1(pc),a0
		jmp	ShowGuru
About1:		move.l	d0,AbWin1

		move.l	d0,a0
		move.l	$32(a0),AbRP

		move.l	gfxbase(pc),a6		;Black Background
		move.l	AbRP(pc),a1
		move.l	#$02,d0
		jsr	SetRast(a6)

		move.l	intbase(pc),a6		;Draw Gads again
		move.l	AbWin1(pc),a1
		lea.l	MGad1(pc),a0
		move.l	#$00,a2
		move.l	#-1,d0
		jsr	RefreshGList(a6)

		move.l	AbRP(pc),a0		;Border
		lea.l	AbBorder1(pc),a1
		move.l	#$00,d0
		move.l	#$00,d1
		jsr	DrawBorder(a6)

		move.l	AbRP(pc),a0		;Texts
		lea.l	AboutTxt1(pc),a1
		move.l	#$00,d0
		move.l	d0,d1
		jsr	PrintIText(a6)

About2:		move.l	AbWin1(pc),a0
		jsr	Check2IDCMP
		cmp.l	#GADGETUP,d2
		beq	AboutOut
		cmp.l	#VANILLAKEY,d2
		beq	AboutKeys
		jmp	About2

AboutKeys:	cmp.w	#$1b,d3
		beq	AboutOut
		cmp.w	#"y",d3
		beq	AboutOut
		cmp.w	#"Y",d3
		beq	AboutOut
		cmp.w	#"n",d3
		beq	AboutOut
		cmp.w	#"N",d3
		beq	AboutOut
		jmp	About2

AboutOut:	move.l	AbWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$0,AbWin1
		move.l	Window2(pc),a0
		move.l	#%10100000,d0
		jsr	MenusOn
		rts
		
FReq:		move.l	a5,FRTitle
		move.l	reqbase(pc),a6
		lea.l	FileRequest1(pc),a0
		jsr	FileRequester(a6)
		tst.l	0
		bne	FreqOut
FreqOut:	rts

QuittingReq:	move.l	Window2(pc),a0
		move.l	#%11100000,d0
		jsr	MenusOff
		lea.l	NewQuitWin1(pc),a0
		move.l	intbase(pc),a6
		jsr	OpenWindow(a6)
		tst.l	d0
		bne	QuittingReq1
		lea.l	NoQuitWin1(pc),a0
		jmp	ErrorPrint
QuittingReq1:	move.l	d0,QuitWin1
		move.l	QuitWin1,a1
		move.l	$32(a1),a0
		lea.l	QuitWin1Txt1,a1
		move.w	#$10,d0
		move.w	#$10,d1
		jsr	PrintIText(a6)
		move.l	Screen1,a0
		jsr	DisplayBeep(a6)
		jsr	Wait.05Sec
		move.l	Screen1,a0
		jsr	DisplayBeep(a6)
		jsr	Wait.05Sec
		move.l	Screen1,a0
		jsr	DisplayBeep(a6)
QuitWin1IDCMP:	move.l	QuitWin1(pc),a0
		jsr	Check2IDCMP

		cmp.l	#GADGETUP,d2
		beq	QuitWin1IDCMP1
		cmp.l	#VANILLAKEY,d2
		bne	QuitWin1IDCMP
		cmp.w	#$1b,d3
		beq	QuitWin1IDCMP2
		cmp.w	#"y",d3
		beq	ShutDown
		cmp.w	#"Y",d3
		beq	ShutDown
		cmp.w	#"n",d3
		beq	QuitWin1IDCMP2
		cmp.w	#"N",d3
		beq	QuitWin1IDCMP2
		jmp	QuitWin1IDCMP
		
QuitWin1IDCMP1:	cmp.w	#$2,$26(a5)
		beq	ShutDown
		cmp.w	#$3,$26(a5)
		bne	QuitWin1IDCMP
QuitWin1IDCMP2:	move.l	Window2(pc),a0
		lea.l	Menu1(pc),a1
		move.l	#%11100000,d0
		jsr	MenusOn
		move.l	QuitWin1(pc),a0
		jsr	ClearMSGs
		move.l	#0,QuitWin1
		jmp	MainLoop

CheckIDCMP:	move.l	$4,a6			;made this a SubRoutine...
		move.l	$56(a0),a2
		move.l	a2,a0
		jsr	GetMsg(a6)
		tst.l	d0
		bne	GetMsg1.1
		move.l	$56(a3),a3
		move.l	a3,a0
		jsr	GetMsg(a6)
		tst.l	d0
		bne	GetMsg1.1
		move.l	$56(a4),a4
		move.l	a4,a0
		jsr	GetMsg(a6)
		tst.l	d0
		bne	GetMsg1.1
		move.l	#0,d1
		move.b	$0f(a2),d1
		bset.l	d1,d0
		move.l	#0,d2
		move.b	$0f(a3),d2
		bset.l	d2,d0
		move.l	#0,d3
		move.b	$0f(a4),d3
		bset.l	d3,d0
CheckIDCMP3:	jsr	Wait(a6)	
	
GetMsg1:	move.l	a2,a0	
		jsr	GetMsg(a6)
		tst.l	d0
		bne	GetMsg1.1
		move.l	a3,a0
		jsr	GetMsg(a6)
		tst.l	d0
		bne	GetMsg1.1
		move.l	a4,a0
		jsr	GetMsg(a6)
		tst.l	d0
		beq	GetMsg2
	
GetMsg1.1:	move.l	d0,a1 
		move.l	$14(a1),d2		;answers with Class in d2,
		move.w	$18(a1),d3		;Code in d3 and
		move.w	$1a(a1),a4		;Qualifier in a4
		move.l	$1c(a1),a5		;IAddress in a5
		jsr	ReplyMsg(a6)
GetMsg2:	move.l	#-1,d0
		rts

Wait.05Sec:	move.l	a6,a5
		move.l	dosbase(pc),a6
		move.l	#1,d1
		jsr	Delay(a6)
		move.l	a5,a6
		rts	
	
MenusOn:	move.l	intbase(pc),a6		;Menu number in d0
		jsr	OnMenu(a6)		;Window in a0
		rts
MenusOff:	move.l	intbase(pc),a6		;Window in a0
		jsr	OffMenu(a6)
		rts

ClearMSGs:	move.l	a0,d0
		tst.l	d0
		beq	ClearMsg3
		move.l	a0,a3
		move.l	$4,a6			;made this a SubRoutine...
		jsr	Forbid(a6)
		move.l	$56(a3),a2		;Give it the window structure in a0
ClearMsg1:	move.l	a2,a0	
		jsr	GetMsg(a6)
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1 
		jsr	ReplyMsg(a6)
		jmp	ClearMsg1
ClearMsg2:	move.l	a3,a0
		move.l	intbase(pc),a6
		jsr	CloseWindow(a6)
		move.l	$4,a6
		jsr	Permit(a6)
ClearMsg3:	rts

ShutDown:	move.l	$4,a6
		tst.l	TPort
		beq	ShutDown104
		move.l	TPort(pc),a1
		jsr	RemPort(a6)
		move.l	#$22,d0
		move.l	TPort(pc),a1
		jsr	FreeMem(a6)
		move.l	TimeReq(pc),a1
		jsr	CloseDevice(a6)
ShutDown104:	tst.b	TSigBit
		beq	ShutDown103
		move.l	#$00,d0
		move.b	TSigBit,d0
		jsr	FreeSignal(a6)
ShutDown103:	tst.l	TimeReq
		beq	ShutDown102
		move.l	#$28,d0
		move.l	TimeReq(pc),a1
		jsr	FreeMem(a6)

ShutDown102:	move.l	OurTask(pc),a0
		move.l	OldTaskWinPtr(pc),$b8(a0)

		move.l	Window3(pc),a0
		beq	ShutDown102.1
		move.l	intbase(pc),a6
		jsr	ClearMenuStrip(a6)
		move.l	Window3(pc),a0
		jsr	ClearMSGs
		move.l	#$00,HelpWin1

ShutDown102.1:	move.l	HelpWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$00,HelpWin1

		move.l	AbWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$0,AbWin1

		move.l	FRWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$0,FRWin1

ShutDown101.1:	move.l	$4,a6
		tst.l	TmpRas
		beq	ShutDown101.2
		move.l	TmpRas(pc),a1
		move.l	#TmpRas_Size,d0
		jsr	FreeMem(a6)	
ShutDown101.2:	tst.l	VecTab1
		beq	ShutDown100
		move.l	$4,a6
		move.l	VecTab1(pc),a1
		move.l	#VecTab_Size,d0
		jsr	FreeMem(a6)	

ShutDown100:
ShutDown100.1:	move.l	QuitWin1(pc),a0
		jsr	ClearMSGs
		move.l	#$0,QuitWin1
		
		tst.l	Window1
		beq	ShutDown99
		move.l	Window1(pc),a0
		jsr	ClearMSGs
		move.l	#$0,Window1

ShutDown99:	tst.l	Window2
		beq	ShutDown98
		move.l	Window2(pc),a0
		move.l	intbase(pc),a6
		jsr	ClearMenuStrip(a6)
		move.l	Window2(pc),a0
		jsr	ClearMSGs
		move.l	#$0,Window2	

ShutDown98:	tst.l	Screen1
		beq	ShutDown97
		move.l	Screen1(pc),a0
		move.l	intbase(pc),a6
		jsr	CloseScreen(a6)
		move.l	#$0,Screen1

ShutDown97:	tst.l	reqbase
		beq	ShutDown96
		lea.l	FileRequest1(pc),a0
		move.l	reqbase,a6
		jsr	PurgeFiles(a6)
		move.l  $4,a6
		move.l	reqbase(pc),a1
		jsr	CloseLibrary(a6)

ShutDown96:	
ShutDown_END:	clr.l	d0
		rts

;Interrupt for handling car movements

TLIntCode:	movem.l	d2-d7/a2-a6,-(sp)
		move.l	$8(a1),a5		;Get screen pointer
		move.w	$8(a5),a6		;Get screenX
		move.w	$a(a5),a5		;Get screenY

		move.w	ScrOldX(pc),a0
		move.w	a6,ScrOldX
		sub.w	a0,a6
		move.w	a6,XOffSet

		move.w	ScrOldY(pc),a0
		move.w	a5,ScrOldY
		sub.w	a0,a5
		move.w	a5,YOffSet

		move.w	XOffSet(pc),d0
		move.w	YOffSet(pc),d1
		add.w	d0,DLJX
		add.w	d0,DRJX
		add.w	d0,FRJX
		add.w	d0,FLJX
		add.w	d0,J1XL
		add.w	d0,J1XR
		add.w	d0,J2XL
		add.w	d0,J2XR
		add.w	d1,DTJY
		add.w	d1,FTJY
		add.w	d1,FBJY
		add.w	d1,DBJY
		add.w	d1,J1YT
		add.w	d1,J1YB
		add.w	d1,J2YT
		add.w	d1,J2YB
		move.l	(a1),a0			;Get Sprite1
AdSOfS:		add.w	d0,$18(a0)		;Add X - this keeps sprites
		add.w	d1,$16(a0)		;Add Y - in the right place
		add.l	#$3e,a0
		move.l	$4(a1),a3
		add.l	#$3e,a3
		cmp.l	a0,a3
		bne	AdSOfS
		move.l	(a1),a0

TLIntCode2:	cmp.l	#$00,$3a(a0)
		bne	MoveSprites
TLIntCode3:	add.l	#$3e,a0
		move.l	$4(a1),a3
		add.l	#$3e,a3
		cmp.l	a0,a3
		bne	TLIntCode2
		move.l	gfxbase(pc),a6
		move.l	RastPort1(pc),a1
		jsr	SortGList(a6)
		movem.l	(sp)+,d2-d7/a2-a6
		move.l	#1,d0
		rts

MoveSprites:	cmp.b	#1,$3a(a0)
		beq	M1
		cmp.b	#2,$3a(a0)
		beq	M2
		cmp.b	#3,$3a(a0)
		beq	M3
		cmp.b	#4,$3a(a0)
		beq	M4
		cmp.b	#5,$3a(a0)
		beq	M5
		cmp.b	#6,$3a(a0)
		beq	M6
		cmp.b	#7,$3a(a0)
		beq	M7
		cmp.b	#8,$3a(a0)
		beq	M8
		cmp.b	#9,$3a(a0)
		beq	M9
		cmp.b	#10,$3a(a0)
		beq	M10
		cmp.b	#11,$3a(a0)
		beq	M11
		cmp.b	#12,$3a(a0)
		beq	M12
		cmp.b	#13,$3a(a0)
		beq	M13
		cmp.b	#14,$3a(a0)
		beq	M14
		cmp.b	#15,$3a(a0)
		beq	M15
		cmp.b	#16,$3a(a0)
		beq	M16
		cmp.b	#17,$3a(a0)
		beq	M17
		cmp.b	#18,$3a(a0)
		beq	M18
		cmp.b	#19,$3a(a0)
		beq	M19
		cmp.b	#20,$3a(a0)
		beq	M20
		cmp.b	#21,$3a(a0)
		beq	M21
		cmp.b	#22,$3a(a0)
		beq	M22
		cmp.b	#23,$3a(a0)
		beq	M23
		cmp.b	#24,$3a(a0)
		beq	M24
		cmp.b	#43,$3a(a0)
		beq	M43
		cmp.b	#44,$3a(a0)
		beq	M44
		cmp.b	#45,$3a(a0)
		beq	M45
		cmp.b	#46,$3a(a0)
		beq	M46
		cmp.b	#47,$3a(a0)
		beq	M47
		cmp.b	#48,$3a(a0)
		beq	M48
		cmp.b	#37,$3a(a0)
		beq	M37
		cmp.b	#38,$3a(a0)
		beq	M38
		cmp.b	#39,$3a(a0)
		beq	M39
		jmp	TLIntCode3

M1:		move.w	$16(a0),d0
		cmp.w	FTJY(pc),d0
		bcc	M1.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M1.1:		add.w   #$01,Amount15
		movem.l	a0-a1,-(sp)
		jsr	CarCome15
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M2:		move.w	$16(a0),d0
		cmp.w	J1YT(pc),d0
		beq	M2.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M2.1:		move.l	$58(a1),$24(a0)
		move.w	DLJX(pc),d0
		cmp.w	$18(a0),d0
		beq     M2.2
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M2.2:           jmp	ResetSprite

M3:		move.w	$16(a0),d0
		cmp.w	J1YB(pc),d0
		beq	M3.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M3.1:		move.l	$54(a1),$24(a0)
		move.w	FLJX(pc),d0
		cmp.w	$18(a0),d0
		bcc	M3.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M3.2:		add.w	#$01,Amount10
		movem.l	a0-a1,-(sp)
		jsr	CarCome10
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M4:		move.w	$16(a0),d0
		cmp.w	FTJY(pc),d0
		beq	M4.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M4.1:		add.w   #$01,Amount11
		movem.l	a0-a1,-(sp)
		jsr	CarCome11
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M5:		move.w	$16(a0),d0
		cmp.w	J1YT(pc),d0
		beq	M5.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M5.1:		move.l	$58(a1),$24(a0)
		move.w	FRJX(pc),d0
		cmp.w	$18(a0),d0
		bcc	M5.2
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M5.2:		add.w	#$01,Amount9
		movem.l	a0-a1,-(sp)
		jsr	CarCome9
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite
M6:		move.w	$16(a0),d0
		cmp.w	J1YB(pc),d0
		bcc	M6.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M6.1:		move.l	$54(a1),$24(a0)
		move.w	DRJX(pc),d0
		cmp.w	$18(a0),d0
		bcs	M6.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M6.2:		jmp	ResetSprite


M7:		move.w	$16(a0),d0
		cmp.w	FBJY(pc),d0
		bcs	M7.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M7.1:		add.w   #$01,Amount12
		movem.l	a0-a1,-(sp)
		jsr	CarCome12
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M8:		move.w	$16(a0),d0
		cmp.w	J2YT(pc),d0
		beq	M8.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M8.1:		move.l	$58(a1),$24(a0)
		move.w	FRJX(pc),d0
		cmp.w	$18(a0),d0
		bcc	M8.2
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M8.2:		add.w	#$01,Amount14
		movem.l	a0-a1,-(sp)
		jsr	CarCome14
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite
M9:		move.w	$16(a0),d0
		cmp.w	J2YB(pc),d0
		beq	M9.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M9.1:		move.l	$54(a1),$24(a0)
		move.w	DRJX(pc),d0
		cmp.w	$18(a0),d0
		bcs	M9.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M9.2:		jmp	ResetSprite

M10:		move.w	$16(a0),d0
		cmp.w	FBJY(pc),d0
		beq	M10.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M10.1:		add.w   #$01,Amount16
		movem.l	a0-a1,-(sp)
		jsr	CarCome16
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M11:		move.w	$16(a0),d0
		cmp.w	J2YT(pc),d0
		beq	M11.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M11.1:		move.l	$58(a1),$24(a0)
		move.w	DLJX(pc),d0
		cmp.w	$18(a0),d0
		bcc	M11.2
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M11.2:		jmp	ResetSprite

M12:		move.w	$16(a0),d0
		cmp.w	J2YB(pc),d0
		beq	M12.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M12.1:		move.l	$54(a1),$24(a0)
		move.w	FLJX(pc),d0
		cmp.w	$18(a0),d0
		bcs	M12.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M12.2:		add.w	#$01,Amount13
		movem.l	a0-a1,-(sp)
		jsr	CarCome13
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M13:		move.w	$16(a0),d0
		cmp.w	DTJY(pc),d0
		beq	M13.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M13.1:		jmp	ResetSprite

M14:		move.w	$16(a0),d0
		cmp.w	J1YT(pc),d0
		beq	M14.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M14.1:		move.l	$58(a1),$24(a0)
		move.w	DLJX(pc),d0
		cmp.w	$18(a0),d0
		beq	M14.2
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M14.2:		jmp	ResetSprite

M15:		move.w	$16(a0),d0
		cmp.w	J1YB(pc),d0
		beq	M15.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M15.1:		move.l	$54(a1),$24(a0)
		move.w	FLJX(pc),d0
		cmp.w	$18(a0),d0
		bcs	M15.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M15.2:		add.w	#$01,Amount10
		movem.l	a0-a1,-(sp)
		jsr	CarCome10
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M16:		move.l	$4c(a1),$24(a0)
		move.w	$16(a0),d0
		cmp.w	DTJY(pc),d0
		beq	M16.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M16.1:		jmp	ResetSprite

M17:		move.w	$16(a0),d0
		cmp.w	J1YT(pc),d0
		beq	M17.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M17.1:		move.l	$58(a1),$24(a0)
		move.w	FRJX(pc),d0
		cmp.w	$18(a0),d0
		bcc	M17.2
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M17.2:		add.w	#$01,Amount9
		movem.l	a0-a1,-(sp)
		jsr	CarCome9
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M18:		move.w	$16(a0),d0
		cmp.w	J1YB(pc),d0
		beq	M18.1
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M18.1:		move.l	$54(a1),$24(a0)
		move.w	DRJX(pc),d0
		cmp.w	$18(a0),d0
		beq	M18.2
		add.w	#$01,$18(a0)		
		jmp	TLIntCode3
M18.2:		jmp	ResetSprite

M19:		move.w	$16(a0),d0
		cmp.w	DBJY(pc),d0
		beq	M19.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M19.1:		jmp	ResetSprite

M20:		move.w	$16(a0),d0
		cmp.w	J2YT(pc),d0
		beq	M20.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M20.1:		move.l	$58(a1),$24(a0)
		move.w	DLJX(pc),d0
		cmp.w	$18(a0),d0
		beq     M20.2
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M20.2:          jmp	ResetSprite

M21:		move.w	$16(a0),d0
		cmp.w	J2YB(pc),d0
		beq	M21.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M21.1:		move.l	$54(a1),$24(a0)
		move.w	FLJX(pc),d0
		cmp.w	$18(a0),d0
		bcs	M21.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M21.2:		add.w	#$01,Amount10
		movem.l	a0-a1,-(sp)
		jsr	CarCome10
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite


M22:		move.l	$50(a1),$24(a0)
		move.w	$16(a0),d0
		cmp.w	DBJY(pc),d0
		beq	M22.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M22.1:		jmp	ResetSprite

M23:		move.w	$16(a0),d0
		cmp.w	J2YT(pc),d0
		beq	M23.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M23.1:		move.l	$58(a1),$24(a0)
		move.w	FRJX(pc),d0
		cmp.w	$18(a0),d0
		bcc	M23.2
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M23.2:		add.w	#$01,Amount14
		movem.l	a0-a1,-(sp)
		jsr	CarCome14
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M24:		move.w	$16(a0),d0
		cmp.w	J2YB(pc),d0
		beq	M24.1
		add.w	#$01,$16(a0)
		jmp	TLIntCode3
M24.1:		move.l	$54(a1),$24(a0)
		move.w	DRJX(pc),d0
		cmp.w	$18(a0),d0
		bcs	M24.2
		add.w	#$03,$18(a0)		
		jmp	TLIntCode3
M24.2:		jmp	ResetSprite


;Xbatches

M43:		move.w	$18(a0),d0
		cmp.w	FRJX(pc),d0
		bcs	M43.1
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M43.1:		add.w   #$01,Amount9
		movem.l	a0-a1,-(sp)
		jsr	CarCome9
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M44:		move.w	$18(a0),d0
		cmp.w	J2XR(pc),d0
		beq	M44.1
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M44.1:		move.l	$4c(a1),$24(a0)
		move.w	DTJY(pc),d0
		cmp.w	$16(a0),d0
		beq     M44.2
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M44.2:		jmp	ResetSprite

M45:		move.w	$18(a0),d0
		cmp.w	J2XL(pc),d0
		beq	M45.1
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M45.1:		move.l	$50(a1),$24(a0)
		move.w	FTJY(pc),d0
		cmp.w	$16(a0),d0
		beq	M45.2
		add.w	#$01,$16(a0)		
		jmp	TLIntCode3
M45.2:		add.w	#$01,Amount11
		movem.l	a0-a1,-(sp)
		jsr	CarCome11
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite


M46:		move.w	$18(a0),d0
		cmp.w	FRJX(pc),d0
		bcs	M46.1
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M46.1:		add.w   #$01,Amount14
		movem.l	a0-a1,-(sp)
		jsr	CarCome14
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M47:		move.w	$18(a0),d0
		cmp.w	J2XR(pc),d0
		beq	M47.1
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M47.1:		move.l	$4c(a1),$24(a0)
		move.w	FTJY(pc),d0
		cmp.w	$16(a0),d0
		beq     M47.2
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M47.2:		add.w	#$01,Amount12
		movem.l	a0-a1,-(sp)
		jsr	CarCome12
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M48:		move.w	$18(a0),d0
		cmp.w	J2XL(pc),d0
		beq	M48.1
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M48.1:		move.l	$50(a1),$24(a0)
		move.w	DBJY(pc),d0
		cmp.w	$16(a0),d0
		bcc	M48.2
		add.w	#$03,$16(a0)		
		jmp	TLIntCode3
M48.2:		jmp	ResetSprite

M37:		move.w	$18(a0),d0
		cmp.w	DLJX(pc),d0
		bcs	M37.1
		sub.w	#$03,$18(a0)
		jmp	TLIntCode3
M37.1:		add.w   #$01,Amount14
		movem.l	a0-a1,-(sp)
		jsr	CarCome14
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite

M38:		move.w	$18(a0),d0
		cmp.w	J1XR(pc),d0
		beq	M38.1
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M38.1:		move.l	$4c(a1),$24(a0)
		move.w	DTJY(pc),d0
		cmp.w	$16(a0),d0
		beq     M38.2
		sub.w	#$01,$16(a0)
		jmp	TLIntCode3
M38.2:		jmp	ResetSprite

M39:		move.w	$18(a0),d0
		cmp.w	J1XL(pc),d0
		beq	M39.1
		sub.w	#$01,$18(a0)
		jmp	TLIntCode3
M39.1:		move.l	$50(a1),$24(a0)
		move.w	FTJY(pc),d0
		cmp.w	$16(a0),d0
		beq	M39.2
		add.w	#$01,$16(a0)		
		jmp	TLIntCode3
M39.2:		add.w	#$01,Amount15
		movem.l	a0-a1,-(sp)
		jsr	CarCome15
		movem.l	(sp)+,a0-a1
		jmp	ResetSprite



ResetSprite:	move.l	#$00,$3a(a0)		;Clears Curr&Dest
		move.l	a0,d0			;Compare with batches
		cmp.l	$c(a1),d0		;so we can reset
		bls	Batch1			;the correct things
		cmp.l	$10(a1),d0		;like SprImg and
		bls	Batch2			;SprY,X              
		cmp.l	$14(a1),d0
		bls	Batch3
		cmp.l	$18(a1),d0
		bls	Batch4
		cmp.l	$1c(a1),d0
		bls	Batch5
		cmp.l	$20(a1),d0
		bls	Batch6
		cmp.l	$24(a1),d0
		bls	Batch7
		cmp.l	$28(a1),d0
		bls	Batch8
		cmp.l	$2c(a1),d0
		bls	Batch9
		cmp.l	$30(a1),d0
		bls	Batch10
		cmp.l	$34(a1),d0
		bls	Batch11
		cmp.l	$38(a1),d0
		bls	Batch12
		cmp.l	$3c(a1),d0
		bls	Batch13
		cmp.l	$40(a1),d0
		bls	Batch14
		cmp.l	$44(a1),d0
		bls	Batch15
		cmp.l	$48(a1),d0
		bls	Batch16
		jmp	TLIntCode3
Batch16:	move.l	$4c(a1),$24(a0)
		move.w	FBJY(pc),$16(a0)
		move.w	J1XR(pc),$18(a0)
		jmp	TLIntCode3
Batch15:	move.l	$50(a1),$24(a0)
		move.w	FTJY(pc),$16(a0)
		move.w	J1XL(pc),$18(a0)
		jmp	TLIntCode3
Batch14:	move.l	$58(a1),$24(a0)
		move.w	J2YT(pc),$16(a0)
		move.w	FRJX(pc),$18(a0)
		jmp	TLIntCode3
Batch13:	move.l	$54(a1),$24(a0)
		move.w	J2YB(pc),$16(a0)
		move.w	FLJX(pc),$18(a0)
		jmp	TLIntCode3
Batch12:	move.l	$50(a1),$24(a0)
		move.w	FTJY(pc),$16(a0)
		move.w	J2XL(pc),$18(a0)
		jmp	TLIntCode3
Batch11:	move.l	$4c(a1),$24(a0)
		move.w	FBJY(pc),$16(a0)
		move.w	J2XR(pc),$18(a0)
		jmp	TLIntCode3
Batch10:	move.l	$54(a1),$24(a0)
		move.w	J1YB(pc),$16(a0)
		move.w	FLJX(pc),$18(a0)
		jmp	TLIntCode3
Batch9:		move.l	$58(a1),$24(a0)
		move.w	J1YT(pc),$16(a0)
		move.w	FRJX(pc),$18(a0)
		jmp	TLIntCode3
Batch8:		move.l	$54(a1),$24(a0)
		move.w	J1YB(pc),$16(a0)
		move.w	DLJX(pc),$18(a0)
		jmp	TLIntCode3
Batch7:		move.l	$54(a1),$24(a0)
		move.w	J2YB(pc),$16(a0)
		move.w	DLJX(pc),$18(a0)
		jmp	TLIntCode3
Batch6:		move.l	$4c(a1),$24(a0)
		move.w	DBJY(pc),$16(a0)
		move.w	J1XR(pc),$18(a0)
		jmp	TLIntCode3
Batch5:		move.l	$4c(a1),$24(a0)
		move.w	DBJY(pc),$16(a0)
		move.w	J2XR(pc),$18(a0)
		jmp	TLIntCode3
Batch4:		move.l	$58(a1),$24(a0)
		move.w	J2YT(pc),$16(a0)
		move.w	DRJX(pc),$18(a0)
		jmp	TLIntCode3
Batch3:		move.l	$58(a1),$24(a0)
		move.w	J1YT(pc),$16(a0)
		move.w	DRJX(pc),$18(a0)
		jmp	TLIntCode3
Batch2:		move.l	$50(a1),$24(a0)
		move.w	DTJY(pc),$16(a0)
		move.w	J2XL(pc),$18(a0)
		jmp	TLIntCode3
Batch1:		move.l	$50(a1),$24(a0)
		move.w	DTJY(pc),$16(a0)
		move.w	J1XL(pc),$18(a0)
		jmp	TLIntCode3

ScrOldX:	dc.w	0
ScrOldY:	dc.w	0
XOffSet:	dc.w	0
YOffSet:	dc.w	0
DLJX:		dc.w	5
FBJY:		dc.w	60
FRJX:		dc.w	120
DTJY:		dc.w	21
FTJY:		dc.w	71
DBJY:		dc.w	99
DRJX:		dc.w	363
FLJX:		dc.w	255
J1YT:		dc.w	32
J1YB:		dc.w	43
J2YT:		dc.w	82
J2YB:		dc.w	92
J1XL:		dc.w	44
J1XR:		dc.w	77
J2XL:		dc.w	308
J2XR:		dc.w	337
SpritesXOn:	dc.b	1		;1= sprs 1,2,4,5 aren't on
		ds.l	0

;Printer to the CLI (use it for error messages)

ErrorPrint:	move.l	a0,d2
ErrorPrint1:	tst.b	(a0)+
		bne	ErrorPrint1
		subq.l	#1,a0
		sub.l	d2,a0
		move.l	a0,d3
		move.l	OutFile(pc),d1
		move.l	dosbase(pc),a6
		jsr	Write(a6)
		jmp	ShutDown		

ShowGuru:	move.l	#RECOVERY_ALERT,d0
		lea.l	NoMem(pc),a0
		move.l	#52,d1
		move.l	intbase(pc),a6
		jsr	DisplayAlert(a6)
		rts
	
;chck:		btst	#$0006,$bfe001
;		bne	chck
;		lea.l	NoCode(pc),a0
;		jmp	ErrorPrint

		ds.l	0


;Structures: First the display stuff

Window1:	dc.l	0
Window2:	dc.l	0
Window3:	dc.l	0
Screen1:	dc.l	0
QuitWin1:	dc.l	0
HelpWin1:	dc.l	0
FRWin1:		dc.l	0
AbWin1:		dc.l	0
RastPort1:	dc.l	0
RastPort2:	dc.l	0
RastPort3:	dc.l	0
AbRP:		dc.l	0
FRRP:		dc.l	0
ViewPort:	dc.l	0
OldTaskWinPtr:	dc.l	0
SWWin1Name:	dc.b	"Save traffic situation as...",0
		ds.l	0
LWWin1Name:	dc.b	"Load traffic situation",0
		ds.l	0
	
;Memory stuff

ChipMem1:	dc.l	0
TmpRas:		dc.l	0
PlanePtr:	dc.l	0
VecTab1:	dc.l	0

;Timer stuff

timename:	dc.b	"timer.device",0
		ds.l	0
timebase:	dc.l	0			;"library" base of timer.dev
TSigBit:	dc.b	0			;Timer SignalBit
		ds.l	0
TPort:		dc.l	0			;Timer ReplyPort
TimePName:	dc.b	"TrafficTimer",0
		ds.l	0
TimeReq:	dc.l	0			;Traffic InputOutPutReq
GSecs:		dc.l	0			;Cars crossing junction
LSecs:		dc.l	0			;Light
CSecs:		dc.l	0			;ComingCar
Mics:		dc.l	0

;Car Stuff

Amount1:	dc.w	0			;Amount of cars
Amount2:	dc.w	0
Amount3:	dc.w	0
Amount4:	dc.w	0
Amount5:	dc.w	0
Amount6:	dc.w	0
Amount7:	dc.w	0
Amount8:	dc.w	0
Amount9:	dc.w	0
Amount10:	dc.w	0
Amount11:	dc.w	0
Amount12:	dc.w	0
Amount13:	dc.w	0
Amount14:	dc.w	0
Amount15:	dc.w	0
Amount16:	dc.w	0
		ds.l	0

;File stuff

OutFile:	dc.l	0			;It`s the way to the CLI
Lock:		dc.l	0
FileReq:	dc.l	0
FileReqTracker: dc.l	0
DiskFile1:	dc.l	0
	
;Library stuff

reqbase:	dc.l	0
dosbase:	dc.l	0
gfxbase:	dc.l	0
intbase:	dc.l	0
NoREQText1:	dc.b	"You need "
		ds.l	0
reqname:	dc.b	"req.library",0
		ds.l	0
NoREQText2:	dc.b	" v2.2+",$0a,0	
		ds.l	0
dosname:	dc.b	"dos.library",0
		ds.l	0
gfxname:	dc.b	"graphics.library",0
		ds.l	0
intname:	dc.b	"intuition.library",0
		ds.l	0

;Task Stuff

OurTask:	dc.l	0

;Error texts

NoWBScreen:	dc.b	"Couldn´t open WorkBench Screen",$0a,0
		ds.l	0
NoScreen1:	dc.b	"Couldn´t open Screen1.",$0a,0
		ds.l	0
NoWin1:		dc.b	"Couldn´t open CityMap-Window1.",$0a,0
		ds.l	0
NoWin2:		dc.b	"Couldn´t open BackDrop-Window2.",$0a,0
		ds.l	0
NoWin3:		dc.b	"Couldn´t open VariableEd-Window3.",$0a,0
		ds.l	0
NoAreaInit:	dc.b	"Couldn´t init area.",$0a,0
		ds.l	0
NoQuitWin1:	dc.b	"Couldn´t open Quitting-Window.",$0a,0
		ds.l	0
NoFRWin1:	dc.b	"Couldn´t open FileRequest-Window.",$0a,0
		ds.l	0
NoAbWin1:	dc.b	"Couldn´t open About-Window.",$0a,0
		ds.l	0
NoHelpWin1:	dc.b	"Couldn´t open Help-Window.",$0a,0
		ds.l	0
WhoKnows?:	dc.b	"User didn´t read the fucking manual error.",$0a,0
		ds.l	0
NoCode:		dc.b	"Hey, Jack! Finish the fucking code!",$0a,0
		ds.l	0
NoFileBufMem:	dc.b	"Couldn´t get memory (20kb).",$0a,0
		ds.l	0

;Guru messages

NoMem:		dc.b	0,$d0
		dc.b	$10
		dc.b	"Canceled - Not enough memory.",0
		dc.b	1
		dc.b	0,$10
		dc.b	$2d
		dc.b	"Left for o.k.",0
		dc.b	1
		dc.b	$1,$f0
		dc.b	$2d
		dc.b	"Right for CANCEL",0
		dc.b	0
		ds.l	0

;Our Color Map(s)
	

ColorMap1:	dc.w	$aaa,$000,$fff,$0f0,$0f0,$f00,$fa0,$f00
ColorMap2:	dc.w	$aaa,$000,$fff,$aaa,$0f0,$f00,$aaa,$aaa

;Other Stuff XIV
HelpStatus	dc.w	0		;Which text on screen
LStatus:	dc.b	3		;Status of trafficlights
		ds.l	0
TrafficMode:	dc.l	4		;Mode. 2 = night, 4 = day, 5 = heavy

;Interrupt stuff

TLInt:		dc.l	0		;Succ
		dc.l	0		;Pred
		dc.b	2		;type
		dc.b	0		;pri
		dc.l	TLIntName	;name
		dc.l	TLIntData	;userstuff
		dc.l	TLIntCode	;code

TLIntName:	dc.b	"TL_Interrupt",0
		ds.l	0

TLIntData:	dc.l	Sprite1			;Pointer to first car Spr
		dc.l	Sprite27		;Pointer to last car Spr
TLIntScreen:	dc.l	0			;Pointer to Screen
		dc.l	Sprite1			;Pointer to SprBatch1
		dc.l	Sprite4			;Pointer to SprBatch2
		dc.l	Sprite7			;Pointer to SprBatch3
		dc.l	Sprite8			;Pointer to SprBatch4
		dc.l	Sprite9			;Pointer to SprBatch5
		dc.l	Sprite10		;Pointer to SprBatch6
		dc.l	Sprite11		;Pointer to SprBatch7
		dc.l	Sprite12		;Pointer to SprBatch8
		dc.l	Sprite13		;Pointer to SprBatch9
		dc.l	Sprite15		;Pointer to SprBatch10
		dc.l	Sprite17		;Pointer to SprBatch11
		dc.l	Sprite19		;Pointer to SprBatch12
		dc.l	Sprite21		;Pointer to SprBatch13
		dc.l	Sprite23		;Pointer to SprBatch14
		dc.l	Sprite25		;Pointer to SprBatch15
		dc.l	Sprite27		;Pointer to SprBatch16
		dc.l	UpSprImg		;Pointer to UpSprImg
		dc.l	DownSprImg		;Pointer to DownSprImg
		dc.l	RightSprImg		;Pointer to RightSprImg
		dc.l	LeftSprImg		;Pointer to LeftSprImg

GelsInfo:	dc.b	255			;Reserved
		dc.b	0			;Flags
		dc.l	0			;GelHead
		dc.l	0			;GelTail
		dc.l	NextLine		;NextLine
		dc.l	LastColor		;LastColor
		dc.l	CollHandler		;CollHandler
		dc.w	0			;LeftMost
		dc.w	639			;RightMost
		dc.w	0			;TopMost
		dc.w	255			;BottomMost
		dc.l	0			;FirstBlissObj
		dc.l	0			;LastBlissObj

NextLine:	dc.w	0,0,0,0,0,0,0,0,0,0
LastColor:	dc.l	0,0,0,0,0,0,0,0,0,0
CollHandler:	dc.l	0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0

;Sprite structure stuff

		ds.l	0

DummyHead:	ds.b	62

		ds.l	0
;Batch 1

Sprite1:	dc.l	0			;NextVSprite
		dc.l	0			;PrevVSprite
		dc.l	0			;DrawPath
		dc.l	0			;ClearPath
		dc.w	0,0			;Old Y and X
		dc.w	1			;Flags
		dc.w	0,0			;Y and X
		dc.w	8			;Height
		dc.w	1			;Width
		dc.w	2			;Depth
		dc.w	0			;MeMask
		dc.w	0			;HitMask
		dc.l	DownSprImg		;ImageData
		dc.l	BorderLine1		;BorderLine
		dc.l	CollMask1		;CollMask
		dc.l	SpriteCols		;SprColors
		dc.l	0			;VSBob
		dc.b	1			;PlanePick
		dc.b	0			;PlaneOnOff
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite2:	dc.l	0			;NextVSprite
		dc.l	0			;PrevVSprite
		dc.l	0			;DrawPath
		dc.l	0			;ClearPath
		dc.w	0,0			;Old Y and X
		dc.w	1			;Flags
		dc.w	0,0			;Y and X
		dc.w	8			;Height
		dc.w	1			;Width
		dc.w	2			;Depth
		dc.w	0			;MeMask
		dc.w	0			;HitMask
		dc.l	DownSprImg		;ImageData
		dc.l	BorderLine2		;BorderLine
		dc.l	CollMask2		;CollMask
		dc.l	SpriteCols		;SprColors
		dc.l	0			;VSBob
		dc.b	1			;PlanePick
		dc.b	0			;PlaneOnOff
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite3:	dc.l	0			;NextVSprite
		dc.l	0			;PrevVSprite
		dc.l	0			;DrawPath
		dc.l	0			;ClearPath
		dc.w	0,0			;Old Y and X
		dc.w	1			;Flags
		dc.w	0,0			;Y and X
		dc.w	8			;Height
		dc.w	1			;Width
		dc.w	2			;Depth
		dc.w	0			;MeMask
		dc.w	0			;HitMask
		dc.l	DownSprImg		;ImageData
		dc.l	BorderLine3		;BorderLine
		dc.l	CollMask3		;CollMask
		dc.l	SpriteCols		;SprColors
		dc.l	0			;VSBob
		dc.b	1			;PlanePick
		dc.b	0			;PlaneOnOff
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite4:	dc.l	0			;NextVSprite
		dc.l	0			;PrevVSprite
		dc.l	0			;DrawPath
		dc.l	0			;ClearPath
		dc.w	0,0			;Old Y and X
		dc.w	1			;Flags
		dc.w	0,0			;Y and X
		dc.w	8			;Height
		dc.w	1			;Width
		dc.w	2			;Depth
		dc.w	0			;MeMask
		dc.w	0			;HitMask
		dc.l	DownSprImg		;ImageData
		dc.l	BorderLine4		;BorderLine
		dc.l	CollMask4		;CollMask
		dc.l	SpriteCols		;SprColors
		dc.l	0			;VSBob
		dc.b	1			;PlanePick
		dc.b	0			;PlaneOnOff
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite5:	dc.l	0			;NextVSprite
		dc.l	0			;PrevVSprite
		dc.l	0			;DrawPath
		dc.l	0			;ClearPath
		dc.w	0,0			;Old Y and X
		dc.w	1			;Flags
		dc.w	0,0			;Y and X
		dc.w	8			;Height
		dc.w	1			;Width
		dc.w	2			;Depth
		dc.w	0			;MeMask
		dc.w	0			;HitMask
		dc.l	DownSprImg		;ImageData
		dc.l	BorderLine5		;BorderLine
		dc.l	CollMask5		;CollMask
		dc.l	SpriteCols		;SprColors
		dc.l	0			;VSBob
		dc.b	1			;PlanePick
		dc.b	0			;PlaneOnOff
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite6:	dc.l	0			;NextVSprite
		dc.l	0			;PrevVSprite
		dc.l	0			;DrawPath
		dc.l	0			;ClearPath
		dc.w	0,0			;Old Y and X
		dc.w	1			;Flags
		dc.w	0,0			;Y and X
		dc.w	8			;Height
		dc.w	1			;Width
		dc.w	2			;Depth
		dc.w	0			;MeMask
		dc.w	0			;HitMask
		dc.l	DownSprImg		;ImageData
		dc.l	BorderLine6		;BorderLine
		dc.l	CollMask6		;CollMask
		dc.l	SpriteCols		;SprColors
		dc.l	0			;VSBob
		dc.b	1			;PlanePick
		dc.b	0			;PlaneOnOff
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite7:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	LeftSprImg			
		dc.l	BorderLine7		
		dc.l	CollMask7		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite8:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	LeftSprImg			
		dc.l	BorderLine8		
		dc.l	CollMask8	
		dc.l	SpriteCols
		dc.l	0	
		dc.b	1	
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite9:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	UpSprImg			
		dc.l	BorderLine9		
		dc.l	CollMask9		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite10:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	UpSprImg			
		dc.l	BorderLine10		
		dc.l	CollMask10		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite11:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	RightSprImg			
		dc.l	BorderLine11		
		dc.l	CollMask11		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite12:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	RightSprImg			
		dc.l	BorderLine12		
		dc.l	CollMask12		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite13:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	LeftSprImg			
		dc.l	BorderLine13		
		dc.l	CollMask13		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite14:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	LeftSprImg			
		dc.l	BorderLine14		
		dc.l	CollMask14		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite15:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	RightSprImg			
		dc.l	BorderLine15		
		dc.l	CollMask15		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite16:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	RightSprImg			
		dc.l	BorderLine16		
		dc.l	CollMask16		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite17:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	UpSprImg			
		dc.l	BorderLine17		
		dc.l	CollMask17		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite18:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	UpSprImg			
		dc.l	BorderLine18		
		dc.l	CollMask18		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite19:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	DownSprImg
		dc.l	BorderLine19		
		dc.l	CollMask19		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite20:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	DownSprImg			
		dc.l	BorderLine20		
		dc.l	CollMask20		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite21:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	RightSprImg			
		dc.l	BorderLine21		
		dc.l	CollMask21		
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite22:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	RightSprImg			
		dc.l	BorderLine22		
		dc.l	CollMask22	
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite23:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	LeftSprImg			
		dc.l	BorderLine23
		dc.l	CollMask23
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite24:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	LeftSprImg			
		dc.l	BorderLine24
		dc.l	CollMask24
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite25:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	DownSprImg			
		dc.l	BorderLine25
		dc.l	CollMask25
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite26:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	DownSprImg			
		dc.l	BorderLine26
		dc.l	CollMask26
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite27:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	UpSprImg			
		dc.l	BorderLine27
		dc.l	CollMask27
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y
Sprite28:	dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.l	0			
		dc.w	0,0			
		dc.w	1			
		dc.w	0,0
		dc.w	8			
		dc.w	1			
		dc.w	2			
		dc.w	0			
		dc.w	0			
		dc.l	UpSprImg			
		dc.l	BorderLine28
		dc.l	CollMask28
		dc.l	SpriteCols		
		dc.l	0			
		dc.b	1			
		dc.b	0			
		dc.b	0			;Current X
		dc.b	0			; --"--  Y
		dc.b	0			;Destination X
		dc.b	0			;Destination Y

DummyTail:	ds.b	62

;Sprite color map

		ds.l	0
SpriteCols:	dc.w	$000,$fff,$00f


NewAreaInfo1:	dc.l	0			;VctrTbl
		dc.l	0			;VctrPtr
		dc.l	0			;FlagTbl
		dc.l	0			;FlagPtr
		dc.w	0			;Count
		dc.w	0			;MaxCount
		dc.w	0			;FirstX
		dc.w	0			;FirstY
		ds.l	0
	
NewTmpRas1:	dc.l	0			;RasPtr
		dc.l	0			;Size
		ds.l	0

NewScreen1:
		dc.w	0,0			;X,Y POS
Screen1MaxCol:	dc.w	640			;WIDTH (orig.704)
Screen1MaxRow:	dc.w	256			;HEIGHT
		dc.w	4			;DEPTH
		dc.b	0,1			;COLORS
		dc.w	$c000			;VIEWMODES
		dc.w	$000F			;TYPE
		dc.l	Screen1Font		;FONT
		dc.l	TLName			;DEFAULT TITLE
		dc.l	0			;GADGETS
		dc.l	0			;CUSTOMBITMAP
		ds.l	0

Screen1Font:	dc.l	Screen1FontN		;NAME
		dc.w	8			;SIZE
		dc.b	0			;STYLE
		dc.b	0			;FLAGS
		ds.l	0
Screen1FontN:	dc.b	"topaz.font",0

		ds.l	0

NewWindow1:
		dc.w	0,11			;X,Y POS
Win1MaxCol:	dc.w	400			;WIDTH (orig.704)
Win1MaxRow:	dc.w	99			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	INTUITICKS+CLOSEWINDOW+GADGETUP+VANILLAKEY+MENUPICK+RAWKEY
		dc.l	$0008			;FLAGS (orig. $100a)
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	WindowTitle1		;TITLE
SToW1:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	400,99,400,99		;MINIMUM SIZE
		dc.w	$000f			;TYPE
		ds.l	0

WindowTitle1:	dc.b	"City map",0
		ds.l	0

NewWindow2:
		dc.w	0,0			;X,Y POS
Win2MaxCol:	dc.w	640			;WIDTH (orig. 704)4)
Win2MaxRow:	dc.w	256			;HEIGHT (orig. 272)
		dc.b	0,1			;PENS
		dc.l	MENUPICK+VANILLAKEY+RAWKEY	;IDCMP FLAGS
		dc.l	$1900			;FLAGS (orig $1800)
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW2:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	640,256,640,256		;MINIMUM SIZE
		dc.w	$000f			;TYPE
		ds.l	0

NewWindow3:
		dc.w	401,11			;X,Y POS
Win3MaxCol:	dc.w	239			;WIDTH (orig.704)
Win3MaxRow:	dc.w	245			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	INTUITICKS+CLOSEWINDOW+GADGETDOWN+GADGETUP+VANILLAKEY+MENUPICK	;IDCMP FLAGS
		dc.l	$100A			;FLAGS (orig. $100a)
		dc.l	ModeGad1,0		;GADGETS, CHECKMARK
		dc.l	WindowTitle3		;TITLE
SToW4:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP
		dc.w	239,245,239,245		;MINIMUM SIZE
		dc.w	$000f			;TYPE
		ds.l	0

WindowTitle3:	dc.b	"Variable editor",0
		ds.l	0
NewAbWindow1:
		dc.w	128,50			;X,Y POS
		dc.w	400			;WIDTH (orig.704)
		dc.w	100			;HEIGHT
		dc.b	1,2			;PENS
		dc.l	GADGETUP+VANILLAKEY	;IDCMP FLAGS
		dc.l	wd_BORDERLESS		;FLAGS 
		dc.l	MGad1,0			;GADGETS, CHECKMARK
		dc.l	0			;TITLE
SToW8:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	128,50,128,50		;MINIMUM SIZE
		dc.w	$000f			;TYPE
		ds.l	0

NewHelpWin1:
		dc.w	10,6,520,250		;POSITION, SIZE
		dc.b	0,1			;PENS
		dc.l	CLOSEWINDOW+GADGETUP+VANILLAKEY	;IDCMP FLAGS
		dc.l	$1006+wd_WINDOWCLOSE	;FLAGS (orig $1006)
		dc.l	MGad1,0			;GADGETS, CHECKMARK
		dc.l	TLName			;TITLE
SToW7:		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	320,200,320,200		;MINIMUM+MAX SIZE
		dc.w	$000f			;TYPE
		ds.l	0

HelpWin1Txt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	1,3			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	HWin1Text1		;TEXT
		dc.l	HWin1Txt2		;NEXTTEXT
		ds.l	0

HWin1Text1:	dc.b	"Help:",0
		ds.l	0

HWin1Txt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	5,22			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	HWin1Text2		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

HWin1Text2:	dc.b	"Sorry, help is not availible yet.",0
		ds.l	0
NewQuitWin1:
                dc.w    0,0,320,75              ;POSITION, SIZE
                dc.b    0,1                     ;PENS
                dc.l    GADGETUP+VANILLAKEY     ;IDCMP FLAGS
                dc.l    $1006                   ;FLAGS (orig $1006)
                dc.l    QuitGad1,0              ;GADGETS, CHECKMARK
                dc.l    TLName			;TITLE
SToW3:          dc.l    0                       ;SCREEN ADDRESS
                dc.l    0                       ;BITMAP
                dc.w    320,75,704,283          ;MINIMUM+MAX SIZE
                dc.w    $000f                   ;TYPE
                ds.l    0

QuitWin1Txt1:   dc.b    1,2                     ;PENS
                dc.w    0                       ;MODE
                dc.w    1,3                     ;LEFT+TOPEDGE
                dc.l    0                       ;FONT
                dc.l    QuitWin1Text1           ;TEXT
                dc.l    QuitWin1Txt2            ;NEXTTEXT
                ds.l    0

QuitWin1Text1:  dc.b    "Message:",0
                ds.l    0
QuitWin1Txt2:   dc.b    1,2			;PENS
                dc.w    0			;MODE
                dc.w    5,22			;LEFT+TOPEDGE
                dc.l    0			;FONT
                dc.l    QuitWin1Text2		;TEXT
                dc.l    0			;NEXTTEXT
                ds.l    0
QuitWin1Text2:  dc.b    "Quit program?",0
                ds.l    0

;QuitWin1Txt3:   dc.b    1,2                     ;PENS
;                dc.w    0                       ;MODE
;                dc.w    1,31                    ;LEFT+TOPEDGE
;                dc.l    0                       ;FONT
;                dc.l    QuitWin1Text3           ;TEXT
;                dc.l    0                       ;NEXTTEXT
;                ds.l    0
;QuitWin1Text3:  dc.b    "",0
;                ds.l    0

;Menus

Menu1:		dc.l	0			;NEXT MENU
		dc.w	0,1			;LEFT+TOP EDGE
		dc.w	100,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu1Name		;NAME
		dc.l	Menu1Item1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)
		ds.l	0

Menu1Name:	dc.b	"Project",0
		ds.l	0

Menu1Item1:	dc.l	Menu1Item2		;NEXT ITEM
		dc.w	1,1			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I1			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"M",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		ds.l	0
		
Menu1I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu1I1Text		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

Menu1I1Text:	dc.b	"City map",0
		ds.l	0

Menu1Item2:	dc.l	Menu1Item3		
		dc.w	1,15			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu1I2			
		dc.l	0			
		dc.b	"H",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu1I2:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I2Text		
		dc.l	0			
		ds.l	0

Menu1I2Text:	dc.b	"Help",0
		ds.l	0

Menu1Item3:	dc.l	Menu1Item4		
		dc.w	1,30			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu1I3			
		dc.l	0			
		dc.b	"L",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu1I3:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I3Text		
		dc.l	0			
		ds.l	0

Menu1I3Text:	dc.b	"Load...",0
		ds.l	0

Menu1Item4:	dc.l	Menu1Item5		
		dc.w	1,40			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu1I4			
		dc.l	0			
		dc.b	"S",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu1I4:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I4Text		
		dc.l	0			
		ds.l	0

Menu1I4Text:	dc.b	"Save",0
		ds.l	0

Menu1Item5:	dc.l	Menu1Item6		
		dc.w	1,50			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu1I5			
		dc.l	0			
		dc.b	"A",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu1I5:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I5Text		
		dc.l	0			
		ds.l	0

Menu1I5Text:	dc.b	"Save as...",0
		ds.l	0

Menu1Item6:	dc.l	Menu1Item7		
		dc.w	1,70			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu1I6			
		dc.l	0			
		dc.b	"?",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu1I6:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I6Text		
		dc.l	0			
		ds.l	0

Menu1I6Text:	dc.b	"About...",0
		ds.l	0

Menu1Item7:	dc.l	0			
		dc.w	1,80			
		dc.w	120,9			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu1I7	
		dc.l	0			
		dc.b 	"Q",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu1I7:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I7Text		
		dc.l	0			
		ds.l	0
	
Menu1I7Text:	dc.b	"Quit",0
		ds.l	0

Menu9:		dc.l	0			;NEXT MENU
		dc.w	0,1			;LEFT+TOP EDGE
		dc.w	100,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu9Name		;NAME
		dc.l	Menu9Item1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)
		ds.l	0

Menu9Name:	dc.b	"Variables",0
		ds.l	0

Menu9Item1:	dc.l	Menu1Item2		;NEXT ITEM
		dc.w	1,1			;LEFT+TOP EDGE
		dc.w	120,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I1			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"M",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		ds.l	0

Menu9I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Menu1I1Text		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

Menu9Item2:	dc.l	Menu9Item3		
		dc.w	1,15			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu9I2			
		dc.l	0			
		dc.b	"H",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu9I2:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I2Text		
		dc.l	0			
		ds.l	0

Menu9Item3:	dc.l	Menu9Item4		
		dc.w	1,30			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu9I3			
		dc.l	0			
		dc.b	"L",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu9I3:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I3Text		
		dc.l	0			
		ds.l	0

Menu9Item4:	dc.l	Menu9Item5		
		dc.w	1,40			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu9I4			
		dc.l	0			
		dc.b	"S",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu9I4:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I4Text		
		dc.l	0			
		ds.l	0

Menu9Item5:	dc.l	Menu9Item6		
		dc.w	1,50			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu9I5			
		dc.l	0			
		dc.b	"A",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu9I5:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I5Text		
		dc.l	0			
		ds.l	0

Menu9Item6:	dc.l	Menu9Item7		
		dc.w	1,70			
		dc.w	120,8			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu9I6			
		dc.l	0			
		dc.b	"?",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu9I6:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I6Text		
		dc.l	0			
		ds.l	0

Menu9Item7:	dc.l	0			
		dc.w	1,80			
		dc.w	120,9			
		dc.w	$0056			
		dc.l	0			
		dc.l	Menu9I7	
		dc.l	0			
		dc.b 	"Q",0			
		dc.l	0			
		dc.w	$ffff			
		ds.l	0
		
Menu9I7:	dc.b	0,1			
		dc.w	0			
		dc.w	1,0			
		dc.l	0			
		dc.l	Menu1I7Text		
		dc.l	0			
		ds.l	0

;Requester Structures

PositiveText1:	dc.b	"Yes",0
		ds.l	0
NegativeText1:	dc.b	"No",0
		ds.l	0
TLName:		dc.b	"Traffic-Lights",0
		ds.l	0


;Gadget Structures.

InTime:		dc.l	OutTime		;Next Gadget
		dc.w	10		;"hit-box" left edge
		dc.w	43		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IT1Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IT1String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IT1Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IT1Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IT1Text:	dc.b	"Come",0
		ds.l	0	

IT1String:	dc.l	ITGad1Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
InCarTime:	dc.l	1		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0


OutTime:	dc.l	XMax		;Next Gadget
		dc.w	60		;"hit-box" left edge
		dc.w	43		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	OT1Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	OT1String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

OT1Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OT1Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

OT1Text:	dc.b	" Go",0
		ds.l	0	

OT1String:	dc.l	OTGad1Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
OutCarTime:	dc.l	1		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

XMax:		dc.l	YMax		;Next Gadget
		dc.w	110		;"hit-box" left edge
		dc.w	43		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	XM1Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	XM1String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

XM1Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	XM1Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

XM1Text:	dc.b	"X max",0
		ds.l	0	

XM1String:	dc.l	XMGad1Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
XMaxAmount:	dc.l	1		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0
YMax:		dc.l	InCar1		;Next Gadget
		dc.w	160		;"hit-box" left edge
		dc.w	43		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	YM1Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	YM1String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

YM1Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	YM1Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

YM1Text:	dc.b	"Y max",0
		ds.l	0	

YM1String:	dc.l	YMGad1Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
YMaxAmount:	dc.l	1		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar1:		dc.l	InCar2		;Next Gadget
		dc.w	10		;"hit-box" left edge
		dc.w	63		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC1Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC1String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC1Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC1Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC1Text:	dc.b	"No 1",0
		ds.l	0	

IC1String:	dc.l	ICGad1Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In1:		dc.l	12		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar2:		dc.l	InCar3		;Next Gadget
		dc.w	50		;"hit-box" left edge
		dc.w	63		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC2Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC2String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC2Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC2Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC2Text:	dc.b	"No 2",0
		ds.l	0	

IC2String:	dc.l	ICGad2Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In2:		dc.l	10		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar3:		dc.l	InCar4		;Next Gadget
		dc.w	90		;"hit-box" left edge
		dc.w	63		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC3Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC3String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC3Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC3Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC3Text:	dc.b	"No 3",0
		ds.l	0	

IC3String:	dc.l	ICGad3Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In3:		dc.l	10		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar4:		dc.l	InCar5		;Next Gadget
		dc.w	130		;"hit-box" left edge
		dc.w	63		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC4Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC4String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC4Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC4Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC4Text:	dc.b	"No 4",0
		ds.l	0	

IC4String:	dc.l	ICGad4Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In4:		dc.l	15		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar5:		dc.l	InCar6		;Next Gadget
		dc.w	170		;"hit-box" left edge
		dc.w	63		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC5Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC5String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC5Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC5Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC5Text:	dc.b	"No 5",0
		ds.l	0	

IC5String:	dc.l	ICGad5Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In5:		dc.l	5		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar6:		dc.l	InCar7		;Next Gadget
		dc.w	10		;"hit-box" left edge
		dc.w	83		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC6Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC6String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC6Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC6Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC6Text:	dc.b	"No 6",0
		ds.l	0	

IC6String:	dc.l	ICGad6Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In6:		dc.l	15		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar7:		dc.l	InCar8		;Next Gadget
		dc.w	50		;"hit-box" left edge
		dc.w	83		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC7Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC7String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC7Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC7Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC7Text:	dc.b	"No 7",0
		ds.l	0	

IC7String:	dc.l	ICGad7Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In7:		dc.l	18		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

InCar8:		dc.l	Turn1		;Next Gadget
		dc.w	90		;"hit-box" left edge
		dc.w	83		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	IC8Txt		;gadget text
		dc.l	0		;mutual exclude
		dc.l	IC8String	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

IC8Txt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	IC8Text			;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

IC8Text:	dc.b	"No 8",0
		ds.l	0	

IC8String:	dc.l	ICGad8Buf	;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
In8:		dc.l	15		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

Turn1:		dc.l	Turn2		
		dc.w	10		
		dc.w	113		
		dc.w	16		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn1String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn1String:	dc.l	TurnGad1Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T1:		dc.l	5		
		dc.l	0		
		ds.l	0

Turn2:		dc.l	Turn3		
		dc.w	35		
		dc.w	113		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn2String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn2String:	dc.l	TurnGad2Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T2:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn3:		dc.l	Turn4		
		dc.w	60		
		dc.w	113		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn3String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn3String:	dc.l	TurnGad3Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T3:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn4:		dc.l	Turn5		
		dc.w	150		
		dc.w	113		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn4String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn4String:	dc.l	TurnGad4Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T4:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn5:		dc.l	Turn6		
		dc.w	175		
		dc.w	113		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn5String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn5String:	dc.l	TurnGad5Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T5:		dc.l	5		
		dc.l	0		
		ds.l	0

Turn6:		dc.l	Turn7		
		dc.w	200		
		dc.w	113		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn6String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn6String:	dc.l	TurnGad6Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T6:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn7:		dc.l	Turn8		
		dc.w	10		
		dc.w	123		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn7String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn7String:	dc.l	TurnGad7Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T7:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn8:		dc.l	Turn9		
		dc.w	35		
		dc.w	123		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn8String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn8String:	dc.l	TurnGad8Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T8:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn9:		dc.l	Turn10		
		dc.w	60		
		dc.w	123		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn9String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn9String:	dc.l	TurnGad9Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T9:		dc.l	12		
		dc.l	0		
		ds.l	0

Turn10:		dc.l	Turn11		
		dc.w	150		
		dc.w	123		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn10String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn10String:	dc.l	TurnGad10Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T10:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn11:		dc.l	Turn12		
		dc.w	175		
		dc.w	123		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn11String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn11String:	dc.l	TurnGad11Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T11:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn12:		dc.l	Turn13		
		dc.w	200		
		dc.w	123		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn12String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn12String:	dc.l	TurnGad12Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T12:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn13:		dc.l	Turn14		
		dc.w	10		
		dc.w	133		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn13String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn13String:	dc.l	TurnGad13Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T13:		dc.l	5		
		dc.l	0		
		ds.l	0

Turn14:		dc.l	Turn15		
		dc.w	35		
		dc.w	133		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn14String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn14String:	dc.l	TurnGad14Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T14:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn15:		dc.l	Turn16		
		dc.w	60		
		dc.w	133		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn15String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn15String:	dc.l	TurnGad15Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T15:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn16:		dc.l	Turn17		
		dc.w	150		
		dc.w	133		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn16String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn16String:	dc.l	TurnGad16Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T16:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn17:		dc.l	Turn18		
		dc.w	175		
		dc.w	133		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn17String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn17String:	dc.l	TurnGad17Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T17:		dc.l	12		
		dc.l	0		
		ds.l	0

Turn18:		dc.l	Turn19		
		dc.w	200		
		dc.w	133		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn18String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn18String:	dc.l	TurnGad18Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T18:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn19:		dc.l	Turn20		
		dc.w	10		
		dc.w	143		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn19String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn19String:	dc.l	TurnGad19Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T19:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn20:		dc.l	Turn21		
		dc.w	35		
		dc.w	143		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn20String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn20String:	dc.l	TurnGad20Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T20:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn21:		dc.l	Turn22		
		dc.w	60		
		dc.w	143		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn21String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn21String:	dc.l	TurnGad21Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T21:		dc.l	5		
		dc.l	0		
		ds.l	0

Turn22:		dc.l	Turn23		
		dc.w	150		
		dc.w	143		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn22String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn22String:	dc.l	TurnGad22Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T22:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn23:		dc.l	Turn24		
		dc.w	175		
		dc.w	143		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn23String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn23String:	dc.l	TurnGad23Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T23:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn24:		dc.l	Turn25		
		dc.w	200		
		dc.w	143		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn24String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn24String:	dc.l	TurnGad24Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T24:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn25:		dc.l	Turn26		
		dc.w	10		
		dc.w	163		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn25String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn25String:	dc.l	TurnGad25Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T25:		dc.l	12		
		dc.l	0		
		ds.l	0

Turn26:		dc.l	Turn27		
		dc.w	35		
		dc.w	163		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn26String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn26String:	dc.l	TurnGad26Buf	
		dc.l	GadUnBuf	
		dc.w	1
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T26:		dc.l	10
		dc.l	0		
		ds.l	0

Turn27:		dc.l	Turn28		
		dc.w	60		
		dc.w	163		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn27String	
		dc.w	1		
		dc.l	0
		ds.l	0

Turn27String:	dc.l	TurnGad27Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T27:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn28:		dc.l	Turn29		
		dc.w	150		
		dc.w	163		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0
		dc.l	0		
		dc.l	0		
		dc.l	Turn28String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn28String:	dc.l	TurnGad28Buf	
		dc.l	GadUnBuf
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T28:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn29:		dc.l	Turn30		
		dc.w	175		
		dc.w	163		
		dc.w	20		
		dc.w	9
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn29String	
		dc.w	1
		dc.l	0		
		ds.l	0

Turn29String:	dc.l	TurnGad29Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T29:		dc.l	5		
		dc.l	0		
		ds.l	0

Turn30:		dc.l	Turn31		
		dc.w	200		
		dc.w	163		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn31String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn30String:	dc.l	TurnGad30Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T30:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn31:		dc.l	Turn32		
		dc.w	10		
		dc.w	173		
		dc.w	20
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn31String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn31String:	dc.l	TurnGad31Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T31:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn32:		dc.l	Turn33		
		dc.w	35		
		dc.w	173		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn32String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn32String:	dc.l	TurnGad32Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T32:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn33:		dc.l	Turn34		
		dc.w	60		
		dc.w	173		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0
		dc.l	Turn33String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn33String:	dc.l	TurnGad33Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T33:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn34:		dc.l	Turn35		
		dc.w	150		
		dc.w	173		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn34String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn34String:	dc.l	TurnGad34Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T34:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn35:		dc.l	Turn36		
		dc.w	175
		dc.w	173		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0
		dc.l	0		
		dc.l	Turn35String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn35String:	dc.l	TurnGad35Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T35:		dc.l	12
		dc.l	0		
		ds.l	0

Turn36:		dc.l	Turn37		
		dc.w	200		
		dc.w	173		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn36String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn36String:	dc.l	TurnGad36Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T36:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn37:		dc.l	Turn38
		dc.w	10		
		dc.w	183		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn37String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn37String:	dc.l	TurnGad37Buf	
		dc.l	GadUnBuf
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T37:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn38:		dc.l	Turn39		
		dc.w	35		
		dc.w	183		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn38String	
		dc.w	1
		dc.l	0		
		ds.l	0

Turn38String:	dc.l	TurnGad38Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T38:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn39:		dc.l	Turn40		
		dc.w	60		
		dc.w	183		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn39String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn39String:	dc.l	TurnGad39Buf
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T39:		dc.l	5		
		dc.l	0		
		ds.l	0

Turn40:		dc.l	Turn41		
		dc.w	150		
		dc.w	183		
		dc.w	20
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn40String
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn40String:	dc.l	TurnGad40Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T40:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn41:		dc.l	Turn42		
		dc.w	175		
		dc.w	183		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn41String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn41String:	dc.l	TurnGad41Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T41:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn42:		dc.l	Turn43		
		dc.w	200		
		dc.w	183
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn42String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn42String:	dc.l	TurnGad42Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	4
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T42:		dc.l	15		
		dc.l	0
		ds.l	0

Turn43:		dc.l	Turn44		
		dc.w	10		
		dc.w	193		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn43String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn43String:	dc.l	TurnGad43Buf	
		dc.l	GadUnBuf	
		dc.w	1
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T43:		dc.l	18		
		dc.l	0		
		ds.l	0

Turn44:		dc.l	Turn45		
		dc.w	35		
		dc.w	193		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0
		dc.l	0		
		dc.l	Turn44String	
		dc.w	1		
		dc.l	0
		ds.l	0

Turn44String:	dc.l	TurnGad44Buf	
		dc.l	GadUnBuf	
		dc.w	1
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T44:		dc.l	15		
		dc.l	0		
		ds.l	0

Turn45:		dc.l	Turn46		
		dc.w	60		
		dc.w	193		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0
		dc.l	0		
		dc.l	0		
		dc.l	Turn45String	
		dc.w	1		
		dc.l	0
		ds.l	0

Turn45String:	dc.l	TurnGad45Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T45:		dc.l	12		
		dc.l	0		
		ds.l	0

Turn46:		dc.l	Turn47
		dc.w	150		
		dc.w	193		
		dc.w	20		
		dc.w	9
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0
		dc.l	0		
		dc.l	0		
		dc.l	Turn46String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn46String:	dc.l	TurnGad46Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T46:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn47:		dc.l	Turn48		
		dc.w	175		
		dc.w	193		
		dc.w	20		
		dc.w	9
		dc.w	$0000
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn47String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn47String:	dc.l	TurnGad47Buf	
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1		
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T47:		dc.l	10		
		dc.l	0		
		ds.l	0

Turn48:		dc.l	0
		dc.w	200
		dc.w	193		
		dc.w	20		
		dc.w	9   		
		dc.w	$0000		
		dc.w	$0a01		
		dc.w	$0004		
		dc.l	GadgetBorder2	
		dc.l	0		
		dc.l	0		
		dc.l	0		
		dc.l	Turn48String	
		dc.w	1		
		dc.l	0		
		ds.l	0

Turn48String:	dc.l	TurnGad48Buf
		dc.l	GadUnBuf	
		dc.w	1		
		dc.w	3		
		dc.w	1
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
T48:		dc.l	15		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

QuitGad1:	dc.l    QuitGad2        ;Next Gadget
		dc.w    -310            ;"hit-box" left edge
		dc.w    -15             ;"hit-box" top  edge
		dc.w    51              ;"hit-box" Width
		dc.w    10              ;"hit-box" Height
QG1Flag:	dc.w    $0018           ;flags
		dc.w    $0001           ;activation
		dc.w    $0001           ;gadget type
		dc.l    QGadgetBorder1  ;gadget rendering
		dc.l    0               ;select rendering
		dc.l    QGadTxt1        ;gadget text
		dc.l    0               ;mutual exclude
		dc.l    0               ;special info
		dc.w    2               ;gadget ID (user definable)
		dc.l    0               ;ptr to general purpose user data
		ds.l    0

QGadTxt1:	dc.b    1,2                     ;PENS
		dc.w    0                       ;MODE
		dc.w    13,1                    ;LEFT+TOPEDGE
		dc.l    0                       ;FONT
		dc.l    PositiveText1           ;TEXT
		dc.l    0                       ;NEXTTEXT
		ds.l	0
		
QuitGad2:	dc.l    0               ;Next Gadget
		dc.w    -58             ;"hit-box" left edge
		dc.w    -15             ;"hit-box" top  edge
		dc.w    51              ;"hit-box" Width
		dc.w    10              ;"hit-box" Height
QG2Flag:	dc.w    $0018           ;flags
		dc.w    $0001           ;activation
		dc.w    $0001           ;gadget type
		dc.l    QGadgetBorder1  ;gadget rendering
		dc.l    0               ;select rendering
		dc.l    QGadTxt2        ;gadget text
		dc.l    0               ;mutual exclude
		dc.l    0               ;special info
		dc.w    3               ;gadget ID (user definable)
		dc.l    0               ;ptr to general purpose user data
		ds.l    0

QGadTxt2:       dc.b    1,2                     ;PENS
                dc.w    0                       ;MODE
                dc.w    17,1                    ;LEFT+TOPEDGE
                dc.l    0                       ;FONT
                dc.l    NegativeText1           ;TEXT
                dc.l    0                       ;NEXTTEXT
                ds.l    0

MGad1:		dc.l    MGad2		;Next Gadget
		dc.w    10		;"hit-box" left edge
		dc.w    -15		;"hit-box" top  edge
		dc.w    51		;"hit-box" Width
		dc.w    10		;"hit-box" Height
G1Flag:		dc.w	$0008		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;Gadget type
		dc.l	QGadgetBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	QGadTxt1	;gadget text
		dc.l	0
		dc.l	0
		dc.w	2		;ID
		dc.l	0
		ds.l	0

MGad2:          dc.l    0		;Next Gadget
		dc.w    -60		;"hit-box" left edge
		dc.w    -15		;"hit-box" top  edge
		dc.w    51		;"hit-box" Width
		dc.w    10		;"hit-box" Height
G2Flag:		dc.w	$0018		;flags
		dc.w	$0001		;activation
		dc.w	$0001		;Gadget type
		dc.l	QGadgetBorder1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	QGadTxt2	;gadget text
		dc.l	0
		dc.l	0
		dc.w	3		;ID
		dc.l	0
		ds.l	0

ModeGad1:	dc.l	ModeGad2	;Next Gadget
		dc.w	7		;"hit-box" left edge
		dc.w	230		;"hit-box" top  edge
		dc.w	16		;"hit-box" Width
		dc.w	12		;"hit-box" Height
		dc.w	$0006		;flags
		dc.w	$0103		;activation
		dc.w	$0001		;gadget type
		dc.l	ModeGadImage1	;gadget renderingg
		dc.l	ModeGadImage2	;select rendering
		dc.l	ModeGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ModeGadTxt1:	dc.b    1,2			;PENS
		dc.w    0			;MODE
		dc.w    17,2			;LEFT+TOPEDGE
		dc.l    0			;FONT
		dc.l	ModeGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l    0
ModeGadText1:	dc.b	"Night",0
		ds.l	0

ModeGad2:	dc.l	ModeGad3	;Next Gadget
		dc.w	67		;"hit-box" left edge
		dc.w	230		;"hit-box" top  edge
		dc.w	16              ;"hit-box" Width
		dc.w	12		;"hit-box" Height
		dc.w	$0006		;flags
		dc.w	$0103		;activation
		dc.w	$0001		;gadget type
		dc.l	ModeGadImage1	;gadget renderingg
		dc.l	ModeGadImage2	;select rendering
		dc.l	ModeGadTxt2	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ModeGadTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ModeGadText2		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
ModeGadText2:	dc.b	"Day",0
		ds.l	0

ModeGad3:	dc.l	Gadget1		;Next Gadget
		dc.w	112		;"hit-box" left edge
		dc.w	230		;"hit-box" top  edge
		dc.w	16              ;"hit-box" Width
		dc.w	12		;"hit-box" Height
		dc.w	$0086		;flags
		dc.w	$0103		;activation
		dc.w	$0001		;gadget type
		dc.l	ModeGadImage1	;gadget renderingg
		dc.l	ModeGadImage2	;select rendering
		dc.l	ModeGadTxt3	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ModeGadTxt3:	dc.b    1,2			;PENS
		dc.w    0			;MODE
		dc.w    17,2			;LEFT+TOPEDGE
		dc.l    0			;FONT
		dc.l    ModeGadText3		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l    0
ModeGadText3:	dc.b	"Heavy traffic",0
		ds.l	0

Gadget1:	dc.l	Gadget2		;Next Gadget
		dc.w	30		;"hit-box" left edge (orig. 200)
		dc.w	23		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9   		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	GadTxt1		;gadget text
		dc.l	0		;mutual exclude
		dc.l	StringInfo1	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

GadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	5,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	GadText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

GadText1:	dc.b	"Red",0
		ds.l	0

StringInfo1:	dc.l	Gad1Buf		;Gadget 1 Buffer
		dc.l	GadUnBuf	;Gadget 1 Undo Buffer
		dc.w	3		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	0		;Buffer Pos. of 1st disp. char
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
RedLength:	dc.l	20		;Long int.
		dc.l	0		;AltKeyMap
		ds.l	0

Gadget2:	dc.l	Gadget3		;Next Gadget
		dc.w	100		;"hit-box" left edge
		dc.w	23		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	GadTxt2		;gadget text
		dc.l	0		;mutual exclude
		dc.l	StringInfo2	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

		ds.l	0

GadTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	-5,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	GadText2		;TEXT
		dc.l	0			;NEXTTEXT

		ds.l	0

GadText2:	dc.b	"Amber",0

		ds.l	0

StringInfo2:	dc.l	Gad2Buf		;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	3		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	0		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

AmberLength:	dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

		ds.l	0

Gadget3:	dc.l	InTime		;Next Gadget
		dc.w	170		;"hit-box" left edge
		dc.w	23		;"hit-box" top  edge
		dc.w	35		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	$0000		;flags
		dc.w	$0a01		;activation
		dc.w	$0004		;gadget type
		dc.l	GadgetBorder	;gadget rendering
		dc.l	0		;select rendering
		dc.l	GadTxt3		;gadget text
		dc.l	0		;mutual exclude
		dc.l	StringInfo3	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

		ds.l	0

GadTxt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	-2,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	GadText3		;TEXT
		dc.l	0			;NEXTTEXT

		ds.l	0

GadText3:	dc.b	"Green",0

		ds.l	0

StringInfo3:	dc.l	Gad3Buf		;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	3		;Pos in Buffer
		dc.w	3		;Max. Chars in Buffer
		dc.w	0		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0
	
GreenLength:	dc.l	30		;Long int.
		dc.l	0		;AltKeyMap
	
		ds.l	0

GadgetBorder:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
BorderXY:	dc.w	-1,-1
		dc.w	36,-1		
		dc.w	36,9
		dc.w	-1,9
		dc.w	-1,-1
		dc.b	0
		ds.l	0

GadgetBorder2:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	BorderXY2	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
BorderXY2:	dc.w	-1,-1
		dc.w	22,-1		
		dc.w	22,9
		dc.w	-1,9
		dc.w	-1,-1
		dc.b	0
		ds.l	0

CityMap1:	dc.w	5		;Initial offsets from the origin
		dc.w	11		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY1		;XY's
		dc.l	CityMap2	;Next Border
		dc.b	0
		ds.l	0
CityMap2:	dc.w	360		;Initial offsets from the origin
		dc.w	11		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY1		;XY's
		dc.l	CityMap3	;Next Border
		dc.b	0
		ds.l	0
CityMap3:	dc.w	360		;Initial offsets from the origin
		dc.w	87		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY1		;XY's
		dc.l	CityMap4	;Next Border
		dc.b	0
		ds.l	0
CityMap4:	dc.w	5		;Initial offsets from the origin
		dc.w	87		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY1		;XY's
		dc.l	CityMap5	;Next Border
		dc.b	0
		ds.l	0
CityMap5:	dc.w	100		;Initial offsets from the origin
		dc.w	87		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY2		;XY's
		dc.l	CityMap6	;Next Border
		dc.b	0
		ds.l	0
CityMap6:	dc.w	100		;Initial offsets from the origin
		dc.w	11		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY2		;XY's
		dc.l	CityMap7	;Next Border
		dc.b	0
		ds.l	0
CityMap7:	dc.w	100		;Initial offsets from the origin
		dc.w	38		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY3		;XY's
		dc.l	CityMap8	;Next Border
		dc.b	0
		ds.l	0
CityMap8:	dc.w	5		;Initial offsets from the origin
		dc.w	38		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY4		;XY's
		dc.l	CityMap9	;Next Border
		dc.b	0
		ds.l	0
CityMap9:	dc.w	360		;Initial offsets from the origin
		dc.w	38		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	CityXY4		;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0

CityXY1:	dc.w	1,1
		dc.w	33,1		
		dc.w	33,9
		dc.w	1,9
		dc.w	1,1
		dc.b	0
		ds.l	0
CityXY2:	dc.w	1,1
		dc.w	200,1		
		dc.w	200,9
		dc.w	1,9
		dc.w	1,1
		dc.b	0
		ds.l	0
CityXY3:	dc.w	1,1
		dc.w	200,1		
		dc.w	200,30
		dc.w	1,30
		dc.w	1,1
		dc.b	0
		ds.l	0
CityXY4:	dc.w	1,1
		dc.w	33,1		
		dc.w	33,30
		dc.w	1,30
		dc.w	1,1
		dc.b	0
		ds.l	0

QGadgetBorder1:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	QBorderXY1	;XY's
		dc.l	QGadgetBorder2	;Next Border
		dc.b	0
		ds.l	0
QBorderXY1:	dc.w	0,0
		dc.w	52,0		
		dc.w	52,11
		dc.w	0,11
		dc.w	0,0
		dc.b	0
		ds.l	0

QGadgetBorder2:	dc.w	-2		;Initial offsets from the origin
		dc.w	-3		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	QBorderXY2	;XY's
		dc.l	QGadgetBorder3	;Next Border
		dc.b	0
		ds.l	0
QBorderXY2:	dc.w	0,0
		dc.w	54,0		
		dc.w	54,15
		dc.w	0,15
		dc.w	0,0
		dc.b	0
		ds.l	0

QGadgetBorder3:	dc.w	-3		;Initial offsets from the origin
		dc.w	-4		;LeftEdge and TopEdge
		dc.b	3,1		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	QBorderXY3	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
QBorderXY3:	dc.w	0,0
		dc.w	56,0		
		dc.w	56,17
		dc.w	0,17
		dc.w	0,0
		dc.b	0
		ds.l	0

PGadgetBorder1:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	PBorderXY1	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
PBorderXY1:	dc.w	-1,-1
		dc.w	25,-1		
		dc.w	25,9
		dc.w	-1,9
		dc.w	-1,-1
		dc.b	0
		ds.l	0

PGadgetBorder2:	dc.w	-1		;Initial offsets from the origin
		dc.w	-1		;LeftEdge and TopEdge
		dc.b	1,2		;Pens
		dc.b	1		;Draw Mode
		dc.b	5		;Line Count (XY)
		dc.l	PBorderXY2	;XY's
		dc.l	0		;Next Border
		dc.b	0
		ds.l	0
PBorderXY2:	dc.w	-1,-1
		dc.w	33,-1		
		dc.w	33,9
		dc.w	-1,9
		dc.w	-1,-1
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

;Gadget buffers
		ds.l	0

PGad1Buf:	dc.b	"1",0,0,0

PGad2Buf:	dc.b	"1",0,0,0

PGadUnBuf:	dc.b	0,0,0,0
	
Gad1Buf:	dc.b	"30",0,0,0
		ds.l	0
Gad2Buf:	dc.b	"0",0,0,0,0
		ds.l	0
Gad3Buf:	dc.b	"20",0,0,0
		ds.l	0
ITGad1Buf:	dc.b	"1",0,0
		ds.l	0		
OTGad1Buf:	dc.b	"1",0,0
		ds.l	0		
XMGad1Buf:	dc.b	"30",0
		ds.l	0		
YMGad1Buf:	dc.b	"20",0
		ds.l	0		
ICGad1Buf:	dc.b	"12",0
		ds.l	0
ICGad2Buf:	dc.b	"10",0
		ds.l	0
ICGad3Buf:	dc.b	"10",0
		ds.l	0
ICGad4Buf:	dc.b	"15",0
		ds.l	0
ICGad5Buf:	dc.b	"05",0,0
		ds.l	0
ICGad6Buf:	dc.b	"15",0
		ds.l	0
ICGad7Buf:	dc.b	"18",0
		ds.l	0
ICGad8Buf:	dc.b	"15",0
		ds.l	0
TurnGad1Buf:	dc.b	"05",0
		ds.l	0
TurnGad2Buf:	dc.b	"40",0
		ds.l	0
TurnGad3Buf:	dc.b	"55",0
		ds.l	0
TurnGad4Buf:	dc.b	"05",0
		ds.l	0
TurnGad5Buf:	dc.b	"65",0,0
		ds.l	0
TurnGad6Buf:	dc.b	"30",0
		ds.l	0
TurnGad7Buf:	dc.b	"40",0
		ds.l	0
TurnGad8Buf:	dc.b	"40",0
		ds.l	0
TurnGad9Buf:	dc.b	"20",0
		ds.l	0
TurnGad10Buf:	dc.b	"40",0
		ds.l	0
TurnGad11Buf:	dc.b	"35",0
		ds.l	0
TurnGad12Buf:	dc.b	"25",0
		ds.l	0
TurnGad13Buf:	dc.b	"30",0,0
		ds.l	0
TurnGad14Buf:	dc.b	"50",0
		ds.l	0
TurnGad15Buf:	dc.b	"20",0
		ds.l	0
TurnGad16Buf:	dc.b	"20",0
		ds.l	0
TurnGad17Buf:	dc.b	"60",0
		ds.l	0
TurnGad18Buf:	dc.b	"20",0
		ds.l	0
TurnGad19Buf:	dc.b	"10",0
		ds.l	0
TurnGad20Buf:	dc.b	"50",0
		ds.l	0
TurnGad21Buf:	dc.b	"40",0
		ds.l	0
TurnGad22Buf:	dc.b	"20",0,0
		ds.l	0
TurnGad23Buf:	dc.b	"70",0
		ds.l	0
TurnGad24Buf:	dc.b	"10",0
		ds.l	0
TurnGad25Buf:	dc.b	"05",0
		ds.l	0
TurnGad26Buf:	dc.b	"80",0
		ds.l	0
TurnGad27Buf:	dc.b	"15",0
		ds.l	0
TurnGad28Buf:	dc.b	"15",0
		ds.l	0
TurnGad29Buf:	dc.b	"70",0
		ds.l	0
TurnGad30Buf:	dc.b	"15",0,0
		ds.l	0
TurnGad31Buf:	dc.b	"35",0
		ds.l	0
TurnGad32Buf:	dc.b	"50",0
		ds.l	0
TurnGad33Buf:	dc.b	"15",0
		ds.l	0
TurnGad34Buf:	dc.b	"20",0
		ds.l	0
TurnGad35Buf:	dc.b	"30",0
		ds.l	0
TurnGad36Buf:	dc.b	"50",0
		ds.l	0
TurnGad37Buf:	dc.b	"10",0
		ds.l	0
TurnGad38Buf:	dc.b	"50",0,0
		ds.l	0
TurnGad39Buf:	dc.b	"35",0
		ds.l	0
TurnGad40Buf:	dc.b	"15",0
		ds.l	0
TurnGad41Buf:	dc.b	"60",0
		ds.l	0
TurnGad42Buf:	dc.b	"25",0
		ds.l	0
TurnGad43Buf:	dc.b	"15",0
		ds.l	0
TurnGad44Buf:	dc.b	"40",0
		ds.l	0
TurnGad45Buf:	dc.b	"45",0
		ds.l	0
TurnGad46Buf:	dc.b	"45",0
		ds.l	0
TurnGad47Buf:	dc.b	"30",0,0
		ds.l	0
TurnGad48Buf:	dc.b	"25",0
		ds.l	0
GadUnBuf:	ds.b	30
		ds.l	0

FRDir:		dc.b	"SYS:",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0
		ds.l	0

FRFile:		dc.b	"Traffic-Lights.DAT",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		ds.l	0

FRPathName:	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0
		ds.l	0
	
FileRequest1:	dc.w	$2				;MUST BE REQVERSION !!!
FRTitle:	dc.l	0				;frq_Title
		dc.l	FRDir				;frq_dir
		dc.l	FRFile				;frq_File
		dc.l	FRPathName			;frq_PathName
		dc.l	0				;frq_Window
		dc.w	0				;frq_MaxExtndSelect
		dc.w	0,0				;frq_NumLines,NumColumns
		dc.w	0				;frq_DevColumns
		dc.l	FRQLOADINGB+FRQABSOLUTEXYB	;frq_Flags
		dc.w	2,1				;frq_DirNamesColor,FileNamesColor
		dc.w	3,4				;frq_DeviceNamesColor,FontNamesColor
		dc.w	0				;frq_FontSizesColor
		dc.w	0,0				;frq_DetailColor,BlockColor
		dc.w	0,0				;frq_GadgetTextColor,TextMessageColor
		dc.w	0,0				;frq_StringNameColor,StringGadgetColor
		dc.w	0,0				;frq_BoxBorderColor,GadgetBoxColor
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;frq_RFU_Stuff
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0		;frq_DateStamp
		dc.w	128,6				;frq_WindowLeftEdge,WindowTopEdge
		dc.w	0,0				;frq_FontYSize,FontStyle
		dc.l	0				;frq_ExtendSelect
		dc.b	0,0,0,0,0,0,0,0,0,0		;frq_Hide
		dc.b	0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0		;frq_Show
		dc.b	0,0,0,0,0,0,0,0,0,0
		dc.b	0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0				;frq_FileBufferPos,FileDispPos
		dc.w	0,0				;frq_DirBufferPos,DirDispPos
		dc.w	0,0				;frq_HideBufferPos,HideDispPos
		dc.w	0,0				;frq_ShowBufferPos,ShowPispPos
		dc.l	0,0				;frq_Memory,Memory2
		dc.l	0				;frq_Lock
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;frq_PrivateDirBuffer
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0				;frq_FileInfoBlock
		dc.w	0				;frq_NumEntries
		dc.w	0				;NumHiddenEntries
		dc.w	0				;frq_FileStartNumber
		dc.w	0				;frq_DevicesStartNumber
		ds.l	0

AmountTxt1:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	40,13			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

AmountTxt2:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	302,13			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt3:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	360,23			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt4:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	360,71			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt5:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	338,89			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt6:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	79,89			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt7:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	20,80			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt8:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	20,31			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt9:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	101,23			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt10:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	282,31			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt11:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	302,61			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt12:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	339,42			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt13:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	282,80			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt14:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	101,71			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt15:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	40,61			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

AmountTxt16:	dc.b	1,0			;PENS
		dc.w	0			;MODE
		dc.w	78,42			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData		;TEXT
		dc.l	0 			;NEXTTEXT
		ds.l	0

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

MapTxt1:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,101			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText1		;TEXT
		dc.l	MapTxt2			;NEXTTEXT
MapTxt2:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,111			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText2		;TEXT
		dc.l	MapTxt3			;NEXTTEXT
MapTxt3:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,11			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText3		;TEXT
		dc.l	MapTxt4			;NEXTTEXT
MapTxt4:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,11			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText4		;TEXT
		dc.l	MapTxt5			;NEXTTEXT
MapTxt5:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	101,111			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText5		;TEXT
		dc.l	MapTxt6			;NEXTTEXT
MapTxt6:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	101,121			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText6		;TEXT
		dc.l	MapTxt7			;NEXTTEXT
MapTxt7:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	101,131			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText7		;TEXT
		dc.l	MapTxt8			;NEXTTEXT
MapTxt8:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	101,141			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MapText8		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

MapText1:	dc.b	"Junction 1",0
		ds.l	0
MapText2:	dc.b	"Junction 2",0
		ds.l	0
MapText3:	dc.b	"Junction 3",0
		ds.l	0
MapText4:	dc.b	"Junction 4",0
		ds.l	0
MapText5:	dc.b	"West",0
		ds.l	0
MapText6:	dc.b	"North",0
		ds.l	0
MapText7:	dc.b	"East",0
		ds.l	0
MapText8:	dc.b	"South",0


AboutText1:	dc.b	"              Traffic-Lights v.0.94",0
		ds.l	0                          
AboutText2:	dc.b	"                       by",0
		ds.l	0
AboutText3:	dc.b	"                 Tomi Blinnikka",0
		ds.l	0
AboutText4:	dc.b	"            (C)opyright 1991. Address :",0,0
		ds.l	0
AboutText5:	dc.b	"                  Syystie 10",0
		ds.l	0
AboutText6:	dc.b	"                  00780 Helsinki",0
		ds.l	0
AboutText7:	dc.b	"         Phone: 90-351 1462/90-345 4588",0
		ds.l	0

Help1Txt1:	dc.b	1,2			;PENS
		dc.w	4			;MODE
		dc.w	11,11			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text1		;TEXT
		dc.l	Help1Txt2		;NEXTTEXT
		ds.l	0
Help1Txt2:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,21			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text2		;TEXT
		dc.l	Help1Txt3		;NEXTTEXT
		ds.l	0
Help1Txt3:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,31			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text3		;TEXT
		dc.l	Help1Txt4		;NEXTTEXT
		ds.l	0
Help1Txt4:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,41			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text4		;TEXT
		dc.l	Help1Txt5		;NEXTTEXT
		ds.l	0
Help1Txt5:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,51			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text5		;TEXT
		dc.l	Help1Txt6		;NEXTTEXT
		ds.l	0
Help1Txt6:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,61			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text6		;TEXT
		dc.l	Help1Txt7		;NEXTTEXT
		ds.l	0
Help1Txt7:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,71			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text7		;TEXT
		dc.l	Help1Txt8		;NEXTTEXT
		ds.l	0
Help1Txt8:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,81			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help1Text8		;TEXT
		dc.l	HelpTxt99		;NEXTTEXT
		ds.l	0

HelpTxt99:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	100,200			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	HelpText99		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

Help2Txt1:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,11			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text1		;TEXT
		dc.l	Help1Txt2		;NEXTTEXT
		ds.l	0
Help2Txt2:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,21			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text2		;TEXT
		dc.l	Help2Txt3		;NEXTTEXT
		ds.l	0
Help2Txt3:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,31			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text3		;TEXT
		dc.l	Help2Txt4		;NEXTTEXT
		ds.l	0
Help2Txt4:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,41			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text4		;TEXT
		dc.l	Help2Txt5		;NEXTTEXT
		ds.l	0
Help2Txt5:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,51			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text5		;TEXT
		dc.l	Help2Txt6		;NEXTTEXT
		ds.l	0
Help2Txt6:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,61			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text6		;TEXT
		dc.l	Help2Txt7		;NEXTTEXT
		ds.l	0
Help2Txt7:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,71			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text7		;TEXT
		dc.l	Help2Txt8		;NEXTTEXT
		ds.l	0
Help2Txt8:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,81			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text8		;TEXT
		dc.l	Help2Txt9		;NEXTTEXT
		ds.l	0
Help2Txt9:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,91			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text10		;TEXT
		dc.l	Help2Txt10		;NEXTTEXT
		ds.l	0
Help2Txt10:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,101			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help2Text10		;TEXT
		dc.l	HelpTxt99		;NEXTTEXT
		ds.l	0

Help3Txt1:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,11			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text1		;TEXT
		dc.l	Help3Txt2		;NEXTTEXT
		ds.l	0
Help3Txt2:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,21			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text2		;TEXT
		dc.l	Help3Txt3		;NEXTTEXT
		ds.l	0
Help3Txt3:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,31			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text3		;TEXT
		dc.l	Help3Txt4		;NEXTTEXT
		ds.l	0
Help3Txt4:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,41			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text4		;TEXT
		dc.l	Help3Txt5		;NEXTTEXT
		ds.l	0
Help3Txt5:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,51			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text5		;TEXT
		dc.l	Help3Txt6		;NEXTTEXT
		ds.l	0
Help3Txt6:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,61			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text6		;TEXT
		dc.l	Help3Txt7		;NEXTTEXT
		ds.l	0
Help3Txt7:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,71			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text7		;TEXT
		dc.l	Help3Txt8		;NEXTTEXT
		ds.l	0
Help3Txt8:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,81			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text8		;TEXT
		dc.l	Help3Txt9		;NEXTTEXT
		ds.l	0
Help3Txt9:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,91			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text10		;TEXT
		dc.l	Help3Txt10		;NEXTTEXT
		ds.l	0
Help3Txt10:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,101			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text10		;TEXT
		dc.l	Help3Txt11		;NEXTTEXT
		ds.l	0
Help3Txt11:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,111			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text11		;TEXT
		dc.l	Help3Txt12		;NEXTTEXT
		ds.l	0
Help3Txt12:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,121			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text12		;TEXT
		dc.l	Help3Txt13		;NEXTTEXT
		ds.l	0
Help3Txt13:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,131			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text13		;TEXT
		dc.l	Help3Txt14		;NEXTTEXT
		ds.l	0
Help3Txt14:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,141			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text14		;TEXT
		dc.l	Help3Txt15		;NEXTTEXT
		ds.l	0
Help3Txt15:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,151			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text15		;TEXT
		dc.l	Help3Txt16		;NEXTTEXT
		ds.l	0
Help3Txt16:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,161			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text16		;TEXT
		dc.l	Help3Txt17		;NEXTTEXT
		ds.l	0
Help3Txt17:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,171			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text17		;TEXT
		dc.l	Help3Txt18		;NEXTTEXT
		ds.l	0
Help3Txt18:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,181			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text18		;TEXT
		dc.l	Help3Txt19		;NEXTTEXT
		ds.l	0
Help3Txt19:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,191			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Help3Text19		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

Help1Text1:	dc.b	"Traffic-Lights help:",0
		ds.l	0                    
Help1Text2:	dc.b	"In the MAIN screen: Choose action from menus.",0
		ds.l	0
Help1Text3:	dc.b	"Options: City Map - The simulation itself",0
		ds.l	0
Help1Text4:	dc.b	"         Help     - This text. On 'HELP'-key also",0,0
		ds.l	0
Help1Text5:	dc.b	"         Load     - Load existing situation",0
		ds.l	0
Help1Text6:	dc.b	"         Save(as) - Save current situation",0
		ds.l	0
Help1Text7:	dc.b	"         About    - Copyright notice and",0
		ds.l	0
Help1Text8:	dc.b	"                    version information",0
		ds.l	0
Help1Text9:	dc.b	"         Quit     - Quit program",0
		ds.l	0
HelpText99:	dc.b	"PRESS 'Y' FOR MORE. YES OR NO TO QUIT.",0
		ds.l	0
Help2Text1:	dc.b	"Traffic-Lights help:",0
		ds.l	0                    
Help2Text2:	dc.b	"In the MAP window.",0
		ds.l	0
Help2Text3:	dc.b	"Keys:    Escape   - Quit variable ed and map",0
		ds.l	0
Help2Text4:	dc.b	"In the VARIABLE EDITOR window.",0
		ds.l	0
Help2Text5:	dc.b	"Menus:   Help     - This text. On 'HELP'-key also",0,0
		ds.l	0
Help2Text6:	dc.b	"         Load     - Load settings",0
		ds.l	0
Help2Text7:	dc.b	"         Save(as) - Save settings",0
		ds.l	0
Help2Text8:	dc.b	"         About    - Copyright notice and",0
		ds.l	0
Help2Text9:	dc.b	"                    version information",0
		ds.l	0
Help2Text10:	dc.b	"         Quit     - Quit variable ed and map",0
		ds.l	0
Help2Text11:	dc.b	"Keys:    Escape   - Quit variable ed and map",0
		ds.l	0
Help3Text1:	dc.b	"Traffic-Lights help:",0
		ds.l	0                    
Help3Text2:	dc.b	"In the VARIABLE EDITOR.",0
		ds.l	0
Help3Text3:	dc.b	"Gadgets (the little boxes):",0
		ds.l	0
Help3Text4:	dc.b	"'Red', 'Amber' and 'Green' are the lengths",0,0
		ds.l	0
Help3Text5:	dc.b	"for the corresponding traffic-lights. These",0
		ds.l	0
Help3Text6:	dc.b	"are for the horizontal direction.",0
		ds.l	0
Help3Text7:	dc.b	"'In' and 'Out' equal the time between vehicles",0
		ds.l	0
Help3Text8:	dc.b	"arriving and leaving.",0
		ds.l	0
Help3Text9:	dc.b	"'Max X' and 'Max Y' are the maximum amount of",0
		ds.l	0
Help3Text10:	dc.b	"vehicles on that axis.",0
		ds.l	0
Help3Text11:	dc.b	"The next 8 gadgets tell the possibility of a",0
		ds.l	0
Help3Text12:	dc.b	"vehicle to arrive to the corresponding road.",0
		ds.l	0
Help3Text13:	dc.b	"Roads are numbered clockwise, starting with",0
		ds.l	0
Help3Text14:	dc.b	"number 1 in the top lefthand corner.",0
		ds.l	0
Help3Text15:	dc.b	"The 4 big groups of gadgets tell the possibilities",0
		ds.l	0
Help3Text16:	dc.b	"of the vehicles turning or going straight.",0
		ds.l	0
Help3Text17:	dc.b	"The three buttons tell what 'time' it is.",0
		ds.l	0
Help3Text18:	dc.b	"Night means light traffic, day is medium traffic",0
		ds.l	0
Help3Text19:	dc.b	"and then heavy traffic is heavy traffic.",0
		ds.l	0

GadImage1:	dc.w	0,0			;Left,Top
		dc.w	16,11			;Sizes
		dc.w	1			;Depth
GI1:		dc.l	0			;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

GadImage2:	dc.w	0,0			;Left,Top
		dc.w	16,11			;Sizes
		dc.w	1			;Depth
GI2:		dc.l	0			;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0
		
GadImg1:	dc.w	$1f80,$30c0,$6060,$c030,$c030,$c030,$c030,$c030,$6060,$30c0,$1f80
GadImg2:	dc.w	$1f80,$30c0,$6660,$cf30,$cf30,$cf30,$cf30,$cf30,$6660,$30c0,$1f80

		ds.l	0

		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

FString:	dc.b	"%d",0
		ds.l	0
DStream:	dc.b	0,0,0
		ds.l	0
PutChData:	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;			M,a,x,., ,l,e,f,t, ,m,a,r,g,i,n, ,?,?,.,0

		ds.l	0
PutChProc:	move.b	d0,(a3)+
		rts

FString2:	dc.b	"%ld",0
		ds.l	0
DStream2:	dc.b	0,0,0,0,0,0
		ds.l	0
PutChData2:	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;			M,a,x,., ,l,e,f,t, ,m,a,r,g,i,n, ,?,?,.,0

		ds.l	0
PutChProc2:	move.b	d0,(a3)+
		rts

RandomTxt1:	dc.b	1,12			;PENS
		dc.w	4			;MODE
		dc.w	11,11			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	PutChData2		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0

ModeGadImage1:	dc.w	0,0			;Left,Top
		dc.w	16,11			;Sizes
		dc.w	1			;Depth
MoGI1:		dc.l	ModeGadImg1		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

ModeGadImage2:	dc.w	0,0			;Left,Top
		dc.w	16,11			;Sizes
		dc.w	1			;Depth
		dc.l	ModeGadImg2		;Image data
		dc.b	1,0			;PlanePick,PlaneOnOff
		dc.l	0			;Next image
		ds.l	0

		section	TLChipstuff,DATA,CHIP
		
ModeGadImg1:	dc.w	$1f80,$30c0,$6060,$c030,$c030,$c030,$c030,$c030,$6060,$30c0,$1f80
ModeGadImg2:	dc.w	$1f80,$30c0,$6660,$cf30,$cf30,$cf30,$cf30,$cf30,$6660,$30c0,$1f80

;Batch1 - Income 1

BorderLine1:	ds.w	2
CollMask1:	ds.w	32
BorderLine2:	ds.w	2
CollMask2:	ds.w	32
BorderLine3:	ds.w	2
CollMask3:	ds.w	32

;Batch2 - Income 2

BorderLine4:	ds.w	2
CollMask4:	ds.w	32
BorderLine5:	ds.w	2
CollMask5:	ds.w	32
BorderLine6:	ds.w	2
CollMask6:	ds.w	32

;Batch3 - Income 3

BorderLine7:	ds.w	2
CollMask7:	ds.w	32
BorderLine8:	ds.w	2
CollMask8:	ds.w	32
BorderLine9:	ds.w	2
CollMask9:	ds.w	32

;Batch4

BorderLine10:	ds.w	2
CollMask10:	ds.w	32
BorderLine11:	ds.w	2
CollMask11:	ds.w	32
BorderLine12:	ds.w	2
CollMask12:	ds.w	32

;Batch5

BorderLine13:	ds.w	2
CollMask13:	ds.w	32
BorderLine14:	ds.w	2
CollMask14:	ds.w	32
BorderLine15:	ds.w	2
CollMask15:	ds.w	32

;Batch6

BorderLine16:	ds.w	2
CollMask16:	ds.w	32
BorderLine17:	ds.w	2
CollMask17:	ds.w	32
BorderLine18:	ds.w	2
CollMask18:	ds.w	32

;Batch7

BorderLine19:	ds.w	2
CollMask19:	ds.w	32
BorderLine20:	ds.w	2
CollMask20:	ds.w	32
BorderLine21:	ds.w	2
CollMask21:	ds.w	32

;Batch8

BorderLine22:	ds.w	2
CollMask22:	ds.w	32
BorderLine23:	ds.w	2
CollMask23:	ds.w	32
BorderLine24:	ds.w	2
CollMask24:	ds.w	32

;Batch9 - Juctions

BorderLine25:	ds.w	2
CollMask25:	ds.w	32
BorderLine26:	ds.w	2
CollMask26:	ds.w	32
BorderLine27:	ds.w	2
CollMask27:	ds.w	32

;Batch10 - Junctions

BorderLine28:	ds.w	2
CollMask28:	ds.w	32
BorderLine29:	ds.w	2
CollMask29:	ds.w	32
BorderLine30:	ds.w	2
CollMask30:	ds.w	32

;Batch11 - Junctions

BorderLine31:	ds.w	2
CollMask31:	ds.w	32
BorderLine32:	ds.w	2
CollMask32:	ds.w	32
BorderLine33:	ds.w	2
CollMask33:	ds.w	32

;Batch12

BorderLine34:	ds.w	2
CollMask34:	ds.w	32
BorderLine35:	ds.w	2
CollMask35:	ds.w	32
BorderLine36:	ds.w	2
CollMask36:	ds.w	32

;Batch13

BorderLine37:	ds.w	2
CollMask37:	ds.w	32
BorderLine38:	ds.w	2
CollMask38:	ds.w	32
BorderLine39:	ds.w	2
CollMask39:	ds.w	32

;Batch14

BorderLine40:	ds.w	2
CollMask40:	ds.w	32
BorderLine41:	ds.w	2
CollMask41:	ds.w	32
BorderLine42:	ds.w	2
CollMask42:	ds.w	32

;Batch15

BorderLine43:	ds.w	2
CollMask43:	ds.w	32
BorderLine44:	ds.w	2
CollMask44:	ds.w	32
BorderLine45:	ds.w	2
CollMask45:	ds.w	32

;Batch16

BorderLine46:	ds.w	2
CollMask46:	ds.w	32
BorderLine47:	ds.w	2
CollMask47:	ds.w	32
BorderLine48:	ds.w	2
CollMask48:	ds.w	32

UpSprImg:	dc.w	%0000000000000000,%0111111111000000
		dc.w	%1011111110100000,%0100000001000000
		dc.w	%1111111111100000,%0011111110000000
		dc.w	%1011111110100000,%0100000001000000
		dc.w	%0010000010000000,%0101111101000000
		dc.w	%1010000010100000,%0101111101000000
		dc.w	%1111111111100000,%0000000000000000
		dc.w	%1010000010100000,%0101111101000000

DownSprImg:	dc.w	%0000010100000101,%0000001011111010
		dc.w	%0000011111111111,%0000000000000000
		dc.w	%0000010100000101,%0000001011111010
		dc.w	%0000000100000100,%0000001011111010
		dc.w	%0000010111111101,%0000001000000010
		dc.w	%0000011111111111,%0000000111111100
		dc.w	%0000010111111101,%0000001111111110
		dc.w	%0000000000000000,%0000001111111110

RightSprImg:	dc.w	%0011100111000000,%0000000000000000
		dc.w	%0001000010000000,%1110111101100000
		dc.w	%0111111111000000,%1100000011100000
		dc.w	%0001000111000000,%1110111011100000
		dc.w	%0111111111000000,%1100000011100000
		dc.w	%0001000010000000,%1110111101100000
		dc.w	%0011100111000000,%0000000000000000
		dc.w	%0000000000000000,%0000000000000000

LeftSprImg:	dc.w	%0000001110011100,%0000000000000000
		dc.w	%0000000100001000,%0000011011110111
		dc.w	%0000001111111110,%0000011100000011
		dc.w	%0000001110001000,%0000011101110111
		dc.w	%0000001111111110,%0000011100000011
		dc.w	%0000000100001000,%0000011011110111
		dc.w	%0000001110011100,%0000000000000000
		dc.w	%0000000000000000,%0000000000000000
		END
