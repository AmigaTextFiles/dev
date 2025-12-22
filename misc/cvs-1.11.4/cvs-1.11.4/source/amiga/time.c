/*
 * $Id$
 *
 * :ts=4
 *
 * AmigaOS wrapper routines for GNU CVS, using the RoadShow TCP/IP API
 *
 * Written and adapted by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 *                        Jens Langner <Jens.Langner@light-speed.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "SDI_compiler.h"

#include <proto/utility.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <stdio.h>
#include <time.h>

/* includes only for SASC or which SASC don`t like */
#if defined(__SASC)
  #include <dos.h>
#endif

/****************************************************************************/

/*#define DEBUG*/
#include "_assert.h"

/****************************************************************************/

#define UNIX_TIME_OFFSET 252460800

/****************************************************************************/

extern int amiga_get_minutes_west(void);

/* add some features GNUC doesn`t provide by default
   and take care that the libnix of morphOS supports some of those per default
*/
#if defined(__GNUC__)

  #if !defined(__MORPHOS__)
    STRPTR _ProgramName;
    #define chkabort() __chkabort()
  #endif

  /* libnix catches the WB startup code for us, so we don`t need to worry */
  extern struct WBStartup *_WBenchMsg;
  #define WBenchMsg _WBenchMsg

  /* prototype for the chkabort() function (libnix supports it) */
  extern void chkabort();
#endif

/******************************************************************************/

/* This file contains replacements for the SAS/C run time library, with
 * respect to time and date management. They are in a separate file so that
 * they may be compiled with the params=both option, thus really replacing
 * the library routines of the same names.
 */

/******************************************************************************/

#if defined(__SASC)
void __tzset(void)
{
	static char time_zone_name[20] = "";

	/* This routine sets up the internal
	 * time zone variable according to
	 * the local settings.
	 */
	if(time_zone_name[0] == '\0')
	{
		int hours_west = amiga_get_minutes_west() / 60;

		if(hours_west >= 0)
			sprintf(time_zone_name,"GMT-%02d", hours_west);
		else
			sprintf(time_zone_name,"GMT+%02d",-hours_west);
	}

	_TZ = time_zone_name;
}
#endif

/******************************************************************************/

time_t
time(time_t *timeptr)
{
	time_t currentTime;
	struct DateStamp ds;
	LONG seconds;

  chkabort();

	DateStamp(&ds);

	seconds = ((ds.ds_Days * 24 * 60) + ds.ds_Minute) * 60 + (ds.ds_Tick / TICKS_PER_SECOND);

	currentTime = UNIX_TIME_OFFSET + seconds + 60 * amiga_get_minutes_west(); /* translate from local time to UTC */

	if(timeptr != NULL)
		(*timeptr) = currentTime;

	return(currentTime);
}

/******************************************************************************/

static struct tm *
convert_time(ULONG seconds)
{
	static struct tm tm;

	struct ClockData clockData;
	ULONG delta;

	Amiga2Date(seconds,&clockData);

	tm.tm_sec	= clockData.sec;
	tm.tm_min	= clockData.min;
	tm.tm_hour	= clockData.hour;
	tm.tm_mday	= clockData.mday;
	tm.tm_mon	= clockData.month - 1;
	tm.tm_year	= clockData.year - 1900;
	tm.tm_wday	= clockData.wday;
	tm.tm_isdst	= 0;

	clockData.mday = 1;
	clockData.month = 1;

	delta = Date2Amiga(&clockData);

	tm.tm_yday = (seconds - delta) / (24*60*60);

	return(&tm);
}

char *
asctime(const struct tm * tm)
{
	static char * month_names[12] =
	{
		"Jan","Feb","Mar","Apr",
		"May","Jun","Jul","Aug",
		"Sep","Oct","Nov","Dec"
	};

	static char * day_names[7] =
	{
		"Sun","Mon","Tue","Wed",
		"Thu","Fri","Sat"
	};

	static char result_buffer[40];
	char * month_name;
	char * day_name;

	month_name = (0 <= tm->tm_mon && tm->tm_mon < 12) ? month_names[tm->tm_mon] : "---";
	day_name = (0 <= tm->tm_wday && tm->tm_wday < 7) ? day_names[tm->tm_wday] : "---";

	sprintf(result_buffer,"%s %s %02d %02d:%02d:%02d %d\n",
		day_name,
		month_name,
		tm->tm_mday,
		tm->tm_hour,tm->tm_min,tm->tm_sec,
		tm->tm_year + 1900);

	return(result_buffer);
}

char *
ctime(const time_t * t)
{
	char * result;

	result = asctime(localtime(t));

	return(result);
}

struct tm *
gmtime(const time_t *t)
{
	struct tm * result;
	ULONG seconds;

	if((*t) < UNIX_TIME_OFFSET)
		seconds = 0;
	else
		seconds = (*t) - UNIX_TIME_OFFSET;

	result = convert_time(seconds);

	return(result);
}

struct tm *
localtime(const time_t *t)
{
	struct tm * result;
	ULONG seconds;

	if((*t) < (UNIX_TIME_OFFSET + 60 * amiga_get_minutes_west()))
		seconds = 0;
	else
		seconds = (*t) - (UNIX_TIME_OFFSET + 60 * amiga_get_minutes_west()); /* translate from UTC to local time */

	result = convert_time(seconds);

	return(result);
}
