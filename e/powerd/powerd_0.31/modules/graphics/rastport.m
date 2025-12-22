MODULE 'graphics/regions','graphics/gfx','utility/hooks','graphics/clip'

OBJECT AreaInfo
	VctrTbl:PTR TO WORD,
	VctrPtr:PTR TO WORD,
	FlagTbl:PTR TO BYTE,
	FlagPtr:PTR TO BYTE,
	Count:WORD,
	MaxCount:WORD,
	FirstX:WORD,
	FirstY:WORD

OBJECT TmpRas
	RasPtr:PTR TO BYTE,
	Size:LONG

OBJECT GelsInfo
	sprRsrvd:BYTE,
	Flags:UBYTE,
	gelHead:PTR TO VS,
	gelTail:PTR TO VS,
	nextLine:PTR TO WORD,
	lastColor:PTR TO PTR TO WORD,
	collHandler:PTR TO collTable,
	leftmost:WORD,
	rightmost:WORD,
	topmost:WORD,
	bottommost:WORD,
	firstBlissObj:APTR,
	lastBlissObj:APTR

CONST	RPF_FRST_DOT=1,
		RPF_ONE_DOT=2,
		RPF_DBUFFER=4,
		RPF_AREAOUTLINE=8,
		RPF_NOCROSSFILL=$20,
		RP_JAM1=0,
		RP_JAM2=1,
		RP_COMPLEMENT=2,
		RP_INVERSVID=4,
		RPF_TXSCALE=1

CONST	RP_AREAPTRN=8,
		RP_MASK=24,
		RP_AOLPEN=27,
		RP_AREAPTSZ=29,
		RP_LINPATCNT=30,
		RP_FLAGS=32,
		RP_LINEPTRN=34

OBJECT RastPort
	Layer:PTR TO Layer,
	BitMap:PTR TO BitMap,
	AreaPtrn:PTR TO UWORD,
	TmpRas:PTR TO TmpRas,
	AreaInfo:PTR TO AreaInfo,
	GelsInfo:PTR TO GelsInfo,
	Mask:UBYTE,
	FgPen:BYTE,
	BgPen:BYTE,
	AOlPen:BYTE,
	DrawMode:BYTE,
	AreaPtSz:BYTE,
	linpatcnt:BYTE,
	dummy:BYTE,
	Flags:UWORD,
	LinePtrn:UWORD,
	cp_x:WORD,
	cp_y:WORD,
	minterms[8]:UBYTE,
	PenWidth:WORD,
	PenHeight:WORD,
	Font:PTR TO TextFont,
	AlgoStyle:UBYTE,
	TxFlags:UBYTE,
	TxHeight:UWORD,
	TxWidth:UWORD,
	TxBaseline:UWORD,
	TxSpacing:WORD,
	RP_User:PTR TO APTR,
	longreserved[2]:LONG,
	wordreserved[7]:UWORD,
	reserved[8]:UBYTE

CONST	ONE_DOTN=1,
		ONE_DOT=2,
		FRST_DOTN=0,
		FRST_DOT=1
