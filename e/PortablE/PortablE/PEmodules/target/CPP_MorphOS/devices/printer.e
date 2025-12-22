/* $VER: printer.h 44.1 (19.10.1999) */
OPT NATIVE, POINTER
MODULE 'target/exec/devices', 'target/intuition/intuition', 'target/utility/tagitem'
MODULE 'target/exec/io', 'target/utility/hooks', 'target/exec/ports', 'target/graphics/rastport', 'target/graphics/view', 'target/prefs/printertxt', 'target/prefs/printergfx', 'target/exec/types'
{#include <devices/printer.h>}
NATIVE {DEVICES_PRINTER_H} CONST

/****************************************************************************/

/* V34-V40 commands */
NATIVE {PRD_RAWWRITE}		CONST PRD_RAWWRITE		= (CMD_NONSTD+0)
NATIVE {PRD_PRTCOMMAND}		CONST PRD_PRTCOMMAND		= (CMD_NONSTD+1)
NATIVE {PRD_DUMPRPORT}		CONST PRD_DUMPRPORT		= (CMD_NONSTD+2)
NATIVE {PRD_QUERY}		CONST PRD_QUERY		= (CMD_NONSTD+3)

/* V44 commands */
NATIVE {PRD_RESETPREFS}		CONST PRD_RESETPREFS		= (CMD_NONSTD+4)	/* PRIVATE: do not use! */
NATIVE {PRD_LOADPREFS}		CONST PRD_LOADPREFS		= (CMD_NONSTD+5)	/* PRIVATE: do not use! */
NATIVE {PRD_USEPREFS}		CONST PRD_USEPREFS		= (CMD_NONSTD+6)	/* PRIVATE: do not use! */
NATIVE {PRD_SAVEPREFS}		CONST PRD_SAVEPREFS		= (CMD_NONSTD+7)	/* PRIVATE: do not use! */
NATIVE {PRD_READPREFS}		CONST PRD_READPREFS		= (CMD_NONSTD+8)
NATIVE {PRD_WRITEPREFS}		CONST PRD_WRITEPREFS		= (CMD_NONSTD+9)
NATIVE {PRD_EDITPREFS}		CONST PRD_EDITPREFS		= (CMD_NONSTD+10)
NATIVE {PRD_SETERRHOOK}		CONST PRD_SETERRHOOK		= (CMD_NONSTD+11)
NATIVE {PRD_DUMPRPORTTAGS}	CONST PRD_DUMPRPORTTAGS	= (CMD_NONSTD+12)

/****************************************************************************/

/* printer command definitions */

NATIVE {aRIS}	CONST ARIS	= 0	/* ESCc  reset                    ISO */
NATIVE {aRIN}	CONST ARIN	= 1	/* ESC#1 initialize               +++ */
NATIVE {aIND}	CONST AIND	= 2	/* ESCD  lf                       ISO */
NATIVE {aNEL}	CONST ANEL	= 3	/* ESCE  return,lf                ISO */
NATIVE {aRI}	CONST ARI	= 4	/* ESCM  reverse lf               ISO */

NATIVE {aSGR0}	CONST ASGR0	= 5	/* ESC[0m normal char set         ISO */
NATIVE {aSGR3}	CONST ASGR3	= 6	/* ESC[3m italics on              ISO */
NATIVE {aSGR23}	CONST ASGR23	= 7	/* ESC[23m italics off            ISO */
NATIVE {aSGR4}	CONST ASGR4	= 8	/* ESC[4m underline on            ISO */
NATIVE {aSGR24}	CONST ASGR24	= 9	/* ESC[24m underline off          ISO */
NATIVE {aSGR1}	CONST ASGR1	= 10	/* ESC[1m boldface on             ISO */
NATIVE {aSGR22}	CONST ASGR22	= 11	/* ESC[22m boldface off           ISO */
NATIVE {aSFC}	CONST ASFC	= 12	/* SGR30-39  set foreground color ISO */
NATIVE {aSBC}	CONST ASBC	= 13	/* SGR40-49  set background color ISO */

NATIVE {aSHORP0}	CONST ASHORP0	= 14	/* ESC[0w normal pitch            DEC */
NATIVE {aSHORP2}	CONST ASHORP2	= 15	/* ESC[2w elite on                DEC */
NATIVE {aSHORP1}	CONST ASHORP1	= 16	/* ESC[1w elite off               DEC */
NATIVE {aSHORP4}	CONST ASHORP4	= 17	/* ESC[4w condensed fine on       DEC */
NATIVE {aSHORP3}	CONST ASHORP3	= 18	/* ESC[3w condensed off           DEC */
NATIVE {aSHORP6}	CONST ASHORP6	= 19	/* ESC[6w enlarged on             DEC */
NATIVE {aSHORP5}	CONST ASHORP5	= 20	/* ESC[5w enlarged off            DEC */

NATIVE {aDEN6}	CONST ADEN6	= 21	/* ESC[6"z shadow print on        DEC (sort of) */
NATIVE {aDEN5}	CONST ADEN5	= 22	/* ESC[5"z shadow print off       DEC */
NATIVE {aDEN4}	CONST ADEN4	= 23	/* ESC[4"z doublestrike on        DEC */
NATIVE {aDEN3}	CONST ADEN3	= 24	/* ESC[3"z doublestrike off       DEC */
NATIVE {aDEN2}	CONST ADEN2	= 25	/* ESC[2"z  NLQ on                DEC */
NATIVE {aDEN1}	CONST ADEN1	= 26	/* ESC[1"z  NLQ off               DEC */

NATIVE {aSUS2}	CONST ASUS2	= 27	/* ESC[2v superscript on          +++ */
NATIVE {aSUS1}	CONST ASUS1	= 28	/* ESC[1v superscript off         +++ */
NATIVE {aSUS4}	CONST ASUS4	= 29	/* ESC[4v subscript on            +++ */
NATIVE {aSUS3}	CONST ASUS3	= 30	/* ESC[3v subscript off           +++ */
NATIVE {aSUS0}	CONST ASUS0	= 31	/* ESC[0v normalize the line      +++ */
NATIVE {aPLU}	CONST APLU	= 32	/* ESCL  partial line up          ISO */
NATIVE {aPLD}	CONST APLD	= 33	/* ESCK  partial line down        ISO */

NATIVE {aFNT0}	CONST AFNT0	= 34	/* ESC(B US char set        or Typeface  0 (default) */
NATIVE {aFNT1}	CONST AFNT1	= 35	/* ESC(R French char set    or Typeface  1 */
NATIVE {aFNT2}	CONST AFNT2	= 36	/* ESC(K German char set    or Typeface  2 */
NATIVE {aFNT3}	CONST AFNT3	= 37	/* ESC(A UK char set        or Typeface  3 */
NATIVE {aFNT4}	CONST AFNT4	= 38	/* ESC(E Danish I char set  or Typeface  4 */
NATIVE {aFNT5}	CONST AFNT5	= 39	/* ESC(H Sweden char set    or Typeface  5 */
NATIVE {aFNT6}	CONST AFNT6	= 40	/* ESC(Y Italian char set   or Typeface  6 */
NATIVE {aFNT7}	CONST AFNT7	= 41	/* ESC(Z Spanish char set   or Typeface  7 */
NATIVE {aFNT8}	CONST AFNT8	= 42	/* ESC(J Japanese char set  or Typeface  8 */
NATIVE {aFNT9}	CONST AFNT9	= 43	/* ESC(6 Norweign char set  or Typeface  9 */
NATIVE {aFNT10}	CONST AFNT10	= 44	/* ESC(C Danish II char set or Typeface 10 */

/*
	Suggested typefaces are:

	 0 - default typeface.
	 1 - Line Printer or equiv.
	 2 - Pica or equiv.
	 3 - Elite or equiv.
	 4 - Helvetica or equiv.
	 5 - Times Roman or equiv.
	 6 - Gothic or equiv.
	 7 - Script or equiv.
	 8 - Prestige or equiv.
	 9 - Caslon or equiv.
	10 - Orator or equiv.
*/

NATIVE {aPROP2}	CONST APROP2	= 45	/* ESC[2p  proportional on        +++ */
NATIVE {aPROP1}	CONST APROP1	= 46	/* ESC[1p  proportional off       +++ */
NATIVE {aPROP0}	CONST APROP0	= 47	/* ESC[0p  proportional clear     +++ */
NATIVE {aTSS}	CONST ATSS	= 48	/* ESC[n E set proportional offset ISO */
NATIVE {aJFY5}	CONST AJFY5	= 49	/* ESC[5 F auto left justify      ISO */
NATIVE {aJFY7}	CONST AJFY7	= 50	/* ESC[7 F auto right justify     ISO */
NATIVE {aJFY6}	CONST AJFY6	= 51	/* ESC[6 F auto full justify      ISO */
NATIVE {aJFY0}	CONST AJFY0	= 52	/* ESC[0 F auto justify off       ISO */
NATIVE {aJFY3}	CONST AJFY3	= 53	/* ESC[3 F letter space (justify) ISO (special) */
NATIVE {aJFY1}	CONST AJFY1	= 54	/* ESC[1 F word fill(auto center) ISO (special) */

NATIVE {aVERP0}	CONST AVERP0	= 55	/* ESC[0z  1/8" line spacing      +++ */
NATIVE {aVERP1}	CONST AVERP1	= 56	/* ESC[1z  1/6" line spacing      +++ */
NATIVE {aSLPP}	CONST ASLPP	= 57	/* ESC[nt  set form length n      DEC */
NATIVE {aPERF}	CONST APERF	= 58	/* ESC[nq  perf skip n (n>0)      +++ */
NATIVE {aPERF0}	CONST APERF0	= 59	/* ESC[0q  perf skip off          +++ */

NATIVE {aLMS}	CONST ALMS	= 60	/* ESC#9   Left margin set        +++ */
NATIVE {aRMS}	CONST ARMS	= 61	/* ESC#0   Right margin set       +++ */
NATIVE {aTMS}	CONST ATMS	= 62	/* ESC#8   Top margin set         +++ */
NATIVE {aBMS}	CONST ABMS	= 63	/* ESC#2   Bottom marg set        +++ */
NATIVE {aSTBM}	CONST ASTBM	= 64	/* ESC[Pn1;Pn2r  T&B margins      DEC */
NATIVE {aSLRM}	CONST ASLRM	= 65	/* ESC[Pn1;Pn2s  L&R margin       DEC */
NATIVE {aCAM}	CONST ACAM	= 66	/* ESC#3   Clear margins          +++ */

NATIVE {aHTS}	CONST AHTS	= 67	/* ESCH    Set horiz tab          ISO */
NATIVE {aVTS}	CONST AVTS	= 68	/* ESCJ    Set vertical tabs      ISO */
NATIVE {aTBC0}	CONST ATBC0	= 69	/* ESC[0g  Clr horiz tab          ISO */
NATIVE {aTBC3}	CONST ATBC3	= 70	/* ESC[3g  Clear all h tab        ISO */
NATIVE {aTBC1}	CONST ATBC1	= 71	/* ESC[1g  Clr vertical tabs      ISO */
NATIVE {aTBC4}	CONST ATBC4	= 72	/* ESC[4g  Clr all v tabs         ISO */
NATIVE {aTBCALL}	CONST ATBCALL	= 73	/* ESC#4   Clr all h & v tabs     +++ */
NATIVE {aTBSALL}	CONST ATBSALL	= 74	/* ESC#5   Set default tabs       +++ */
NATIVE {aEXTEND}	CONST AEXTEND	= 75	/* ESC[Pn"x extended commands     +++ */

NATIVE {aRAW}	CONST ARAW	= 76	/*	ESC[Pn"r	Next	'Pn' chars are raw +++ */

/****************************************************************************/

/* For PRD_PRTCOMMAND */
NATIVE {IOPrtCmdReq} OBJECT ioprtcmdreq
	{io_Message}	mn	:mn
	{io_Device}	device	:PTR TO dd	/* device node pointer  */
	{io_Unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io_Command}	command	:UINT	/* device command */
	{io_Flags}	flags	:UBYTE
	{io_Error}	error	:BYTE	/* error or warning num */
->#the above members were represented by an "io" object in AmigaE
	{io_PrtCommand}	prtcommand	:UINT	/* printer command */
	{io_Parm0}	parm0	:UBYTE	/* first command parameter */
	{io_Parm1}	parm1	:UBYTE	/* second command parameter */
	{io_Parm2}	parm2	:UBYTE	/* third command parameter */
	{io_Parm3}	parm3	:UBYTE	/* fourth command parameter */
ENDOBJECT

/****************************************************************************/

/* For PRD_DUMPRPORT */
NATIVE {IODRPReq} OBJECT iodrpreq
	{io_Message}	mn	:mn
	{io_Device}	device	:PTR TO dd	/* device node pointer  */
	{io_Unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io_Command}	command	:UINT	/* device command */
	{io_Flags}	flags	:UBYTE
	{io_Error}	error	:BYTE	/* error or warning num */
->#the above members were represented by an "io" object in AmigaE
	{io_RastPort}	rastport	:PTR TO rastport	/* raster port */
	{io_ColorMap}	colormap	:PTR TO colormap	/* color map */
	{io_Modes}	modes	:ULONG	/* graphics viewport modes */
	{io_SrcX}	srcx	:UINT	/* source x origin */
	{io_SrcY}	srcy	:UINT	/* source y origin */
	{io_SrcWidth}	srcwidth	:UINT	/* source x width */
	{io_SrcHeight}	srcheight	:UINT	/* source x height */
	{io_DestCols}	destcols	:VALUE	/* destination x width */
	{io_DestRows}	destrows	:VALUE	/* destination y height */
	{io_Special}	special	:UINT	/* option flags */
ENDOBJECT

/****************************************************************************/

/* For PRD_DUMPRPORTTAGS (V44) */
NATIVE {IODRPTagsReq} OBJECT iodrptagsreq
	{io_Message}	mn	:mn
	{io_Device}	device	:PTR TO dd	/* device node pointer  */
	{io_Unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io_Command}	command	:UINT	/* device command */
	{io_Flags}	flags	:UBYTE
	{io_Error}	error	:BYTE	/* error or warning num */
	{io_RastPort}	rastport	:PTR TO rastport	/* raster port */
	{io_ColorMap}	colormap	:PTR TO colormap	/* color map */
	{io_Modes}	modes	:ULONG	/* graphics viewport modes */
	{io_SrcX}	srcx	:UINT	/* source x origin */
	{io_SrcY}	srcy	:UINT	/* source y origin */
	{io_SrcWidth}	srcwidth	:UINT	/* source x width */
	{io_SrcHeight}	srcheight	:UINT	/* source x height */
	{io_DestCols}	destcols	:VALUE	/* destination x width */
	{io_DestRows}	destrows	:VALUE	/* destination y height */
	{io_Special}	special	:UINT	/* option flags */
	{io_TagList}	taglist	:ARRAY OF tagitem	/* tag list with additional info */
ENDOBJECT

/****************************************************************************/

NATIVE {SPECIAL_MILCOLS}		CONST SPECIAL_MILCOLS		= $0001	/* DestCols specified in 1/1000" */
NATIVE {SPECIAL_MILROWS}		CONST SPECIAL_MILROWS		= $0002	/* DestRows specified in 1/1000" */
NATIVE {SPECIAL_FULLCOLS}	CONST SPECIAL_FULLCOLS	= $0004	/* make DestCols maximum possible */
NATIVE {SPECIAL_FULLROWS}	CONST SPECIAL_FULLROWS	= $0008	/* make DestRows maximum possible */
NATIVE {SPECIAL_FRACCOLS}	CONST SPECIAL_FRACCOLS	= $0010	/* DestCols is fraction of FULLCOLS */
NATIVE {SPECIAL_FRACROWS}	CONST SPECIAL_FRACROWS	= $0020	/* DestRows is fraction of FULLROWS */
NATIVE {SPECIAL_CENTER}		CONST SPECIAL_CENTER		= $0040	/* center image on paper */
NATIVE {SPECIAL_ASPECT}		CONST SPECIAL_ASPECT		= $0080	/* ensure correct aspect ratio */
NATIVE {SPECIAL_DENSITY1}	CONST SPECIAL_DENSITY1	= $0100	/* lowest resolution (dpi) */
NATIVE {SPECIAL_DENSITY2}	CONST SPECIAL_DENSITY2	= $0200	/* next res */
NATIVE {SPECIAL_DENSITY3}	CONST SPECIAL_DENSITY3	= $0300	/* next res */
NATIVE {SPECIAL_DENSITY4}	CONST SPECIAL_DENSITY4	= $0400	/* next res */
NATIVE {SPECIAL_DENSITY5}	CONST SPECIAL_DENSITY5	= $0500	/* next res */
NATIVE {SPECIAL_DENSITY6}	CONST SPECIAL_DENSITY6	= $0600	/* next res */
NATIVE {SPECIAL_DENSITY7}	CONST SPECIAL_DENSITY7	= $0700	/* highest res */
NATIVE {SPECIAL_NOFORMFEED}	CONST SPECIAL_NOFORMFEED	= $0800	/* don't eject paper on gfx prints */
NATIVE {SPECIAL_TRUSTME}		CONST SPECIAL_TRUSTME		= $1000	/* don't reset on gfx prints */

/*
	Compute print size, set 'io_DestCols' and 'io_DestRows' in the calling
	program's 'IODRPReq' structure and exit, DON'T PRINT.  This allows the
	calling program to see what the final print size would be in printer
	pixels.  Note that it modifies the 'io_DestCols' and 'io_DestRows'
	fields of your 'IODRPReq' structure.  Also, set the print density and
	update the 'MaxXDots', 'MaxYDots', 'XDotsInch', and 'YDotsInch' fields
	of the 'PrinterExtendedData' structure.
*/
NATIVE {SPECIAL_NOPRINT}		CONST SPECIAL_NOPRINT		= $2000	/* see above */

/****************************************************************************/

NATIVE {PDERR_NOERR}		CONST PDERR_NOERR		= 0	/* clean exit, no errors */
NATIVE {PDERR_CANCEL}		CONST PDERR_CANCEL		= 1	/* user cancelled print */
NATIVE {PDERR_NOTGRAPHICS}	CONST PDERR_NOTGRAPHICS	= 2	/* printer cannot output graphics */
NATIVE {PDERR_INVERTHAM}		CONST PDERR_INVERTHAM		= 3	/* OBSOLETE */
NATIVE {PDERR_BADDIMENSION}	CONST PDERR_BADDIMENSION	= 4	/* print dimensions illegal */
NATIVE {PDERR_DIMENSIONOVFLOW}	CONST PDERR_DIMENSIONOVFLOW	= 5	/* OBSOLETE */
NATIVE {PDERR_INTERNALMEMORY}	CONST PDERR_INTERNALMEMORY	= 6	/* no memory for internal variables */
NATIVE {PDERR_BUFFERMEMORY}	CONST PDERR_BUFFERMEMORY	= 7	/* no memory for print buffer */

/*
	Note : this is an internal error that can be returned from the render
	function to the printer device.  It is NEVER returned to the user.
	If the printer device sees this error it converts it 'PDERR_NOERR'
	and exits gracefully.  Refer to the document on
	'How to Write a Graphics Printer Driver' for more info.
*/
NATIVE {PDERR_TOOKCONTROL}	CONST PDERR_TOOKCONTROL	= 8	/* Took control in case 0 of render */

NATIVE {PDERR_BADPREFERENCES}	CONST PDERR_BADPREFERENCES	= 9	/* preferences file corrupt */

/*
	Note: all error codes < 32 are reserved for printer.device.
	All error codes >= 32 and < 127 are reserved for driver specific
	errors. Negative errors are reserved for system use (standard I/O
	errors) and error code 127 is reserved for future expansion.
*/
NATIVE {PDERR_LASTSTANDARD}	CONST PDERR_LASTSTANDARD	= 31
NATIVE {PDERR_FIRSTCUSTOM}	CONST PDERR_FIRSTCUSTOM	= 32
NATIVE {PDERR_LASTCUSTOM}	CONST PDERR_LASTCUSTOM	= 126

/* internal use */
NATIVE {SPECIAL_DENSITYMASK}	CONST SPECIAL_DENSITYMASK	= $0700	/* masks out density values */
NATIVE {SPECIAL_DIMENSIONSMASK} CONST SPECIAL_DIMENSIONSMASK = SPECIAL_MILCOLS OR SPECIAL_MILROWS OR SPECIAL_FULLCOLS OR SPECIAL_FULLROWS OR SPECIAL_FRACCOLS OR SPECIAL_FRACROWS OR SPECIAL_ASPECT

/****************************************************************************/

/* The following tags are used for PRD_DUMPRPORTTAGS */

NATIVE {DRPA_Dummy} CONST DRPA_DUMMY = (TAG_USER + $60000)

/****************************************************************************/

/* The following tags are not implemented but reserved for future use. */

NATIVE {DRPA_ICCProfile}		CONST DRPA_ICCPROFILE		= (DRPA_DUMMY+1) /* APTR */
NATIVE {DRPA_ICCName}		CONST DRPA_ICCNAME		= (DRPA_DUMMY+2) /* STRPTR */
NATIVE {DRPA_NoColCorrect}	CONST DRPA_NOCOLCORRECT	= (DRPA_DUMMY+3) /* LBOOL */

/****************************************************************************/

/* If the following tag is used io_RastPort and io_ColorMap are
   ignored.
*/
NATIVE {DRPA_SourceHook}   CONST DRPA_SOURCEHOOK   = (DRPA_DUMMY+4) /* struct Hook * */

/* The source hook (DRPA_SourceHook) is called with object NULL and
   message is a pointer to the following struct.

		VOID hook(struct Hook * hook,
		          APTR dummy,
		          struct DRPSourceMsg * drpm);
*/
NATIVE {DRPSourceMsg} OBJECT drpsourcemsg
	{x}	x	:VALUE
	{y}	y	:VALUE
	{width}	width	:VALUE
	{height}	height	:VALUE
	{buf}	buf	:PTR TO ULONG /* fill this buffer with $00RRGGBB pixels */
ENDOBJECT

/****************************************************************************/

/* If these tags are used io_Modes is ignored for aspect ratio */

NATIVE {DRPA_AspectX}      CONST DRPA_ASPECTX      = (DRPA_DUMMY+5) /* ULONG */
NATIVE {DRPA_AspectY}      CONST DRPA_ASPECTY      = (DRPA_DUMMY+6) /* ULONG */

/****************************************************************************/

/* The following tags are used for PRD_EDITPREFS */

NATIVE {PPRA_Dummy} CONST PPRA_DUMMY = (TAG_USER + $70000)

/****************************************************************************/

/* Request to edit prefs (for PRD_EDITPREFS; V44) */

NATIVE {IOPrtPrefsReq} OBJECT ioprtprefsreq
	{io_Message}	mn	:mn
	{io_Device}	device	:PTR TO dd	/* device node pointer  */
	{io_Unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io_Command}	command	:UINT	/* device command */
	{io_Flags}	flags	:UBYTE
	{io_Error}	error	:BYTE	/* error or warning num */
	{io_TagList}	taglist	:ARRAY OF tagitem	/* requester tag list */
ENDOBJECT

NATIVE {PPRA_Window}	CONST PPRA_WINDOW	= (PPRA_DUMMY+1) /* struct Window * */
NATIVE {PPRA_Screen}	CONST PPRA_SCREEN	= (PPRA_DUMMY+2) /* struct Screen * */
NATIVE {PPRA_PubScreen}	CONST PPRA_PUBSCREEN	= (PPRA_DUMMY+3) /* STRPTR */

/****************************************************************************/

/* Request to set error hook (for PRD_SETERRHOOK; V44)*/

NATIVE {PDHOOK_NONE}	CONST PDHOOK_NONE	= NIL!!PTR TO hook
NATIVE {PDHOOK_STD}	CONST PDHOOK_STD	= 1!!VALUE!!PTR TO hook

NATIVE {IOPrtErrReq} OBJECT ioprterrreq
	{io_Message}	mn	:mn
	{io_Device}	device	:PTR TO dd	/* device node pointer  */
	{io_Unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io_Command}	command	:UINT	/* device command */
	{io_Flags}	flags	:UBYTE
	{io_Error}	error	:BYTE	/* error or warning num */
	{io_Hook}	hook	:PTR TO hook
ENDOBJECT

/****************************************************************************/

/*
	The error hook is called with the IORequest that caused the error as
	object (2nd Parameter) and a pointer to struct PrtErrMsg as message
	(3rd Parameter):

		VOID hook(struct Hook * hook,
		          struct printerIO * ior,
		          struct PrtErrMsg * pem);
*/
NATIVE {PrtErrMsg} OBJECT prterrmsg
	{pe_Version}	version	:ULONG	/* Version of this struct */
	{pe_ErrorLevel}	errorlevel	:ULONG	/* RETURN_WARN, RETURN_ERROR, RETURN_FAIL */
	{pe_Window}	window	:PTR TO window	/* window for EasyRequest() */
	{pe_ES}	es	:PTR TO easystruct
	{pe_IDCMP}	idcmp	:PTR TO ULONG
	{pe_ArgList}	arglist	:APTR
ENDOBJECT

NATIVE {PDHOOK_VERSION} CONST PDHOOK_VERSION = 1

/****************************************************************************/

/* PRIVATE: Request to change prefs temporary. DO NOT USE! */

NATIVE {IOPrefsReq} OBJECT ioprefsreq
	{io_Message}	mn	:mn
	{io_Device}	device	:PTR TO dd	/* device node pointer  */
	{io_Unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io_Command}	command	:UINT	/* device command */
	{io_Flags}	flags	:UBYTE
	{io_Error}	error	:BYTE	/* error or warning num */
	{io_TxtPrefs}	txtprefs	:PTR TO printertxtprefs
	{io_UnitPrefs}	unitprefs	:PTR TO printerunitprefs
	{io_DevUnitPrefs}	devunitprefs	:PTR TO printerdeviceunitprefs
	{io_GfxPrefs}	gfxprefs	:PTR TO printergfxprefs
ENDOBJECT
