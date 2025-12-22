/*
**     $VER: rtgCGX.h 1.002 (15 Jan 1998)
*/

MODULE	'rtgmaster/rtgsublibs',
			'exec/libraries',
			'exec/ports',
			'graphics/view',
			'intuition/intuition'

OBJECT RtgBaseCGX
	CGXLibBase:Library,
	Pad1:UWORD,
	SegList:ULONG,
	ExecBase:PTR,
	UtilityBase:PTR,
	DosBase:PTR,
	CGXBase:PTR,
	GfxBase:PTR,
	IntBase:PTR,
	Flags:ULONG,
	ExpansionBase:PTR,
	DiskFontBase:PTR,
	LinkerDB:PTR

OBJECT MyPort
	port:PTR TO MsgPort,
	signal:ULONG,
	MouseX:PTR TO WORD,
	MouseY:PTR TO WORD

OBJECT RtgScreenCGX
	Header:RtgScreen,
	MyScreen:PTR,
	ActiveMap:ULONG,
	MapA:PTR,
	MapB:PTR,
	MapC:PTR,
	FrontMap:PTR,
	Bytes:ULONG,
	Width:ULONG,
	Height:UWORD,
	NumBuf:ULONG,
	Locks:UWORD,
	ModeID:ULONG,
	RealMapA:PTR TO BitMap,
	Tags[5]:ULONG,
	OffA:ULONG,
	OffB:ULONG,
	OffC:ULONG,
	MyWindow:PTR TO Window,
	PortData:MyPort,
	BPR:ULONG,
	dbi:PTR TO DBufInfo,
	SafeToWrite:ULONG,
	SafeToDisp:ULONG,
	Special:ULONG,
	SrcMode:ULONG,
	tempras:PTR,
	tempbm:PTR,
	wbcolors:PTR,
	colchanged:ULONG
