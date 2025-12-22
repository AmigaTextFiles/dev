/* $Id: displayinfo.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/graphics/gfx', /*'target/graphics/modeid',*/ 'target/graphics/monitor', 'target/utility/tagitem'
{#include <graphics/displayinfo.h>}
NATIVE {GRAPHICS_DISPLAYINFO_H} CONST

TYPE DISPLAYINFOHANDLE IS NATIVE {DisplayInfoHandle} ARRAY


NATIVE {DisplayInfoHandle} CONST

NATIVE {QueryHeader} OBJECT qh
    {StructID}	structid	:ULONG
    {DisplayID}	displayid	:ULONG
    {SkipID}	skipid	:ULONG
    {Length}	length	:ULONG
ENDOBJECT

NATIVE {DisplayInfo} OBJECT displayinfo
    {Header}	qh	:qh

    {NotAvailable}	notavailable	:UINT     /* ==0 means DisplayInfo is available
                               !=0 means not available (see below) */
    {PropertyFlags}	propertyflags	:ULONG    /* see below */
    {Resolution}	resolution	:tpoint
    {PixelSpeed}	pixelspeed	:UINT
    {NumStdSprites}	numstdsprites	:UINT
    {PaletteRange}	paletterange	:UINT
    {SpriteResolution}	spriteresolution	:tpoint
    {pad}	pad[4]	:ARRAY OF UBYTE
    {RedBits}	redbits	:UBYTE
    {GreenBits}	greenbits	:UBYTE
    {BlueBits}	bluebits	:UBYTE
    {pad2[0]}	pad2a:UBYTE	->hack to fix typed lists
    {pad2}	pad2b[5]	:ARRAY OF UBYTE
    {reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT

/* NotAvailable */
NATIVE {DI_AVAIL_NOCHIPS}        CONST DI_AVAIL_NOCHIPS        = $1
NATIVE {DI_AVAIL_NOMONITOR}      CONST DI_AVAIL_NOMONITOR      = $2
NATIVE {DI_AVAIL_NOTWITHGENLOCK} CONST DI_AVAIL_NOTWITHGENLOCK = $4

/* PropertyFlags */
NATIVE {DIPF_IS_LACE}              CONST DIPF_IS_LACE              = $1
NATIVE {DIPF_IS_DUALPF}            CONST DIPF_IS_DUALPF            = $2
NATIVE {DIPF_IS_PF2PRI}            CONST DIPF_IS_PF2PRI            = $4
NATIVE {DIPF_IS_HAM}               CONST DIPF_IS_HAM               = $8
NATIVE {DIPF_IS_ECS}               CONST DIPF_IS_ECS               = $10
NATIVE {DIPF_IS_PAL}               CONST DIPF_IS_PAL               = $20
NATIVE {DIPF_IS_SPRITES}           CONST DIPF_IS_SPRITES           = $40
NATIVE {DIPF_IS_GENLOCK}           CONST DIPF_IS_GENLOCK           = $80
NATIVE {DIPF_IS_WB}                CONST DIPF_IS_WB                = $100
NATIVE {DIPF_IS_DRAGGABLE}         CONST DIPF_IS_DRAGGABLE         = $200
NATIVE {DIPF_IS_PANELLED}          CONST DIPF_IS_PANELLED          = $400
NATIVE {DIPF_IS_BEAMSYNC}          CONST DIPF_IS_BEAMSYNC          = $800
NATIVE {DIPF_IS_EXTRAHALFBRITE}    CONST DIPF_IS_EXTRAHALFBRITE    = $1000
NATIVE {DIPF_IS_SPRITES_ATT}       CONST DIPF_IS_SPRITES_ATT       = $2000
NATIVE {DIPF_IS_SPRITES_CHNG_RES}  CONST DIPF_IS_SPRITES_CHNG_RES  = $4000
NATIVE {DIPF_IS_SPRITES_BORDER}    CONST DIPF_IS_SPRITES_BORDER    = $8000
NATIVE {DIPF_IS_AA}                CONST DIPF_IS_AA                = $10000
NATIVE {DIPF_IS_SCANDBL}           CONST DIPF_IS_SCANDBL           = $20000
NATIVE {DIPF_IS_SPRITES_CHNG_BASE} CONST DIPF_IS_SPRITES_CHNG_BASE = $40000
NATIVE {DIPF_IS_SPRITES_CHNG_PRI}  CONST DIPF_IS_SPRITES_CHNG_PRI  = $80000
NATIVE {DIPF_IS_DBUFFER}           CONST DIPF_IS_DBUFFER           = $100000
NATIVE {DIPF_IS_PROGBEAM}          CONST DIPF_IS_PROGBEAM          = $200000
NATIVE {DIPF_IS_FOREIGN}           CONST DIPF_IS_FOREIGN           = $80000000

NATIVE {DimensionInfo} OBJECT dimensioninfo
    {Header}	qh	:qh

    {MaxDepth}	maxdepth	:UINT
    {MinRasterWidth}	minrasterwidth	:UINT
    {MinRasterHeight}	minrasterheight	:UINT
    {MaxRasterWidth}	maxrasterwidth	:UINT
    {MaxRasterHeight}	maxrasterheight	:UINT

    {Nominal}	nominal	:rectangle
    {MaxOScan}	maxoscan	:rectangle
    {VideoOScan}	videooscan	:rectangle
    {TxtOScan}	txtoscan	:rectangle
    {StdOScan}	stdoscan	:rectangle

    {pad}	pad[14]	:ARRAY OF UBYTE
    {reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT

NATIVE {MonitorInfo} OBJECT monitorinfo
    {Header}	qh	:qh

    {Mspc}	mspc	:PTR TO monitorspec
    {ViewPosition}	viewposition	:tpoint
    {ViewResolution}	viewresolution	:tpoint
    {ViewPositionRange}	viewpositionrange	:rectangle
    {TotalRows}	totalrows	:UINT
    {TotalColorClocks}	totalcolorclocks	:UINT
    {MinRow}	minrow	:UINT
    {Compatibility}	compatibility	:INT       /* see below */
    {pad}	pad[32]	:ARRAY OF UBYTE
    {MouseTicks}	mousetick	:tpoint
    {DefaultViewPosition}	defaultviewposition	:tpoint
    {PreferredModeID}	preferredmodeid	:ULONG
    {reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT

/* Compability */
NATIVE {MCOMPAT_NOBODY} CONST MCOMPAT_NOBODY = -1
NATIVE {MCOMPAT_MIXED}   CONST MCOMPAT_MIXED   = 0
NATIVE {MCOMPAT_SELF}    CONST MCOMPAT_SELF    = 1

NATIVE {DISPLAYNAMELEN} CONST DISPLAYNAMELEN = 32
NATIVE {NameInfo} OBJECT nameinfo
    {Header}	qh	:qh

    {Name}	name[DISPLAYNAMELEN]	:ARRAY OF UBYTE
    {reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT

/* Tags */
NATIVE {DTAG_DISP} CONST DTAG_DISP = (TAG_USER)
NATIVE {DTAG_DIMS} CONST DTAG_DIMS = (TAG_USER + $1000)
NATIVE {DTAG_MNTR} CONST DTAG_MNTR = (TAG_USER + $2000)
NATIVE {DTAG_NAME} CONST DTAG_NAME = (TAG_USER + $3000)
NATIVE {DTAG_VEC}  CONST DTAG_VEC  = (TAG_USER + $4000)

/* PRIVATE */
NATIVE {VecInfo} OBJECT vecinfo
    {Header}	qh	:qh

    {Vec}	vec	:APTR
    {Data}	data	:APTR
    {Type}	type	:UINT
    {pad}	pad[3]	:ARRAY OF UINT
    {reserved}	reserved[2]	:ARRAY OF ULONG
ENDOBJECT
