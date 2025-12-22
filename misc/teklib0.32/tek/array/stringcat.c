
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringCat(TSTRPTR *s1, TSTRPTR s2)
**	i0               p0           p1
**
**	catenate dynamic strings.
**
*/

TBOOL TStringCat(TSTRPTR *s1, TSTRPTR s2)
{
	if (*s1 && s2)
	{
		TARRAY *a1 = *((TARRAY **) s1) - 1;
		TARRAY *a2 = ((TARRAY *) s2) - 1;
		
		if (a1->valid && a2->valid)
		{
			TUINT addlen = a2->len - 1;
			if (addlen)
			{
				TUINT oldlen = a2->len - 1;
				if (TArraySetLen((TAPTR *) s1, oldlen + addlen + 1))
				{
					TMemCopy(s2, *s1 + oldlen, addlen + 1);
					return TTRUE;
				}
				return TFALSE;
			}
			return TTRUE;
		}
	}
	return TFALSE;
}
