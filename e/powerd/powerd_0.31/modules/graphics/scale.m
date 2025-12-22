MODULE	'graphics/gfx'

OBJECT BitScaleArgs
	SrcX:UWORD,
	SrcY:UWORD,
	SrcWidth:UWORD,
	SrcHeight:UWORD,
	XSrcFactor:UWORD,
	YSrcFactor:UWORD,
	DestX:UWORD,
	DestY:UWORD,
	DestWidth:UWORD,
	DestHeight:UWORD,
	XDestFactor:UWORD,
	YDestFactor:UWORD,
	SrcBitMap:PTR TO BitMap,
	DestBitMap:PTR TO BitMap,
	Flags:ULONG,
	XDDA:UWORD,
	YDDA:UWORD,
	Reserved1:ULONG,
	Reserved2:ULONG
