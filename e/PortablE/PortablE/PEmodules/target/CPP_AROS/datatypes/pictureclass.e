OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/datatypes/datatypes_shared'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse'
MODULE 'target/exec/types'
{#include <datatypes/pictureclass.h>}
NATIVE {DATATYPES_PICTURECLASS_H} CONST

NATIVE {PICTUREDTCLASS}          CONST
#define PICTUREDTCLASS picturedtclass
STATIC picturedtclass          = 'picture.datatype'

NATIVE {BitMapHeader} OBJECT bitmapheader
    {bmh_Width}	width	:UINT
    {bmh_Height}	height	:UINT
    {bmh_Left}	left	:INT
    {bmh_Top}	top	:INT
    {bmh_Depth}	depth	:UBYTE
    {bmh_Masking}	masking	:UBYTE
    {bmh_Compression}	compression	:UBYTE
    {bmh_Pad}	pad	:UBYTE
    {bmh_Transparent}	transparent	:UINT
    {bmh_XAspect}	xaspect	:UBYTE
    {bmh_YAspect}	yaspect	:UBYTE
    {bmh_PageWidth}	pagewidth	:INT
    {bmh_PageHeight}	pageheight	:INT
ENDOBJECT

NATIVE {ColorRegister} OBJECT colorregister
    {red}	red	:UBYTE
	{green}	green	:UBYTE
	{blue}	blue	:UBYTE
ENDOBJECT


NATIVE {PDTA_ModeID}             CONST PDTA_MODEID             = (DTA_DUMMY + 200)
NATIVE {PDTA_BitMapHeader}       CONST PDTA_BITMAPHEADER       = (DTA_DUMMY + 201)
NATIVE {PDTA_BitMap}             CONST PDTA_BITMAP             = (DTA_DUMMY + 202)
NATIVE {PDTA_ColorRegisters}     CONST PDTA_COLORREGISTERS     = (DTA_DUMMY + 203)
NATIVE {PDTA_CRegs}              CONST PDTA_CREGS              = (DTA_DUMMY + 204)
NATIVE {PDTA_GRegs}              CONST PDTA_GREGS              = (DTA_DUMMY + 205)
NATIVE {PDTA_ColorTable}         CONST PDTA_COLORTABLE         = (DTA_DUMMY + 206)
NATIVE {PDTA_ColorTable2}        CONST PDTA_COLORTABLE2        = (DTA_DUMMY + 207)
NATIVE {PDTA_Allocated}          CONST PDTA_ALLOCATED          = (DTA_DUMMY + 208)
NATIVE {PDTA_NumColors}          CONST PDTA_NUMCOLORS          = (DTA_DUMMY + 209)
NATIVE {PDTA_NumAlloc}           CONST PDTA_NUMALLOC           = (DTA_DUMMY + 210)
NATIVE {PDTA_Remap}              CONST PDTA_REMAP              = (DTA_DUMMY + 211)
NATIVE {PDTA_Screen}             CONST PDTA_SCREEN             = (DTA_DUMMY + 212)
NATIVE {PDTA_FreeSourceBitMap}   CONST PDTA_FREESOURCEBITMAP   = (DTA_DUMMY + 213)
NATIVE {PDTA_Grab}               CONST PDTA_GRAB               = (DTA_DUMMY + 214)
NATIVE {PDTA_DestBitMap}         CONST PDTA_DESTBITMAP         = (DTA_DUMMY + 215)
NATIVE {PDTA_ClassBitMap}        CONST PDTA_CLASSBITMAP        = (DTA_DUMMY + 216)
NATIVE {PDTA_NumSparse}          CONST PDTA_NUMSPARSE          = (DTA_DUMMY + 217)
NATIVE {PDTA_SparseTable}        CONST PDTA_SPARSETABLE        = (DTA_DUMMY + 218)

NATIVE {PDTA_SourceMode}		CONST PDTA_SOURCEMODE		= (DTA_DUMMY + 250) /* Set the interface mode for the sub datatype. See below. */
NATIVE {PDTA_DestMode}		CONST PDTA_DESTMODE		= (DTA_DUMMY + 251) /* Set the interface mode for the app datatype. See below. */
NATIVE {PDTA_UseFriendBitMap}	CONST PDTA_USEFRIENDBITMAP	= (DTA_DUMMY + 255) /* Make the allocated bitmap be a "friend" bitmap (BOOL) */

/* Interface modes */
NATIVE {PMODE_V42} CONST PMODE_V42 = (0)	/* Mode used for backward compatibility */
NATIVE {PMODE_V43} CONST PMODE_V43 = (1)	/* Use the new features*/


NATIVE {mskNone}                 CONST MSKNONE                 = 0
NATIVE {mskHasMask}              CONST MSKHASMASK              = 1
NATIVE {mskHasTransparentColor}  CONST MSKHASTRANSPARENTCOLOR  = 2
NATIVE {mskLasso}                CONST MSKLASSO                = 3
NATIVE {mskHasAlpha}             CONST MSKHASALPHA             = 4

NATIVE {cmpNone}                 CONST CMPNONE                 = 0
NATIVE {cmpByteRun1}             CONST CMPBYTERUN1             = 1
NATIVE {cmpByteRun2}             CONST CMPBYTERUN2             = 2


NATIVE {ID_ILBM}         CONST ID_ILBM         = "ILBM"
NATIVE {ID_BMHD}         CONST ID_BMHD         = "BMHD"
->"CONST ID_BODY" is on-purposely missing from here (it can be found in 'datatypes/datatypes_shared')
NATIVE {ID_CMAP}         CONST ID_CMAP         = "CMAP"
NATIVE {ID_CRNG}         CONST ID_CRNG         = "CRNG"
NATIVE {ID_GRAB}         CONST ID_GRAB         = "GRAB"
NATIVE {ID_SPRT}         CONST ID_SPRT         = "SPRT"
NATIVE {ID_DEST}         CONST ID_DEST         = "DEST"
NATIVE {ID_CAMG}         CONST ID_CAMG         = "CAMG"

/*
 *  Support for the V44 picture.datatype
 *
 *  It is not clear, if AROS should support AmigaOS3.5 .
 *
 *  But if you want V44-support define DT_V44_SUPPORT
 *
 *  Joerg Dietrich
 */
->#ifndef DT_V44_SUPPORT
NATIVE {DT_V44_SUPPORT} CONST ->DT_V44_SUPPORT = 1
->#endif

->#ifdef DT_V44_SUPPORT

->NATIVE {PMODE_V42} CONST PMODE_V42 = (0)
->NATIVE {PMODE_V43} CONST PMODE_V43 = (1)

NATIVE {PDTANUMPICTURES_Unknown} CONST PDTANUMPICTURES_UNKNOWN = (0)

NATIVE {PDTA_WhichPicture}       CONST PDTA_WHICHPICTURE       = (DTA_DUMMY + 219)
NATIVE {PDTA_GetNumPictures}     CONST PDTA_GETNUMPICTURES     = (DTA_DUMMY + 220)
NATIVE {PDTA_MaxDitherPens}      CONST PDTA_MAXDITHERPENS      = (DTA_DUMMY + 221)
NATIVE {PDTA_DitherQuality}      CONST PDTA_DITHERQUALITY      = (DTA_DUMMY + 222)
NATIVE {PDTA_AllocatedPens}      CONST PDTA_ALLOCATEDPENS      = (DTA_DUMMY + 223)
NATIVE {PDTA_ScaleQuality}	CONST PDTA_SCALEQUALITY	= (DTA_DUMMY + 224)
NATIVE {PDTA_DelayRead}		CONST PDTA_DELAYREAD		= (DTA_DUMMY + 225)
NATIVE {PDTA_DelayedRead}	CONST PDTA_DELAYEDREAD	= (DTA_DUMMY + 226)

->NATIVE {PDTA_SourceMode}         CONST PDTA_SOURCEMODE         = (DTA_DUMMY + 250)
->NATIVE {PDTA_DestMode}           CONST PDTA_DESTMODE           = (DTA_DUMMY + 251)
->NATIVE {PDTA_UseFriendBitMap}    CONST PDTA_USEFRIENDBITMAP    = (DTA_DUMMY + 255)
NATIVE {PDTA_MaskPlane}          CONST PDTA_MASKPLANE          = (DTA_DUMMY + 258)

NATIVE {PDTM_Dummy}              CONST PDTM_DUMMY              = (DTM_DUMMY + $60)
NATIVE {PDTM_WRITEPIXELARRAY}    CONST PDTM_WRITEPIXELARRAY    = (PDTM_DUMMY + 0)
NATIVE {PDTM_READPIXELARRAY}     CONST PDTM_READPIXELARRAY     = (PDTM_DUMMY + 1)
NATIVE {PDTM_SCALE}              CONST PDTM_SCALE              = (PDTM_DUMMY + 2)

NATIVE {pdtBlitPixelArray} OBJECT pdtblitpixelarray
	{MethodID}	methodid	:ULONG
	{pbpa_PixelData}	pixeldata	:APTR
	{pbpa_PixelFormat}	pixelformat	:ULONG
	{pbpa_PixelArrayMod}	pixelarraymod	:ULONG
	{pbpa_Left}	left	:ULONG
	{pbpa_Top}	top	:ULONG
	{pbpa_Width}	width	:ULONG
	{pbpa_Height}	height	:ULONG
ENDOBJECT

NATIVE {pdtScale} OBJECT pdtscale
	{MethodID}	methodid	:ULONG
	{ps_NewWidth}	newwidth	:ULONG
	{ps_NewHeight}	newheight	:ULONG
	{ps_Flags}	flags	:ULONG
ENDOBJECT

/* Flags for ps_Flags, for AROS only */
NATIVE {PScale_KeepAspect}	CONST PSCALE_KEEPASPECT	= $10	/* Keep aspect ratio when scaling, fit inside given x,y coordinates */


NATIVE {PBPAFMT_RGB}     CONST PBPAFMT_RGB     = 0
NATIVE {PBPAFMT_RGBA}    CONST PBPAFMT_RGBA    = 1
NATIVE {PBPAFMT_ARGB}    CONST PBPAFMT_ARGB    = 2
NATIVE {PBPAFMT_LUT8}    CONST PBPAFMT_LUT8    = 3
NATIVE {PBPAFMT_GREY8}   CONST PBPAFMT_GREY8   = 4

->#endif /* DT_V44_SUPPORT */
