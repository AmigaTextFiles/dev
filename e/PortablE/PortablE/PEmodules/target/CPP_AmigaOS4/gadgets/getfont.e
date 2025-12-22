/* $VER: getfont.h 53.21 (29.9.2013) */
OPT NATIVE, PREPROCESS
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/exec/types', 'target/intuition/intuition'
{#include <gadgets/getfont.h>}
NATIVE {GADGETS_GETFONT_H} CONST

/* Attributes defined by the getfont.gadget class
 */
NATIVE {GETFONT_Dummy}          CONST GETFONT_DUMMY          = (REACTION_DUMMY + $40000)

NATIVE {GETFONT_TextAttr}       CONST GETFONT_TEXTATTR       = (GETFONT_DUMMY+1)
    /* (struct TextAttr *) Font to show in the gadget (default: None)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFONT_DoFrontPen}     CONST GETFONT_DOFRONTPEN     = (GETFONT_DUMMY+2)
    /* (BOOL) Do front pen (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFONT_DoBackPen}      CONST GETFONT_DOBACKPEN      = (GETFONT_DUMMY+3)
    /* (BOOL) Do back pen (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFONT_DoStyle}        CONST GETFONT_DOSTYLE        = (GETFONT_DUMMY+4)
    /* (BOOL) Do style (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFONT_DoDrawMode}     CONST GETFONT_DODRAWMODE     = (GETFONT_DUMMY+5)
    /* (BOOL) Do draw mode (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFONT_MinHeight}      CONST GETFONT_MINHEIGHT      = (GETFONT_DUMMY+6)
    /* (UWORD) Minimum font height (default: 6) (OM_NEW, OM_SET) */

NATIVE {GETFONT_MaxHeight}      CONST GETFONT_MAXHEIGHT      = (GETFONT_DUMMY+7)
    /* (UWORD) Maximum font height (default: 20) (OM_NEW, OM_SET) */

NATIVE {GETFONT_FixedWidthOnly} CONST GETFONT_FIXEDWIDTHONLY = (GETFONT_DUMMY+8)
    /* (BOOL) Only show fixed width fonts (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFONT_TitleText}      CONST GETFONT_TITLETEXT      = (GETFONT_DUMMY+9)
    /* (STRPTR) Title of the ASL font requester (default: None)
       (NOT copied) (OM_NEW, OM_SET) */

NATIVE {GETFONT_Height}         CONST GETFONT_HEIGHT         = (GETFONT_DUMMY+10)
    /* (WORD) Height of the ASL font requester (default: 200)
       (OM_NEW, OM_SET, OM_GET) (ASL V38) */

NATIVE {GETFONT_Width}          CONST GETFONT_WIDTH          = (GETFONT_DUMMY+11)
    /* (WORD) Width of the ASL font requester (default: 300)
       (OM_NEW, OM_SET, OM_GET) (ASL V38) */

NATIVE {GETFONT_LeftEdge}       CONST GETFONT_LEFTEDGE       = (GETFONT_DUMMY+12)
    /* (WORD) Left edge of the ASL font requester (default: 30)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETFONT_TopEdge}        CONST GETFONT_TOPEDGE        = (GETFONT_DUMMY+13)
    /* (WORD) Top edge of the ASL font requester (default: 20)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETFONT_FrontPen}       CONST GETFONT_FRONTPEN       = (GETFONT_DUMMY+14)
    /* (UBYTE) Front pen (default: 1) (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFONT_BackPen}        CONST GETFONT_BACKPEN        = (GETFONT_DUMMY+15)
    /* (UBYTE) Back pen (default: 0) (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFONT_DrawMode}       CONST GETFONT_DRAWMODE       = (GETFONT_DUMMY+16)
    /* (UBYTE) Draw mode (default: JAM1)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFONT_MaxFrontPen}    CONST GETFONT_MAXFRONTPEN    = (GETFONT_DUMMY+17)
    /* (UBYTE) Max number of colors in front palette (default: 255)
       (OM_NEW, OM_SET) (ASL V40) */

NATIVE {GETFONT_MaxBackPen}     CONST GETFONT_MAXBACKPEN     = (GETFONT_DUMMY+18)
    /* (UBYTE) Max number of colors in back palette (default: 255)
       (OM_NEW, OM_SET) (ASL V40) */

NATIVE {GETFONT_ModeList}       CONST GETFONT_MODELIST       = (GETFONT_DUMMY+19)
    /* (STRPTR *) Substitute list for drawmodes (default: None)
       (NOT copied) (OM_NEW, OM_SET) */

NATIVE {GETFONT_FrontPens}      CONST GETFONT_FRONTPENS      = (GETFONT_DUMMY+20)
    /* (UBYTE *) Color table for front pen palette (default: None)
       (NOT copied) (OM_NEW, OM_SET) (ASL V40) */

NATIVE {GETFONT_BackPens}       CONST GETFONT_BACKPENS       = (GETFONT_DUMMY+21)
    /* (UBYTE *) Color table for back pen palette (default: None)
       (NOT copied) (OM_NEW, OM_SET) (ASL V40) */

NATIVE {GETFONT_SoftStyle}      CONST GETFONT_SOFTSTYLE      = (GETFONT_DUMMY+22)
    /* (UBYTE) SoftStyle, provided only for making mapping to button.gadget
       easier (OM_GET, OM_NOTIFY)
       textattr.ta_Style in the GETFONT_TextAttr attribute will provide
       the style in other cases. */

NATIVE {GETFONT_SampleText}     CONST GETFONT_SAMPLETEXT     = (GETFONT_DUMMY+23)
    /* (STRPTR) Text to display in font sample area (default: NULL)
       (NOT copied) (OM_NEW, OM_SET) (V50) */

NATIVE {GETFONT_DoCharSet}      CONST GETFONT_DOCHARSET      = (GETFONT_DUMMY+24)
    /* (BOOL) Allow the user to select the font charset (default: FALSE)
       (OM_NEW, OM_SET) (V50) */

NATIVE {GETFONT_CharSet}        CONST GETFONT_CHARSET        = (GETFONT_DUMMY+25)
    /* (ULONG) IANA charset number of the font (default: 0)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) (V50) */

NATIVE {GETFONT_OTagOnly}       CONST GETFONT_OTAGONLY       = (GETFONT_DUMMY+26)
    /* (BOOL) Only show fonts that are handled via bullet API
       (default: FALSE) (OM_NEW, OM_SET) (V50) */

NATIVE {GETFONT_ScalableOnly}   CONST GETFONT_SCALABLEONLY   = (GETFONT_DUMMY+27)
    /* (BOOL) Only show scalable fonts that are handled via bullet API
       (default: FALSE) (OM_NEW, OM_SET) (V50) */

NATIVE {GETFONT_DoSpecialMode}  CONST GETFONT_DOSPECIALMODE  = (GETFONT_DUMMY+28)
    /* (BOOL) Do special draw mode (default: FALSE) (OM_NEW, OM_SET)
       (V50) */

NATIVE {GETFONT_SpecialMode}    CONST GETFONT_SPECIALMODE    = (GETFONT_DUMMY+29)
    /* (UBYTE) Special draw mode (default: FO_SPECIALMODE_NONE)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) (V50) */

NATIVE {GETFONT_FilterFunc}     CONST GETFONT_FILTERFUNC     = (GETFONT_DUMMY+30)
    /* (struct Hook *) Passed as ASLFO_FilterFunc to asl.library
       when not NULL (default: NULL) (OM_NEW, OM_SET) (V51.3) */

NATIVE {GETFONT_CSFilterFunc}   CONST GETFONT_CSFILTERFUNC   = (GETFONT_DUMMY+31)
    /* (struct Hook *) Passed as ASLFO_CSFilterFunc to asl.library
       when not NULL (default: NULL) (OM_NEW, OM_SET) (V51.3) */

NATIVE {GETFONT_SpecialModeBitMap} CONST GETFONT_SPECIALMODEBITMAP = (GETFONT_DUMMY+32)
    /* (struct BitMap *) Passed as ASLFO_SpecialModeBitMap to asl.library */

NATIVE {GETFONT_SpecialModeBitMapWidth} CONST GETFONT_SPECIALMODEBITMAPWIDTH = (GETFONT_DUMMY+33)
    /* (int32) Passed as ASLFO_SpecialModeBitMapWidth */

NATIVE {GETFONT_SpecialModeBitMapHeight} CONST GETFONT_SPECIALMODEBITMAPHEIGHT = (GETFONT_DUMMY+34)
    /* (int32) Passed as ASLFO_SpecialModeBitMapWidth */

/*****************************************************************************/

/*
 * getfont.gadget methods
 */
NATIVE {GFONT_REQUEST} CONST GFONT_REQUEST = ($600001)

/* The GFONT_REQUEST method should be called whenever you want to open
 * a font requester.
 */

NATIVE {gfRequest} OBJECT gfrequest
    {MethodID}	methodid	:ULONG   /* GFONT_REQUEST */
    {gfr_Window}	window	:PTR TO window /* The window that will be locked when
                                   the requester is active.
                                   MUST be provided! */
ENDOBJECT

/* macro for calling the method easily */

NATIVE {gfRequestFont} PROC
#define requestFont(obj/*:PTR TO /*Object*/ ULONG*/, win) IdoMethod(obj, GFONT_REQUEST, win)

/* ReAction synomym for End which can make layout groups easier to follow */

#ifndef GetFontEnd
NATIVE {GetFontEnd} CONST
#define GetFontEnd TAG_END]:tagitem)
#endif
