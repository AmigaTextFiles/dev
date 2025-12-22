
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	len = TStrLen(TSTRPTR s)
**
**	get length of a string.
**
*/

TUINT TStrLen(TSTRPTR s)
{
	TUINT l = 0;
	if (s)
	{
		while (*s++)
		{
			l++;
		}
	}
	
	return l;
}
