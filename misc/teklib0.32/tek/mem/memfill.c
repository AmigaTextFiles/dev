
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMemFill(TAPTR dest, TUINT numbytes, TUINT fillval)
**	
**	fill memory.
*/

TVOID TMemFill(TAPTR dest, TUINT numbytes, TUINT fillval)
{
	kn_memset(dest, numbytes, (TUINT8) fillval);
}

