#ifndef EXT_BOOTTABLE_H
#define EXT_BOOTTABLE_H 1
/**************************************************************************** 

$Source: MASTER:include/ext/boottable.h,v $
$Revision: 3.3 $
$Date: 1997/02/01 08:16:06 $

This file contains the definition of the BootTable structure and related
values.

Copyright © 1993-1996 by W. John Malone. All rights reserved.

****************************************************************************/
#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif


/* The BootTable is located at a known offset from the location of
   exec.library.  BOOTTABLE is that offset. */

#define BOOTTABLE    (-0x400)


/* A BootTable contains info Exec needs at boot time. */

struct BootTable
   {
   APTR   AbsSysBase;               /* pointer to pointer to base of exec lib */
   APTR   SysStackLower;            /* lower limit of supervisor stack */
   APTR   SysStackUpper;            /* upper limit of supervisor stack */
   APTR   ScanStart;                /* start for ROMTag scan */
   ULONG  ScanSkip;                 /* memory quantum to advance scan on bus error */
   APTR   DumpArea;                 /* where to dump if debug.library not present */
   UWORD  AttnFlags;                /* processors and co-processors */
   UWORD  SoftIntTrap;              /* trap used for software interrupts */
   APTR   VectorBase;               /* location of vector table - i.e. VBR */
   struct Vector   *MonitorVectors; /* exception vectors when monitor present */
   struct LibEntry *ExecISRs;       /* ptr to jump table of ExecISRs */
   ULONG  Baud;                     /* default baud rate for console */
   BOOL   TagStep;                  /* pause at each ROMTag during boot */
   UWORD  BreakpointTrap;           /* trap used to insert breakpoints */
   void   (*BootEvent)(UWORD event, 
                       APTR  data); /* low level boot debugging callback */
   };


/* Boot Event types. */

#define BE_SCANSTART       1     /* scan begins, data is NULL */
#define BE_RESIDENTFOUND   2     /* resident module found, data is Resident */
#define BE_RESIDENTINIT    3     /* resident module about to init, data is Resident */


#endif
