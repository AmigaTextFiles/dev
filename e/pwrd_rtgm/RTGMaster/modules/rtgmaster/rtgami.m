/*
**     $VER: rtgAMI 1.006 (15 Jan 1998)
*/

MODULE	'rtgmaster/rtgsublibs',
			'rtgmaster/rtgmaster',
			'exec/libraries',
			'graphics/gfx',
			'graphics/rastport',
			'graphics/view',
			'intuition/screens'

OBJECT RtgBaseAMI
	LibBase:Library,
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
	DiskFontBase:PTR

OBJECT MyPort
	port:PTR TO MsgPort,
	signal:ULONG,
	MouseX:PTR TO WORD,
	MouseY:PTR TO WORD

OBJECT RtgScreenAMI
	Header:RtgScreen,
	Locks:UWORD,
	ScreenHandle:PTR TO Screen,
	PlaneSize:ULONG,
	DispBuf:ULONG,
	ChipMem1:ULONG,
	ChipMem2:ULONG,
	ChipMem3:ULONG,
	Bitmap1:BitMap,
	Bitmap2:BitMap,
	Bitmap3:BitMap,
	Flags:ULONG,
	MyRect:Rectangle,
	Place[52]:BYTE,
	RastPort1:RastPort,
	RastPort2:RastPort,
	RastPort3:RastPort,
	MyWindow:PTR,
	Pointer:PTR,
	PortData:MyPort,
	dbufinfo:PTR TO DBufInfo,
	DispBuf1:ULONG,
	DispBuf2:ULONG,
	DispBuf3:ULONG,
	SafeToWrite:ULONG,
	SafeToDisp:ULONG,
	SrcMode:ULONG,
	tempras:PTR,
	tempbm:PTR,
	wbcolors:PTR,
	Width:ULONG,
	Height:ULONG,
	colchanged:ULONG
