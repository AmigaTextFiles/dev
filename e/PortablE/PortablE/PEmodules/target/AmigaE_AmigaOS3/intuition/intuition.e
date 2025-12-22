/* $VER: intuition.h 38.26 (15.2.1993) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/clip', 'target/graphics/view', 'target/graphics/rastport', 'target/graphics/layers', 'target/graphics/text', 'target/exec/ports', 'target/devices/inputevent', 'target/utility/tagitem', 'target/intuition/screens', 'target/intuition/preferences' /*, 'target/intuition/iobsolete'*/
MODULE 'target/intuition/intuition_shared2', 'target/devices/keymap'
{MODULE 'intuition/intuition'}

/* ======================================================================== */
/* === Menu =============================================================== */
/* ======================================================================== */
->"OBJECT menu" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* FLAGS SET BY BOTH THE APPLIPROG AND INTUITION */
NATIVE {MENUENABLED} CONST MENUENABLED = $0001	/* whether or not this menu is enabled */

/* FLAGS SET BY INTUITION */
NATIVE {MIDRAWN} CONST MIDRAWN = $0100		/* this menu's items are currently drawn */






/* ======================================================================== */
/* === MenuItem =========================================================== */
/* ======================================================================== */
->"OBJECT menuitem" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* FLAGS SET BY THE APPLIPROG */
NATIVE {CHECKIT}		CONST CHECKIT		= $0001	/* set to indicate checkmarkable item */
NATIVE {ITEMTEXT}	CONST ITEMTEXT	= $0002	/* set if textual, clear if graphical item */
NATIVE {COMMSEQ}		CONST COMMSEQ		= $0004	/* set if there's an command sequence */
NATIVE {MENUTOGGLE}	CONST MENUTOGGLE	= $0008	/* set for toggling checks (else mut. exclude) */
NATIVE {ITEMENABLED}	CONST ITEMENABLED	= $0010	/* set if this item is enabled */

/* these are the SPECIAL HIGHLIGHT FLAG state meanings */
NATIVE {HIGHFLAGS}	CONST HIGHFLAGS	= $00C0	/* see definitions below for these bits */
NATIVE {HIGHIMAGE}	CONST HIGHIMAGE	= $0000	/* use the user's "select image" */
NATIVE {HIGHCOMP}	CONST HIGHCOMP	= $0040	/* highlight by complementing the selectbox */
NATIVE {HIGHBOX}		CONST HIGHBOX		= $0080	/* highlight by "boxing" the selectbox */
NATIVE {HIGHNONE}	CONST HIGHNONE	= $00C0	/* don't highlight */

/* FLAGS SET BY BOTH APPLIPROG AND INTUITION */
NATIVE {CHECKED}	CONST CHECKED	= $0100	/* state of the checkmark */

/* FLAGS SET BY INTUITION */
NATIVE {ISDRAWN}		CONST ISDRAWN		= $1000	/* this item's subs are currently drawn */
NATIVE {HIGHITEM}	CONST HIGHITEM	= $2000	/* this item is currently highlighted */
NATIVE {MENUTOGGLED}	CONST MENUTOGGLED	= $4000	/* this item was already toggled */





/* ======================================================================== */
/* === Requester ========================================================== */
/* ======================================================================== */
->"OBJECT requester" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* FLAGS SET BY THE APPLIPROG */
NATIVE {POINTREL}	CONST POINTREL	= $0001
NATIVE {PREDRAWN}	CONST PREDRAWN	= $0002
NATIVE {NOISYREQ}	CONST NOISYREQ	= $0004
NATIVE {SIMPLEREQ}	CONST SIMPLEREQ	= $0010

/* New for V36		*/
NATIVE {USEREQIMAGE}	CONST USEREQIMAGE	= $0020
NATIVE {NOREQBACKFILL}	CONST NOREQBACKFILL	= $0040


/* FLAGS SET BY INTUITION */
NATIVE {REQOFFWINDOW}	CONST REQOFFWINDOW	= $1000	/* part of one of the Gadgets was offwindow */
NATIVE {REQACTIVE}	CONST REQACTIVE	= $2000	/* this requester is active */
NATIVE {SYSREQUEST}	CONST SYSREQUEST	= $4000	/* (unused) this requester caused by system */
NATIVE {DEFERREFRESH}	CONST DEFERREFRESH	= $8000	/* this Requester stops a Refresh broadcast */






/* ======================================================================== */
/* === Gadget ============================================================= */
/* ======================================================================== */
->"OBJECT gadget" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


NATIVE {extgadget} OBJECT extgadget
    /* The first fields match struct Gadget exactly */
    {nextgadget}	nextgadget	:PTR TO extgadget /* Matches struct Gadget */
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT	  /* Matches struct Gadget */
    {width}	width	:INT
	{height}	height	:INT		  /* Matches struct Gadget */
    {flags}	flags	:UINT		  /* Matches struct Gadget */
    {activation}	activation	:UINT		  /* Matches struct Gadget */
    {gadgettype}	gadgettype	:UINT		  /* Matches struct Gadget */
    {gadgetrender}	gadgetrender	:APTR		  /* Matches struct Gadget */
    {selectrender}	selectrender	:APTR		  /* Matches struct Gadget */
    {gadgettext}	gadgettext	:PTR TO intuitext /* Matches struct Gadget */
    {mutualexclude}	mutualexclude	:VALUE		  /* Matches struct Gadget */
    {specialinfo}	specialinfo	:APTR		  /* Matches struct Gadget */
    {gadgetid}	gadgetid	:UINT		  /* Matches struct Gadget */
    {userdata}	userdata	:APTR		  /* Matches struct Gadget */

    /* These fields only exist under V39 and only if GFLG_EXTENDED is set */
    {moreflags}	moreflags	:ULONG		/* see GMORE_ flags below */
    {boundsleftedge}	boundsleftedge	:INT	/* Bounding extent for gadget, valid   */
    {boundstopedge}	boundstopedge	:INT		/* only if GMORE_BOUNDS is set.  The   */
    {boundswidth}	boundswidth	:INT		/* GFLG_RELxxx flags affect these      */
    {boundsheight}	boundsheight	:INT		/* coordinates as well.	       */
ENDOBJECT


/* --- Gadget.Flags values	--- */
/* combinations in these bits describe the highlight technique to be used */
NATIVE {GFLG_GADGHIGHBITS} CONST GFLG_GADGHIGHBITS = $0003
NATIVE {GFLG_GADGHCOMP}	  CONST GFLG_GADGHCOMP	  = $0000  /* Complement the select box */
NATIVE {GFLG_GADGHBOX}	  CONST GFLG_GADGHBOX	  = $0001  /* Draw a box around the image */
NATIVE {GFLG_GADGHIMAGE}	  CONST GFLG_GADGHIMAGE	  = $0002  /* Blast in this alternate image */
NATIVE {GFLG_GADGHNONE}	  CONST GFLG_GADGHNONE	  = $0003  /* don't highlight */

NATIVE {GFLG_GADGIMAGE}		  CONST GFLG_GADGIMAGE		  = $0004  /* set if GadgetRender and SelectRender
				   * point to an Image structure, clear
				   * if they point to Border structures
				   */

NATIVE {GFLG_RELBOTTOM}	  CONST GFLG_RELBOTTOM	  = $0008  /* vert. pos. is relative to bottom edge */
NATIVE {GFLG_RELRIGHT}	  CONST GFLG_RELRIGHT	  = $0010  /* horiz. pos. is relative to right edge */
NATIVE {GFLG_RELWIDTH}	  CONST GFLG_RELWIDTH	  = $0020  /* width is relative to req/window	*/
NATIVE {GFLG_RELHEIGHT}	  CONST GFLG_RELHEIGHT	  = $0040  /* height is relative to req/window	*/

NATIVE {GFLG_RELSPECIAL}	  CONST GFLG_RELSPECIAL	  = $4000  /* custom gadget has special relativity.
				   * Gadget box values are absolutes, but
				   * can be changed via the GM_LAYOUT method.
				   */
NATIVE {GFLG_SELECTED}	  CONST GFLG_SELECTED	  = $0080  /* you may initialize and look at this	*/

NATIVE {GFLG_DISABLED}	  CONST GFLG_DISABLED	  = $0100

NATIVE {GFLG_LABELMASK}	  CONST GFLG_LABELMASK	  = $3000
NATIVE {GFLG_LABELITEXT}	  CONST GFLG_LABELITEXT	  = $0000  /* GadgetText points to IntuiText	*/
NATIVE {GFLG_LABELSTRING}  CONST GFLG_LABELSTRING  = $1000  /* GadgetText points to (UBYTE *)	*/
NATIVE {GFLG_LABELIMAGE}	  CONST GFLG_LABELIMAGE	  = $2000  /* GadgetText points to Image (object)	*/

/* New for V37: GFLG_TABCYCLE */
NATIVE {GFLG_TABCYCLE}	  CONST GFLG_TABCYCLE	  = $0200  /* (string or custom) gadget participates in
				   * cycling activation with Tab or Shift-Tab
				   */
NATIVE {GFLG_STRINGEXTEND} CONST GFLG_STRINGEXTEND = $0400  /* this String Gadget has StringExtend	*/

NATIVE {GFLG_IMAGEDISABLE} CONST GFLG_IMAGEDISABLE = $0800  /* Gadget's image knows how to do disabled
				   * rendering
				   */

NATIVE {GFLG_EXTENDED}	  CONST GFLG_EXTENDED	  = $8000  /* Gadget is extended */

/* ---	Gadget.Activation flag values	--- */
NATIVE {GACT_RELVERIFY}	  CONST GACT_RELVERIFY	  = $0001

NATIVE {GACT_IMMEDIATE}	  CONST GACT_IMMEDIATE	  = $0002

NATIVE {GACT_ENDGADGET}	  CONST GACT_ENDGADGET	  = $0004

NATIVE {GACT_FOLLOWMOUSE}  CONST GACT_FOLLOWMOUSE  = $0008

NATIVE {GACT_RIGHTBORDER}  CONST GACT_RIGHTBORDER  = $0010
NATIVE {GACT_LEFTBORDER}	  CONST GACT_LEFTBORDER	  = $0020
NATIVE {GACT_TOPBORDER}	  CONST GACT_TOPBORDER	  = $0040
NATIVE {GACT_BOTTOMBORDER} CONST GACT_BOTTOMBORDER = $0080
NATIVE {GACT_BORDERSNIFF}  CONST GACT_BORDERSNIFF  = $8000  /* neither set nor rely on this bit	*/

NATIVE {GACT_TOGGLESELECT} CONST GACT_TOGGLESELECT = $0100  /* this bit for toggle-select mode */
NATIVE {GACT_BOOLEXTEND}	  CONST GACT_BOOLEXTEND	  = $2000  /* this Boolean Gadget has a BoolInfo	*/

/* should properly be in StringInfo, but aren't	*/
NATIVE {GACT_STRINGLEFT}	  CONST GACT_STRINGLEFT	  = $0000  /* NOTE WELL: that this has value zero	*/
NATIVE {GACT_STRINGCENTER} CONST GACT_STRINGCENTER = $0200
NATIVE {GACT_STRINGRIGHT}  CONST GACT_STRINGRIGHT  = $0400
NATIVE {GACT_LONGINT}	  CONST GACT_LONGINT	  = $0800  /* this String Gadget is for Long Ints	*/
NATIVE {GACT_ALTKEYMAP}	  CONST GACT_ALTKEYMAP	  = $1000  /* this String has an alternate keymap	*/
NATIVE {GACT_STRINGEXTEND} CONST GACT_STRINGEXTEND = $2000  /* this String Gadget has StringExtend	*/

NATIVE {GACT_ACTIVEGADGET} CONST GACT_ACTIVEGADGET = $4000  /* this gadget is "active".  This flag
				   * is maintained by Intuition, and you
				   * cannot count on its value persisting
				   * while you do something on your program's
				   * task.  It can only be trusted by
				   * people implementing custom gadgets
				   */

/* --- GADGET TYPES ------------------------------------------------------- */
NATIVE {GTYP_GADGETTYPE}	CONST GTYP_GADGETTYPE	= $FC00	/* all Gadget Global Type flags (padded) */

NATIVE {GTYP_SCRGADGET}		CONST GTYP_SCRGADGET		= $4000	/* 1 = ScreenGadget, 0 = WindowGadget */
NATIVE {GTYP_GZZGADGET}		CONST GTYP_GZZGADGET		= $2000	/* 1 = for WFLG_GIMMEZEROZERO borders */
NATIVE {GTYP_REQGADGET}		CONST GTYP_REQGADGET		= $1000	/* 1 = this is a Requester Gadget */

NATIVE {GTYP_SYSGADGET}		CONST GTYP_SYSGADGET		= $8000
NATIVE {GTYP_SYSTYPEMASK}	CONST GTYP_SYSTYPEMASK	= $00F0

/* These definitions describe system gadgets in V36 and higher: */
NATIVE {GTYP_SIZING}		CONST GTYP_SIZING		= $0010	/* Window sizing gadget */
NATIVE {GTYP_WDRAGGING}		CONST GTYP_WDRAGGING		= $0020	/* Window drag bar */
NATIVE {GTYP_SDRAGGING}		CONST GTYP_SDRAGGING		= $0030	/* Screen drag bar */
NATIVE {GTYP_WDEPTH}		CONST GTYP_WDEPTH		= $0040	/* Window depth gadget */
NATIVE {GTYP_SDEPTH}		CONST GTYP_SDEPTH		= $0050	/* Screen depth gadget */
NATIVE {GTYP_WZOOM}		CONST GTYP_WZOOM		= $0060	/* Window zoom gadget */
NATIVE {GTYP_SUNUSED}		CONST GTYP_SUNUSED		= $0070	/* Unused screen gadget */
NATIVE {GTYP_CLOSE}		CONST GTYP_CLOSE		= $0080	/* Window close gadget */

/* These definitions describe system gadgets prior to V36: */
NATIVE {GTYP_WUPFRONT}		CONST GTYP_WUPFRONT		= GTYP_WDEPTH	/* Window to-front gadget */
NATIVE {GTYP_SUPFRONT}		CONST GTYP_SUPFRONT		= GTYP_SDEPTH	/* Screen to-front gadget */
NATIVE {GTYP_WDOWNBACK}		CONST GTYP_WDOWNBACK		= GTYP_WZOOM	/* Window to-back gadget */
NATIVE {GTYP_SDOWNBACK}		CONST GTYP_SDOWNBACK		= GTYP_SUNUSED	/* Screen to-back gadget */

NATIVE {GTYP_GTYPEMASK}		CONST GTYP_GTYPEMASK		= $0007

NATIVE {GTYP_BOOLGADGET}		CONST GTYP_BOOLGADGET		= $0001
NATIVE {GTYP_GADGET0002}		CONST GTYP_GADGET0002		= $0002
NATIVE {GTYP_PROPGADGET}		CONST GTYP_PROPGADGET		= $0003
NATIVE {GTYP_STRGADGET}		CONST GTYP_STRGADGET		= $0004
NATIVE {GTYP_CUSTOMGADGET}	CONST GTYP_CUSTOMGADGET	= $0005

NATIVE {GMORE_BOUNDS}	   CONST GMORE_BOUNDS	   = $00000001 /* ExtGadget has valid Bounds */
NATIVE {GMORE_GADGETHELP}   CONST GMORE_GADGETHELP   = $00000002 /* This gadget responds to gadget help */
NATIVE {GMORE_SCROLLRASTER} CONST GMORE_SCROLLRASTER = $00000004 /* This (custom) gadget uses ScrollRaster */


/* ======================================================================== */
/* === BoolInfo======================================================= */
/* ======================================================================== */
NATIVE {boolinfo} OBJECT boolinfo
    {flags}	flags	:UINT	/* defined below */
    {mask}	mask	:PTR TO UINT	/* bit mask for highlighting and selecting
			 * mask must follow the same rules as an Image
			 * plane.  Its width and height are determined
			 * by the width and height of the gadget's
			 * select box. (i.e. Gadget.Width and .Height).
			 */
    {reserved}	reserved	:ULONG	/* set to 0	*/
ENDOBJECT

NATIVE {BOOLMASK}	CONST BOOLMASK	= $0001	/* extension is for masked gadget */

/* ======================================================================== */
/* === PropInfo =========================================================== */
/* ======================================================================== */
NATIVE {propinfo} OBJECT propinfo
    {flags}	flags	:UINT	/* general purpose flag bits (see defines below) */

    {horizpot}	horizpot	:UINT	/* 16-bit FixedPoint horizontal quantity percentage */
    {vertpot}	vertpot	:UINT	/* 16-bit FixedPoint vertical quantity percentage */

    {horizbody}	horizbody	:UINT		/* horizontal Body */
    {vertbody}	vertbody	:UINT		/* vertical Body */

    /* these are the variables that Intuition sets and maintains */
    {cwidth}	cwidth	:UINT	/* Container width (with any relativity absoluted) */
    {cheight}	cheight	:UINT	/* Container height (with any relativity absoluted) */
    {hpotres}	hpotres	:UINT
	{vpotres}	vpotres	:UINT	/* pot increments */
    {leftborder}	leftborder	:UINT		/* Container borders */
    {topborder}	topborder	:UINT		/* Container borders */
ENDOBJECT


/* --- FLAG BITS ---------------------------------------------------------- */
NATIVE {AUTOKNOB}	CONST AUTOKNOB	= $0001	/* this flag sez:  gimme that old auto-knob */

NATIVE {FREEHORIZ}	CONST FREEHORIZ	= $0002	/* if set, the knob can move horizontally */
NATIVE {FREEVERT}	CONST FREEVERT	= $0004	/* if set, the knob can move vertically */
NATIVE {PROPBORDERLESS}	CONST PROPBORDERLESS	= $0008	/* if set, no border will be rendered */
NATIVE {KNOBHIT}		CONST KNOBHIT		= $0100	/* set when this Knob is hit */
NATIVE {PROPNEWLOOK}	CONST PROPNEWLOOK	= $0010	/* set this if you want to get the new
				 * V36 look
				 */

NATIVE {KNOBHMIN}	CONST KNOBHMIN	= 6	/* minimum horizontal size of the Knob */
NATIVE {KNOBVMIN}	CONST KNOBVMIN	= 4	/* minimum vertical size of the Knob */
NATIVE {MAXBODY}		CONST MAXBODY		= $FFFF	/* maximum body value */
NATIVE {MAXPOT}			CONST MAXPOT			= $FFFF	/* maximum pot value */


/* ======================================================================== */
/* === StringInfo ========================================================= */
/* ======================================================================== */
NATIVE {stringinfo} OBJECT stringinfo
    /* you initialize these variables, and then Intuition maintains them */
    {buffer}	buffer	:ARRAY OF UBYTE	/* the buffer containing the start and final string */
    {undobuffer}	undobuffer	:ARRAY OF UBYTE	/* optional buffer for undoing current entry */
    {bufferpos}	bufferpos	:INT	/* character position in Buffer */
    {maxchars}	maxchars	:INT	/* max number of chars in Buffer (including NULL) */
    {disppos}	disppos	:INT	/* Buffer position of first displayed character */

    /* Intuition initializes and maintains these variables for you */
    {undopos}	undopos	:INT	/* character position in the undo buffer */
    {numchars}	numchars	:INT	/* number of characters currently in Buffer */
    {dispcount}	dispcount	:INT	/* number of whole characters visible in Container */
    {cleft}	cleft	:INT
	{ctop}	ctop	:INT	/* topleft offset of the container */

    /* struct Layer *LayerPtr;	--- obsolete --- */
    {extension}	extension	:PTR TO stringextend

    {longint}	longint	:VALUE

    {altkeymap}	altkeymap	:PTR TO keymap
ENDOBJECT

/* ======================================================================== */
/* === IntuiText ========================================================== */
/* ======================================================================== */
->"OBJECT intuitext" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')






/* ======================================================================== */
/* === Border ============================================================= */
/* ======================================================================== */
->"OBJECT border" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')






/* ======================================================================== */
/* === Image ============================================================== */
/* ======================================================================== */
->"OBJECT image" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')






/* ======================================================================== */
/* === IntuiMessage ======================================================= */
/* ======================================================================== */
->"OBJECT intuimessage" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {extintuimessage} OBJECT extintuimessage
    {intuimessage}	intuimessage	:intuimessage
    {tabletdata}	tabletdata	:PTR TO tabletdata
ENDOBJECT

/* --- IDCMP Classes ------------------------------------------------------ */
/* Please refer to the Autodoc for OpenWindow() and to the Rom Kernel
 * Manual for full details on the IDCMP classes.
 */
NATIVE {IDCMP_SIZEVERIFY}	CONST IDCMP_SIZEVERIFY	= $00000001
NATIVE {IDCMP_NEWSIZE}		CONST IDCMP_NEWSIZE		= $00000002
NATIVE {IDCMP_REFRESHWINDOW}	CONST IDCMP_REFRESHWINDOW	= $00000004
NATIVE {IDCMP_MOUSEBUTTONS}	CONST IDCMP_MOUSEBUTTONS	= $00000008
NATIVE {IDCMP_MOUSEMOVE}		CONST IDCMP_MOUSEMOVE		= $00000010
NATIVE {IDCMP_GADGETDOWN}	CONST IDCMP_GADGETDOWN	= $00000020
NATIVE {IDCMP_GADGETUP}		CONST IDCMP_GADGETUP		= $00000040
NATIVE {IDCMP_REQSET}		CONST IDCMP_REQSET		= $00000080
NATIVE {IDCMP_MENUPICK}		CONST IDCMP_MENUPICK		= $00000100
NATIVE {IDCMP_CLOSEWINDOW}	CONST IDCMP_CLOSEWINDOW	= $00000200
NATIVE {IDCMP_RAWKEY}		CONST IDCMP_RAWKEY		= $00000400
NATIVE {IDCMP_REQVERIFY}		CONST IDCMP_REQVERIFY		= $00000800
NATIVE {IDCMP_REQCLEAR}		CONST IDCMP_REQCLEAR		= $00001000
NATIVE {IDCMP_MENUVERIFY}	CONST IDCMP_MENUVERIFY	= $00002000
NATIVE {IDCMP_NEWPREFS}		CONST IDCMP_NEWPREFS		= $00004000
NATIVE {IDCMP_DISKINSERTED}	CONST IDCMP_DISKINSERTED	= $00008000
NATIVE {IDCMP_DISKREMOVED}	CONST IDCMP_DISKREMOVED	= $00010000
NATIVE {IDCMP_WBENCHMESSAGE}	CONST IDCMP_WBENCHMESSAGE	= $00020000  /*	System use only		*/
NATIVE {IDCMP_ACTIVEWINDOW}	CONST IDCMP_ACTIVEWINDOW	= $00040000
NATIVE {IDCMP_INACTIVEWINDOW}	CONST IDCMP_INACTIVEWINDOW	= $00080000
NATIVE {IDCMP_DELTAMOVE}		CONST IDCMP_DELTAMOVE		= $00100000
NATIVE {IDCMP_VANILLAKEY}	CONST IDCMP_VANILLAKEY	= $00200000
NATIVE {IDCMP_INTUITICKS}	CONST IDCMP_INTUITICKS	= $00400000
/*  for notifications from "boopsi" gadgets	*/
NATIVE {IDCMP_IDCMPUPDATE}	CONST IDCMP_IDCMPUPDATE	= $00800000  /* new for V36	*/
/* for getting help key report during menu session	*/
NATIVE {IDCMP_MENUHELP}		CONST IDCMP_MENUHELP		= $01000000  /* new for V36	*/
/* for notification of any move/size/zoom/change window		*/
NATIVE {IDCMP_CHANGEWINDOW}	CONST IDCMP_CHANGEWINDOW	= $02000000  /* new for V36	*/
NATIVE {IDCMP_GADGETHELP}	CONST IDCMP_GADGETHELP	= $04000000  /* new for V39	*/

/* NOTEZ-BIEN:				0x80000000 is reserved for internal use   */

NATIVE {IDCMP_LONELYMESSAGE}	CONST IDCMP_LONELYMESSAGE	= $80000000


/* --- IDCMP Codes -------------------------------------------------------- */
/* This group of codes is for the IDCMP_CHANGEWINDOW message */
NATIVE {CWCODE_MOVESIZE}	CONST CWCODE_MOVESIZE	= $0000	/* Window was moved and/or sized */
NATIVE {CWCODE_DEPTH}	CONST CWCODE_DEPTH	= $0001	/* Window was depth-arranged (new for V39) */

/* This group of codes is for the IDCMP_MENUVERIFY message */
NATIVE {MENUHOT}		CONST MENUHOT		= $0001	/* IntuiWants verification or MENUCANCEL    */
NATIVE {MENUCANCEL}	CONST MENUCANCEL	= $0002	/* HOT Reply of this cancels Menu operation */
NATIVE {MENUWAITING}	CONST MENUWAITING	= $0003	/* Intuition simply wants a ReplyMsg() ASAP */

NATIVE {OKOK}		CONST OKOK		= MENUHOT	/* guy didn't care			*/
NATIVE {OKABORT}		CONST OKABORT		= $0004	/* window rendered question moot	*/
NATIVE {OKCANCEL}	CONST OKCANCEL	= MENUCANCEL /* window sent cancel reply		*/

/* This group of codes is for the IDCMP_WBENCHMESSAGE messages */
NATIVE {WBENCHOPEN}	CONST WBENCHOPEN	= $0001
NATIVE {WBENCHCLOSE}	CONST WBENCHCLOSE	= $0002


/* A data structure common in V36 Intuition processing	*/
NATIVE {ibox} OBJECT ibox
    {left}	left	:INT
    {top}	top	:INT
    {width}	width	:INT
    {height}	height	:INT
ENDOBJECT



/* ======================================================================== */
/* === Window ============================================================= */
/* ======================================================================== */
->"OBJECT window" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')


/* --- Flags requested at OpenWindow() time by the application --------- */
NATIVE {WFLG_SIZEGADGET}	    CONST WFLG_SIZEGADGET	    = $00000001	/* include sizing system-gadget? */
NATIVE {WFLG_DRAGBAR}	    CONST WFLG_DRAGBAR	    = $00000002	/* include dragging system-gadget? */
NATIVE {WFLG_DEPTHGADGET}    CONST WFLG_DEPTHGADGET    = $00000004	/* include depth arrangement gadget? */
NATIVE {WFLG_CLOSEGADGET}    CONST WFLG_CLOSEGADGET    = $00000008	/* include close-box system-gadget? */

NATIVE {WFLG_SIZEBRIGHT}	    CONST WFLG_SIZEBRIGHT	    = $00000010	/* size gadget uses right border */
NATIVE {WFLG_SIZEBBOTTOM}    CONST WFLG_SIZEBBOTTOM    = $00000020	/* size gadget uses bottom border */

/* --- refresh modes ------------------------------------------------------ */
/* combinations of the WFLG_REFRESHBITS select the refresh type */
NATIVE {WFLG_REFRESHBITS}    CONST WFLG_REFRESHBITS    = $000000C0
NATIVE {WFLG_SMART_REFRESH}  CONST WFLG_SMART_REFRESH  = $00000000
NATIVE {WFLG_SIMPLE_REFRESH} CONST WFLG_SIMPLE_REFRESH = $00000040
NATIVE {WFLG_SUPER_BITMAP}   CONST WFLG_SUPER_BITMAP   = $00000080
NATIVE {WFLG_OTHER_REFRESH}  CONST WFLG_OTHER_REFRESH  = $000000C0

NATIVE {WFLG_BACKDROP}	    CONST WFLG_BACKDROP	    = $00000100	/* this is a backdrop window */

NATIVE {WFLG_REPORTMOUSE}    CONST WFLG_REPORTMOUSE    = $00000200	/* to hear about every mouse move */

NATIVE {WFLG_GIMMEZEROZERO}  CONST WFLG_GIMMEZEROZERO  = $00000400	/* a GimmeZeroZero window	*/

NATIVE {WFLG_BORDERLESS}	    CONST WFLG_BORDERLESS	    = $00000800	/* to get a Window sans border */

NATIVE {WFLG_ACTIVATE}	    CONST WFLG_ACTIVATE	    = $00001000	/* when Window opens, it's Active */

/* --- Other User Flags --------------------------------------------------- */
NATIVE {WFLG_RMBTRAP}	    CONST WFLG_RMBTRAP	    = $00010000	/* Catch RMB events for your own */
NATIVE {WFLG_NOCAREREFRESH}  CONST WFLG_NOCAREREFRESH  = $00020000	/* not to be bothered with REFRESH */

/* - V36 new Flags which the programmer may specify in NewWindow.Flags	*/
NATIVE {WFLG_NW_EXTENDED}    CONST WFLG_NW_EXTENDED    = $00040000	/* extension data provided	*/
					/* see struct ExtNewWindow	*/

/* - V39 new Flags which the programmer may specify in NewWindow.Flags	*/
NATIVE {WFLG_NEWLOOKMENUS}   CONST WFLG_NEWLOOKMENUS   = $00200000	/* window has NewLook menus	*/


/* These flags are set only by Intuition.  YOU MAY NOT SET THEM YOURSELF! */
NATIVE {WFLG_WINDOWACTIVE}   CONST WFLG_WINDOWACTIVE   = $00002000	/* this window is the active one */
NATIVE {WFLG_INREQUEST}	    CONST WFLG_INREQUEST	    = $00004000	/* this window is in request mode */
NATIVE {WFLG_MENUSTATE}	    CONST WFLG_MENUSTATE	    = $00008000	/* Window is active with Menus on */
NATIVE {WFLG_WINDOWREFRESH}  CONST WFLG_WINDOWREFRESH  = $01000000	/* Window is currently refreshing */
NATIVE {WFLG_WBENCHWINDOW}   CONST WFLG_WBENCHWINDOW   = $02000000	/* WorkBench tool ONLY Window */
NATIVE {WFLG_WINDOWTICKED}   CONST WFLG_WINDOWTICKED   = $04000000	/* only one timer tick at a time */

/* V36 and higher flags to be set only by Intuition: */
NATIVE {WFLG_VISITOR}	    CONST WFLG_VISITOR	    = $08000000	/* visitor window		*/
NATIVE {WFLG_ZOOMED}	    CONST WFLG_ZOOMED	    = $10000000	/* identifies "zoom state"	*/
NATIVE {WFLG_HASZOOM}	    CONST WFLG_HASZOOM	    = $20000000	/* window has a zoom gadget	*/


/* --- Other Window Values ---------------------------------------------- */
NATIVE {DEFAULTMOUSEQUEUE}	CONST DEFAULTMOUSEQUEUE	= (5)	/* no more mouse messages	*/

/* --- see struct IntuiMessage for the IDCMP Flag definitions ------------- */


/* ======================================================================== */
/* === NewWindow ========================================================== */
/* ======================================================================== */
NATIVE {nw} OBJECT nw
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT		/* screen dimensions of window */
    {width}	width	:INT
	{height}	height	:INT			/* screen dimensions of window */

    {detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE		/* for bar/border/gadget rendering */

    {idcmpflags}	idcmpflags	:ULONG			/* User-selected IDCMP flags */

    {flags}	flags	:ULONG			/* see Window struct for defines */

    {firstgadget}	firstgadget	:PTR TO gadget

    {checkmark}	checkmark	:PTR TO image

    {title}	title	:ARRAY OF UBYTE			  /* the title text for this window */

    {screen}	screen	:PTR TO screen

    {bitmap}	bitmap	:PTR TO bitmap

    {minwidth}	minwidth	:INT
	{minheight}	minheight	:INT	    /* minimums */
    {maxwidth}	maxwidth	:UINT
	{maxheight}	maxheight	:UINT	     /* maximums */

    {type}	type	:UINT

ENDOBJECT

NATIVE {extnewwindow} OBJECT extnewwindow
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT
    {width}	width	:INT
	{height}	height	:INT

    {detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE
    {idcmpflags}	idcmpflags	:ULONG
    {flags}	flags	:ULONG
    {firstgadget}	firstgadget	:PTR TO gadget

    {checkmark}	checkmark	:PTR TO image

    {title}	title	:ARRAY OF UBYTE
    {screen}	screen	:PTR TO screen
    {bitmap}	bitmap	:PTR TO bitmap

    {minwidth}	minwidth	:INT
	{minheight}	minheight	:INT
    {maxwidth}	maxwidth	:UINT
	{maxheight}	maxheight	:UINT

    {type}	type	:UINT

    {extension}	extension	:ARRAY OF tagitem
ENDOBJECT

CONST WA_DUMMY	= (TAG_USER + 99)	/* 0x80000063	*/

/* these tags simply override NewWindow parameters */
NATIVE {WA_LEFT}			CONST WA_LEFT			= (WA_DUMMY + $01)
NATIVE {WA_TOP}			CONST WA_TOP			= (WA_DUMMY + $02)
NATIVE {WA_WIDTH}		CONST WA_WIDTH		= (WA_DUMMY + $03)
NATIVE {WA_HEIGHT}		CONST WA_HEIGHT		= (WA_DUMMY + $04)
NATIVE {WA_DETAILPEN}		CONST WA_DETAILPEN		= (WA_DUMMY + $05)
NATIVE {WA_BLOCKPEN}		CONST WA_BLOCKPEN		= (WA_DUMMY + $06)
NATIVE {WA_IDCMP}		CONST WA_IDCMP		= (WA_DUMMY + $07)
NATIVE {WA_FLAGS}		CONST WA_FLAGS		= (WA_DUMMY + $08)
NATIVE {WA_GADGETS}		CONST WA_GADGETS		= (WA_DUMMY + $09)
NATIVE {WA_CHECKMARK}		CONST WA_CHECKMARK		= (WA_DUMMY + $0A)
NATIVE {WA_TITLE}		CONST WA_TITLE		= (WA_DUMMY + $0B)
NATIVE {WA_SCREENTITLE}		CONST WA_SCREENTITLE		= (WA_DUMMY + $0C)
NATIVE {WA_CUSTOMSCREEN}		CONST WA_CUSTOMSCREEN		= (WA_DUMMY + $0D)
NATIVE {WA_SUPERBITMAP}		CONST WA_SUPERBITMAP		= (WA_DUMMY + $0E)
NATIVE {WA_MINWIDTH}		CONST WA_MINWIDTH		= (WA_DUMMY + $0F)
NATIVE {WA_MINHEIGHT}		CONST WA_MINHEIGHT		= (WA_DUMMY + $10)
NATIVE {WA_MAXWIDTH}		CONST WA_MAXWIDTH		= (WA_DUMMY + $11)
NATIVE {WA_MAXHEIGHT}		CONST WA_MAXHEIGHT		= (WA_DUMMY + $12)

/* The following are specifications for new features	*/

NATIVE {WA_INNERWIDTH}		CONST WA_INNERWIDTH		= (WA_DUMMY + $13)
NATIVE {WA_INNERHEIGHT}		CONST WA_INNERHEIGHT		= (WA_DUMMY + $14)

NATIVE {WA_PUBSCREENNAME}	CONST WA_PUBSCREENNAME	= (WA_DUMMY + $15)
NATIVE {WA_PUBSCREEN}		CONST WA_PUBSCREEN		= (WA_DUMMY + $16)
NATIVE {WA_PUBSCREENFALLBACK}	CONST WA_PUBSCREENFALLBACK	= (WA_DUMMY + $17)
NATIVE {WA_WINDOWNAME}		CONST WA_WINDOWNAME		= (WA_DUMMY + $18)
NATIVE {WA_COLORS}		CONST WA_COLORS		= (WA_DUMMY + $19)
NATIVE {WA_ZOOM}		CONST WA_ZOOM		= (WA_DUMMY + $1A)
NATIVE {WA_MOUSEQUEUE}		CONST WA_MOUSEQUEUE		= (WA_DUMMY + $1B)
NATIVE {WA_BACKFILL}		CONST WA_BACKFILL		= (WA_DUMMY + $1C)
NATIVE {WA_RPTQUEUE}		CONST WA_RPTQUEUE		= (WA_DUMMY + $1D)

    /* These Boolean tag items are alternatives to the NewWindow.Flags
     * boolean flags with similar names.
     */
NATIVE {WA_SIZEGADGET}		CONST WA_SIZEGADGET		= (WA_DUMMY + $1E)
NATIVE {WA_DRAGBAR}		CONST WA_DRAGBAR		= (WA_DUMMY + $1F)
NATIVE {WA_DEPTHGADGET}		CONST WA_DEPTHGADGET		= (WA_DUMMY + $20)
NATIVE {WA_CLOSEGADGET}		CONST WA_CLOSEGADGET		= (WA_DUMMY + $21)
NATIVE {WA_BACKDROP}		CONST WA_BACKDROP		= (WA_DUMMY + $22)
NATIVE {WA_REPORTMOUSE}		CONST WA_REPORTMOUSE		= (WA_DUMMY + $23)
NATIVE {WA_NOCAREREFRESH}	CONST WA_NOCAREREFRESH	= (WA_DUMMY + $24)
NATIVE {WA_BORDERLESS}		CONST WA_BORDERLESS		= (WA_DUMMY + $25)
NATIVE {WA_ACTIVATE}		CONST WA_ACTIVATE		= (WA_DUMMY + $26)
NATIVE {WA_RMBTRAP}		CONST WA_RMBTRAP		= (WA_DUMMY + $27)
NATIVE {WA_WBENCHWINDOW}		CONST WA_WBENCHWINDOW		= (WA_DUMMY + $28)	/* PRIVATE!! */
NATIVE {WA_SIMPLEREFRESH}	CONST WA_SIMPLEREFRESH	= (WA_DUMMY + $29)
NATIVE {WA_SMARTREFRESH}		CONST WA_SMARTREFRESH		= (WA_DUMMY + $2A)
NATIVE {WA_SIZEBRIGHT}		CONST WA_SIZEBRIGHT		= (WA_DUMMY + $2B)
NATIVE {WA_SIZEBBOTTOM}		CONST WA_SIZEBBOTTOM		= (WA_DUMMY + $2C)

    /* New Boolean properties	*/
NATIVE {WA_AUTOADJUST}		CONST WA_AUTOADJUST		= (WA_DUMMY + $2D)

NATIVE {WA_GIMMEZEROZERO}	CONST WA_GIMMEZEROZERO	= (WA_DUMMY + $2E)

/* New for V37: WA_MenuHelp (ignored by V36) */
NATIVE {WA_MENUHELP}		CONST WA_MENUHELP		= (WA_DUMMY + $2F)

/* New for V39:  (ignored by V37 and earlier) */
NATIVE {WA_NEWLOOKMENUS}		CONST WA_NEWLOOKMENUS		= (WA_DUMMY + $30)
NATIVE {WA_AMIGAKEY}		CONST WA_AMIGAKEY		= (WA_DUMMY + $31)
NATIVE {WA_NOTIFYDEPTH}		CONST WA_NOTIFYDEPTH		= (WA_DUMMY + $32)

/* WA_DUMMY + $33 is obsolete */

NATIVE {WA_POINTER}		CONST WA_POINTER		= (WA_DUMMY + $34)

NATIVE {WA_BUSYPOINTER}		CONST WA_BUSYPOINTER		= (WA_DUMMY + $35)

NATIVE {WA_POINTERDELAY}		CONST WA_POINTERDELAY		= (WA_DUMMY + $36)

NATIVE {WA_TABLETMESSAGES}	CONST WA_TABLETMESSAGES	= (WA_DUMMY + $37)

NATIVE {WA_HELPGROUP}		CONST WA_HELPGROUP		= (WA_DUMMY + $38)

NATIVE {WA_HELPGROUPWINDOW}	CONST WA_HELPGROUPWINDOW	= (WA_DUMMY + $39)


NATIVE {HC_GADGETHELP}	CONST HC_GADGETHELP	= (1)


/* ======================================================================== */
/* === Remember =========================================================== */
/* ======================================================================== */
NATIVE {remember} OBJECT remember
    {nextremember}	nextremember	:PTR TO remember
    {remembersize}	remembersize	:ULONG
    {memory}	memory	:PTR TO UBYTE
ENDOBJECT


/* === Color Spec ====================================================== */
NATIVE {colorspec} OBJECT colorspec
    {colorindex}	colorindex	:INT	/* -1 terminates an array of ColorSpec	*/
    {red}	red	:UINT	/* only the _bottom_ 4 bits recognized */
    {green}	green	:UINT	/* only the _bottom_ 4 bits recognized */
    {blue}	blue	:UINT	/* only the _bottom_ 4 bits recognized */
ENDOBJECT

/* === Easy Requester Specification ======================================= */
NATIVE {easystruct} OBJECT easystruct
    {structsize}	structsize	:ULONG	/* should be sizeof (struct EasyStruct )*/
    {flags}	flags	:ULONG	/* should be 0 for now			*/
    {title}	title	:ARRAY OF UBYTE	/* title of requester window		*/
    {textformat}	textformat	:ARRAY OF UBYTE	/* 'printf' style formatting string	*/
    {gadgetformat}	gadgetformat	:ARRAY OF UBYTE /* 'printf' style formatting string	*/
ENDOBJECT



/* ======================================================================== */
/* === Miscellaneous ====================================================== */
/* ======================================================================== */

/* = MACROS ============================================================== */
NATIVE {MENUNUM} CONST	->MENUNUM(n) (n & 0x1F)
NATIVE {ITEMNUM} CONST	->ITEMNUM(n) ((n >> 5) & 0x003F)
NATIVE {SUBNUM} CONST	->SUBNUM(n) ((n >> 11) & 0x001F)

NATIVE {SHIFTMENU} CONST	->SHIFTMENU(n) (n & 0x1F)
NATIVE {SHIFTITEM} CONST	->SHIFTITEM(n) ((n & 0x3F) << 5)
NATIVE {SHIFTSUB} CONST	->SHIFTSUB(n) ((n & 0x1F) << 11)

NATIVE {FULLMENUNUM} CONST	->FULLMENUNUM( menu, item, sub ) ( SHIFTSUB(sub) | SHIFTITEM(item) | SHIFTMENU(menu) )

NATIVE {SRBNUM} CONST	->SRBNUM(n)    (0x08 - (n >> 4))	/* SerRWBits -> read bits per char */
NATIVE {SWBNUM} CONST	->SWBNUM(n)    (0x08 - (n & 0x0F))/* SerRWBits -> write bits per chr */
NATIVE {SSBNUM} CONST	->SSBNUM(n)    (0x01 + (n >> 4))	/* SerStopBuf -> stop bits per chr */
NATIVE {SPARNUM} CONST	->SPARNUM(n)   (n >> 4)		/* SerParShk -> parity setting	  */
NATIVE {SHAKNUM} CONST	->SHAKNUM(n)   (n & 0x0F)	/* SerParShk -> handshake mode	  */

#define MENUNUM(n) ((n) AND $1F)
#define ITEMNUM(n) (Shr((n),5) AND $3F)
#define SUBNUM(n)  (Shr((n),11) AND $1F)

#define SHIFTMENU(n) ((n) AND $1F)
#define SHIFTITEM(n) (Shl((n) AND $3F,5))
#define SHIFTSUB(n)  (Shl((n) AND $1F,11))

#define FULLMENUNUM(menu,item,sub) (SHIFTSUB(sub) OR SHIFTITEM(item) OR SHIFTMENU(menu))

#define SRBNUM(n)  (8-Shr((n),4))
#define SWBNUM(n)  (8-((n) AND $F))
#define SSBNUM(n)  (1+Shr((n),4))
#define SPARNUM(n) (Shr((n),4))
#define SHAKNUM(n) ((n) AND $F)


/* = MENU STUFF =========================================================== */
NATIVE {NOMENU} CONST NOMENU = $001F
NATIVE {NOITEM} CONST NOITEM = $003F
NATIVE {NOSUB}  CONST NOSUB  = $001F
NATIVE {MENUNULL} CONST MENUNULL = $FFFF


/* = =RJ='s peculiarities ================================================= */
NATIVE {FOREVER} CONST ->FOREVER = for(;;)
NATIVE {SIGN} CONST	->SIGN(x) ( ((x) > 0) - ((x) < 0) )
NATIVE {NOT} CONST ->NOT = !

NATIVE {CHECKWIDTH}	CONST CHECKWIDTH	= 19
NATIVE {COMMWIDTH}	CONST COMMWIDTH	= 27
NATIVE {LOWCHECKWIDTH}	CONST LOWCHECKWIDTH	= 13
NATIVE {LOWCOMMWIDTH}	CONST LOWCOMMWIDTH	= 16


NATIVE {ALERT_TYPE}	CONST ALERT_TYPE	= $80000000
NATIVE {RECOVERY_ALERT}	CONST RECOVERY_ALERT	= $00000000	/* the system can recover from this */
NATIVE {DEADEND_ALERT}	CONST DEADEND_ALERT	= $80000000	/* no recovery possible, this is it */


NATIVE {AUTOFRONTPEN}	CONST AUTOFRONTPEN	= 0
NATIVE {AUTOBACKPEN}	CONST AUTOBACKPEN	= 1
NATIVE {AUTODRAWMODE}	CONST AUTODRAWMODE	= RP_JAM2
NATIVE {AUTOLEFTEDGE}	CONST AUTOLEFTEDGE	= 6
NATIVE {AUTOTOPEDGE}	CONST AUTOTOPEDGE	= 3
NATIVE {AUTOITEXTFONT}	CONST AUTOITEXTFONT	= NIL
NATIVE {AUTONEXTTEXT}	CONST AUTONEXTTEXT	= NIL


/* --- RAWMOUSE Codes and Qualifiers (Console OR IDCMP) ------------------- */
NATIVE {SELECTUP}	CONST SELECTUP	= (IECODE_LBUTTON OR IECODE_UP_PREFIX)
NATIVE {SELECTDOWN}	CONST SELECTDOWN	= (IECODE_LBUTTON)
NATIVE {MENUUP}		CONST MENUUP		= (IECODE_RBUTTON OR IECODE_UP_PREFIX)
NATIVE {MENUDOWN}	CONST MENUDOWN	= (IECODE_RBUTTON)
NATIVE {MIDDLEUP}	CONST MIDDLEUP	= (IECODE_MBUTTON OR IECODE_UP_PREFIX)
NATIVE {MIDDLEDOWN}	CONST MIDDLEDOWN	= (IECODE_MBUTTON)
NATIVE {ALTLEFT}		CONST ALTLEFT		= (IEQUALIFIER_LALT)
NATIVE {ALTRIGHT}	CONST ALTRIGHT	= (IEQUALIFIER_RALT)
NATIVE {AMIGALEFT}	CONST AMIGALEFT	= (IEQUALIFIER_LCOMMAND)
NATIVE {AMIGARIGHT}	CONST AMIGARIGHT	= (IEQUALIFIER_RCOMMAND)
NATIVE {AMIGAKEYS}	CONST AMIGAKEYS	= (AMIGALEFT OR AMIGARIGHT)

NATIVE {CURSORUP}	CONST CURSORUP	= $4C
NATIVE {CURSORLEFT}	CONST CURSORLEFT	= $4F
NATIVE {CURSORRIGHT}	CONST CURSORRIGHT	= $4E
NATIVE {CURSORDOWN}	CONST CURSORDOWN	= $4D
NATIVE {KEYCODE_Q}	CONST KEYCODE_Q	= $10
NATIVE {KEYCODE_Z}	CONST KEYCODE_Z	= $31
NATIVE {KEYCODE_X}	CONST KEYCODE_X	= $32
NATIVE {KEYCODE_V}	CONST KEYCODE_V	= $34
NATIVE {KEYCODE_B}	CONST KEYCODE_B	= $35
NATIVE {KEYCODE_N}	CONST KEYCODE_N	= $36
NATIVE {KEYCODE_M}	CONST KEYCODE_M	= $37
NATIVE {KEYCODE_LESS}	CONST KEYCODE_LESS	= $38
NATIVE {KEYCODE_GREATER} CONST KEYCODE_GREATER = $39



NATIVE {TABLETA_DUMMY}		CONST TABLETA_DUMMY		= (TAG_USER + $3A000)
NATIVE {TABLETA_TABLETZ}		CONST TABLETA_TABLETZ		= (TABLETA_DUMMY + $01)
NATIVE {TABLETA_RANGEZ}		CONST TABLETA_RANGEZ		= (TABLETA_DUMMY + $02)
NATIVE {TABLETA_ANGLEX}		CONST TABLETA_ANGLEX		= (TABLETA_DUMMY + $03)
NATIVE {TABLETA_ANGLEY}		CONST TABLETA_ANGLEY		= (TABLETA_DUMMY + $04)
NATIVE {TABLETA_ANGLEZ}		CONST TABLETA_ANGLEZ		= (TABLETA_DUMMY + $05)
NATIVE {TABLETA_PRESSURE}	CONST TABLETA_PRESSURE	= (TABLETA_DUMMY + $06)
NATIVE {TABLETA_BUTTONBITS}	CONST TABLETA_BUTTONBITS	= (TABLETA_DUMMY + $07)
NATIVE {TABLETA_INPROXIMITY}	CONST TABLETA_INPROXIMITY	= (TABLETA_DUMMY + $08)
NATIVE {TABLETA_RESOLUTIONX}	CONST TABLETA_RESOLUTIONX	= (TABLETA_DUMMY + $09)
NATIVE {TABLETA_RESOLUTIONY}	CONST TABLETA_RESOLUTIONY	= (TABLETA_DUMMY + $0A)

NATIVE {tabletdata} OBJECT tabletdata
    {xfraction}	xfraction	:UINT
	{yfraction}	yfraction	:UINT

    {tabletx}	tabletx	:ULONG
	{tablety}	tablety	:ULONG

    {rangex}	rangex	:ULONG
	{rangey}	rangey	:ULONG

    {taglist}	taglist	:ARRAY OF tagitem
ENDOBJECT

NATIVE {tablethookdata} OBJECT tablethookdata
    {screen}	screen	:PTR TO screen

    {width}	width	:ULONG
    {height}	height	:ULONG

    {screenchanged}	screenchanged	:VALUE
ENDOBJECT
