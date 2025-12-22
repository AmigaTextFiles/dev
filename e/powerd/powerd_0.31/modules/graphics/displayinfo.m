/*
**	$VER: displayinfo.h 39.13 (31.5.93)
**	Includes Release 40.15
**
**	include define file for displayinfo database
**
**	(C) Copyright 1985-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
*/

MODULE	'graphics/gfx',
			'graphics/monitor'

// datachunk type identifiers

CONST	DTAG_DISP=$80000000,
		DTAG_DIMS=$80001000,
		DTAG_MNTR=$80002000,
		DTAG_NAME=$80003000,
		DTAG_VEC =$80004000	// internal use only

OBJECT QueryHeader
	StructID:ULONG,		// datachunk type identifier
	DisplayID:ULONG,		// copy of display record key
	SkipID:ULONG,			// TAG_SKIP -- see tagitems.m
	Length:ULONG			// length of local data in double-longwords

OBJECT DisplayInfo
	Header:QueryHeader,
	NotAvailable:UWORD,		// if NULL available, else see defines
	PropertyFlags:ULONG,		// Properties of this mode see defines
	Resolution:tPoint,		// ticks-per-pixel X/Y
	PixelSpeed:UWORD,			// aproximation in nanoseconds
	NumStdSprites:UWORD,		// number of standard amiga sprites
	PaletteRange:UWORD,		// OBSOLETE - use Red/Green/Blue bits instead
	SpriteResolution:tPoint,// std sprite ticks-per-pixel X/Y
	pad[4]:UBYTE,				// used internally
	RedBits:UBYTE,				// number of Red bits this display supports (V39)
	GreenBits:UBYTE,			// number of Green bits this display supports (V39)
	BlueBits:UBYTE,			// number of Blue bits this display supports (V39)
	pad2[5]:UBYTE,				// find some use for this.
	reserved[2]:ULONG			// terminator

// availability
SET	DI_AVAIL_NOCHIPS,
		DI_AVAIL_NOMONITOR,
		DI_AVAIL_NOTWITHGENLOCK

// mode properties

CONST	DIPF_IS_LACE	=$00000001,
		DIPF_IS_DUALPF	=$00000002,
		DIPF_IS_PF2PRI	=$00000004,
		DIPF_IS_HAM		=$00000008,
		DIPF_IS_ECS		=$00000010,	// note: ECS modes (SHIRES, VGA, and
											// PRODUCTIVITY) do not support
											// attached sprites.
		DIPF_IS_AA		=$00010000,	// AA modes - may only be available
											// if machine has correct memory
											// type to support required
											// bandwidth - check availability.
											// (V39)
		DIPF_IS_PAL		=$00000020,
		DIPF_IS_SPRITES=$00000040,
		DIPF_IS_GENLOCK=$00000080,
		DIPF_IS_WB		=$00000100,
		DIPF_IS_DRAGGABLE	=$00000200,
		DIPF_IS_PANELLED	=$00000400,
		DIPF_IS_BEAMSYNC	=$00000800,
		DIPF_IS_EXTRAHALFBRITE	=$00001000,
// The following DIPF_IS_... flags are new for V39
		DIPF_IS_SPRITES_ATT		=$00002000,	// supports attached sprites
		DIPF_IS_SPRITES_CHNG_RES=$00004000,	// supports variable sprite resolution
		DIPF_IS_SPRITES_BORDER	=$00008000,	// sprite can be displayed in the border
		DIPF_IS_SCANDBL			=$00020000,	// scan doubled
		DIPF_IS_SPRITES_CHNG_BASE=$00040000,
										// can change the sprite base colour
		DIPF_IS_SPRITES_CHNG_PRI=$00080000,
										// can change the sprite priority
										// with respect to the playfield(s).
		DIPF_IS_DBUFFER	=$00100000,	// can support double buffering
		DIPF_IS_PROGBEAM	=$00200000,	// is a programmed beam-sync mode
		DIPF_IS_FOREIGN	=$80000000	// this mode is not native to the Amiga


OBJECT DimensionInfo
	Header:QueryHeader,
	MaxDepth:UWORD,			// log2( max number of colors )
	MinRasterWidth:UWORD,	// minimum width in pixels
	MinRasterHeight:UWORD,	// minimum height in pixels
	MaxRasterWidth:UWORD,	// maximum width in pixels
	MaxRasterHeight:UWORD,	// maximum height in pixels
	Nominal:Rectangle,		// "standard" dimensions
	MaxOScan:Rectangle,		// fixed, hardware dependent
	VideoOScan:Rectangle,	// fixed, hardware dependent
	TxtOScan:Rectangle,		// editable via preferences
	StdOScan:Rectangle,		// editable via preferences
	pad[14]:UBYTE,
	reserved[2]:ULONG			// terminator

OBJECT MonitorInfo
	Header:QueryHeader,
	Mspc:PTR TO MonitorSpec,		// pointer to monitor specification
	ViewPosition:tPoint,				// editable via preferences
	ViewResolution:tPoint,			// standard monitor ticks-per-pixel
	ViewPositionRange:Rectangle,  // fixed, hardware dependent
	TotalRows:UWORD,					// display height in scanlines
	TotalColorClocks:UWORD,			// scanline width in 280 ns units
	MinRow:UWORD,						// absolute minimum active scanline
	Compatibility:WORD,				// how this coexists with others
	pad[32]:UBYTE,
	MouseTicks:tPoint,
	DefaultViewPosition:tPoint,	// original, never changes
	PreferredModeID:ULONG,			// for Preferences
	reserved[2]:ULONG					// terminator

// monitor compatibility

CONST	MCOMPAT_MIXED =0,				// can share display with other MCOMPAT_MIXED
		MCOMPAT_SELF  =1,				// can share only within same monitor
		MCOMPAT_NOBODY=-1				// only one viewport at a time

CONST	DISPLAYNAMELEN=32

OBJECT NameInfo
	Header:QueryHeader,
	Name[DISPLAYNAMELEN]:UBYTE,
	reserved[2]:ULONG					// terminator

/******************************************************************************/

/* The following VecInfo structure is PRIVATE, for our use only
 * Touch these, and burn! (V39)
 */

OBJECT VecInfo
	Header:QueryHeader,
	Vec:APTR,
	Data:APTR,
	Type:UWORD,
	pad[3]:UWORD,
	reserved[2]:ULONG
