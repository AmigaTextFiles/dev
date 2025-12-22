/* $VER: datatypesclass.h 44.1 (17.4.1999) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared3'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypes', 'target/intuition/intuition', 'target/devices/printer', 'target/devices/prtbase'
MODULE 'target/exec/semaphores', 'target/exec/types', 'target/graphics/gfx', 'target/graphics/view', 'target/intuition/cghooks', 'target/exec/io', 'target/graphics/rastport', 'target/dos/dos'
{MODULE 'datatypes/datatypesclass'}

NATIVE {DATATYPESCLASS}		CONST
#define DATATYPESCLASS datatypesclass
STATIC datatypesclass		= 'datatypesclass'

/*****************************************************************************/

NATIVE {DTA_DUMMY}		CONST DTA_DUMMY		= (TAG_USER+$1000)

/*****************************************************************************/

/* Generic attributes */


/* (struct TextAttr *) Pointer to the default TextAttr to use for
 * the text within the object.
 */
NATIVE {DTA_TEXTATTR}		CONST DTA_TEXTATTR		= (DTA_DUMMY+10)

/* (LONG) Current top vertical unit */
NATIVE {DTA_TOPVERT}		CONST DTA_TOPVERT		= (DTA_DUMMY+11)

/* (LONG) Number of visible vertical units */
NATIVE {DTA_VISIBLEVERT}		CONST DTA_VISIBLEVERT		= (DTA_DUMMY+12)

/* (LONG) Total number of vertical units */
NATIVE {DTA_TOTALVERT}		CONST DTA_TOTALVERT		= (DTA_DUMMY+13)

/* (LONG) Number of pixels per vertical unit */
NATIVE {DTA_VERTUNIT}		CONST DTA_VERTUNIT		= (DTA_DUMMY+14)

/* (LONG) Current top horizontal unit */
NATIVE {DTA_TOPHORIZ}		CONST DTA_TOPHORIZ		= (DTA_DUMMY+15)

/* (LONG)  Number of visible horizontal units */
NATIVE {DTA_VISIBLEHORIZ}	CONST DTA_VISIBLEHORIZ	= (DTA_DUMMY+16)

/* (LONG) Total number of horizontal units */
NATIVE {DTA_TOTALHORIZ}		CONST DTA_TOTALHORIZ		= (DTA_DUMMY+17)

/* (LONG) Number of pixels per horizontal unit */
NATIVE {DTA_HORIZUNIT}		CONST DTA_HORIZUNIT		= (DTA_DUMMY+18)

/* (UBYTE *) Name of the current element within the object. */
NATIVE {DTA_NODENAME}		CONST DTA_NODENAME		= (DTA_DUMMY+19)

/* (UBYTE *) Title of the object. */
NATIVE {DTA_TITLE}		CONST DTA_TITLE		= (DTA_DUMMY+20)

/* (struct DTMethod *) Pointer to a NULL terminated array of
 * supported trigger methods.
 */
NATIVE {DTA_TRIGGERMETHODS}	CONST DTA_TRIGGERMETHODS	= (DTA_DUMMY+21)

/* (APTR) Object specific data. */
NATIVE {DTA_DATA}		CONST DTA_DATA		= (DTA_DUMMY+22)

/* (struct TextFont *) Default font to use for text within the
 * object.
 */
NATIVE {DTA_TEXTFONT}		CONST DTA_TEXTFONT		= (DTA_DUMMY+23)

/* (ULONG *) Pointer to a ~0 terminated array of supported
 * methods.
 */
NATIVE {DTA_METHODS}		CONST DTA_METHODS		= (DTA_DUMMY+24)

/* (LONG) Printer error message.  Error numbers are defined in
 * <devices/printer.h>
 */
NATIVE {DTA_PRINTERSTATUS}	CONST DTA_PRINTERSTATUS	= (DTA_DUMMY+25)

/* PRIVATE (struct Process *) Pointer to the print process. */
NATIVE {DTA_PRINTERPROC}		CONST DTA_PRINTERPROC		= (DTA_DUMMY+26)

/* PRIVATE (struct Process *) Pointer to the layout process. */
NATIVE {DTA_LAYOUTPROC}		CONST DTA_LAYOUTPROC		= (DTA_DUMMY+27)

/* Used to turn the applications' busy pointer off and on */
NATIVE {DTA_BUSY}		CONST DTA_BUSY		= (DTA_DUMMY+28)

/* Used to indicate that new information has been loaded into
 * an object.  This is for models that cache the DTA_TopVert-
 * like tags
 */
NATIVE {DTA_SYNC}		CONST DTA_SYNC		= (DTA_DUMMY+29)

/* The base name of the class */
NATIVE {DTA_BASENAME}		CONST DTA_BASENAME		= (DTA_DUMMY+30)

/* Group that the object must belong in */
NATIVE {DTA_GROUPID}		CONST DTA_GROUPID		= (DTA_DUMMY+31)

/* Error level */
NATIVE {DTA_ERRORLEVEL}		CONST DTA_ERRORLEVEL		= (DTA_DUMMY+32)

/* datatypes.library error number */
NATIVE {DTA_ERRORNUMBER}		CONST DTA_ERRORNUMBER		= (DTA_DUMMY+33)

/* Argument for datatypes.library error */
NATIVE {DTA_ERRORSTRING}		CONST DTA_ERRORSTRING		= (DTA_DUMMY+34)

/* New for V40. (UBYTE *) specifies the name of the
 * realtime.library conductor.	Defaults to "Main".
 */
NATIVE {DTA_CONDUCTOR}		CONST DTA_CONDUCTOR		= (DTA_DUMMY+35)

/* New for V40. (BOOL) Indicate whether a control panel should be
 * embedded within the object (in the animation datatype, for
 * example).  Defaults to TRUE.
 */
NATIVE {DTA_CONTROLPANEL}	CONST DTA_CONTROLPANEL	= (DTA_DUMMY+36)

/* New for V40. (BOOL) Indicate whether the object should
 * immediately begin playing.  Defaults to FALSE.
 */
NATIVE {DTA_IMMEDIATE}		CONST DTA_IMMEDIATE		= (DTA_DUMMY+37)

/* New for V40. (BOOL) Indicate that the object should repeat
 * playing.  Defaults to FALSE.
 */
NATIVE {DTA_REPEAT}		CONST DTA_REPEAT		= (DTA_DUMMY+38)

/* New for V44. Address of a DTST_MEMORY source type
 * object (APTR).
 */
CONST DTA_SOURCEADDRESS	= (DTA_DUMMY+39)

/* New for V44. Size of a DTST_MEMORY source type
 * object (ULONG).
 */
CONST DTA_SOURCESIZE		= (DTA_DUMMY+40)

/* Reserved tag; DO NOT USE (V44) */
CONST DTA_RESERVED		= (DTA_DUMMY+41)

/* DTObject attributes */
NATIVE {DTA_NAME}		CONST DTA_NAME		= (DTA_DUMMY+100)
NATIVE {DTA_SOURCETYPE}		CONST DTA_SOURCETYPE		= (DTA_DUMMY+101)
NATIVE {DTA_HANDLE}		CONST DTA_HANDLE		= (DTA_DUMMY+102)
NATIVE {DTA_DATATYPE}		CONST DTA_DATATYPE		= (DTA_DUMMY+103)
NATIVE {DTA_DOMAIN}		CONST DTA_DOMAIN		= (DTA_DUMMY+104)

/* DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> */
NATIVE {DTA_LEFT}		CONST DTA_LEFT		= (DTA_DUMMY+105)
NATIVE {DTA_TOP}			CONST DTA_TOP			= (DTA_DUMMY+106)
NATIVE {DTA_WIDTH}		CONST DTA_WIDTH		= (DTA_DUMMY+107)
NATIVE {DTA_HEIGHT}		CONST DTA_HEIGHT		= (DTA_DUMMY+108)

NATIVE {DTA_OBJNAME}		CONST DTA_OBJNAME		= (DTA_DUMMY+109)
NATIVE {DTA_OBJAUTHOR}		CONST DTA_OBJAUTHOR		= (DTA_DUMMY+110)
NATIVE {DTA_OBJANNOTATION}	CONST DTA_OBJANNOTATION	= (DTA_DUMMY+111)
NATIVE {DTA_OBJCOPYRIGHT}	CONST DTA_OBJCOPYRIGHT	= (DTA_DUMMY+112)
NATIVE {DTA_OBJVERSION}		CONST DTA_OBJVERSION		= (DTA_DUMMY+113)
NATIVE {DTA_OBJECTID}		CONST DTA_OBJECTID		= (DTA_DUMMY+114)
NATIVE {DTA_USERDATA}		CONST DTA_USERDATA		= (DTA_DUMMY+115)
NATIVE {DTA_FRAMEINFO}		CONST DTA_FRAMEINFO		= (DTA_DUMMY+116)

/* DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> */
NATIVE {DTA_RELRIGHT}		CONST DTA_RELRIGHT		= (DTA_DUMMY+117)
NATIVE {DTA_RELBOTTOM}		CONST DTA_RELBOTTOM		= (DTA_DUMMY+118)
NATIVE {DTA_RELWIDTH}		CONST DTA_RELWIDTH		= (DTA_DUMMY+119)
NATIVE {DTA_RELHEIGHT}		CONST DTA_RELHEIGHT		= (DTA_DUMMY+120)

NATIVE {DTA_SELECTDOMAIN}	CONST DTA_SELECTDOMAIN	= (DTA_DUMMY+121)
NATIVE {DTA_TOTALPVERT}		CONST DTA_TOTALPVERT		= (DTA_DUMMY+122)
NATIVE {DTA_TOTALPHORIZ}		CONST DTA_TOTALPHORIZ		= (DTA_DUMMY+123)
NATIVE {DTA_NOMINALVERT}		CONST DTA_NOMINALVERT		= (DTA_DUMMY+124)
NATIVE {DTA_NOMINALHORIZ}	CONST DTA_NOMINALHORIZ	= (DTA_DUMMY+125)

/* Printing attributes */

/* (LONG) Destination X width */
NATIVE {DTA_DESTCOLS}		CONST DTA_DESTCOLS		= (DTA_DUMMY+400)

/* (LONG) Destination Y height */
NATIVE {DTA_DESTROWS}		CONST DTA_DESTROWS		= (DTA_DUMMY+401)

/* (UWORD) Option flags */
NATIVE {DTA_SPECIAL}		CONST DTA_SPECIAL		= (DTA_DUMMY+402)

/* (struct RastPort *) RastPort to use when printing. (V40) */
NATIVE {DTA_RASTPORT}		CONST DTA_RASTPORT		= (DTA_DUMMY+403)

/* (STRPTR) Pointer to base name for ARexx port (V40) */
NATIVE {DTA_AREXXPORTNAME}	CONST DTA_AREXXPORTNAME	= (DTA_DUMMY+404)


/*****************************************************************************/

NATIVE {DTST_RAM}		CONST DTST_RAM		= 1
NATIVE {DTST_FILE}		CONST DTST_FILE		= 2
NATIVE {DTST_CLIPBOARD}		CONST DTST_CLIPBOARD		= 3
NATIVE {DTST_HOTLINK}		CONST DTST_HOTLINK		= 4
CONST DTST_MEMORY		= 5	/* New for V44 */

/*****************************************************************************/

/* Attached to the Gadget.SpecialInfo field of the gadget.  Don't access directly,
 * use the Get/Set calls instead.
 */
NATIVE {dtspecialinfo} OBJECT dtspecialinfo
    {lock}	lock	:ss	/* Locked while in DoAsyncLayout() */
    {flags}	flags	:ULONG

    {topvert}	topvert	:VALUE	/* Top row (in units) */
    {visvert}	visvert	:VALUE	/* Number of visible rows (in units) */
    {totvert}	totvert	:VALUE	/* Total number of rows (in units) */
    {otopvert}	otopvert	:VALUE	/* Previous top (in units) */
    {vertunit}	vertunit	:VALUE	/* Number of pixels in vertical unit */

    {tophoriz}	tophoriz	:VALUE	/* Top column (in units) */
    {vishoriz}	vishoriz	:VALUE	/* Number of visible columns (in units) */
    {tothoriz}	tothoriz	:VALUE	/* Total number of columns (in units) */
    {otophoriz}	otophoriz	:VALUE	/* Previous top (in units) */
    {horizunit}	horizunit	:VALUE	/* Number of pixels in horizontal unit */
ENDOBJECT


/* Object is in layout processing */
NATIVE {DTSIF_LAYOUT}		CONST DTSIF_LAYOUT		= 1 SHL 0

/* Object needs to be layed out */
NATIVE {DTSIF_NEWSIZE}		CONST DTSIF_NEWSIZE		= 1 SHL 1

NATIVE {DTSIF_DRAGGING}		CONST DTSIF_DRAGGING		= 1 SHL 2
NATIVE {DTSIF_DRAGSELECT}	CONST DTSIF_DRAGSELECT	= 1 SHL 3

NATIVE {DTSIF_HIGHLIGHT}		CONST DTSIF_HIGHLIGHT		= 1 SHL 4

/* Object is being printed */
NATIVE {DTSIF_PRINTING}		CONST DTSIF_PRINTING		= 1 SHL 5

/* Object is in layout process */
NATIVE {DTSIF_LAYOUTPROC}	CONST DTSIF_LAYOUTPROC	= 1 SHL 6

/*****************************************************************************/

NATIVE {dtmethod} OBJECT dtmethod
    {label}	label	:/*STRPTR*/ ARRAY OF CHAR
    {command}	command	:/*STRPTR*/ ARRAY OF CHAR
    {method}	method	:ULONG
ENDOBJECT

/*****************************************************************************/

CONST DTM_DUMMY		= ($600)

/* Inquire what environment an object requires */
NATIVE {DTM_FRAMEBOX}		CONST DTM_FRAMEBOX		= ($601)

/* Same as GM_LAYOUT except guaranteed to be on a process already */
NATIVE {DTM_PROCLAYOUT}		CONST DTM_PROCLAYOUT		= ($602)

/* Layout that is occurring on a process */
NATIVE {DTM_ASYNCLAYOUT}		CONST DTM_ASYNCLAYOUT		= ($603)

/* When a RemoveDTObject() is called */
NATIVE {DTM_REMOVEDTOBJECT}	CONST DTM_REMOVEDTOBJECT	= ($604)

NATIVE {DTM_SELECT}		CONST DTM_SELECT		= ($605)
NATIVE {DTM_CLEARSELECTED}	CONST DTM_CLEARSELECTED	= ($606)

NATIVE {DTM_COPY}		CONST DTM_COPY		= ($607)
NATIVE {DTM_PRINT}		CONST DTM_PRINT		= ($608)
NATIVE {DTM_ABORTPRINT}		CONST DTM_ABORTPRINT		= ($609)

NATIVE {DTM_NEWMEMBER}		CONST DTM_NEWMEMBER		= ($610)
NATIVE {DTM_DISPOSEMEMBER}	CONST DTM_DISPOSEMEMBER	= ($611)

NATIVE {DTM_GOTO}		CONST DTM_GOTO		= ($630)
NATIVE {DTM_TRIGGER}		CONST DTM_TRIGGER		= ($631)

NATIVE {DTM_OBTAINDRAWINFO}	CONST DTM_OBTAINDRAWINFO	= ($640)
NATIVE {DTM_DRAW}		CONST DTM_DRAW		= ($641)
NATIVE {DTM_RELEASEDRAWINFO}	CONST DTM_RELEASEDRAWINFO	= ($642)

NATIVE {DTM_WRITE}		CONST DTM_WRITE		= ($650)

/* Used to ask the object about itself */
NATIVE {frameinfo} OBJECT frameinfo
    {propertyflags}	propertyflags	:ULONG		/* DisplayInfo (graphics/displayinfo.h) */
    {resolution}	resolution	:tpoint		/* DisplayInfo */

    {redbits}	redbits	:UBYTE
    {greenbits}	greenbits	:UBYTE
    {bluebits}	bluebits	:UBYTE

	{width}	width	:ULONG
	{height}	height	:ULONG
	{depth}	depth	:ULONG

    {screen}	screen	:PTR TO screen
    {colormap}	colormap	:PTR TO colormap

    {flags}	flags	:ULONG
ENDOBJECT

NATIVE {FIF_SCALABLE}	CONST FIF_SCALABLE	= $1
NATIVE {FIF_SCROLLABLE}	CONST FIF_SCROLLABLE	= $2
NATIVE {FIF_REMAPPABLE}	CONST FIF_REMAPPABLE	= $4

/* DTM_REMOVEDTOBJECT, DTM_CLEARSELECTED, DTM_COPY, DTM_ABORTPRINT */
NATIVE {dtgeneral} OBJECT dtgeneral
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
ENDOBJECT

/* DTM_SELECT */
NATIVE {dtselect} OBJECT dtselect
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {select}	select	:rectangle
ENDOBJECT

/* DTM_FRAMEBOX */
NATIVE {dtframebox} OBJECT dtframebox
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {contentsinfo}	contentsinfo	:PTR TO frameinfo	/* Input */
    {frameinfo}	frameinfo	:PTR TO frameinfo		/* Output */
    {sizeframeinfo}	sizeframeinfo	:ULONG
    {frameflags}	frameflags	:ULONG
ENDOBJECT

->#ifndef	FRAMEF_SPECIFY
->"CONST FRAMEF_SPECIFY" is on-purposely missing from here (it can be found in 'intuition/intuition_shared3')
->#endif

/* DTM_GOTO */
NATIVE {dtgoto} OBJECT dtgoto
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {nodename}	nodename	:/*STRPTR*/ ARRAY OF CHAR		/* Node to goto */
    {attrlist}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* DTM_TRIGGER */
NATIVE {dttrigger} OBJECT dttrigger
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo
    {function}	function	:ULONG
    {data}	data	:APTR
ENDOBJECT

NATIVE {STM_PAUSE}		CONST STM_PAUSE		= 1
NATIVE {STM_PLAY}		CONST STM_PLAY		= 2
NATIVE {STM_CONTENTS}		CONST STM_CONTENTS		= 3
NATIVE {STM_INDEX}		CONST STM_INDEX		= 4
NATIVE {STM_RETRACE}		CONST STM_RETRACE		= 5
NATIVE {STM_BROWSE_PREV}		CONST STM_BROWSE_PREV		= 6
NATIVE {STM_BROWSE_NEXT}		CONST STM_BROWSE_NEXT		= 7

NATIVE {STM_NEXT_FIELD}		CONST STM_NEXT_FIELD		= 8
NATIVE {STM_PREV_FIELD}		CONST STM_PREV_FIELD		= 9
NATIVE {STM_ACTIVATE_FIELD}	CONST STM_ACTIVATE_FIELD	= 10

NATIVE {STM_COMMAND}		CONST STM_COMMAND		= 11

/* New for V40 */
NATIVE {STM_REWIND}		CONST STM_REWIND		= 12
NATIVE {STM_FASTFORWARD}		CONST STM_FASTFORWARD		= 13
NATIVE {STM_STOP}		CONST STM_STOP		= 14
NATIVE {STM_RESUME}		CONST STM_RESUME		= 15
NATIVE {STM_LOCATE}		CONST STM_LOCATE		= 16

/* Printer IO request */
OBJECT printerio
    ios	:iostd
    iodrp	:iodrpreq
    iopc	:ioprtcmdreq
ENDOBJECT

/* DTM_PRINT */
NATIVE {dtprint} OBJECT dtprint
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo		/* Gadget information */
    {ios}	ios	:PTR TO printerio		/* Printer IO request */
    {attrlist}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* DTM_DRAW */
NATIVE {dtdraw} OBJECT dtdraw
    {methodid}	methodid	:ULONG
    {rport}	rport	:PTR TO rastport
    {left}	left	:VALUE
    {top}	top	:VALUE
    {width}	width	:VALUE
    {height}	height	:VALUE
    {tophoriz}	tophoriz	:VALUE
    {topvert}	topvert	:VALUE
    {attrlist}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* DTM_WRITE */
NATIVE {dtwrite} OBJECT dtwrite
    {methodid}	methodid	:ULONG
    {ginfo}	ginfo	:PTR TO gadgetinfo		/* Gadget information */
    {filehandle}	filehandle	:BPTR	/* File handle to write to */
    {mode}	mode	:ULONG
    {attrlist}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* Save data as IFF data */
NATIVE {DTWM_IFF}	CONST DTWM_IFF	= 0

/* Save data as local data format */
NATIVE {DTWM_RAW}	CONST DTWM_RAW	= 1
