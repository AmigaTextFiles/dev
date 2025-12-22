OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
MODULE 'target/x86_64-linux-gnu/sys/types'	->guessed
MODULE 'target/features'
MODULE 'target/stddef'
/* This defines CLOCKS_PER_SEC, which is the number of processor clock
   ticks per second, and possibly a number of other constants.   */
MODULE 'target/x86_64-linux-gnu/bits/time'

/* Many of the typedefs and structs whose official home is this header
   may also need to be defined by other headers.  */
MODULE 'target/x86_64-linux-gnu/bits/types/clock_t'
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/types/time_t'
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/types/struct_tm'

 MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'

 MODULE 'target/x86_64-linux-gnu/bits/types/clockid_t'
 MODULE 'target/x86_64-linux-gnu/bits/types/timer_t'
 MODULE 'target/x86_64-linux-gnu/bits/types/struct_itimerspec'
 MODULE 'target/x86_64-linux-gnu/bits/types/locale_t'
{#include <time.h>}
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

NATIVE {_TIME_H}	CONST ->_TIME_H	= 1


->NATIVE {__need_size_t} DEF
->NATIVE {__need_NULL} DEF

NATIVE {sigevent} OBJECT sigevent
ENDOBJECT

->NATIVE {pid_t} OBJECT
->TYPE PID_T IS NATIVE {pid_t} PID_T__
  ->NATIVE {__pid_t_defined} DEF

/* Time base values for timespec_get.  */
 NATIVE {TIME_UTC} CONST TIME_UTC = 1


/* Time used by the program so far (user time + system time).
   The result / CLOCKS_PER_SEC is program time in seconds.  */
NATIVE {clock} PROC
PROC clock() IS NATIVE {clock()} ENDNATIVE !!CLOCK_T

/* Return the current time and put it in *TIMER if TIMER is not NULL.  */
NATIVE {time} PROC
PROC time(__timer:PTR TO TIME_T) IS NATIVE {time(} __timer {)} ENDNATIVE !!TIME_T

/* Return the difference between TIME1 and TIME0.  */
NATIVE {difftime} PROC
PROC difftime(__time1:TIME_T, __time0:TIME_T) IS NATIVE {difftime(} __time1 {,} __time0 {)} ENDNATIVE !!NATIVE {double} FLOAT

/* Return the `TIME_T' representation of TP and normalize TP.  */
NATIVE {mktime} PROC
PROC mktime(__tp:PTR TO tm) IS NATIVE {mktime(} __tp {)} ENDNATIVE !!TIME_T


/* Format TP into S according to FORMAT.
   Write no more than MAXSIZE characters and return the number
   of characters written, or 0 if it would exceed MAXSIZE.  */
NATIVE {strftime} PROC
PROC strftime(__s:ARRAY OF CHAR, __maxsize:SIZE_T,
			__format:ARRAY OF CHAR,
			__tp:PTR TO tm) IS NATIVE {strftime(} __s {,} __maxsize {,} __format {,} __tp {)} ENDNATIVE !!SIZE_T

/* Parse S according to FORMAT and store binary time information in TP.
   The return value is a pointer to the first unparsed character in S.  */
NATIVE {strptime} PROC
PROC strptime(__s:ARRAY OF CHAR,
		       __fmt:ARRAY OF CHAR, __tp:PTR TO tm) IS NATIVE {strptime(} __s {,} __fmt {,} __tp {)} ENDNATIVE !!ARRAY OF CHAR

/* Similar to the two functions above but take the information from
   the provided locale and not the global locale.  */

NATIVE {strftime_l} PROC
PROC strftime_l(__s:ARRAY OF CHAR, __maxsize:SIZE_T,
			  __format:ARRAY OF CHAR,
			  __tp:PTR TO tm,
			  __loc:LOCALE_T) IS NATIVE {strftime_l(} __s {,} __maxsize {,} __format {,} __tp {,} __loc {)} ENDNATIVE !!SIZE_T

NATIVE {strptime_l} PROC
PROC strptime_l(__s:ARRAY OF CHAR,
			 __fmt:ARRAY OF CHAR, __tp:PTR TO tm,
			 __loc:LOCALE_T) IS NATIVE {strptime_l(} __s {,} __fmt {,} __tp {,} __loc {)} ENDNATIVE !!ARRAY OF CHAR


/* Return the `struct tm' representation of *TIMER
   in Universal Coordinated Time (aka Greenwich Mean Time).  */
NATIVE {gmtime} PROC
PROC gmtime(__timer:PTR TO TIME_T) IS NATIVE {gmtime(} __timer {)} ENDNATIVE !!PTR TO tm

/* Return the `struct tm' representation
   of *TIMER in the local timezone.  */
NATIVE {localtime} PROC
PROC localtime(__timer:PTR TO TIME_T) IS NATIVE {localtime(} __timer {)} ENDNATIVE !!PTR TO tm

/* Return the `struct tm' representation of *TIMER in UTC,
   using *TP to store the result.  */
NATIVE {gmtime_r} PROC
PROC gmtime_r(__timer:PTR TO TIME_T,
			    __tp:PTR TO tm) IS NATIVE {gmtime_r(} __timer {,} __tp {)} ENDNATIVE !!PTR TO tm

/* Return the `struct tm' representation of *TIMER in local time,
   using *TP to store the result.  */
NATIVE {localtime_r} PROC
PROC localtime_r(__timer:PTR TO TIME_T,
			       __tp:PTR TO tm) IS NATIVE {localtime_r(} __timer {,} __tp {)} ENDNATIVE !!PTR TO tm

/* Return a string of the form "Day Mon dd hh:mm:ss yyyy\n"
   that is the representation of TP in this format.  */
NATIVE {asctime} PROC
PROC asctime(__tp:PTR TO tm) IS NATIVE {asctime(} __tp {)} ENDNATIVE !!ARRAY OF CHAR

/* Equivalent to `asctime (localtime (timer))'.  */
NATIVE {ctime} PROC
PROC ctime(__timer:PTR TO TIME_T) IS NATIVE {ctime(} __timer {)} ENDNATIVE !!ARRAY OF CHAR

/* Reentrant versions of the above functions.  */

/* Return in BUF a string of the form "Day Mon dd hh:mm:ss yyyy\n"
   that is the representation of TP in this format.  */
NATIVE {asctime_r} PROC
PROC asctime_r(__tp:PTR TO tm,
			__buf:ARRAY OF CHAR) IS NATIVE {asctime_r(} __tp {,} __buf {)} ENDNATIVE !!ARRAY OF CHAR

/* Equivalent to `asctime_r (localtime_r (timer, *TMP*), buf)'.  */
NATIVE {ctime_r} PROC
PROC ctime_r(__timer:PTR TO TIME_T,
		      __buf:ARRAY OF CHAR) IS NATIVE {ctime_r(} __timer {,} __buf {)} ENDNATIVE !!ARRAY OF CHAR


/* Defined in localtime.c.  */
->NATIVE {__tzname} DEF	/* Current timezone names.  */
->NATIVE {__daylight} DEF		/* If daylight-saving time is ever in use.  */
->NATIVE {__timezone} DEF	/* Seconds west of UTC.  */


/* Same as above.  */
NATIVE {tzname} DEF

/* Set time conversion information from the TZ environment variable.
   If TZ is not defined, a locale-dependent default is used.  */
NATIVE {tzset} PROC
PROC tzset() IS NATIVE {tzset()} ENDNATIVE

NATIVE {daylight} DEF
->NATIVE {timezone} DEF


/* Nonzero if YEAR is a leap year (every 4 years,
   except every 100th isn't, and every 400th is).  */
->NATIVE {__isleap} PROC	->define __isleap(year)	((year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0))


/* Miscellaneous functions many Unices inherited from the public domain
   localtime package.  These are included only for compatibility.  */

/* Like `mktime', but for TP represents Universal Time, not local time.  */
NATIVE {timegm} PROC
PROC timegm(__tp:PTR TO tm) IS NATIVE {timegm(} __tp {)} ENDNATIVE !!TIME_T

/* Another name for `mktime'.  */
NATIVE {timelocal} PROC
PROC timelocal(__tp:PTR TO tm) IS NATIVE {timelocal(} __tp {)} ENDNATIVE !!TIME_T

/* Return the number of days in YEAR.  */
NATIVE {dysize} PROC
PROC dysize(__year:VALUE) IS NATIVE {dysize( (int) } __year {)} ENDNATIVE !!VALUE


/* Pause execution for a number of nanoseconds.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {nanosleep} PROC
PROC nanosleep(__requested_time:PTR TO timespec,
		      __remaining:PTR TO timespec) IS NATIVE {nanosleep(} __requested_time {,} __remaining {)} ENDNATIVE !!VALUE


/* Get resolution of clock CLOCK_ID.  */
NATIVE {clock_getres} PROC
PROC clock_getres(__clock_id:CLOCKID_T, __res:PTR TO timespec) IS NATIVE {clock_getres(} __clock_id {,} __res {)} ENDNATIVE !!VALUE

/* Get current value of clock CLOCK_ID and store it in TP.  */
NATIVE {clock_gettime} PROC
PROC clock_gettime(__clock_id:CLOCKID_T, __tp:PTR TO timespec) IS NATIVE {clock_gettime(} __clock_id {,} __tp {)} ENDNATIVE !!VALUE

/* Set clock CLOCK_ID to value TP.  */
NATIVE {clock_settime} PROC
PROC clock_settime(__clock_id:CLOCKID_T, __tp:PTR TO timespec) IS NATIVE {clock_settime(} __clock_id {,} __tp {)} ENDNATIVE !!VALUE

/* High-resolution sleep with the specified clock.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {clock_nanosleep} PROC
PROC clock_nanosleep(__clock_id:CLOCKID_T, __flags:VALUE,
			    __req:PTR TO timespec,
			    __rem:PTR TO timespec) IS NATIVE {clock_nanosleep(} __clock_id {, (int) } __flags {,} __req {,} __rem {)} ENDNATIVE !!VALUE

/* Return clock ID for CPU-time clock.  */
NATIVE {clock_getcpuclockid} PROC
PROC clock_getcpuclockid(__pid:PID_T, __clock_id:PTR TO CLOCKID_T) IS NATIVE {clock_getcpuclockid(} __pid {,} __clock_id {)} ENDNATIVE !!VALUE


/* Create new per-process timer using CLOCK_ID.  */
NATIVE {timer_create} PROC
->PROC timer_create(__clock_id:CLOCKID_T, __evp:PTR TO sigevent, __timerid:PTR TO TIMER_T) IS NATIVE {timer_create(} __clock_id {,} __evp {,} __timerid {)} ENDNATIVE !!VALUE

/* Delete timer TIMERID.  */
NATIVE {timer_delete} PROC
->PROC timer_delete(__timerid:TIMER_T) IS NATIVE {timer_delete(} __timerid {)} ENDNATIVE !!VALUE

/* Set timer TIMERID to VALUE, returning old value in OVALUE.  */
NATIVE {timer_settime} PROC
->PROC timer_settime(__timerid:TIMER_T, __flags:VALUE, __value:PTR TO itimerspec, __ovalue:PTR TO itimerspec) IS NATIVE {timer_settime(} __timerid {, (int) } __flags {,} __value {,} __ovalue {)} ENDNATIVE !!VALUE

/* Get current value of timer TIMERID and store it in VALUE.  */
NATIVE {timer_gettime} PROC
->PROC timer_gettime(__timerid:TIMER_T, __value:PTR TO itimerspec) IS NATIVE {timer_gettime(} __timerid {,} __value {)} ENDNATIVE !!VALUE

/* Get expiration overrun for timer TIMERID.  */
NATIVE {timer_getoverrun} PROC
->PROC timer_getoverrun(__timerid:TIMER_T) IS NATIVE {timer_getoverrun(} __timerid {)} ENDNATIVE !!VALUE


/* Set TS to calendar time based in time base BASE.  */
NATIVE {timespec_get} PROC
PROC timespec_get(__ts:PTR TO timespec, __base:VALUE) IS NATIVE {timespec_get(} __ts {, (int) } __base {)} ENDNATIVE !!VALUE


/* Set to one of the following values to indicate an error.
     1  the DATEMSK environment variable is null or undefined,
     2  the template file cannot be opened for reading,
     3  failed to get file status information,
     4  the template file is not a regular file,
     5  an error is encountered while reading the template file,
     6  memory allication failed (not enough memory available),
     7  there is no line in the template that matches the input,
     8  invalid input specification Example: February 31 or a time is
	specified that can not be represented in a TIME_T (representing
	the time in seconds since 00:00:00 UTC, January 1, 1970) */
NATIVE {getdate_err} DEF

/* Parse the given string as a date specification and return a value
   representing the value.  The templates from the file identified by
   the environment variable DATEMSK are used.  In case of an error
   `getdate_err' is set.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {getdate} PROC
PROC getdate(__string:ARRAY OF CHAR) IS NATIVE {getdate(} __string {)} ENDNATIVE !!PTR TO tm

/* Since `getdate' is not reentrant because of the use of `getdate_err'
   and the static buffer to return the result in, we provide a thread-safe
   variant.  The functionality is the same.  The result is returned in
   the buffer pointed to by RESBUFP and in case of an error the return
   value is != 0 with the same values as given above for `getdate_err'.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
NATIVE {getdate_r} PROC
PROC getdate_r(__string:ARRAY OF CHAR,
		      __resbufp:PTR TO tm) IS NATIVE {getdate_r(} __string {,} __resbufp {)} ENDNATIVE !!VALUE
