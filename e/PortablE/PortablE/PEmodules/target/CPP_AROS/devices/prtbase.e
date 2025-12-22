/* $Id: prtbase.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/utility/tagitem', 'target/exec/devices', 'target/devices/parallel', 'target/devices/serial', 'target/devices/timer', 'target/dos/dosextens', 'target/intuition/intuition'
MODULE /*'target/aros/machine',*/ 'target/aros/cpu', 'target/exec/libraries', 'target/exec/ports', 'target/exec/tasks', 'target/intuition/preferences', 'target/exec/types', 'target/dos/dos'
{#include <devices/prtbase.h>}
NATIVE {DEVICES_PRTBASE_H} CONST

NATIVE {DeviceData} OBJECT devicedata
    {dd_Device}	lib	:lib
    {dd_Segment}	segment	:APTR
    {dd_ExecBase}	execbase	:APTR
    {dd_CmdVectors}	cmdvectors	:APTR
    {dd_CmdBytes}	cmdbytes	:APTR
    {dd_NumCommands}	numcommands	:UINT
ENDOBJECT

/* IO Flags */

NATIVE {IOB_QUEUED}	    	CONST IOB_QUEUED	    	= 4
NATIVE {IOB_CURRENT}	    	CONST IOB_CURRENT	    	= 5
NATIVE {IOB_SERVICING}	    	CONST IOB_SERVICING	    	= 6
NATIVE {IOB_DONE}	    	CONST IOB_DONE	    	= 7

NATIVE {IOF_QUEUED}	    	CONST IOF_QUEUED	    	= $10
NATIVE {IOF_CURRENT}	    	CONST IOF_CURRENT	    	= $20
NATIVE {IOF_SERVICING}	    	CONST IOF_SERVICING	    	= $40
NATIVE {IOF_DONE}	    	CONST IOF_DONE	    	= $80

/* pd_Flags */

NATIVE {PB_IOR0}		    	CONST PB_IOR0		    	= 0
NATIVE {PB_IOR1}		    	CONST PB_IOR1		    	= 1
NATIVE {PB_IOOPENED}	    	CONST PB_IOOPENED	    	= 2
NATIVE {PB_EXPUNGED}	    	CONST PB_EXPUNGED	    	= 7

NATIVE {PBF_IOR0}	    	CONST PF_IOR0	    	= $1
NATIVE {PBF_IOR1}	    	CONST PF_IOR1	    	= $2
NATIVE {PBF_IOOPENDED}	    	CONST PF_IOOPENDED	    	= $4
NATIVE {PBF_EXPUNGED}	    	CONST PF_EXPUNGED	    	= $80

/* du_Flags (actually placed in pd_Unit.mp_Node.ln_Pri) */

NATIVE {DUB_STOPPED}	    	CONST DUB_STOPPED	    	= 0

NATIVE {DUF_STOPPED}	    	CONST DUF_STOPPED	    	= $1

NATIVE {P_OLDSTKSIZE}	    	CONST P_OLDSTKSIZE	    	= $0800
NATIVE {P_STKSIZE}   	    	CONST P_STKSIZE   	    	= AROS_STACKSIZE	/* 0x1000 in AmigaOS */
NATIVE {P_BUFSIZE}	    	CONST P_BUFSIZE	    	= 256
NATIVE {P_SAFESIZE}	    	CONST P_SAFESIZE	    	= 128

->#This should really be declared but it causes a problem with 'datatypes/datatypesclass': NATIVE {printerIO} OBJECT

NATIVE {PrinterData} OBJECT printerdata
    {pd_Device}	dd	:devicedata
    {pd_Unit}	unit	:mp
    {pd_PrinterSegment}	printersegment	:BPTR
    {pd_PrinterType}	printertype	:UINT
    {pd_SegmentData}	segmentdata	:PTR TO printersegment
    {pd_PrintBuf}	printbuf	:ARRAY OF UBYTE
    {pd_PWrite}	pwrite	:NATIVE {LONG    	    	    (*)(APTR data, LONG len)} PTR
    {pd_PBothReady}	pbothready	:NATIVE {LONG    	    	    (*)(VOID)} PTR
	{pd_ior0.pd_p0}	p0	:ioextpar
	{pd_ior0.pd_s0}	s0	:ioextser
	{pd_ior1.pd_p1}	p1	:ioextpar
	{pd_ior1.pd_s1}	s1	:ioextser
    {pd_TIOR}	tior	:timerequest
    {pd_IORPort}	iorport	:mp
    {pd_TC}	tc	:tc
    {pd_OldStk}	oldstk[P_OLDSTKSIZE]	:ARRAY OF UBYTE
    {pd_Flags}	flags	:UBYTE
    {pd_pad}	pad	:UBYTE
    {pd_Preferences}	preferences	:preferences
    {pd_PWaitEnabled}	pwaitenabled	:UBYTE
    {pd_Flags1}	flags1	:UBYTE
    {pd_Stk}	stk[P_STKSIZE]	:ARRAY OF UBYTE
    {pd_PUnit}	punit	:PTR ->#TO PrinterUnit
    {pd_PRead}	pread	:NATIVE {LONG    	    	    (*)(char * buffer, LONG *length, struct timeval *tv)} PTR
    {pd_CallErrHook}	callerrhook	:NATIVE {LONG    	    	    (*)(struct Hook *hook, union printerIO *ior, struct PrtErrMsg *pem)} PTR
    {pd_UnitNumber}	unitnumber	:ULONG
    {pd_DriverName}	drivername	:/*STRPTR*/ ARRAY OF CHAR
    {pd_PQuery}	pquery	:NATIVE {LONG    	    	    (*)(LONG *numofchars)} PTR
ENDOBJECT

NATIVE {pd_PIOR0}    	    	DEF
NATIVE {pd_SIOR0}    	    	DEF

NATIVE {pd_PIOR1}    	    	DEF
NATIVE {pd_SIOR1}    	    	DEF

/* Printer Class */

NATIVE {PPCB_GFX}	    	CONST PPCB_GFX	    	= 0
NATIVE {PPCF_GFX}	    	CONST PPCF_GFX	    	= $1
NATIVE {PPCB_COLOR}	    	CONST PPCB_COLOR	    	= 1
NATIVE {PPCF_COLOR}	    	CONST PPCF_COLOR	    	= $2

NATIVE {PPC_BWALPHA}	    	CONST PPC_BWALPHA	    	= $00
NATIVE {PPC_BWGFX}	    	CONST PPC_BWGFX	    	= $01
NATIVE {PPC_COLORALPHA}	    	CONST PPC_COLORALPHA	    	= $02
NATIVE {PPC_COLORGFX}	    	CONST PPC_COLORGFX	    	= $03

NATIVE {PPCB_EXTENDED}	    	CONST PPCB_EXTENDED	    	= 2
NATIVE {PPCF_EXTENDED}	    	CONST PPCF_EXTENDED	    	= $4

NATIVE {PPCB_NOSTRIP}	    	CONST PPCB_NOSTRIP	    	= 3
NATIVE {PPCF_NOSTRIP}	    	CONST PPCF_NOSTRIP	    	= $8

/* Color Class */

NATIVE {PCC_BW}		    	CONST PCC_BW		    	= $01
NATIVE {PCC_YMC}		    	CONST PCC_YMC		    	= $02
NATIVE {PCC_YMC_BW}	    	CONST PCC_YMC_BW	    	= $03
NATIVE {PCC_YMCB}	    	CONST PCC_YMCB	    	= $04
NATIVE {PCC_4COLOR}	    	CONST PCC_4COLOR	    	= $04
NATIVE {PCC_ADDITIVE}	    	CONST PCC_ADDITIVE	    	= $08
NATIVE {PCC_WB}		    	CONST PCC_WB		    	= $09
NATIVE {PCC_BGR}		    	CONST PCC_BGR		    	= $0A
NATIVE {PCC_BGR_WB}	    	CONST PCC_BGR_WB	    	= $0B
NATIVE {PCC_BGRW}	    	CONST PCC_BGRW	    	= $0C
NATIVE {PCC_MULTI_PASS}	    	CONST PCC_MULTI_PASS	    	= $10

NATIVE {PrinterExtendedData} OBJECT printerextendeddata
    {ped_PrinterName}	printername	:ARRAY OF CHAR
    {ped_Init}	init	:NATIVE {VOID    	    (*)(struct PrinterData *pd)} PTR
    {ped_Expunge}	expunge	:NATIVE {VOID    	    (*)(VOID)} PTR
    {ped_Open}	open	:NATIVE {LONG    	    (*)(union printerIO *ior)} PTR
    {ped_Close}	close	:NATIVE {VOID    	    (*)(union printerIO *ior)} PTR
    {ped_PrinterClass}	printerclass	:UBYTE
    {ped_ColorClass}	colorclass	:UBYTE
    {ped_MaxColumns}	maxcolumns	:UBYTE
    {ped_NumCharSets}	numcharsets	:UBYTE
    {ped_NumRows}	numrows	:UINT
    {ped_MaxXDots}	maxxdots	:ULONG
    {ped_MaxYDots}	maxydots	:ULONG
    {ped_XDotsInch}	xdotsinch	:UINT
    {ped_YDotsInch}	ydotsinch	:UINT
    {ped_Commands}	commands	:ARRAY OF ARRAY OF /*STRPTR*/ ARRAY /*OF CHAR*/
    {ped_DoSpecial}	dospecial	:NATIVE {LONG    	    (*)(UWORD *command, UBYTE output_buffer[], BYTE *current_line_position, BYTE *current_line_spacing, BYTE *crlf_flag, UBYTE params[])} PTR
    {ped_Render}	render	:NATIVE {LONG    	    (*)(LONG ct, LONG x, LONG y, LONG status)} PTR
    {ped_TimeoutSecs}	timeoutsecs	:VALUE
    {ped_8BitChars}	x8bitchars	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
    {ped_PrintMode}	printmode	:VALUE
    {ped_ConvFunc}	convfunv	:NATIVE {LONG    	    (*)(UBYTE *buf, UBYTE c, LONG crlf_flag)} PTR
    {ped_TagList}	taglist	:ARRAY OF tagitem
    {ped_DoPreferences}	dopreferences	:NATIVE {LONG    	    (*)(union printerIO *ior, LONG command)} PTR
    {ped_CallErrHook}	callerrhook	:NATIVE {VOID    	    (*)(union printerIO *ior, struct Hook *hook)} PTR
ENDOBJECT

/* Tags to define more printer driver features */

NATIVE {PRTA_Dummy}  	    	CONST PRTA_DUMMY  	    	= (TAG_USER + $50000)
NATIVE {PRTA_8BitGuns}		CONST PRTA_8BITGUNS		= (PRTA_DUMMY + 1)
NATIVE {PRTA_ConvertSource}	CONST PRTA_CONVERTSOURCE	= (PRTA_DUMMY + 2)
NATIVE {PRTA_FloydDithering}	CONST PRTA_FLOYDDITHERING	= (PRTA_DUMMY + 3)
NATIVE {PRTA_AntiAlias}		CONST PRTA_ANTIALIAS		= (PRTA_DUMMY + 4)
NATIVE {PRTA_ColorCorrection}	CONST PRTA_COLORCORRECTION	= (PRTA_DUMMY + 5)
NATIVE {PRTA_NoIO}		CONST PRTA_NOIO		= (PRTA_DUMMY + 6)
NATIVE {PRTA_NewColor}		CONST PRTA_NEWCOLOR		= (PRTA_DUMMY + 7)
NATIVE {PRTA_ColorSize}		CONST PRTA_COLORSIZE		= (PRTA_DUMMY + 8)
NATIVE {PRTA_NoScaling}		CONST PRTA_NOSCALING		= (PRTA_DUMMY + 9)

/* User interface */
NATIVE {PRTA_DitherNames}	CONST PRTA_DITHERNAMES	= (PRTA_DUMMY + 20)
NATIVE {PRTA_ShadingNames}	CONST PRTA_SHADINGNAMES	= (PRTA_DUMMY + 21)
NATIVE {PRTA_ColorCorrect}	CONST PRTA_COLORCORRECT	= (PRTA_DUMMY + 22)
NATIVE {PRTA_DensityInfo}	CONST PRTA_DENSITYINFO	= (PRTA_DUMMY + 23)

/* Hardware page borders */
NATIVE {PRTA_LeftBorder}		CONST PRTA_LEFTBORDER		= (PRTA_DUMMY + 30)
NATIVE {PRTA_TopBorder}		CONST PRTA_TOPBORDER		= (PRTA_DUMMY + 31)

NATIVE {PRTA_MixBWColor}		CONST PRTA_MIXBWCOLOR		= (PRTA_DUMMY + 32)

/* Driver Preferences */
NATIVE {PRTA_Preferences}	CONST PRTA_PREFERENCES	= (PRTA_DUMMY + 40)

/****************************************************************************/

NATIVE {PrinterSegment} OBJECT printersegment
    {ps_NextSegment}	nextsegment	:BPTR
    {ps_runAlert}	runalert	:ULONG
    {ps_Version}	version	:UINT
    {ps_Revision}	revision	:UINT
    {ps_PED}	ped	:printerextendeddata	
ENDOBJECT

/****************************************************************************/

NATIVE {PrtDriverPreferences} OBJECT prtdriverpreferences
    {pdp_Version}	version	:UINT
    {pdp_PrinterID}	printerid[32]	:ARRAY OF UBYTE
    {pdp_PrefName}	prefname[FILENAME_SIZE-16]	:ARRAY OF CHAR
    {pdp_Length}	length	:ULONG    	/* size of this structure */

    /* .. more driver private fields following .. */
ENDOBJECT
