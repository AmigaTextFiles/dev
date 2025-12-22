/*
 *	File:					CalcField.c
 *	Description:	Replaces date fields with it's true value.
 *
 *	(C) 1993,1994,1995 Ketil Hunn
 *
 */

#ifndef CALCFIELD_C
#define CALCFIELD_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "CalcField.h"
#include "TASK_Date.h"
#include "AdjustYear.h"
#include "MakeDate.h"
#include "MakeTime.h"
#include "DateList.h"

#include <time.h>
#include <string.h>
#include <dos.h>
#include <dos/datetime.h>

#include <clib/timer_protos.h>


/*** DEFINES *************************************************************************/
#define	FIELD_COUNTDAYS					1
#define	FIELD_COUNTMONTHS				2
#define	FIELD_COUNTYEARS				3
#define	FIELD_COUNTHOURS				4
#define	FIELD_COUNTMINUTES			5
#define	FIELD_DATE							6
#define	FIELD_TIME							7
#define	FIELD_MONTH							8
#define	FIELD_DAY								9
#define	FIELD_YEAR							10
#define	FIELD_HOUR							11
#define	FIELD_MINUTE						12
#define	FIELD_WEEKDAY						13
#define	FIELD_TIMELAPSE					14

#define	FIELD_COUNTDAYS_LEN			6
#define	FIELD_COUNTMONTHS_LEN		8
#define	FIELD_COUNTYEARS_LEN		7
#define	FIELD_COUNTHOURS_LEN		7
#define	FIELD_COUNTMINUTES_LEN	9
#define	FIELD_TIMELAPSE_LEN			11
#define	FIELD_DATE_LEN					6
#define	FIELD_TIME_LEN					6
#define	FIELD_DAY_LEN						5
#define	FIELD_MONTH_LEN					7
#define	FIELD_YEAR_LEN					6
#define	FIELD_HOUR_LEN					6
#define	FIELD_MINUTE_LEN				8
#define	FIELD_WEEKDAY_LEN				9

#define	DATE_LEN								11
#define	TIME_LEN								6

#define	PREVVALUE								-1
#define	NEXTVALUE								-2

/*** FUNCTIONS ***********************************************************************/
void fillblanks(struct DateNode *node)
{
	struct timeval		tv;
	struct ClockData	clockdata;

	GetSysTime(&tv);
	Amiga2Date(tv.tv_secs, &clockdata);

	if(node->day==0)
		node->day=clockdata.mday;
	if(node->month==0)
		node->month=clockdata.month;
	if(node->year==0)
		node->year=AdjustYear(clockdata.year);

	if(node->hour==-1)
		node->hour=clockdata.hour;
	if(node->minutes==-1)
		node->minutes=clockdata.min;
}

void stringToDate(char *datestr, struct DateNode *node)
{
	char tmp[3], *dummy;

	if(strmid(datestr, tmp, 1, 2)==0)
	{
		node->day=strtol(tmp, &dummy, 10);
		if(strmid(datestr, tmp, 4, 2)==0)
		{
			node->month=strtol(tmp, &dummy, 10);
			if(strmid(datestr, tmp, 7, 4)==0)
				node->year=strtol(tmp, &dummy, 10);
		}
	}
	fillblanks(node);
}

void stringToTime(char *datestr, struct DateNode *node)
{
	char tmp[3], *dummy;

	if(strmid(datestr, tmp, 1, 2)==0)
	{
//printf("%s\n", tmp);
		node->hour=strtol(tmp, &dummy, 10);
		if(strmid(datestr, tmp, 4, 2)==0)
			node->minutes=strtol(tmp, &dummy, 10);
//printf("%s\n", tmp);
	}
	fillblanks(node);
}

ULONG countDays(struct DateNode *node)
{
	struct DateStamp *date;
	time_t t;
	LONG	days1, days2;

	t=MakeDate(NULL);
	date=__timecvt(t);
	days1=date->ds_Days;

	t=MakeDate(node);
	date=__timecvt(t);
	days2=date->ds_Days;

	return (ULONG)ABS(days2-days1);
}

LONG countMins(struct DateNode *node)
{
	ULONG stamp1=datenow+timenow,
				stamp2=MakeDate(node)+MakeTime(node);
	LONG	stamp3=stamp1-stamp2;

	return ABS(stamp3)/60;
}

LONG countHours(struct DateNode *node)
{
	ULONG stamp1=datenow+timenow,
				stamp2=MakeDate(node)+MakeTime(node);
	LONG	stamp3=stamp1-stamp2;

	return ABS(stamp3)/3600;
}

LONG MatchField(UBYTE *field)
{
	if(0==Strnicmp(field, "{days:", FIELD_COUNTDAYS_LEN))
		return FIELD_COUNTDAYS;
	else if(0==Strnicmp(field, "{months:", FIELD_COUNTMONTHS_LEN))
		return FIELD_COUNTMONTHS;
	else if(0==Strnicmp(field, "{years:", FIELD_COUNTYEARS_LEN))
		return FIELD_COUNTYEARS;
	else if(0==Strnicmp(field, "{hours:", FIELD_COUNTHOURS_LEN))
		return FIELD_COUNTHOURS;
	else if(0==Strnicmp(field, "{minutes:", FIELD_COUNTMINUTES_LEN))
		return FIELD_COUNTMINUTES;
	else if(0==Strnicmp(field, "{date}", FIELD_DATE_LEN))
		return FIELD_DATE;
	else if(0==Strnicmp(field, "{time}", FIELD_TIME_LEN))
		return FIELD_TIME;
	else if(0==Strnicmp(field, "{day}", FIELD_DAY_LEN))
		return FIELD_DAY;
	else if(0==Strnicmp(field, "{month}", FIELD_MONTH_LEN))
		return FIELD_MONTH;
	else if(0==Strnicmp(field, "{year}", FIELD_YEAR_LEN))
		return FIELD_YEAR;
	else if(0==Strnicmp(field, "{hour}", FIELD_HOUR_LEN))
		return FIELD_HOUR;
	else if(0==Strnicmp(field, "{minute}", FIELD_MINUTE_LEN))
		return FIELD_MINUTE;
	else if(0==Strnicmp(field, "{weekday}", FIELD_WEEKDAY_LEN))
		return FIELD_WEEKDAY;
	else if(0==Strnicmp(field, "{timelapse:", FIELD_TIMELAPSE_LEN))
		return FIELD_TIMELAPSE;
	return 0;
}

UBYTE *ParseFields(struct QuickNode *quicknode, UBYTE *newtext, UBYTE *text)
{
	register UBYTE *c, *f=text;
	struct DateTime dt;
	struct timeval		tv;
	struct ClockData	clockdata;
	UBYTE	date[LEN_DATSTRING],
				time[LEN_DATSTRING],
				weekday[LEN_DATSTRING],
				unit[5];
	struct DateNode	datenode;

	GetSysTime(&tv);
	Amiga2Date(tv.tv_secs, &clockdata);

	DateStamp(&dt.dat_Stamp);
	dt.dat_Format	 = 4;
	dt.dat_Flags	 = NULL;
	dt.dat_StrDay  = weekday;
	dt.dat_StrDate = date;
	dt.dat_StrTime = time;

	DateToStr(&dt);

	while(c=strchr(f, '{'))
	{
		UBYTE field=MatchField(c);

		*c='\0';
		strcat(newtext, f);

		switch(field)
		{
			case FIELD_COUNTDAYS:
				stringToDate((char *)c+FIELD_COUNTDAYS_LEN, &datenode);
				sprintf(unit, "%ld", countDays(&datenode));
				strcat(newtext, unit);
				f=c+FIELD_COUNTDAYS_LEN+DATE_LEN;
				break;
			case FIELD_COUNTMONTHS:
				stringToDate((char *)c+FIELD_COUNTMONTHS_LEN, &datenode);
				sprintf(unit, "%ld", countDays(&datenode)/31);
				strcat(newtext, unit);
				f=c+FIELD_COUNTMONTHS_LEN+DATE_LEN;
				break;
			case FIELD_COUNTYEARS:
				{
					register ULONG years;

					stringToDate((char *)c+FIELD_COUNTYEARS_LEN, &datenode);
					years=(ULONG)ABS(datenode.year-clockdata.year);
					if(clockdata.month<datenode.month |
						(clockdata.month==datenode.month & clockdata.mday<datenode.day))
						--years;
					sprintf(unit, "%ld", years);
					strcat(newtext, unit);
					f=c+FIELD_COUNTYEARS_LEN+DATE_LEN;
				}
				break;
			case FIELD_COUNTHOURS:
				stringToDate((char *)c+FIELD_COUNTHOURS_LEN, 	&datenode);
				stringToTime((char *)c+FIELD_COUNTHOURS_LEN+DATE_LEN, &datenode);
				sprintf(unit, "%ld", countHours(&datenode));
				strcat(newtext, unit);
				f=c+FIELD_COUNTHOURS_LEN+DATE_LEN+TIME_LEN;
				break;
			case FIELD_COUNTMINUTES:
				stringToDate((char *)c+FIELD_COUNTMINUTES_LEN, &datenode);
				stringToTime((char *)c+FIELD_COUNTMINUTES_LEN+DATE_LEN, &datenode);
				sprintf(unit, "%ld", countMins(&datenode));
				strcat(newtext, unit);
				f=c+FIELD_COUNTMINUTES_LEN+DATE_LEN+TIME_LEN;
				break;
			case FIELD_TIMELAPSE:
				stringToDate((char *)c+FIELD_TIMELAPSE_LEN, &datenode);
				stringToTime((char *)c+FIELD_TIMELAPSE_LEN+DATE_LEN, &datenode);
				sprintf(unit, "%02ld:%02ld", countHours(&datenode), countMins(&datenode)%60);
				strcat(newtext, unit);
				f=c+FIELD_TIMELAPSE_LEN+DATE_LEN+TIME_LEN;
				break;
			case FIELD_DATE:
				strcat(newtext, date);
				f=c+FIELD_DATE_LEN;
				break;
			case FIELD_TIME:
				strcat(newtext, time);
				f=c+FIELD_TIME_LEN;
				break;
			case FIELD_DAY:
				sprintf(unit, "%ld", clockdata.mday);
				strcat(newtext, unit);
				f=c+FIELD_DAY_LEN;
				break;
			case FIELD_MONTH:
				sprintf(unit, "%ld", clockdata.month);
				strcat(newtext, unit);
				f=c+FIELD_MONTH_LEN;
				break;
			case FIELD_YEAR:
				sprintf(unit, "%ld", AdjustYear(clockdata.year));
				strcat(newtext, unit);
				f=c+FIELD_YEAR_LEN;
				break;
			case FIELD_HOUR:
				sprintf(unit, "%ld", clockdata.hour);
				strcat(newtext, unit);
				f=c+FIELD_HOUR_LEN;
				break;
			case FIELD_MINUTE:
				sprintf(unit, "%ld", clockdata.min);
				strcat(newtext, unit);
				f=c+FIELD_MINUTE_LEN;
				break;
			case FIELD_WEEKDAY:
				strcat(newtext, weekday);
				f=c+FIELD_WEEKDAY_LEN;
				break;
		}
	}
	if(*f!='\0')
		strcat(newtext, f);

	return newtext;
}


#endif
