/* eatmem.c
**
** Temporarily "eat" free memory to test programs on low mem situations
**
**                              Version 1.0
**                   Copyright © 1994 T.O. Karjalainen
**                       This program is FREEWARE
**
** Use a tab size of three when reading this source.
*/

/* V36 or higher includes required for compilation! */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>

#define SUPPORT_PRE_V36_DOS 1

int main( int argc, UBYTE **argv );
BOOL isnumeric( UBYTE *s );

extern struct Library *DOSBase;

struct memnode
{
	struct MinNode mn_Node;
	void *mem;
	ULONG size;
};

const UBYTE	template[] =		"LEAVE/S,BYTES/A/N,CHIP/S,FAST/S,PUBLIC/S,"
										"LOCAL/S,24BITDMA/S",
				badargs[] =			"Usage: EatMem [LEAVE] <bytes> [CHIP] "
										"[FAST] [PUBLIC] [LOCAL] [24BITDMA]\n",
				pressreturn[] =	"Press <RETURN> to free the memory...",
				cannoteat[] =		"\aUnable to eat the memory!\n",
				version[] =			"\0$VER: EatMem 1.0 (25.2.1994)";

int main( int argc, UBYTE **argv )
{
	BPTR out = 0;
	ULONG memamount = 0, memflags = MEMF_ANY;
	BOOL leave = FALSE;

	out = Output();

#ifdef SUPPORT_PRE_V36_DOS

	if ( DOSBase->lib_Version < 36 )
	{
		if ( argc < 2 )
		{
			Write( out, badargs, strlen( badargs ) );
			return ERROR_REQUIRED_ARG_MISSING;
		}

		if ( ! stricmp( argv[1], "?" ) )
		{
			Write( out, badargs, strlen( badargs ) );
			return RETURN_OK;
		}

		{
			int i;

			for ( i = 1; i < argc; i++ )
			{
				if ( ! stricmp( argv[i], "LEAVE" ) )
					leave = TRUE;
				else if ( isnumeric( argv[i] ) )	
					memamount = atol( argv[i] );
				else if ( ! stricmp( argv[i], "CHIP" ) )
					memflags |= MEMF_CHIP;
				else if ( ! stricmp( argv[i], "FAST" ) )
					memflags |= MEMF_FAST;
				else if ( ! stricmp( argv[i], "PUBLIC" ) )
					memflags |= MEMF_PUBLIC;
				else if ( ! stricmp( argv[i], "LOCAL" ) )
					memflags |= MEMF_LOCAL;
				else if ( ! stricmp( argv[i], "24BITDMA" ) )
					memflags |= MEMF_24BITDMA;
			}
		}
	}
	else

#endif

	{
		struct RDArgs *args;
		ULONG argvalues[7] = { 0 };

		if ( argc < 2 )
		{
			Write( out, badargs, strlen( badargs ) );
			return ERROR_REQUIRED_ARG_MISSING;
		}

		if ( args = ReadArgs( template, argvalues, NULL ) )
		{
			if ( argvalues[0] )
				leave = TRUE;
	
			if ( argvalues[1] )
				memamount = * ( (ULONG *) argvalues[1] );

			if ( argvalues[2] )
				memflags |= MEMF_CHIP;
			if ( argvalues[3] )
				memflags |= MEMF_FAST;
			if ( argvalues[4] )
				memflags |= MEMF_LOCAL;
			if ( argvalues[5] )
				memflags |= MEMF_PUBLIC;
			if ( argvalues[6] )
				memflags |= MEMF_24BITDMA;

			FreeArgs( args );
		}
		else
			return ERROR_REQUIRED_ARG_MISSING;
	}

	if ( !leave )
	{
		if ( memamount )
		{
			void *mem;

			if ( mem = AllocMem( memamount, memflags ) )
			{
				Write( out, pressreturn, strlen( pressreturn ) );
				while ( getchar() != '\n' );
				FreeMem( mem, memamount );
			}
			else
			{
				Write( out, cannoteat, strlen( cannoteat ) );	
				return ERROR_NO_FREE_STORE;
			}
		}
		else 
			while ( getchar() != '\n' );
	}
	else
	{
		struct MinList memlist;

		NewList( (struct List *) &memlist );

		while ( AvailMem( memflags | MEMF_LARGEST ) > memamount )
		{
			struct memnode *n;

			if ( n = AllocMem( sizeof( struct memnode ), MEMF_ANY ) )
			{		
				ULONG size;

				if ( n->mem = AllocMem( ( size = AvailMem( memflags | MEMF_LARGEST ) - memamount ), memflags ) )
				{
					n->size = size;
					AddTail( (struct List *) &memlist, (struct Node *) n );
				}
				else break;
			}
			else break;
		}

		Write( out, pressreturn, strlen( pressreturn ) );
		while ( getchar() != '\n' );
		
		while ( ! IsListEmpty( (struct List *) &memlist ) )
		{
			struct memnode *n;

			n = RemTail( (struct List *) &memlist );
			FreeMem( n->mem, n->size );
			FreeMem( n, sizeof( struct memnode ) );
		}
	}

	return RETURN_OK;
}

BOOL isnumeric( UBYTE *s )
{
	register UBYTE ch;

	while ( ch = *s )
	{
		if ( ch >= '0' && ch <= '9' )
			s++;
		else
			return FALSE;  
	}
	return TRUE;
}
