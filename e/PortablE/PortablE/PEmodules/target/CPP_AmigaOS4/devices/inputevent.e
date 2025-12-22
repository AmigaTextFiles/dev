/* $Id: inputevent.h,v 1.16 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/devices/timer', 'target/utility/hooks', 'target/utility/tagitem'
MODULE 'target/intuition/screens', 'target/exec/types'
{#include <devices/inputevent.h>}
NATIVE {DEVICES_INPUTEVENT_H} CONST

/*----- constants --------------------------------------------------*/

/*  --- InputEvent.ie_Class --- */
NATIVE {IECLASS_NULL}           CONST IECLASS_NULL           = $00 /* A NOP input event */
NATIVE {IECLASS_RAWKEY}         CONST IECLASS_RAWKEY         = $01 /* A raw keycode from the keyboard device */
NATIVE {IECLASS_RAWMOUSE}       CONST IECLASS_RAWMOUSE       = $02 /* The raw mouse report from the game port
                                       device */
NATIVE {IECLASS_EVENT}          CONST IECLASS_EVENT          = $03 /* A private console event */
NATIVE {IECLASS_POINTERPOS}     CONST IECLASS_POINTERPOS     = $04 /* A Pointer Position report */
NATIVE {IECLASS_TIMER}          CONST IECLASS_TIMER          = $06 /* A timer event */
NATIVE {IECLASS_GADGETDOWN}     CONST IECLASS_GADGETDOWN     = $07 /* select button pressed down over a Gadget
                                       (address in ie_EventAddress) */
NATIVE {IECLASS_GADGETUP}       CONST IECLASS_GADGETUP       = $08 /* select button released over the same
                                       Gadget (address in ie_EventAddress) */
NATIVE {IECLASS_REQUESTER}      CONST IECLASS_REQUESTER      = $09 /* some Requester activity has taken place.
                                       See Codes REQCLEAR and REQSET */
NATIVE {IECLASS_MENULIST}       CONST IECLASS_MENULIST       = $0A /* this is a Menu Number transmission
                                       (Menu number is in ie_Code) */
NATIVE {IECLASS_CLOSEWINDOW}    CONST IECLASS_CLOSEWINDOW    = $0B /* User has selected the active Window's
                                       Close Gadget */
NATIVE {IECLASS_SIZEWINDOW}     CONST IECLASS_SIZEWINDOW     = $0C /* this Window has a new size */
NATIVE {IECLASS_REFRESHWINDOW}  CONST IECLASS_REFRESHWINDOW  = $0D /* the Window pointed to by ie_EventAddress
                                       needs to be refreshed */
NATIVE {IECLASS_NEWPREFS}       CONST IECLASS_NEWPREFS       = $0E /* new preferences are available */
NATIVE {IECLASS_DISKREMOVED}    CONST IECLASS_DISKREMOVED    = $0F /* the disk has been removed */
NATIVE {IECLASS_DISKINSERTED}   CONST IECLASS_DISKINSERTED   = $10 /* the disk has been inserted */
NATIVE {IECLASS_ACTIVEWINDOW}   CONST IECLASS_ACTIVEWINDOW   = $11 /* the window is about to be been made
                                       active */
NATIVE {IECLASS_INACTIVEWINDOW} CONST IECLASS_INACTIVEWINDOW = $12 /* the window is about to be made inactive */
NATIVE {IECLASS_NEWPOINTERPOS}  CONST IECLASS_NEWPOINTERPOS  = $13 /* extended-function pointer position
                                       report (V36) */
NATIVE {IECLASS_MENUHELP}       CONST IECLASS_MENUHELP       = $14 /* Help key report during Menu session (V36) */
NATIVE {IECLASS_CHANGEWINDOW}   CONST IECLASS_CHANGEWINDOW   = $15 /* the Window has been modified with move,
                                       size, zoom, or change (V36) */
NATIVE {IECLASS_RESERVED}       CONST IECLASS_RESERVED       = $16 /* reserved */
NATIVE {IECLASS_MOUSEWHEEL}     CONST IECLASS_MOUSEWHEEL     = $17 /* the mousewheel report from the gameport
                                       (V51) */
NATIVE {IECLASS_EXTENDEDRAWKEY} CONST IECLASS_EXTENDEDRAWKEY = $18 /* A 16bit raw keycode from the keyboard
                                       device (V51), see below for subclasses. */
NATIVE {IECLASS_MAX}            CONST IECLASS_MAX            = $18 /* the last class */


/*  --- InputEvent.ie_SubClass --- */
/*  IECLASS_NEWPOINTERPOS */
/*    like IECLASS_POINTERPOS */
NATIVE {IESUBCLASS_COMPATIBLE} CONST IESUBCLASS_COMPATIBLE = $00
/*    ie_EventAddress points to struct IEPointerPixel */
NATIVE {IESUBCLASS_PIXEL}      CONST IESUBCLASS_PIXEL      = $01
/*    ie_EventAddress points to struct IEPointerTablet */
NATIVE {IESUBCLASS_TABLET}     CONST IESUBCLASS_TABLET     = $02
/*    ie_EventAddress points to struct IENewTablet */
NATIVE {IESUBCLASS_NEWTABLET}  CONST IESUBCLASS_NEWTABLET  = $03

/*  IECLASS_EXTENDED_RAWKEY */
NATIVE {IESUBCLASS_AMIGA_RAWKEY}             CONST IESUBCLASS_AMIGA_RAWKEY             = $00
NATIVE {IESUBCLASS_SET1_RAWKEY}              CONST IESUBCLASS_SET1_RAWKEY              = $01
NATIVE {IESUBCLASS_HID_CONSUMER_DOWN_RAWKEY} CONST IESUBCLASS_HID_CONSUMER_DOWN_RAWKEY = $02
NATIVE {IESUBCLASS_HID_CONSUMER_UP_RAWKEY}   CONST IESUBCLASS_HID_CONSUMER_UP_RAWKEY   = $03


/* pointed to by ie_EventAddress for IECLASS_NEWPOINTERPOS,
 * and IESUBCLASS_PIXEL.
 *
 * You specify a screen and pixel coordinates in that screen
 * at which you'd like the mouse to be positioned.
 * Intuition will try to oblige, but there will be restrictions
 * to positioning the pointer over offscreen pixels.
 *
 * IEQUALIFIER_RELATIVEMOUSE is supported for IESUBCLASS_PIXEL.
 */

NATIVE {IEPointerPixel} OBJECT iepointerpixel
    {iepp_Screen}	screen	:PTR TO screen /* pointer to an open screen */
    {iepp_Position.X}	positionx	:INT                 /* pixel coordinates in iepp_Screen */
    {iepp_Position.Y}	positiony	:INT
ENDOBJECT

/* pointed to by ie_EventAddress for IECLASS_NEWPOINTERPOS,
 * and IESUBCLASS_TABLET.
 *
 * You specify a range of values and a value within the range
 * independently for each of X and Y (the minimum value of
 * the ranges is always normalized to 0).
 *
 * Intuition will position the mouse proportionally within its
 * natural mouse position rectangle limits.
 *
 * IEQUALIFIER_RELATIVEMOUSE is not supported for IESUBCLASS_TABLET.
 */
NATIVE {IEPointerTablet} OBJECT iepointertablet
    {iept_Range.X}	rangex	:UINT
    {iept_Range.Y}	rangey	:UINT
        /* 0 is min, these are max    */
    {iept_Value.X}	valuex	:UINT
    {iept_Value.Y}	valuey	:UINT
        /* between 0 and iept_Range    */
    {iept_Pressure}	pressure	:INT /* -128 to 127 (unused, set to 0)  */
ENDOBJECT


/* The ie_EventAddress of an IECLASS_NEWPOINTERPOS event of subclass
 * IESUBCLASS_NEWTABLET points at an IENewTablet structure.
 *
 *
 * IEQUALIFIER_RELATIVEMOUSE is not supported for IESUBCLASS_NEWTABLET.
 */

NATIVE {IENewTablet} OBJECT ienewtablet
    /* Pointer to a hook you wish to be called back through, in
     * order to handle scaling.  You will be provided with the
     * width and height you are expected to scale your tablet
     * to, perhaps based on some user preferences.
     * If NULL, the tablet's specified range will be mapped directly
     * to that width and height for you, and you will not be
     * called back.
     */
    {ient_CallBack}	callback	:PTR TO hook

    /* Post-scaling coordinates and fractional coordinates.
     * DO NOT FILL THESE IN AT THE TIME THE EVENT IS WRITTEN!
     * Your driver will be called back and provided information
     * about the width and height of the area to scale the
     * tablet into.  It should scale the tablet coordinates
     * (perhaps based on some preferences controlling aspect
     * ratio, etc.) and place the scaled result into these
     * fields.    The ient_ScaledX and ient_ScaledY fields are
     * in screen-pixel resolution, but the origin ( [0,0]-point )
     * is not defined.    The ient_ScaledXFraction and
     * ient_ScaledYFraction fields represent sub-pixel position
     * information, and should be scaled to fill a UWORD fraction.
     */
    {ient_ScaledX}	scaledx	:UINT
	{ient_ScaledY}	scaledy	:UINT
    {ient_ScaledXFraction}	scaledxfraction	:UINT
	{ient_ScaledYFraction}	scaledyfraction	:UINT

    /* Current tablet coordinates along each axis: */
    {ient_TabletX}	tabletx	:ULONG
	{ient_TabletY}	tablety	:ULONG

    /* Tablet range along each axis.  For example, if ient_TabletX
     * can take values 0-999, ient_RangeX should be 1000.
     */
    {ient_RangeX}	rangex	:ULONG
	{ient_RangeY}	rangey	:ULONG

    /* Pointer to tag-list of additional tablet attributes.
     * See <intuition/intuition.h> for the tag values.
     */
    {ient_TagList}	taglist	:ARRAY OF tagitem
ENDOBJECT


/*  --- InputEvent.ie_Code --- */
/*  IECLASS_RAWKEY */
NATIVE {IECODE_UP_PREFIX}       CONST IECODE_UP_PREFIX       = $80
NATIVE {IECODE_KEY_CODE_FIRST}  CONST IECODE_KEY_CODE_FIRST  = $00
NATIVE {IECODE_KEY_CODE_LAST}   CONST IECODE_KEY_CODE_LAST   = $77
NATIVE {IECODE_COMM_CODE_FIRST} CONST IECODE_COMM_CODE_FIRST = $78
NATIVE {IECODE_COMM_CODE_LAST}  CONST IECODE_COMM_CODE_LAST  = $7F

/*  IECLASS_ANSI */
NATIVE {IECODE_C0_FIRST}     CONST IECODE_C0_FIRST     = $00
NATIVE {IECODE_C0_LAST}      CONST IECODE_C0_LAST      = $1F
NATIVE {IECODE_ASCII_FIRST}  CONST IECODE_ASCII_FIRST  = $20
NATIVE {IECODE_ASCII_LAST}   CONST IECODE_ASCII_LAST   = $7E
NATIVE {IECODE_ASCII_DEL}    CONST IECODE_ASCII_DEL    = $7F
NATIVE {IECODE_C1_FIRST}     CONST IECODE_C1_FIRST     = $80
NATIVE {IECODE_C1_LAST}      CONST IECODE_C1_LAST      = $9F
NATIVE {IECODE_LATIN1_FIRST} CONST IECODE_LATIN1_FIRST = $A0
NATIVE {IECODE_LATIN1_LAST}  CONST IECODE_LATIN1_LAST  = $FF

/*  IECLASS_RAWMOUSE */
NATIVE {IECODE_LBUTTON}    CONST IECODE_LBUTTON    = $68 /* also uses IECODE_UP_PREFIX */
NATIVE {IECODE_RBUTTON}    CONST IECODE_RBUTTON    = $69
NATIVE {IECODE_MBUTTON}    CONST IECODE_MBUTTON    = $6A
NATIVE {IECODE_4TH_BUTTON} CONST IECODE_4TH_BUTTON = $7E /* also called 'side'  */
NATIVE {IECODE_5TH_BUTTON} CONST IECODE_5TH_BUTTON = $78 /* also called 'extra' */
NATIVE {IECODE_NOBUTTON}   CONST IECODE_NOBUTTON   = $FF

/*  IECLASS_EVENT (V36) */
NATIVE {IECODE_NEWACTIVE} CONST IECODE_NEWACTIVE = $01 /* new active input window */
NATIVE {IECODE_NEWSIZE}   CONST IECODE_NEWSIZE   = $02 /* resize of window */
NATIVE {IECODE_REFRESH}   CONST IECODE_REFRESH   = $03 /* refresh of window */

/*  IECLASS_REQUESTER */
/*    broadcast when the first Requester (not subsequent ones) opens up in */
/*    the Window */
NATIVE {IECODE_REQSET}   CONST IECODE_REQSET   = $01
/*    broadcast when the last Requester clears out of the Window */
NATIVE {IECODE_REQCLEAR} CONST IECODE_REQCLEAR = $00



/*  --- InputEvent.ie_Qualifier --- */
NATIVE {IEQUALIFIER_LSHIFT}           CONST IEQUALIFIER_LSHIFT           = $0001
NATIVE {IEQUALIFIER_RSHIFT}           CONST IEQUALIFIER_RSHIFT           = $0002
NATIVE {IEQUALIFIER_CAPSLOCK}         CONST IEQUALIFIER_CAPSLOCK         = $0004
NATIVE {IEQUALIFIER_CONTROL}          CONST IEQUALIFIER_CONTROL          = $0008
NATIVE {IEQUALIFIER_LALT}             CONST IEQUALIFIER_LALT             = $0010
NATIVE {IEQUALIFIER_RALT}             CONST IEQUALIFIER_RALT             = $0020
NATIVE {IEQUALIFIER_LCOMMAND}         CONST IEQUALIFIER_LCOMMAND         = $0040
NATIVE {IEQUALIFIER_RCOMMAND}         CONST IEQUALIFIER_RCOMMAND         = $0080
NATIVE {IEQUALIFIER_NUMERICPAD}       CONST IEQUALIFIER_NUMERICPAD       = $0100
NATIVE {IEQUALIFIER_REPEAT}           CONST IEQUALIFIER_REPEAT           = $0200
NATIVE {IEQUALIFIER_INTERRUPT}        CONST IEQUALIFIER_INTERRUPT        = $0400
NATIVE {IEQUALIFIER_MULTIBROADCAST}   CONST IEQUALIFIER_MULTIBROADCAST   = $0800
NATIVE {IEQUALIFIER_MIDBUTTON}        CONST IEQUALIFIER_MIDBUTTON        = $1000
NATIVE {IEQUALIFIER_RBUTTON}          CONST IEQUALIFIER_RBUTTON          = $2000
NATIVE {IEQUALIFIER_LEFTBUTTON}       CONST IEQUALIFIER_LEFTBUTTON       = $4000
NATIVE {IEQUALIFIER_RELATIVEMOUSE}    CONST IEQUALIFIER_RELATIVEMOUSE    = $8000

NATIVE {IEQUALIFIERB_LSHIFT}          CONST IEQUALIFIERB_LSHIFT          = 0
NATIVE {IEQUALIFIERB_RSHIFT}          CONST IEQUALIFIERB_RSHIFT          = 1
NATIVE {IEQUALIFIERB_CAPSLOCK}        CONST IEQUALIFIERB_CAPSLOCK        = 2
NATIVE {IEQUALIFIERB_CONTROL}         CONST IEQUALIFIERB_CONTROL         = 3
NATIVE {IEQUALIFIERB_LALT}            CONST IEQUALIFIERB_LALT            = 4
NATIVE {IEQUALIFIERB_RALT}            CONST IEQUALIFIERB_RALT            = 5
NATIVE {IEQUALIFIERB_LCOMMAND}        CONST IEQUALIFIERB_LCOMMAND        = 6
NATIVE {IEQUALIFIERB_RCOMMAND}        CONST IEQUALIFIERB_RCOMMAND        = 7
NATIVE {IEQUALIFIERB_NUMERICPAD}      CONST IEQUALIFIERB_NUMERICPAD      = 8
NATIVE {IEQUALIFIERB_REPEAT}          CONST IEQUALIFIERB_REPEAT          = 9
NATIVE {IEQUALIFIERB_INTERRUPT}      CONST IEQUALIFIERB_INTERRUPT      = 10
NATIVE {IEQUALIFIERB_MULTIBROADCAST} CONST IEQUALIFIERB_MULTIBROADCAST = 11
NATIVE {IEQUALIFIERB_MIDBUTTON}      CONST IEQUALIFIERB_MIDBUTTON      = 12
NATIVE {IEQUALIFIERB_RBUTTON}        CONST IEQUALIFIERB_RBUTTON        = 13
NATIVE {IEQUALIFIERB_LEFTBUTTON}     CONST IEQUALIFIERB_LEFTBUTTON     = 14
NATIVE {IEQUALIFIERB_RELATIVEMOUSE}  CONST IEQUALIFIERB_RELATIVEMOUSE  = 15

/*----- InputEvent -------------------------------------------------*/

NATIVE {InputEvent} OBJECT inputevent
    {ie_NextEvent}	nextevent	:PTR TO inputevent /* the chronologically next event */
    {ie_Class}	class	:UBYTE     /* the input event class */
    {ie_SubClass}	subclass	:UBYTE  /* optional subclass of the class */
    {ie_Code}	code	:UINT      /* the input event code */
    {ie_Qualifier}	qualifier	:UINT /* qualifiers in effect for the event*/
    {ie_position.ie_xy.ie_x}	x	:INT               /* the pointer position for the event*/
    {ie_position.ie_xy.ie_y}	y	:INT
    {ie_position.ie_addr}	eventaddress	:APTR          /* the event address */
    {ie_position.ie_dead.ie_prev1DownCode}	prev1downcode	:UBYTE  /* previous down keys for dead */
    {ie_position.ie_dead.ie_prev1DownQual}	prev1downqual	:UBYTE  /*   key translation: the ie_Code */
    {ie_position.ie_dead.ie_prev2DownCode}	prev2downcode	:UBYTE  /*   & low byte of ie_Qualifier for */
    {ie_position.ie_dead.ie_prev2DownQual}	prev2downqual	:UBYTE  /*   last & second last down keys */
    {ie_TimeStamp}	timestamp	:timeval /* the system tick at the event */
ENDOBJECT

NATIVE {ie_X}             CONST
NATIVE {ie_Y}             CONST
NATIVE {ie_EventAddress}  CONST
NATIVE {ie_Prev1DownCode} CONST
NATIVE {ie_Prev1DownQual} CONST
NATIVE {ie_Prev2DownCode} CONST
NATIVE {ie_Prev2DownQual} CONST

/*----- ExtendedDeadKey -------------------------------------------------*/

NATIVE {ExtendedDeadKey} OBJECT extendeddeadkey
    {Reserved}	reserved	:ULONG
    {Prev1DownClass}	prev1downclass	:UINT
    {Prev1DownCode}	prev1downcode	:UINT
    {Prev1DownQual}	prev1downqual	:UINT
    {Prev2DownClass}	prev2downclass	:UINT
    {Prev2DownCode}	prev2downcode	:UINT
    {Prev2DownQual}	prev2downqual	:UINT
ENDOBJECT
