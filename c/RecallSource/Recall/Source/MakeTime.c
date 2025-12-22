/*
 *	File:					MakeTime.c
 *	Description:	Returns the time in a time_t value
 *
 *	(C) 1993-1995 Ketil Hunn
 *
 */

#ifndef MAKETIME_C
#define MAKETIME_C

/*** INCLUDES ************************************************************************/
#include "System_Recall.h"
#include <time.h>
#include <string.h>
#include <dos.h>
#include "AdjustYear.h"

#include <clib/timer_protos.h>

/*** FUNCTIONS ***********************************************************************/
ULONG MakeTime(struct DateNode *node)
{
	struct timeval		tv;
	struct ClockData	clockdata;

#ifdef MYDEBUG_H
	DebugOut("MakeTime");
#endif
	GetSysTime(&tv);
	Amiga2Date(tv.tv_secs, &clockdata);
	clockdata.sec=0;

	if(node!=NULL)
	{
		if(node->hour>NONE)
			clockdata.hour	=node->hour;
		if(node->minutes>NONE)
			clockdata.min		=node->minutes;
	}
	return CheckDate(&clockdata);
}

#endif
