@DATABASE "gg:doc/NDK/Guide/Include/devices/inputevent.h"
@MASTER   "gg:os-include/devices/inputevent.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:26
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/inputevent.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/inputevent.h" LINK File}


@{b}Structures@{ub}

@{"IENewTablet" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 138}  @{"IEPointerPixel" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 97}  @{"IEPointerTablet" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 117}  @{"InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257}


@{b}#defines@{ub}

@{"ie_EventAddress" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 281}              @{"ie_Prev1DownCode" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 282}
@{"ie_Prev1DownQual" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 283}             @{"ie_Prev2DownCode" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 284}
@{"ie_Prev2DownQual" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 285}             @{"ie_X" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 279}
@{"ie_Y" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 280}                         @{"IECLASS_ACTIVEWINDOW" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 61}
@{"IECLASS_CHANGEWINDOW" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 69}         @{"IECLASS_CLOSEWINDOW" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 49}
@{"IECLASS_DISKINSERTED" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 59}         @{"IECLASS_DISKREMOVED" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 57}
@{"IECLASS_EVENT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 35}                @{"IECLASS_GADGETDOWN" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 41}
@{"IECLASS_GADGETUP" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 43}             @{"IECLASS_INACTIVEWINDOW" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 63}
@{"IECLASS_MAX" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 72}                  @{"IECLASS_MENUHELP" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 67}
@{"IECLASS_MENULIST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 47}             @{"IECLASS_NEWPOINTERPOS" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 65}
@{"IECLASS_NEWPREFS" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 55}             @{"IECLASS_NULL" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 29}
@{"IECLASS_POINTERPOS" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 37}           @{"IECLASS_RAWKEY" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 31}
@{"IECLASS_RAWMOUSE" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 33}             @{"IECLASS_REFRESHWINDOW" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 53}
@{"IECLASS_REQUESTER" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 45}            @{"IECLASS_SIZEWINDOW" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 51}
@{"IECLASS_TIMER" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 39}                @{"IECODE_ASCII_DEL" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 194}
@{"IECODE_ASCII_FIRST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 192}           @{"IECODE_ASCII_LAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 193}
@{"IECODE_C0_FIRST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 190}              @{"IECODE_C0_LAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 191}
@{"IECODE_C1_FIRST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 195}              @{"IECODE_C1_LAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 196}
@{"IECODE_COMM_CODE_FIRST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 186}       @{"IECODE_COMM_CODE_LAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 187}
@{"IECODE_KEY_CODE_FIRST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 184}        @{"IECODE_KEY_CODE_LAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 185}
@{"IECODE_LATIN1_FIRST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 197}          @{"IECODE_LATIN1_LAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 198}
@{"IECODE_LBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 201}               @{"IECODE_MBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 203}
@{"IECODE_NEWACTIVE" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 207}             @{"IECODE_NEWSIZE" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 208}
@{"IECODE_NOBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 204}              @{"IECODE_RBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 202}
@{"IECODE_REFRESH" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 209}               @{"IECODE_REQCLEAR" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 216}
@{"IECODE_REQSET" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 214}                @{"IECODE_UP_PREFIX" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 183}
@{"IEQUALIFIER_CAPSLOCK" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 223}         @{"IEQUALIFIER_CONTROL" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 224}
@{"IEQUALIFIER_INTERRUPT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 231}        @{"IEQUALIFIER_LALT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 225}
@{"IEQUALIFIER_LCOMMAND" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 227}         @{"IEQUALIFIER_LEFTBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 235}
@{"IEQUALIFIER_LSHIFT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 221}           @{"IEQUALIFIER_MIDBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 233}
@{"IEQUALIFIER_MULTIBROADCAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 232}   @{"IEQUALIFIER_NUMERICPAD" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 229}
@{"IEQUALIFIER_RALT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 226}             @{"IEQUALIFIER_RBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 234}
@{"IEQUALIFIER_RCOMMAND" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 228}         @{"IEQUALIFIER_RELATIVEMOUSE" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 236}
@{"IEQUALIFIER_REPEAT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 230}           @{"IEQUALIFIER_RSHIFT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 222}
@{"IEQUALIFIERB_CAPSLOCK" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 240}        @{"IEQUALIFIERB_CONTROL" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 241}
@{"IEQUALIFIERB_INTERRUPT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 248}       @{"IEQUALIFIERB_LALT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 242}
@{"IEQUALIFIERB_LCOMMAND" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 244}        @{"IEQUALIFIERB_LEFTBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 252}
@{"IEQUALIFIERB_LSHIFT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 238}          @{"IEQUALIFIERB_MIDBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 250}
@{"IEQUALIFIERB_MULTIBROADCAST" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 249}  @{"IEQUALIFIERB_NUMERICPAD" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 246}
@{"IEQUALIFIERB_RALT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 243}            @{"IEQUALIFIERB_RBUTTON" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 251}
@{"IEQUALIFIERB_RCOMMAND" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 245}        @{"IEQUALIFIERB_RELATIVEMOUSE" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 253}
@{"IEQUALIFIERB_REPEAT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 247}          @{"IEQUALIFIERB_RSHIFT" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 239}
@{"IESUBCLASS_COMPATIBLE" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 78}        @{"IESUBCLASS_NEWTABLET" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 84}
@{"IESUBCLASS_PIXEL" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 80}             @{"IESUBCLASS_TABLET" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 82}

@ENDNODE
@NODE File "devices/inputevent.h"
#ifndef DEVICES_INPUTEVENT_H
#define DEVICES_INPUTEVENT_H
/*
**      $VER: inputevent.h 36.10 (26.6.1992)
**      Includes Release 45.1
**
**      input event definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif

#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*----- constants --------------------------------------------------*/

/*  --- InputEvent.ie_Class --- */
/* A @{"NOP" LINK "gg:doc/NDK/Guide/exec/NOP"} input event */
#define IECLASS_NULL                    0x00
/* A raw keycode from the keyboard device */
#define IECLASS_RAWKEY                  0x01
/* The raw mouse report from the game port device */
#define IECLASS_RAWMOUSE                0x02
/* A private console event */
#define IECLASS_EVENT                   0x03
/* A Pointer Position report */
#define IECLASS_POINTERPOS              0x04
/* A timer event */
#define IECLASS_TIMER                   0x06
/* select button pressed down over a Gadget (address in @{"ie_EventAddress" LINK File 281}) */
#define IECLASS_GADGETDOWN              0x07
/* select button released over the same Gadget (address in @{"ie_EventAddress" LINK File 281}) */
#define IECLASS_GADGETUP                0x08
/* some Requester activity has taken place.  See Codes @{"REQCLEAR" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File" 121} and @{"REQSET" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File" 116} */
#define IECLASS_REQUESTER               0x09
/* this is a Menu Number transmission (Menu number is in ie_Code) */
#define IECLASS_MENULIST                0x0A
/* User has selected the active Window's Close Gadget */
#define IECLASS_CLOSEWINDOW             0x0B
/* this Window has a new size */
#define IECLASS_SIZEWINDOW              0x0C
/* the Window pointed to by @{"ie_EventAddress" LINK File 281} needs to be refreshed */
#define IECLASS_REFRESHWINDOW           0x0D
/* new preferences are available */
#define IECLASS_NEWPREFS                0x0E
/* the disk has been removed */
#define IECLASS_DISKREMOVED             0x0F
/* the disk has been inserted */
#define IECLASS_DISKINSERTED            0x10
/* the window is about to be been made active */
#define IECLASS_ACTIVEWINDOW            0x11
/* the window is about to be made inactive */
#define IECLASS_INACTIVEWINDOW          0x12
/* extended-function pointer position report (V36) */
#define IECLASS_NEWPOINTERPOS           0x13
/* Help key report during Menu session (V36) */
#define IECLASS_MENUHELP                0x14
/* the Window has been modified with move, size, zoom, or change (V36) */
#define IECLASS_CHANGEWINDOW            0x15

/* the last class */
#define IECLASS_MAX                     0x15


/*  --- InputEvent.ie_SubClass --- */
/*  @{"IECLASS_NEWPOINTERPOS" LINK File 65} */
/*      like @{"IECLASS_POINTERPOS" LINK File 37} */
#define IESUBCLASS_COMPATIBLE   0x00
/*      @{"ie_EventAddress" LINK File 281} points to @{"struct IEPointerPixel" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 97} */
#define IESUBCLASS_PIXEL        0x01
/*      @{"ie_EventAddress" LINK File 281} points to @{"struct IEPointerTablet" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 117} */
#define IESUBCLASS_TABLET       0x02
/*      @{"ie_EventAddress" LINK File 281} points to @{"struct IENewTablet" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 138} */
#define IESUBCLASS_NEWTABLET       0x03

/* pointed to by @{"ie_EventAddress" LINK File 281} for @{"IECLASS_NEWPOINTERPOS" LINK File 65},
 * and @{"IESUBCLASS_PIXEL" LINK File 80}.
 *
 * You specify a screen and pixel coordinates in that screen
 * at which you'd like the mouse to be positioned.
 * Intuition will try to oblige, but there will be restrictions
 * to positioning the pointer over offscreen pixels.
 *
 * @{"IEQUALIFIER_RELATIVEMOUSE" LINK File 236} is supported for @{"IESUBCLASS_PIXEL" LINK File 80}.
 */

struct IEPointerPixel   {
    @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133}       *iepp_Screen;   /* pointer to an open screen */
    struct                            /* pixel coordinates in iepp_Screen */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    X;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Y;
    }                   iepp_Position;
};

/* pointed to by @{"ie_EventAddress" LINK File 281} for @{"IECLASS_NEWPOINTERPOS" LINK File 65},
 * and @{"IESUBCLASS_TABLET" LINK File 82}.
 *
 * You specify a range of values and a value within the range
 * independently for each of X and Y (the minimum value of
 * the ranges is always normalized to 0).
 *
 * Intuition will position the mouse proportionally within its
 * natural mouse position rectangle limits.
 *
 * @{"IEQUALIFIER_RELATIVEMOUSE" LINK File 236} is not supported for @{"IESUBCLASS_TABLET" LINK File 82}.
 */
struct IEPointerTablet  {
    struct
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   X;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Y;
    }                   iept_Range;     /* 0 is min, these are max      */
    struct
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   X;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Y;
    }                   iept_Value;     /* between 0 and iept_Range     */

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                iept_Pressure;  /* -128 to 127 (unused, set to 0)  */
};


/* The @{"ie_EventAddress" LINK File 281} of an @{"IECLASS_NEWPOINTERPOS" LINK File 65} event of subclass
 * @{"IESUBCLASS_NEWTABLET" LINK File 84} points at an IENewTablet structure.
 *
 *
 * @{"IEQUALIFIER_RELATIVEMOUSE" LINK File 236} is not supported for @{"IESUBCLASS_NEWTABLET" LINK File 84}.
 */

struct IENewTablet
{
    /* Pointer to a hook you wish to be called back through, in
     * order to handle scaling.  You will be provided with the
     * width and height you are expected to scale your tablet
     * to, perhaps based on some user preferences.
     * If @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}, the tablet's specified range will be mapped directly
     * to that width and height for you, and you will not be
     * called back.
     */
    @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *ient_CallBack;

    /* Post-scaling coordinates and fractional coordinates.
     * DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} FILL THESE IN AT THE TIME THE EVENT IS WRITTEN!
     * Your driver will be called back and provided information
     * about the width and height of the area to scale the
     * tablet into.  It should scale the tablet coordinates
     * (perhaps based on some preferences controlling aspect
     * ratio, etc.) and place the scaled result into these
     * fields.  The ient_ScaledX and ient_ScaledY fields are
     * in screen-pixel resolution, but the origin ( [0,0]-point )
     * is not defined.  The ient_ScaledXFraction and
     * ient_ScaledYFraction fields represent sub-pixel position
     * information, and should be scaled to fill a @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} fraction.
     */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ient_ScaledX, ient_ScaledY;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ient_ScaledXFraction, ient_ScaledYFraction;

    /* Current tablet coordinates along each axis: */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ient_TabletX, ient_TabletY;

    /* Tablet range along each axis.  For example, if ient_TabletX
     * can take values 0-999, ient_RangeX should be 1000.
     */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ient_RangeX, ient_RangeY;

    /* Pointer to tag-list of additional tablet attributes.
     * See <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}> for the tag values.
     */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *ient_TagList;
};


/*  --- InputEvent.ie_Code --- */
/*  @{"IECLASS_RAWKEY" LINK File 31} */
#define IECODE_UP_PREFIX                0x80
#define IECODE_KEY_CODE_FIRST           0x00
#define IECODE_KEY_CODE_LAST            0x77
#define IECODE_COMM_CODE_FIRST          0x78
#define IECODE_COMM_CODE_LAST           0x7F

/*  IECLASS_ANSI */
#define IECODE_C0_FIRST                 0x00
#define IECODE_C0_LAST                  0x1F
#define IECODE_ASCII_FIRST              0x20
#define IECODE_ASCII_LAST               0x7E
#define IECODE_ASCII_DEL                0x7F
#define IECODE_C1_FIRST                 0x80
#define IECODE_C1_LAST                  0x9F
#define IECODE_LATIN1_FIRST             0xA0
#define IECODE_LATIN1_LAST              0xFF

/*  @{"IECLASS_RAWMOUSE" LINK File 33} */
#define IECODE_LBUTTON                  0x68    /* also uses @{"IECODE_UP_PREFIX" LINK File 183} */
#define IECODE_RBUTTON                  0x69
#define IECODE_MBUTTON                  0x6A
#define IECODE_NOBUTTON                 0xFF

/*  @{"IECLASS_EVENT" LINK File 35} (V36) */
#define IECODE_NEWACTIVE                0x01    /* new active input window */
#define IECODE_NEWSIZE                  0x02    /* resize of window */
#define IECODE_REFRESH                  0x03    /* refresh of window */

/*  @{"IECLASS_REQUESTER" LINK File 45} */
/*      broadcast when the first Requester (not subsequent ones) opens up in */
/*      the Window */
#define IECODE_REQSET                   0x01
/*      broadcast when the last Requester clears out of the Window */
#define IECODE_REQCLEAR                 0x00



/*  --- InputEvent.ie_Qualifier --- */
#define IEQUALIFIER_LSHIFT              0x0001
#define IEQUALIFIER_RSHIFT              0x0002
#define IEQUALIFIER_CAPSLOCK            0x0004
#define IEQUALIFIER_CONTROL             0x0008
#define IEQUALIFIER_LALT                0x0010
#define IEQUALIFIER_RALT                0x0020
#define IEQUALIFIER_LCOMMAND            0x0040
#define IEQUALIFIER_RCOMMAND            0x0080
#define IEQUALIFIER_NUMERICPAD          0x0100
#define IEQUALIFIER_REPEAT              0x0200
#define IEQUALIFIER_INTERRUPT           0x0400
#define IEQUALIFIER_MULTIBROADCAST      0x0800
#define IEQUALIFIER_MIDBUTTON           0x1000
#define IEQUALIFIER_RBUTTON             0x2000
#define IEQUALIFIER_LEFTBUTTON          0x4000
#define IEQUALIFIER_RELATIVEMOUSE       0x8000

#define IEQUALIFIERB_LSHIFT             0
#define IEQUALIFIERB_RSHIFT             1
#define IEQUALIFIERB_CAPSLOCK           2
#define IEQUALIFIERB_CONTROL            3
#define IEQUALIFIERB_LALT               4
#define IEQUALIFIERB_RALT               5
#define IEQUALIFIERB_LCOMMAND           6
#define IEQUALIFIERB_RCOMMAND           7
#define IEQUALIFIERB_NUMERICPAD         8
#define IEQUALIFIERB_REPEAT             9
#define IEQUALIFIERB_INTERRUPT          10
#define IEQUALIFIERB_MULTIBROADCAST     11
#define IEQUALIFIERB_MIDBUTTON          12
#define IEQUALIFIERB_RBUTTON            13
#define IEQUALIFIERB_LEFTBUTTON         14
#define IEQUALIFIERB_RELATIVEMOUSE      15

/*----- InputEvent -------------------------------------------------*/

struct InputEvent {
    struct  InputEvent *ie_NextEvent;   /* the chronologically next event */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ie_Class;                   /* the input event class */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ie_SubClass;                /* optional subclass of the class */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ie_Code;                    /* the input event code */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ie_Qualifier;               /* qualifiers in effect for the event*/
    union
        struct
            @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    ie_x;               /* the pointer position for the event*/
            @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    ie_y;
        } ie_xy;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ie_addr;                /* the event address */
        struct
            @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ie_prev1DownCode;   /* previous down keys for dead */
            @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ie_prev1DownQual;   /*   key translation: the ie_Code */
            @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ie_prev2DownCode;   /*   & low byte of ie_Qualifier for */
            @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ie_prev2DownQual;   /*   last & second last down keys */
        } ie_dead;
    } ie_position;
    @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} ie_TimeStamp;        /* the system tick at the event */
};

#define ie_X                    ie_position.ie_xy.ie_x
#define ie_Y                    ie_position.ie_xy.ie_y
#define ie_EventAddress         ie_position.ie_addr
#define ie_Prev1DownCode        ie_position.ie_dead.ie_prev1DownCode
#define ie_Prev1DownQual        ie_position.ie_dead.ie_prev1DownQual
#define ie_Prev2DownCode        ie_position.ie_dead.ie_prev2DownCode
#define ie_Prev2DownQual        ie_position.ie_dead.ie_prev2DownQual

#endif  /* DEVICES_INPUTEVENT_H */
@ENDNODE
