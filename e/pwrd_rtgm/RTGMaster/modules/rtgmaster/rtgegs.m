/*
**     $VER: rtgEGS.h 1.004 (15 Jan 1998)
*/

MODULE	'rtgmaster/rtgsublibs',
			'exec/libraries',
			'exec/ports'

OBJECT RtgBaseEGS
	EGSLibBase:Library,
	Pad1:UWORD,
	SegList:ULONG,
	ExecBase:PTR,
	UtilityBase:PTR,
	DosBase:PTR,
	EgsBase:PTR,
	EgsBlitBase:PTR,
	GFXBase:PTR,
	Flags:ULONG,
	EgsGfxBase:PTR,
	ExpansionBase:PTR

OBJECT MyPort
	port:PTR TO MsgPort,
	signal:ULONG,
	MouseX:PTR TO WORD,
	MouseY:PTR TO WORD

OBJECT RtgScreenEGS
	Header:RtgScreen,
	MyScreen:PTR,
	ActiveMap:ULONG,
	MapA:PTR,
	MapB:PTR,
	MapC:PTR,
	FrontMap:PTR,
	Bytes:ULONG,
	Width:ULONG,
	Type:ULONG,
	NumBuf:ULONG,
	Locks:UWORD,
	RastPort1:PTR,
	RastPort2:PTR,
	RastPort3:PTR,
	Pointer[28]:UBYTE,
	PointerA[256]:UBYTE,
	PointerB[1024]:UBYTE,
	PointerC[28]:UBYTE,
	PortData:MyPort
