MODULE 'graphics/gfx','graphics/layers'


CONST NEWLOCKS=1

OBJECT Layer
	front:PTR TO Layer,
	back:PTR TO Layer,
	ClipRect:PTR TO ClipRect,
	rp|RP:PTR TO RastPort,
	bounds:Rectangle,
	reserved[4]:UBYTE,
	priority:UWORD,
	Flags:UWORD,
	SuperBitMap:PTR TO BitMap,
	SuperClipRect:PTR TO ClipRect,
	Window:APTR,
	Scroll_X:WORD,
	Scroll_Y:WORD,
	cr|CR:PTR TO ClipRect,
	cr2|CR2:PTR TO ClipRect,
	crnew|CRNew:PTR TO ClipRect,
	SuperSaveClipRects:PTR TO ClipRect,
	_cliprects:PTR TO ClipRect,
	LayerInfo:PTR TO Layer_Info,
	Lock:SS,
	BackFill:PTR TO Hook,
	reserved1:ULONG,
	ClipRegion:PTR TO Region,
	saveClipRects:PTR TO Region,
	reserved2[18]:UBYTE, /* 22 ??? */
	DamageList:PTR TO Region

OBJECT ClipRect
	Next:PTR TO ClipRect,
	Prev:PTR TO ClipRect,
	lobs:PTR TO Layer,
	BitMap:PTR TO BitMap,
	bounds:Rectangle,
	_p1:LONG,
	_p2:LONG,
	reserved:LONG,
	Flags:LONG

CONST	CR_NEEDS_NO_CONCEALED_RASTERS=1,
		CR_NEEDS_NO_LAYERBLIT_DAMAGE=2,
		ISLESSX=1,
		ISLESSY=2,
		ISGRTRX=4,
		ISGRTRY=8,
		LR_FRONT=0,
		LR_BACK=4,
		LR_RASTPORT=12,
		CR_PREV=4,
		CR_LOBS=8
