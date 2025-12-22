/* $VER: gadgetclass.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/intuition/intuition', 'target/utility/tagitem', 'target/intuition/iobsolete'
MODULE 'target/intuition/cghooks', 'target/graphics/rastport', 'target/devices/inputevent', 'target/exec/types'
{MODULE 'intuition/gadgetclass'}

/* Gadget class attributes */
NATIVE {GA_DUMMY} 		CONST GA_DUMMY 		= (TAG_USER+$30000)

NATIVE {GA_LEFT}			CONST GA_LEFT			= (GA_DUMMY+1)

NATIVE {GA_RELRIGHT}		CONST GA_RELRIGHT		= (GA_DUMMY+2)

NATIVE {GA_TOP}			CONST GA_TOP			= (GA_DUMMY+3)

NATIVE {GA_RELBOTTOM}		CONST GA_RELBOTTOM		= (GA_DUMMY+4)

NATIVE {GA_WIDTH}		CONST GA_WIDTH		= (GA_DUMMY+5)

NATIVE {GA_RELWIDTH}		CONST GA_RELWIDTH		= (GA_DUMMY+6)

NATIVE {GA_HEIGHT}		CONST GA_HEIGHT		= (GA_DUMMY+7)

NATIVE {GA_RELHEIGHT}		CONST GA_RELHEIGHT		= (GA_DUMMY+8)

NATIVE {GA_TEXT}			CONST GA_TEXT			= (GA_DUMMY+9)

NATIVE {GA_IMAGE}		CONST GA_IMAGE		= (GA_DUMMY+10)

NATIVE {GA_BORDER}		CONST GA_BORDER		= (GA_DUMMY+11)

NATIVE {GA_SELECTRENDER}		CONST GA_SELECTRENDER		= (GA_DUMMY+12)

NATIVE {GA_HIGHLIGHT}		CONST GA_HIGHLIGHT		= (GA_DUMMY+13)

NATIVE {GA_DISABLED}		CONST GA_DISABLED		= (GA_DUMMY+14)

NATIVE {GA_GZZGADGET}		CONST GA_GZZGADGET		= (GA_DUMMY+15)

NATIVE {GA_ID}			CONST GA_ID			= (GA_DUMMY+16)

NATIVE {GA_USERDATA}		CONST GA_USERDATA		= (GA_DUMMY+17)

NATIVE {GA_SPECIALINFO}		CONST GA_SPECIALINFO		= (GA_DUMMY+18)

NATIVE {GA_SELECTED}		CONST GA_SELECTED		= (GA_DUMMY+19)

NATIVE {GA_ENDGADGET}		CONST GA_ENDGADGET		= (GA_DUMMY+20)

NATIVE {GA_IMMEDIATE}		CONST GA_IMMEDIATE		= (GA_DUMMY+21)

NATIVE {GA_RELVERIFY}		CONST GA_RELVERIFY		= (GA_DUMMY+22)

NATIVE {GA_FOLLOWMOUSE}		CONST GA_FOLLOWMOUSE		= (GA_DUMMY+23)

NATIVE {GA_RIGHTBORDER}		CONST GA_RIGHTBORDER		= (GA_DUMMY+24)

NATIVE {GA_LEFTBORDER}		CONST GA_LEFTBORDER		= (GA_DUMMY+25)

NATIVE {GA_TOPBORDER}		CONST GA_TOPBORDER		= (GA_DUMMY+26)

NATIVE {GA_BOTTOMBORDER}		CONST GA_BOTTOMBORDER		= (GA_DUMMY+27)

NATIVE {GA_TOGGLESELECT}		CONST GA_TOGGLESELECT		= (GA_DUMMY+28)

NATIVE {GA_SYSGADGET}		CONST GA_SYSGADGET		= (GA_DUMMY+29)

NATIVE {GA_SYSGTYPE}		CONST GA_SYSGTYPE		= (GA_DUMMY+30)

NATIVE {GA_PREVIOUS}		CONST GA_PREVIOUS		= (GA_DUMMY+31)

NATIVE {GA_NEXT}			CONST GA_NEXT			= (GA_DUMMY+32)

NATIVE {GA_DRAWINFO}		CONST GA_DRAWINFO		= (GA_DUMMY+33)

NATIVE {GA_INTUITEXT}		CONST GA_INTUITEXT		= (GA_DUMMY+34)

NATIVE {GA_LABELIMAGE}		CONST GA_LABELIMAGE		= (GA_DUMMY+35)

NATIVE {GA_TABCYCLE}		CONST GA_TABCYCLE		= (GA_DUMMY+36)

NATIVE {GA_GADGETHELP}		CONST GA_GADGETHELP		= (GA_DUMMY+37)

NATIVE {GA_BOUNDS}		CONST GA_BOUNDS		= (GA_DUMMY+38)

NATIVE {GA_RELSPECIAL}		CONST GA_RELSPECIAL		= (GA_DUMMY+39)

NATIVE {GA_TEXTATTR}		CONST GA_TEXTATTR		= (GA_DUMMY+40)

NATIVE {GA_READONLY}		CONST GA_READONLY		= (GA_DUMMY+41)

CONST GA_UNDERSCORE		= (GA_DUMMY+42)

CONST GA_ACTIVATEKEY		= (GA_DUMMY+43)

CONST GA_BACKFILL		= (GA_DUMMY+44)

CONST GA_GADGETHELPTEXT		= (GA_DUMMY+45)

CONST GA_USERINPUT		= (GA_DUMMY+46)

/*****************************************************************************/

/* PROPGCLASS attributes */
NATIVE {PGA_DUMMY}	CONST PGA_DUMMY	= (TAG_USER+$31000)
NATIVE {PGA_FREEDOM}	CONST PGA_FREEDOM	= (PGA_DUMMY+$0001)
	/* only one of FREEVERT or FREEHORIZ */
NATIVE {PGA_BORDERLESS}	CONST PGA_BORDERLESS	= (PGA_DUMMY+$0002)
NATIVE {PGA_HORIZPOT}	CONST PGA_HORIZPOT	= (PGA_DUMMY+$0003)
NATIVE {PGA_HORIZBODY}	CONST PGA_HORIZBODY	= (PGA_DUMMY+$0004)
NATIVE {PGA_VERTPOT}	CONST PGA_VERTPOT	= (PGA_DUMMY+$0005)
NATIVE {PGA_VERTBODY}	CONST PGA_VERTBODY	= (PGA_DUMMY+$0006)
NATIVE {PGA_TOTAL}	CONST PGA_TOTAL	= (PGA_DUMMY+$0007)
NATIVE {PGA_VISIBLE}	CONST PGA_VISIBLE	= (PGA_DUMMY+$0008)
NATIVE {PGA_TOP}		CONST PGA_TOP		= (PGA_DUMMY+$0009)
/* New for V37: */
NATIVE {PGA_NEWLOOK}	CONST PGA_NEWLOOK	= (PGA_DUMMY+$000A)

/*****************************************************************************/

/* STRGCLASS attributes */
NATIVE {STRINGA_DUMMY}  		CONST STRINGA_DUMMY  		= (TAG_USER     +$32000)
NATIVE {STRINGA_MAXCHARS}	CONST STRINGA_MAXCHARS	= (STRINGA_DUMMY+$0001)

NATIVE {STRINGA_BUFFER}		CONST STRINGA_BUFFER		= (STRINGA_DUMMY+$0002)
NATIVE {STRINGA_UNDOBUFFER}	CONST STRINGA_UNDOBUFFER	= (STRINGA_DUMMY+$0003)
NATIVE {STRINGA_WORKBUFFER}	CONST STRINGA_WORKBUFFER	= (STRINGA_DUMMY+$0004)
NATIVE {STRINGA_BUFFERPOS}	CONST STRINGA_BUFFERPOS	= (STRINGA_DUMMY+$0005)
NATIVE {STRINGA_DISPPOS}		CONST STRINGA_DISPPOS		= (STRINGA_DUMMY+$0006)
NATIVE {STRINGA_ALTKEYMAP}	CONST STRINGA_ALTKEYMAP	= (STRINGA_DUMMY+$0007)
NATIVE {STRINGA_FONT}		CONST STRINGA_FONT		= (STRINGA_DUMMY+$0008)
NATIVE {STRINGA_PENS}		CONST STRINGA_PENS		= (STRINGA_DUMMY+$0009)
NATIVE {STRINGA_ACTIVEPENS}	CONST STRINGA_ACTIVEPENS	= (STRINGA_DUMMY+$000A)
NATIVE {STRINGA_EDITHOOK}	CONST STRINGA_EDITHOOK	= (STRINGA_DUMMY+$000B)
NATIVE {STRINGA_EDITMODES}	CONST STRINGA_EDITMODES	= (STRINGA_DUMMY+$000C)

/* booleans */
NATIVE {STRINGA_REPLACEMODE}	CONST STRINGA_REPLACEMODE	= (STRINGA_DUMMY+$000D)
NATIVE {STRINGA_FIXEDFIELDMODE}	CONST STRINGA_FIXEDFIELDMODE	= (STRINGA_DUMMY+$000E)
NATIVE {STRINGA_NOFILTERMODE}	CONST STRINGA_NOFILTERMODE	= (STRINGA_DUMMY+$000F)

NATIVE {STRINGA_JUSTIFICATION}	CONST STRINGA_JUSTIFICATION	= (STRINGA_DUMMY+$0010)
	/* GACT_STRINGCENTER, GACT_STRINGLEFT, GACT_STRINGRIGHT */
NATIVE {STRINGA_LONGVAL}		CONST STRINGA_LONGVAL		= (STRINGA_DUMMY+$0011)
NATIVE {STRINGA_TEXTVAL}		CONST STRINGA_TEXTVAL		= (STRINGA_DUMMY+$0012)

NATIVE {STRINGA_EXITHELP}	CONST STRINGA_EXITHELP	= (STRINGA_DUMMY+$0013)

NATIVE {SG_DEFAULTMAXCHARS}	CONST SG_DEFAULTMAXCHARS	= (128)

/*****************************************************************************/

/* Gadget layout related attributes */
NATIVE {LAYOUTA_DUMMY} 		CONST LAYOUTA_DUMMY 		= (TAG_USER+$38000)
NATIVE {LAYOUTA_LAYOUTOBJ}	CONST LAYOUTA_LAYOUTOBJ	= (LAYOUTA_DUMMY+$0001)
NATIVE {LAYOUTA_SPACING}		CONST LAYOUTA_SPACING		= (LAYOUTA_DUMMY+$0002)
NATIVE {LAYOUTA_ORIENTATION}	CONST LAYOUTA_ORIENTATION	= (LAYOUTA_DUMMY+$0003)

NATIVE {LAYOUTA_CHILDMAXWIDTH}	CONST LAYOUTA_CHILDMAXWIDTH	= (LAYOUTA_DUMMY+$0004)
NATIVE {LAYOUTA_CHILDMAXHEIGHT}	CONST LAYOUTA_CHILDMAXHEIGHT	= (LAYOUTA_DUMMY+$0005)

/* orientation values */
NATIVE {LORIENT_NONE}	CONST LORIENT_NONE	= 0
NATIVE {LORIENT_HORIZ}	CONST LORIENT_HORIZ	= 1
NATIVE {LORIENT_VERT}	CONST LORIENT_VERT	= 2

/*****************************************************************************/

/* Gadget Method ID's */
CONST GM_DUMMY	= (-1)

NATIVE {GM_HITTEST}	CONST GM_HITTEST	= (0)

NATIVE {GM_RENDER}	CONST GM_RENDER	= (1)

NATIVE {GM_GOACTIVE}	CONST GM_GOACTIVE	= (2)

NATIVE {GM_HANDLEINPUT}	CONST GM_HANDLEINPUT	= (3)

NATIVE {GM_GOINACTIVE}	CONST GM_GOINACTIVE	= (4)

NATIVE {GM_HELPTEST}	CONST GM_HELPTEST	= (5)

NATIVE {GM_LAYOUT}	CONST GM_LAYOUT	= (6)

NATIVE {GM_DOMAIN}	CONST GM_DOMAIN	= (7)

CONST GM_KEYTEST	= (8)

CONST GM_KEYGOACTIVE	= (9)

CONST GM_KEYGOINACTIVE	= (10)

/*****************************************************************************/

/* Parameter "Messages" passed to gadget class methods	*/

NATIVE {gphittest} OBJECT gphittest
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
	{mousex}	mousex	:INT
	{mousey}	mousey	:INT
ENDOBJECT

NATIVE {GMR_GADGETHIT}	CONST GMR_GADGETHIT	= ($00000004)	/* GM_HITTEST hit */

NATIVE {GMR_NOHELPHIT}	CONST GMR_NOHELPHIT	= ($00000000)	/* GM_HELPTEST didn't hit */
NATIVE {GMR_HELPHIT}	CONST GMR_HELPHIT	= ($FFFFFFFF)	/* GM_HELPTEST hit, return code = ~0 */
NATIVE {GMR_HELPCODE}	CONST GMR_HELPCODE	= ($00010000)	/* GM_HELPTEST hit, return low word as code */

/*****************************************************************************/

/* GM_RENDER	*/
NATIVE {gprender} OBJECT gprender
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo	/* gadget context		*/
    {rport}	rport	:PTR TO rastport	/* all ready for use		*/
    {redraw}	redraw	:VALUE	/* might be a "highlight pass"	*/
ENDOBJECT

/* values of gpr_Redraw	*/
NATIVE {GREDRAW_UPDATE}	CONST GREDRAW_UPDATE	= (2)	/* incremental update, e.g. prop slider	*/
NATIVE {GREDRAW_REDRAW}	CONST GREDRAW_REDRAW	= (1)	/* redraw gadget	*/
NATIVE {GREDRAW_TOGGLE}	CONST GREDRAW_TOGGLE	= (0)	/* toggle highlight, if applicable	*/

/*****************************************************************************/

/* GM_GOACTIVE, GM_HANDLEINPUT	*/
NATIVE {gpinput} OBJECT gpinput
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {ievent}	ievent	:PTR TO inputevent
    {termination}	termination	:PTR TO VALUE
	{mousex}	mousex	:INT
	{mousey}	mousey	:INT

    {tabletdata}	tabletdata	:PTR TO tabletdata
ENDOBJECT

NATIVE {GMR_MEACTIVE}	CONST GMR_MEACTIVE	= (0)
NATIVE {GMR_NOREUSE}	CONST GMR_NOREUSE	= $2
NATIVE {GMR_REUSE}	CONST GMR_REUSE	= $4
NATIVE {GMR_VERIFY}	CONST GMR_VERIFY	= $8	/* you MUST set gpi_Termination */

NATIVE {GMR_NEXTACTIVE}	CONST GMR_NEXTACTIVE	= $10
NATIVE {GMR_PREVACTIVE}	CONST GMR_PREVACTIVE	= $20

/*****************************************************************************/

/* GM_GOINACTIVE */
NATIVE {gpgoinactive} OBJECT gpgoinactive
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo

    /* V37 field only!  DO NOT attempt to read under V36! */
    {abort}	abort	:ULONG	/* gpgi_Abort=1 if gadget was aborted
					 * by Intuition and 0 if gadget went
					 * inactive at its own request
					 */
ENDOBJECT

/*****************************************************************************/

/* GM_LAYOUT */
NATIVE {gplayout} OBJECT gplayout
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {initial}	initial	:ULONG	/* non-zero if this method was invoked
					 * during AddGList() or OpenWindow()
					 * time.  zero if this method was invoked
					 * during window resizing. */
ENDOBJECT

/*****************************************************************************/

/* GM_DOMAIN */
NATIVE {gpdomain} OBJECT gpdomain
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {rport}	rport	:PTR TO rastport	/* RastPort to layout for */
    {which}	which	:VALUE
    {domain}	domain	:ibox	/* Resulting domain */
    {attrs}	attrs	:ARRAY OF tagitem	/* Additional attributes */
ENDOBJECT

NATIVE {GDOMAIN_MINIMUM}		CONST GDOMAIN_MINIMUM		= (0)
    /* Minimum size */

NATIVE {GDOMAIN_NOMINAL}		CONST GDOMAIN_NOMINAL		= (1)
    /* Nominal size */

NATIVE {GDOMAIN_MAXIMUM}		CONST GDOMAIN_MAXIMUM		= (2)
    /* Maximum size */


/*****************************************************************************/

/* GM_KEYTEST send this message. */
/*NATIVE {gpkeytest} OBJECT gpkeytest
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {imsg}	imsg	:PTR TO intuimessage	/* The IntuiMessage that triggered this */
    {vanillakey}	vanillakey	:ULONG
ENDOBJECT*/

/*****************************************************************************/

/*NATIVE {gpkeyinput} OBJECT gpkeyinput
    {methodid}	methodid	:ULONG			/* GM_KEYGOACTIVE */
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {ievent}	ievent	:PTR TO inputevent
    {termination}	termination	:PTR TO VALUE
ENDOBJECT*/

CONST GMR_KEYACTIVE	= $10
CONST GMR_KEYVERIFY	= $20	/* you MUST set gpk_Termination */

/*NATIVE {gpkeygoinactive} OBJECT gpkeygoinactive
    {methodid}	methodid	:ULONG			/* GM_KEYGOINACTIVE */
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {abort}	abort	:ULONG			/* TRUE if input was aborted */
ENDOBJECT*/


NATIVE {gpgoactive} OBJECT gpgoactive OF gpinput
ENDOBJECT
NATIVE {gphelptest} OBJECT gphelptest OF gphittest
ENDOBJECT
