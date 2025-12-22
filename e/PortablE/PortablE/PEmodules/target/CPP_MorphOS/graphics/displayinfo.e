/* $VER: displayinfo.h 39.13 (31.5.1993) */
OPT NATIVE
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/monitor', /*'target/graphics/modeid',*/ 'target/utility/tagitem'
{#include <graphics/displayinfo.h>}
NATIVE {GRAPHICS_DISPLAYINFO_H} CONST

TYPE DISPLAYINFOHANDLE IS NATIVE {DisplayInfoHandle} ARRAY


/* the "public" handle to a DisplayInfoRecord */

NATIVE {DisplayInfoHandle} CONST

/* datachunk type identifiers */

NATIVE {DTAG_DISP}		CONST DTAG_DISP		= $80000000
NATIVE {DTAG_DIMS}		CONST DTAG_DIMS		= $80001000
NATIVE {DTAG_MNTR}		CONST DTAG_MNTR		= $80002000
NATIVE {DTAG_NAME}		CONST DTAG_NAME		= $80003000
NATIVE {DTAG_VEC}		CONST DTAG_VEC		= $80004000	/* internal use only */

NATIVE {QueryHeader} OBJECT qh
	{StructID}	structid	:ULONG	/* datachunk type identifier */
	{DisplayID}	displayid	:ULONG	/* copy of display record key	*/
	{SkipID}	skipid	:ULONG		/* TAG_SKIP -- see tagitems.h */
	{Length}	length	:ULONG		/* length of local data in double-longwords */
ENDOBJECT

NATIVE {DisplayInfo} OBJECT displayinfo
	{Header}	qh	:qh
	{NotAvailable}	notavailable	:UINT	/* if NULL available, else see defines */
	{PropertyFlags}	propertyflags	:ULONG	/* Properties of this mode see defines */
	{Resolution}	resolution	:tpoint	/* ticks-per-pixel X/Y		       */
	{PixelSpeed}	pixelspeed	:UINT	/* aproximation in nanoseconds	       */
	{NumStdSprites}	numstdsprites	:UINT	/* number of standard amiga sprites    */
	{PaletteRange}	paletterange	:UINT	/* OBSOLETE - use Red/Green/Blue bits instead */
	{SpriteResolution}	spriteresolution	:tpoint /* std sprite ticks-per-pixel X/Y    */
	{pad}	pad[4]	:ARRAY OF UBYTE		/* used internally */
	{RedBits}	redbits	:UBYTE	/* number of Red bits this display supports (V39) */
	{GreenBits}	greenbits	:UBYTE	/* number of Green bits this display supports (V39) */
	{BlueBits}	bluebits	:UBYTE	/* number of Blue bits this display supports (V39) */
    {pad2[0]}	pad2a:UBYTE	->hack to fix typed lists
	{pad2}	pad2b[5]	:ARRAY OF UBYTE	/* find some use for this. */	->AmigaE split this into pad2a & pad2b for some reason
	{reserved}	reserved[2]	:ARRAY OF ULONG	/* terminator */
ENDOBJECT

/* availability */

NATIVE {DI_AVAIL_NOCHIPS}	CONST DI_AVAIL_NOCHIPS	= $0001
NATIVE {DI_AVAIL_NOMONITOR}	CONST DI_AVAIL_NOMONITOR	= $0002
NATIVE {DI_AVAIL_NOTWITHGENLOCK}	CONST DI_AVAIL_NOTWITHGENLOCK	= $0004

/* mode properties */

NATIVE {DIPF_IS_LACE}		CONST DIPF_IS_LACE		= $00000001
NATIVE {DIPF_IS_DUALPF}		CONST DIPF_IS_DUALPF		= $00000002
NATIVE {DIPF_IS_PF2PRI}		CONST DIPF_IS_PF2PRI		= $00000004
NATIVE {DIPF_IS_HAM}		CONST DIPF_IS_HAM		= $00000008

NATIVE {DIPF_IS_ECS}		CONST DIPF_IS_ECS		= $00000010	/* note: ECS modes (SHIRES, VGA, and **
											** PRODUCTIVITY) do not support      **
											** attached sprites.		     **
											*/
NATIVE {DIPF_IS_AA}		CONST DIPF_IS_AA		= $00010000	/* AA modes - may only be available
						** if machine has correct memory
						** type to support required
						** bandwidth - check availability.
						** (V39)
						*/
NATIVE {DIPF_IS_PAL}		CONST DIPF_IS_PAL		= $00000020
NATIVE {DIPF_IS_SPRITES}		CONST DIPF_IS_SPRITES		= $00000040
NATIVE {DIPF_IS_GENLOCK}		CONST DIPF_IS_GENLOCK		= $00000080

NATIVE {DIPF_IS_WB}		CONST DIPF_IS_WB		= $00000100
NATIVE {DIPF_IS_DRAGGABLE}	CONST DIPF_IS_DRAGGABLE	= $00000200
NATIVE {DIPF_IS_PANELLED}	CONST DIPF_IS_PANELLED	= $00000400
NATIVE {DIPF_IS_BEAMSYNC}	CONST DIPF_IS_BEAMSYNC	= $00000800

NATIVE {DIPF_IS_EXTRAHALFBRITE}	CONST DIPF_IS_EXTRAHALFBRITE	= $00001000

/* The following DIPF_IS_... flags are new for V39 */
NATIVE {DIPF_IS_SPRITES_ATT}		CONST DIPF_IS_SPRITES_ATT		= $00002000	/* supports attached sprites */
NATIVE {DIPF_IS_SPRITES_CHNG_RES}	CONST DIPF_IS_SPRITES_CHNG_RES	= $00004000	/* supports variable sprite resolution */
NATIVE {DIPF_IS_SPRITES_BORDER}		CONST DIPF_IS_SPRITES_BORDER		= $00008000	/* sprite can be displayed in the border */
NATIVE {DIPF_IS_SCANDBL}			CONST DIPF_IS_SCANDBL			= $00020000	/* scan doubled */
NATIVE {DIPF_IS_SPRITES_CHNG_BASE}	CONST DIPF_IS_SPRITES_CHNG_BASE	= $00040000
											/* can change the sprite base colour */
NATIVE {DIPF_IS_SPRITES_CHNG_PRI}	CONST DIPF_IS_SPRITES_CHNG_PRI	= $00080000
											/* can change the sprite priority
											** with respect to the playfield(s).
											*/
NATIVE {DIPF_IS_DBUFFER}		CONST DIPF_IS_DBUFFER		= $00100000	/* can support double buffering */
NATIVE {DIPF_IS_PROGBEAM}	CONST DIPF_IS_PROGBEAM	= $00200000	/* is a programmed beam-sync mode */
NATIVE {DIPF_IS_FOREIGN}		CONST DIPF_IS_FOREIGN		= $80000000	/* this mode is not native to the Amiga */


NATIVE {DimensionInfo} OBJECT dimensioninfo
	{Header}	qh	:qh
	{MaxDepth}	maxdepth	:UINT	      /* log2( max number of colors ) */
	{MinRasterWidth}	minrasterwidth	:UINT       /* minimum width in pixels      */
	{MinRasterHeight}	minrasterheight	:UINT      /* minimum height in pixels     */
	{MaxRasterWidth}	maxrasterwidth	:UINT       /* maximum width in pixels      */
	{MaxRasterHeight}	maxrasterheight	:UINT      /* maximum height in pixels     */
	{Nominal}	nominal	:rectangle  /* "standard" dimensions	      */
	{MaxOScan}	maxoscan	:rectangle /* fixed, hardware dependent    */
	{VideoOScan}	videooscan	:rectangle /* fixed, hardware dependent    */
	{TxtOScan}	txtoscan	:rectangle /* editable via preferences     */
	{StdOScan}	stdoscan	:rectangle /* editable via preferences     */
	{pad}	pad[14]	:ARRAY OF UBYTE
	{reserved}	reserved[2]	:ARRAY OF ULONG	      /* terminator */
ENDOBJECT

NATIVE {MonitorInfo} OBJECT monitorinfo
	{Header}	qh	:qh
	{Mspc}	mspc	:PTR TO monitorspec   /* pointer to monitor specification  */
	{ViewPosition}	viewposition	:tpoint	      /* editable via preferences	   */
	{ViewResolution}	viewresolution	:tpoint       /* standard monitor ticks-per-pixel  */
	{ViewPositionRange}	viewpositionrange	:rectangle  /* fixed, hardware dependent */
	{TotalRows}	totalrows	:UINT	      /* display height in scanlines	   */
	{TotalColorClocks}	totalcolorclocks	:UINT     /* scanline width in 280 ns units    */
	{MinRow}	minrow	:UINT	      /* absolute minimum active scanline  */
	{Compatibility}	compatibility	:INT	      /* how this coexists with others	   */
	{pad}	pad[32]	:ARRAY OF UBYTE
	{MouseTicks}	mousetick	:tpoint
	{DefaultViewPosition}	defaultviewposition	:tpoint  /* original, never changes */
	{PreferredModeID}	preferredmodeid	:ULONG      /* for Preferences */
	{reserved}	reserved[2]	:ARRAY OF ULONG	      /* terminator */
ENDOBJECT

/* monitor compatibility */

NATIVE {MCOMPAT_MIXED}	CONST MCOMPAT_MIXED	= 0	/* can share display with other MCOMPAT_MIXED */
NATIVE {MCOMPAT_SELF}	CONST MCOMPAT_SELF	= 1	/* can share only within same monitor */
NATIVE {MCOMPAT_NOBODY} CONST MCOMPAT_NOBODY = -1	/* only one viewport at a time */

NATIVE {DISPLAYNAMELEN} CONST DISPLAYNAMELEN = 32

NATIVE {NameInfo} OBJECT nameinfo
	{Header}	qh	:qh
	{Name}	name[DISPLAYNAMELEN]	:ARRAY OF UBYTE
	{reserved}	reserved[2]	:ARRAY OF ULONG	      /* terminator */
ENDOBJECT

/******************************************************************************/

/* The following VecInfo structure is PRIVATE, for our use only
 * Touch these, and burn! (V39)
 */

NATIVE {VecInfo} OBJECT vecinfo
	{Header}	qh	:qh
	{Vec}	vec	:APTR
	{Data}	data	:APTR
	{Type}	type	:UINT
	{pad}	pad[3]	:ARRAY OF UINT
	{reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT
