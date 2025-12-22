/* $VER: displayinfo.h 39.13 (31.5.1993) */
OPT NATIVE
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/monitor', /*'target/graphics/modeid',*/ 'target/utility/tagitem'
{MODULE 'graphics/displayinfo'}

TYPE DISPLAYINFOHANDLE IS ARRAY


/* datachunk type identifiers */

NATIVE {DTAG_DISP}		CONST DTAG_DISP		= $80000000
NATIVE {DTAG_DIMS}		CONST DTAG_DIMS		= $80001000
NATIVE {DTAG_MNTR}		CONST DTAG_MNTR		= $80002000
NATIVE {DTAG_NAME}		CONST DTAG_NAME		= $80003000
NATIVE {DTAG_VEC}		CONST DTAG_VEC		= $80004000	/* internal use only */

NATIVE {qh} OBJECT qh
	{structid}	structid	:ULONG	/* datachunk type identifier */
	{displayid}	displayid	:ULONG	/* copy of display record key	*/
	{skipid}	skipid	:ULONG		/* TAG_SKIP -- see tagitems.h */
	{length}	length	:ULONG		/* length of local data in double-longwords */
ENDOBJECT

NATIVE {displayinfo} OBJECT displayinfo
	{qh}	qh	:qh
	{notavailable}	notavailable	:UINT	/* if NULL available, else see defines */
	{propertyflags}	propertyflags	:ULONG	/* Properties of this mode see defines */
	{resolution}	resolution	:tpoint	/* ticks-per-pixel X/Y		       */
	{pixelspeed}	pixelspeed	:UINT	/* aproximation in nanoseconds	       */
	{numstdsprites}	numstdsprites	:UINT	/* number of standard amiga sprites    */
	{paletterange}	paletterange	:UINT	/* OBSOLETE - use Red/Green/Blue bits instead */
	{spriteresolution}	spriteresolution	:tpoint /* std sprite ticks-per-pixel X/Y    */
	{pad}	pad[4]	:ARRAY OF UBYTE		/* used internally */
	{redbits}	redbits	:UBYTE	/* number of Red bits this display supports (V39) */
	{greenbits}	greenbits	:UBYTE	/* number of Green bits this display supports (V39) */
	{bluebits}	bluebits	:UBYTE	/* number of Blue bits this display supports (V39) */
    {pad2a}	pad2a:UBYTE
	{pad2b}	pad2b[4]	:ARRAY OF UBYTE	/* find some use for this. */
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

NATIVE {DIPF_IS_DBUFFER}		CONST DIPF_IS_DBUFFER		= $00100000	/* can support double buffering */
NATIVE {DIPF_IS_PROGBEAM}	CONST DIPF_IS_PROGBEAM	= $00200000	/* is a programmed beam-sync mode */
NATIVE {DIPF_IS_FOREIGN}		CONST DIPF_IS_FOREIGN		= $80000000	/* this mode is not native to the Amiga */


NATIVE {dimensioninfo} OBJECT dimensioninfo
	{qh}	qh	:qh
	{maxdepth}	maxdepth	:UINT	      /* log2( max number of colors ) */
	{minrasterwidth}	minrasterwidth	:UINT       /* minimum width in pixels      */
	{minrasterheight}	minrasterheight	:UINT      /* minimum height in pixels     */
	{maxrasterwidth}	maxrasterwidth	:UINT       /* maximum width in pixels      */
	{maxrasterheight}	maxrasterheight	:UINT      /* maximum height in pixels     */
	{nominal}	nominal	:rectangle  /* "standard" dimensions	      */
	{maxoscan}	maxoscan	:rectangle /* fixed, hardware dependent    */
	{videooscan}	videooscan	:rectangle /* fixed, hardware dependent    */
	{txtoscan}	txtoscan	:rectangle /* editable via preferences     */
	{stdoscan}	stdoscan	:rectangle /* editable via preferences     */
	{pad}	pad[14]	:ARRAY OF UBYTE
	{reserved}	reserved[2]	:ARRAY OF ULONG	      /* terminator */
ENDOBJECT

NATIVE {monitorinfo} OBJECT monitorinfo
	{qh}	qh	:qh
	{mspc}	mspc	:PTR TO monitorspec   /* pointer to monitor specification  */
	{viewposition}	viewposition	:tpoint	      /* editable via preferences	   */
	{viewresolution}	viewresolution	:tpoint       /* standard monitor ticks-per-pixel  */
	{viewpositionrange}	viewpositionrange	:rectangle  /* fixed, hardware dependent */
	{totalrows}	totalrows	:UINT	      /* display height in scanlines	   */
	{totalcolorclocks}	totalcolorclocks	:UINT     /* scanline width in 280 ns units    */
	{minrow}	minrow	:UINT	      /* absolute minimum active scanline  */
	{compatibility}	compatibility	:INT	      /* how this coexists with others	   */
	{pad}	pad[32]	:ARRAY OF UBYTE
	{mouseticks}	mousetick	:tpoint
	{defaultviewposition}	defaultviewposition	:tpoint  /* original, never changes */
	{preferredmodeid}	preferredmodeid	:ULONG      /* for Preferences */
	{reserved}	reserved[2]	:ARRAY OF ULONG	      /* terminator */
ENDOBJECT

/* monitor compatibility */

NATIVE {MCOMPAT_MIXED}	CONST MCOMPAT_MIXED	= 0	/* can share display with other MCOMPAT_MIXED */
NATIVE {MCOMPAT_SELF}	CONST MCOMPAT_SELF	= 1	/* can share only within same monitor */
NATIVE {MCOMPAT_NOBODY} CONST MCOMPAT_NOBODY = -1	/* only one viewport at a time */

NATIVE {DISPLAYNAMELEN} CONST DISPLAYNAMELEN = 32

NATIVE {nameinfo} OBJECT nameinfo
	{qh}	qh	:qh
	{name}	name[DISPLAYNAMELEN]	:ARRAY OF UBYTE
	{reserved}	reserved[2]	:ARRAY OF ULONG	      /* terminator */
ENDOBJECT

/******************************************************************************/

/* The following VecInfo structure is PRIVATE, for our use only
 * Touch these, and burn! (V39)
 */

NATIVE {vecinfo} OBJECT vecinfo
	{qh}	qh	:qh
	{vec}	vec	:APTR
	{data}	data	:APTR
	{type}	type	:UINT
	{pad}	pad[3]	:ARRAY OF UINT
	{reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT
