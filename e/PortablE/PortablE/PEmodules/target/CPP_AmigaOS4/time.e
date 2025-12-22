OPT NATIVE
{#include <time.h>}
/*
 * $Id: time.h,v 1.7 2006/01/08 12:06:14 obarthel Exp $
 *
 * :ts=4
 *
 * Portable ISO 'C' (1994) runtime library for the Amiga computer
 * Copyright (c) 2002-2006 by Olaf Barthel <olsen (at) sourcery.han.de>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   - Neither the name of Olaf Barthel nor the names of contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************
 *
 * Documentation and source code for this library, and the most recent library
 * build are available from <http://sourceforge.net/projects/clib2>.
 *
 *****************************************************************************
 */

NATIVE {_TIME_H} DEF

/****************************************************************************/

/*
 * Divide the number returned by clock() by CLOCKS_PER_SEC to obtain
 * the elapsed time in seconds
 */
NATIVE {CLOCKS_PER_SEC} CONST CLOCKS_PER_SEC = 50

/****************************************************************************/

NATIVE {clock_t} OBJECT
TYPE CLOCK_T IS NATIVE {clock_t} VALUE
NATIVE {time_t} OBJECT
TYPE TIME_T IS NATIVE {time_t} VALUE

/* from stddef.h */
TYPE SIZE_T IS NATIVE {size_t} VALUE

/****************************************************************************/

NATIVE {tm} OBJECT tm
	{tm_sec}	sec	:VALUE		/* Number of seconds past the minute (0..59) */
	{tm_min}	min	:VALUE		/* Number of minutes past the hour (0..59) */
	{tm_hour}	hour	:VALUE	/* Number of hours past the day (0..23) */
	{tm_mday}	mday	:VALUE	/* Day of the month (1..31) */
	{tm_mon}	mon	:VALUE		/* Month number (0..11) */
	{tm_year}	year	:VALUE	/* Year number minus 1900 */
	{tm_wday}	wday	:VALUE	/* Day of the week (0..6; 0 is Sunday) */
	{tm_yday}	yday	:VALUE	/* Day of the year (0..365) */
	{tm_isdst}	isdst	:VALUE	/* Is this date using daylight savings time? */
ENDOBJECT

/****************************************************************************/

->NATIVE {clock} PROC
PROC clock() IS NATIVE {clock()} ENDNATIVE !!CLOCK_T
->NATIVE {time} PROC
PROC time(t:PTR TO TIME_T) IS NATIVE {time(} t {)} ENDNATIVE !!TIME_T
->NATIVE {asctime} PROC
PROC asctime(tm:PTR TO tm) IS NATIVE {asctime(} tm {)} ENDNATIVE !!ARRAY OF CHAR
->NATIVE {ctime} PROC
PROC ctime(t:PTR TO TIME_T) IS NATIVE {ctime(} t {)} ENDNATIVE !!ARRAY OF CHAR
->NATIVE {gmtime} PROC
PROC gmtime(t:PTR TO TIME_T) IS NATIVE {gmtime(} t {)} ENDNATIVE !!PTR TO tm
->NATIVE {localtime} PROC
PROC localtime(t:PTR TO TIME_T) IS NATIVE {localtime(} t {)} ENDNATIVE !!PTR TO tm
->NATIVE {mktime} PROC
PROC mktime(tm:PTR TO tm) IS NATIVE {mktime(} tm {)} ENDNATIVE !!TIME_T

/****************************************************************************/

->NATIVE {difftime} PROC
PROC difftime(t1:TIME_T,t0:TIME_T) IS NATIVE {difftime(} t1 {,} t0 {)} ENDNATIVE !!NATIVE {double} FLOAT

/****************************************************************************/

->NATIVE {strftime} PROC
PROC strftime(s:PTR TO CHAR, maxsize:SIZE_T, format:PTR TO CHAR, tm:PTR TO tm) IS NATIVE {strftime(} s {,} maxsize {,} format {,} tm {)} ENDNATIVE !!SIZE_T

/****************************************************************************/

/* The following is not part of the ISO 'C' (1994) standard. */

/****************************************************************************/

->NATIVE {asctime_r} PROC
PROC asctime_r(tm:PTR TO tm,buffer:ARRAY OF CHAR) IS NATIVE {asctime_r(} tm {,} buffer {)} ENDNATIVE !!ARRAY OF CHAR
->NATIVE {ctime_r} PROC
PROC ctime_r(tptr:PTR TO TIME_T,buffer:ARRAY OF CHAR) IS NATIVE {ctime_r(} tptr {,} buffer {)} ENDNATIVE !!ARRAY OF CHAR
->NATIVE {gmtime_r} PROC
PROC gmtime_r(t:PTR TO TIME_T,tm_ptr:PTR TO tm) IS NATIVE {gmtime_r(} t {,} tm_ptr {)} ENDNATIVE !!PTR TO tm
->NATIVE {localtime_r} PROC
PROC localtime_r(t:PTR TO TIME_T,tm_ptr:PTR TO tm) IS NATIVE {localtime_r(} t {,} tm_ptr {)} ENDNATIVE !!PTR TO tm

/****************************************************************************/
