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
static inline char mtoupper( char c )
{
	return( islower(c) ? c - 'a' + 'A' : c );
}
#endif

#ifdef AZTEC_C
#define inline
#endif

#include "cxref.h"


extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct RxsLib *RexxSysBase;


/* $ARB: I 917382093 */


/* $ARB: B 1 SEARCH */
void rx_search( struct RexxHost *host, struct rxd_search **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_search *rd = *rxd;
	int lineno;
static char linestr[32];

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if(( rd = *rxd ))
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if(NULL!=(rd->res.filename=findfunc(rd->arg.word,&lineno))) {
				sprintf(linestr,"%d",lineno);
				rd->res.linenumber=linestr;
			} else {
				rd->res.filename="NONE";
				rd->res.linenumber="0";
			}
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 1 SEARCH */

/* $ARB: B 2 QUIT */
void rx_quit( struct RexxHost *host, struct rxd_quit **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_quit *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if(( rd = *rxd ))
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			Quit=TRUE;
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 2 QUIT */

/* $ARB: B 5 FILE */
void rx_file( struct RexxHost *host, struct rxd_file **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_file *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if(( rd = *rxd ))
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if(rd->arg.open==TRUE&&rd->arg.close==FALSE) setclose(FALSE);
			if(rd->arg.open==FALSE&&rd->arg.close==TRUE) setclose(TRUE);
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 5 FILE */


#ifndef RX_ALIAS_C
char *ExpandRXCommand( struct RexxHost *host, char *command )
{
	/* Insert your ALIAS-HANDLER here */
	return( NULL );
}
#endif

