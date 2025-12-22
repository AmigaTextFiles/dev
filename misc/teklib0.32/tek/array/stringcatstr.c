
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringCatStr(TSTRPTR *s1, TSTRPTR s2)
**
**	append regular string to dynamic string.
**
*/

TBOOL TStringCatStr(TSTRPTR *s1, TSTRPTR s2)
{
	if (*s1 && s2)
	{
		TARRAY *a1 = *((TARRAY **) s1) - 1;
		if (a1->valid)
		{
			TUINT addlen = TStrLen(s2);
			if (addlen)
			{
				TUINT oldlen = a1->len - 1;
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
