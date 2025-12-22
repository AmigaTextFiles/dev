/* $Id: intuitionbase.h,v 1.10 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/libraries', 'target/intuition/intuition', 'target/exec/interrupts'
MODULE 'target/graphics/view'
{#include <intuition/intuitionbase.h>}
NATIVE {INTUITION_INTUITIONBASE_H} CONST

/* these are the display modes for which we have corresponding parameter
 *  settings in the config arrays
 */
NATIVE {DMODECOUNT} CONST DMODECOUNT = $0002 /* how many modes there are */
NATIVE {HIRESPICK}  CONST HIRESPICK  = $0000
NATIVE {LOWRESPICK} CONST LOWRESPICK = $0001

NATIVE {EVENTMAX}   CONST EVENTMAX   = 10     /* size of event array */

/* these are the system Gadget defines */
NATIVE {RESCOUNT}     CONST RESCOUNT     = 2
NATIVE {HIRESGADGET}  CONST HIRESGADGET  = 0
NATIVE {LOWRESGADGET} CONST LOWRESGADGET = 1

NATIVE {GADGETCOUNT}     CONST GADGETCOUNT     = 8
NATIVE {UPFRONTGADGET}   CONST UPFRONTGADGET   = 0
NATIVE {DOWNBACKGADGET}  CONST DOWNBACKGADGET  = 1
NATIVE {SIZEGADGET}      CONST SIZEGADGET      = 2
NATIVE {CLOSEGADGET}     CONST CLOSEGADGET     = 3
NATIVE {DRAGGADGET}      CONST DRAGGADGET      = 4
NATIVE {SUPFRONTGADGET}  CONST SUPFRONTGADGET  = 5
NATIVE {SDOWNBACKGADGET} CONST SDOWNBACKGADGET = 6
NATIVE {SDRAGGADGET}     CONST SDRAGGADGET     = 7

/* ======================================================================== */
/* === IntuitionBase ====================================================== */
/* ======================================================================== */
/*
 * Be sure to protect yourself against someone modifying these data as
 * you look at them.  This is done by calling:
 *
 * lock = LockIBase(0), which returns a ULONG.    When done call
 * UnlockIBase(lock) where lock is what LockIBase() returned.
 */

/* This structure is strictly READ ONLY */
NATIVE {IntuitionBase} OBJECT intuitionbase
    {LibNode}	libnode	:lib

    {ViewLord}	viewlord	:view

    {ActiveWindow}	activewindow	:PTR TO window
    {ActiveScreen}	activescreen	:PTR TO screen

    /* the FirstScreen variable points to the frontmost Screen.  Screens are
     * then maintained in a front to back order using Screen.NextScreen
     */
    {FirstScreen}	firstscreen	:PTR TO screen /* for linked list of all screens */

    {Flags}	flags	:ULONG                /* values are all system private */
    {MouseY}	mousey	:INT
	{MouseX}	mousex	:INT       /* note "backwards" order of these */

    {Seconds}	seconds	:ULONG              /* timestamp of most current input event */
    {Micros}	micros	:ULONG               /* timestamp of most current input event */

    /* I told you this was private.
     * The data beyond this point has changed, is changing, and
     * will continue to change.
     */
ENDOBJECT
