/**********************************
** Includes and other common stuff 
**********************************/

/* System */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <libraries/gadtools.h>
#include <libraries/reqtools.h>
#include <devices/timer.h>
#include <libraries/commodities.h>

/* Prototypes */
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>
#include <clib/timer_protos.h>
#include <clib/asl_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/commodities_protos.h>

/* ANSI C */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Compiler specific stuff */

#ifdef _DCC

#define REG(x) __ ## x
#define ASM
#define SAVEDS __geta4

#else

#define REG(x) register __ ## x

#if defined __MAXON__ || defined __GNUC__
#define ASM
#define SAVEDS
#else
#define ASM    __asm
#define SAVEDS __saveds
#endif /* if defined ... */


#ifdef __SASC
#include <pragmas/exec_sysbase_pragmas.h>
#else
#ifndef __GNUC__
#include <pragmas/exec_pragmas.h>
#endif /* ifndef __GNUC__ */
#endif /* ifdef SASC      */

#ifndef __GNUC__

#include <pragmas/dos_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/reqtools.h>
#include <pragmas/timer_pragmas.h>
#include <pragmas/commodities_pragmas.h>

#endif /* ifndef __GNUC__ */

#endif /* ifdef _DCC */

#ifdef _DCC

int brkfunc(void) { return(0); }

int wbmain(struct WBStartup *wb_startup)
{
        extern int main(int argc, char *argv[]);
        return (main(0, (char **)wb_startup));
}

#endif

#ifdef __SASC
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}
#endif

LONG __stack = 8192;
