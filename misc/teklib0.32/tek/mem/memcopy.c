
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TMemCopy(TAPTR from, TAPTR to, TUINT numbytes)
**
**	copy mem
**
*/

TVOID TMemCopy(TAPTR from, TAPTR to, TUINT numbytes)
{
	kn_memcopy(from, to, numbytes);
}
