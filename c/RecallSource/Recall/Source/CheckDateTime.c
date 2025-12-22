/*
 *	File:					CheckDateTime.c
 *	Description:	Functions to handle and check date, time and calcfields.
 *
 *	(C) 1993-1994, Ketil Hunn
 *
 */

#ifndef CHECKDATETIME_C
#define CHECKDATETIME_C

/*** INCLUDES ************************************************************************/
#include "System_Recall.h"
#include "CheckDateTime.h"
#include "CalcField.h"
#include <time.h>
#include <string.h>
#include <dos.h>

#include <clib/timer_protos.h>

/*** FUNCTIONS ***********************************************************************/
__inline BYTE getWeekday(void)
{
	struct 	ClockData	clockdata;
	struct timeval		tv;

#ifdef MYDEBUG_H
	DebugOut("getWeekday");
#endif

	GetSysTime(&tv);
	Amiga2Date(tv.tv_secs, &clockdata);
	return (BYTE)clockdata.wday;
}

int CheckPrefixDate(struct QuickNode *quicknode)
{
	struct DateNode *datenode=quicknode->datenode;

#ifdef MYDEBUG_H
	DebugOut("CheckPrefixDate");
#endif

	switch(datenode->whendate)
	{
		case EXACT:
			return (datenow==quicknode->date);
			break;

		case BEFORE:
			return (datenow<=quicknode->date);
			break;

		case AFTER:
			return (datenow>=quicknode->date);
			break;
	}
	return FALSE;
}

BYTE CheckNodeDate(struct QuickNode *quicknode)
{
	register struct DateNode		*datenode	=quicknode->datenode;
	register BYTE display=FALSE;

#ifdef MYDEBUG_H
	DebugOut("CheckNodeDate");
#endif

	if(quicknode->date==0)
		display=TRUE;
	else if(CheckPrefixDate(quicknode))
	{
		if(datenode->whendate==EXACT)
			display=TRUE;
		else
		{
			int count=countDays(datenode);

			if(datenode->daterepeat==0)
			{
				if(count<=datenode->dateperiod | datenode->dateperiod==0)
					display=TRUE;
			}
			else if(count%datenode->daterepeat==0 &&
							(count<=datenode->dateperiod | datenode->dateperiod==0))
				display=TRUE;
		}
	}

	if(display && datenode && datenode->weekdays && datenode->weekdays!=127)
	{
		register BYTE weekbits=0;

		switch(getWeekday())
		{
			case SUNDAY:
				SETBIT(weekbits, FSUNDAY);
				break;
			case MONDAY:
				SETBIT(weekbits, FMONDAY);
				break;
			case TUESDAY:
				SETBIT(weekbits, FTUESDAY);
				break;
			case WEDNESDAY:
				SETBIT(weekbits, FWEDNESDAY);
				break;
			case THURSDAY:
				SETBIT(weekbits, FTHURSDAY);
				break;
			case FRIDAY:
				SETBIT(weekbits, FFRIDAY);
				break;
			case SATURDAY:
				SETBIT(weekbits, FSATURDAY);
				break;
		}
		if(!ISBITSET(weekbits, datenode->weekdays))
			display=FALSE;
	}
	return display;
}

int CheckPrefixTime(struct QuickNode *quicknode)
{
#ifdef MYDEBUG_H
	DebugOut("CheckPrefixTime");
#endif
	switch(quicknode->datenode->whentime)
	{
		case EXACT:
			return (timenow==quicknode->time);
			break;

		case BEFORE:
			return (timenow<=quicknode->time);
			break;

		case AFTER:
			return (timenow>=quicknode->time);
			break;
	}
	return FALSE;
}

int CheckNodeTime(struct QuickNode *quicknode)
{
	struct DateNode		*datenode	=quicknode->datenode;

#ifdef MYDEBUG_H
	DebugOut("CheckNodeTime");
#endif

	if(datenode==NULL)
		return 1;
	if(quicknode->datenode->hour==NONE && quicknode->datenode->minutes==NONE)
		return 1;

	if(CheckPrefixTime(quicknode))
	{
		if(datenode->whentime==EXACT)
			return 1;
		else
		{
			int count=countMins(datenode);

			if(datenode->timerepeat==0)
				return (count<=datenode->timeperiod | datenode->timeperiod==0);
			else if(count%datenode->timerepeat==0)
				return (count<=datenode->timeperiod | datenode->timeperiod==0);
		}
	}
	return 0;
}

BYTE CheckNodeDateTime(struct QuickNode *quicknode)
{
#ifdef MYDEBUG_H
	DebugOut("CheckNodeDateTime");
#endif
	return (BYTE)(CheckNodeDate(quicknode) && CheckNodeTime(quicknode));
}
#endif
