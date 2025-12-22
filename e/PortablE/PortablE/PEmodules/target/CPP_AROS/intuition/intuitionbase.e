/* $Id: intuitionbase.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/interrupts', 'target/exec/libraries', 'target/exec/types', 'target/intuition/intuition'
MODULE 'target/graphics/view'
{#include <intuition/intuitionbase.h>}
NATIVE {INTUITION_INTUITIONBASE_H} CONST

/* You have to call LockIBase() before reading this struct! */
NATIVE {IntuitionBase} OBJECT intuitionbase
    {LibNode}	libnode	:lib

    {ViewLord}	viewlord	:view

    {ActiveWindow}	activewindow	:PTR TO window
    {ActiveScreen}	activescreen	:PTR TO screen
    {FirstScreen}	firstscreen	:PTR TO screen

    {Flags}	flags	:ULONG
    {MouseX}	mousey	:INT
    {MouseY}	mousex	:INT

    {Seconds}	seconds	:ULONG
    {Micros}	micros	:ULONG
ENDOBJECT

NATIVE {HIRESPICK}  CONST HIRESPICK  = $0000
NATIVE {LOWRESPICK} CONST LOWRESPICK = $0001
NATIVE {DMODECOUNT} CONST DMODECOUNT = $0002

NATIVE {HIRESGADGET}  CONST HIRESGADGET  = 0
NATIVE {LOWRESGADGET} CONST LOWRESGADGET = 1
NATIVE {RESCOUNT}     CONST RESCOUNT     = 2

NATIVE {UPFRONTGADGET}   CONST UPFRONTGADGET   = 0
NATIVE {DOWNBACKGADGET}  CONST DOWNBACKGADGET  = 1
NATIVE {SIZEGADGET}      CONST SIZEGADGET      = 2
NATIVE {CLOSEGADGET}     CONST CLOSEGADGET     = 3
NATIVE {DRAGGADGET}      CONST DRAGGADGET      = 4
NATIVE {SUPFRONTGADGET}  CONST SUPFRONTGADGET  = 5
NATIVE {SDOWNBACKGADGET} CONST SDOWNBACKGADGET = 6
NATIVE {SDRAGGADGET}     CONST SDRAGGADGET     = 7
NATIVE {GADGETCOUNT}     CONST GADGETCOUNT     = 8

NATIVE {EVENTMAX} CONST EVENTMAX = 10
