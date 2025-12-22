/* $VER: requester.h 53.21 (29.9.2013) */
OPT NATIVE, PREPROCESS
MODULE 'target/reaction/reaction'
MODULE 'target/utility/tagitem', 'target/exec/types', 'target/intuition/intuition'
{#include <classes/requester.h>}
NATIVE {CLASSES_REQUESTER_H} CONST

/* Attributes defined by the requester.gadget class */
NATIVE {REQ_Dummy}       CONST REQ_DUMMY       = (REACTION_DUMMY + $45000)
NATIVE {REQS_Dummy}      CONST REQS_DUMMY      = (REQ_DUMMY + $100)
NATIVE {REQI_Dummy}      CONST REQI_DUMMY      = (REQ_DUMMY + $200)
NATIVE {REQP_Dummy}      CONST REQP_DUMMY      = (REQ_DUMMY + $300)

NATIVE {REQ_Type}        CONST REQ_TYPE        = (REQ_DUMMY+1)
    /* (ULONG) Type of requester. See definitions below.
       (default: REQTYPE_INFO) (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQ_TitleText}   CONST REQ_TITLETEXT   = (REQ_DUMMY+2)
    /* (UBYTE *) Title text of the requester (default: None)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQ_BodyText}    CONST REQ_BODYTEXT    = (REQ_DUMMY+3)
    /* (UBYTE *) Body text of the requester (default: None)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQ_GadgetText}  CONST REQ_GADGETTEXT  = (REQ_DUMMY+4)
    /* (UBYTE *) Gadget text(s) for the requester
       (default: " _Ok | _Cancel ") (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQ_ReturnCode}  CONST REQ_RETURNCODE  = (REQ_DUMMY+5)
    /* (ULONG) Last return code of the requester (default: 0)
       (OM_GET) */

NATIVE {REQ_TabSize}     CONST REQ_TABSIZE     = (REQ_DUMMY+6) /* NOT IMPLEMENTED YET */
    /* (ULONG) Tab size to use when formatting the bodytext (default: 8)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQ_Image}       CONST REQ_IMAGE       = (REQ_DUMMY+7)
    /* (struct Image *) alternative requester image or one of
       constants below.  (V50) */

NATIVE {REQ_VarArgs}     CONST REQ_VARARGS     = (REQ_DUMMY+8)
    /* (APTR) Varargs data array to supply data for RawDoFmt() when
       format specifiers are to be used in REQ_BodyText text string.
       (V50) */

NATIVE {REQ_EvenButtons} CONST REQ_EVENBUTTONS = (REQ_DUMMY+9)
    /* (BOOL) If TRUE, the requester buttons will be evenly sized
       (default: FALSE) (OM_NEW, OM_SET, RM_OPENREQ) (V50) */

NATIVE {REQ_WrapBorder}  CONST REQ_WRAPBORDER  = (REQ_DUMMY+10)
    /* (WORD) Wordwrap bodytext after 'n' chars. Defaults to 72. (V50) */

NATIVE {REQ_TimeOutSecs} CONST REQ_TIMEOUTSECS = (REQ_DUMMY+11)
    /* (ULONG) Requester timeout seconds. Defaults to 0 (no timeout).
       (OM_NEW, OM_SET, RM_OPENREQ) (V51.5) */

NATIVE {REQ_IDCMP_Ptr}   CONST REQ_IDCMP_PTR   = (REQ_DUMMY+12)
    /* (ULONG *) Pointer to an ULONG with IDCMP flags that specify which
       IDCMP flags should terminate the requester with result -1.
       In this case the ULONG will contain the IDCMP flag that
       caused the termination, otherwise it will contain 0.
       Caution: Currently only IDCMP_DISKINSERTED is supported.
       Defaults to NULL which means no extra IDCMP flags shall
       be monitored.
       (OM_NEW, OM_SET, RM_OPENREQ) (V51.5) */

NATIVE {REQ_Inactive}    CONST REQ_INACTIVE    = (REQ_DUMMY+13)
    /* (BOOL) If TRUE, the requester window will not be activated.
       You should e.g. set this value to TRUE when your requester has
       keyboard shortcuts and may appear when the user didnt expect
       it, otherwise the user can accidently select an option of the
       requester when he is currently typing something.
       (default: FALSE) (OM_NEW, OM_SET, RM_OPENREQ) (V51.8) */

NATIVE {REQ_CharSet}     CONST REQ_CHARSET     = (REQ_DUMMY+14)
    /* (ULONG) Character set for the requester's text and gadgets.
       Defaults to 0, meaning no character set is required.
       (OM_NEW, OM_SET, OM_GET, RM_OPENREQ) (V51.11) */

NATIVE {REQ_StayOnTop}   CONST REQ_STAYONTOP   = (REQ_DUMMY+15)
    /* (BOOL) Stop the requester from being depth arranged and lost
       in a window stack. (OM_SET, RM_OPENREQ) (V53.16) */
       
/* Default requester images. V50 */
NATIVE {REQIMAGE_DEFAULT}	CONST REQIMAGE_DEFAULT = 0
NATIVE {REQIMAGE_INFO}		CONST REQIMAGE_INFO = 1
NATIVE {REQIMAGE_WARNING}	CONST REQIMAGE_WARNING = 2
NATIVE {REQIMAGE_ERROR}		CONST REQIMAGE_ERROR = 3
NATIVE {REQIMAGE_QUESTION}	CONST REQIMAGE_QUESTION = 4
NATIVE {REQIMAGE_INSERTDISK}	CONST REQIMAGE_INSERTDISK = 5

/**********************************
* integer request type attributes *
**********************************/

NATIVE {REQI_Minimum}    CONST REQI_MINIMUM    = (REQI_DUMMY+1)
    /* (LONG) Minimum allowed value (default: MININT) (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQI_Maximum}    CONST REQI_MAXIMUM    = (REQI_DUMMY+2)
    /* (LONG) Maximum allowed value (default: MAXINT)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQI_Invisible}  CONST REQI_INVISIBLE  = (REQI_DUMMY+3) /* NOT IMPLEMENTED YET */
    /* (BOOL) Integer input will be echoed with '.' and not what the user
       actually types (default: FALSE) (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQI_Number}     CONST REQI_NUMBER     = (REQI_DUMMY+4)
    /* (LONG) Number to show in gadget (default: 0)
       (OM_NEW, OM_SET, OM_GET, RM_OPENREQ) */

NATIVE {REQI_Arrows}     CONST REQI_ARROWS     = (REQI_DUMMY+5)
    /* (BOOL) Show arrows to the right of the integer gadget (default: FALSE)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQI_MaxChars}   CONST REQI_MAXCHARS   = (REQI_DUMMY+6)
    /* (UWORD) Maximum number of characters for the number (including negative
       sign). (default: 10) (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQI_MinText}    CONST REQI_MINTEXT    = (REQI_DUMMY+7)
NATIVE {REQI_MaxText}    CONST REQI_MAXTEXT    = (REQI_DUMMY+8)
    /* (STRPTR) Allows to localize the "Min: ", "Max: " labels (IS). V50 */

NATIVE {REQI_Mark}       CONST REQI_MARK       = (REQS_DUMMY+9)
    /* (BOOL) the number in the integer gadget should be marked ready
       for editing. (default: FALSE) (OM_NEW) */
       
/*********************************
* string request type attributes *
*********************************/

NATIVE {REQS_AllowEmpty}    CONST REQS_ALLOWEMPTY    = (REQS_DUMMY+1)
    /* (BOOL) Allow empty string to be accepted. (default: FALSE)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQS_Invisible}     CONST REQS_INVISIBLE     = (REQI_INVISIBLE) /* NOT IMPLEMENTED YET */
    /* (BOOL) String input will be echoed with '.' and not what the user
       actually types (default: FALSE) (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQS_Buffer}        CONST REQS_BUFFER        = (REQS_DUMMY+2)
    /* (UBYTE *) Buffer used in the string gadget. MUST be provided.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQS_ShowDefault}   CONST REQS_SHOWDEFAULT   = (REQS_DUMMY+3)
    /* (BOOL) Show content of REQS_Buffer in string gadget. (default: TRUE)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQS_MaxChars}      CONST REQS_MAXCHARS      = (REQS_DUMMY+4)
    /* (ULONG) Maximum number of characters in string gadget. Must not be
       larger than size of REQS_Buffer - 1. (default: 127)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQS_ChooserArray}  CONST REQS_CHOOSERARRAY  = (REQS_DUMMY+5)
    /* (UBYTE **) An array of strings that will be added to a chooser gadget
       to the right of the string gadget.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQS_ChooserActive} CONST REQS_CHOOSERACTIVE = (REQS_DUMMY+6)
    /* (ULONG) The current active entry among the strings passed in
       using REQS_ChooserOptions.  (default: 0)
       (OM_NEW, OM_SET, OM_GET, RM_OPENREQ) */

NATIVE {REQS_Mark} CONST REQS_MARK = (REQS_DUMMY+7)
    /* (BOOL) the text in the string gadget should be marked ready
       for editing. (default: FALSE)
       (OM_NEW) */
       
/**********************************
* progress window type attributes *
**********************************/

NATIVE {REQP_Total}         CONST REQP_TOTAL         = (REQP_DUMMY+1)
    /* (ULONG) Total number of levels for the progressbar. (default: 100)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_Current}       CONST REQP_CURRENT       = (REQP_DUMMY+2)
    /* (ULONG) The current level of the progressbar. (default: 0)
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_AbortText}     CONST REQP_ABORTTEXT     = REQ_GADGETTEXT
    /* (UBYTE *) Text to be put into the gadget that will abort the progressbar.
       If not present, no gadget will be created.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_ProgressText}  CONST REQP_PROGRESSTEXT  = REQ_BODYTEXT
    /* (UBYTE *) Text to be shown over the progressbar.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_OpenInactive}  CONST REQP_OPENINACTIVE  = (REQP_DUMMY+3)
    /* (BOOL) Open window inactive if ta_Data is TRUE.
       (OM_NEW, RM_OPENREQ) */

NATIVE {REQP_NoText}        CONST REQP_NOTEXT        = (REQP_DUMMY+4)
    /* (BOOL)  No text-gadget in progressbar if ti_Data is TRUE
       (OM_NEW, RM_OPENREQ) */

NATIVE {REQP_Dynamic}       CONST REQP_DYNAMIC       = (REQP_DUMMY+5)
    /* (BOOL)  TRUE if the pb should size automatically when
       a too long progresstext is set. Default is TRUE.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_CenterWindow}  CONST REQP_CENTERWINDOW  = (REQP_DUMMY+6)
    /* (struct Window *) The progressbar is centered over this window.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_LastPosition}  CONST REQP_LASTPOSITION  = (REQP_DUMMY+7)
    /* (BOOL) Open progressbar on the same place the last was. Default is TRUE.
       (OM_NEW, OM_SET, RM_OPENREQ) */

NATIVE {REQP_Percent}       CONST REQP_PERCENT       = (REQP_DUMMY+8)
    /* (BOOL) Render numeric percentage display.
       (OM_NEW, RM_OPENREQ) */

NATIVE {REQP_Ticks}         CONST REQP_TICKS         = (REQP_DUMMY+9)
    /* (WORD) If present, how many tick marks
       (OM_NEW, RM_OPENREQ) */

NATIVE {REQP_ShortTicks}    CONST REQP_SHORTTICKS    = (REQP_DUMMY+10)
    /* (BOOL) Enable small intermediate tick marks.
       (OM_NEW, RM_OPENREQ) */

/*****************************************************************************/

/*
 * requester.class methods
 */
NATIVE {RM_OPENREQ}         CONST RM_OPENREQ         = ($650001)

/* The RM_OPENREQ method should be called whenever you want to open
 * a requester.
 */

NATIVE {orRequest} OBJECT orRequest
    {MethodID}	methodid	:ULONG  /* RM_OPENREQ */
    {or_Attrs}	attrs	:PTR TO tagitem  /* List of tag attributes */
    {or_Window}	win	:PTR TO window /* Reference window for requester. */
    {or_Screen}	scr	:PTR TO screen /* Reference screen for requester.
                                * REQUIRED if or_Window is
                                * not supplied
                                */
ENDOBJECT

/* The REQ_Type must be used to set what type of requester you
 * want to use. Here are the definitions:
 */
NATIVE {REQTYPE_INFO}     CONST REQTYPE_INFO     = 0 /* Normal information/query requester like
                            * EasyRequest()
                            */
NATIVE {REQTYPE_INTEGER}  CONST REQTYPE_INTEGER  = 1 /* Get an integer from the user */
NATIVE {REQTYPE_STRING}   CONST REQTYPE_STRING   = 2 /* Get a string from the user */
NATIVE {REQTYPE_PROGRESS} CONST REQTYPE_PROGRESS = 3 /* Progressbar window (NOT IMPLEMENTED YET) */

/* Useful macros */
->#ifndef RequesterObject
   NATIVE {OpenRequester} PROC
   #define OpenRequester(obj, win) IdoMethod(obj, RM_OPENREQ, NIL, win, NIL, TAG_DONE)
   
   NATIVE {RequesterObject} CONST
   #define RequesterObject NewObject(Requester_GetClass(), NILA
->#endif
