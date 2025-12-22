/* libvstring/strncmp.c */

#include "libvstring.h"


LONG StrNCmp(STRPTR s, STRPTR d, LONG len)
{
	while(len--)
	{
		if(*s++ != *d++)
			return s[-1] - d[-1];
	}
	return NULL;
}

