
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TDestroyString(TAPTR mmu, TUINT numchars)
**
**	destroy dynamic string.
**
*/

TVOID TDestroyString(TSTRPTR string)
{
	if (string)
	{
		TDestroyArray(string);
	}
}
