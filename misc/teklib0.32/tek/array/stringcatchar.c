
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringCatChar(TSTRPTR *s1, TCHAR c)
**
**	append single character to a dynamic string.
**
*/

TBOOL TStringCatChar(TSTRPTR *s1, TBYTE c)
{
	if (*s1 && c != 0)
	{
		TARRAY *a1 = *((TARRAY **) s1) - 1;
		if (a1->valid)
		{
			TUINT oldlen = a1->len - 1;
			if (TArraySetLen((TAPTR *) s1, oldlen + 2))
			{
				*(*s1 + oldlen) = c;
				*(*s1 + oldlen + 1) = 0;
				return TTRUE;
			}
			return TFALSE;
		}
	}
	return TFALSE;
}
