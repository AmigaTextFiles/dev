/* libvstring/strncat.c */

#include "libvstring.h"

STRPTR StrCat(STRPTR s, STRPTR d)
{
	for(;*d != '\0';++d);

	while(*s != '\0')
		*d++ = *s++;

	*d = '\0';
	return d;
}
