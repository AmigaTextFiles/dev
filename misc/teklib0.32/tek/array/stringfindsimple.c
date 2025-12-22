
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
*/

TINT TStringFindSimple(TSTRPTR string, TSTRPTR search, TINT stringlen, TINT searchlen)
{
	TINT pos = -1;
	TINT foundpos = 0, x = 0;

	while (x + foundpos < stringlen)
	{
		if (string[x + foundpos] == search[foundpos])
		{
			foundpos++;
			if (foundpos == searchlen)
			{
				pos = x;
				break;
			}
		}
		else
		{
			x++;
			foundpos = 0;
		}
	}
	
	return pos;
}
