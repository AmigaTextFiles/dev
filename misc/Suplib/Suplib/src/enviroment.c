

/*  ENVIROMENT.C
 *
 *  str = GetDEnv(name)
 *  bool= SetDEnv(name, str)    (0=failure, 1=success)
 *
 *	If the enviroment variable 'name' exists, malloc and return a copy
 *	of it.	The user program must free() it (or allow the standard C
 *	exit routine to free() it).
 */

#include <local/typedefs.h>
#ifdef LATTICE
#include <stdlib.h>
#include <string.h>
#else
extern void *malloc();
#endif

char *
GetDEnv(name)
char *name;
{
    short nlen = strlen(name) + 5;
    char *ptr = AllocMem(nlen, MEMF_PUBLIC);
    char *res = NULL;
    long fh;
    long len;

    if (ptr) {
	strcpy(ptr, "ENV:");
	strcat(ptr, name);
	if (fh = (long)Open(ptr, 1005)) {
	    len = (Seek(fh, 0L, 1), Seek(fh, 0L, 0));
	    if (len >= 0 && (res = malloc(len+1))) {
		Seek(fh, 0L, -1);
		if (Read(fh, res, len) != len)
		    len = 0;
		res[len] = 0;
	    }
	    Close(fh);
	}
	FreeMem(ptr, nlen);
    }
    return(res);
}

int
SetDEnv(name, str)
char *name, *str;
{
    short nlen = strlen(name) + 5;
    short slen = strlen(str);
    int res = 0;
    char *ptr = AllocMem(nlen, MEMF_PUBLIC);
    long fh;

    if (ptr) {
	strcpy(ptr, "ENV:");
	strcat(ptr, name);
	if (fh = (long)Open(ptr, 1006)) {
	    if (Write(fh, str, slen) == slen)
		res = 1;
	    Close(fh);
	}
	FreeMem(ptr, nlen);
    }
    return(res);
}

