/* $VER: window.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction'
MODULE 'target/exec/types', 'target/intuition/intuition'
{#include <classes/window.h>}
NATIVE {CLASSES_WINDOW_H} CONST

/*
** Attributes specific to window.class
*/

NATIVE {WINDOW_Dummy}              CONST WINDOW_DUMMY              = (REACTION_DUMMY + $25000)

NATIVE {WINDOW_Window}             CONST WINDOW_WINDOW             = (WINDOW_DUMMY + 1)
    /* (struct Window *) Return the pointer to the real
       Intuition window structure. */

NATIVE {WINDOW_SigMask}            CONST WINDOW_SIGMASK            = (WINDOW_DUMMY + 2)
    /* (uint32) Return the signal bit that you must wait for
       this window to know if the window as received
       any input. Defaults to 0. */

NATIVE {WINDOW_MenuStrip}          CONST WINDOW_MENUSTRIP          = (WINDOW_DUMMY + 4)
    /* (struct MenuStrip *) A list of Menu structure that will
       be used as the menu of this window when open. Defaults to
       NULL. */

NATIVE {WINDOW_Layout}             CONST WINDOW_LAYOUT             = (WINDOW_DUMMY + 5)
NATIVE {WINDOW_ParentLayout}       CONST WINDOW_PARENTLAYOUT       = WINDOW_LAYOUT
NATIVE {WINDOW_ParentGroup}        CONST WINDOW_PARENTGROUP        = WINDOW_LAYOUT
    /* (Object *) Layout group object for the window
       Defaults to NULL. */

NATIVE {WINDOW_UserData}           CONST WINDOW_USERDATA           = (WINDOW_DUMMY + 6)
    /* (APTR) A value that will be stored in the Window Object
       structure. Defaults to NULL. */

NATIVE {WINDOW_SharedPort}         CONST WINDOW_SHAREDPORT         = (WINDOW_DUMMY + 7)
    /* (struct MsgPort *) A port that will be used for this
       window.  The port will not be closed at dispose time.
       Defaults to NULL. */

NATIVE {WINDOW_Zoom}               CONST WINDOW_ZOOM               = (WINDOW_DUMMY + 8)
    /* When TRUE, it will act as a click on the zoom button. */

NATIVE {WINDOW_FrontBack}          CONST WINDOW_FRONTBACK          = (WINDOW_DUMMY + 9)
    /* (uint16) Only WT_FRONT and WT_BACK can be used here.
       This put the window in front or in back of
       others windows */

NATIVE {WINDOW_Activate}           CONST WINDOW_ACTIVATE           = (WINDOW_DUMMY + 10)
    /* (BOOL) Activate the window (and its master group) if
       set to TRUE and the window is open. */

NATIVE {WINDOW_LockWidth}          CONST WINDOW_LOCKWIDTH          = (WINDOW_DUMMY + 11)
    /* (BOOL) Lock the window from resize in width.
       Defaults to FALSE. */

NATIVE {WINDOW_LockHeight}         CONST WINDOW_LOCKHEIGHT         = (WINDOW_DUMMY + 12)
    /* (BOOL) Lock the window from resize in height.
       Defaults to FALSE. */

NATIVE {WINDOW_AppPort}            CONST WINDOW_APPPORT            = (WINDOW_DUMMY + 13)
    /* (struct MsgPort *) A shared message port for appmessages
       You must pass this to be able to iconify the window.
       Defaults to NULL. */

NATIVE {WINDOW_Position}           CONST WINDOW_POSITION           = (WINDOW_DUMMY + 14)
    /* (uint32) The initial position to open at. */

NATIVE {WINDOW_IDCMPHook}          CONST WINDOW_IDCMPHOOK          = (WINDOW_DUMMY + 15)
    /* (struct Hook *) Defaults to NULL. */

NATIVE {WINDOW_IDCMPHookBits}      CONST WINDOW_IDCMPHOOKBITS      = (WINDOW_DUMMY + 16)
    /* (uint32) Defaults to 0L. */

NATIVE {WINDOW_GadgetUserData}     CONST WINDOW_GADGETUSERDATA     = (WINDOW_DUMMY + 17)
NATIVE {WINDOW_InterpretUserData}  CONST WINDOW_INTERPRETUSERDATA  = WINDOW_GADGETUSERDATA
    /* (uint16) How Gadget.UserData is interpreted.
       Defaults to WGUD_IGNORE */

NATIVE {WINDOW_MenuUserData}       CONST WINDOW_MENUUSERDATA       = (WINDOW_DUMMY + 25)
    /* (uint16) How GTMENUITEM_USERDATA is interpreted. */

NATIVE {WGUD_HOOK}   CONST WGUD_HOOK   = 0 /* Gadget/MenuItem UserData points to a Hook */
NATIVE {WGUD_FUNC}   CONST WGUD_FUNC   = 1 /* Points to a function */
NATIVE {WGUD_IGNORE} CONST WGUD_IGNORE = 2 /* App private, don't touch it */

NATIVE {WINDOW_IconTitle}          CONST WINDOW_ICONTITLE          = (WINDOW_DUMMY + 18)
    /* (CONST_STRPTR) Title of the iconified window. */

NATIVE {WINDOW_AppMsgHook}         CONST WINDOW_APPMSGHOOK         = (WINDOW_DUMMY + 19)
    /* (struct Hook *) Defaults to NULL. */

NATIVE {WINDOW_Icon}               CONST WINDOW_ICON               = (WINDOW_DUMMY + 20)
    /* (struct DiskObject *) Custom icon for the window. */

NATIVE {WINDOW_AppWindow}          CONST WINDOW_APPWINDOW          = (WINDOW_DUMMY + 21)
    /* (BOOL) Make the window a Workbench AppWindow. */

NATIVE {WINDOW_GadgetHelp}         CONST WINDOW_GADGETHELP         = (WINDOW_DUMMY + 22)
    /* (BOOL) Set gadget-help on/off. */

NATIVE {WINDOW_IconifyGadget}      CONST WINDOW_ICONIFYGADGET      = (WINDOW_DUMMY + 23)
    /* (BOOL) Add an iconification gadget to window title bar. */

NATIVE {WINDOW_TextAttr}           CONST WINDOW_TEXTATTR           = (WINDOW_DUMMY + 24)
    /* (struct TextAttr *)Default font for window.
       If not set, use screen font. */

NATIVE {WINDOW_BackFillName}       CONST WINDOW_BACKFILLNAME       = (WINDOW_DUMMY + 26)
    /* (CONST_STRPTR) replaces the default backfill pattern with this file,
       loaded through datatypes. */

NATIVE {WINDOW_RefWindow}          CONST WINDOW_REFWINDOW          = (WINDOW_DUMMY + 41)
    /* (struct Window *) Causes WINDOW_Position to be relative to
       to this window vs the screen. (V42) */

NATIVE {WINDOW_InputEvent}         CONST WINDOW_INPUTEVENT         = (WINDOW_DUMMY + 42)
    /* (struct InputEvent *) returns a pointer to an inputevent
       which will be current *ONLY* after a WHMI_RAWKEY. (V42) */

NATIVE {WINDOW_HintInfo}           CONST WINDOW_HINTINFO           = (WINDOW_DUMMY + 43)
    /* (struct HintInfo *) Static Array of help hints.
        Pointer to a gadget HintInfo array. This is similar in concept
       to Apple's bubble help or Microsoft's help tips. By providing
       this array of helpinfo, and setting WINDOW_GadgetHelp, TRUE,
       window class will transparently manage the help hints. */

NATIVE {WINDOW_KillWindow}         CONST WINDOW_KILLWINDOW         = (WINDOW_DUMMY + 44)
NATIVE {WINDOW_Application}        CONST WINDOW_APPLICATION        = (WINDOW_DUMMY + 45)
    /* ** PRIVATE TAGS SET/GET BY APPLICATION CLASS! ** (V43 BETA) */

NATIVE {WINDOW_InterpretIDCMPHook} CONST WINDOW_INTERPRETIDCMPHOOK = (WINDOW_DUMMY + 46)
    /* Interpret IDCMPHook results. (V43 BETA) */

NATIVE {WINDOW_Parent}             CONST WINDOW_PARENT             = (WINDOW_DUMMY + 47)
    /* ** PRIVATE TAG SET/GET BY APPLICATION CLASS! ** (V43 BETA) */

NATIVE {WINDOW_PreRefreshHook}     CONST WINDOW_PREREFRESHHOOK     = (WINDOW_DUMMY + 48)
    /* (struct Hook *) window.class calls this hook BEFORE RefreshGList() */

NATIVE {WINDOW_PostRefreshHook}    CONST WINDOW_POSTREFRESHHOOK    = (WINDOW_DUMMY + 49)
    /* (struct Hook *) window.class calls this hook AFTER RefreshGList() */

NATIVE {WINDOW_AppWindowPtr}       CONST WINDOW_APPWINDOWPTR       = (WINDOW_DUMMY + 50)
    /* (struct AppWindow *) GetAttr()'able pointer to AddAppWindow() result.*/

NATIVE {WINDOW_VertProp}           CONST WINDOW_VERTPROP           = (WINDOW_DUMMY + 27)
    /* (int32) Show/hide vertical border scroller. (V45, public since V51) */

NATIVE {WINDOW_VertObject}         CONST WINDOW_VERTOBJECT         = (WINDOW_DUMMY + 28)
    /* (Object *) OM_GET the vertical scroller object pointer. (V45) */

NATIVE {WINDOW_HorizProp}          CONST WINDOW_HORIZPROP          = (WINDOW_DUMMY + 29)
    /* (int32) Show/hide horizontal border scroller. (V45, public since V51) */

NATIVE {WINDOW_HorizObject}        CONST WINDOW_HORIZOBJECT        = (WINDOW_DUMMY + 30)
    /* (Object *) OM_GET the horizontal scroller object pointer. (V45) */

NATIVE {WINDOW_IconNoDispose}      CONST WINDOW_ICONNODISPOSE      = (WINDOW_DUMMY + 51)
    /* (BOOL) Dispose WINDOW_Icon? Defaults to false (ie. dispose) (V50). */

NATIVE {WINDOW_NewMenu}            CONST WINDOW_NEWMENU            = (WINDOW_DUMMY + 52)
    /* (struct NewMenu *) Let window.class create and layout the menus
       useful for iconification and screenchanges (V50). */

NATIVE {WINDOW_Qualifier}          CONST WINDOW_QUALIFIER          = (WINDOW_DUMMY + 53)
    /* (uint16) Current qualifiers from intuimessage (V50). */

NATIVE {WINDOW_CharSet}            CONST WINDOW_CHARSET            = (WINDOW_DUMMY + 54)
    /* (uint32) Charset of the WINDOW_HintInfo strings and the
       WINDOW_NewMenu strings (V51.11). */

NATIVE {WINDOW_BuiltInScroll}      CONST WINDOW_BUILTINSCROLL      = (WINDOW_DUMMY + 55)
    /* (BOOL) Turn on built-in scrollwheel support. Also needs
    IDCMP_EXTENDEDMOUSE specified. */

NATIVE {WINDOW_IDCMPSnoopHook}     CONST WINDOW_IDCMPSNOOPHOOK     = (WINDOW_DUMMY + 56)
    /* (struct Hook *) Defaults to NULL. */

NATIVE {WINDOW_ShowingHint}        CONST WINDOW_SHOWINGHINT        = (WINDOW_DUMMY + 57)
    /* (BOOL) Is there a GadgetHelp hint displayed? */

NATIVE {WINDOW_NewPrefsHook}       CONST WINDOW_NEWPREFSHOOK       = (WINDOW_DUMMY + 58)
    /* (struct Hook *) Called when the window receives a NEWPREFS
       notification from GUI prefs */

NATIVE {WINDOW_Iconifiable}        CONST WINDOW_ICONIFIABLE        = (WINDOW_DUMMY + 59)
    /* (BOOL) Window can be iconified via WMHI_ICONIFY/WMHI_UNICONIFY
       but does not have an iconify gadget. */

NATIVE {WINDOW_PopupGadget}        CONST WINDOW_POPUPGADGET        = (WINDOW_DUMMY + 60)
    /* (BOOL) Tell window class that the window should have a popup
       gadget. Defaults to FALSE */

NATIVE {WINDOW_PopupHook}          CONST WINDOW_POPUPHOOK          = (WINDOW_DUMMY + 61)
    /* (APTR) Set the pointer to a hook which will add popup menu
       items. */

NATIVE {WINDOW_PopupItem}          CONST WINDOW_POPUPITEM          = (WINDOW_DUMMY + 62)
    /* (APTR) If a user-defined popup item was selected, get the
        pointer to it. */

NATIVE {WINDOW_JumpScreensMenu}    CONST WINDOW_JUMPSCREENSMENU    = (WINDOW_DUMMY + 63)
    /* (BOOL) Show the "Jump to screen" menu. Defaults to FALSE */

NATIVE {WINDOW_UniqueID}           CONST WINDOW_UNIQUEID           = (WINDOW_DUMMY + 64 )
    /* (STRPTR) An ID for this window for snapshot and restore
       functionality. */

/****************************************************************************/

/* Pre-defined WM_HANDLEINPUT return codes. */
NATIVE {WMHI_LASTMSG}         CONST WMHI_LASTMSG         = (0)     /* No more messages */
NATIVE {WMHI_IGNORE}          CONST WMHI_IGNORE          = (NOT 0)    /* Ignore */
NATIVE {WMHI_GADGETMASK}      CONST WMHI_GADGETMASK      = ($ffff) /* Gadget ID mask value */
NATIVE {WMHI_MENUMASK}        CONST WMHI_MENUMASK        = ($ffff) /* Menu ID mask value */
NATIVE {WMHI_KEYMASK}         CONST WMHI_KEYMASK         = ($ff)   /* Key code mask value */
NATIVE {WMHI_CLASSMASK}   CONST WMHI_CLASSMASK   = ($ffff0000) /* Event class mask value */
NATIVE {WMHI_CLOSEWINDOW}     CONST WMHI_CLOSEWINDOW     = 1 SHL 16 /* The close gadget was clicked */
                                      /* or a hook function trigged close */
NATIVE {WMHI_GADGETUP}        CONST WMHI_GADGETUP        = (2 SHL 16) /* A gadget was released */
NATIVE {WMHI_INACTIVE}        CONST WMHI_INACTIVE        = (3 SHL 16) /* The window was de-activated */
NATIVE {WMHI_ACTIVE}          CONST WMHI_ACTIVE          = (4 SHL 16) /* The window was activated */
NATIVE {WMHI_NEWSIZE}         CONST WMHI_NEWSIZE         = (5 SHL 16) /* The window was resized */
NATIVE {WMHI_MENUPICK}        CONST WMHI_MENUPICK        = (6 SHL 16) /* A menu item was picked */
NATIVE {WMHI_MENUHELP}        CONST WMHI_MENUHELP        = (7 SHL 16) /* Help was hit in a menu */
NATIVE {WMHI_GADGETHELP}      CONST WMHI_GADGETHELP      = (8 SHL 16) /* A gadget returns a help code */
NATIVE {WMHI_ICONIFY}         CONST WMHI_ICONIFY         = (9 SHL 16) /* Window requests to be iconified */
NATIVE {WMHI_UNICONIFY}      CONST WMHI_UNICONIFY      = 1 SHL 16 /* Window was uniconified */
NATIVE {WMHI_RAWKEY}         CONST WMHI_RAWKEY         = 1 SHL 16 /* Raw key codes */
NATIVE {WMHI_VANILLAKEY}     CONST WMHI_VANILLAKEY     = 1 SHL 16 /* Vanilla key codes */
NATIVE {WMHI_CHANGEWINDOW}   CONST WMHI_CHANGEWINDOW   = 1 SHL 16 /* Window moved (or depth arranged) */
NATIVE {WMHI_INTUITICK}      CONST WMHI_INTUITICK      = 1 SHL 16 /* IDCMP intuitick (maximum 10 per second) */
NATIVE {WMHI_MOUSEMOVE}      CONST WMHI_MOUSEMOVE      = 1 SHL 16 /* IDCMP mouse move */
NATIVE {WMHI_MOUSEBUTTONS}   CONST WMHI_MOUSEBUTTONS   = 1 SHL 16 /* IDCMP mouse buttons */
NATIVE {WMHI_DISPOSEDWINDOW} CONST WMHI_DISPOSEDWINDOW = 1 SHL 16 /* Hook function triggered disposal */
NATIVE {WMHI_JUMPSCREEN}     CONST WMHI_JUMPSCREEN     = 1 SHL 16 /* User wants window on a different Screen */
NATIVE {WMHI_POPUPMENU}      CONST WMHI_POPUPMENU      = 1 SHL 16 /* A user defined popup menu item was selected */
NATIVE {WMHI_GADGETDOWN}     CONST WMHI_GADGETDOWN     = (20 SHL 16) /* A gadget was activated (V53.52) */

/****************************************************************************/

NATIVE {WHOOKRSLT_IGNORE}        CONST WHOOKRSLT_IGNORE        = (0) /* Ignore return value */
NATIVE {WHOOKRSLT_CLOSEWINDOW}   CONST WHOOKRSLT_CLOSEWINDOW   = (1) /* WM_CLOSE and return WMHI_CLOSEWINDOW */
NATIVE {WHOOKRSLT_DISPOSEWINDOW} CONST WHOOKRSLT_DISPOSEWINDOW = (2) /* OM_DISPOSE and return WMHI_DISPOSEDWINDOW */

/****************************************************************************/

NATIVE {WMF_ZOOMED}    CONST WMF_ZOOMED    = ($0001) /* Window is in zoomed state */
NATIVE {WMF_ZIPWINDOW} CONST WMF_ZIPWINDOW = ($0002) /* This resize toggled zoom state */

/****************************************************************************/

/* Possible WINDOW_FrontBack values */
NATIVE {WT_FRONT}    CONST WT_FRONT    = TRUE
NATIVE {WT_BACK}     CONST WT_BACK     = FALSE

/* Possible WINDOW_Position values */
NATIVE {WPOS_CENTERSCREEN} CONST WPOS_CENTERSCREEN = (1)    /* Center on the screen */
NATIVE {WPOS_CENTERMOUSE}  CONST WPOS_CENTERMOUSE  = (2)    /* Center under the mouse */
NATIVE {WPOS_TOPLEFT}      CONST WPOS_TOPLEFT      = (3)    /* Top-left of the screen */
NATIVE {WPOS_CENTERWINDOW} CONST WPOS_CENTERWINDOW = (4)    /* Center in another window */
NATIVE {WPOS_FULLSCREEN}   CONST WPOS_FULLSCREEN   = (5)    /* Top-left of, and fill the screen */

/****************************************************************************/

/*
 * Window Methods
 */
NATIVE {WM_HANDLEINPUT}    CONST WM_HANDLEINPUT    = ($570001)

/* The WM_HANDLEINPUT method should be called by for each received
 * IDCMP message.
 * If the message could be linked to a gadget in the window, the int16
 * pointed to by wmh_Code will be set to the gadget's return code.
 */

NATIVE {wmHandle} OBJECT wmhandle
    {MethodID}	methodid	:ULONG    /* WM_HANDLEINPUT */
    {wmh_Code}	code	:PTR TO INT    /* The code from the gadget */
ENDOBJECT

NATIVE {WM_OPEN}           CONST WM_OPEN           = ($570002)
NATIVE {WM_CLOSE}          CONST WM_CLOSE          = ($570003)
NATIVE {WM_NEWPREFS}       CONST WM_NEWPREFS       = ($570004)
NATIVE {WM_ICONIFY}        CONST WM_ICONIFY        = ($570005)
NATIVE {WM_RETHINK}        CONST WM_RETHINK        = ($570006)
NATIVE {WM_ACTIVATEGADGET} CONST WM_ACTIVATEGADGET = ($570007)    /* V50 */

NATIVE {wmActivateGadget} OBJECT wmactivategadget
    {MethodID}	methodid	:ULONG
    {wma_Object}	object	:PTR TO gadget
ENDOBJECT


NATIVE {WM_SNAPSHOT}       CONST WM_SNAPSHOT       = ($570008)    /* 53.51 */

NATIVE {SnapHow} DEF
NATIVE {SAVE} CONST SAVE = 0 /* forces WM_SNAPSHOT to save data to ENVARC; */
NATIVE {USE} CONST USE = 1       /* data is only saved to ENV: */
NATIVE {wmSnapshot} OBJECT wmsnapshot
    {MethodID}	methodid	:ULONG /* always WM_SNAPSHOT */
    {How}	how	:/*NATIVE {enum SnapHow}*/ ULONG
ENDOBJECT

NATIVE {WM_UNSNAPSHOT}     CONST WM_UNSNAPSHOT     = ($570009)    /* 53.51 */
NATIVE {WM_RESTORE}        CONST WM_RESTORE        = ($570010)    /* 53.51 */


/****************************************************************************/

/* The use of GA_HintInfo is highly recommended over 
** using arrays of the following structure .
*/

NATIVE {HintInfo} OBJECT hintinfo
    {hi_GadgetID}	gadgetid	:INT   /* Gadget ID hint belongs to, -1 indicates end. */
    {hi_Code}	code	:INT       /* Code required for this gadget,
                           * or -1 if it doesn't matter. */
    {hi_Text}	text	:CONST_STRPTR /* The text of the hint.. */
    {hi_Flags}	flags	:ULONG      /* Flags, currently unsupported and must be 0 */
ENDOBJECT
