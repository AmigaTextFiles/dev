
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TStrCat(TSTRPTR dest, TSTRPTR addstr)
**
**	concatenate string.
**
*/

TVOID TStrCat(TSTRPTR dest, TSTRPTR addstr)
{
	if (dest && addstr)
	{
		TStrCopy(addstr, dest + TStrLen(dest));
	}
}
