/* Copyright 2011 Fredrik Wikstrom. All rights reserved.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions
** are met:
**
** 1. Redistributions of source code must retain the above copyright
**    notice, this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright
**    notice, this list of conditions and the following disclaimer in the
**    documentation and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
** IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
** ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
** LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
** CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
** SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
** INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
** CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
** POSSIBILITY OF SUCH DAMAGE.
*/

#include "w32private.h"

static BYTE days_in_month[]={0,31,28,31,30,31,30,31,31,30,31,30,31};
static inline WORD LeapYear (WORD year);
static inline WORD LeapMonth (WORD year, WORD month);

BOOL WINAPI FileTimeToSystemTime (const FILETIME *lpFileTime,
	LPSYSTEMTIME lpSystemTime)
{
	QWORD windowstime;
	DWORD year, month, day, daycode, milliseconds, yearlen, monthlen;
	windowstime = ((QWORD)lpFileTime->dwHighDateTime << 32)|(lpFileTime->dwLowDateTime);
	year = 1601;
	month = 1;
	day = 1UL + (windowstime / _DAY);
	daycode = day % 7UL;
	milliseconds = (windowstime % _DAY) / _MILLISECOND;
	while (day > (yearlen = 365 + LeapYear(year))) {
		day -= yearlen;
		year++;
	}
	while (day > (monthlen = days_in_month[month] + LeapMonth(year, month))) {
		day -= monthlen;
		month++;
	}
	lpSystemTime->wYear = year;
	lpSystemTime->wMonth = month;
	lpSystemTime->wDayOfWeek = daycode;
	lpSystemTime->wDay = day;
	lpSystemTime->wHour = milliseconds / (60UL * 60UL * 1000UL);
	lpSystemTime->wMinute = (milliseconds % (60UL * 60UL * 1000UL)) / (60UL * 1000UL);
	lpSystemTime->wSecond = (milliseconds % (60UL * 1000UL)) / 1000UL;
	lpSystemTime->wMilliseconds = milliseconds % 1000UL;
	return TRUE;
}

static inline WORD LeapYear (WORD year) {
	if ((year % 4) == 0 && ((year % 100) != 0 || (year % 400) == 0)) {
		return 1;
	} else {
		return 0;
	}
}

static inline WORD LeapMonth (WORD year, WORD month) {
	if (month == 2) {
		return LeapYear(year);
	} else {
		return 0;
	}
}
