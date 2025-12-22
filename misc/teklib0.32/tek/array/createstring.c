
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	string = TCreateString(TAPTR mmu, TUINT numchars)
**
**	create dynamic string.
**
*/

TSTRPTR TCreateString(TAPTR mmu, TUINT numchars)
{
	TSTRPTR str = TCreateArray(mmu, 1, numchars + 1, TNULL);
	if (str)
	{
		*str = 0;
	}
	return str;
}
