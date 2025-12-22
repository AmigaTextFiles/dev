/* $Id: screens.h 25583 2007-03-26 23:38:53Z dariusb $ */
OPT NATIVE
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/types', 'target/graphics/clip', 'target/graphics/gfx', 'target/graphics/layers', 'target/graphics/rastport', 'target/graphics/view', 'target/utility/tagitem'
MODULE 'target/graphics/text', 'target/exec/nodes', 'target/exec/tasks'
{#include <intuition/screens.h>}
NATIVE {INTUITION_SCREENS_H} CONST

->"OBJECT screen" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {NewScreen} OBJECT ns
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {Depth}	depth	:INT
    {DetailPen}	detailpen	:UBYTE
    {BlockPen}	blockpen	:UBYTE

    {ViewModes}	viewmodes	:UINT
    {Type}	type	:UINT      /* see below */

    {Font}	font	:PTR TO textattr
    {DefaultTitle}	defaulttitle	:ARRAY OF UBYTE
    {Gadgets}	gadgets	:PTR TO gadget
    {CustomBitMap}	custombitmap	:PTR TO bitmap
ENDOBJECT

NATIVE {ExtNewScreen} OBJECT extnewscreen
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {Depth}	depth	:INT
    {DetailPen}	detailpen	:UBYTE
    {BlockPen}	blockpen	:UBYTE

    {ViewModes}	viewmodes	:UINT
    {Type}	type	:UINT      /* see below */

    {Font}	font	:PTR TO textattr
    {DefaultTitle}	defaulttitle	:ARRAY OF UBYTE
    {Gadgets}	gadgets	:PTR TO gadget
    {CustomBitMap}	custombitmap	:PTR TO bitmap

/* ExtNewScreen specific extension */
    {Extension}	extension	:ARRAY OF tagitem /* see below */
ENDOBJECT

/* Screen->Flags and (Ext)NewScreen->Type*/
NATIVE {WBENCHSCREEN} CONST WBENCHSCREEN = $1
NATIVE {PUBLICSCREEN} CONST PUBLICSCREEN = $2
NATIVE {CUSTOMSCREEN} CONST CUSTOMSCREEN = $000F
NATIVE {SCREENTYPE}   CONST SCREENTYPE   = $000F
/* Screen->Flags */
NATIVE {SHOWTITLE}    CONST SHOWTITLE    = $10
NATIVE {BEEPING}      CONST BEEPING      = $20
NATIVE {CUSTOMBITMAP} CONST CUSTOMBITMAP = $40
NATIVE {SCREENBEHIND} CONST SCREENBEHIND = $80
NATIVE {SCREENQUIET}  CONST SCREENQUIET  = $100
NATIVE {SCREENHIRES}  CONST SCREENHIRES  = $200
NATIVE {PENSHARED}    CONST PENSHARED    = $400
NATIVE {NS_EXTENDED}  CONST NS_EXTENDED  = $1000
NATIVE {AUTOSCROLL}   CONST AUTOSCROLL   = $4000

/* Height */
NATIVE {STDSCREENHEIGHT} CONST STDSCREENHEIGHT = -1
/* Width */
NATIVE {STDSCREENWIDTH}  CONST STDSCREENWIDTH  = -1

/* ExtNewScreen->Extension (Tags) */
NATIVE {SA_Dummy}     CONST SA_DUMMY     = (TAG_USER + 32)
NATIVE {SA_Left}      CONST SA_LEFT      = (SA_DUMMY + 1)
NATIVE {SA_Top}       CONST SA_TOP       = (SA_DUMMY + 2)
NATIVE {SA_Width}     CONST SA_WIDTH     = (SA_DUMMY + 3)
NATIVE {SA_Height}    CONST SA_HEIGHT    = (SA_DUMMY + 4)
NATIVE {SA_Depth}     CONST SA_DEPTH     = (SA_DUMMY + 5)
NATIVE {SA_DetailPen} CONST SA_DETAILPEN = (SA_DUMMY + 6)
NATIVE {SA_BlockPen}  CONST SA_BLOCKPEN  = (SA_DUMMY + 7)
NATIVE {SA_Title}     CONST SA_TITLE     = (SA_DUMMY + 8)
NATIVE {SA_Colors}    CONST SA_COLORS    = (SA_DUMMY + 9)
NATIVE {SA_ErrorCode} CONST SA_ERRORCODE = (SA_DUMMY + 10)
NATIVE {SA_Font}      CONST SA_FONT      = (SA_DUMMY + 11)
NATIVE {SA_SysFont}   CONST SA_SYSFONT   = (SA_DUMMY + 12)
NATIVE {SA_Type}      CONST SA_TYPE      = (SA_DUMMY + 13)
NATIVE {SA_BitMap}    CONST SA_BITMAP    = (SA_DUMMY + 14)
NATIVE {SA_PubName}   CONST SA_PUBNAME   = (SA_DUMMY + 15)
NATIVE {SA_PubSig}    CONST SA_PUBSIG    = (SA_DUMMY + 16)
NATIVE {SA_PubTask}   CONST SA_PUBTASK   = (SA_DUMMY + 17)
NATIVE {SA_DisplayID} CONST SA_DISPLAYID = (SA_DUMMY + 18)
NATIVE {SA_DClip}     CONST SA_DCLIP     = (SA_DUMMY + 19)
NATIVE {SA_Overscan}  CONST SA_OVERSCAN  = (SA_DUMMY + 20) /* see below */

NATIVE {SA_ShowTitle}       CONST SA_SHOWTITLE       = (SA_DUMMY + 22)
NATIVE {SA_Behind}          CONST SA_BEHIND          = (SA_DUMMY + 23)
NATIVE {SA_Quiet}           CONST SA_QUIET           = (SA_DUMMY + 24)
NATIVE {SA_AutoScroll}      CONST SA_AUTOSCROLL      = (SA_DUMMY + 25)
NATIVE {SA_Pens}            CONST SA_PENS            = (SA_DUMMY + 26)
NATIVE {SA_FullPalette}     CONST SA_FULLPALETTE     = (SA_DUMMY + 27)
NATIVE {SA_ColorMapEntries} CONST SA_COLORMAPENTRIES = (SA_DUMMY + 28)
NATIVE {SA_Parent}          CONST SA_PARENT          = (SA_DUMMY + 29)
NATIVE {SA_Draggable}       CONST SA_DRAGGABLE       = (SA_DUMMY + 30)
NATIVE {SA_Exclusive}       CONST SA_EXCLUSIVE       = (SA_DUMMY + 31)
NATIVE {SA_SharePens}       CONST SA_SHAREPENS       = (SA_DUMMY + 32)
NATIVE {SA_BackFill}        CONST SA_BACKFILL        = (SA_DUMMY + 33)
NATIVE {SA_Interleaved}     CONST SA_INTERLEAVED     = (SA_DUMMY + 34)
NATIVE {SA_Colors32}        CONST SA_COLORS32        = (SA_DUMMY + 35)
NATIVE {SA_VideoControl}    CONST SA_VIDEOCONTROL    = (SA_DUMMY + 36)
NATIVE {SA_FrontChild}      CONST SA_FRONTCHILD      = (SA_DUMMY + 37)
NATIVE {SA_BackChild}       CONST SA_BACKCHILD       = (SA_DUMMY + 38)
NATIVE {SA_LikeWorkbench}   CONST SA_LIKEWORKBENCH   = (SA_DUMMY + 39)
NATIVE {SA_MinimizeISG}     CONST SA_MINIMIZEISG     = (SA_DUMMY + 41)
NATIVE {SA_ID}              CONST SA_ID              = (SA_DUMMY + 42)

/* SA_Overscan */
NATIVE {OSCAN_TEXT}     CONST OSCAN_TEXT     = 1
NATIVE {OSCAN_STANDARD} CONST OSCAN_STANDARD = 2
NATIVE {OSCAN_MAX}      CONST OSCAN_MAX      = 3
NATIVE {OSCAN_VIDEO}    CONST OSCAN_VIDEO    = 4

                            /* Public Screens */

NATIVE {PubScreenNode} OBJECT pubscreennode
    {psn_Node}	ln	:ln

    {psn_Screen}	screen	:PTR TO screen
    {psn_Flags}	flags	:UINT        /* see below */
    {psn_Size}	size	:INT
    {psn_VisitorCount}	visitorcount	:INT
    {psn_SigTask}	sigtask	:PTR TO tc
    {psn_SigBit}	sigbit	:UBYTE
ENDOBJECT

/* psn_Flags */
NATIVE {PSNF_PRIVATE} CONST PSNF_PRIVATE = $1

/* Maximum length of public screen names. The buffers containing these strings
   must have a length of MAXPUBSCREENNAME+1. */   
NATIVE {MAXPUBSCREENNAME} CONST MAXPUBSCREENNAME = 139

NATIVE {SHANGHAI}     CONST SHANGHAI     = $1
NATIVE {POPPUBSCREEN} CONST POPPUBSCREEN = $2

                         /* Screen functions */

/* AllocScreenBuffer() */
NATIVE {SB_SCREEN_BITMAP} CONST SB_SCREEN_BITMAP = 1
NATIVE {SB_COPY_BITMAP}   CONST SB_COPY_BITMAP   = 2

NATIVE {ScreenBuffer} OBJECT screenbuffer
    {sb_BitMap}	bitmap	:PTR TO bitmap
    {sb_DBufInfo}	dbufinfo	:PTR TO dbufinfo
ENDOBJECT

/* ScreenDepth() */
NATIVE {SDEPTH_TOFRONT}  CONST SDEPTH_TOFRONT  = 0
NATIVE {SDEPTH_TOBACK}   CONST SDEPTH_TOBACK   = 1
NATIVE {SDEPTH_INFAMILY} CONST SDEPTH_INFAMILY = 2

/* ScreenPosition() */
NATIVE {SPOS_RELATIVE}    CONST SPOS_RELATIVE    = $00
NATIVE {SPOS_ABSOLUTE}    CONST SPOS_ABSOLUTE    = $1
NATIVE {SPOS_MAKEVISIBLE} CONST SPOS_MAKEVISIBLE = $2
NATIVE {SPOS_FORCEDRAG}   CONST SPOS_FORCEDRAG   = $4

                            /* Draw Info */

->"OBJECT drawinfo" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* dri_Version */
NATIVE {DRI_VERSION} CONST DRI_VERSION = 2

/* dri_Flags */
NATIVE {DRIF_NEWLOOK} CONST DRIF_NEWLOOK = $1
NATIVE {DRIF_DIRECTCOLOR} CONST DRIF_DIRECTCOLOR = $2

/* dri_Pens */
NATIVE {DETAILPEN}        CONST DETAILPEN        = 0
NATIVE {BLOCKPEN}         CONST BLOCKPEN         = 1
NATIVE {TEXTPEN}          CONST TEXTPEN          = 2
NATIVE {SHINEPEN}         CONST SHINEPEN         = 3
NATIVE {SHADOWPEN}        CONST SHADOWPEN        = 4
NATIVE {FILLPEN}          CONST FILLPEN          = 5
NATIVE {FILLTEXTPEN}      CONST FILLTEXTPEN      = 6
NATIVE {BACKGROUNDPEN}    CONST BACKGROUNDPEN    = 7
NATIVE {HIGHLIGHTTEXTPEN} CONST HIGHLIGHTTEXTPEN = 8
NATIVE {BARDETAILPEN}     CONST BARDETAILPEN     = 9
NATIVE {BARBLOCKPEN}      CONST BARBLOCKPEN      = 10
NATIVE {BARTRIMPEN}       CONST BARTRIMPEN       = 11
NATIVE {NUMDRIPENS}       CONST NUMDRIPENS       = 12

NATIVE {PEN_C0} CONST PEN_C0 = $FEFF
NATIVE {PEN_C1} CONST PEN_C1 = $FEFE
NATIVE {PEN_C2} CONST PEN_C2 = $FEFD
NATIVE {PEN_C3} CONST PEN_C3 = $FEFC

/* values for ChangeDecoration ID param */

NATIVE {DECORATION_SET}     CONST DECORATION_SET     = $8001
NATIVE {DECORATION_DEFAULT} CONST DECORATION_DEFAULT = $8000

/* Errors */
NATIVE {OSERR_NOMONITOR}    CONST OSERR_NOMONITOR    = 1
NATIVE {OSERR_NOCHIPS}      CONST OSERR_NOCHIPS      = 2
NATIVE {OSERR_NOMEM}        CONST OSERR_NOMEM        = 3
NATIVE {OSERR_NOCHIPMEM}    CONST OSERR_NOCHIPMEM    = 4
NATIVE {OSERR_PUBNOTUNIQUE} CONST OSERR_PUBNOTUNIQUE = 5
NATIVE {OSERR_UNKNOWNMODE}  CONST OSERR_UNKNOWNMODE  = 6
NATIVE {OSERR_TOODEEP}      CONST OSERR_TOODEEP      = 7
NATIVE {OSERR_ATTACHFAIL}   CONST OSERR_ATTACHFAIL   = 8
NATIVE {OSERR_NOTAVAILABLE} CONST OSERR_NOTAVAILABLE = 9
