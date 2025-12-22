@DATABASE "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h"
@MASTER   "gg:os-include/intuition/intuitionbase.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:13
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/intuitionbase.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/intuitionbase.h" LINK File}


@{b}Structures@{ub}

@{"IntuitionBase" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 66}


@{b}#defines@{ub}

@{"CLOSEGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 48}   @{"DMODECOUNT" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 33}   @{"DOWNBACKGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 46}  @{"DRAGGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 49}
@{"EVENTMAX" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 37}      @{"GADGETCOUNT" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 44}  @{"HIRESGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 41}     @{"HIRESPICK" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 34}
@{"LOWRESGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 42}  @{"LOWRESPICK" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 35}   @{"RESCOUNT" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 40}        @{"SDOWNBACKGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 51}
@{"SDRAGGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 52}   @{"SIZEGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 47}   @{"SUPFRONTGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 50}  @{"UPFRONTGADGET" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 45}

@ENDNODE
@NODE File "intuition/intuitionbase.h"
#ifndef INTUITION_INTUITIONBASE_H
#define INTUITION_INTUITIONBASE_H 1
/*
**  $VER: intuitionbase.h 38.0 (12.6.1991)
**  Includes Release 45.1
**
**  Public part of IntuitionBase structure and supporting structures
**
**  (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif


#ifndef EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif

/* these are the display modes for which we have corresponding parameter
 *  settings in the config arrays
 */
#define DMODECOUNT      0x0002  /* how many modes there are */
#define HIRESPICK       0x0000
#define LOWRESPICK      0x0001

#define EVENTMAX 10             /* size of event array */

/* these are the system Gadget defines */
#define RESCOUNT        2
#define HIRESGADGET     0
#define LOWRESGADGET    1

#define GADGETCOUNT     8
#define UPFRONTGADGET   0
#define DOWNBACKGADGET  1
#define SIZEGADGET      2
#define CLOSEGADGET     3
#define DRAGGADGET      4
#define SUPFRONTGADGET  5
#define SDOWNBACKGADGET 6
#define SDRAGGADGET     7

/* ======================================================================== */
/* === IntuitionBase ====================================================== */
/* ======================================================================== */
/*
 * Be sure to protect yourself against someone modifying these data as
 * you look at them.  This is done by calling:
 *
 * lock = @{"LockIBase" LINK "gg:doc/NDK/Guide/intuition/LockIBase"}(0), which returns a @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}.  When done call
 * @{"UnlockIBase" LINK "gg:doc/NDK/Guide/intuition/UnlockIBase"}(lock) where lock is what @{"LockIBase()" LINK "gg:doc/NDK/Guide/intuition/LockIBase"} returned.
 */

/* This structure is strictly READ ONLY */
struct IntuitionBase
{
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} LibNode;

    @{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} ViewLord;

    @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *ActiveWindow;
    @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *ActiveScreen;

    /* the FirstScreen variable points to the frontmost Screen.  Screens are
     * then maintained in a front to back order using Screen.NextScreen
     */
    @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *FirstScreen; /* for linked list of all screens */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} Flags;        /* values are all system private */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}        MouseY, MouseX;
                        /* note "backwards" order of these              */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} Seconds;      /* timestamp of most current input event */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} Micros;       /* timestamp of most current input event */

    /* I told you this was private.
     * The data beyond this point has changed, is changing, and
     * will continue to change.
     */
};

#endif
@ENDNODE
