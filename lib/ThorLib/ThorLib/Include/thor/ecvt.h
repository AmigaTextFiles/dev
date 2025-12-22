#ifndef THOR_ECVT_H
#define THOR_ECVT_H

#ifndef CONVERSIONS_H
#include <thor/conversions.h>
#endif

/*
 * this is required to have a static buffer. You shouldn't use this
 * if you need re-entrant programs
 */

char *ecvt(double value,int digits,int *index,int *sign)
{
static char buffer[20];

	if (digits < 20)
		return ecvtr(index,sign,buffer,&value,digits);
	else
		return 0;
}

#endif
