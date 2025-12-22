
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TSTRPTR TStrDup(TAPTR mmu, TSTRPTR s)
**
**	duplicate string via MMU.
**
*/

TSTRPTR TStrDup(TAPTR mmu, TSTRPTR s)
{
	TSTRPTR s2 = TNULL;
	
	if (s)
	{
		TUINT l = TStrLen(s);
		
		if (l > 0)
		{
			s2 = TMMUAlloc(mmu, l + 1);
			TStrCopy(s, s2);
		}
	}
	
	return s2;
}
