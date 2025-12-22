MODULE	'exec/libraries',
			'exec/nodes'

CONST	DISKFONT_GLYPH_I=1

OBJECT GlyphEngine
	Library:PTR TO Lib,
	Name:PTR TO CHAR

OBJECT GlyphMap
	BMModulo:UWORD,
	BMRows:UWORD,
	BlackLeft:UWORD,
	BlackTop:UWORD,
	BlackWidth:UWORD,
	BlackHeight:UWORD,
	XOrigin:LONG,
	YOrigin:LONG,
	X0:WORD,
	Y0:WORD,
	X1:WORD,
	Y1:WORD,
	Width:LONG,
	BitMap:PTR TO UBYTE

OBJECT GlyphWidthEntry
	Node:MLN,
	Code:UWORD,
	Width:LONG
