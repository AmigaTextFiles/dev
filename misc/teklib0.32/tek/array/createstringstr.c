
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	string = TCreateStringStr(TAPTR mmu, TSTRPTR initial)
**
**	create dynamic string from regular string.
**
*/

TSTRPTR TCreateStringStr(TAPTR mmu, TSTRPTR initial)
{
	TUINT len;
	TSTRPTR str;
	
	len = initial ? TStrLen(initial) : 0;
	str = TCreateArray(mmu, 1, len + 1, TNULL);
	if (str)
	{
		if (len)
		{
			TSTRPTR d = str;
			while ((*d++ = *initial++));
		}
		else
		{
			*str = 0;
		}
	}
	
	return str;
}
