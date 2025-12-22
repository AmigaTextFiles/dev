
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TStrCmp(TSTRPTR s1, TSTRPTR s2)
**
**	compare strings.
**
*/

TINT TStrCmp(TSTRPTR s1, TSTRPTR s2)
{
	if (s1 && s2)
	{
		TINT t1 = *s1, t2 = *s2;
		TINT c1, c2, t;
	
	strcmp_lop:
	
		if ((c1 = t1))
		{
			t1 = *s1++;
		}
	
		if ((c2 = t2))
		{
			t2 = *s2++;
		}
	
		t = c1 - c2;		
	
		switch (!t1 + !t2)
		{
			case 1:
				return (TINT) (t1 - t2);
	
			case 0:
				if (!t)
				{
					goto strcmp_lop;
				}	
			
			default:
				return (TINT) t;	
		}
	}

	return (TINT) (!!s1 - !!s2);
}
