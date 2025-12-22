
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringCopyStrN(TSTRPTR *s1, TSTRPTR s2, TUINT32 n)
**
**	copy max. n characters of regular string to a dynamic string
**
*/

TBOOL TStringCopyStrN(TSTRPTR *s1, TSTRPTR s2, TUINT n)
{
	if (*s1)
	{
		TARRAY *a1 = *((TARRAY **) s1) - 1;

		if (a1->valid)
		{
			TUINT newlen = TStrLen(s2);
			newlen = TMIN(newlen, n);
			if (TArraySetLen((TAPTR *) s1, newlen + 1))
			{
				TMemCopy(s2, *s1, newlen);
				(*s1)[newlen] = 0;
				return TTRUE;	
			}
		}
	}
	return TFALSE;
}
