/*************************************************************************
 *
 * Chunker/DeChunk
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * machine.c
 *  Initilisation code plus any other machine dependant code.
 */

#include "machine.h"


#ifdef BUILD_AMIGA

/*************************************************************************
 * OS_sprintf() - Equivalent to sprintf(). Implemented using the exec 
 *  RawDoFmt command. Note that "\x16\xC0\x4E\x75" represents MC68000
 *  instructions:
 *
 *    move.b  d0,(a3)+
 *    rts
 */

void OS_sprintf(char *buffer, char *format, ...)
{
	RawDoFmt(format, (APTR)(&format+1), (void (*))"\x16\xC0\x4E\x75", buffer);
}

#endif /* BUILD_AMIGA */


/*************************************************************************
 * InitSystem() - Called from main() to initilise and check any system
 *  options or dependancies.
 */
 
int InitSystem( void )
{
#ifdef BUILD_AMIGA
	if( (((struct Library *)SysBase)->lib_Version >= 36) &&
	    (((struct Library *)DOSBase)->lib_Version >= 36) )
		return( 1 );
	else
		return( 0 );
#else
	return( 1 );
#endif
}


/*************************************************************************
 * FreeSystem() - Called from main() to delalocate anything allocated
 *  by InitSystem.
 */

void FreeSystem( void )
{
}


/*************************************************************************
 * GetChunkerArgs() - Parse command line arguments for Chunker
 */

#define ARG_CSOURCE argv[1]
#define ARG_CDEST argv[2]
#define ARG_CSIZE argv[3]
#define NUM_CARGS 4

struct Args *GetChunkerArgs(int argc, char **argv)
{
	struct Args *args = NULL;
#ifdef BUILD_AMIGA
#define CHUNKER_TEMP "SOURCE/A,DESTBASENAME/A,SIZE/N/A"
#define OPT_CSOURCE 0
#define OPT_CDEST 1
#define OPT_CSIZE 2
#define OPT_CMAX 3
	if( args = (struct Args *)OS_malloc(sizeof(struct Args)) )
	{
		STRPTR argsa[OPT_CMAX] = {0, 0, 0};
		
		if( args->arg_RAHandle = ReadArgs(CHUNKER_TEMP, (LONG *)&argsa, NULL) )
		{
			args->arg_Filename = argsa[OPT_CSOURCE];
			args->arg_Basename = argsa[OPT_CDEST];
			args->arg_Size = *((unsigned long *)argsa[OPT_CSIZE]);
		} else
		{
			OS_free((char *)args);
			args = NULL;
			PrintFault(IoErr(), "Chunker");
		}
	}
#else
	if( argc == NUM_CARGS )
	{
		if( atol(ARG_CSIZE) )
		{
			if( args = (struct Args *)OS_malloc(sizeof(struct Args)) )
			{
				args->arg_Filename = ARG_CSOURCE;
				args->arg_Basename = ARG_CDEST;
				args->arg_Size = atol(ARG_CSIZE);
			}
		} else
			OS_printf("3rd argument must be an integer\n");
	} else
		OS_printf("Usage:\n chunker <file> <basename> <size>\n");
#endif	
	return( args );
}


/*************************************************************************
 * FreeChunkerArgs() - Free Arguments for chunker
 */

void FreeChunkerArgs(struct Args *args)
{
	if( args )
	{
#ifdef BUILD_AMIGA
		if( args->arg_RAHandle )
			FreeArgs(args->arg_RAHandle);
#endif
		OS_free((char *)args);
	}	
}


/*************************************************************************
 * GetDeChunkArgs() - Parse command line arguments for dechunk
 */

#define ARG_DDEST argv[1]
#define ARG_DSOURCE argv[2]
#define NUM_DARGS 3

struct Args *GetDeChunkArgs(int argc, char **argv)
{
	struct Args *args = NULL;
#ifdef BUILD_AMIGA
#define DECHUNK_TEMP "DESTINATION/A,BASENAME/A"
#define OPT_DDEST 0
#define OPT_DBASE 1
#define OPT_DMAX 2
	if( args = (struct Args *)OS_malloc(sizeof(struct Args)) )
	{
		STRPTR argsa[OPT_DMAX] = {0, 0};
		
		if( args->arg_RAHandle = ReadArgs(DECHUNK_TEMP, (LONG *)&argsa, NULL) )
		{
			args->arg_Filename = argsa[OPT_DDEST];
			args->arg_Basename = argsa[OPT_DBASE];
		} else
		{
			OS_free((char *)args);
			args = NULL;
			PrintFault(IoErr(), "DeChunk");
		}
	}
#else
	if( argc == NUM_DARGS )
	{
		if( args = (struct Args *)OS_malloc(sizeof(struct Args)) )
		{
			args->arg_Filename = ARG_DDEST;
			args->arg_Basename = ARG_DSOURCE;
		}
	} else
		OS_printf("Usage:\n dechunk <outputfile> <basename>\n");
#endif	
	return( args );
}


/*************************************************************************
 * FreeDeChunkArgs() - Free Arguments for chunker
 */

void FreeDeChunkArgs(struct Args *args)
{
	if( args )
	{
#ifdef BUILD_AMIGA
		if( args->arg_RAHandle )
			FreeArgs(args->arg_RAHandle);
#endif
		OS_free((char *)args);
	}	
}
