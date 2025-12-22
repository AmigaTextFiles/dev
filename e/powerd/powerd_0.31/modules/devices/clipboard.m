MODULE	'exec/devices',
			'exec/nodes',
			'exec/ports'

CONST	DEVICES_CLIPBOARD_I=1,
		CBD_POST=9,
		CBD_CURRENTREADID=10,
		CBD_CURRENTWRITEID=11,
		CBD_CHANGEHOOK=12,
		CBERR_OBSOLETEID=1

OBJECT ClipboardUnitPartial
	Node:LN,
	UnitNum:ULONG

OBJECT IOClipReq
	Message:MN,
	Device:PTR TO DD,
	Unit:PTR TO ClipboardUnitPartial,
	Command:UWORD,
	Flags:UBYTE,
	Error:BYTE,
	Actual:ULONG,
	Length:ULONG,
	Data:PTR TO UBYTE,
	Offset:ULONG,
	ClipID:LONG

CONST	PRIMARY_CLIP=0

OBJECT SatisfyMsg
	Msg:MN,
	Unit:UWORD,
	ClipID:LONG

OBJECT ClipHookMsg
	Type:ULONG,
	ChangeCmd:LONG,
	ClipID:LONG
