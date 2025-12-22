
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TStrCopy(TSTRPTR source, TSTRPTR dest)
**
**	copy string.
**
*/

TVOID TStrCopy(TSTRPTR source, TSTRPTR dest)
{
	if (source && dest)
	{
		while ((*dest++ = *source++));
	}
}
