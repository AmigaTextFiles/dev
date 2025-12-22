/***************************************************************/
/* Includes and other MUI and Amiga stuff for Little Smalltalk */
/***************************************************************/

/* MUI */
#include <libraries/mui.h>

/* System */
#include <dos/dos.h>
#include <exec/memory.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <intuition/classes.h>
#include <intuition/icclass.h>

/* Prototypes */
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>
#include <clib/asl_protos.h>

/* ANSI C */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Compiler specific stuff */

#define REG(x) register __ ## x

#if defined __MAXON__ || defined __GNUC__
#define ASM
#define SAVEDS
#else
#define ASM    __asm
#define SAVEDS __saveds
#endif /* if defined ... */

#ifndef __GNUC__
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/muimaster_pragmas.h>
#endif /* ifndef __GNUC__ */

extern struct Library *SysBase,*IntuitionBase,*UtilityBase,*GfxBase,*DOSBase,*IconBase;

/* windows are maintained in a single structure */
# define WINDOWMAX 15
extern APTR wins[WINDOWMAX];

/* Application event notification IDs */
#define ID_ABOUT   1
#define ID_NEWCLA  2
#define ID_NEWMET  3
#define ID_NEWCON  4
#define ID_BROWSE  5
#define ID_TXTEDT  6
#define ID_FILEIN  7
#define ID_FILEOUT 8
#define ID_SAVEIMG 9
#define ID_ADDCLS 10
#define ID_ADDMTH 11
#define ID_ECHO   12
#define ID_BYTES  13
#define ID_QUITBR 14
#define ID_REQU   15
#define ID_SELFILE 16
