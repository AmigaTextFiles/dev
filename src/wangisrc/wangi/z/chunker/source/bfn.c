/*************************************************************************
 *
 * Chunker/DeChunker
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * bfn.c
 */

#include "bfn.h"


/*************************************************************************
 * BuildFName() - Build an incremental filename from base.
 */

char *BuildFName(char *base, long *num)
{
	char *ret = NULL;
	
	if( base )
	{
		char *s;
		
		/* strlen + . + maximum 8 digit hex num + \0 */
		unsigned int maxsize = strlen(base) + 10;
		
		if( ret = OS_malloc(maxsize) )
		{
			OS_sprintf(ret, "%s.%03lx", base, *num);
			++(*num);
			
			/* Uppercase the hex part for transfer and UNIX case sensitive reasons */
			for( s = ret; *s != '.'; ++s );
			for( ++s; *s |= '\0'; ++s )
				*s = toupper(*s);
		}
	}
	return( ret );
}


/*************************************************************************
 * FreeFName() - Free memory allocated by BuildFName()
 */

void FreeFName(char *fname)
{
	if( fname )
		OS_free(fname);
}

