
#include "tek/util.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TGetRandom(TINT seed)
**
**	calculate pseudo random number from seed
*/

TINT TGetRandom(TINT seed)
{
	TUINT lo, hi;

	lo = 16807 * (TINT) (seed & 0xffff);
	hi = 16807 * (TINT) ((TUINT) seed >> 16);
	lo += (hi & 0x7fff) << 16;
	if (lo > 2147483647)
	{
		lo &= 2147483647;
		++lo;
	}
	lo += hi >> 15;
	if (lo > 2147483647)
	{
		lo &= 2147483647;
		++lo;
	}
	
	return (TINT) lo;
}
