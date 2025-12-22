/* $Id: printer.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, POINTER
MODULE 'target/exec/devices', 'target/intuition/intuition', 'target/utility/tagitem'
MODULE 'target/exec/io', 'target/utility/hooks', 'target/exec/ports', 'target/graphics/rastport', 'target/graphics/view', 'target/prefs/printertxt', 'target/prefs/printergfx', 'target/exec/types'
{#include <devices/printer.h>}
NATIVE {DEVICES_PRINTER_H} CONST

/* V30-V40 commands */

NATIVE {PRD_RAWWRITE} 	    	CONST PRD_RAWWRITE 	    	= (CMD_NONSTD)
NATIVE {PRD_PRTCOMMAND}	    	CONST PRD_PRTCOMMAND	    	= (CMD_NONSTD + 1)
NATIVE {PRD_DUMPRPORT}	    	CONST PRD_DUMPRPORT	    	= (CMD_NONSTD + 2)
NATIVE {PRD_QUERY}   	    	CONST PRD_QUERY   	    	= (CMD_NONSTD + 3)

/* V44 commands */

NATIVE {PRD_RESETPREFS}	    	CONST PRD_RESETPREFS	    	= (CMD_NONSTD + 4)
NATIVE {PRD_LOADPREFS}	    	CONST PRD_LOADPREFS	    	= (CMD_NONSTD + 5)
NATIVE {PRD_USEPREFS}	    	CONST PRD_USEPREFS	    	= (CMD_NONSTD + 6)
NATIVE {PRD_SAVEPREFS}	    	CONST PRD_SAVEPREFS	    	= (CMD_NONSTD + 7)
NATIVE {PRD_READPREFS}	    	CONST PRD_READPREFS	    	= (CMD_NONSTD + 8)
NATIVE {PRD_WRITEPREFS}	    	CONST PRD_WRITEPREFS	    	= (CMD_NONSTD + 9)
NATIVE {PRD_EDITPREFS}	    	CONST PRD_EDITPREFS	    	= (CMD_NONSTD + 10)
NATIVE {PRD_SETERRHOOK}	    	CONST PRD_SETERRHOOK	    	= (CMD_NONSTD + 11)
NATIVE {PRD_DUMPRPORTTAGS}   	CONST PRD_DUMPRPORTTAGS   	= (CMD_NONSTD + 12)

/* printer command definitions */

NATIVE {aRIS}	    	    	CONST ARIS	    	    	= 0
NATIVE {aRIN}	    	    	CONST ARIN	    	    	= 1
NATIVE {aIND}	    	    	CONST AIND	    	    	= 2
NATIVE {aNEL}	    	    	CONST ANEL	    	    	= 3
NATIVE {aRI} 	    	    	CONST ARI 	    	    	= 4

NATIVE {aSGR0}	    	    	CONST ASGR0	    	    	= 5
NATIVE {aSGR3}	    	    	CONST ASGR3	    	    	= 6
NATIVE {aSGR23}	    	    	CONST ASGR23	    	    	= 7
NATIVE {aSGR4}	    	    	CONST ASGR4	    	    	= 8
NATIVE {aSGR24}	    	    	CONST ASGR24	    	    	= 9
NATIVE {aSGR1}	    	    	CONST ASGR1	    	    	= 10
NATIVE {aSGR22}	    	    	CONST ASGR22	    	    	= 11
NATIVE {aSFC}	    	    	CONST ASFC	    	    	= 12
NATIVE {aSBC}	    	    	CONST ASBC	    	    	= 13

NATIVE {aSHORP0}  	    	CONST ASHORP0  	    	= 14
NATIVE {aSHORP2}     	    	CONST ASHORP2     	    	= 15
NATIVE {aSHORP1}     	    	CONST ASHORP1     	    	= 16
NATIVE {aSHORP4}     	    	CONST ASHORP4     	    	= 17
NATIVE {aSHORP3}     	    	CONST ASHORP3     	    	= 18
NATIVE {aSHORP6}     	    	CONST ASHORP6     	    	= 19
NATIVE {aSHORP5}     	    	CONST ASHORP5     	    	= 20

NATIVE {aDEN6}	    	    	CONST ADEN6	    	    	= 21
NATIVE {aDEN5}	    	    	CONST ADEN5	    	    	= 22
NATIVE {aDEN4}	    	    	CONST ADEN4	    	    	= 23
NATIVE {aDEN3}	    	    	CONST ADEN3	    	    	= 24
NATIVE {aDEN2}	    	    	CONST ADEN2	    	    	= 25
NATIVE {aDEN1}	    	    	CONST ADEN1	    	    	= 26

NATIVE {aSUS2}	    	    	CONST ASUS2	    	    	= 27
NATIVE {aSUS1}	    	    	CONST ASUS1	    	    	= 28
NATIVE {aSUS4}	    	    	CONST ASUS4	    	    	= 29
NATIVE {aSUS3}	    	    	CONST ASUS3	    	    	= 30
NATIVE {aSUS0}	    	    	CONST ASUS0	    	    	= 31
NATIVE {aPLU}	    	    	CONST APLU	    	    	= 32
NATIVE {aPLD}	    	    	CONST APLD	    	    	= 33

NATIVE {aFNT0}	    	    	CONST AFNT0	    	    	= 34
NATIVE {aFNT1}	    	    	CONST AFNT1	    	    	= 35
NATIVE {aFNT2}	    	    	CONST AFNT2	    	    	= 36
NATIVE {aFNT3}	    	    	CONST AFNT3	    	    	= 37
NATIVE {aFNT4}	    	    	CONST AFNT4	    	    	= 38
NATIVE {aFNT5}	    	    	CONST AFNT5	    	    	= 39
NATIVE {aFNT6}	    	    	CONST AFNT6	    	    	= 40
NATIVE {aFNT7}	    	    	CONST AFNT7	    	    	= 41
NATIVE {aFNT8}	    	    	CONST AFNT8	    	    	= 42
NATIVE {aFNT9}	    	    	CONST AFNT9	    	    	= 43
NATIVE {aFNT10}	    	    	CONST AFNT10	    	    	= 44

NATIVE {aPROP2}	    	    	CONST APROP2	    	    	= 45
NATIVE {aPROP1}	    	    	CONST APROP1	    	    	= 46
NATIVE {aPROP0}	    	    	CONST APROP0	    	    	= 47
NATIVE {aTSS}	    	    	CONST ATSS	    	    	= 48
NATIVE {aJFY5}	    	    	CONST AJFY5	    	    	= 49
NATIVE {aJFY7}	    	    	CONST AJFY7	    	    	= 50
NATIVE {aJFY6}	    	    	CONST AJFY6	    	    	= 51
NATIVE {aJFY0}	    	    	CONST AJFY0	    	    	= 52
NATIVE {aJFY3}	    	    	CONST AJFY3	    	    	= 53
NATIVE {aJFY1}	    	    	CONST AJFY1	    	    	= 54

NATIVE {aVERP0}	    	    	CONST AVERP0	    	    	= 55
NATIVE {aVERP1}	    	    	CONST AVERP1	    	    	= 56
NATIVE {aSLPP}	    	    	CONST ASLPP	    	    	= 57
NATIVE {aPERF}	    	    	CONST APERF	    	    	= 58
NATIVE {aPERF0}	    	    	CONST APERF0	    	    	= 59

NATIVE {aLMS}	    	    	CONST ALMS	    	    	= 60
NATIVE {aRMS}	    	    	CONST ARMS	    	    	= 61
NATIVE {aTMS}	    	    	CONST ATMS	    	    	= 62
NATIVE {aBMS}	    	    	CONST ABMS	    	    	= 63
NATIVE {aSTBM}	    	    	CONST ASTBM	    	    	= 64
NATIVE {aSLRM}	    	    	CONST ASLRM	    	    	= 65
NATIVE {aCAM}	    	    	CONST ACAM	    	    	= 66

NATIVE {aHTS}	    	    	CONST AHTS	    	    	= 67
NATIVE {aVTS}	    	    	CONST AVTS	    	    	= 68
NATIVE {aTBC0}	    	    	CONST ATBC0	    	    	= 69
NATIVE {aTBC3}	    	    	CONST ATBC3	    	    	= 70
NATIVE {aTBC1}	    	    	CONST ATBC1	    	    	= 71
NATIVE {aTBC4}	    	    	CONST ATBC4	    	    	= 72
NATIVE {aTBCALL}	    	    	CONST ATBCALL	    	    	= 73
NATIVE {aTBSALL}	    	    	CONST ATBSALL	    	    	= 74
NATIVE {aEXTEND}	    	    	CONST AEXTEND	    	    	= 75

NATIVE {aRAW}	    	    	CONST ARAW	    	    	= 76

/* For PRD_PRTCOMMAND */

NATIVE {IOPrtCmdReq} OBJECT ioprtcmdreq
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
->#the above members were represented by an "io" object in AmigaE
    {io_PrtCommand}	prtcommand	:UINT
    {io_Parm0}	parm0	:UBYTE
    {io_Parm1}	parm1	:UBYTE
    {io_Parm2}	parm2	:UBYTE
    {io_Parm3}	parm3	:UBYTE
ENDOBJECT

/* For PRD_DUMPRPORT */

NATIVE {IODRPReq} OBJECT iodrpreq
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
->#the above members were represented by an "io" object in AmigaE
    {io_RastPort}	rastport	:PTR TO rastport
    {io_ColorMap}	colormap	:PTR TO colormap
    {io_Modes}	modes	:ULONG
    {io_SrcX}	srcx	:UINT
    {io_SrcY}	srcy	:UINT

    {io_SrcWidth}	srcwidth	:UINT
    {io_SrcHeight}	srcheight	:UINT
    {io_DestCols}	destcols	:VALUE
    {io_DestRows}	destrows	:VALUE
    {io_Special}	special	:UINT
ENDOBJECT

/* For PRD_DUMPRPORTTAGS (V44) */

NATIVE {IODRPTagsReq} OBJECT iodrptagsreq
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
    {io_RastPort}	rastport	:PTR TO rastport
    {io_ColorMap}	colormap	:PTR TO colormap
    {io_Modes}	modes	:ULONG
    {io_SrcX}	srcx	:UINT
    {io_SrcY}	srcy	:UINT
    {io_SrcWidth}	srcwidth	:UINT
    {io_SrcHeight}	srcheight	:UINT
    {io_DestCols}	destcols	:VALUE
    {io_DestRows}	destrows	:VALUE
    {io_Special}	special	:UINT
    {io_TagList}	taglist	:ARRAY OF tagitem
ENDOBJECT

NATIVE {SPECIAL_MILCOLS}	    	CONST SPECIAL_MILCOLS	    	= $0001
NATIVE {SPECIAL_MILROWS}	    	CONST SPECIAL_MILROWS	    	= $0002
NATIVE {SPECIAL_FULLCOLS}    	CONST SPECIAL_FULLCOLS    	= $0004
NATIVE {SPECIAL_FULLROWS}    	CONST SPECIAL_FULLROWS    	= $0008
NATIVE {SPECIAL_FRACCOLS}    	CONST SPECIAL_FRACCOLS    	= $0010
NATIVE {SPECIAL_FRACROWS}    	CONST SPECIAL_FRACROWS    	= $0020
NATIVE {SPECIAL_CENTER}	    	CONST SPECIAL_CENTER	    	= $0040
NATIVE {SPECIAL_ASPECT}	    	CONST SPECIAL_ASPECT	    	= $0080
NATIVE {SPECIAL_DENSITY1}    	CONST SPECIAL_DENSITY1    	= $0100
NATIVE {SPECIAL_DENSITY2}    	CONST SPECIAL_DENSITY2    	= $0200
NATIVE {SPECIAL_DENSITY3}    	CONST SPECIAL_DENSITY3    	= $0300
NATIVE {SPECIAL_DENSITY4}    	CONST SPECIAL_DENSITY4    	= $0400
NATIVE {SPECIAL_DENSITY5}    	CONST SPECIAL_DENSITY5    	= $0500
NATIVE {SPECIAL_DENSITY6}    	CONST SPECIAL_DENSITY6    	= $0600
NATIVE {SPECIAL_DENSITY7}    	CONST SPECIAL_DENSITY7    	= $0700
NATIVE {SPECIAL_NOFORMFEED}  	CONST SPECIAL_NOFORMFEED  	= $0800
NATIVE {SPECIAL_TRUSTME}	    	CONST SPECIAL_TRUSTME	    	= $1000
NATIVE {SPECIAL_NOPRINT}	    	CONST SPECIAL_NOPRINT	    	= $2000

NATIVE {PDERR_NOERR}	    	CONST PDERR_NOERR	    	= 0
NATIVE {PDERR_CANCEL}		CONST PDERR_CANCEL		= 1
NATIVE {PDERR_NOTGRAPHICS}	CONST PDERR_NOTGRAPHICS	= 2
NATIVE {PDERR_INVERTHAM}		CONST PDERR_INVERTHAM		= 3
NATIVE {PDERR_BADDIMENSION}	CONST PDERR_BADDIMENSION	= 4
NATIVE {PDERR_DIMENSIONOVFLOW}	CONST PDERR_DIMENSIONOVFLOW	= 5
NATIVE {PDERR_INTERNALMEMORY}	CONST PDERR_INTERNALMEMORY	= 6
NATIVE {PDERR_BUFFERMEMORY}	CONST PDERR_BUFFERMEMORY	= 7
NATIVE {PDERR_TOOKCONTROL}	CONST PDERR_TOOKCONTROL	= 8
NATIVE {PDERR_BADPREFERENCES}	CONST PDERR_BADPREFERENCES	= 9

NATIVE {PDERR_LASTSTANDARD}	CONST PDERR_LASTSTANDARD	= 31
NATIVE {PDERR_FIRSTCUSTOM}	CONST PDERR_FIRSTCUSTOM	= 32
NATIVE {PDERR_LASTCUSTOM}	CONST PDERR_LASTCUSTOM	= 126

NATIVE {SPECIAL_DENSITYMASK}	CONST SPECIAL_DENSITYMASK	= $0700

NATIVE {SPECIAL_DIMENSIONSMASK} CONST SPECIAL_DIMENSIONSMASK = (SPECIAL_MILCOLS OR SPECIAL_MILROWS OR SPECIAL_FULLCOLS OR SPECIAL_FULLROWS OR SPECIAL_FRACCOLS OR SPECIAL_FRACROWS OR SPECIAL_ASPECT)

/* Tags for PRD_DUMPRPORTTAGS */

NATIVE {DRPA_Dummy}  	    	CONST DRPA_DUMMY  	    	= (TAG_USER + $60000)
NATIVE {DRPA_ICCProfile}		CONST DRPA_ICCPROFILE		= (DRPA_DUMMY + 1)
NATIVE {DRPA_ICCName}		CONST DRPA_ICCNAME		= (DRPA_DUMMY + 2)
NATIVE {DRPA_NoColCorrect}	CONST DRPA_NOCOLCORRECT	= (DRPA_DUMMY + 3)
NATIVE {DRPA_SourceHook}     	CONST DRPA_SOURCEHOOK     	= (DRPA_DUMMY + 4)
NATIVE {DRPA_AspectX}        	CONST DRPA_ASPECTX        	= (DRPA_DUMMY + 5)
NATIVE {DRPA_AspectY}        	CONST DRPA_ASPECTY        	= (DRPA_DUMMY  +6)

NATIVE {DRPSourceMsg} OBJECT drpsourcemsg
    {x}	x	:VALUE
    {y}	y	:VALUE
    {width}	width	:VALUE
    {height}	height	:VALUE
    {buf}	buf	:PTR TO ULONG
ENDOBJECT

/* Tags for PRD_EDITPREFS */

NATIVE {PPRA_Dummy}  	    	CONST PPRA_DUMMY  	    	= (TAG_USER + $70000)
NATIVE {PPRA_Window}	    	CONST PPRA_WINDOW	    	= (PPRA_DUMMY + 1)
NATIVE {PPRA_Screen}	    	CONST PPRA_SCREEN	    	= (PPRA_DUMMY + 2)
NATIVE {PPRA_PubScreen}	    	CONST PPRA_PUBSCREEN	    	= (PPRA_DUMMY + 3)

/* PRD_EDITPREFS Request (V44) */

NATIVE {IOPrtPrefsReq} OBJECT ioprtprefsreq
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
    {io_TagList}	taglist	:ARRAY OF tagitem
ENDOBJECT

/* PRD_SETERRHOOK Request (V44) */

NATIVE {IOPrtErrReq} OBJECT ioprterrreq
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
    {io_Hook}	hook	:PTR TO hook
ENDOBJECT

NATIVE {PDHOOK_NONE}	    	CONST PDHOOK_NONE	    	= NIL!!PTR TO hook
NATIVE {PDHOOK_STD}	    	CONST PDHOOK_STD	    	= 1!!VALUE!!PTR TO hook

NATIVE {PDHOOK_VERSION}      	CONST PDHOOK_VERSION      	= 1

NATIVE {PrtErrMsg} OBJECT prterrmsg
    {pe_Version}	version	:ULONG
    {pe_ErrorLevel}	errorlevel	:ULONG
    {pe_Window}	window	:PTR TO window
    {pe_ES}	es	:PTR TO easystruct
    {pe_IDCMP}	idcmp	:PTR TO ULONG
    {pe_ArgList}	arglist	:APTR
ENDOBJECT

/* PRIVATE: Request to change prefs temporary. DO NOT USE!!! */

NATIVE {IOPrefsReq} OBJECT ioprefsreq
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
    {io_TxtPrefs}	txtprefs	:PTR TO printertxtprefs
    {io_UnitPrefs}	unitprefs	:PTR TO printerunitprefs
    {io_DevUnitPrefs}	devunitprefs	:PTR ->#TO printerdeviceunitprefs
    {io_GfxPrefs}	gfxprefs	:PTR TO printergfxprefs
ENDOBJECT
