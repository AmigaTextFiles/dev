
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringCopy(TSTRPTR *s1, TSTRPTR s2)
**
**	copy dynamic string to another dynamic string.
**
*/

TBOOL TStringCopy(TSTRPTR *s1, TSTRPTR s2)
{
	if (*s1 && s2)
	{
		TARRAY *a1 = *((TARRAY **) s1) - 1;
		TARRAY *a2 = ((TARRAY *) s2) - 1;
	
		if (a1->valid && a2->valid)
		{
			TUINT newlen = a2->len;
			if (TArraySetLen((TAPTR *) s1, newlen))
			{
				TMemCopy(s2, *s1, newlen);
				return TTRUE;
			}
		}
	}
	return TFALSE;
}
