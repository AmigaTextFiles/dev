/* $VER: prtbase.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem',  'target/exec/devices',  'target/devices/parallel',  'target/devices/serial',  'target/devices/timer',  'target/dos/dosextens',  'target/intuition/intuition'
MODULE 'target/exec/libraries', 'target/exec/ports', 'target/exec/tasks', 'target/intuition/preferences', 'target/exec/types', 'target/dos/dos'
{MODULE 'devices/prtbase'}

/****************************************************************************/

NATIVE {devicedata} OBJECT devicedata
	{lib}	lib	:lib	/* standard library node */
	{segment}	segment	:APTR	/* A0 when initialized */
	{execbase}	execbase	:APTR	/* A6 for exec */
	{cmdvectors}	cmdvectors	:APTR	/* command table for device commands */
	{cmdbytes}	cmdbytes	:APTR	/* bytes describing which command queue */
	{numcommands}	numcommands	:UINT	/* the number of commands supported */
ENDOBJECT

/****************************************************************************/

/* IO Flags */
CONST IOB_QUEUED	= 4
CONST IOB_CURRENT	= 5
CONST IOB_SERVICING	= 6
CONST IOB_DONE	= 7

NATIVE {IOF_QUEUED}	CONST IOF_QUEUED	= 16
NATIVE {IOF_CURRENT}	CONST IOF_CURRENT	= 32
NATIVE {IOF_SERVICING}	CONST IOF_SERVICING	= 64
NATIVE {IOF_DONE}	CONST IOF_DONE	= 128

/* pd_Flags */
CONST PB_IOR0		= 0
CONST PB_IOR1		= 1
CONST PB_IOOPENED	= 2
CONST PB_EXPUNGED	= 7

NATIVE {PBF_IOR0}	CONST PF_IOR0	= 1
NATIVE {PBF_IOR1}	CONST PF_IOR1	= 2
NATIVE {PBF_IOOPENDED}	CONST PF_IOOPENDED	= 4
NATIVE {PBF_EXPUNGED}	CONST PF_EXPUNGED	= 128

/* du_Flags (actually placed in pd_Unit.mp_Node.ln_Pri) */
CONST DUB_STOPPED	= 0

NATIVE {DUF_STOPPED}	CONST DUF_STOPPED	= 1

NATIVE {P_OLDSTKSIZE}	CONST P_OLDSTKSIZE	= $0800	/* stack size for child task (OBSOLETE) */
NATIVE {P_STKSIZE}	CONST P_STKSIZE	= $1000	/* stack size for child task */
NATIVE {P_BUFSIZE}	CONST P_BUFSIZE	= 256	/* size of internal buffers for text i/o */
NATIVE {P_SAFESIZE}	CONST P_SAFESIZE	= 128	/* safety margin for text output buffer */

/****************************************************************************/

NATIVE {printerdata} OBJECT printerdata
	{dd}	dd	:devicedata

	/* PRIVATE & OBSOLETE: the one and only unit */
	{unit}	unit	:mp

	/* the printer specific segment */
	{printersegment}	printersegment	:BPTR

	/* the segment printer type */
	{printertype}	printertype	:UINT

	/* the segment data structure */
	{segmentdata}	segmentdata	:PTR TO printersegment

	/* the raster print buffer */
	{printbuf}	printbuf	:ARRAY OF UBYTE

	/* the write function:
	 */
	{pwrite}	pwrite	:PTR /*LONG (*pd_PWrite)()*/

	/* write function's done:
	 */
	{pbothready}	pbothready	:PTR /*LONG (*pd_PBothReady)()*/

	/* PRIVATE: port I/O request 0 */
	{p0}	p0	:ioextpar
	{s0}	s0	:ioextser

	/* PRIVATE:  and 1 for double buffering */
	{p1}	p1	:ioextpar
	{s1}	s1	:ioextser

	/* PRIVATE: timer I/O request */
	{tior}	tior	:timerequest

	/* PRIVATE: and message reply port */
	{iorport}	iorport	:mp

	/* PRIVATE: write task */
	{tc}	tc	:tc

	/* PRIVATE: and stack space (OBSOLETE) */
	{oldstk}	oldstk[P_OLDSTKSIZE]	:ARRAY OF UBYTE

	/* PRIVATE: device flags */
	{flags}	flags	:UBYTE

	/* PRIVATE: padding */
	{pad}	pad	:UBYTE

	/* the latest preferences */
	{preferences}	preferences	:preferences

	/* PRIVATE: wait function switch */
	{pwaitenabled}	pwaitenabled	:UBYTE

	/**************************************************************
	 *
	 * New fields for V2.0:
	 *
	 *************************************************************/

	/* PRIVATE: padding */
	{pad1}	flags1	:UBYTE

	/* PRIVATE: stack space (OBSOLETE) */
	{stk}	stk[P_STKSIZE]	:ARRAY OF UBYTE

	/**************************************************************
	 *
	 *  New fields for V3.5 (V44):
	 *
	 *************************************************************/

	/* PRIVATE: the Unit. pd_Unit is obsolete */
->	{punit}	punit	:PTR ->#TO PrinterUnit

	/* the read function:
	 */
->	{pread}	pread	:PTR /*LONG (*pd_PRead)()*/

	/* call application's error hook:
	 */
->	{callerrhook}	callerrhook	:PTR /*LONG (*pd_CallErrHook)()*/

	/* unit number */
->	{unitnumber}	unitnumber	:ULONG

	/* name of loaded driver */
->	{drivername}	drivername	:ARRAY OF CHAR /*STRPTR*/

	/* the query function:
	 */
->	{pquery}	pquery	:PTR /*LONG (*pd_PQuery)()*/
ENDOBJECT

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

CONST PPCB_EXTENDED	= 2	/* extended PED structure (V44) */
CONST PPCF_EXTENDED	= $4

CONST PPCB_NOSTRIP	= 3	/* no strip printing, please */
CONST PPCF_NOSTRIP	= $8

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

NATIVE {PCC_MULTI_PASS}	CONST PCC_MULTI_PASS	= $10	/* see explanation above */

/****************************************************************************/

NATIVE {printerextendeddata} OBJECT printerextendeddata
	/* printer name, null terminated */
	{printername}	printername	:ARRAY OF CHAR

	/* called after LoadSeg:
	 */
	{init}	init	:PTR /*VOID (*ped_Init)()*/

	/* called before UnLoadSeg:
	 */
	{expunge}	expunge	:PTR /*VOID (*ped_Expunge)()*/

	/* called at OpenDevice:
	 */
	{open}	open	:PTR /*LONG (*ped_Open)()*/

	/* called at CloseDevice:
	 */
	{close}	close	:PTR /*VOID (*ped_Close)()*/

	/* printer class */
	{printerclass}	printerclass	:UBYTE

	/* color class */
	{colorclass}	colorclass	:UBYTE

	/* number of print columns available */
	{maxcolumns}	maxcolumns	:UBYTE

	/* number of character sets */
	{numcharsets}	numcharsets	:UBYTE

	/* number of 'pins' in print head */
	{numrows}	numrows	:UINT

	/* number of dots max in a raster dump */
	{maxxdots}	maxxdots	:ULONG

	/* number of dots max in a raster dump */
	{maxydots}	maxydots	:ULONG

	/* horizontal dot density */
	{xdotsinch}	xdotsinch	:UINT

	/* vertical dot density */
	{ydotsinch}	ydotsinch	:UINT

	/* printer text command table */
	{commands}	commands	:ARRAY OF ARRAY OF ARRAY /*OF CHAR /*STRPTR*/*/

	/* special command handler:
	 */
	{dospecial}	dospecial	:PTR /*LONG (*ped_DoSpecial)()*/

	/* raster render function:
	 */
	{render}	render	:PTR /*LONG (*ped_Render)()*/

	/* good write timeout */
	{timeoutsecs}	timeoutsecs	:VALUE

	/**************************************************************
	 *
	 * The following only exists if the segment version is >= 33:
	 *
	 *************************************************************/

	/* Conversion strings for the extended font */
	{x8bitchars}	x8bitchars	:ARRAY OF ARRAY OF CHAR /*STRPTR*/

	/* Set if text printed, otherwise 0 */
	{printmode}	printmode	:VALUE

	/**************************************************************
	 *
	 * The following only exists if the segment version is >= 34:
	 *
	 *************************************************************/

	/* ptr to conversion function for all chars:
	 */
	{convfunc}	convfunv	:PTR /*LONG (*ped_ConvFunc)()*/

	/**************************************************************
	 *
	 * The following only exists if the segment version is >= 44
	 * AND PPCB_EXTENDED is set in ped_PrinterClass:
	 *
	 *************************************************************/

	/* Attributes and features */
->	{taglist}	taglist	:ARRAY OF tagitem

	/* driver specific preferences:
	 */
->	{dopreferences}	dopreferences	:PTR /*LONG (*ped_DoPreferences)()*/

	/* custom error handling:
	 */
->	{callerrhook}	callerrhook	:PTR /*VOID (*ped_CallErrHook)()*/
ENDOBJECT

/****************************************************************************/

/* The following tags are used to define more printer driver features */

->CONST PRTA_DUMMY = (TAG_USER + $50000)

/****************************************************************************/

/* V44 features */
->NATIVE {PRTA_8BITGUNS}		CONST PRTA_8BITGUNS		= (PRTA_DUMMY + 1) /* LBOOL */
->NATIVE {PRTA_CONVERTSOURCE}	CONST PRTA_CONVERTSOURCE	= (PRTA_DUMMY + 2) /* LBOOL */
->NATIVE {PRTA_FLOYDDITHERING}	CONST PRTA_FLOYDDITHERING	= (PRTA_DUMMY + 3) /* LBOOL */
->NATIVE {PRTA_ANTIALIAS}		CONST PRTA_ANTIALIAS		= (PRTA_DUMMY + 4) /* LBOOL */
->NATIVE {PRTA_COLORCORRECTION}	CONST PRTA_COLORCORRECTION	= (PRTA_DUMMY + 5) /* LBOOL */
->NATIVE {PRTA_NOIO}		CONST PRTA_NOIO		= (PRTA_DUMMY + 6) /* LBOOL */
->NATIVE {PRTA_NEWCOLOR}		CONST PRTA_NEWCOLOR		= (PRTA_DUMMY + 7) /* LBOOL */
->NATIVE {PRTA_COLORSIZE}		CONST PRTA_COLORSIZE		= (PRTA_DUMMY + 8) /* LONG */
->NATIVE {PRTA_NOSCALING}		CONST PRTA_NOSCALING		= (PRTA_DUMMY + 9) /* LBOOL */

/* User interface */
->NATIVE {PRTA_DITHERNAMES}	CONST PRTA_DITHERNAMES	= (PRTA_DUMMY + 20) /* STRPTR * */
->NATIVE {PRTA_SHADINGNAMES}	CONST PRTA_SHADINGNAMES	= (PRTA_DUMMY + 21) /* STRPTR * */
->NATIVE {PRTA_COLORCORRECT}	CONST PRTA_COLORCORRECT	= (PRTA_DUMMY + 22) /* LBOOL */
->NATIVE {PRTA_DENSITYINFO}	CONST PRTA_DENSITYINFO	= (PRTA_DUMMY + 23) /* STRPTR * */

/* Hardware page borders */
->NATIVE {PRTA_LEFTBORDER}		CONST PRTA_LEFTBORDER		= (PRTA_DUMMY + 30) /* LONG, inches/1000 */
->NATIVE {PRTA_TOPBORDER}		CONST PRTA_TOPBORDER		= (PRTA_DUMMY + 31) /* LONG, inches/1000 */

->NATIVE {PRTA_MIXBWCOLOR}		CONST PRTA_MIXBWCOLOR		= (PRTA_DUMMY + 32) /* LBOOL */

/* Driver Preferences */
->NATIVE {PRTA_PREFERENCES}	CONST PRTA_PREFERENCES	= (PRTA_DUMMY + 40) /* LBOOL */

/****************************************************************************/

NATIVE {printersegment} OBJECT printersegment
	{nextsegment}	nextsegment	:BPTR
	{runalert}	runalert	:ULONG	/* MOVEQ #0,D0 : RTS */
	{version}	version	:UINT	/* segment version */
	{revision}	revision	:UINT	/* segment revision */
	{ped}	ped	:printerextendeddata		/* printer extended data */
ENDOBJECT

/****************************************************************************/

NATIVE {prtdriverpreferences} OBJECT prtdriverpreferences
	{version}	version	:UINT				/* PRIVATE! driver specific version */
	{printerid}	printerid[32]	:ARRAY OF UBYTE			/* PRIVATE! driver specific id */
	{prefname}	prefname[FILENAME_SIZE-16]	:ARRAY OF CHAR
	{length}	length	:ULONG				/* size of this structure */

	/* .. more driver private fields follow .. */
ENDOBJECT
