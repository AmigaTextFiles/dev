/* $VER: intuitionbase.h 38.0 (12.6.1991) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/libraries', 'target/intuition/intuition', 'target/exec/interrupts'
MODULE 'target/graphics/view'
{MODULE 'intuition/intuitionbase'}

NATIVE {DMODECOUNT}	CONST DMODECOUNT	= $0002	/* how many modes there are */
NATIVE {HIRESPICK}	CONST HIRESPICK	= $0000
NATIVE {LOWRESPICK}	CONST LOWRESPICK	= $0001

NATIVE {EVENTMAX} CONST EVENTMAX = 10		/* size of event array */

/* these are the system Gadget defines */
NATIVE {RESCOUNT}	CONST RESCOUNT	= 2
NATIVE {HIRESGADGET}	CONST HIRESGADGET	= 0
NATIVE {LOWRESGADGET}	CONST LOWRESGADGET	= 1

NATIVE {GADGETCOUNT}	CONST GADGETCOUNT	= 8
NATIVE {UPFRONTGADGET}	CONST UPFRONTGADGET	= 0
NATIVE {DOWNBACKGADGET}	CONST DOWNBACKGADGET	= 1
NATIVE {SIZEGADGET}	CONST SIZEGADGET	= 2
NATIVE {CLOSEGADGET}	CONST CLOSEGADGET	= 3
NATIVE {DRAGGADGET}	CONST DRAGGADGET	= 4
NATIVE {SUPFRONTGADGET}	CONST SUPFRONTGADGET	= 5
NATIVE {SDOWNBACKGADGET}	CONST SDOWNBACKGADGET	= 6
NATIVE {SDRAGGADGET}	CONST SDRAGGADGET	= 7

/* ======================================================================== */
/* === IntuitionBase ====================================================== */
/* ======================================================================== */

/* This structure is strictly READ ONLY */
NATIVE {intuitionbase} OBJECT intuitionbase
    {libnode}	libnode	:lib

    {viewlord}	viewlord	:view

    {activewindow}	activewindow	:PTR TO window
    {activescreen}	activescreen	:PTR TO screen

    {firstscreen}	firstscreen	:PTR TO screen /* for linked list of all screens */

    {flags}	flags	:ULONG	/* values are all system private */
    {mousey}	mousey	:INT
	{mousex}	mousex	:INT

    {seconds}	seconds	:ULONG	/* timestamp of most current input event */
    {micros}	micros	:ULONG	/* timestamp of most current input event */
ENDOBJECT
