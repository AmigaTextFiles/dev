
#include "tek/kn/elate/exec.h"
#include <string.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_memcopy(TAPTR from, TAPTR to, TUINT numbytes)
**
**	copy memory.
**
*/

TVOID kn_memcopy(TAPTR from, TAPTR to, TUINT numbytes)
{
	memcpy(to, from, numbytes);
}
