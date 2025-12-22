
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringCopyStr(TSTRPTR *s1, TSTRPTR s2)
**
**	copy regular string to a dynamic string.
**
*/

TBOOL TStringCopyStr(TSTRPTR *s1, TSTRPTR s2)
{
	if (*s1)
	{
		TARRAY *a1 = *((TARRAY **) s1) - 1;
		if (a1->valid)
		{
			TUINT newlen = TStrLen(s2);
			if (TArraySetLen((TAPTR *) s1, newlen + 1))
			{
				TMemCopy(s2, *s1, newlen + 1);
				return TTRUE;	
			}
		}
	}
	return TFALSE;
}
