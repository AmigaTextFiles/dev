/* $VER: datatypesclass.h 44.1 (17.4.1999) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/intuition/intuition_shared3'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypes', 'target/intuition/intuition', 'target/devices/printer', 'target/devices/prtbase'
MODULE 'target/exec/semaphores', 'target/exec/types', 'target/graphics/gfx', 'target/graphics/view', 'target/intuition/cghooks', 'target/exec/io', 'target/graphics/rastport', 'target/dos/dos'
{#include <datatypes/datatypesclass.h>}
NATIVE {DATATYPES_DATATYPESCLASS_H} CONST

NATIVE {DATATYPESCLASS}		CONST
#define DATATYPESCLASS datatypesclass
STATIC datatypesclass		= 'datatypesclass'

/*****************************************************************************/

NATIVE {DTA_Dummy}		CONST DTA_DUMMY		= (TAG_USER+$1000)

/*****************************************************************************/

/* Generic attributes */


/* (struct TextAttr *) Pointer to the default TextAttr to use for
 * the text within the object.
 */
NATIVE {DTA_TextAttr}		CONST DTA_TEXTATTR		= (DTA_DUMMY+10)

/* (LONG) Current top vertical unit */
NATIVE {DTA_TopVert}		CONST DTA_TOPVERT		= (DTA_DUMMY+11)

/* (LONG) Number of visible vertical units */
NATIVE {DTA_VisibleVert}		CONST DTA_VISIBLEVERT		= (DTA_DUMMY+12)

/* (LONG) Total number of vertical units */
NATIVE {DTA_TotalVert}		CONST DTA_TOTALVERT		= (DTA_DUMMY+13)

/* (LONG) Number of pixels per vertical unit */
NATIVE {DTA_VertUnit}		CONST DTA_VERTUNIT		= (DTA_DUMMY+14)

/* (LONG) Current top horizontal unit */
NATIVE {DTA_TopHoriz}		CONST DTA_TOPHORIZ		= (DTA_DUMMY+15)

/* (LONG)  Number of visible horizontal units */
NATIVE {DTA_VisibleHoriz}	CONST DTA_VISIBLEHORIZ	= (DTA_DUMMY+16)

/* (LONG) Total number of horizontal units */
NATIVE {DTA_TotalHoriz}		CONST DTA_TOTALHORIZ		= (DTA_DUMMY+17)

/* (LONG) Number of pixels per horizontal unit */
NATIVE {DTA_HorizUnit}		CONST DTA_HORIZUNIT		= (DTA_DUMMY+18)

/* (UBYTE *) Name of the current element within the object. */
NATIVE {DTA_NodeName}		CONST DTA_NODENAME		= (DTA_DUMMY+19)

/* (UBYTE *) Title of the object. */
NATIVE {DTA_Title}		CONST DTA_TITLE		= (DTA_DUMMY+20)

/* (struct DTMethod *) Pointer to a NULL terminated array of
 * supported trigger methods.
 */
NATIVE {DTA_TriggerMethods}	CONST DTA_TRIGGERMETHODS	= (DTA_DUMMY+21)

/* (APTR) Object specific data. */
NATIVE {DTA_Data}		CONST DTA_DATA		= (DTA_DUMMY+22)

/* (struct TextFont *) Default font to use for text within the
 * object.
 */
NATIVE {DTA_TextFont}		CONST DTA_TEXTFONT		= (DTA_DUMMY+23)

/* (ULONG *) Pointer to a ~0 terminated array of supported
 * methods.
 */
NATIVE {DTA_Methods}		CONST DTA_METHODS		= (DTA_DUMMY+24)

/* (LONG) Printer error message.  Error numbers are defined in
 * <devices/printer.h>
 */
NATIVE {DTA_PrinterStatus}	CONST DTA_PRINTERSTATUS	= (DTA_DUMMY+25)

/* PRIVATE (struct Process *) Pointer to the print process. */
NATIVE {DTA_PrinterProc}		CONST DTA_PRINTERPROC		= (DTA_DUMMY+26)

/* PRIVATE (struct Process *) Pointer to the layout process. */
NATIVE {DTA_LayoutProc}		CONST DTA_LAYOUTPROC		= (DTA_DUMMY+27)

/* Used to turn the applications' busy pointer off and on */
NATIVE {DTA_Busy}		CONST DTA_BUSY		= (DTA_DUMMY+28)

/* Used to indicate that new information has been loaded into
 * an object.  This is for models that cache the DTA_TopVert-
 * like tags
 */
NATIVE {DTA_Sync}		CONST DTA_SYNC		= (DTA_DUMMY+29)

/* The base name of the class */
NATIVE {DTA_BaseName}		CONST DTA_BASENAME		= (DTA_DUMMY+30)

/* Group that the object must belong in */
NATIVE {DTA_GroupID}		CONST DTA_GROUPID		= (DTA_DUMMY+31)

/* Error level */
NATIVE {DTA_ErrorLevel}		CONST DTA_ERRORLEVEL		= (DTA_DUMMY+32)

/* datatypes.library error number */
NATIVE {DTA_ErrorNumber}		CONST DTA_ERRORNUMBER		= (DTA_DUMMY+33)

/* Argument for datatypes.library error */
NATIVE {DTA_ErrorString}		CONST DTA_ERRORSTRING		= (DTA_DUMMY+34)

/* New for V40. (UBYTE *) specifies the name of the
 * realtime.library conductor.	Defaults to "Main".
 */
NATIVE {DTA_Conductor}		CONST DTA_CONDUCTOR		= (DTA_DUMMY+35)

/* New for V40. (BOOL) Indicate whether a control panel should be
 * embedded within the object (in the animation datatype, for
 * example).  Defaults to TRUE.
 */
NATIVE {DTA_ControlPanel}	CONST DTA_CONTROLPANEL	= (DTA_DUMMY+36)

/* New for V40. (BOOL) Indicate whether the object should
 * immediately begin playing.  Defaults to FALSE.
 */
NATIVE {DTA_Immediate}		CONST DTA_IMMEDIATE		= (DTA_DUMMY+37)

/* New for V40. (BOOL) Indicate that the object should repeat
 * playing.  Defaults to FALSE.
 */
NATIVE {DTA_Repeat}		CONST DTA_REPEAT		= (DTA_DUMMY+38)

/* New for V44. Address of a DTST_MEMORY source type
 * object (APTR).
 */
NATIVE {DTA_SourceAddress}	CONST DTA_SOURCEADDRESS	= (DTA_DUMMY+39)

/* New for V44. Size of a DTST_MEMORY source type
 * object (ULONG).
 */
NATIVE {DTA_SourceSize}		CONST DTA_SOURCESIZE		= (DTA_DUMMY+40)

/* Reserved tag; DO NOT USE (V44) */
NATIVE {DTA_Reserved}		CONST DTA_RESERVED		= (DTA_DUMMY+41)

/* DTObject attributes */
NATIVE {DTA_Name}		CONST DTA_NAME		= (DTA_DUMMY+100)
NATIVE {DTA_SourceType}		CONST DTA_SOURCETYPE		= (DTA_DUMMY+101)
NATIVE {DTA_Handle}		CONST DTA_HANDLE		= (DTA_DUMMY+102)
NATIVE {DTA_DataType}		CONST DTA_DATATYPE		= (DTA_DUMMY+103)
NATIVE {DTA_Domain}		CONST DTA_DOMAIN		= (DTA_DUMMY+104)

/* DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> */
NATIVE {DTA_Left}		CONST DTA_LEFT		= (DTA_DUMMY+105)
NATIVE {DTA_Top}			CONST DTA_TOP			= (DTA_DUMMY+106)
NATIVE {DTA_Width}		CONST DTA_WIDTH		= (DTA_DUMMY+107)
NATIVE {DTA_Height}		CONST DTA_HEIGHT		= (DTA_DUMMY+108)

NATIVE {DTA_ObjName}		CONST DTA_OBJNAME		= (DTA_DUMMY+109)
NATIVE {DTA_ObjAuthor}		CONST DTA_OBJAUTHOR		= (DTA_DUMMY+110)
NATIVE {DTA_ObjAnnotation}	CONST DTA_OBJANNOTATION	= (DTA_DUMMY+111)
NATIVE {DTA_ObjCopyright}	CONST DTA_OBJCOPYRIGHT	= (DTA_DUMMY+112)
NATIVE {DTA_ObjVersion}		CONST DTA_OBJVERSION		= (DTA_DUMMY+113)
NATIVE {DTA_ObjectID}		CONST DTA_OBJECTID		= (DTA_DUMMY+114)
NATIVE {DTA_UserData}		CONST DTA_USERDATA		= (DTA_DUMMY+115)
NATIVE {DTA_FrameInfo}		CONST DTA_FRAMEINFO		= (DTA_DUMMY+116)

/* DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> */
NATIVE {DTA_RelRight}		CONST DTA_RELRIGHT		= (DTA_DUMMY+117)
NATIVE {DTA_RelBottom}		CONST DTA_RELBOTTOM		= (DTA_DUMMY+118)
NATIVE {DTA_RelWidth}		CONST DTA_RELWIDTH		= (DTA_DUMMY+119)
NATIVE {DTA_RelHeight}		CONST DTA_RELHEIGHT		= (DTA_DUMMY+120)

NATIVE {DTA_SelectDomain}	CONST DTA_SELECTDOMAIN	= (DTA_DUMMY+121)
NATIVE {DTA_TotalPVert}		CONST DTA_TOTALPVERT		= (DTA_DUMMY+122)
NATIVE {DTA_TotalPHoriz}		CONST DTA_TOTALPHORIZ		= (DTA_DUMMY+123)
NATIVE {DTA_NominalVert}		CONST DTA_NOMINALVERT		= (DTA_DUMMY+124)
NATIVE {DTA_NominalHoriz}	CONST DTA_NOMINALHORIZ	= (DTA_DUMMY+125)

/* Printing attributes */

/* (LONG) Destination X width */
NATIVE {DTA_DestCols}		CONST DTA_DESTCOLS		= (DTA_DUMMY+400)

/* (LONG) Destination Y height */
NATIVE {DTA_DestRows}		CONST DTA_DESTROWS		= (DTA_DUMMY+401)

/* (UWORD) Option flags */
NATIVE {DTA_Special}		CONST DTA_SPECIAL		= (DTA_DUMMY+402)

/* (struct RastPort *) RastPort to use when printing. (V40) */
NATIVE {DTA_RastPort}		CONST DTA_RASTPORT		= (DTA_DUMMY+403)

/* (STRPTR) Pointer to base name for ARexx port (V40) */
NATIVE {DTA_ARexxPortName}	CONST DTA_AREXXPORTNAME	= (DTA_DUMMY+404)


/*****************************************************************************/

NATIVE {DTST_RAM}		CONST DTST_RAM		= 1
NATIVE {DTST_FILE}		CONST DTST_FILE		= 2
NATIVE {DTST_CLIPBOARD}		CONST DTST_CLIPBOARD		= 3
NATIVE {DTST_HOTLINK}		CONST DTST_HOTLINK		= 4
NATIVE {DTST_MEMORY}		CONST DTST_MEMORY		= 5	/* New for V44 */

/*****************************************************************************/

/* Attached to the Gadget.SpecialInfo field of the gadget.  Don't access directly,
 * use the Get/Set calls instead.
 */
NATIVE {DTSpecialInfo} OBJECT dtspecialinfo
    {si_Lock}	lock	:ss	/* Locked while in DoAsyncLayout() */
    {si_Flags}	flags	:ULONG

    {si_TopVert}	topvert	:VALUE	/* Top row (in units) */
    {si_VisVert}	visvert	:VALUE	/* Number of visible rows (in units) */
    {si_TotVert}	totvert	:VALUE	/* Total number of rows (in units) */
    {si_OTopVert}	otopvert	:VALUE	/* Previous top (in units) */
    {si_VertUnit}	vertunit	:VALUE	/* Number of pixels in vertical unit */

    {si_TopHoriz}	tophoriz	:VALUE	/* Top column (in units) */
    {si_VisHoriz}	vishoriz	:VALUE	/* Number of visible columns (in units) */
    {si_TotHoriz}	tothoriz	:VALUE	/* Total number of columns (in units) */
    {si_OTopHoriz}	otophoriz	:VALUE	/* Previous top (in units) */
    {si_HorizUnit}	horizunit	:VALUE	/* Number of pixels in horizontal unit */
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

NATIVE {DTMethod} OBJECT dtmethod
    {dtm_Label}	label	:/*STRPTR*/ ARRAY OF CHAR
    {dtm_Command}	command	:/*STRPTR*/ ARRAY OF CHAR
    {dtm_Method}	method	:ULONG
ENDOBJECT

/*****************************************************************************/

NATIVE {DTM_Dummy}		CONST DTM_DUMMY		= ($600)

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
NATIVE {FrameInfo} OBJECT frameinfo
    {fri_PropertyFlags}	propertyflags	:ULONG		/* DisplayInfo (graphics/displayinfo.h) */
    {fri_Resolution}	resolution	:tpoint		/* DisplayInfo */

    {fri_RedBits}	redbits	:UBYTE
    {fri_GreenBits}	greenbits	:UBYTE
    {fri_BlueBits}	bluebits	:UBYTE

	{fri_Dimensions.Width}	width	:ULONG
	{fri_Dimensions.Height}	height	:ULONG
	{fri_Dimensions.Depth}	depth	:ULONG

    {fri_Screen}	screen	:PTR TO screen
    {fri_ColorMap}	colormap	:PTR TO colormap

    {fri_Flags}	flags	:ULONG
ENDOBJECT

NATIVE {FIF_SCALABLE}	CONST FIF_SCALABLE	= $1
NATIVE {FIF_SCROLLABLE}	CONST FIF_SCROLLABLE	= $2
NATIVE {FIF_REMAPPABLE}	CONST FIF_REMAPPABLE	= $4

/* DTM_REMOVEDTOBJECT, DTM_CLEARSELECTED, DTM_COPY, DTM_ABORTPRINT */
NATIVE {dtGeneral} OBJECT dtgeneral
    {MethodID}	methodid	:ULONG
    {dtg_GInfo}	ginfo	:PTR TO gadgetinfo
ENDOBJECT

/* DTM_SELECT */
NATIVE {dtSelect} OBJECT dtselect
    {MethodID}	methodid	:ULONG
    {dts_GInfo}	ginfo	:PTR TO gadgetinfo
    {dts_Select}	select	:rectangle
ENDOBJECT

/* DTM_FRAMEBOX */
NATIVE {dtFrameBox} OBJECT dtframebox
    {MethodID}	methodid	:ULONG
    {dtf_GInfo}	ginfo	:PTR TO gadgetinfo
    {dtf_ContentsInfo}	contentsinfo	:PTR TO frameinfo	/* Input */
    {dtf_FrameInfo}	frameinfo	:PTR TO frameinfo		/* Output */
    {dtf_SizeFrameInfo}	sizeframeinfo	:ULONG
    {dtf_FrameFlags}	frameflags	:ULONG
ENDOBJECT

->#ifndef	FRAMEF_SPECIFY
->"CONST FRAMEF_SPECIFY" is on-purposely missing from here (it can be found in 'intuition/intuition_shared3')
->#endif

/* DTM_GOTO */
NATIVE {dtGoto} OBJECT dtgoto
    {MethodID}	methodid	:ULONG
    {dtg_GInfo}	ginfo	:PTR TO gadgetinfo
    {dtg_NodeName}	nodename	:/*STRPTR*/ ARRAY OF CHAR		/* Node to goto */
    {dtg_AttrList}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* DTM_TRIGGER */
NATIVE {dtTrigger} OBJECT dttrigger
    {MethodID}	methodid	:ULONG
    {dtt_GInfo}	ginfo	:PTR TO gadgetinfo
    {dtt_Function}	function	:ULONG
    {dtt_Data}	data	:APTR
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
NATIVE {printerIO} OBJECT printerio
    {ios}	ios	:iostd
    {iodrp}	iodrp	:iodrpreq
    {iopc}	iopc	:ioprtcmdreq
ENDOBJECT

/* DTM_PRINT */
NATIVE {dtPrint} OBJECT dtprint
    {MethodID}	methodid	:ULONG
    {dtp_GInfo}	ginfo	:PTR TO gadgetinfo		/* Gadget information */
    {dtp_PIO}	ios	:PTR TO printerio		/* Printer IO request */
    {dtp_AttrList}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* DTM_DRAW */
NATIVE {dtDraw} OBJECT dtdraw
    {MethodID}	methodid	:ULONG
    {dtd_RPort}	rport	:PTR TO rastport
    {dtd_Left}	left	:VALUE
    {dtd_Top}	top	:VALUE
    {dtd_Width}	width	:VALUE
    {dtd_Height}	height	:VALUE
    {dtd_TopHoriz}	tophoriz	:VALUE
    {dtd_TopVert}	topvert	:VALUE
    {dtd_AttrList}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* DTM_WRITE */
NATIVE {dtWrite} OBJECT dtwrite
    {MethodID}	methodid	:ULONG
    {dtw_GInfo}	ginfo	:PTR TO gadgetinfo		/* Gadget information */
    {dtw_FileHandle}	filehandle	:BPTR	/* File handle to write to */
    {dtw_Mode}	mode	:ULONG
    {dtw_AttrList}	attrlist	:ARRAY OF tagitem		/* Additional attributes */
ENDOBJECT

/* Save data as IFF data */
NATIVE {DTWM_IFF}	CONST DTWM_IFF	= 0

/* Save data as local data format */
NATIVE {DTWM_RAW}	CONST DTWM_RAW	= 1
