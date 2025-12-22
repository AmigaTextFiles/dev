/* libvstring/strstr.c */

#include "libvstring.h"


STRPTR StrStr(STRPTR s, STRPTR d)
{
	BYTE dch, sch;
	LONG len;

	dch = *d++;
	if(!dch)
		return (STRPTR) s;


	len = StrLen(d);

	do
	{
		do
		{
			sch = *s++;
			if(!sch)
				return (STRPTR) NULL;
		} while (sch != dch);
	} while (StrNCmp(s, d, len) != 0);

	return (STRPTR) (s - 1);
}

