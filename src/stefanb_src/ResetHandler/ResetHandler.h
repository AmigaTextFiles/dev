/*
 * ResetHandler.h  V1.0
 *
 * Main include file
 *
 * (c) 1991 Stefan Becker
 *
 */

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <exec/interrupts.h>
#include <exec/memory.h>
#include <devices/keyboard.h>
#include <devices/timer.h>
#include <graphics/gfxbase.h>
#include <stdlib.h>
#include <stdio.h>

extern struct Library *SysBase,*DOSBase,*IntuitionBase;
