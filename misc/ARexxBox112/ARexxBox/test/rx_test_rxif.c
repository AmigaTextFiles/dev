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

#include "rx_test.h"


extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct RxsLib *RexxSysBase;


/* $ARB: I 727905256 */


/* $ARB: B 1 HELP */
#include "/rxif/rx_help.c"
/* $ARB: E 1 HELP */

/* $ARB: B 3 MULTI_IN_NUM */
void rx_multi_in_num( struct RexxHost *host, struct rxd_multi_in_num **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_multi_in_num *rd = *rxd;
	long **s;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			Printf( "\nmulti_in_num: liste=%lx\n", rd->arg.liste );
			if( s = rd->arg.liste )
				for( ; *s; s++ )
					Printf( "Liste: %ld\n", **s );
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 3 MULTI_IN_NUM */

/* $ARB: B 4 MULTI_IN_STR */
void rx_multi_in_str( struct RexxHost *host, struct rxd_multi_in_str **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_multi_in_str *rd = *rxd;
	char **s;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			Printf( "\nmulti_in_str: liste=%lx\n", rd->arg.liste );
			if( s = rd->arg.liste )
				for( ; *s; s++ )
					Printf( "Liste: %s\n", *s );
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 4 MULTI_IN_STR */

/* $ARB: B 5 MULTI_OUT_NUM */
void rx_multi_out_num( struct RexxHost *host, struct rxd_multi_out_num **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_multi_out_num *rd = *rxd;
	static long a=123, b=234, c=345;
	static long *aa[4];

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			aa[0] = &a;
			aa[1] = &b;
			aa[2] = &c;
			aa[3] = NULL;
			rd->res.liste = aa;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 5 MULTI_OUT_NUM */

/* $ARB: B 6 MULTI_OUT_STR */
void rx_multi_out_str( struct RexxHost *host, struct rxd_multi_out_str **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_multi_out_str *rd = *rxd;
	static char *a[] = { "abc","bcd","cde","def","huhu", NULL };

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->res.liste = a;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 6 MULTI_OUT_STR */

/* $ARB: B 7 OPEN */
void rx_open( struct RexxHost *host, struct rxd_open **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_open *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
				rd->arg.file = "default_file";
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			Printf( "\nopen file=%s prompt=%ld\n",
				rd->arg.file, rd->arg.prompt );
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 7 OPEN */

/* $ARB: B 8 INOUT */
void rx_inout( struct RexxHost *host, struct rxd_inout **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_inout *rd = *rxd;
	static long a1 = 4711;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
				rd->arg.arg1 = &a1;
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			Printf( "\ninout var=%s, stem=%s, arg1=%ld\n",
				rd->arg.var ? rd->arg.var : "<n.a.>",
				rd->arg.stem ? rd->arg.stem : "<n.a.>",
				*rd->arg.arg1 );
			
			rd->res.res1 = "Dies ist das Resultat!";
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 8 INOUT */


#ifndef RX_ALIAS_C
char *ExpandRXCommand( struct RexxHost *host, char *command )
{
	/* Insert your ALIAS-HANDLER here */
	return( NULL );
}
#endif

