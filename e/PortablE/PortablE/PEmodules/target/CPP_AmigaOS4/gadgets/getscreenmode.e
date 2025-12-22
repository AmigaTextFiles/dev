/* $VER: getscreenmode.h 53.21 (29.9.2013) */
OPT NATIVE, PREPROCESS
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/exec/types', 'target/intuition/intuition'
{#include <gadgets/getscreenmode.h>}
NATIVE {GADGETS_GETSCREENMODE_H} CONST

/* Attributes defined by the getfont.gadget class
 */
NATIVE {GETSCREENMODE_Dummy}          CONST GETSCREENMODE_DUMMY          = (REACTION_DUMMY + $41000)

NATIVE {GETSCREENMODE_TitleText}      CONST GETSCREENMODE_TITLETEXT      = (GETSCREENMODE_DUMMY+1)
    /* (STRPTR) Title of the screenmode requester (default: None)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_Height}         CONST GETSCREENMODE_HEIGHT         = (GETSCREENMODE_DUMMY+2)
    /* (WORD) Height of the screenmode requester (default: 200)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETSCREENMODE_Width}          CONST GETSCREENMODE_WIDTH          = (GETSCREENMODE_DUMMY+3)
    /* (WORD) Width of the screenmode requester (default: 300)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETSCREENMODE_LeftEdge}       CONST GETSCREENMODE_LEFTEDGE       = (GETSCREENMODE_DUMMY+4)
    /* (WORD) Left edge of the screenmode requester (default: 30)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETSCREENMODE_TopEdge}        CONST GETSCREENMODE_TOPEDGE        = (GETSCREENMODE_DUMMY+5)
    /* (WORD) Top edge of the screenmode requester (default: 20)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETSCREENMODE_DisplayID}      CONST GETSCREENMODE_DISPLAYID      = (GETSCREENMODE_DUMMY+6)
    /* (ULONG) display id of screenmode (default: 0 (LORES_KEY))
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETSCREENMODE_DisplayWidth}   CONST GETSCREENMODE_DISPLAYWIDTH   = (GETSCREENMODE_DUMMY+7)
    /* (ULONG) Display width (default: 640)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETSCREENMODE_DisplayHeight}  CONST GETSCREENMODE_DISPLAYHEIGHT  = (GETSCREENMODE_DUMMY+8)
    /* (ULONG) Display height (default: 200)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETSCREENMODE_DisplayDepth}   CONST GETSCREENMODE_DISPLAYDEPTH   = (GETSCREENMODE_DUMMY+9)
    /* (UWORD) Display depth (default: 2)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETSCREENMODE_OverscanType}   CONST GETSCREENMODE_OVERSCANTYPE   = (GETSCREENMODE_DUMMY+10)
    /* (UWORD) Type of overscan (default: OSCAN_TEXT)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETSCREENMODE_AutoScroll}     CONST GETSCREENMODE_AUTOSCROLL     = (GETSCREENMODE_DUMMY+11)
    /* (BOOL) Autoscroll setting(default: TRUE)
       (OM_NEW, OM_SET, OM_NOTIFY) */

NATIVE {GETSCREENMODE_InfoOpened}     CONST GETSCREENMODE_INFOOPENED     = (GETSCREENMODE_DUMMY+12)
    /* (BOOL) Info window initially opened?(default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_InfoLeftEdge}   CONST GETSCREENMODE_INFOLEFTEDGE   = (GETSCREENMODE_DUMMY+13)
    /* (WORD) Info window left edge (default: 30)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETSCREENMODE_InfoTopEdge}    CONST GETSCREENMODE_INFOTOPEDGE    = (GETSCREENMODE_DUMMY+14)
    /* (WORD) Info window top edge (default: 20)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETSCREENMODE_DoWidth}        CONST GETSCREENMODE_DOWIDTH        = (GETSCREENMODE_DUMMY+15)
    /* (BOOL) Display Width gadget? (default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_DoHeight}       CONST GETSCREENMODE_DOHEIGHT       = (GETSCREENMODE_DUMMY+16)
    /* (BOOL) Display Height gadget? (default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_DoDepth}        CONST GETSCREENMODE_DODEPTH        = (GETSCREENMODE_DUMMY+17)
    /* (BOOL) Display Depth gadget? (default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_DoOverscanType} CONST GETSCREENMODE_DOOVERSCANTYPE = (GETSCREENMODE_DUMMY+18)
    /* (BOOL) Display Overscan Type gadget? (default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_DoAutoScroll}   CONST GETSCREENMODE_DOAUTOSCROLL   = (GETSCREENMODE_DUMMY+19)
    /* (BOOL) Display AutoScroll gadget? (default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_PropertyFlags}  CONST GETSCREENMODE_PROPERTYFLAGS  = (GETSCREENMODE_DUMMY+20)
    /* (ULONG) Must have these Property flags (default: DIPF_IS_WB)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_PropertyMask}   CONST GETSCREENMODE_PROPERTYMASK   = (GETSCREENMODE_DUMMY+21)
    /* (ULONG) Only these should be looked at (default: DIPF_IS_WB)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_MinWidth}       CONST GETSCREENMODE_MINWIDTH       = (GETSCREENMODE_DUMMY+22)
    /* (ULONG) Minimum display width to allow (default: 16)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_MaxWidth}       CONST GETSCREENMODE_MAXWIDTH       = (GETSCREENMODE_DUMMY+23)
    /* (ULONG) Maximum display width to allow (default: 16368)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_MinHeight}      CONST GETSCREENMODE_MINHEIGHT      = (GETSCREENMODE_DUMMY+24)
    /* (ULONG) Minimum display height to allow (default: 16)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_MaxHeight}      CONST GETSCREENMODE_MAXHEIGHT      = (GETSCREENMODE_DUMMY+25)
    /* (ULONG) Maximum display height to allow (default: 16368)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_MinDepth}       CONST GETSCREENMODE_MINDEPTH       = (GETSCREENMODE_DUMMY+26)
    /* (ULONG) Minimum display depth to allow (default: 1)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_MaxDepth}       CONST GETSCREENMODE_MAXDEPTH       = (GETSCREENMODE_DUMMY+27)
    /* (ULONG) Maximum display depth to allow (default: 24)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_FilterFunc}     CONST GETSCREENMODE_FILTERFUNC     = (GETSCREENMODE_DUMMY+28)
    /* (struct Hook *) Function to filter mode id's (default: None)
       (OM_NEW, OM_SET) */

NATIVE {GETSCREENMODE_CustomSMList}   CONST GETSCREENMODE_CUSTOMSMLIST   = (GETSCREENMODE_DUMMY+29)
    /* (struct List *) Exec list of struct DisplayMode (default: None)
       (OM_NEW, OM_SET) */

/*****************************************************************************/

/*
 * getscreenmode.gadget methods
 */
NATIVE {GSM_REQUEST} CONST GSM_REQUEST = ($610001)

/* The GSM_REQUEST method should be called whenever you want to open
 * a screenmode requester.
 */

NATIVE {gsmRequest} OBJECT gsmrequest
    {MethodID}	methodid	:ULONG    /* GSM_REQUEST */
    {gsmr_Window}	window	:PTR TO window /* The window that will be locked when
                                    the requester is active. If not
                                    provided, no window will be locked and
                                    no visual updating of any gadgets will
                                    take place. This should be the window
                                    the gadget resides in. */
ENDOBJECT

/* macro for calling the method easily */

NATIVE {RequestScreenMode} PROC
#define requestScreenMode(obj/*:PTR TO /*Object*/ ULONG*/, win) IdoMethod(obj, GSM_REQUEST, win)

/* ReAction synomym for End which can make layout groups easier to follow */

#ifndef GetScreenModeEnd
NATIVE {GetScreenModeEnd} CONST
#define GetScreenModeEnd TAG_END]:tagitem)
#endif
