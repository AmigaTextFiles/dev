/* $VER: inputevent.h 36.10 (26.6.1992) */
OPT NATIVE
MODULE 'target/devices/timer', 'target/utility/hooks', 'target/utility/tagitem'
MODULE 'target/intuition/screens', 'target/exec/types'
{MODULE 'devices/inputevent'}

/*----- constants --------------------------------------------------*/

/*  --- InputEvent.ie_Class --- */
/* A NOP input event */
NATIVE {IECLASS_NULL}			CONST IECLASS_NULL			= $00
/* A raw keycode from the keyboard device */
NATIVE {IECLASS_RAWKEY}			CONST IECLASS_RAWKEY			= $01
/* The raw mouse report from the game port device */
NATIVE {IECLASS_RAWMOUSE}		CONST IECLASS_RAWMOUSE		= $02
/* A private console event */
NATIVE {IECLASS_EVENT}			CONST IECLASS_EVENT			= $03
/* A Pointer Position report */
NATIVE {IECLASS_POINTERPOS}		CONST IECLASS_POINTERPOS		= $04
/* A timer event */
NATIVE {IECLASS_TIMER}			CONST IECLASS_TIMER			= $06
/* select button pressed down over a Gadget (address in ie_EventAddress) */
NATIVE {IECLASS_GADGETDOWN}		CONST IECLASS_GADGETDOWN		= $07
/* select button released over the same Gadget (address in ie_EventAddress) */
NATIVE {IECLASS_GADGETUP}		CONST IECLASS_GADGETUP		= $08
/* some Requester activity has taken place.  See Codes REQCLEAR and REQSET */
NATIVE {IECLASS_REQUESTER}		CONST IECLASS_REQUESTER		= $09
/* this is a Menu Number transmission (Menu number is in ie_Code) */
NATIVE {IECLASS_MENULIST}		CONST IECLASS_MENULIST		= $0A
/* User has selected the active Window's Close Gadget */
NATIVE {IECLASS_CLOSEWINDOW}		CONST IECLASS_CLOSEWINDOW		= $0B
/* this Window has a new size */
NATIVE {IECLASS_SIZEWINDOW}		CONST IECLASS_SIZEWINDOW		= $0C
/* the Window pointed to by ie_EventAddress needs to be refreshed */
NATIVE {IECLASS_REFRESHWINDOW}		CONST IECLASS_REFRESHWINDOW		= $0D
/* new preferences are available */
NATIVE {IECLASS_NEWPREFS}		CONST IECLASS_NEWPREFS		= $0E
/* the disk has been removed */
NATIVE {IECLASS_DISKREMOVED}		CONST IECLASS_DISKREMOVED		= $0F
/* the disk has been inserted */
NATIVE {IECLASS_DISKINSERTED}		CONST IECLASS_DISKINSERTED		= $10
/* the window is about to be been made active */
NATIVE {IECLASS_ACTIVEWINDOW}		CONST IECLASS_ACTIVEWINDOW		= $11
/* the window is about to be made inactive */
NATIVE {IECLASS_INACTIVEWINDOW}		CONST IECLASS_INACTIVEWINDOW		= $12
/* extended-function pointer position report (V36) */
NATIVE {IECLASS_NEWPOINTERPOS}		CONST IECLASS_NEWPOINTERPOS		= $13
/* Help key report during Menu session (V36) */
NATIVE {IECLASS_MENUHELP}		CONST IECLASS_MENUHELP		= $14
/* the Window has been modified with move, size, zoom, or change (V36) */
NATIVE {IECLASS_CHANGEWINDOW}		CONST IECLASS_CHANGEWINDOW		= $15

/* the last class */
NATIVE {IECLASS_MAX}			CONST IECLASS_MAX			= $15


/*  --- InputEvent.ie_SubClass --- */
/*  IECLASS_NEWPOINTERPOS */
/*	like IECLASS_POINTERPOS */
NATIVE {IESUBCLASS_COMPATIBLE}	CONST IESUBCLASS_COMPATIBLE	= $00
/*	ie_EventAddress points to struct IEPointerPixel */
NATIVE {IESUBCLASS_PIXEL}	CONST IESUBCLASS_PIXEL	= $01
/*	ie_EventAddress points to struct IEPointerTablet */
NATIVE {IESUBCLASS_TABLET}	CONST IESUBCLASS_TABLET	= $02
/*	ie_EventAddress points to struct IENewTablet */
NATIVE {IESUBCLASS_NEWTABLET}	   CONST IESUBCLASS_NEWTABLET	   = $03

NATIVE {iepointerpixel} OBJECT iepointerpixel
    {screen}	screen	:PTR TO screen	/* pointer to an open screen */
    				/* pixel coordinates in iepp_Screen */
	{positionx}	positionx	:INT
	{positiony}	positiony	:INT
ENDOBJECT

NATIVE {iepointertablet} OBJECT iepointertablet
	{rangex}	rangex	:UINT
	{rangey}	rangey	:UINT
    	/* 0 is min, these are max	*/
	{valuex}	valuex	:UINT
	{valuey}	valuey	:UINT
    	/* between 0 and iept_Range	*/

    {pressure}	pressure	:INT	/* -128 to 127 (unused, set to 0)  */
ENDOBJECT


NATIVE {ienewtablet} OBJECT ienewtablet
    {callback}	callback	:PTR TO hook

    {scaledx}	scaledx	:UINT
	{scaledy}	scaledy	:UINT
    {scaledxfraction}	scaledxfraction	:UINT
	{scaledyfraction}	scaledyfraction	:UINT

    {tabletx}	tabletx	:ULONG
	{tablety}	tablety	:ULONG

    {rangex}	rangex	:ULONG
	{rangey}	rangey	:ULONG

    {taglist}	taglist	:ARRAY OF tagitem
ENDOBJECT


/*  --- InputEvent.ie_Code --- */
/*  IECLASS_RAWKEY */
NATIVE {IECODE_UP_PREFIX}		CONST IECODE_UP_PREFIX		= $80
NATIVE {IECODE_KEY_CODE_FIRST}		CONST IECODE_KEY_CODE_FIRST		= $00
NATIVE {IECODE_KEY_CODE_LAST}		CONST IECODE_KEY_CODE_LAST		= $77
NATIVE {IECODE_COMM_CODE_FIRST}		CONST IECODE_COMM_CODE_FIRST		= $78
NATIVE {IECODE_COMM_CODE_LAST}		CONST IECODE_COMM_CODE_LAST		= $7F

/*  IECLASS_ANSI */
NATIVE {IECODE_C0_FIRST}			CONST IECODE_C0_FIRST			= $00
NATIVE {IECODE_C0_LAST}			CONST IECODE_C0_LAST			= $1F
NATIVE {IECODE_ASCII_FIRST}		CONST IECODE_ASCII_FIRST		= $20
NATIVE {IECODE_ASCII_LAST}		CONST IECODE_ASCII_LAST		= $7E
NATIVE {IECODE_ASCII_DEL}		CONST IECODE_ASCII_DEL		= $7F
NATIVE {IECODE_C1_FIRST}			CONST IECODE_C1_FIRST			= $80
NATIVE {IECODE_C1_LAST}			CONST IECODE_C1_LAST			= $9F
NATIVE {IECODE_LATIN1_FIRST}		CONST IECODE_LATIN1_FIRST		= $A0
NATIVE {IECODE_LATIN1_LAST}		CONST IECODE_LATIN1_LAST		= $FF

/*  IECLASS_RAWMOUSE */
NATIVE {IECODE_LBUTTON}			CONST IECODE_LBUTTON			= $68	/* also uses IECODE_UP_PREFIX */
NATIVE {IECODE_RBUTTON}			CONST IECODE_RBUTTON			= $69
NATIVE {IECODE_MBUTTON}			CONST IECODE_MBUTTON			= $6A
NATIVE {IECODE_NOBUTTON}			CONST IECODE_NOBUTTON			= $FF

/*  IECLASS_EVENT (V36) */
NATIVE {IECODE_NEWACTIVE}		CONST IECODE_NEWACTIVE		= $01	/* new active input window */
NATIVE {IECODE_NEWSIZE}			CONST IECODE_NEWSIZE			= $02	/* resize of window */
NATIVE {IECODE_REFRESH}			CONST IECODE_REFRESH			= $03	/* refresh of window */

/*  IECLASS_REQUESTER */
/*	broadcast when the first Requester (not subsequent ones) opens up in */
/*	the Window */
NATIVE {IECODE_REQSET}			CONST IECODE_REQSET			= $01
/*	broadcast when the last Requester clears out of the Window */
NATIVE {IECODE_REQCLEAR}			CONST IECODE_REQCLEAR			= $00



/*  --- InputEvent.ie_Qualifier --- */
NATIVE {IEQUALIFIER_LSHIFT}		CONST IEQUALIFIER_LSHIFT		= $0001
NATIVE {IEQUALIFIER_RSHIFT}		CONST IEQUALIFIER_RSHIFT		= $0002
NATIVE {IEQUALIFIER_CAPSLOCK}		CONST IEQUALIFIER_CAPSLOCK		= $0004
NATIVE {IEQUALIFIER_CONTROL}		CONST IEQUALIFIER_CONTROL		= $0008
NATIVE {IEQUALIFIER_LALT}		CONST IEQUALIFIER_LALT		= $0010
NATIVE {IEQUALIFIER_RALT}		CONST IEQUALIFIER_RALT		= $0020
NATIVE {IEQUALIFIER_LCOMMAND}		CONST IEQUALIFIER_LCOMMAND		= $0040
NATIVE {IEQUALIFIER_RCOMMAND}		CONST IEQUALIFIER_RCOMMAND		= $0080
NATIVE {IEQUALIFIER_NUMERICPAD}		CONST IEQUALIFIER_NUMERICPAD		= $0100
NATIVE {IEQUALIFIER_REPEAT}		CONST IEQUALIFIER_REPEAT		= $0200
NATIVE {IEQUALIFIER_INTERRUPT}		CONST IEQUALIFIER_INTERRUPT		= $0400
NATIVE {IEQUALIFIER_MULTIBROADCAST}	CONST IEQUALIFIER_MULTIBROADCAST	= $0800
NATIVE {IEQUALIFIER_MIDBUTTON}		CONST IEQUALIFIER_MIDBUTTON		= $1000
NATIVE {IEQUALIFIER_RBUTTON}		CONST IEQUALIFIER_RBUTTON		= $2000
NATIVE {IEQUALIFIER_LEFTBUTTON}		CONST IEQUALIFIER_LEFTBUTTON		= $4000
NATIVE {IEQUALIFIER_RELATIVEMOUSE}	CONST IEQUALIFIER_RELATIVEMOUSE	= $8000

NATIVE {IEQUALIFIERB_LSHIFT}		CONST IEQUALIFIERB_LSHIFT		= 0
NATIVE {IEQUALIFIERB_RSHIFT}		CONST IEQUALIFIERB_RSHIFT		= 1
NATIVE {IEQUALIFIERB_CAPSLOCK}		CONST IEQUALIFIERB_CAPSLOCK		= 2
NATIVE {IEQUALIFIERB_CONTROL}		CONST IEQUALIFIERB_CONTROL		= 3
NATIVE {IEQUALIFIERB_LALT}		CONST IEQUALIFIERB_LALT		= 4
NATIVE {IEQUALIFIERB_RALT}		CONST IEQUALIFIERB_RALT		= 5
NATIVE {IEQUALIFIERB_LCOMMAND}		CONST IEQUALIFIERB_LCOMMAND		= 6
NATIVE {IEQUALIFIERB_RCOMMAND}		CONST IEQUALIFIERB_RCOMMAND		= 7
NATIVE {IEQUALIFIERB_NUMERICPAD}		CONST IEQUALIFIERB_NUMERICPAD		= 8
NATIVE {IEQUALIFIERB_REPEAT}		CONST IEQUALIFIERB_REPEAT		= 9
NATIVE {IEQUALIFIERB_INTERRUPT}		CONST IEQUALIFIERB_INTERRUPT		= 10
NATIVE {IEQUALIFIERB_MULTIBROADCAST}	CONST IEQUALIFIERB_MULTIBROADCAST	= 11
NATIVE {IEQUALIFIERB_MIDBUTTON}		CONST IEQUALIFIERB_MIDBUTTON		= 12
NATIVE {IEQUALIFIERB_RBUTTON}		CONST IEQUALIFIERB_RBUTTON		= 13
NATIVE {IEQUALIFIERB_LEFTBUTTON}		CONST IEQUALIFIERB_LEFTBUTTON		= 14
NATIVE {IEQUALIFIERB_RELATIVEMOUSE}	CONST IEQUALIFIERB_RELATIVEMOUSE	= 15

/*----- InputEvent -------------------------------------------------*/

NATIVE {inputevent} OBJECT inputevent
    {nextevent}	nextevent	:PTR TO inputevent	/* the chronologically next event */
    {class}	class	:UBYTE			/* the input event class */
    {subclass}	subclass	:UBYTE		/* optional subclass of the class */
    {code}	code	:UINT			/* the input event code */
    {qualifier}	qualifier	:UINT		/* qualifiers in effect for the event*/
    {x}	x	:INT		/* the pointer position for the event*/
    {y}	y	:INT
	{eventaddress}	eventaddress	:APTR		/* the event address */
    {prev1downcode}	prev1downcode	:UBYTE	/* previous down keys for dead */
    {prev1downqual}	prev1downqual	:UBYTE	/*   key translation: the ie_Code */
    {prev2downcode}	prev2downcode	:UBYTE	/*   & low byte of ie_Qualifier for */
    {prev2downqual}	prev2downqual	:UBYTE	/*   last & second last down keys */
    {timestamp}	timestamp	:timeval	/* the system tick at the event */
ENDOBJECT
