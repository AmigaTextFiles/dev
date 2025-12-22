/*
 *	File:					MakeDate.c
 *	Description:	Returns the date in a time_t value
 *
 *	(C) 1993-1995 Ketil Hunn
 *
 */

#ifndef MAKEDATE_C
#define MAKEDATE_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System_Recall.h"
#include <devices/timer.h>
#include <clib/utility_protos.h>
#include <clib/timer_protos.h>
#include <string.h>
#include "AdjustYear.h"

/*** FUNCTIONS ***********************************************************************/
ULONG MakeDate(struct DateNode *node)
{
	struct timeval		tv;
	struct ClockData	clockdata;

#ifdef MYDEBUG_H
	DebugOut("MakeDate");
#endif

	GetSysTime(&tv);
	Amiga2Date(tv.tv_secs, &clockdata);
	clockdata.hour=clockdata.min=clockdata.sec=0;

	if(node!=NULL)
	{
		if(node->day)
			clockdata.mday	=node->day;
		if(node->month)
			clockdata.month	=node->month;
		if(node->year)
			clockdata.year	=AdjustYear(node->year);
	}
	return CheckDate(&clockdata);
}
#endif
