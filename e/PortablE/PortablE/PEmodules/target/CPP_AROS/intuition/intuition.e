/* $Id: intuition.h 28542 2008-04-28 22:58:18Z sszymczy $ */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/ports', 'target/exec/types', 'target/graphics/clip', 'target/graphics/gfx', 'target/graphics/layers', 'target/graphics/rastport', 'target/graphics/text', 'target/graphics/view', 'target/utility/tagitem', 'target/devices/inputevent', 'target/intuition/preferences', 'target/intuition/screens', 'target/intuition/classusr'
MODULE 'target/intuition/intuition_shared2', 'target/devices/keymap', 'target/exec/nodes'
{#include <intuition/intuition.h>}
NATIVE {INTUITION_INTUITION_H} CONST

NATIVE {INTUITIONNAME} CONST
#define INTUITIONNAME intuitionname
STATIC intuitionname = 'intuition.library'

		       /***** Intuition Message *****/

->"OBJECT intuimessage" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {ExtIntuiMessage} OBJECT extintuimessage
    {eim_IntuiMessage}	intuimessage	:intuimessage
    {eim_TabletData}	tabletdata	:PTR TO tabletdata
ENDOBJECT

			    /***** IDCMP *****/

NATIVE {IDCMP_SIZEVERIFY}     CONST IDCMP_SIZEVERIFY     = $1
NATIVE {IDCMP_NEWSIZE}	     CONST IDCMP_NEWSIZE	     = $2
NATIVE {IDCMP_REFRESHWINDOW}  CONST IDCMP_REFRESHWINDOW  = $4
NATIVE {IDCMP_MOUSEBUTTONS}   CONST IDCMP_MOUSEBUTTONS   = $8
NATIVE {IDCMP_MOUSEMOVE}      CONST IDCMP_MOUSEMOVE      = $10
NATIVE {IDCMP_GADGETDOWN}     CONST IDCMP_GADGETDOWN     = $20
NATIVE {IDCMP_GADGETUP}	     CONST IDCMP_GADGETUP	     = $40
NATIVE {IDCMP_REQSET}	     CONST IDCMP_REQSET	     = $80
NATIVE {IDCMP_MENUPICK}	     CONST IDCMP_MENUPICK	     = $100
NATIVE {IDCMP_CLOSEWINDOW}    CONST IDCMP_CLOSEWINDOW    = $200
NATIVE {IDCMP_RAWKEY}	     CONST IDCMP_RAWKEY	     = $400
NATIVE {IDCMP_REQVERIFY}      CONST IDCMP_REQVERIFY      = $800
NATIVE {IDCMP_REQCLEAR}	     CONST IDCMP_REQCLEAR	     = $1000
NATIVE {IDCMP_MENUVERIFY}     CONST IDCMP_MENUVERIFY     = $2000
NATIVE {IDCMP_NEWPREFS}	     CONST IDCMP_NEWPREFS	     = $4000
NATIVE {IDCMP_DISKINSERTED}   CONST IDCMP_DISKINSERTED   = $8000
NATIVE {IDCMP_DISKREMOVED}    CONST IDCMP_DISKREMOVED    = $10000
NATIVE {IDCMP_WBENCHMESSAGE}  CONST IDCMP_WBENCHMESSAGE  = $20000
NATIVE {IDCMP_ACTIVEWINDOW}   CONST IDCMP_ACTIVEWINDOW   = $40000
NATIVE {IDCMP_INACTIVEWINDOW} CONST IDCMP_INACTIVEWINDOW = $80000
NATIVE {IDCMP_DELTAMOVE}      CONST IDCMP_DELTAMOVE      = $100000
NATIVE {IDCMP_VANILLAKEY}     CONST IDCMP_VANILLAKEY     = $200000
NATIVE {IDCMP_INTUITICKS}     CONST IDCMP_INTUITICKS     = $400000
NATIVE {IDCMP_IDCMPUPDATE}    CONST IDCMP_IDCMPUPDATE    = $800000
NATIVE {IDCMP_MENUHELP}	     CONST IDCMP_MENUHELP	     = $1000000
NATIVE {IDCMP_CHANGEWINDOW}   CONST IDCMP_CHANGEWINDOW   = $2000000
NATIVE {IDCMP_GADGETHELP}     CONST IDCMP_GADGETHELP     = $4000000
NATIVE {IDCMP_LONELYMESSAGE}  CONST IDCMP_LONELYMESSAGE  = $80000000

NATIVE {CWCODE_MOVESIZE} CONST CWCODE_MOVESIZE = 0
NATIVE {CWCODE_DEPTH}	CONST CWCODE_DEPTH	= 1
NATIVE {MENUHOT} 	CONST MENUHOT 	= 1
NATIVE {MENUCANCEL}	CONST MENUCANCEL	= 2
NATIVE {MENUWAITING}	CONST MENUWAITING	= 3
NATIVE {OKOK}		CONST OKOK		= 1
NATIVE {OKCANCEL}	CONST OKCANCEL	= 2
NATIVE {OKABORT} 	CONST OKABORT 	= 4
NATIVE {WBENCHOPEN}	CONST WBENCHOPEN	= 1
NATIVE {WBENCHCLOSE}	CONST WBENCHCLOSE	= 2

			    /***** IntuiText *****/

->"OBJECT intuitext" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

			     /***** Menu *****/

->"OBJECT menu" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* Flags */
NATIVE {MENUENABLED} CONST MENUENABLED = $1
/* The following flag is READ-ONLY */
NATIVE {MIDRAWN}     CONST MIDRAWN     = $100

->"OBJECT menuitem" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* Flags */
NATIVE {CHECKIT}     CONST CHECKIT     = $1
NATIVE {ITEMTEXT}    CONST ITEMTEXT    = $2
NATIVE {COMMSEQ}     CONST COMMSEQ     = $4
NATIVE {MENUTOGGLE}  CONST MENUTOGGLE  = $8
NATIVE {ITEMENABLED} CONST ITEMENABLED = $10
NATIVE {HIGHIMAGE}   CONST HIGHIMAGE   = $0000
NATIVE {HIGHCOMP}    CONST HIGHCOMP    = $40
NATIVE {HIGHBOX}     CONST HIGHBOX     = $80
NATIVE {HIGHNONE}    CONST HIGHNONE    = $00C0
NATIVE {HIGHFLAGS}   CONST HIGHFLAGS   = $00C0
NATIVE {CHECKED}     CONST CHECKED     = $100
/* The following flags are READ-ONLY */
NATIVE {ISDRAWN}     CONST ISDRAWN     = $1000
NATIVE {HIGHITEM}    CONST HIGHITEM    = $2000
NATIVE {MENUTOGGLED} CONST MENUTOGGLED = $4000

NATIVE {NOMENU}	 CONST NOMENU	 = $001F
NATIVE {NOITEM}	 CONST NOITEM	 = $003F
NATIVE {NOSUB}	 CONST NOSUB	 = $001F
NATIVE {MENUNULL} CONST MENUNULL = $FFFF

/* Macros */
NATIVE {MENUNUM} CONST	->MENUNUM(x) ((x) & 0x1F)
NATIVE {ITEMNUM} CONST	->ITEMNUM(x) (((x)>>5)  & 0x003F)
NATIVE {SUBNUM} CONST	->SUBNUM(x)  (((x)>>11) & 0x001F)

NATIVE {SHIFTMENU} CONST	->SHIFTMENU(x) ((x) & 0x1F)
NATIVE {SHIFTITEM} CONST	->SHIFTITEM(x) (((x) & 0x3F)<<5)
NATIVE {SHIFTSUB} CONST	->SHIFTSUB(x)  (((x) & 0x1F)<<11)
NATIVE {FULLMENUNUM} CONST	->FULLMENUNUM(m,i,s) (SHIFTMENU(m) | SHIFTITEM(i) | SHIFTSUB(s))

NATIVE {SRBNUM} CONST	->SRBNUM(x)  (0x08 - ((x)>>4))
NATIVE {SWBNUM} CONST	->SWBNUM(x)  (0x08 - ((x) & 0x0F))
NATIVE {SSBNUM} CONST	->SSBNUM(x)  (0x01 + ((x)>>4))
NATIVE {SPARNUM} CONST	->SPARNUM(x) ((x)>>4)
NATIVE {SHAKNUM} CONST	->SHAKNUM(x) ((x) & 0x0F)

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


NATIVE {CHECKWIDTH}    CONST CHECKWIDTH    = 19
NATIVE {LOWCHECKWIDTH} CONST LOWCHECKWIDTH = 13
NATIVE {COMMWIDTH}     CONST COMMWIDTH     = 27
NATIVE {LOWCOMMWIDTH}  CONST LOWCOMMWIDTH  = 16

			   /***** Gadgets *****/

->"OBJECT gadget" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {ExtGadget} OBJECT extgadget
    {NextGadget}	nextgadget	:PTR TO extgadget

    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {Flags}	flags	:UINT      /* see below */
    {Activation}	activation	:UINT /* see below */
    {GadgetType}	gadgettype	:UINT /* see below */

    {GadgetRender}	gadgetrender	:APTR
    {SelectRender}	selectrender	:APTR
    {GadgetText}	gadgettext	:PTR TO intuitext

    {MutualExclude}	mutualexclude	:VALUE /* OBSOLETE */

    {SpecialInfo}	specialinfo	:APTR
    {GadgetID}	gadgetid	:UINT
    {UserData}	userdata	:APTR

/* ExtGadget specific fields */
    {MoreFlags}	moreflags	:ULONG	  /* see below */
    {BoundsLeftEdge}	boundsleftedge	:INT
    {BoundsTopEdge}	boundstopedge	:INT
    {BoundsWidth}	boundswidth	:INT
    {BoundsHeight}	boundsheight	:INT
ENDOBJECT

/* Flags */
NATIVE {GFLG_GADGHCOMP}	    CONST GFLG_GADGHCOMP	    = $0000
NATIVE {GFLG_GADGHBOX}	    CONST GFLG_GADGHBOX	    = $1
NATIVE {GFLG_GADGHIMAGE}     CONST GFLG_GADGHIMAGE     = $2
NATIVE {GFLG_GADGHNONE}	    CONST GFLG_GADGHNONE	    = $0003
NATIVE {GFLG_GADGHIGHBITS}   CONST GFLG_GADGHIGHBITS   = $0003
NATIVE {GFLG_GADGIMAGE}	    CONST GFLG_GADGIMAGE	    = $4
NATIVE {GFLG_RELBOTTOM}	    CONST GFLG_RELBOTTOM	    = $8
NATIVE {GFLG_RELRIGHT}	    CONST GFLG_RELRIGHT	    = $10
NATIVE {GFLG_RELWIDTH}	    CONST GFLG_RELWIDTH	    = $20
NATIVE {GFLG_RELHEIGHT}	    CONST GFLG_RELHEIGHT	    = $40
NATIVE {GFLG_SELECTED}	    CONST GFLG_SELECTED	    = $80
NATIVE {GFLG_DISABLED}	    CONST GFLG_DISABLED	    = $100
NATIVE {GFLG_TABCYCLE}	    CONST GFLG_TABCYCLE	    = $200
NATIVE {GFLG_STRINGEXTEND}   CONST GFLG_STRINGEXTEND   = $400
NATIVE {GFLG_IMAGEDISABLE}   CONST GFLG_IMAGEDISABLE   = $800
NATIVE {GFLG_LABELITEXT}     CONST GFLG_LABELITEXT     = $0000
NATIVE {GFLG_LABELSTRING}    CONST GFLG_LABELSTRING    = $1000
NATIVE {GFLG_LABELIMAGE}     CONST GFLG_LABELIMAGE     = $2000
NATIVE {GFLG_LABELMASK}	    CONST GFLG_LABELMASK	    = $3000
NATIVE {GFLG_RELSPECIAL}     CONST GFLG_RELSPECIAL     = $4000
NATIVE {GFLG_EXTENDED}	    CONST GFLG_EXTENDED	    = $8000

/* Activation */
NATIVE {GACT_RELVERIFY}	  CONST GACT_RELVERIFY	  = $1
NATIVE {GACT_IMMEDIATE}	  CONST GACT_IMMEDIATE	  = $2
NATIVE {GACT_ENDGADGET}	  CONST GACT_ENDGADGET	  = $4
NATIVE {GACT_FOLLOWMOUSE}  CONST GACT_FOLLOWMOUSE  = $8
NATIVE {GACT_RIGHTBORDER}  CONST GACT_RIGHTBORDER  = $10
NATIVE {GACT_LEFTBORDER}   CONST GACT_LEFTBORDER   = $20
NATIVE {GACT_TOPBORDER}	  CONST GACT_TOPBORDER	  = $40
NATIVE {GACT_BOTTOMBORDER} CONST GACT_BOTTOMBORDER = $80
NATIVE {GACT_TOGGLESELECT} CONST GACT_TOGGLESELECT = $100
NATIVE {GACT_STRINGLEFT}   CONST GACT_STRINGLEFT   = 0
NATIVE {GACT_STRINGCENTER} CONST GACT_STRINGCENTER = $200
NATIVE {GACT_STRINGRIGHT}  CONST GACT_STRINGRIGHT  = $400
NATIVE {GACT_LONGINT}	  CONST GACT_LONGINT	  = $800
NATIVE {GACT_ALTKEYMAP}	  CONST GACT_ALTKEYMAP	  = $1000
NATIVE {GACT_STRINGEXTEND} CONST GACT_STRINGEXTEND = $2000
NATIVE {GACT_BOOLEXTEND}   CONST GACT_BOOLEXTEND   = $2000
NATIVE {GACT_ACTIVEGADGET} CONST GACT_ACTIVEGADGET = $4000
NATIVE {GACT_BORDERSNIFF}  CONST GACT_BORDERSNIFF  = $8000

/* GadgetType */
NATIVE {GTYP_GADGETTYPE}   CONST GTYP_GADGETTYPE   = $FC00
NATIVE {GTYP_SYSTYPEMASK}  CONST GTYP_SYSTYPEMASK  = $00F0
NATIVE {GTYP_SIZING}	  CONST GTYP_SIZING	  = $0010
NATIVE {GTYP_WDRAGGING}	  CONST GTYP_WDRAGGING	  = $0020
NATIVE {GTYP_SDRAGGING}	  CONST GTYP_SDRAGGING	  = $0030
NATIVE {GTYP_WDEPTH}	  CONST GTYP_WDEPTH	  = $0040
NATIVE {GTYP_SDEPTH}	  CONST GTYP_SDEPTH	  = $0050
NATIVE {GTYP_WZOOM}	  CONST GTYP_WZOOM	  = $0060
NATIVE {GTYP_SUNUSED}	  CONST GTYP_SUNUSED	  = $0070
NATIVE {GTYP_CLOSE}	  CONST GTYP_CLOSE	  = $0080
NATIVE {GTYP_REQGADGET}	  CONST GTYP_REQGADGET	  = $1000
NATIVE {GTYP_GZZGADGET}	  CONST GTYP_GZZGADGET	  = $2000
NATIVE {GTYP_SCRGADGET}	  CONST GTYP_SCRGADGET	  = $4000
NATIVE {GTYP_SYSGADGET}	  CONST GTYP_SYSGADGET	  = $8000
NATIVE {GTYP_BOOLGADGET}   CONST GTYP_BOOLGADGET   = $0001
NATIVE {GTYP_GADGET0002}   CONST GTYP_GADGET0002   = $0002
NATIVE {GTYP_PROPGADGET}   CONST GTYP_PROPGADGET   = $0003
NATIVE {GTYP_STRGADGET}	  CONST GTYP_STRGADGET	  = $0004
NATIVE {GTYP_CUSTOMGADGET} CONST GTYP_CUSTOMGADGET = $0005
NATIVE {GTYP_GTYPEMASK}	  CONST GTYP_GTYPEMASK	  = $0007

/* MoreFlags */
NATIVE {GMORE_BOUNDS}	   CONST GMORE_BOUNDS	   = $1
NATIVE {GMORE_GADGETHELP}   CONST GMORE_GADGETHELP   = $2
NATIVE {GMORE_SCROLLRASTER} CONST GMORE_SCROLLRASTER = $4
NATIVE {GMORE_BOOPSIGADGET} CONST GMORE_BOOPSIGADGET = $8 /* some internal boopsi classes changes the gadget type during execution (ie propgclass), so GTYP_CUSTOMGADGET doesn´t work (dariusb) */

/***** Bool Gadget *****/
NATIVE {BoolInfo} OBJECT boolinfo
    {Flags}	flags	:UINT    /* see below */
    {Mask}	mask	:PTR TO UINT
    {Reserved}	reserved	:ULONG /* must be NULL */
ENDOBJECT

/* Flags */
NATIVE {BOOLMASK} CONST BOOLMASK = $1

/***** Proportional gadget *****/
NATIVE {PropInfo} OBJECT propinfo
    {Flags}	flags	:UINT      /* see below */
    {HorizPot}	horizpot	:UINT
    {VertPot}	vertpot	:UINT
    {HorizBody}	horizbody	:UINT
    {VertBody}	vertbody	:UINT
    {CWidth}	cwidth	:UINT
    {CHeight}	cheight	:UINT
    {HPotRes}	hpotres	:UINT
    {VPotRes}	vpotres	:UINT
    {LeftBorder}	leftborder	:UINT
    {TopBorder}	topborder	:UINT
ENDOBJECT

NATIVE {AUTOKNOB}       CONST AUTOKNOB       = $1
NATIVE {FREEHORIZ}      CONST FREEHORIZ      = $2
NATIVE {FREEVERT}       CONST FREEVERT       = $4
NATIVE {PROPBORDERLESS} CONST PROPBORDERLESS = $8
NATIVE {PROPNEWLOOK}    CONST PROPNEWLOOK    = $10
NATIVE {KNOBHIT}        CONST KNOBHIT        = $100

NATIVE {KNOBHMIN} CONST KNOBHMIN = 6
NATIVE {KNOBVMIN} CONST KNOBVMIN = 4
NATIVE {MAXBODY}  CONST MAXBODY  = $FFFF
NATIVE {MAXPOT}	 CONST MAXPOT	 = $FFFF

/***** StringInfo *****/

NATIVE {StringInfo} OBJECT stringinfo
    {Buffer}	buffer	:ARRAY OF UBYTE
    {UndoBuffer}	undobuffer	:ARRAY OF UBYTE
    {BufferPos}	bufferpos	:INT
    {MaxChars}	maxchars	:INT
    {DispPos}	disppos	:INT

    {UndoPos}	undopos	:INT
    {NumChars}	numchars	:INT
    {DispCount}	dispcount	:INT
    {CLeft}	cleft	:INT
    {CTop}	ctop	:INT

    {Extension}	extension	:PTR TO stringextend
    {LongInt}	longint	:VALUE
    {AltKeyMap}	altkeymap	:PTR TO keymap
ENDOBJECT

/**********************************************************************
 **                            Requesters                            **
 **********************************************************************/

/* The following struct is used for standard intuition requesters
   (not to be mixed up with asl or easy requesters).
   See intuition.library/Request() for more information. */
->"OBJECT request" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

/* Flags */
NATIVE {POINTREL}      CONST POINTREL      = $1 /* If set, LeftEdge and TopEdge are relative
                                to the coordinates of either the pointer
                                or the window */
NATIVE {PREDRAWN}      CONST PREDRAWN      = $2 /* If set, ImageBMap points to a custom bitmap */
NATIVE {NOISYREQ}      CONST NOISYREQ      = $4 /* Requester doesn't filter input */
NATIVE {SIMPLEREQ}     CONST SIMPLEREQ     = $10 /* If set, a SIMPLEREFRESH layer is used */
NATIVE {USEREQIMAGE}   CONST USEREQIMAGE   = $20 /* ReqImage points to an image, which is used
                                as background */
NATIVE {NOREQBACKFILL} CONST NOREQBACKFILL = $40 /* Ignore BackFill pen */
/* The following flags are READ-ONLY */
NATIVE {REQOFFWINDOW}  CONST REQOFFWINDOW  = $1000
NATIVE {REQACTIVE}     CONST REQACTIVE     = $2000 /* Requester is active */
NATIVE {SYSREQUEST}    CONST SYSREQUEST    = $4000 /* unused */
NATIVE {DEFERREFRESH}  CONST DEFERREFRESH  = $8000

/* This struct is passes as second parameter to EasyRequestArgs() and
   BuildEasyRequest(). It describes the general look of the requester. */
NATIVE {EasyStruct} OBJECT easystruct
    {es_StructSize}	structsize	:ULONG   /* Should be sizeof(struct EasyStruct). Note
                                     that this size may change, if you update the
                                     includes! Do not use absolute values as
                                     the size of pointers may vary on different
                                     platforms! */
    {es_Flags}	flags	:ULONG        /* None defined, yet */
    {es_Title}	title	:CONST_STRPTR        /* Text in the titlebar of the requester */
    {es_TextFormat}	textformat	:CONST_STRPTR   /* Text in requester (printf-style). The
                                     arguments needed for that string are the
                                     fourth paramter to EasyRequestArgs() */
    {es_GadgetFormat}	gadgetformat	:CONST_STRPTR /* Text of the gadgets, separated by |'s */
ENDOBJECT

			    /***** Window *****/

->"OBJECT window" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {HAS_CHILDREN} CONST	->HAS_CHILDREN(w) (NULL != w->firstchild)
NATIVE {IS_CHILD} CONST	->IS_CHILD(w) (NULL != w->parent)

NATIVE {NewWindow} OBJECT nw
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {DetailPen}	detailpen	:UBYTE
    {BlockPen}	blockpen	:UBYTE

    {IDCMPFlags}	idcmpflags	:ULONG
    {Flags}	flags	:ULONG

    {FirstGadget}	firstgadget	:PTR TO gadget
    {CheckMark}	checkmark	:PTR TO image
    {Title}	title	:ARRAY OF UBYTE
    {Screen}	screen	:PTR TO screen
    {BitMap}	bitmap	:PTR TO bitmap

    {MinWidth}	minwidth	:INT
    {MinHeight}	minheight	:INT
    {MaxWidth}	maxwidth	:UINT
    {MaxHeight}	maxheight	:UINT

    {Type}	type	:UINT
ENDOBJECT

NATIVE {ExtNewWindow} OBJECT extnewwindow
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {DetailPen}	detailpen	:UBYTE
    {BlockPen}	blockpen	:UBYTE

    {IDCMPFlags}	idcmpflags	:ULONG
    {Flags}	flags	:ULONG

    {FirstGadget}	firstgadget	:PTR TO gadget
    {CheckMark}	checkmark	:PTR TO image
    {Title}	title	:ARRAY OF UBYTE
    {Screen}	screen	:PTR TO screen
    {BitMap}	bitmap	:PTR TO bitmap

    {MinWidth}	minwidth	:INT
    {MinHeight}	minheight	:INT
    {MaxWidth}	maxwidth	:UINT
    {MaxHeight}	maxheight	:UINT

    {Type}	type	:UINT

/* ExtNewWindow specific fields */
    {Extension}	extension	:ARRAY OF tagitem
ENDOBJECT

/* Tags */
NATIVE {WA_Dummy}	     CONST WA_DUMMY	     = (TAG_USER + 99)
NATIVE {WA_Left} 	     CONST WA_LEFT 	     = (WA_DUMMY + 1)
NATIVE {WA_Top}		     CONST WA_TOP		     = (WA_DUMMY + 2)
NATIVE {WA_Width}	     CONST WA_WIDTH	     = (WA_DUMMY + 3)
NATIVE {WA_Height}	     CONST WA_HEIGHT	     = (WA_DUMMY + 4)
NATIVE {WA_DetailPen}	     CONST WA_DETAILPEN	     = (WA_DUMMY + 5)
NATIVE {WA_BlockPen}	     CONST WA_BLOCKPEN	     = (WA_DUMMY + 6)
NATIVE {WA_IDCMP}	     CONST WA_IDCMP	     = (WA_DUMMY + 7)
NATIVE {WA_Flags}	     CONST WA_FLAGS	     = (WA_DUMMY + 8)
NATIVE {WA_Gadgets}	     CONST WA_GADGETS	     = (WA_DUMMY + 9)
NATIVE {WA_Checkmark}	     CONST WA_CHECKMARK	     = (WA_DUMMY + 10)
NATIVE {WA_Title}	     CONST WA_TITLE	     = (WA_DUMMY + 11)
NATIVE {WA_ScreenTitle}	     CONST WA_SCREENTITLE	     = (WA_DUMMY + 12)
NATIVE {WA_CustomScreen}      CONST WA_CUSTOMSCREEN      = (WA_DUMMY + 13)
NATIVE {WA_SuperBitMap}	     CONST WA_SUPERBITMAP	     = (WA_DUMMY + 14)
NATIVE {WA_MinWidth}	     CONST WA_MINWIDTH	     = (WA_DUMMY + 15)
NATIVE {WA_MinHeight}	     CONST WA_MINHEIGHT	     = (WA_DUMMY + 16)
NATIVE {WA_MaxWidth}	     CONST WA_MAXWIDTH	     = (WA_DUMMY + 17)
NATIVE {WA_MaxHeight}	     CONST WA_MAXHEIGHT	     = (WA_DUMMY + 18)
NATIVE {WA_InnerWidth}	     CONST WA_INNERWIDTH	     = (WA_DUMMY + 19)
NATIVE {WA_InnerHeight}	     CONST WA_INNERHEIGHT	     = (WA_DUMMY + 20)
NATIVE {WA_PubScreenName}     CONST WA_PUBSCREENNAME     = (WA_DUMMY + 21)
NATIVE {WA_PubScreen}	     CONST WA_PUBSCREEN	     = (WA_DUMMY + 22)
NATIVE {WA_PubScreenFallBack} CONST WA_PUBSCREENFALLBACK = (WA_DUMMY + 23)
NATIVE {WA_WindowName}	     CONST WA_WINDOWNAME	     = (WA_DUMMY + 24)
NATIVE {WA_Colors}	     CONST WA_COLORS	     = (WA_DUMMY + 25)
NATIVE {WA_Zoom} 	     CONST WA_ZOOM 	     = (WA_DUMMY + 26)
NATIVE {WA_MouseQueue}	     CONST WA_MOUSEQUEUE	     = (WA_DUMMY + 27)
NATIVE {WA_BackFill}	     CONST WA_BACKFILL	     = (WA_DUMMY + 28)
NATIVE {WA_RptQueue}	     CONST WA_RPTQUEUE	     = (WA_DUMMY + 29)
NATIVE {WA_SizeGadget}	     CONST WA_SIZEGADGET	     = (WA_DUMMY + 30)
NATIVE {WA_DragBar}	     CONST WA_DRAGBAR	     = (WA_DUMMY + 31)
NATIVE {WA_DepthGadget}	     CONST WA_DEPTHGADGET	     = (WA_DUMMY + 32)
NATIVE {WA_CloseGadget}	     CONST WA_CLOSEGADGET	     = (WA_DUMMY + 33)
NATIVE {WA_Backdrop}	     CONST WA_BACKDROP	     = (WA_DUMMY + 34)
NATIVE {WA_ReportMouse}	     CONST WA_REPORTMOUSE	     = (WA_DUMMY + 35)
NATIVE {WA_NoCareRefresh}     CONST WA_NOCAREREFRESH     = (WA_DUMMY + 36)
NATIVE {WA_Borderless}	     CONST WA_BORDERLESS	     = (WA_DUMMY + 37)
NATIVE {WA_Activate}	     CONST WA_ACTIVATE	     = (WA_DUMMY + 38)
NATIVE {WA_RMBTrap}	     CONST WA_RMBTRAP	     = (WA_DUMMY + 39)
NATIVE {WA_WBenchWindow}      CONST WA_WBENCHWINDOW      = (WA_DUMMY + 40)
NATIVE {WA_SimpleRefresh}     CONST WA_SIMPLEREFRESH     = (WA_DUMMY + 41)
NATIVE {WA_SmartRefresh}      CONST WA_SMARTREFRESH      = (WA_DUMMY + 42)
NATIVE {WA_SizeBRight}	     CONST WA_SIZEBRIGHT	     = (WA_DUMMY + 43)
NATIVE {WA_SizeBBottom}	     CONST WA_SIZEBBOTTOM	     = (WA_DUMMY + 44)
NATIVE {WA_AutoAdjust}	     CONST WA_AUTOADJUST	     = (WA_DUMMY + 45)
NATIVE {WA_GimmeZeroZero}     CONST WA_GIMMEZEROZERO     = (WA_DUMMY + 46)
NATIVE {WA_MenuHelp}	     CONST WA_MENUHELP	     = (WA_DUMMY + 47)
NATIVE {WA_NewLookMenus}      CONST WA_NEWLOOKMENUS      = (WA_DUMMY + 48)
NATIVE {WA_AmigaKey}	     CONST WA_AMIGAKEY	     = (WA_DUMMY + 49)
NATIVE {WA_NotifyDepth}	     CONST WA_NOTIFYDEPTH	     = (WA_DUMMY + 50)
NATIVE {WA_Pointer}	     CONST WA_POINTER	     = (WA_DUMMY + 52)
NATIVE {WA_BusyPointer}	     CONST WA_BUSYPOINTER	     = (WA_DUMMY + 53)
NATIVE {WA_PointerDelay}      CONST WA_POINTERDELAY      = (WA_DUMMY + 54)
NATIVE {WA_TabletMessages}    CONST WA_TABLETMESSAGES    = (WA_DUMMY + 55)
NATIVE {WA_HelpGroup}	     CONST WA_HELPGROUP	     = (WA_DUMMY + 56)
NATIVE {WA_HelpGroupWindow}   CONST WA_HELPGROUPWINDOW   = (WA_DUMMY + 57)
NATIVE {WA_ToolBox}           CONST WA_TOOLBOX           = (WA_DUMMY + 58)

/* AROS specific tags */

NATIVE {WA_Priority} 	     CONST WA_PRIORITY 	     = (WA_DUMMY + 100)
NATIVE {WA_Parent}   	     CONST WA_PARENT   	     = (WA_DUMMY + 101)
NATIVE {WA_InFrontOf}	     CONST WA_INFRONTOF	     = (WA_DUMMY + 102)
NATIVE {WA_Behind}   	     CONST WA_BEHIND   	     = (WA_DUMMY + 103)
NATIVE {WA_Visible}  	     CONST WA_VISIBLE  	     = (WA_DUMMY + 104)
NATIVE {WA_Shape}    	     CONST WA_SHAPE    	     = (WA_DUMMY + 105)
NATIVE {WA_ShapeHook}	     CONST WA_SHAPEHOOK	     = (WA_DUMMY + 106)

/* Flags */
NATIVE {WFLG_SIZEGADGET}     CONST WFLG_SIZEGADGET     = $1
NATIVE {WFLG_DRAGBAR}	    CONST WFLG_DRAGBAR	    = $2
NATIVE {WFLG_DEPTHGADGET}    CONST WFLG_DEPTHGADGET    = $4
NATIVE {WFLG_CLOSEGADGET}    CONST WFLG_CLOSEGADGET    = $8
NATIVE {WFLG_SIZEBRIGHT}     CONST WFLG_SIZEBRIGHT     = $10
NATIVE {WFLG_SIZEBBOTTOM}    CONST WFLG_SIZEBBOTTOM    = $20

NATIVE {WFLG_SMART_REFRESH}  CONST WFLG_SMART_REFRESH  = 0
NATIVE {WFLG_SIMPLE_REFRESH} CONST WFLG_SIMPLE_REFRESH = $40
NATIVE {WFLG_SUPER_BITMAP}   CONST WFLG_SUPER_BITMAP   = $80
NATIVE {WFLG_OTHER_REFRESH}  CONST WFLG_OTHER_REFRESH  = $40 OR $80
NATIVE {WFLG_REFRESHBITS}    CONST WFLG_REFRESHBITS    = WFLG_OTHER_REFRESH

NATIVE {WFLG_BACKDROP}	    CONST WFLG_BACKDROP	    = $100
NATIVE {WFLG_REPORTMOUSE}    CONST WFLG_REPORTMOUSE    = $200
NATIVE {WFLG_GIMMEZEROZERO}  CONST WFLG_GIMMEZEROZERO  = $400
NATIVE {WFLG_BORDERLESS}     CONST WFLG_BORDERLESS     = $800
NATIVE {WFLG_ACTIVATE}	    CONST WFLG_ACTIVATE	    = $1000

/* PRIVATE */
NATIVE {WFLG_WINDOWACTIVE}   CONST WFLG_WINDOWACTIVE   = $2000
NATIVE {WFLG_INREQUEST}	    CONST WFLG_INREQUEST	    = $4000
NATIVE {WFLG_MENUSTATE}	    CONST WFLG_MENUSTATE	    = $8000

NATIVE {WFLG_RMBTRAP}	    CONST WFLG_RMBTRAP	    = $10000
NATIVE {WFLG_NOCAREREFRESH}  CONST WFLG_NOCAREREFRESH  = $20000
NATIVE {WFLG_NW_EXTENDED}    CONST WFLG_NW_EXTENDED    = $40000

NATIVE {WFLG_NEWLOOKMENUS}   CONST WFLG_NEWLOOKMENUS   = $200000

/* PRIVATE */
NATIVE {WFLG_WINDOWREFRESH}  CONST WFLG_WINDOWREFRESH  = $1000000
NATIVE {WFLG_WBENCHWINDOW}   CONST WFLG_WBENCHWINDOW   = $2000000
NATIVE {WFLG_WINDOWTICKED}   CONST WFLG_WINDOWTICKED   = $4000000
NATIVE {WFLG_VISITOR}	    CONST WFLG_VISITOR	    = $8000000
NATIVE {WFLG_ZOOMED}	    CONST WFLG_ZOOMED	    = $10000000
NATIVE {WFLG_HASZOOM}	    CONST WFLG_HASZOOM	    = $20000000
NATIVE {WFLG_TOOLBOX}        CONST WFLG_TOOLBOX        = $40000000

NATIVE {DEFAULTMOUSEQUEUE} CONST DEFAULTMOUSEQUEUE = 5

NATIVE {HC_GADGETHELP} CONST HC_GADGETHELP = 1

			   /***** Images *****/

->"OBJECT image" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

			   /***** Border *****/

->"OBJECT border" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

			 /***** Tablets *****/

NATIVE {TabletData} OBJECT tabletdata
    {td_XFraction}	xfraction	:UINT
    {td_YFraction}	yfraction	:UINT
    {td_TabletX}	tabletx	:ULONG
    {td_TabletY}	tablety	:ULONG
    {td_RangeX}	rangex	:ULONG
    {td_RangeY}	rangey	:ULONG

    {td_TagList}	taglist	:ARRAY OF tagitem /* see below */
ENDOBJECT

/* Tags */
NATIVE {TABLETA_Dummy}	    CONST TABLETA_DUMMY	    = (TAG_USER + $3A000)
NATIVE {TABLETA_TabletZ}     CONST TABLETA_TABLETZ     = (TABLETA_DUMMY + $01)
NATIVE {TABLETA_RangeZ}	    CONST TABLETA_RANGEZ	    = (TABLETA_DUMMY + $02)
NATIVE {TABLETA_AngleX}	    CONST TABLETA_ANGLEX	    = (TABLETA_DUMMY + $03)
NATIVE {TABLETA_AngleY}	    CONST TABLETA_ANGLEY	    = (TABLETA_DUMMY + $04)
NATIVE {TABLETA_AngleZ}	    CONST TABLETA_ANGLEZ	    = (TABLETA_DUMMY + $05)
NATIVE {TABLETA_Pressure}    CONST TABLETA_PRESSURE    = (TABLETA_DUMMY + $06)
NATIVE {TABLETA_ButtonBits}  CONST TABLETA_BUTTONBITS  = (TABLETA_DUMMY + $07)
NATIVE {TABLETA_InProximity} CONST TABLETA_INPROXIMITY = (TABLETA_DUMMY + $08)
NATIVE {TABLETA_ResolutionX} CONST TABLETA_RESOLUTIONX = (TABLETA_DUMMY + $09)
NATIVE {TABLETA_ResolutionY} CONST TABLETA_RESOLUTIONY = (TABLETA_DUMMY + $0a)

NATIVE {TabletHookData} OBJECT tablethookdata
    {thd_Screen}	screen	:PTR TO screen
    {thd_Width}	width	:ULONG
    {thd_Height}	height	:ULONG
    {thd_ScreenChanged}	screenchanged	:VALUE
ENDOBJECT

			  /***** Keys *****/

NATIVE {SELECTDOWN} CONST SELECTDOWN = (IECODE_LBUTTON)
NATIVE {SELECTUP}   CONST SELECTUP   = (IECODE_LBUTTON OR IECODE_UP_PREFIX)
NATIVE {MENUDOWN}   CONST MENUDOWN   = (IECODE_RBUTTON)
NATIVE {MENUUP}	   CONST MENUUP	   = (IECODE_RBUTTON OR IECODE_UP_PREFIX)
NATIVE {MIDDLEDOWN} CONST MIDDLEDOWN = (IECODE_MBUTTON)
NATIVE {MIDDLEUP}   CONST MIDDLEUP   = (IECODE_MBUTTON OR IECODE_UP_PREFIX)
NATIVE {ALTLEFT}    CONST ALTLEFT    = (IEQUALIFIER_LALT)
NATIVE {ALTRIGHT}   CONST ALTRIGHT   = (IEQUALIFIER_RALT)
NATIVE {AMIGALEFT}  CONST AMIGALEFT  = (IEQUALIFIER_LCOMMAND)
NATIVE {AMIGARIGHT} CONST AMIGARIGHT = (IEQUALIFIER_RCOMMAND)
NATIVE {AMIGAKEYS}  CONST AMIGAKEYS  = (AMIGALEFT OR AMIGARIGHT)

NATIVE {CURSORUP}    CONST CURSORUP    = $4C
NATIVE {CURSORDOWN}  CONST CURSORDOWN  = $4D
NATIVE {CURSORRIGHT} CONST CURSORRIGHT = $4E
NATIVE {CURSORLEFT}  CONST CURSORLEFT  = $4F

NATIVE {KEYCODE_Q}	CONST KEYCODE_Q	= $10
NATIVE {KEYCODE_Z}	CONST KEYCODE_Z	= $31
NATIVE {KEYCODE_X}	CONST KEYCODE_X	= $32
NATIVE {KEYCODE_V}	CONST KEYCODE_V	= $34
NATIVE {KEYCODE_B}	CONST KEYCODE_B	= $35
NATIVE {KEYCODE_N}	CONST KEYCODE_N	= $36
NATIVE {KEYCODE_M}	CONST KEYCODE_M	= $37
NATIVE {KEYCODE_LESS}	CONST KEYCODE_LESS	= $38
NATIVE {KEYCODE_GREATER} CONST KEYCODE_GREATER = $39

			   /* Miscellaneous */

->"OBJECT ibox" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {Remember} OBJECT remember
    {NextRemember}	nextremember	:PTR TO remember
    {RememberSize}	remembersize	:ULONG
    {Memory}	memory	:PTR TO UBYTE
ENDOBJECT

NATIVE {ColorSpec} OBJECT colorspec
    {ColorIndex}	colorindex	:INT
    {Red}	red	:UINT
    {Green}	green	:UINT
    {Blue}	blue	:UINT
ENDOBJECT

NATIVE {FOREVER} CONST ->FOREVER = for(;;)
NATIVE {SIGN} CONST	->SIGN(x) (((x)>0) - ((x)<0))
NATIVE {NOT} CONST ->NOT = !

NATIVE {ALERT_TYPE}     CONST ALERT_TYPE     = $80000000
NATIVE {RECOVERY_ALERT} CONST RECOVERY_ALERT = $00000000
NATIVE {DEADEND_ALERT}  CONST DEADEND_ALERT  = $80000000

NATIVE {AUTOFRONTPEN}  CONST AUTOFRONTPEN  = 0
NATIVE {AUTOBACKPEN}   CONST AUTOBACKPEN   = 1
NATIVE {AUTODRAWMODE}  CONST AUTODRAWMODE  = RP_JAM2
NATIVE {AUTOLEFTEDGE}  CONST AUTOLEFTEDGE  = 6
NATIVE {AUTORIGHTEDGE} CONST AUTORIGHTEDGE = 3
NATIVE {AUTOITEXTFONT} CONST AUTOITEXTFONT = NIL
NATIVE {AUTONEXTTEXT}  CONST AUTONEXTTEXT  = NIL

/* NewDecorator structure used by ChangeDecoration
   the three Objects (nd_Window, nd_Screen and nd_Menu
   must be installed and point to decorator objects
   the port is used for different issues and will be filled
   up with DecoratorMessages */

NATIVE {NewDecorator} OBJECT newdecorator
   {nd_Node}	node	:ln
    {nd_Port}	port	:PTR TO mp
            {nd_cnt}	cnt	:UINT
            {nd_Pattern}	pattern	:/*STRPTR*/ ARRAY OF CHAR
            {nd_IntPattern}	intpattern	:/*STRPTR*/ ARRAY OF CHAR /* Private, transformated Pattern be dos/ParsePattern() */
            {nd_Window}	window	:PTR TO /*Object*/ ULONG
            {nd_Screen}	screen	:PTR TO /*Object*/ ULONG
            {nd_Menu}	menu	:PTR TO /*Object*/ ULONG
ENDOBJECT

NATIVE {DecoratorMessage} OBJECT decoratormessage
    {dm_Message}	message	:magicmessage
    {dm_Class}	class	:ULONG
    {dm_Code}	code	:ULONG
    {dm_Flags}	flags	:ULONG
    {dm_Object}	object	:IPTR
ENDOBJECT

NATIVE {DECORATOR_VERSION}  CONST DECORATOR_VERSION  = 0

/* there is only one Message in the initial decoration system
   it will be sent to the decorator port to signal that it´ll not be used any longer
   and may be destroyed, in that case the dm_Object contains the NewDecorator struct
   Intuition does not touch anything, the decorator have to destroy all objects as well as the
   NewDecorator struct. */

NATIVE {DM_CLASS_DESTROYDECORATOR}       CONST DM_CLASS_DESTROYDECORATOR       = $8001

NATIVE {ScreenNotifyMessage} OBJECT screennotifymessage
    {snm_Message}	message	:magicmessage
    {snm_Class}	class	:ULONG           /* Notification Class ID same as SNA_Notify */
    {snm_Code}	code	:ULONG            /* Code only supported for ScreenDepth() and will put the Flags in */
    {snm_Object}	object	:IPTR	     /* Pointer to the Object that caused this message */
    {snm_UserData}	userdata	:IPTR        /* will be filled with SNA_UserData */
ENDOBJECT

NATIVE {SCREENNOTIFY_VERSION} CONST SCREENNOTIFY_VERSION = 0

NATIVE {SNA_PubName}             CONST SNA_PUBNAME             = (TAG_USER + $01) /* public screen name of NULL for all screens */
NATIVE {SNA_Notify}              CONST SNA_NOTIFY              = (TAG_USER + $02) /* Flags to look for see below */
NATIVE {SNA_UserData}            CONST SNA_USERDATA            = (TAG_USER + $03) /* this tag will be passed to the screennotify message */
NATIVE {SNA_SigTask}             CONST SNA_SIGTASK             = (TAG_USER + $04) /* if port == NULL, a sigbit will be set for this task */
NATIVE {SNA_SigBit}              CONST SNA_SIGBIT              = (TAG_USER + $05) /* signal bit to set if port == NULL*/
NATIVE {SNA_MsgPort}             CONST SNA_MSGPORT             = (TAG_USER + $06) /* if != NULL post mesage to this port */
NATIVE {SNA_Priority}            CONST SNA_PRIORITY            = (TAG_USER + $07) /*  */
NATIVE {SNA_Hook}                CONST SNA_HOOK                = (TAG_USER + $08)

/* SNA_Notify (all unassigned bits are reserved for system use) */
NATIVE {SNOTIFY_AFTER_OPENSCREEN}        CONST SNOTIFY_AFTER_OPENSCREEN        = $1  /* screen has been opened */
NATIVE {SNOTIFY_BEFORE_CLOSESCREEN}      CONST SNOTIFY_BEFORE_CLOSESCREEN      = $2  /* going to close screen */
NATIVE {SNOTIFY_AFTER_OPENWB}            CONST SNOTIFY_AFTER_OPENWB            = $4  /* Workbench is open */
NATIVE {SNOTIFY_BEFORE_CLOSEWB}          CONST SNOTIFY_BEFORE_CLOSEWB          = $8  /* Workbench is going to be closed */
NATIVE {SNOTIFY_AFTER_OPENWINDOW}        CONST SNOTIFY_AFTER_OPENWINDOW        = $10  /* new window */
NATIVE {SNOTIFY_BEFORE_CLOSEWINDOW}      CONST SNOTIFY_BEFORE_CLOSEWINDOW      = $20  /* window is going to be closed */
NATIVE {SNOTIFY_PUBSCREENSTATE}          CONST SNOTIFY_PUBSCREENSTATE          = $40  /* PubScreenState() */
NATIVE {SNOTIFY_LOCKPUBSCREEN}           CONST SNOTIFY_LOCKPUBSCREEN           = $80  /* LockPubScreen() */
NATIVE {SNOTIFY_SCREENDEPTH}             CONST SNOTIFY_SCREENDEPTH             = $100  /* ScreenDepth() */
NATIVE {SNOTIFY_AFTER_CLOSESCREEN}       CONST SNOTIFY_AFTER_CLOSESCREEN       = $200	/* notify after CloseScreen() */
NATIVE {SNOTIFY_AFTER_CLOSEWINDOW}       CONST SNOTIFY_AFTER_CLOSEWINDOW       = $400	/* dto. CloseWindow() */
NATIVE {SNOTIFY_BEFORE_OPENSCREEN}       CONST SNOTIFY_BEFORE_OPENSCREEN       = $800	/* notify before OpenScreen() */
NATIVE {SNOTIFY_BEFORE_OPENWINDOW}       CONST SNOTIFY_BEFORE_OPENWINDOW       = $1000	/* dto. OpenWindow() */
NATIVE {SNOTIFY_BEFORE_OPENWB}           CONST SNOTIFY_BEFORE_OPENWB           = $2000	/* like OPENSCREEN */
NATIVE {SNOTIFY_AFTER_CLOSEWB}           CONST SNOTIFY_AFTER_CLOSEWB           = $4000	/* like CLOSESCREEN */
NATIVE {SNOTIFY_WAIT_REPLY}              CONST SNOTIFY_WAIT_REPLY              = $8000 /* wait for reply before taking action */
NATIVE {SNOTIFY_UNLOCKPUBSCREEN}         CONST SNOTIFY_UNLOCKPUBSCREEN         = $10000 /* UnlockPubScreen() */
NATIVE {SNOTIFY_BEFORE_UPDATEINTUITION}  CONST SNOTIFY_BEFORE_UPDATEINTUITION  = $20000 /* Intuition is going to be updated */
NATIVE {SNOTIFY_AFTER_UPDATEINTUITION}   CONST SNOTIFY_AFTER_UPDATEINTUITION   = $40000 /* Intuition is updated */
