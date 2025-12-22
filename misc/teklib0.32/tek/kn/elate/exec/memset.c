
#include "tek/kn/elate/exec.h"
#include <string.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_memset(TAPTR dest, TUINT numbytes, TUINT8 fillval)
**
**	fill memory
**
*/

TVOID kn_memset(TAPTR dest, TUINT numbytes, TUINT8 fillval)
{
	memset(dest, (int) fillval, numbytes);
}
