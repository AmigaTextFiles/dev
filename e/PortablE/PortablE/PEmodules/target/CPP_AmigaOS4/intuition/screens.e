/* $Id: screens.h,v 1.16 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/clip', 'target/graphics/view', 'target/graphics/rastport', 'target/graphics/layers', 'target/utility/tagitem' /*, 'target/intuition/iobsolete'*/
MODULE 'target/graphics/text', 'target/exec/nodes', 'target/exec/tasks'
{#include <intuition/screens.h>}
NATIVE {INTUITION_SCREENS_H} CONST

/* ======================================================================== */
/* === DrawInfo =========================================================== */
/* ======================================================================== */

/* This is a packet of information for graphics rendering.  It originates
 * with a Screen, and is gotten using GetScreenDrawInfo( screen );
 */

/* You can use the Intuition version number to tell which fields are
 * present in this structure.
 *
 * DRI_VERSION of 1 corresponds to V37 release.
 * DRI_VERSION of 2 corresponds to V39, and includes three new pens
 *    and the dri_CheckMark and dri_AmigaKey fields.
 * DRI_VERSION of 3 corresponds to V50, and includes 33 new pens and
 *    the dri_Screen and the dri_Prefs fields.
 *
 * Note that sometimes applications need to create their own DrawInfo
 * structures, in which case the DRI_VERSION won't correspond exactly
 * to the OS version!!!
 */
NATIVE {DRI_VERSION} CONST DRI_VERSION = (3)

NATIVE {DrawInfo} OBJECT drawinfo
    {dri_Version}	version	:UINT     /* will be  DRI_VERSION             */
    {dri_NumPens}	numpens	:UINT     /* guaranteed to be >= 9            */
    {dri_Pens}	pens	:PTR TO UINT        /* pointer to pen array             */

    {dri_Font}	font	:PTR TO textfont        /* screen default font              */
    {dri_Depth}	depth	:UINT       /* (initial) depth of screen bitmap */

              /* from DisplayInfo database for initial display mode      */
    {dri_Resolution.X}	resolutionx	:UINT
    {dri_Resolution.Y}	resolutiony	:UINT

    {dri_Flags}	flags	:ULONG       /* defined below */
/* New for V39: dri_CheckMark, dri_AmigaKey. */
    {dri_CheckMark}	checkmark	:PTR TO image   /* pointer to scaled checkmark image
                                       * Will be NULL if DRI_VERSION < 2
                                       */
    {dri_AmigaKey}	amigakey	:PTR TO image    /* pointer to scaled Amiga-key image
                                       * Will be NULL if DRI_VERSION < 2
                                       */
/* New for V50: dri_Screen, dri_Prefs. */
    {dri_Screen}	longreserved	:PTR TO screen      /* pointer to associated screen
                                       * Will be NULL if DRI_VERSION < 3
                                       */
    {dri_Prefs}	prefs	:APTR       /* opaque handle to GUI settings
                                       * Will be NULL if DRI_VERSION < 3
                                       */
    {dri_Reserved}	reserved[3]	:ARRAY OF ULONG /* avoid recompilation ;^) */
ENDOBJECT

NATIVE {DRIF_NEWLOOK}    CONST DRIF_NEWLOOK    = $00000001 /* specified SA_Pens, full treatment   */
NATIVE {DRIF_NEWDISABLE} CONST DRIF_NEWDISABLE = $00000002 /* fancy look for disabled items (V50) */
NATIVE {DRIF_REALSHADE}  CONST DRIF_REALSHADE  = $00000004 /* realistic bitmap shading (V50)      */

/* rendering pen number indexes into DrawInfo.dri_Pens[] */
NATIVE {DETAILPEN}             CONST DETAILPEN             = ($0000) /* compatible Intuition rendering pens */
NATIVE {BLOCKPEN}              CONST BLOCKPEN              = ($0001) /* compatible Intuition rendering pens */
NATIVE {TEXTPEN}               CONST TEXTPEN               = ($0002) /* text on background                  */
NATIVE {SHINEPEN}              CONST SHINEPEN              = ($0003) /* bright edge on 3D objects           */
NATIVE {SHADOWPEN}             CONST SHADOWPEN             = ($0004) /* dark edge on 3D objects             */
NATIVE {FILLPEN}               CONST FILLPEN               = ($0005) /* active-window/selected-gadget fill  */
NATIVE {FILLTEXTPEN}           CONST FILLTEXTPEN           = ($0006) /* text over FILLPEN                   */
NATIVE {BACKGROUNDPEN}         CONST BACKGROUNDPEN         = ($0007) /* may not always be color 0           */
NATIVE {HIGHLIGHTTEXTPEN}      CONST HIGHLIGHTTEXTPEN      = ($0008) /* special color text, on background   */
/* New for V39, only present if DRI_VERSION >= 2: */
NATIVE {BARDETAILPEN}          CONST BARDETAILPEN          = ($0009) /* text/detail in screen-bar/menus     */
NATIVE {BARBLOCKPEN}           CONST BARBLOCKPEN           = ($000A) /* screen-bar/menus fill               */
NATIVE {BARTRIMPEN}            CONST BARTRIMPEN            = ($000B) /* trim under screen-bar               */
/* New for V50, only present if DRI_VERSION >= 3: */
NATIVE {BARCONTOURPEN}         CONST BARCONTOURPEN         = ($000C) /* contour above screen-bar            */
NATIVE {FOREGROUNDPEN}         CONST FOREGROUNDPEN         = ($000D) /* inside of unselected gadgets        */
NATIVE {FORESHINEPEN}          CONST FORESHINEPEN          = ($000E) /* bright edges of unselected gadgets  */
NATIVE {FORESHADOWPEN}         CONST FORESHADOWPEN         = ($000F) /* dark edges of unselected gadgets    */
NATIVE {FILLSHINEPEN}          CONST FILLSHINEPEN          = ($0010) /* bright edges for FILLPEN            */
NATIVE {FILLSHADOWPEN}         CONST FILLSHADOWPEN         = ($0011) /* dark edges for FILLPEN              */
NATIVE {INACTIVEFILLPEN}       CONST INACTIVEFILLPEN       = ($0012) /* inactive window borders fill        */
NATIVE {INACTIVEFILLTEXTPEN}   CONST INACTIVEFILLTEXTPEN   = ($0013) /* text over INACTIVEFILLPEN           */
NATIVE {INACTIVEFILLSHINEPEN}  CONST INACTIVEFILLSHINEPEN  = ($0014) /* bright edges for INACTIVEFILLPEN    */
NATIVE {INACTIVEFILLSHADOWPEN} CONST INACTIVEFILLSHADOWPEN = ($0015) /* dark edges for INACTIVEFILLPEN      */
NATIVE {DISABLEDPEN}           CONST DISABLEDPEN           = ($0016) /* background of disabled elements     */
NATIVE {DISABLEDTEXTPEN}       CONST DISABLEDTEXTPEN       = ($0017) /* text of disabled string gadgets     */
NATIVE {DISABLEDSHINEPEN}      CONST DISABLEDSHINEPEN      = ($0018) /* bright edges of disabled elements   */
NATIVE {DISABLEDSHADOWPEN}     CONST DISABLEDSHADOWPEN     = ($0019) /* dark edges of disabled elements     */
NATIVE {MENUBACKGROUNDPEN}     CONST MENUBACKGROUNDPEN     = ($001A) /* background of menus                 */
NATIVE {MENUTEXTPEN}           CONST MENUTEXTPEN           = ($001B) /* normal text in menus                */
NATIVE {MENUSHINEPEN}          CONST MENUSHINEPEN          = ($001C) /* bright edges of menus               */
NATIVE {MENUSHADOWPEN}         CONST MENUSHADOWPEN         = ($001D) /* dark edges of menus                 */
NATIVE {SELECTPEN}             CONST SELECTPEN             = ($001E) /* background of selected items        */
NATIVE {SELECTTEXTPEN}         CONST SELECTTEXTPEN         = ($001F) /* text of selected items              */
NATIVE {SELECTSHINEPEN}        CONST SELECTSHINEPEN        = ($0020) /* bright edges of selected items      */
NATIVE {SELECTSHADOWPEN}       CONST SELECTSHADOWPEN       = ($0021) /* dark edges of selected items        */
NATIVE {GLYPHPEN}              CONST GLYPHPEN              = ($0022) /* system gadget glyphs, outlines      */
NATIVE {GLYPHFILLPEN}          CONST GLYPHFILLPEN          = ($0023) /* system gadget glyphs, colored areas */
NATIVE {INACTIVEGLYPHPEN}      CONST INACTIVEGLYPHPEN      = ($0024) /* system gadget glyphs, inact. windows*/
NATIVE {RESERVEDPEN}           CONST RESERVEDPEN           = ($0025) /* reserved - don't use                */
NATIVE {GADGETPEN}             CONST GADGETPEN             = ($0026) /* gadget symbols (arrows, cycle, etc.)*/
NATIVE {TITLEPEN}              CONST TITLEPEN              = ($0027) /* title of gadget groups              */
NATIVE {HALFSHINEPEN}          CONST HALFSHINEPEN          = ($0028) /* half-bright edge on 3D objects      */
NATIVE {HALFSHADOWPEN}         CONST HALFSHADOWPEN         = ($0029) /* half-dark edge on 3D objects        */
NATIVE {FLATBORDERPEN}         CONST FLATBORDERPEN         = ($002A) /* flat (non-3D) borders and frames    */
NATIVE {FILLFLATPEN}           CONST FILLFLATPEN           = ($002B) /* flat outlines of active windows     */
NATIVE {INACTIVEFILLFLATPEN}   CONST INACTIVEFILLFLATPEN   = ($002C) /* flat outlines of inactive windows   */

NATIVE {NUMDRIPENS}            CONST NUMDRIPENS            = ($002D)


/* New for V39:  It is sometimes useful to specify that a pen value
 * is to be the complement of color zero to three.  The "magic" numbers
 * serve that purpose:
 */
NATIVE {PEN_C3}  CONST PEN_C3  = $FEFC /* Complement of color 3 */
NATIVE {PEN_C2}  CONST PEN_C2  = $FEFD /* Complement of color 2 */
NATIVE {PEN_C1}  CONST PEN_C1  = $FEFE /* Complement of color 1 */
NATIVE {PEN_C0}  CONST PEN_C0  = $FEFF /* Complement of color 0 */

/* ======================================================================== */
/* === Screen ============================================================= */
/* ======================================================================== */

/* VERY IMPORTANT NOTE ABOUT Screen->BitMap.  In the future, bitmaps
 * will need to grow.  The embedded instance of a bitmap in the screen
 * will no longer be large enough to hold the whole description of
 * the bitmap.
 *
 * YOU ARE STRONGLY URGED to use Screen->RastPort.BitMap in place of
 * &Screen->BitMap whenever and whereever possible.
 */

->"OBJECT screen" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* --- FLAGS SET BY INTUITION --------------------------------------------- */
/* The SCREENTYPE bits are reserved for describing various Screen types
 * available under Intuition.
 */
NATIVE {SCREENTYPE}   CONST SCREENTYPE   = $000F /* all the screens types available         */
/* --- the definitions for the Screen Type ------------------------------- */
NATIVE {WBENCHSCREEN} CONST WBENCHSCREEN = $0001 /* identifies the Workbench screen         */
NATIVE {PUBLICSCREEN} CONST PUBLICSCREEN = $0002 /* public shared (custom) screen           */
NATIVE {CUSTOMSCREEN} CONST CUSTOMSCREEN = $000F /* original custom screens                 */

NATIVE {SHOWTITLE}    CONST SHOWTITLE    = $0010 /* this gets set by a call to ShowTitle()  */

NATIVE {BEEPING}      CONST BEEPING      = $0020 /* set when Screen is beeping (private)    */

NATIVE {CUSTOMBITMAP} CONST CUSTOMBITMAP = $0040 /* if you are supplying your own BitMap    */

NATIVE {SCREENBEHIND} CONST SCREENBEHIND = $0080 /* if you want your screen to open behind
                             * already open screens
                             */
NATIVE {SCREENQUIET}  CONST SCREENQUIET  = $0100 /* if you do not want Intuition to render
                             * into your screen (gadgets, title)
                             */
NATIVE {SCREENHIRES}  CONST SCREENHIRES  = $0200 /* do not use lowres gadgets  (private)    */

NATIVE {NS_EXTENDED}  CONST NS_EXTENDED  = $1000 /* ExtNewScreen.Extension is valid         */
/* V36 applications can use OpenScreenTagList() instead of NS_EXTENDED */

NATIVE {AUTOSCROLL}   CONST AUTOSCROLL   = $4000 /* screen is to autoscoll                  */

/* New for V39: */
NATIVE {PENSHARED}    CONST PENSHARED    = $0400 /* Screen opener set {SA_SharePens,TRUE}   */




NATIVE {STDSCREENHEIGHT} CONST STDSCREENHEIGHT = -1 /* supply in NewScreen.Height */
NATIVE {STDSCREENWIDTH}  CONST STDSCREENWIDTH  = -1 /* supply in NewScreen.Width  */

/*
 * Screen attribute tag ID's.  These are used in the ti_Tag field of
 * TagItem arrays passed to OpenScreenTagList() (or in the
 * ExtNewScreen.Extension field).
 */

/* Screen attribute tags.  Please use these versions, not those in
 * iobsolete.h.
 */

NATIVE {SA_Dummy}             CONST SA_DUMMY             = (TAG_USER + 32)
/*
 * these items specify items equivalent to fields in NewScreen
 */
NATIVE {SA_Left}              CONST SA_LEFT              = (SA_DUMMY + $0001)
NATIVE {SA_Top}               CONST SA_TOP               = (SA_DUMMY + $0002)
NATIVE {SA_Width}             CONST SA_WIDTH             = (SA_DUMMY + $0003)
NATIVE {SA_Height}            CONST SA_HEIGHT            = (SA_DUMMY + $0004)
            /* traditional screen positions and dimensions */
NATIVE {SA_Depth}             CONST SA_DEPTH             = (SA_DUMMY + $0005)
            /* screen bitmap depth */
NATIVE {SA_DetailPen}         CONST SA_DETAILPEN         = (SA_DUMMY + $0006)
            /* serves as default for windows, too */
NATIVE {SA_BlockPen}          CONST SA_BLOCKPEN          = (SA_DUMMY + $0007)
NATIVE {SA_Title}             CONST SA_TITLE             = (SA_DUMMY + $0008)
            /* default screen title */
NATIVE {SA_Colors}            CONST SA_COLORS            = (SA_DUMMY + $0009)
            /* ti_Data is an array of struct ColorSpec,
             * terminated by ColorIndex = -1.  Specifies
             * initial screen palette colors.
             * Also see SA_Colors32 for use under V39.
             */
NATIVE {SA_ErrorCode}         CONST SA_ERRORCODE         = (SA_DUMMY + $000A)
            /* ti_Data points to LONG error code (values below) */
NATIVE {SA_Font}              CONST SA_FONT              = (SA_DUMMY + $000B)
            /* equiv. to NewScreen.Font */
NATIVE {SA_SysFont}           CONST SA_SYSFONT           = (SA_DUMMY + $000C)
            /* Selects one of the preferences system fonts:
             *    0 - old DefaultFont, fixed-width
             *    1 - WB Screen preferred font
             */
NATIVE {SA_Type}              CONST SA_TYPE              = (SA_DUMMY + $000D)
            /* ti_Data is PUBLICSCREEN or CUSTOMSCREEN.  For other
             * fields of NewScreen.Type, see individual tags,
             * eg. SA_Behind, SA_Quiet.
             */
NATIVE {SA_BitMap}            CONST SA_BITMAP            = (SA_DUMMY + $000E)
            /* ti_Data is pointer to custom BitMap.  This
             * implies type of CUSTOMBITMAP
             */
NATIVE {SA_PubName}           CONST SA_PUBNAME           = (SA_DUMMY + $000F)
            /* presence of this tag means that the screen
             * is to be a public screen.  Please specify
             * BEFORE the two tags below
             */
NATIVE {SA_PubSig}            CONST SA_PUBSIG            = (SA_DUMMY + $0010)
NATIVE {SA_PubTask}           CONST SA_PUBTASK           = (SA_DUMMY + $0011)
            /* Task ID and signal for being notified that
             * the last window has closed on a public screen.
             */
NATIVE {SA_DisplayID}         CONST SA_DISPLAYID         = (SA_DUMMY + $0012)
            /* ti_Data is new extended display ID from
             * <graphics/displayinfo.h> (V37) or from
             * <graphics/modeid.h> (V39 and up)
             */
NATIVE {SA_DClip}             CONST SA_DCLIP             = (SA_DUMMY + $0013)
            /* ti_Data points to a rectangle which defines
             * screen display clip region
             */
NATIVE {SA_Overscan}          CONST SA_OVERSCAN          = (SA_DUMMY + $0014)
            /* Set to one of the OSCAN_
             * specifiers below to get a system standard
             * overscan region for your display clip,
             * screen dimensions (unless otherwise specified),
             * and automatically centered position (partial
             * support only so far).
             * If you use this, you shouldn't specify
             * SA_DClip.  SA_Overscan is for "standard"
             * overscan dimensions, SA_DClip is for
             * your custom numeric specifications.
             */
NATIVE {SA_Obsolete1}         CONST SA_OBSOLETE1         = (SA_DUMMY + $0015)
            /* obsolete S_MONITORNAME */

/** booleans **/
NATIVE {SA_ShowTitle}         CONST SA_SHOWTITLE         = (SA_DUMMY + $0016)
            /* boolean equivalent to flag SHOWTITLE    */
NATIVE {SA_Behind}            CONST SA_BEHIND            = (SA_DUMMY + $0017)
            /* boolean equivalent to flag SCREENBEHIND */
NATIVE {SA_Quiet}             CONST SA_QUIET             = (SA_DUMMY + $0018)
            /* boolean equivalent to flag SCREENQUIET  */
NATIVE {SA_AutoScroll}        CONST SA_AUTOSCROLL        = (SA_DUMMY + $0019)
            /* boolean equivalent to flag AUTOSCROLL   */
NATIVE {SA_Pens}              CONST SA_PENS              = (SA_DUMMY + $001A)
            /* pointer to ~0 terminated UWORD array, as
             * found in struct DrawInfo
             */
NATIVE {SA_FullPalette}       CONST SA_FULLPALETTE       = (SA_DUMMY + $001B)
            /* boolean: initialize color table to entire
             * preferences palette (32 for V36), rather
             * than compatible pens 0-3, 17-19, with
             * remaining palette as returned by GetColorMap()
             */

NATIVE {SA_ColorMapEntries}   CONST SA_COLORMAPENTRIES   = (SA_DUMMY + $001C)
            /* New for V39:
             * Allows you to override the number of entries
             * in the ColorMap for your screen.  Intuition
             * normally allocates (1<<depth) or 32, whichever
             * is more, but you may require even more if you
             * use certain V39 graphics.library features
             * (eg. palette-banking).
             */

NATIVE {SA_Parent}            CONST SA_PARENT            = (SA_DUMMY + $001D)
            /* New for V39:
             * ti_Data is a pointer to a "parent" screen to
             * attach this one to.  Attached screens slide
             * and depth-arrange together.
             */

NATIVE {SA_Draggable}         CONST SA_DRAGGABLE         = (SA_DUMMY + $001E)
            /* New for V39:
             * Boolean tag allowing non-draggable screens.
             * Do not use without good reason!
             * (Defaults to TRUE).
             */

NATIVE {SA_Exclusive}         CONST SA_EXCLUSIVE         = (SA_DUMMY + $001F)
            /* New for V39:
             * Boolean tag allowing screens that won't share
             * the display.  Use sparingly!  Starting with 3.01,
             * attached screens may be SA_Exclusive.  Setting
             * SA_Exclusive for each screen will produce an
             * exclusive family.   (Defaults to FALSE).
             */

NATIVE {SA_SharePens}         CONST SA_SHAREPENS         = (SA_DUMMY + $0020)
            /* New for V39:
             * For those pens in the screen's DrawInfo->dri_Pens,
             * Intuition obtains them in shared mode (see
             * graphics.library/ObtainPen()).  For compatibility,
             * Intuition obtains the other pens of a public
             * screen as PEN_EXCLUSIVE.  Screens that wish to
             * manage the pens themselves should generally set
             * this tag to TRUE.  This instructs Intuition to
             * leave the other pens unallocated.
             */

NATIVE {SA_BackFill}          CONST SA_BACKFILL          = (SA_DUMMY + $0021)
            /* New for V39:
             * provides a "backfill hook" for your screen's
             * Layer_Info.
             * See layers.library/InstallLayerInfoHook()
             */

NATIVE {SA_Interleaved}       CONST SA_INTERLEAVED       = (SA_DUMMY + $0022)
            /* New for V39:
             * Boolean tag requesting that the bitmap
             * allocated for you be interleaved.
             * (Defaults to FALSE).
             */

NATIVE {SA_Colors32}          CONST SA_COLORS32          = (SA_DUMMY + $0023)
            /* New for V39:
             * Tag to set the screen's initial palette colors
             * at 32 bits-per-gun.  ti_Data is a pointer
             * to a table to be passed to the
             * graphics.library/LoadRGB32() function.
             * This format supports both runs of color
             * registers and sparse registers.  See the
             * autodoc for that function for full details.
             * Any color set here has precedence over
             * the same register set by SA_Colors.
             */

NATIVE {SA_VideoControl}      CONST SA_VIDEOCONTROL      = (SA_DUMMY + $0024)
            /* New for V39:
             * ti_Data is a pointer to a taglist that Intuition
             * will pass to graphics.library/VideoControl(),
             * upon opening the screen.
             */

NATIVE {SA_FrontChild}        CONST SA_FRONTCHILD        = (SA_DUMMY + $0025)
            /* New for V39:
             * ti_Data is a pointer to an already open screen
             * that is to be the child of the screen being
             * opened.  The child screen will be moved to the
             * front of its family.
             */

NATIVE {SA_BackChild}         CONST SA_BACKCHILD         = (SA_DUMMY + $0026)
            /* New for V39:
             * ti_Data is a pointer to an already open screen
             * that is to be the child of the screen being
             * opened.  The child screen will be moved to the
             * back of its family.
             */

NATIVE {SA_LikeWorkbench}     CONST SA_LIKEWORKBENCH     = (SA_DUMMY + $0027)
            /* New for V39:
             * Set ti_Data to 1 to request a screen which
             * is just like the Workbench.  This gives
             * you the same screen mode, depth, size,
             * colors, etc., as the Workbench screen.
             */

NATIVE {SA_Reserved}          CONST SA_RESERVED          = (SA_DUMMY + $0028)
            /* Reserved for private Intuition use */

NATIVE {SA_MinimizeISG}       CONST SA_MINIMIZEISG       = (SA_DUMMY + $0029)
            /* New for V40:
             * For compatibility, Intuition always ensures
             * that the inter-screen gap is at least three
             * non-interlaced lines.  If your application
             * would look best with the smallest possible
             * inter-screen gap, set ti_Data to TRUE.
             * If you use the new graphics VideoControl()
             * VC_NoColorPaletteLoad tag for your screen's
             * ViewPort, you should also set this tag.
             */

NATIVE {SA_OffScreenDragging} CONST SA_OFFSCREENDRAGGING = (SA_DUMMY + $002a)
            /* New for V50:
             * When TRUE, windows can be dragged off the
             * screen.
             */

NATIVE {SA_Reserved2}         CONST SA_RESERVED2         = (SA_DUMMY + $002b)
            /* Reserved for private Intuition use. V50. */

NATIVE {SA_ActiveWindow}      CONST SA_ACTIVEWINDOW      = (SA_DUMMY + $002c)
            /* the active window of the screen. V50. */

NATIVE {SA_MaxWindowBox}      CONST SA_MAXWINDOWBOX      = (SA_DUMMY + $002d)
                        /* (struct IBox *). V50. PRIVATE */

NATIVE {SA_Reserved3}         CONST SA_RESERVED3         = (SA_DUMMY + $002e)
            /* Reserved for private Intuition use. V51. */

/* this is an obsolete tag included only for compatibility with V35
 * interim release for the A2024 and Viking monitors
 */
NATIVE {NSTAG_EXT_VPMODE} CONST NSTAG_EXT_VPMODE = (TAG_USER OR 1)


/* OpenScreen error codes, which are returned in the (optional) LONG
 * pointed to by ti_Data for the SA_ErrorCode tag item
 */
NATIVE {OSERR_NOMONITOR}    CONST OSERR_NOMONITOR    = (1)  /* named monitor spec not available    */
NATIVE {OSERR_NOCHIPS}      CONST OSERR_NOCHIPS      = (2)  /* you need newer custom chips         */
NATIVE {OSERR_NOMEM}        CONST OSERR_NOMEM        = (3)  /* couldn't get normal memory          */
NATIVE {OSERR_NOCHIPMEM}    CONST OSERR_NOCHIPMEM    = (4)  /* couldn't get chipmem                */
NATIVE {OSERR_PUBNOTUNIQUE} CONST OSERR_PUBNOTUNIQUE = (5)  /* public screen name already used     */
NATIVE {OSERR_UNKNOWNMODE}  CONST OSERR_UNKNOWNMODE  = (6)  /* don't recognize mode asked for      */
NATIVE {OSERR_TOODEEP}      CONST OSERR_TOODEEP      = (7)  /* Screen deeper than HW supports      */
NATIVE {OSERR_ATTACHFAIL}   CONST OSERR_ATTACHFAIL   = (8)  /* Failed to attach screens            */
NATIVE {OSERR_NOTAVAILABLE} CONST OSERR_NOTAVAILABLE = (9)  /* Mode not available for other reason */
NATIVE {OSERR_BADBITMAP}    CONST OSERR_BADBITMAP    = (10) /* Custom bitmap not displayable (V51) */

/* ======================================================================== */
/* === NewScreen ========================================================== */
/* ======================================================================== */
/* note: to use the Extended field, you must use the
 * new ExtNewScreen structure, below
 */
NATIVE {NewScreen} OBJECT ns
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT
	{Width}	width	:INT
	{Height}	height	:INT
	{Depth}	depth	:INT  /* screen dimensions */

    {DetailPen}	detailpen	:UBYTE
	{BlockPen}	blockpen	:UBYTE /* for bar/border/gadget rendering       */

    {ViewModes}	viewmodes	:UINT           /* the Modes for the ViewPort (and View) */

    {Type}	type	:UINT                /* the Screen type (see defines above)   */

    {Font}	font	:PTR TO textattr     /* this Screen's default text attributes */

    {DefaultTitle}	defaulttitle	:/*STRPTR*/ ARRAY OF CHAR       /* the default title for this Screen     */

    {Gadgets}	gadgets	:PTR TO gadget    /* UNUSED:  Leave this NULL              */

    /* if you are opening a CUSTOMSCREEN and already have a BitMap
     * that you want used for your Screen, you set the flags CUSTOMBITMAP in
     * the Type field and you set this variable to point to your BitMap
     * structure.  The structure will be copied into your Screen structure,
     * after which you may discard your own BitMap if you want
     */
    {CustomBitMap}	custombitmap	:PTR TO bitmap
ENDOBJECT

/*
 * For compatibility reasons, we need a new structure for extending
 * NewScreen.  Use this structure is you need to use the new Extension
 * field.
 *
 * NOTE: V36-specific applications should use the
 * OpenScreenTagList( newscreen, tags ) version of OpenScreen().
 * Applications that want to be V34-compatible as well may safely use the
 * ExtNewScreen structure.  Its tags will be ignored by V34 Intuition.
 *
 */
NATIVE {ExtNewScreen} OBJECT extnewscreen
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT
	{Width}	width	:INT
	{Height}	height	:INT
	{Depth}	depth	:INT
    {DetailPen}	detailpen	:UBYTE
	{BlockPen}	blockpen	:UBYTE
    {ViewModes}	viewmodes	:UINT
    {Type}	type	:UINT
    {Font}	font	:PTR TO textattr
    {DefaultTitle}	defaulttitle	:/*STRPTR*/ ARRAY OF CHAR
    {Gadgets}	gadgets	:PTR TO gadget
    {CustomBitMap}	custombitmap	:PTR TO bitmap

    {Extension}	extension	:ARRAY OF tagitem
                /* more specification data, scanned if
                 * NS_EXTENDED is set in NewScreen.Type
                 */
ENDOBJECT

/* === Overscan Types === */
NATIVE {OSCAN_TEXT}     CONST OSCAN_TEXT     = (1) /* entirely visible           */
NATIVE {OSCAN_STANDARD} CONST OSCAN_STANDARD = (2) /* just past edges            */
NATIVE {OSCAN_MAX}      CONST OSCAN_MAX      = (3) /* as much as possible        */
NATIVE {OSCAN_VIDEO}    CONST OSCAN_VIDEO    = (4) /* even more than is possible */


/* === Public Shared Screen Node === */

/* This is the representative of a public shared screen.
 * This is an internal data structure, but some functions may
 * present a copy of it to the calling application.  In that case,
 * be aware that the screen pointer of the structure can NOT be
 * used safely, since there is no guarantee that the referenced
 * screen will remain open and a valid data structure.
 *
 * Never change one of these.
 */

NATIVE {PubScreenNode} OBJECT pubscreennode
    {psn_Node}	ln	:ln         /* ln_Name is screen name           */
    {psn_Screen}	screen	:PTR TO screen
    {psn_Flags}	flags	:UINT        /* below                            */
    {psn_Size}	size	:INT         /* includes name buffer             */
    {psn_VisitorCount}	visitorcount	:INT /* how many visitor windows         */
    {psn_SigTask}	sigtask	:PTR TO tc      /* who to signal when visitors gone */
    {psn_SigBit}	sigbit	:UBYTE       /* which signal                     */
ENDOBJECT

NATIVE {PSNF_PRIVATE} CONST PSNF_PRIVATE = ($0001)

/* NOTE: Due to a bug in NextPubScreen(), make sure your buffer
 * actually has MAXPUBSCREENNAME+1 characters in it!
 */
NATIVE {MAXPUBSCREENNAME} CONST MAXPUBSCREENNAME = (139) /* names no longer, please    */

/* pub screen modes */
NATIVE {SHANGHAI}     CONST SHANGHAI     = $0001 /* put workbench windows on pub screen */
NATIVE {POPPUBSCREEN} CONST POPPUBSCREEN = $0002 /* pop pub screen to front when visitor opens */

/* New for V39:  Intuition has new screen depth-arrangement and movement
 * functions called ScreenDepth() and ScreenPosition() respectively.
 * These functions permit the old behavior of ScreenToFront(),
 * ScreenToBack(), and MoveScreen().  ScreenDepth() also allows
 * independent depth control of attached screens.  ScreenPosition()
 * optionally allows positioning screens even though they were opened
 * {SA_Draggable,FALSE}.
 */

/* For ScreenDepth(), specify one of SDEPTH_TOFRONT or SDEPTH_TOBACK,
 * and optionally also SDEPTH_INFAMILY.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * SDEPTH_INFAMILY.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.  (Note that this is a style-behavior
 * requirement;  there is no technical requirement that the
 * task calling this function need be the task which opened
 * the screen).
 */

NATIVE {SDEPTH_TOFRONT}   CONST SDEPTH_TOFRONT   = (0) /* Bring screen to front */
NATIVE {SDEPTH_TOBACK}    CONST SDEPTH_TOBACK    = (1) /* Send screen to back */
NATIVE {SDEPTH_INFAMILY}  CONST SDEPTH_INFAMILY  = (2) /* Move an attached screen with
                              * respect to other screens of
                              * its family
                              */

/* Here's an obsolete name equivalent to SDEPTH_INFAMILY: */
NATIVE {SDEPTH_CHILDONLY} CONST SDEPTH_CHILDONLY = SDEPTH_INFAMILY


/* For ScreenPosition(), specify one of SPOS_RELATIVE, SPOS_ABSOLUTE,
 * or SPOS_MAKEVISIBLE to describe the kind of screen positioning you
 * wish to perform:
 *
 * SPOS_RELATIVE: The x1 and y1 parameters to ScreenPosition() describe
 *    the offset in coordinates you wish to move the screen by.
 * SPOS_ABSOLUTE: The x1 and y1 parameters to ScreenPosition() describe
 *    the absolute coordinates you wish to move the screen to.
 * SPOS_MAKEVISIBLE: (x1,y1)-(x2,y2) describes a rectangle on the
 *    screen which you would like autoscrolled into view.
 *
 * You may additionally set SPOS_FORCEDRAG along with any of the
 * above.  Set this if you wish to reposition an {SA_Draggable,FALSE}
 * screen that you opened.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * SPOS_FORCEDRAG.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.
 */

NATIVE {SPOS_RELATIVE}    CONST SPOS_RELATIVE    = (0) /* Coordinates are relative */

NATIVE {SPOS_ABSOLUTE}    CONST SPOS_ABSOLUTE    = (1) /* Coordinates are expressed as
                              * absolutes, not relatives.
                              */

NATIVE {SPOS_MAKEVISIBLE} CONST SPOS_MAKEVISIBLE = (2) /* Coordinates describe a box on
                              * the screen you wish to be
                              * made visible by autoscrolling
                              */

NATIVE {SPOS_FORCEDRAG}   CONST SPOS_FORCEDRAG   = (4) /* Move non-draggable screen */

/* New for V39: Intuition supports double-buffering in screens,
 * with friendly interaction with menus and certain gadgets.
 * For each buffer, you need to get one of these structures
 * from the AllocScreenBuffer() call.  Never allocate your
 * own ScreenBuffer structures!
 *
 * The sb_DBufInfo field is for your use.  See the graphics.library
 * AllocDBufInfo() autodoc for details.
 */
NATIVE {ScreenBuffer} OBJECT screenbuffer
    {sb_BitMap}	bitmap	:PTR TO bitmap   /* BitMap of this buffer    */
    {sb_DBufInfo}	dbufinfo	:PTR TO dbufinfo /* DBufInfo for this buffer */
ENDOBJECT

/* These are the flags that may be passed to AllocScreenBuffer().
 */
NATIVE {SB_SCREEN_BITMAP} CONST SB_SCREEN_BITMAP = 1
NATIVE {SB_COPY_BITMAP}   CONST SB_COPY_BITMAP   = 2
