/* $VER: prtbase.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem',  'target/exec/devices',  'target/devices/parallel',  'target/devices/serial',  'target/devices/timer',  'target/dos/dosextens',  'target/intuition/intuition'
MODULE 'target/exec/libraries', 'target/exec/ports', 'target/exec/tasks', 'target/intuition/preferences', 'target/exec/types', 'target/dos/dos'
{#include <devices/prtbase.h>}
NATIVE {DEVICES_PRTBASE_H} CONST

/****************************************************************************/

NATIVE {DeviceData} OBJECT devicedata
	{dd_Device}	lib	:lib	/* standard library node */
	{dd_Segment}	segment	:APTR	/* A0 when initialized */
	{dd_ExecBase}	execbase	:APTR	/* A6 for exec */
	{dd_CmdVectors}	cmdvectors	:APTR	/* command table for device commands */
	{dd_CmdBytes}	cmdbytes	:APTR	/* bytes describing which command queue */
	{dd_NumCommands}	numcommands	:UINT	/* the number of commands supported */
ENDOBJECT

/****************************************************************************/

/* IO Flags */
NATIVE {IOB_QUEUED}	CONST IOB_QUEUED	= 4
NATIVE {IOB_CURRENT}	CONST IOB_CURRENT	= 5
NATIVE {IOB_SERVICING}	CONST IOB_SERVICING	= 6
NATIVE {IOB_DONE}	CONST IOB_DONE	= 7

NATIVE {IOF_QUEUED}	CONST IOF_QUEUED	= 16
NATIVE {IOF_CURRENT}	CONST IOF_CURRENT	= 32
NATIVE {IOF_SERVICING}	CONST IOF_SERVICING	= 64
NATIVE {IOF_DONE}	CONST IOF_DONE	= 128

/* pd_Flags */
NATIVE {PB_IOR0}		CONST PB_IOR0		= 0
NATIVE {PB_IOR1}		CONST PB_IOR1		= 1
NATIVE {PB_IOOPENED}	CONST PB_IOOPENED	= 2
NATIVE {PB_EXPUNGED}	CONST PB_EXPUNGED	= 7

NATIVE {PBF_IOR0}	CONST PF_IOR0	= 1
NATIVE {PBF_IOR1}	CONST PF_IOR1	= 2
NATIVE {PBF_IOOPENDED}	CONST PF_IOOPENDED	= 4
NATIVE {PBF_EXPUNGED}	CONST PF_EXPUNGED	= 128

/* du_Flags (actually placed in pd_Unit.mp_Node.ln_Pri) */
NATIVE {DUB_STOPPED}	CONST DUB_STOPPED	= 0

NATIVE {DUF_STOPPED}	CONST DUF_STOPPED	= 1

NATIVE {P_OLDSTKSIZE}	CONST P_OLDSTKSIZE	= $0800	/* stack size for child task (OBSOLETE) */
NATIVE {P_STKSIZE}	CONST P_STKSIZE	= $1000	/* stack size for child task */
NATIVE {P_BUFSIZE}	CONST P_BUFSIZE	= 256	/* size of internal buffers for text i/o */
NATIVE {P_SAFESIZE}	CONST P_SAFESIZE	= 128	/* safety margin for text output buffer */

/****************************************************************************/

/*
	"struct PrinterData" was a very bad concept in the old V1.0 days
	because it is both: the device and the unit.

	Starting with V44 PrinterData may be duplicated for many Units. But all
	new fields that are specific to the Unit  are now part of the new
	"struct PrinterUnit". Don't touch the private fields!

	A note on the function pointers in these data structure definitions:
	unless otherwise specified, all functions expect that their parameters
	are passed on the *stack* rather than in CPU registers. Every parameter
	must be passed a 32 bit long word, i.e. an "UWORD" will use the same
	stack space as an "ULONG".
*/

NATIVE {PrinterData} OBJECT printerdata
	{pd_Device}	dd	:devicedata

	/* PRIVATE & OBSOLETE: the one and only unit */
	{pd_Unit}	unit	:mp

	/* the printer specific segment */
	{pd_PrinterSegment}	printersegment	:BPTR

	/* the segment printer type */
	{pd_PrinterType}	printertype	:UINT

	/* the segment data structure */
	{pd_SegmentData}	segmentdata	:PTR TO printersegment

	/* the raster print buffer */
	{pd_PrintBuf}	printbuf	:ARRAY OF UBYTE

	/* the write function:
	 *
	 *	LONG PWrite(APTR data,
	 *	            LONG len);
	 */
	{pd_PWrite}	pwrite	:NATIVE {LONG (*)()} PTR

	/* write function's done:
	 *
	 *	LONG PBothReady(VOID);
	 */
	{pd_PBothReady}	pbothready	:NATIVE {LONG (*)()} PTR

	/* PRIVATE: port I/O request 0 */
	{pd_ior0.pd_p0}	p0	:ioextpar
	{pd_ior0.pd_s0}	s0	:ioextser

	/* PRIVATE:  and 1 for double buffering */
	{pd_ior1.pd_p1}	p1	:ioextpar
	{pd_ior1.pd_s1}	s1	:ioextser

	/* PRIVATE: timer I/O request */
	{pd_TIOR}	tior	:timerequest

	/* PRIVATE: and message reply port */
	{pd_IORPort}	iorport	:mp

	/* PRIVATE: write task */
	{pd_TC}	tc	:tc

	/* PRIVATE: and stack space (OBSOLETE) */
	{pd_OldStk}	oldstk[P_OLDSTKSIZE]	:ARRAY OF UBYTE

	/* PRIVATE: device flags */
	{pd_Flags}	flags	:UBYTE

	/* PRIVATE: padding */
	{pd_pad}	pad	:UBYTE

	/* the latest preferences */
	{pd_Preferences}	preferences	:preferences

	/* PRIVATE: wait function switch */
	{pd_PWaitEnabled}	pwaitenabled	:UBYTE

	/**************************************************************
	 *
	 * New fields for V2.0:
	 *
	 *************************************************************/

	/* PRIVATE: padding */
	{pd_Flags1}	flags1	:UBYTE

	/* PRIVATE: stack space (OBSOLETE) */
	{pd_Stk}	stk[P_STKSIZE]	:ARRAY OF UBYTE

	/**************************************************************
	 *
	 *  New fields for V3.5 (V44):
	 *
	 *************************************************************/

	/* PRIVATE: the Unit. pd_Unit is obsolete */
	{pd_PUnit}	punit	:PTR ->#TO PrinterUnit

	/* the read function:
	 *
	 *	LONG pd_PRead(char * buffer,
	 *	              LONG * length,
	 *	              struct timeval * tv);
	 */
	{pd_PRead}	pread	:NATIVE {LONG (*)()} PTR

	/* call application's error hook:
	 *
	 *	LONG pd_CallErrorHook(struct Hook * hook,
	 *	                      struct printerIO * ior,
	 *	                      struct PrtErrMsg * pem);
	 */
	{pd_CallErrHook}	callerrhook	:NATIVE {LONG (*)()} PTR

	/* unit number */
	{pd_UnitNumber}	unitnumber	:ULONG

	/* name of loaded driver */
	{pd_DriverName}	drivername	:ARRAY OF CHAR /*STRPTR*/

	/* the query function:
	 *
	 *	LONG pd_PQuery(LONG * numofchars);
	 */
	{pd_PQuery}	pquery	:NATIVE {LONG (*)()} PTR
ENDOBJECT

NATIVE {pd_PIOR0} DEF
NATIVE {pd_SIOR0} DEF

NATIVE {pd_PIOR1} DEF
NATIVE {pd_SIOR1} DEF

/****************************************************************************/

/* Printer Class */
NATIVE {PPCB_GFX}	CONST PPCB_GFX	= 0	/* graphics (bit position) */
NATIVE {PPCF_GFX}	CONST PPCF_GFX	= $1	/* graphics (and/or flag) */
NATIVE {PPCB_COLOR}	CONST PPCB_COLOR	= 1	/* color (bit position) */
NATIVE {PPCF_COLOR}	CONST PPCF_COLOR	= $2	/* color (and/or flag) */

NATIVE {PPC_BWALPHA}	CONST PPC_BWALPHA	= $00	/* black&white alphanumerics */
NATIVE {PPC_BWGFX}	CONST PPC_BWGFX	= $01	/* black&white graphics */
NATIVE {PPC_COLORALPHA}	CONST PPC_COLORALPHA	= $02	/* color alphanumerics */
NATIVE {PPC_COLORGFX}	CONST PPC_COLORGFX	= $03	/* color graphics */

NATIVE {PPCB_EXTENDED}	CONST PPCB_EXTENDED	= 2	/* extended PED structure (V44) */
NATIVE {PPCF_EXTENDED}	CONST PPCF_EXTENDED	= $4

/*
	Some printer drivers (PrinterPS) do not support
	strip printing. An application has to print a page
	using a single print request or through clever use
	of the PRD_DUMPRPORTTAGS printing callback hook.
*/
NATIVE {PPCB_NOSTRIP}	CONST PPCB_NOSTRIP	= 3	/* no strip printing, please */
NATIVE {PPCF_NOSTRIP}	CONST PPCF_NOSTRIP	= $8

/* Color Class */
NATIVE {PCC_BW}		CONST PCC_BW		= $01	/* black&white only */
NATIVE {PCC_YMC}		CONST PCC_YMC		= $02	/* yellow/magenta/cyan only */
NATIVE {PCC_YMC_BW}	CONST PCC_YMC_BW	= $03	/* yellow/magenta/cyan or black&white */
NATIVE {PCC_YMCB}	CONST PCC_YMCB	= $04	/* yellow/magenta/cyan/black */
NATIVE {PCC_4COLOR}	CONST PCC_4COLOR	= $04	/* a flag for YMCB and BGRW */
NATIVE {PCC_ADDITIVE}	CONST PCC_ADDITIVE	= $08	/* not ymcb but blue/green/red/white */
NATIVE {PCC_WB}		CONST PCC_WB		= $09	/* black&white only, 0 == BLACK */
NATIVE {PCC_BGR}		CONST PCC_BGR		= $0A	/* blue/green/red */
NATIVE {PCC_BGR_WB}	CONST PCC_BGR_WB	= $0B	/* blue/green/red or black&white */
NATIVE {PCC_BGRW}	CONST PCC_BGRW	= $0C	/* blue/green/red/white */

/*
	The picture must be scanned once for each color component, as the
	printer can only define one color at a time.  ie. If 'PCC_YMC' then
	first pass sends all 'Y' info to printer, second pass sends all 'M'
	info, and third pass sends all C info to printer.  The CalComp
	PlotMaster is an example of this type of printer.
*/
NATIVE {PCC_MULTI_PASS}	CONST PCC_MULTI_PASS	= $10	/* see explanation above */

/****************************************************************************/

NATIVE {PrinterExtendedData} OBJECT printerextendeddata
	/* printer name, null terminated */
	{ped_PrinterName}	printername	:ARRAY OF CHAR

	/* called after LoadSeg:
	 *
	 *	LONG ped_Init(struct PrinterData * pd);
	 */
	{ped_Init}	init	:NATIVE {VOID (*)()} PTR

	/* called before UnLoadSeg:
	 *
	 *	VOID ped_Expunge(VOID);
	 */
	{ped_Expunge}	expunge	:NATIVE {VOID (*)()} PTR

	/* called at OpenDevice:
	 *
	 *	LONG ped_Open(struct printerIO * ior);
	 */
	{ped_Open}	open	:NATIVE {LONG (*)()} PTR

	/* called at CloseDevice:
	 *
	 *	VOID ped_Close(struct printerIO * ior);
	 */
	{ped_Close}	close	:NATIVE {VOID (*)()} PTR

	/* printer class */
	{ped_PrinterClass}	printerclass	:UBYTE

	/* color class */
	{ped_ColorClass}	colorclass	:UBYTE

	/* number of print columns available */
	{ped_MaxColumns}	maxcolumns	:UBYTE

	/* number of character sets */
	{ped_NumCharSets}	numcharsets	:UBYTE

	/* number of 'pins' in print head */
	{ped_NumRows}	numrows	:UINT

	/* number of dots max in a raster dump */
	{ped_MaxXDots}	maxxdots	:ULONG

	/* number of dots max in a raster dump */
	{ped_MaxYDots}	maxydots	:ULONG

	/* horizontal dot density */
	{ped_XDotsInch}	xdotsinch	:UINT

	/* vertical dot density */
	{ped_YDotsInch}	ydotsinch	:UINT

	/* printer text command table */
	{ped_Commands}	commands	:ARRAY OF ARRAY OF ARRAY /*OF CHAR /*STRPTR*/*/

	/* special command handler:
	 *
	 *	LONG ped_DoSpecial(UWORD * command,
	 *	                   UBYTE output_buffer[],
	 *	                   BYTE * current_line_position,
	 *	                   BYTE * current_line_spacing,
	 *	                   BYTE * crlf_flag,
	 *	                   UBYTE params[]);
	 */
	{ped_DoSpecial}	dospecial	:NATIVE {LONG (*)()} PTR

	/* raster render function:
	 *
	 *	LONG ped_Render(LONG ct,LONG x,LONG y,LONG status);
	 */
	{ped_Render}	render	:NATIVE {LONG (*)()} PTR

	/* good write timeout */
	{ped_TimeoutSecs}	timeoutsecs	:VALUE

	/**************************************************************
	 *
	 * The following only exists if the segment version is >= 33:
	 *
	 *************************************************************/

	/* Conversion strings for the extended font */
	{ped_8BitChars}	x8bitchars	:ARRAY OF ARRAY OF CHAR /*STRPTR*/

	/* Set if text printed, otherwise 0 */
	{ped_PrintMode}	printmode	:VALUE

	/**************************************************************
	 *
	 * The following only exists if the segment version is >= 34:
	 *
	 *************************************************************/

	/* ptr to conversion function for all chars:
	 *
	 *	LONG ped_ConvFunc(UBYTE * buf,
	 *	                  UBYTE c,
	 *	                  LONG crlf_flag);
	 */
	{ped_ConvFunc}	convfunv	:NATIVE {LONG (*)()} PTR

	/**************************************************************
	 *
	 * The following only exists if the segment version is >= 44
	 * AND PPCB_EXTENDED is set in ped_PrinterClass:
	 *
	 *************************************************************/

	/* Attributes and features */
	{ped_TagList}	taglist	:ARRAY OF tagitem

	/* driver specific preferences:
	 *
	 *	LONG ped_DoPreferences(struct printerIO * ior,
	 *	                       LONG command);
	 */
	{ped_DoPreferences}	dopreferences	:NATIVE {LONG (*)()} PTR

	/* custom error handling:
	 *
	 *	VOID ped_CallErrHook(struct printerIO * ior,
	 *	                     struct Hook * hook);
	 */
	{ped_CallErrHook}	callerrhook	:NATIVE {VOID (*)()} PTR
ENDOBJECT

/****************************************************************************/

/* The following tags are used to define more printer driver features */

NATIVE {PRTA_Dummy} CONST PRTA_DUMMY = (TAG_USER + $50000)

/****************************************************************************/

/* V44 features */
NATIVE {PRTA_8BitGuns}		CONST PRTA_8BITGUNS		= (PRTA_DUMMY + 1) /* LBOOL */
NATIVE {PRTA_ConvertSource}	CONST PRTA_CONVERTSOURCE	= (PRTA_DUMMY + 2) /* LBOOL */
NATIVE {PRTA_FloydDithering}	CONST PRTA_FLOYDDITHERING	= (PRTA_DUMMY + 3) /* LBOOL */
NATIVE {PRTA_AntiAlias}		CONST PRTA_ANTIALIAS		= (PRTA_DUMMY + 4) /* LBOOL */
NATIVE {PRTA_ColorCorrection}	CONST PRTA_COLORCORRECTION	= (PRTA_DUMMY + 5) /* LBOOL */
NATIVE {PRTA_NoIO}		CONST PRTA_NOIO		= (PRTA_DUMMY + 6) /* LBOOL */
NATIVE {PRTA_NewColor}		CONST PRTA_NEWCOLOR		= (PRTA_DUMMY + 7) /* LBOOL */
NATIVE {PRTA_ColorSize}		CONST PRTA_COLORSIZE		= (PRTA_DUMMY + 8) /* LONG */
NATIVE {PRTA_NoScaling}		CONST PRTA_NOSCALING		= (PRTA_DUMMY + 9) /* LBOOL */

/* User interface */
NATIVE {PRTA_DitherNames}	CONST PRTA_DITHERNAMES	= (PRTA_DUMMY + 20) /* STRPTR * */
NATIVE {PRTA_ShadingNames}	CONST PRTA_SHADINGNAMES	= (PRTA_DUMMY + 21) /* STRPTR * */
NATIVE {PRTA_ColorCorrect}	CONST PRTA_COLORCORRECT	= (PRTA_DUMMY + 22) /* LBOOL */
NATIVE {PRTA_DensityInfo}	CONST PRTA_DENSITYINFO	= (PRTA_DUMMY + 23) /* STRPTR * */

/* Hardware page borders */
NATIVE {PRTA_LeftBorder}		CONST PRTA_LEFTBORDER		= (PRTA_DUMMY + 30) /* LONG, inches/1000 */
NATIVE {PRTA_TopBorder}		CONST PRTA_TOPBORDER		= (PRTA_DUMMY + 31) /* LONG, inches/1000 */

NATIVE {PRTA_MixBWColor}		CONST PRTA_MIXBWCOLOR		= (PRTA_DUMMY + 32) /* LBOOL */

/* Driver Preferences */
NATIVE {PRTA_Preferences}	CONST PRTA_PREFERENCES	= (PRTA_DUMMY + 40) /* LBOOL */

/****************************************************************************/

NATIVE {PrinterSegment} OBJECT printersegment
	{ps_NextSegment}	nextsegment	:BPTR
	{ps_runAlert}	runalert	:ULONG	/* MOVEQ #0,D0 : RTS */
	{ps_Version}	version	:UINT	/* segment version */
	{ps_Revision}	revision	:UINT	/* segment revision */
	{ps_PED}	ped	:printerextendeddata		/* printer extended data */
ENDOBJECT

/****************************************************************************/

/*
	Driver specific preferences. This structure is device specific: every
	driver must base its preferences structure on this to allow version
	checking etc.

	The application will read/write this structure as an I/O buffer.
*/
NATIVE {PrtDriverPreferences} OBJECT prtdriverpreferences
	{pdp_Version}	version	:UINT				/* PRIVATE! driver specific version */
	{pdp_PrinterID}	printerid[32]	:ARRAY OF UBYTE			/* PRIVATE! driver specific id */
	{pdp_PrefName}	prefname[FILENAME_SIZE-16]	:ARRAY OF CHAR
	{pdp_Length}	length	:ULONG				/* size of this structure */

	/* .. more driver private fields follow .. */
ENDOBJECT
