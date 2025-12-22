/*************************************************************************
 *
 * ea/deea
 *
 * Copyright ©1995 Lee Kindness and Evan Tuer
 * cs2lk@scms.rgu.ac.uk
 *
 * machine.c
 *  Initilisation code plus any other machine dependant code.
 */

#include "machine.h"


#ifdef AMIGA

/*************************************************************************
 * msprintf() - Equivalent to sprintf(). Implemented using the exec RawDoFmt
 *  command. Note that "\x16\xC0\x4E\x75" represents:
 *
 *    move.b  d0,(a3)+
 *    rts
 */

void msprintf(char *buffer, char *format, ...)
{
	RawDoFmt(format, (APTR)(&format+1), (void (*))"\x16\xC0\x4E\x75", buffer);
}

#endif /* AMIGA */


/*************************************************************************
 * InitSystem() - Called from main() to initilise and check any system
 *  options or dependancies.
 */
 
int InitSystem( void )
{
#ifdef AMIGA
	if( (((struct Library *)DOSBase)->lib_Version >= 36) &&
	    (((struct Library *)SysBase)->lib_Version >= 36) )
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
 * GeteaArgs() - Parse command line arguments for ea
 */

#define ARG_CSOURCE argv[1]
#define ARG_CDEST argv[2]
#define NUM_CARGS 3

struct Args *GeteaArgs(int argc, char **argv)
{
	struct Args *args = NULL;
#ifdef AMIGA
#define EA_TEMP "SOURCE/A,DESTINATION/A"
#define OPT_CSOURCE 0
#define OPT_CDEST 1
#define OPT_CMAX 2
	if( args = (struct Args *)mmalloc(sizeof(struct Args)) )
	{
		STRPTR argsa[OPT_CMAX] = {0, 0};
		
		if( args->arg_RAHandle = ReadArgs(EA_TEMP, (LONG *)&argsa, NULL) )
		{
			args->arg_Filename = argsa[OPT_CSOURCE];
			args->arg_Dest = argsa[OPT_CDEST];
		} else
		{
			mfree((char *)args);
			args = NULL;
			PrintFault(IoErr(), "ea");
		}
	}
#else
	if( argc == NUM_CARGS )
	{
		if( args = (struct Args *)mmalloc(sizeof(struct Args)) )
		{
			args->arg_Filename = ARG_CSOURCE;
			args->arg_Dest = ARG_CDEST;
		}
	} else
		mprintf("Usage:\n ea <source> <destination>\n");
#endif	
	return( args );
}


/*************************************************************************
 * FreeeaArgs() - Free Arguments for ea
 */

void FreeeaArgs(struct Args *args)
{
	if( args )
	{
#ifdef AMIGA
		if( args->arg_RAHandle )
			FreeArgs(args->arg_RAHandle);
#endif
		mfree((char *)args);
	}	
}


/*************************************************************************
 * GetdeeaArgs() - Parse command line arguments for deea
 */

#define ARG_DSOURCE argv[1]
#define NUM_DARGS 2

struct Args *GetdeeaArgs(int argc, char **argv)
{
	struct Args *args = NULL;
#ifdef AMIGA
#define DEEA_TEMP "SOURCE/A"
#define OPT_DSOURCE 0
#define OPT_DMAX 1
	if( args = (struct Args *)mmalloc(sizeof(struct Args)) )
	{
		STRPTR argsa[OPT_DMAX] = {0};
		
		if( args->arg_RAHandle = ReadArgs(DEEA_TEMP, (LONG *)&argsa, NULL) )
		{
			args->arg_Filename = argsa[OPT_DSOURCE];
		} else
		{
			mfree((char *)args);
			args = NULL;
			PrintFault(IoErr(), "deea");
		}
	}
#else
	if( argc == NUM_DARGS )
	{
		if( args = (struct Args *)mmalloc(sizeof(struct Args)) )
		{
			args->arg_Filename = ARG_DSOURCE;
		}
	} else
		mprintf("Usage:\n deea <source>");
#endif	
	return( args );
}


/*************************************************************************
 * FreedeeaArgs() - Free Arguments for deea
 */

void FreedeeaArgs(struct Args *args)
{
	if( args )
	{
#ifdef AMIGA
		if( args->arg_RAHandle )
			FreeArgs(args->arg_RAHandle);
#endif
		mfree((char *)args);
	}	
}
