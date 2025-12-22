/* $VER: cybergraphics.h 50.12 (13.08.2008) */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/tagitem', 'target/graphics/displayinfo'
MODULE 'target/exec/types', 'target/exec/nodes', 'target/graphics/gfx'
{#include <cybergraphx/cybergraphics.h>}
NATIVE {CYBERGRAPHX_CYBERGRAPHICS_H} CONST

NATIVE {CYBERGFXNAME}	CONST
#define CYBERGFXNAME cybergfxname
STATIC cybergfxname = 'cybergraphics.library'

NATIVE {CYBERGFX_INCLUDE_VERSION}  CONST CYBERGFX_INCLUDE_VERSION  = (41)

/*
 *  Definition of CyberModeNode (Returned in AllocModeList)
 *
 */

NATIVE {CyberModeNode} OBJECT cybermodenode
	{Node}	ln	:ln
	{ModeText}	modetext[DISPLAYNAMELEN]	:ARRAY OF CHAR        /* name for this mode */
	{DisplayID}	displayid	:ULONG                       /* display id associated with the node */
	{Width}	width	:UINT                           /* visible width */
	{Height}	height	:UINT                          /* visible height */
	{Depth}	depth	:UINT                           /* display depth */
	{DisplayTagList}	displaytaglist	:PTR TO tagitem         /* taglist with extended ModeID information */
ENDOBJECT


/*
 * Parameters for GetCyberMapAttr()
 *
 */

NATIVE {CYBRMATTR_XMOD}        CONST CYBRMATTR_XMOD        = ($80000001) /* function returns BytesPerRow if its called with this parameter */
NATIVE {CYBRMATTR_BPPIX}       CONST CYBRMATTR_BPPIX       = ($80000002) /* BytesPerPixel shall be returned */
NATIVE {CYBRMATTR_DISPADR}     CONST CYBRMATTR_DISPADR     = ($80000003) /* do not use this ! private tag */
NATIVE {CYBRMATTR_PIXFMT}      CONST CYBRMATTR_PIXFMT      = ($80000004) /* the pixel format is returned */
NATIVE {CYBRMATTR_WIDTH}       CONST CYBRMATTR_WIDTH       = ($80000005) /* returns width in pixels */
NATIVE {CYBRMATTR_HEIGHT}      CONST CYBRMATTR_HEIGHT      = ($80000006) /* returns height in lines */
NATIVE {CYBRMATTR_DEPTH}       CONST CYBRMATTR_DEPTH       = ($80000007) /* returns bits per pixel */
NATIVE {CYBRMATTR_ISCYBERGFX}  CONST CYBRMATTR_ISCYBERGFX  = ($80000008) /* returns -1 if supplied bitmap is a cybergfx one */
NATIVE {CYBRMATTR_ISLINEARMEM} CONST CYBRMATTR_ISLINEARMEM = ($80000009) /* returns -1 if supplied bitmap is linear accessable */
NATIVE {CYBRMATTR_COLORMAP}    CONST CYBRMATTR_COLORMAP    = ($8000000A) /* returns colormap associated with that bitmap (v50) */

/*
 * Parameters for GetCyberIDAttr()
 *
 */

NATIVE {CYBRIDATTR_PIXFMT} CONST CYBRIDATTR_PIXFMT = ($80000001) /* the pixel format is returned */
NATIVE {CYBRIDATTR_WIDTH}  CONST CYBRIDATTR_WIDTH  = ($80000002) /* returns visible width in pixels */
NATIVE {CYBRIDATTR_HEIGHT} CONST CYBRIDATTR_HEIGHT = ($80000003) /* returns visible height in lines */
NATIVE {CYBRIDATTR_DEPTH}  CONST CYBRIDATTR_DEPTH  = ($80000004) /* returns bits per pixel */
NATIVE {CYBRIDATTR_BPPIX}  CONST CYBRIDATTR_BPPIX  = ($80000005) /* BytesPerPixel shall be returned */

/*
 * Tags for CyberModeRequest()
 *
 */

NATIVE {CYBRMREQ_TB}          CONST CYBRMREQ_TB          = (TAG_USER+$40000)

/*
 * FilterTags
 *
 */

NATIVE {CYBRMREQ_MinDepth}    CONST CYBRMREQ_MINDEPTH    = (CYBRMREQ_TB+0)  /* Minimum depth for displayed screenmode */
NATIVE {CYBRMREQ_MaxDepth}    CONST CYBRMREQ_MAXDEPTH    = (CYBRMREQ_TB+1)  /* Maximum depth  "       "        " */
NATIVE {CYBRMREQ_MinWidth}    CONST CYBRMREQ_MINWIDTH    = (CYBRMREQ_TB+2)  /* Minumum width  "       "        " */
NATIVE {CYBRMREQ_MaxWidth}    CONST CYBRMREQ_MAXWIDTH    = (CYBRMREQ_TB+3)  /* Maximum width  "       "        " */
NATIVE {CYBRMREQ_MinHeight}   CONST CYBRMREQ_MINHEIGHT   = (CYBRMREQ_TB+4)  /* Minumum height "       "        " */
NATIVE {CYBRMREQ_MaxHeight}   CONST CYBRMREQ_MAXHEIGHT   = (CYBRMREQ_TB+5)  /* Minumum height "       "        " */
NATIVE {CYBRMREQ_CModelArray} CONST CYBRMREQ_CMODELARRAY = (CYBRMREQ_TB+6)

NATIVE {CYBRMREQ_WinTitle}    CONST CYBRMREQ_WINTITLE    = (CYBRMREQ_TB+20)
NATIVE {CYBRMREQ_OKText}      CONST CYBRMREQ_OKTEXT      = (CYBRMREQ_TB+21)
NATIVE {CYBRMREQ_CancelText}  CONST CYBRMREQ_CANCELTEXT  = (CYBRMREQ_TB+22)

NATIVE {CYBRMREQ_Screen}      CONST CYBRMREQ_SCREEN      = (CYBRMREQ_TB+30)  /* Screen you wish the Requester to open on */

/*
 * Tags for BestCyberModeID()
 *
 */

NATIVE {CYBRBIDTG_TB}  CONST CYBRBIDTG_TB  = (TAG_USER+$50000)

/* FilterTags */

NATIVE {CYBRBIDTG_Depth}         CONST CYBRBIDTG_DEPTH         = (CYBRBIDTG_TB+0)
NATIVE {CYBRBIDTG_NominalWidth}  CONST CYBRBIDTG_NOMINALWIDTH  = (CYBRBIDTG_TB+1)
NATIVE {CYBRBIDTG_NominalHeight} CONST CYBRBIDTG_NOMINALHEIGHT = (CYBRBIDTG_TB+2)
NATIVE {CYBRBIDTG_MonitorID}     CONST CYBRBIDTG_MONITORID     = (CYBRBIDTG_TB+3)
NATIVE {CYBRBIDTG_BoardName}     CONST CYBRBIDTG_BOARDNAME     = (CYBRBIDTG_TB+5)

/*
 * definition of drivers pixel formats
 *
 * Note: PIXFMT_BGR15, PIXFMT_BGR15PC, PIXFMT_BGR16 and PIXFMT_BGR16PC
 * aren't really supported by CyberGraphX, you should not use them as
 * pixel format for your bitmaps.
 */

NATIVE {PIXFMT_LUT8}     CONST PIXFMT_LUT8     = (0)
NATIVE {PIXFMT_RGB15}    CONST PIXFMT_RGB15    = (1)
NATIVE {PIXFMT_RGB15X}   CONST PIXFMT_RGB15X   = (2)  /* CGX4 used it as RRRRRGGG GGBBBBBX, CGX3 did not support it at all */
NATIVE {PIXFMT_BGR15}    CONST PIXFMT_BGR15    = (2)  /* NOTE: Source code compatibility only, really RGB15X */
NATIVE {PIXFMT_RGB15PC}  CONST PIXFMT_RGB15PC  = (3)
NATIVE {PIXFMT_BGR15PC}  CONST PIXFMT_BGR15PC  = (4)
NATIVE {PIXFMT_RGB16}    CONST PIXFMT_RGB16    = (5)
NATIVE {PIXFMT_BGR16}    CONST PIXFMT_BGR16    = (6)
NATIVE {PIXFMT_RGB16PC}  CONST PIXFMT_RGB16PC  = (7)
NATIVE {PIXFMT_BGR16PC}  CONST PIXFMT_BGR16PC  = (8)
NATIVE {PIXFMT_RGB24}    CONST PIXFMT_RGB24    = (9)
NATIVE {PIXFMT_BGR24}    CONST PIXFMT_BGR24    = (10)
NATIVE {PIXFMT_ARGB32}   CONST PIXFMT_ARGB32   = (11)
NATIVE {PIXFMT_BGRA32}   CONST PIXFMT_BGRA32   = (12)
NATIVE {PIXFMT_RGBA32}   CONST PIXFMT_RGBA32   = (13)


/*
 * SrcRectangle formats defines for xxxPixelArray calls()
 *
 */

NATIVE {RECTFMT_RGB}     CONST RECTFMT_RGB     = (0)
NATIVE {RECTFMT_RGBA}    CONST RECTFMT_RGBA    = (1)
NATIVE {RECTFMT_ARGB}    CONST RECTFMT_ARGB    = (2)
NATIVE {RECTFMT_LUT8}    CONST RECTFMT_LUT8    = (3)
NATIVE {RECTFMT_GREY8}   CONST RECTFMT_GREY8   = (4)
NATIVE {RECTFMT_RAW}     CONST RECTFMT_RAW     = (5)

/*
 * Parameters for CVideoCtrlTagList()
 *
 */

NATIVE {SETVC_DPMSLevel}  CONST SETVC_DPMSLEVEL  = ($88002001)

NATIVE {DPMS_ON}      CONST DPMS_ON      = (0)   /* Full operation                             */
NATIVE {DPMS_STANDBY} CONST DPMS_STANDBY = (1)   /* Optional state of minimal power reduction  */
NATIVE {DPMS_SUSPEND} CONST DPMS_SUSPEND = (2)   /* Significant reduction of power consumption */
NATIVE {DPMS_OFF}     CONST DPMS_OFF     = (3)   /* Lowest level of power consumption          */


/*
 * Tags for LockBitMapTagList()
 *
 */

NATIVE {LBMI_WIDTH}       CONST LBMI_WIDTH       = ($84001001)
NATIVE {LBMI_HEIGHT}      CONST LBMI_HEIGHT      = ($84001002)
NATIVE {LBMI_DEPTH}       CONST LBMI_DEPTH       = ($84001003)
NATIVE {LBMI_PIXFMT}      CONST LBMI_PIXFMT      = ($84001004)
NATIVE {LBMI_BYTESPERPIX} CONST LBMI_BYTESPERPIX = ($84001005)
NATIVE {LBMI_BYTESPERROW} CONST LBMI_BYTESPERROW = ($84001006)
NATIVE {LBMI_BASEADDRESS} CONST LBMI_BASEADDRESS = ($84001007)

/*
 * Tags for UnLockBitMapTagList()
 *
 */

NATIVE {UBMI_UPDATERECTS}        CONST UBMI_UPDATERECTS        = ($85001001)
NATIVE {UBMI_REALLYUNLOCK}       CONST UBMI_REALLYUNLOCK       = ($85001002)



/*
 * Message passed to the DoCDrawMethodTagList() hook function
 *
 */


NATIVE {CDrawMsg} OBJECT cdrawmsg
	{cdm_MemPtr}	memptr	:APTR
	{cdm_offx}	offx	:ULONG
	{cdm_offy}	offy	:ULONG
	{cdm_xsize}	xsize	:ULONG
	{cdm_ysize}	ysize	:ULONG
	{cdm_BytesPerRow}	bytesperrow	:UINT
	{cdm_BytesPerPix}	bytesperpix	:UINT
	{cdm_ColorModel}	colormodel	:UINT
ENDOBJECT

/*
 * Colour Table source formats for WriteLUTPixelArray()
 *
 */

NATIVE {CTABFMT_XRGB8}   CONST CTABFMT_XRGB8   = (0)   /* ULONG [] table */


/*
 * graphics.library/AllocBitMap() extended flags
 *
 */

NATIVE {BMB_SPECIALFMT} CONST BMB_SPECIALFMT = (7)
NATIVE {BMF_SPECIALFMT} CONST BMF_SPECIALFMT = (1 SHL BMB_SPECIALFMT)

NATIVE {SHIFT_PIXFMT} CONST	->SHIFT_PIXFMT( fmt ) (((ULONG)(fmt)) << 24)
#define SHIFT_PIXFMT(fmt) ((fmt) SHL 24)

NATIVE {BMF_REQUESTVMEM}  CONST BMF_REQUESTVMEM  = (BMF_MINPLANES OR BMF_DISPLAYABLE)	

NATIVE {BMB_ROOTMAP} CONST BMB_ROOTMAP = (5)
NATIVE {BMF_ROOTMAP} CONST BMF_ROOTMAP = (1 SHL BMB_ROOTMAP)

NATIVE {BMB_3DTARGET} CONST BMB_3DTARGET = (8)
NATIVE {BMF_3DTARGET} CONST BMF_3DTARGET = (1 SHL BMB_3DTARGET)

/*
 * Operations for ProcessPixelArray() (v50)
 *
 */

NATIVE {POP_BRIGHTEN}            CONST POP_BRIGHTEN            = 0
NATIVE {POP_DARKEN}              CONST POP_DARKEN              = 1
NATIVE {POP_SETALPHA}            CONST POP_SETALPHA            = 2
NATIVE {POP_TINT}                CONST POP_TINT                = 3
NATIVE {POP_BLUR}                CONST POP_BLUR                = 4
NATIVE {POP_COLOR2GREY}          CONST POP_COLOR2GREY          = 5
NATIVE {POP_NEGATIVE}            CONST POP_NEGATIVE            = 6
NATIVE {POP_NEGFADE}             CONST POP_NEGFADE             = 7
NATIVE {POP_TINTFADE}            CONST POP_TINTFADE            = 8
NATIVE {POP_GRADIENT}            CONST POP_GRADIENT            = 9
NATIVE {POP_SHIFTRGB}            CONST POP_SHIFTRGB            = 10

/*
 * Values for POP_SHIFTRGB
 *
 */

NATIVE {RGBSHIFT_BGR}             CONST RGBSHIFT_BGR             = (1)
NATIVE {RGBSHIFT_BRG}             CONST RGBSHIFT_BRG             = (2)
NATIVE {RGBSHIFT_GBR}             CONST RGBSHIFT_GBR             = (3)
NATIVE {RGBSHIFT_GRB}             CONST RGBSHIFT_GRB             = (4)
NATIVE {RGBSHIFT_RBG}             CONST RGBSHIFT_RBG             = (5)


/*
 * Tags for ProcessPixelArray() ops
 *
 */

NATIVE {PPAOPTAG_FADEFULLSCALE}  CONST PPAOPTAG_FADEFULLSCALE  = $85231020
NATIVE {PPAOPTAG_FADEOFFSET}     CONST PPAOPTAG_FADEOFFSET     = $85231021


NATIVE {PPAOPTAG_GRADIENTTYPE}                   CONST PPAOPTAG_GRADIENTTYPE                   = $85231022

NATIVE {GRADTYPE_HORIZONTAL}                     CONST GRADTYPE_HORIZONTAL                     = 0
NATIVE {GRADTYPE_VERTICAL}                       CONST GRADTYPE_VERTICAL                       = 1

/* yet unsupported gradient types follow */
NATIVE {GRADTYPE_RECTANGLE}                      CONST GRADTYPE_RECTANGLE                      = 2
NATIVE {GRADTYPE_LINEAR_ANGLE}                   CONST GRADTYPE_LINEAR_ANGLE                   = 3
NATIVE {GRADTYPE_RADIAL}                         CONST GRADTYPE_RADIAL                         = 4 /* "circle" center-based */

NATIVE {GRADIENT_NUMTYPES}                       CONST GRADIENT_NUMTYPES                       = 2

NATIVE {PPAOPTAG_GRADCOLOR1}                     CONST PPAOPTAG_GRADCOLOR1                     = $85231023
NATIVE {PPAOPTAG_GRADCOLOR2}                     CONST PPAOPTAG_GRADCOLOR2                     = $85231024

NATIVE {PPAOPTAG_GRADFULLSCALE}                  CONST PPAOPTAG_GRADFULLSCALE                  = PPAOPTAG_FADEFULLSCALE
NATIVE {PPAOPTAG_GRADOFFSET}                     CONST PPAOPTAG_GRADOFFSET                     = PPAOPTAG_FADEOFFSET

NATIVE {PPAOPTAG_RGBMASK}                        CONST PPAOPTAG_RGBMASK                        = $85231025

NATIVE {PPAOPTAG_GRADSYMCENTER}                  CONST PPAOPTAG_GRADSYMCENTER                  = $85231026

/*
 * Tags for BltBitMap(RastPort)Alpha() (v50)
 *
 */

NATIVE {BLTBMA_MIXLEVEL}         CONST BLTBMA_MIXLEVEL         = $88802000      /* from 0(0%) to $FFFFFFFF (100%) */
NATIVE {BLTBMA_USESOURCEALPHA}   CONST BLTBMA_USESOURCEALPHA   = $88802001
NATIVE {BLTBMA_GLOBALALPHA}      CONST BLTBMA_GLOBALALPHA      = BLTBMA_MIXLEVEL
NATIVE {BLTBMA_DESTALPHAVALUE}   CONST BLTBMA_DESTALPHAVALUE   = $88802002

NATIVE {DESTALPHAVALUE_UNDEFINED}    CONST DESTALPHAVALUE_UNDEFINED    = 0 /* default */
NATIVE {DESTALPHAVALUE_ONE}          CONST DESTALPHAVALUE_ONE          = 1
NATIVE {DESTALPHAVALUE_USESOURCE}    CONST DESTALPHAVALUE_USESOURCE    = 2
NATIVE {DESTALPHAVALUE_USEDEST}      CONST DESTALPHAVALUE_USEDEST      = 3
