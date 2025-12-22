/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <rexx/storage.h>
#include <rexx/rxslib.h>

#ifdef __GNUC__
/* GCC needs all struct defs */
#include <dos/exall.h>
#include <graphics/graphint.h>
#include <intuition/classes.h>
#include <devices/keymap.h>
#include <exec/semaphores.h>
#endif

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/rexxsyslib_protos.h>

#ifndef __NO_PRAGMAS

#ifdef AZTEC_C
#include <pragmas/exec_lib.h>
#include <pragmas/dos_lib.h>
#include <pragmas/rexxsyslib_lib.h>
#endif

#ifdef LATTICE
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#endif

#endif /* __NO_PRAGMAS */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef LATTICE
#undef toupper
#define inline __inline
#endif

#ifdef __GNUC__
#undef toupper
static inline char toupper( char c )
{
	return( islower(c) ? c - 'a' + 'A' : c );
}
#endif

#ifdef AZTEC_C
#define inline
#endif

#include "rx_test2.h"


extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct RxsLib *RexxSysBase;


/* $ARB: I 727904534 */


/* $ARB: B 1 ALIAS */
#include "/rxif/rx_alias.c"
/* $ARB: E 1 ALIAS */

/* $ARB: B 2 CMDSHELL */
#include "/rxif/rx_cmdshell.c"
/* $ARB: E 2 CMDSHELL */

/* $ARB: B 3 DISABLE */
#include "/rxif/rx_disable.c"
/* $ARB: E 3 DISABLE */

/* $ARB: B 4 ENABLE */
#include "/rxif/rx_enable.c"
/* $ARB: E 4 ENABLE */

/* $ARB: B 5 FAULT */
#include "/rxif/rx_fault.c"
/* $ARB: E 5 FAULT */

/* $ARB: B 6 HELP */
#include "/rxif/rx_help.c"
/* $ARB: E 6 HELP */

/* $ARB: B 7 RX */
#include "/rxif/rx_rx.c"
/* $ARB: E 7 RX */


#ifndef RX_ALIAS_C
char *ExpandRXCommand( struct RexxHost *host, char *command )
{
	/* Insert your ALIAS-HANDLER here */
	return( NULL );
}
#endif

