OPT MODULE
OPT PREPROCESS
OPT EXPORT

/*
**      $Filename: libraries/swazblanker.h $
**      $Release: 2.12 $
**      $Revision: 42.0 $
**
**	SwazBlanker definitions
**
**	(C) Copyright 1993-94 David Swasbrook
**	    All Rights Reserved
**
**	Quick conversion to AmigaE
**	by Krzysztof Cmok
*/

#define TAG_USER		$80000000
#define SWAZBLANKERNAME		'swazblanker.library'
#define SB_TagBase		TAG_USER+$80000

/*****************************************************************************
   This structure is for messages to the SBPort
 */

OBJECT sbmessage
	message:PTR TO LONG		/* struct Message * */
	type:PTR TO LONG		/* See below for message types */
	data:PTR TO LONG		/* Specific for type */
	result:PTR TO LONG		/* Result */
ENDOBJECT

#define SBMSG_PING			0
#define SBMSG_BECOMEBLANKER		1
#define SBMSG_BECOMEBLANKER_END		2

/*****************************************************************************
   This structure is returned by SB_BlankerInfo()
 */

OBJECT blankerinfo
	node:PTR TO LONG		/* (node struct) So you can link it into a list if you like */
	version:INT			/* Version of blanker module */
	revision:INT			/* Revision of blanker module */
	shortdesc:PTR TO CHAR		/* breif description */
	longDesc:PTR TO CHAR		/* information buffer */
	author:PTR TO CHAR		/* authors name */
	email:PTR TO CHAR		/* email address */
	time:PTR TO CHAR		/* Compilation date/time */
	stack:LONG			/* recommended stack size */
	kickstart:LONG			/* minimum kickstart required */
	cpu:LONG			/* cpu */
	loading:LONG

	/*** Private fields follow ***/
	pool:PTR TO LONG		/* Pool stuff */
ENDOBJECT

/*****************************************************************************
   This structure is returned by SB_OpenColorCycleTagList()
   Structure is PRIVATE!
 */

OBJECT sbcolorcyc
	flags:PTR TO LONG
	diesig:PTR TO CHAR
	screen:PTR TO LONG	/* struct Screen */
	viewport:PTR TO LONG    /* struct Viewport */
	colortask:PTR TO LONG	/* Task struct */
	creatortask:PTR TO LONG /* -"- */
	private:PTR TO LONG
ENDOBJECT

/*****************************************************************************
   This structure is returned by SB_OpenCopperTagList()
   Structure is PRIVATE!
 */
#define	SB_MINCOPPER	30
#define	SB_MAXCOPPER	200

OBJECT sbcopper
	diesig:PTR TO CHAR
	pen:PTR TO CHAR
	coloradd:PTR TO CHAR
	colorremove:PTR TO CHAR
	color[3]:ARRAY OF CHAR
	pad:PTR TO CHAR
	spacing:INT
	spectrumlength:INT
	yoffset:INT
	screen:PTR TO LONG	/* screen struct */
	coppertask:PTR TO LONG  /* task struct */
	creatortask:PTR TO LONG /* task struct */
	viewport:PTR TO LONG	/* viewport struct */
	ucoplist:PTR TO LONG    /* ucoplist struct */

	speed:INT
	currlev:INT

	ystart:INT
	ystop:INT

	/* Raw data follows ... */
	spectrum[400]:ARRAY OF LONG
ENDOBJECT

/*****************************************************************************
   This structure is returned by SB_AddPrefsTaskTagList()
 */

OBJECT blankerprefsnode
	node:PTR TO LONG		/* Standard exec node (node struct) */
	task:PTR TO LONG		/* Pointer to prefs task (task struct) */
	window:PTR TO LONG		/* Pointer to window owned by prefs task (window struct) */
	sbhelp:PTR TO LONG		/* Pointer returned by SB_HelpTagList() */
ENDOBJECT

/*****************************************************************************
    Mode values for SB_LockSBBase() and SB_UnLockSBBase().
 */
#define SBLOCK_READ		0
#define SBLOCK_WRITE		1

/*****************************************************************************
    Tag values for SB_SetBaseVarTagList() and SB_GetBaseVarTagList().
 */

#define SBBV_ObtainSemaphore	SB_TagBase+0x01
#define SBBV_FontInfo		SB_TagBase+0x02
#define SBBV_PrefsWindow	SB_TagBase+$03
#define SBBV_BlankerPath	SB_TagBase+$04
#define SBBV_BlankerTaskPri	SB_TagBase+$06
#define SBBV_NumberOfPrefsTasks SB_TagBase+$07
#define SBBV_TimeString		SB_TagBase+$08


/*****************************************************************************
    Tag values for SB_BlankerInfoTagList();
 */

#define SBBI_Buffer		SB_TagBase+$100

/*****************************************************************************
    Tag values for SB_HelpTagList();
 */
#define SBHELP_BlankerPrefs	SB_TagBase+$101
#define SBHELP_Directory	SB_TagBase+$102

#define SBHELPDIR_SYS		0	/* Dir for main help files etc... */
#define SBHELPDIR_BLANKERS	1	/* Directory for blanker help files */

/*****************************************************************************
    Tag values for SB_OpenCopperTagList() and SB_SerCopperTagList().
 */

#define SBCOPPER_RandomiseColors	SB_TagBase+$201	/* Randomise the colors being used */
#define SBCOPPER_YStart			SB_TagBase+$202	/* First line of copper */
#define SBCOPPER_YStop			SB_TagBase+$203	/* Last line of copper */
#define SBCOPPER_Disabled		SB_TagBase+$204	/* Set to TRUE to turn effect off */
#define SBCOPPER_ScanLinesPerColor	SB_TagBase+$205	/* How many scanlines before color change */
#define SBCOPPER_Speed			SB_TagBase+$206	/* How far copper should move in scanlines/vnblank */
#define SBCOPPER_Pen			SB_TagBase+$207	/* Pen to use for copper effect */


/*****************************************************************************
   Structure returned by SB_Init()
 */
OBJECT sbinit
	name:PTR TO CHAR                     /* Name of the module */
	catalog:PTR TO LONG                  /* Opened locale catalog (catalog struct)*/
	method:PTR TO LONG                   /* Invokation method (see below) */

	/* Private fields follow */
	oldprogdir:PTR TO CHAR
	oldcurrentdir:PTR TO CHAR
	namebuffer[32]:ARRAY OF CHAR
ENDOBJECT

	#define SBINIT_METHOD_NONE	0
	#define SBINIT_METHOD_PREFS	1
	#define SBINIT_METHOD_BLANK	2
	#define SBINIT_METHOD_INFO	3

/*****************************************************************************
    Tag values for SB_InitTagList().
 */

#define SBINIT_Name           SB_TagBase+$300    /* Name of module */

#define SBINFO_ShortDesc      SB_TagBase+$301    /* string for short info */
#define SBINFO_LongDesc       SB_TagBase+$302    /* string for long info */
#define SBINFO_CPU            SB_TagBase+$305    /* CPU Type required */
#define SBINFO_CPULoading     SB_TagBase+$306    /* CPU Loading level (see below) */
#define SBINFO_Stack          SB_TagBase+$307    /* Stack required */
#define SBINFO_EMail          SB_TagBase+$308    /* EMail address of author */
#define SBINFO_Author         SB_TagBase+$309    /* Name of author */
#define SBINFO_Kickstart      SB_TagBase+$30A    /* Minimum kickstart version */
#define SBINFO_Version        SB_TagBase+$30B    /* Version */
#define SBINFO_Revision       SB_TagBase+$30C    /* Revision */
#define SBINFO_Time           SB_TagBase+$30D    /* Compilation time */

#define SBINFOLOAD_NONE		0
#define SBINFOLOAD_LOW		1
#define SBINFOLOAD_LOWMED	2
#define SBINFOLOAD_MEDIUM	3
#define SBINFOLOAD_MEDHIGH	4
#define SBINFOLOAD_HIGH		5

#define SBDEF_KICKSTART		39
#define SBDEF_STACK		4096
#define SBDEF_CPU		68000
#define SBDEF_CPULOAD		SBINFOLOAD_LOW

/*****************************************************************************
    Tag values for SB_BlankNotifyTagList().
 */

#define SBNOTIFY_Task		SB_TagBase+$400    /* Task to signal */
#define SBNOTIFY_BlankSigMask	SB_TagBase+$401    /* Mask of signals to set */
#define SBNOTIFY_UnBlankSigMask	SB_TagBase+$402    /* Mask of signals to set */

