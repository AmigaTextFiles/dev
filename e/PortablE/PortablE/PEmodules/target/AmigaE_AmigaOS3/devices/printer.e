/* $VER: printer.h 44.1 (19.10.1999) */
OPT NATIVE, POINTER
MODULE 'target/exec/devices', 'target/intuition/intuition', 'target/utility/tagitem'
MODULE 'target/exec/io', 'target/utility/hooks', 'target/exec/ports', 'target/graphics/rastport', 'target/graphics/view', 'target/prefs/printertxt', 'target/prefs/printergfx', 'target/exec/types'
{MODULE 'devices/printer'}

/****************************************************************************/

/* V34-V40 commands */
NATIVE {PRD_RAWWRITE}		CONST PRD_RAWWRITE		= (CMD_NONSTD+0)
NATIVE {PRD_PRTCOMMAND}		CONST PRD_PRTCOMMAND		= (CMD_NONSTD+1)
NATIVE {PRD_DUMPRPORT}		CONST PRD_DUMPRPORT		= (CMD_NONSTD+2)
NATIVE {PRD_QUERY}		CONST PRD_QUERY		= (CMD_NONSTD+3)

/* V44 commands */
CONST PRD_RESETPREFS		= (CMD_NONSTD+4)	/* PRIVATE: do not use! */
CONST PRD_LOADPREFS		= (CMD_NONSTD+5)	/* PRIVATE: do not use! */
CONST PRD_USEPREFS		= (CMD_NONSTD+6)	/* PRIVATE: do not use! */
CONST PRD_SAVEPREFS		= (CMD_NONSTD+7)	/* PRIVATE: do not use! */
CONST PRD_READPREFS		= (CMD_NONSTD+8)
CONST PRD_WRITEPREFS		= (CMD_NONSTD+9)
CONST PRD_EDITPREFS		= (CMD_NONSTD+10)
CONST PRD_SETERRHOOK		= (CMD_NONSTD+11)
CONST PRD_DUMPRPORTTAGS	= (CMD_NONSTD+12)

/****************************************************************************/

/* printer command definitions */

NATIVE {ARIS}	CONST ARIS	= 0	/* ESCc  reset                    ISO */
NATIVE {ARIN}	CONST ARIN	= 1	/* ESC#1 initialize               +++ */
NATIVE {AIND}	CONST AIND	= 2	/* ESCD  lf                       ISO */
NATIVE {ANEL}	CONST ANEL	= 3	/* ESCE  return,lf                ISO */
NATIVE {ARI}	CONST ARI	= 4	/* ESCM  reverse lf               ISO */

NATIVE {ASGR0}	CONST ASGR0	= 5	/* ESC[0m normal char set         ISO */
NATIVE {ASGR3}	CONST ASGR3	= 6	/* ESC[3m italics on              ISO */
NATIVE {ASGR23}	CONST ASGR23	= 7	/* ESC[23m italics off            ISO */
NATIVE {ASGR4}	CONST ASGR4	= 8	/* ESC[4m underline on            ISO */
NATIVE {ASGR24}	CONST ASGR24	= 9	/* ESC[24m underline off          ISO */
NATIVE {ASGR1}	CONST ASGR1	= 10	/* ESC[1m boldface on             ISO */
NATIVE {ASGR22}	CONST ASGR22	= 11	/* ESC[22m boldface off           ISO */
NATIVE {ASFC}	CONST ASFC	= 12	/* SGR30-39  set foreground color ISO */
NATIVE {ASBC}	CONST ASBC	= 13	/* SGR40-49  set background color ISO */

NATIVE {ASHORP0}	CONST ASHORP0	= 14	/* ESC[0w normal pitch            DEC */
NATIVE {ASHORP2}	CONST ASHORP2	= 15	/* ESC[2w elite on                DEC */
NATIVE {ASHORP1}	CONST ASHORP1	= 16	/* ESC[1w elite off               DEC */
NATIVE {ASHORP4}	CONST ASHORP4	= 17	/* ESC[4w condensed fine on       DEC */
NATIVE {ASHORP3}	CONST ASHORP3	= 18	/* ESC[3w condensed off           DEC */
NATIVE {ASHORP6}	CONST ASHORP6	= 19	/* ESC[6w enlarged on             DEC */
NATIVE {ASHORP5}	CONST ASHORP5	= 20	/* ESC[5w enlarged off            DEC */

NATIVE {ADEN6}	CONST ADEN6	= 21	/* ESC[6"z shadow print on        DEC (sort of) */
NATIVE {ADEN5}	CONST ADEN5	= 22	/* ESC[5"z shadow print off       DEC */
NATIVE {ADEN4}	CONST ADEN4	= 23	/* ESC[4"z doublestrike on        DEC */
NATIVE {ADEN3}	CONST ADEN3	= 24	/* ESC[3"z doublestrike off       DEC */
NATIVE {ADEN2}	CONST ADEN2	= 25	/* ESC[2"z  NLQ on                DEC */
NATIVE {ADEN1}	CONST ADEN1	= 26	/* ESC[1"z  NLQ off               DEC */

NATIVE {ASUS2}	CONST ASUS2	= 27	/* ESC[2v superscript on          +++ */
NATIVE {ASUS1}	CONST ASUS1	= 28	/* ESC[1v superscript off         +++ */
NATIVE {ASUS4}	CONST ASUS4	= 29	/* ESC[4v subscript on            +++ */
NATIVE {ASUS3}	CONST ASUS3	= 30	/* ESC[3v subscript off           +++ */
NATIVE {ASUS0}	CONST ASUS0	= 31	/* ESC[0v normalize the line      +++ */
NATIVE {APLU}	CONST APLU	= 32	/* ESCL  partial line up          ISO */
NATIVE {APLD}	CONST APLD	= 33	/* ESCK  partial line down        ISO */

NATIVE {AFNT0}	CONST AFNT0	= 34	/* ESC(B US char set        or Typeface  0 (default) */
NATIVE {AFNT1}	CONST AFNT1	= 35	/* ESC(R French char set    or Typeface  1 */
NATIVE {AFNT2}	CONST AFNT2	= 36	/* ESC(K German char set    or Typeface  2 */
NATIVE {AFNT3}	CONST AFNT3	= 37	/* ESC(A UK char set        or Typeface  3 */
NATIVE {AFNT4}	CONST AFNT4	= 38	/* ESC(E Danish I char set  or Typeface  4 */
NATIVE {AFNT5}	CONST AFNT5	= 39	/* ESC(H Sweden char set    or Typeface  5 */
NATIVE {AFNT6}	CONST AFNT6	= 40	/* ESC(Y Italian char set   or Typeface  6 */
NATIVE {AFNT7}	CONST AFNT7	= 41	/* ESC(Z Spanish char set   or Typeface  7 */
NATIVE {AFNT8}	CONST AFNT8	= 42	/* ESC(J Japanese char set  or Typeface  8 */
NATIVE {AFNT9}	CONST AFNT9	= 43	/* ESC(6 Norweign char set  or Typeface  9 */
NATIVE {AFNT10}	CONST AFNT10	= 44	/* ESC(C Danish II char set or Typeface 10 */


NATIVE {APROP2}	CONST APROP2	= 45	/* ESC[2p  proportional on        +++ */
NATIVE {APROP1}	CONST APROP1	= 46	/* ESC[1p  proportional off       +++ */
NATIVE {APROP0}	CONST APROP0	= 47	/* ESC[0p  proportional clear     +++ */
NATIVE {ATSS}	CONST ATSS	= 48	/* ESC[n E set proportional offset ISO */
NATIVE {AJFY5}	CONST AJFY5	= 49	/* ESC[5 F auto left justify      ISO */
NATIVE {AJFY7}	CONST AJFY7	= 50	/* ESC[7 F auto right justify     ISO */
NATIVE {AJFY6}	CONST AJFY6	= 51	/* ESC[6 F auto full justify      ISO */
NATIVE {AJFY0}	CONST AJFY0	= 52	/* ESC[0 F auto justify off       ISO */
NATIVE {AJFY3}	CONST AJFY3	= 53	/* ESC[3 F letter space (justify) ISO (special) */
CONST AJFY1	= 54	/* ESC[1 F word fill(auto center) ISO (special) */

NATIVE {AVERP0}	CONST AVERP0	= 55	/* ESC[0z  1/8" line spacing      +++ */
NATIVE {AVERP1}	CONST AVERP1	= 56	/* ESC[1z  1/6" line spacing      +++ */
NATIVE {ASLPP}	CONST ASLPP	= 57	/* ESC[nt  set form length n      DEC */
NATIVE {APERF}	CONST APERF	= 58	/* ESC[nq  perf skip n (n>0)      +++ */
NATIVE {APERF0}	CONST APERF0	= 59	/* ESC[0q  perf skip off          +++ */

NATIVE {ALMS}	CONST ALMS	= 60	/* ESC#9   Left margin set        +++ */
NATIVE {ARMS}	CONST ARMS	= 61	/* ESC#0   Right margin set       +++ */
NATIVE {ATMS}	CONST ATMS	= 62	/* ESC#8   Top margin set         +++ */
NATIVE {ABMS}	CONST ABMS	= 63	/* ESC#2   Bottom marg set        +++ */
NATIVE {ASTBM}	CONST ASTBM	= 64	/* ESC[Pn1;Pn2r  T&B margins      DEC */
NATIVE {ASLRM}	CONST ASLRM	= 65	/* ESC[Pn1;Pn2s  L&R margin       DEC */
NATIVE {ACAM}	CONST ACAM	= 66	/* ESC#3   Clear margins          +++ */

NATIVE {AHTS}	CONST AHTS	= 67	/* ESCH    Set horiz tab          ISO */
NATIVE {AVTS}	CONST AVTS	= 68	/* ESCJ    Set vertical tabs      ISO */
NATIVE {ATBC0}	CONST ATBC0	= 69	/* ESC[0g  Clr horiz tab          ISO */
NATIVE {ATBC3}	CONST ATBC3	= 70	/* ESC[3g  Clear all h tab        ISO */
NATIVE {ATBC1}	CONST ATBC1	= 71	/* ESC[1g  Clr vertical tabs      ISO */
NATIVE {ATBC4}	CONST ATBC4	= 72	/* ESC[4g  Clr all v tabs         ISO */
NATIVE {ATBCALL}	CONST ATBCALL	= 73	/* ESC#4   Clr all h & v tabs     +++ */
NATIVE {ATBSALL}	CONST ATBSALL	= 74	/* ESC#5   Set default tabs       +++ */
NATIVE {AEXTEND}	CONST AEXTEND	= 75	/* ESC[Pn"x extended commands     +++ */

NATIVE {ARAW}	CONST ARAW	= 76	/*	ESC[Pn"r	Next	'Pn' chars are raw +++ */

/****************************************************************************/

/* For PRD_PRTCOMMAND */
NATIVE {ioprtcmdreq} OBJECT ioprtcmdreq
	{io.mn}	mn	:mn
	{io.device}	device	:PTR TO dd	/* device node pointer  */
	{io.unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io.command}	command	:UINT	/* device command */
	{io.flags}	flags	:UBYTE
	{io.error}	error	:BYTE	/* error or warning num */
->#the above members were represented by an "io" object in AmigaE
	{prtcommand}	prtcommand	:UINT	/* printer command */
	{parm0}	parm0	:UBYTE	/* first command parameter */
	{parm1}	parm1	:UBYTE	/* second command parameter */
	{parm2}	parm2	:UBYTE	/* third command parameter */
	{parm3}	parm3	:UBYTE	/* fourth command parameter */
ENDOBJECT

/****************************************************************************/

/* For PRD_DUMPRPORT */
NATIVE {iodrpreq} OBJECT iodrpreq
	{io.mn}	mn	:mn
	{io.device}	device	:PTR TO dd	/* device node pointer  */
	{io.unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{io.command}	command	:UINT	/* device command */
	{io.flags}	flags	:UBYTE
	{io.error}	error	:BYTE	/* error or warning num */
->#the above members were represented by an "io" object in AmigaE
	{rastport}	rastport	:PTR TO rastport	/* raster port */
	{colormap}	colormap	:PTR TO colormap	/* color map */
	{modes}	modes	:ULONG	/* graphics viewport modes */
	{srcx}	srcx	:UINT	/* source x origin */
	{srcy}	srcy	:UINT	/* source y origin */
	{srcwidth}	srcwidth	:UINT	/* source x width */
	{srcheight}	srcheight	:UINT	/* source x height */
	{destcols}	destcols	:VALUE	/* destination x width */
	{destrows}	destrows	:VALUE	/* destination y height */
	{special}	special	:UINT	/* option flags */
ENDOBJECT

/****************************************************************************/

/* For PRD_DUMPRPORTTAGS (V44) */
/*
NATIVE {iodrptagsreq} OBJECT iodrptagsreq
	{mn}	mn	:mn
	{device}	device	:PTR TO dd	/* device node pointer  */
	{unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{command}	command	:UINT	/* device command */
	{flags}	flags	:UBYTE
	{error}	error	:BYTE	/* error or warning num */
	{rastport}	rastport	:PTR TO rastport	/* raster port */
	{colormap}	colormap	:PTR TO colormap	/* color map */
	{modes}	modes	:ULONG	/* graphics viewport modes */
	{srcx}	srcx	:UINT	/* source x origin */
	{srcy}	srcy	:UINT	/* source y origin */
	{srcwidth}	srcwidth	:UINT	/* source x width */
	{srcheight}	srcheight	:UINT	/* source x height */
	{destcols}	destcols	:VALUE	/* destination x width */
	{destrows}	destrows	:VALUE	/* destination y height */
	{special}	special	:UINT	/* option flags */
	{taglist}	taglist	:ARRAY OF tagitem	/* tag list with additional info */
ENDOBJECT
*/
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

NATIVE {PDERR_TOOKCONTROL}	CONST PDERR_TOOKCONTROL	= 8	/* Took control in case 0 of render */

CONST PDERR_BADPREFERENCES	= 9	/* preferences file corrupt */

CONST PDERR_LASTSTANDARD	= 31
CONST PDERR_FIRSTCUSTOM	= 32
CONST PDERR_LASTCUSTOM	= 126

/* internal use */
NATIVE {SPECIAL_DENSITYMASK}	CONST SPECIAL_DENSITYMASK	= $0700	/* masks out density values */
NATIVE {SPECIAL_DIMENSIONSMASK} CONST SPECIAL_DIMENSIONSMASK = SPECIAL_MILCOLS OR SPECIAL_MILROWS OR SPECIAL_FULLCOLS OR SPECIAL_FULLROWS OR SPECIAL_FRACCOLS OR SPECIAL_FRACROWS OR SPECIAL_ASPECT

/****************************************************************************/

/* The following tags are used for PRD_DUMPRPORTTAGS */

CONST DRPA_DUMMY = (TAG_USER + $60000)

/****************************************************************************/

/* The following tags are not implemented but reserved for future use. */

CONST DRPA_ICCPROFILE		= (DRPA_DUMMY+1) /* APTR */
CONST DRPA_ICCNAME		= (DRPA_DUMMY+2) /* STRPTR */
CONST DRPA_NOCOLCORRECT	= (DRPA_DUMMY+3) /* LBOOL */

/****************************************************************************/

CONST DRPA_SOURCEHOOK   = (DRPA_DUMMY+4) /* struct Hook * */
/*
NATIVE {drpsourcemsg} OBJECT drpsourcemsg
	{x}	x	:VALUE
	{y}	y	:VALUE
	{width}	width	:VALUE
	{height}	height	:VALUE
	{buf}	buf	:PTR TO ULONG /* fill this buffer with $00RRGGBB pixels */
ENDOBJECT
*/
/****************************************************************************/

/* If these tags are used io_Modes is ignored for aspect ratio */

CONST DRPA_ASPECTX      = (DRPA_DUMMY+5) /* ULONG */
CONST DRPA_ASPECTY      = (DRPA_DUMMY+6) /* ULONG */

/****************************************************************************/

/* The following tags are used for PRD_EDITPREFS */

CONST PPRA_DUMMY = (TAG_USER + $70000)

/****************************************************************************/

/* Request to edit prefs (for PRD_EDITPREFS; V44) */
/*
NATIVE {ioprtprefsreq} OBJECT ioprtprefsreq
	{mn}	mn	:mn
	{device}	device	:PTR TO dd	/* device node pointer  */
	{unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{command}	command	:UINT	/* device command */
	{flags}	flags	:UBYTE
	{error}	error	:BYTE	/* error or warning num */
	{taglist}	taglist	:ARRAY OF tagitem	/* requester tag list */
ENDOBJECT
*/
CONST PPRA_WINDOW	= (PPRA_DUMMY+1) /* struct Window * */
CONST PPRA_SCREEN	= (PPRA_DUMMY+2) /* struct Screen * */
CONST PPRA_PUBSCREEN	= (PPRA_DUMMY+3) /* STRPTR */

/****************************************************************************/

/* Request to set error hook (for PRD_SETERRHOOK; V44)*/

CONST PDHOOK_NONE	= NIL!!PTR TO hook
CONST PDHOOK_STD	= 1!!VALUE!!PTR TO hook
/*
NATIVE {ioprterrreq} OBJECT ioprterrreq
	{mn}	mn	:mn
	{device}	device	:PTR TO dd	/* device node pointer  */
	{unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{command}	command	:UINT	/* device command */
	{flags}	flags	:UBYTE
	{error}	error	:BYTE	/* error or warning num */
	{hook}	hook	:PTR TO hook
ENDOBJECT
*/

/****************************************************************************/
/*
NATIVE {prterrmsg} OBJECT prterrmsg
	{version}	version	:ULONG	/* Version of this struct */
	{errorlevel}	errorlevel	:ULONG	/* RETURN_WARN, RETURN_ERROR, RETURN_FAIL */
	{window}	window	:PTR TO window	/* window for EasyRequest() */
	{es}	es	:PTR TO easystruct
	{idcmp}	idcmp	:PTR TO ULONG
	{arglist}	arglist	:APTR
ENDOBJECT
*/
CONST PDHOOK_VERSION = 1

/****************************************************************************/

/* PRIVATE: Request to change prefs temporary. DO NOT USE! */
/*
NATIVE {ioprefsreq} OBJECT ioprefsreq
	{mn}	mn	:mn
	{device}	device	:PTR TO dd	/* device node pointer  */
	{unit}	unit	:PTR TO unit	/* unit (driver private)*/
	{command}	command	:UINT	/* device command */
	{flags}	flags	:UBYTE
	{error}	error	:BYTE	/* error or warning num */
	{txtprefs}	txtprefs	:PTR TO printertxtprefs
	{unitprefs}	unitprefs	:PTR TO printerunitprefs
	{devunitprefs}	devunitprefs	:PTR TO printerdeviceunitprefs
	{gfxprefs}	gfxprefs	:PTR TO printergfxprefs
ENDOBJECT
*/
