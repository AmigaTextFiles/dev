/*
 * Written by Randell Jesup, Commodore-Amiga Inc.
 * This routine is in the public domain.
 * It should be rewritten to use GetVar() when running under 2.0.
 *
 */

#include <exec/types.h>
#include <libraries/dos.h>
#include <dos.h>
#ifdef LATTICE
#include <proto/exec.h>
#include <proto/dos.h>
#endif

char *
getenv(str)
	char *str;
{
	register char *dest = NULL;
	register LONG len,newlen;
	register BPTR envfh;
	BPTR lock;

	lock = Lock("ENV:",SHARED_LOCK);
	if (!lock)
		return NULL;

	lock = CurrentDir(lock);
	if (envfh = Open(str,MODE_OLDFILE))
	{
		/* find end of file */
		Seek(envfh,0,OFFSET_END);
		len = Seek(envfh,0,OFFSET_BEGINNING);

		if (len >= 0 && (dest = (char *) malloc(len+1)))
		{
			newlen = Read(envfh,dest,len);
			if (newlen >= 0)
			{
				dest[newlen] = '\0';
			}
		}
		Close(envfh);
	}
	lock = CurrentDir(lock);
	UnLock(lock);

	return dest;
}
