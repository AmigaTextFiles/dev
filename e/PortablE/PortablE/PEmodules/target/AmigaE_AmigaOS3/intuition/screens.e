/* $VER: screens.h 38.25 (15.2.1993) */
OPT NATIVE
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/clip', 'target/graphics/view', 'target/graphics/rastport', 'target/graphics/layers', 'target/utility/tagitem' /*, 'target/intuition/iobsolete'*/
MODULE 'target/graphics/text', 'target/exec/nodes', 'target/exec/tasks'
{MODULE 'intuition/screens'}

/* ======================================================================== */
/* === DrawInfo ========================================================= */
/* ======================================================================== */

NATIVE {DRI_VERSION}	CONST DRI_VERSION	= (2)

NATIVE {drawinfo} OBJECT drawinfo
    {version}	version	:UINT	/* will be  DRI_VERSION			*/
    {numpens}	numpens	:UINT	/* guaranteed to be >= 9		*/
    {pens}	pens	:PTR TO UINT	/* pointer to pen array			*/

    {font}	font	:PTR TO textfont	/* screen default font		*/
    {depth}	depth	:UINT	/* (initial) depth of screen bitmap	*/

    	  /* from DisplayInfo database for initial display mode	*/
	{resolutionx}	resolutionx	:UINT
	{resolutiony}	resolutiony	:UINT

    {flags}	flags	:ULONG		/* defined below		*/
/* New for V39: dri_CheckMark, dri_AmigaKey. */
    {checkmark}	checkmark	:PTR TO image	/* pointer to scaled checkmark image
					 * Will be NULL if DRI_VERSION < 2
					 */
    {amigakey}	amigakey	:PTR TO image	/* pointer to scaled Amiga-key image
					 * Will be NULL if DRI_VERSION < 2
					 */
    {longreserved}	longreserved[5]	:ARRAY OF ULONG	/* avoid recompilation ;^)	*/
ENDOBJECT

NATIVE {DRIF_NEWLOOK}	CONST DRIF_NEWLOOK	= $00000001	/* specified SA_Pens, full treatment */

/* rendering pen number indexes into DrawInfo.dri_Pens[]	*/
NATIVE {DETAILPEN}	 CONST DETAILPEN	 = ($0000)	/* compatible Intuition rendering pens	*/
NATIVE {BLOCKPEN}	 CONST BLOCKPEN	 = ($0001)	/* compatible Intuition rendering pens	*/
NATIVE {TEXTPEN}		 CONST TEXTPEN		 = ($0002)	/* text on background			*/
NATIVE {SHINEPEN}	 CONST SHINEPEN	 = ($0003)	/* bright edge on 3D objects		*/
NATIVE {SHADOWPEN}	 CONST SHADOWPEN	 = ($0004)	/* dark edge on 3D objects		*/
NATIVE {FILLPEN}		 CONST FILLPEN		 = ($0005)	/* active-window/selected-gadget fill	*/
NATIVE {FILLTEXTPEN}	 CONST FILLTEXTPEN	 = ($0006)	/* text over FILLPEN			*/
NATIVE {BACKGROUNDPEN}	 CONST BACKGROUNDPEN	 = ($0007)	/* may not always be color 0		*/
NATIVE {HIGHLIGHTTEXTPEN} CONST HIGHLIGHTTEXTPEN = ($0008)	/* special color text, on background	*/
/* New for V39, only present if DRI_VERSION >= 2: */
NATIVE {BARDETAILPEN}	 CONST BARDETAILPEN	 = ($0009)	/* text/detail in screen-bar/menus */
NATIVE {BARBLOCKPEN}	 CONST BARBLOCKPEN	 = ($000A)	/* screen-bar/menus fill */
NATIVE {BARTRIMPEN}	 CONST BARTRIMPEN	 = ($000B)	/* trim under screen-bar */

NATIVE {NUMDRIPENS}	 CONST NUMDRIPENS	 = ($000C)


NATIVE {PEN_C3}		CONST PEN_C3		= $FEFC		/* Complement of color 3 */
NATIVE {PEN_C2}		CONST PEN_C2		= $FEFD		/* Complement of color 2 */
NATIVE {PEN_C1}		CONST PEN_C1		= $FEFE		/* Complement of color 1 */
NATIVE {PEN_C0}		CONST PEN_C0		= $FEFF		/* Complement of color 0 */

/* ======================================================================== */
/* === Screen ============================================================= */
/* ======================================================================== */

->"OBJECT screen" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* --- FLAGS SET BY INTUITION --------------------------------------------- */
NATIVE {SCREENTYPE}	CONST SCREENTYPE	= $000F	/* all the screens types available	*/
/* --- the definitions for the Screen Type ------------------------------- */
NATIVE {WBENCHSCREEN}	CONST WBENCHSCREEN	= $0001	/* identifies the Workbench screen	*/
NATIVE {PUBLICSCREEN}	CONST PUBLICSCREEN	= $0002	/* public shared (custom) screen	*/
NATIVE {CUSTOMSCREEN}	CONST CUSTOMSCREEN	= $000F	/* original custom screens		*/

NATIVE {SHOWTITLE}	CONST SHOWTITLE	= $0010	/* this gets set by a call to ShowTitle() */

NATIVE {BEEPING}		CONST BEEPING		= $0020	/* set when Screen is beeping (private)	*/

NATIVE {CUSTOMBITMAP}	CONST CUSTOMBITMAP	= $0040	/* if you are supplying your own BitMap */

NATIVE {SCREENBEHIND}	CONST SCREENBEHIND	= $0080	/* if you want your screen to open behind
				 * already open screens
				 */
NATIVE {SCREENQUIET}	CONST SCREENQUIET	= $0100	/* if you do not want Intuition to render
				 * into your screen (gadgets, title)
				 */
NATIVE {SCREENHIRES}	CONST SCREENHIRES	= $0200	/* do not use lowres gadgets  (private)	*/

NATIVE {NS_EXTENDED}	CONST NS_EXTENDED	= $1000		/* ExtNewScreen.Extension is valid	*/
/* V36 applications can use OpenScreenTagList() instead of NS_EXTENDED	*/

NATIVE {AUTOSCROLL}	CONST AUTOSCROLL	= $4000	/* screen is to autoscoll		*/

/* New for V39: */
NATIVE {PENSHARED}	CONST PENSHARED	= $0400	/* Screen opener set {SA_SharePens,TRUE} */




NATIVE {STDSCREENHEIGHT} CONST STDSCREENHEIGHT = -1	/* supply in NewScreen.Height		*/
NATIVE {STDSCREENWIDTH} CONST STDSCREENWIDTH = -1	/* supply in NewScreen.Width		*/

NATIVE {SA_DUMMY}	CONST SA_DUMMY	= (TAG_USER + 32)
NATIVE {SA_LEFT}		CONST SA_LEFT		= (SA_DUMMY + $0001)
NATIVE {SA_TOP}		CONST SA_TOP		= (SA_DUMMY + $0002)
NATIVE {SA_WIDTH}	CONST SA_WIDTH	= (SA_DUMMY + $0003)
NATIVE {SA_HEIGHT}	CONST SA_HEIGHT	= (SA_DUMMY + $0004)
NATIVE {SA_DEPTH}	CONST SA_DEPTH	= (SA_DUMMY + $0005)
NATIVE {SA_DETAILPEN}	CONST SA_DETAILPEN	= (SA_DUMMY + $0006)
NATIVE {SA_BLOCKPEN}	CONST SA_BLOCKPEN	= (SA_DUMMY + $0007)
NATIVE {SA_TITLE}	CONST SA_TITLE	= (SA_DUMMY + $0008)
NATIVE {SA_COLORS}	CONST SA_COLORS	= (SA_DUMMY + $0009)
NATIVE {SA_ERRORCODE}	CONST SA_ERRORCODE	= (SA_DUMMY + $000A)
NATIVE {SA_FONT}		CONST SA_FONT		= (SA_DUMMY + $000B)
NATIVE {SA_SYSFONT}	CONST SA_SYSFONT	= (SA_DUMMY + $000C)
NATIVE {SA_TYPE}		CONST SA_TYPE		= (SA_DUMMY + $000D)
NATIVE {SA_BITMAP}	CONST SA_BITMAP	= (SA_DUMMY + $000E)
NATIVE {SA_PUBNAME}	CONST SA_PUBNAME	= (SA_DUMMY + $000F)
NATIVE {SA_PUBSIG}	CONST SA_PUBSIG	= (SA_DUMMY + $0010)
NATIVE {SA_PUBTASK}	CONST SA_PUBTASK	= (SA_DUMMY + $0011)
NATIVE {SA_DISPLAYID}	CONST SA_DISPLAYID	= (SA_DUMMY + $0012)
NATIVE {SA_DCLIP}	CONST SA_DCLIP	= (SA_DUMMY + $0013)
NATIVE {SA_OVERSCAN}	CONST SA_OVERSCAN	= (SA_DUMMY + $0014)
NATIVE {SA_OBSOLETE1}	CONST SA_OBSOLETE1	= (SA_DUMMY + $0015)

/** booleans **/
NATIVE {SA_SHOWTITLE}	CONST SA_SHOWTITLE	= (SA_DUMMY + $0016)
NATIVE {SA_BEHIND}	CONST SA_BEHIND	= (SA_DUMMY + $0017)
NATIVE {SA_QUIET}	CONST SA_QUIET	= (SA_DUMMY + $0018)
NATIVE {SA_AUTOSCROLL}	CONST SA_AUTOSCROLL	= (SA_DUMMY + $0019)
NATIVE {SA_PENS}		CONST SA_PENS		= (SA_DUMMY + $001A)
NATIVE {SA_FULLPALETTE}	CONST SA_FULLPALETTE	= (SA_DUMMY + $001B)

NATIVE {SA_COLORMAPENTRIES} CONST SA_COLORMAPENTRIES = (SA_DUMMY + $001C)

NATIVE {SA_PARENT}	CONST SA_PARENT	= (SA_DUMMY + $001D)

NATIVE {SA_DRAGGABLE}	CONST SA_DRAGGABLE	= (SA_DUMMY + $001E)

NATIVE {SA_EXCLUSIVE}	CONST SA_EXCLUSIVE	= (SA_DUMMY + $001F)

NATIVE {SA_SHAREPENS}	CONST SA_SHAREPENS	= (SA_DUMMY + $0020)

NATIVE {SA_BACKFILL}	CONST SA_BACKFILL	= (SA_DUMMY + $0021)

NATIVE {SA_INTERLEAVED}	CONST SA_INTERLEAVED	= (SA_DUMMY + $0022)

NATIVE {SA_COLORS32}	CONST SA_COLORS32	= (SA_DUMMY + $0023)

NATIVE {SA_VIDEOCONTROL}	CONST SA_VIDEOCONTROL	= (SA_DUMMY + $0024)

NATIVE {SA_FRONTCHILD}	CONST SA_FRONTCHILD	= (SA_DUMMY + $0025)

NATIVE {SA_BACKCHILD}	CONST SA_BACKCHILD	= (SA_DUMMY + $0026)

NATIVE {SA_LIKEWORKBENCH}	CONST SA_LIKEWORKBENCH	= (SA_DUMMY + $0027)

NATIVE {SA_RESERVED}		CONST SA_RESERVED		= (SA_DUMMY + $0028)

NATIVE {SA_MINIMIZEISG}		CONST SA_MINIMIZEISG		= (SA_DUMMY + $0029)

->NATIVE {NSTAG_EXT_VPMODE} CONST NSTAG_EXT_VPMODE = (TAG_USER OR 1)


NATIVE {OSERR_NOMONITOR}	   CONST OSERR_NOMONITOR	   = (1)	/* named monitor spec not available	*/
NATIVE {OSERR_NOCHIPS}	   CONST OSERR_NOCHIPS	   = (2)	/* you need newer custom chips		*/
NATIVE {OSERR_NOMEM}	   CONST OSERR_NOMEM	   = (3)	/* couldn't get normal memory		*/
NATIVE {OSERR_NOCHIPMEM}	   CONST OSERR_NOCHIPMEM	   = (4)	/* couldn't get chipmem			*/
NATIVE {OSERR_PUBNOTUNIQUE} CONST OSERR_PUBNOTUNIQUE = (5)	/* public screen name already used	*/
NATIVE {OSERR_UNKNOWNMODE}  CONST OSERR_UNKNOWNMODE  = (6)	/* don't recognize mode asked for	*/
NATIVE {OSERR_TOODEEP}	   CONST OSERR_TOODEEP	   = (7)	/* Screen deeper than HW supports	*/
NATIVE {OSERR_ATTACHFAIL}   CONST OSERR_ATTACHFAIL   = (8)	/* Failed to attach screens		*/
NATIVE {OSERR_NOTAVAILABLE} CONST OSERR_NOTAVAILABLE = (9)	/* Mode not available for other reason	*/

/* ======================================================================== */
/* === NewScreen ========================================================== */
/* ======================================================================== */
NATIVE {ns} OBJECT ns
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT
	{width}	width	:INT
	{height}	height	:INT
	{depth}	depth	:INT  /* screen dimensions */

    {detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE	/* for bar/border/gadget rendering	*/

    {viewmodes}	viewmodes	:UINT		/* the Modes for the ViewPort (and View) */

    {type}	type	:UINT			/* the Screen type (see defines above)	*/

    {font}	font	:PTR TO textattr	/* this Screen's default text attributes */

    {defaulttitle}	defaulttitle	:ARRAY OF UBYTE	/* the default title for this Screen	*/

    {gadgets}	gadgets	:PTR TO gadget	/* UNUSED:  Leave this NULL		*/

    {custombitmap}	custombitmap	:PTR TO bitmap
ENDOBJECT

NATIVE {extnewscreen} OBJECT extnewscreen
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT
	{width}	width	:INT
	{height}	height	:INT
	{depth}	depth	:INT
    {detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE
    {viewmodes}	viewmodes	:UINT
    {type}	type	:UINT
    {font}	font	:PTR TO textattr
    {defaulttitle}	defaulttitle	:ARRAY OF UBYTE
    {gadgets}	gadgets	:PTR TO gadget
    {custombitmap}	custombitmap	:PTR TO bitmap

    {extension}	extension	:ARRAY OF tagitem
ENDOBJECT

/* === Overscan Types ===	*/
NATIVE {OSCAN_TEXT}	CONST OSCAN_TEXT	= (1)	/* entirely visible	*/
NATIVE {OSCAN_STANDARD}	CONST OSCAN_STANDARD	= (2)	/* just past edges	*/
NATIVE {OSCAN_MAX}	CONST OSCAN_MAX	= (3)	/* as much as possible	*/
NATIVE {OSCAN_VIDEO}	CONST OSCAN_VIDEO	= (4)	/* even more than is possible	*/


/* === Public Shared Screen Node ===	*/

NATIVE {pubscreennode} OBJECT pubscreennode
    {node}	ln	:ln	/* ln_Name is screen name */
    {screen}	screen	:PTR TO screen
    {flags}	flags	:UINT	/* below		*/
    {size}	size	:INT	/* includes name buffer	*/
    {visitorcount}	visitorcount	:INT /* how many visitor windows */
    {sigtask}	sigtask	:PTR TO tc	/* who to signal when visitors gone */
    {sigbit}	sigbit	:UBYTE	/* which signal	*/
ENDOBJECT

NATIVE {PSNF_PRIVATE}	CONST PSNF_PRIVATE	= ($0001)

NATIVE {MAXPUBSCREENNAME}	CONST MAXPUBSCREENNAME	= (139)	/* names no longer, please	*/

/* pub screen modes	*/
NATIVE {SHANGHAI}	CONST SHANGHAI	= $0001	/* put workbench windows on pub screen */
NATIVE {POPPUBSCREEN}	CONST POPPUBSCREEN	= $0002	/* pop pub screen to front when visitor opens */

NATIVE {SDEPTH_TOFRONT}			CONST SDEPTH_TOFRONT			= (0)	/* Bring screen to front */
NATIVE {SDEPTH_TOBACK}		CONST SDEPTH_TOBACK		= (1)	/* Send screen to back */
NATIVE {SDEPTH_INFAMILY}		CONST SDEPTH_INFAMILY		= (2)	/* Move an attached screen with
					 * respect to other screens of
					 * its family
					 */

/* Here's an obsolete name equivalent to SDEPTH_INFAMILY: */
NATIVE {SDEPTH_CHILDONLY}	CONST SDEPTH_CHILDONLY	= SDEPTH_INFAMILY


NATIVE {SPOS_RELATIVE}		CONST SPOS_RELATIVE		= (0)	/* Coordinates are relative */

NATIVE {SPOS_ABSOLUTE}		CONST SPOS_ABSOLUTE		= (1)	/* Coordinates are expressed as
					 * absolutes, not relatives.
					 */

NATIVE {SPOS_MAKEVISIBLE}	CONST SPOS_MAKEVISIBLE	= (2)	/* Coordinates describe a box on
					 * the screen you wish to be
					 * made visible by autoscrolling
					 */

NATIVE {SPOS_FORCEDRAG}		CONST SPOS_FORCEDRAG		= (4)	/* Move non-draggable screen */

NATIVE {screenbuffer} OBJECT screenbuffer
    {bitmap}	bitmap	:PTR TO bitmap		/* BitMap of this buffer */
    {dbufinfo}	dbufinfo	:PTR TO dbufinfo	/* DBufInfo for this buffer */
ENDOBJECT

/* These are the flags that may be passed to AllocScreenBuffer(). */
NATIVE {SB_SCREEN_BITMAP}	CONST SB_SCREEN_BITMAP	= 1
NATIVE {SB_COPY_BITMAP}		CONST SB_COPY_BITMAP		= 2
