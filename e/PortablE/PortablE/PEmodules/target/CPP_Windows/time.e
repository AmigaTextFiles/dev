OPT NATIVE
MODULE 'target/_mingw'
PUBLIC MODULE 'target/sys/types'	->for TIME_T
{#include <time.h>}
/* 
 * time.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * Date and time functions and types.
 *
 */

NATIVE {_TIME_H_} DEF

/* All the headers include this file. */

/*
 * Number of clock ticks per second. A clock tick is the unit by which
 * processor time is measured and is returned by 'clock'.
 */
NATIVE {CLOCKS_PER_SEC}	CONST CLOCKS_PER_SEC	= 1000 !!VALUE /*CLOCK_T*/
NATIVE {CLK_TCK}		CONST CLK_TCK		= CLOCKS_PER_SEC


/*
 * A type for storing the current time and date. This is the number of
 * seconds since midnight Jan 1, 1970.
 * NOTE: This is also defined in non-ISO sys/types.h.
 */
/*
NATIVE {time_t} OBJECT
TYPE TIME_T IS NATIVE {time_t} VALUE
NATIVE {_TIME_T_DEFINED} DEF
*/

/* A 64-bit time_t to get to Y3K */
->NATIVE {_TIME64_T_DEFINED} DEF

/*
 * A type for measuring processor time (in clock ticks).
 */
NATIVE {clock_t} OBJECT
TYPE CLOCK_T IS NATIVE {clock_t} VALUE
NATIVE {_CLOCK_T_DEFINED} DEF

/*
 * A structure for storing all kinds of useful information about the
 * current (or another) time.
 */
NATIVE {tm} OBJECT tm
	{tm_sec}	sec	:VALUE		/* Seconds: 0-59 (K&R says 0-61?) */
	{tm_min}	min	:VALUE		/* Minutes: 0-59 */
	{tm_hour}	hour	:VALUE	/* Hours since midnight: 0-23 */
	{tm_mday}	mday	:VALUE	/* Day of the month: 1-31 */
	{tm_mon}	mon	:VALUE		/* Months *since* january: 0-11 */
	{tm_year}	year	:VALUE	/* Years since 1900 */
	{tm_wday}	wday	:VALUE	/* Days since Sunday (0-6) */
	{tm_yday}	yday	:VALUE	/* Days since Jan. 1: 0-365 */
	{tm_isdst}	isdst	:VALUE	/* +1 Daylight Savings Time, 0 No DST,
				 * -1 don't know */
ENDOBJECT
NATIVE {_TM_DEFINED} DEF

NATIVE {clock} PROC
PROC clock() IS NATIVE {clock()} ENDNATIVE !!CLOCK_T
NATIVE {time} PROC
PROC time(param:PTR TO TIME_T) IS NATIVE {time(} param {)} ENDNATIVE !!TIME_T
NATIVE {difftime} PROC
PROC difftime(param1:TIME_T, param2:TIME_T) IS NATIVE {difftime(} param1 {,} param2 {)} ENDNATIVE !!NATIVE {double} FLOAT
NATIVE {mktime} PROC
PROC mktime(param:PTR TO tm) IS NATIVE {mktime(} param {)} ENDNATIVE !!TIME_T

/*
 * These functions write to and return pointers to static buffers that may
 * be overwritten by other function calls. Yikes!
 *
 * NOTE: localtime, and perhaps the others of the four functions grouped
 * below may return NULL if their argument is not 'acceptable'. Also note
 * that calling asctime with a NULL pointer will produce an Invalid Page
 * Fault and crap out your program. Guess how I know. Hint: stat called on
 * a directory gives 'invalid' times in st_atime etc...
 */
NATIVE {asctime} PROC
PROC asctime(param1:PTR TO tm) IS NATIVE {asctime(} param1 {)} ENDNATIVE !!PTR TO CHAR
NATIVE {ctime} PROC
PROC ctime(param1:PTR TO TIME_T) IS NATIVE {ctime(} param1 {)} ENDNATIVE !!PTR TO CHAR
NATIVE {gmtime} PROC
PROC gmtime(param1:PTR TO TIME_T) IS NATIVE {gmtime(} param1 {)} ENDNATIVE !!PTR TO tm
NATIVE {localtime} PROC
PROC localtime(param1:PTR TO TIME_T) IS NATIVE {localtime(} param1 {)} ENDNATIVE !!PTR TO tm

NATIVE {strftime} PROC
PROC strftime(param1:ARRAY OF CHAR, param2:SIZE_T, param3:ARRAY OF CHAR, param4:PTR TO tm) IS NATIVE {strftime(} param1 {,} param2 {, (const char*)} param3 {, (const struct tm*)} param4 {)} ENDNATIVE !!SIZE_T

->#ifndef __STRICT_ANSI__

/*extern*/ NATIVE {_tzset} PROC
PROC _tzset() IS NATIVE {_tzset()} ENDNATIVE

/*extern*/ NATIVE {tzset} PROC
PROC tzset() IS NATIVE {tzset()} ENDNATIVE

NATIVE {_strdate} PROC
PROC _strdate(param1:PTR TO CHAR) IS NATIVE {_strdate(} param1 {)} ENDNATIVE !!PTR TO CHAR
NATIVE {_strtime} PROC
PROC _strtime(param1:PTR TO CHAR) IS NATIVE {_strtime(} param1 {)} ENDNATIVE !!PTR TO CHAR

/* These require newer versions of msvcrt.dll (6.10 or higher). */ 
/*
#if __MSVCRT_VERSION__ >= 0x0601
__time64_t  _time64( __time64_t*);
__time64_t  _mktime64 (struct tm*);
NATIVE {_ctime64} PROC
PROC _ctime64(param1:PTR TO TIME64_T) IS NATIVE {_ctime64(} param1 {)} ENDNATIVE !!PTR TO CHAR
NATIVE {_gmtime64} PROC
PROC _gmtime64(param1:PTR TO TIME64_T) IS NATIVE {_gmtime64(} param1 {)} ENDNATIVE !!PTR TO tm
NATIVE {_localtime64} PROC
PROC _localtime64(param1:PTR TO TIME64_T) IS NATIVE {_localtime64(} param1 {)} ENDNATIVE !!PTR TO tm
#endif /* __MSVCRT_VERSION__ >= 0x0601 */
*/

/*
 * _daylight: non zero if daylight savings time is used.
 * _timezone: difference in seconds between GMT and local time.
 * _tzname: standard/daylight savings time zone names (an array with two
 *          elements).
 */
/*
#ifdef __MSVCRT__

/* These are for compatibility with pre-VC 5.0 suppied MSVCRT. */
/*extern*/ NATIVE {__p__daylight} PROC
PROC __p__daylight() IS NATIVE {__p__daylight()} ENDNATIVE !!PTR TO VALUE
/*extern*/ NATIVE {__p__timezone} PROC
PROC __p__timezone() IS NATIVE {__p__timezone()} ENDNATIVE !!PTR TO VALUE
/*extern*/ NATIVE {__p__tzname} PROC
PROC __p__tzname() IS NATIVE {__p__tzname()} ENDNATIVE !!ARRAY OF ARRAY OF CHAR

__MINGW_IMPORT int	_daylight;
__MINGW_IMPORT long	_timezone;
__MINGW_IMPORT char 	*_tzname[2];

#else /* not __MSVCRT (ie. crtdll) */
*/

->#ifndef __DECLSPEC_SUPPORTED

NATIVE {_imp___daylight_dll} DEF ->_imp___daylight_dll:PTR TO NATIVE {int} VALUE	->extern int*	_imp___daylight_dll;
NATIVE {_imp___timezone_dll} DEF ->_imp___timezone_dll:PTR TO LONG				->extern long*	_imp___timezone_dll;
NATIVE {_imp___tzname}       DEF ->_imp___tzname:ARRAY OF ARRAY OF CHAR			->extern char**	_imp___tzname;

NATIVE {_daylight}	DEF ->_daylight	= (*_imp___daylight_dll)
NATIVE {_timezone}	DEF ->_timezone	= (*_imp___timezone_dll)
NATIVE {_tzname}		DEF ->_tzname		= (*_imp___tzname)

/*
#else /* __DECLSPEC_SUPPORTED */

__MINGW_IMPORT int	_daylight_dll;
__MINGW_IMPORT long	_timezone_dll;
__MINGW_IMPORT char*	_tzname[2];

NATIVE {_daylight}	DEF ->_daylight	= _daylight_dll
NATIVE {_timezone}	DEF ->_timezone	= _timezone_dll

#endif /* __DECLSPEC_SUPPORTED */
*/

->#endif /* not __MSVCRT__ */


/*
#ifdef __MSVCRT__

/* These go in the oldnames import library for MSVCRT. */
__MINGW_IMPORT int	daylight;
__MINGW_IMPORT long	timezone;
__MINGW_IMPORT char 	*tzname[2];

#else /* not __MSVCRT__ */
*/

/* CRTDLL is royally messed up when it comes to these macros.
   TODO: import and alias these via oldnames import library instead 
   of macros.  */

NATIVE {daylight}        DEF ->daylight        = _daylight
/* NOTE: timezone not defined because it would conflict with sys/timeb.h.
   Also, tzname used to a be macro, but now it's in moldname. */
NATIVE {tzname} DEF tzname[2]:ARRAY OF CHAR

->#endif /* not __MSVCRT__ */

->#endif	/* Not __STRICT_ANSI__ */

->#ifndef _WTIME_DEFINED
/* wide function prototypes, also declared in wchar.h */
->#ifndef __STRICT_ANSI__
/*
#ifdef __MSVCRT__
NATIVE {_wasctime} PROC
PROC _wasctime(param1:PTR TO tm) IS NATIVE {_wasctime(} param1 {)} ENDNATIVE !!PTR TO WCHAR_T
NATIVE {_wctime} PROC
PROC _wctime(param1:PTR TO TIME_T) IS NATIVE {_wctime(} param1 {)} ENDNATIVE !!PTR TO WCHAR_T
NATIVE {_wstrdate} PROC
PROC _wstrdate(param1:PTR TO WCHAR_T) IS NATIVE {_wstrdate(} param1 {)} ENDNATIVE !!PTR TO WCHAR_T
NATIVE {_wstrtime} PROC
PROC _wstrtime(param1:PTR TO WCHAR_T) IS NATIVE {_wstrtime(} param1 {)} ENDNATIVE !!PTR TO WCHAR_T
->#if __MSVCRT_VERSION__ >= 0x0601
NATIVE {_wctime64} PROC
PROC _wctime64(param1:PTR TO TIME64_T) IS NATIVE {_wctime64(} param1 {)} ENDNATIVE !!PTR TO WCHAR_T
->#endif
#endif /*  __MSVCRT__ */
*/
->#endif /* __STRICT_ANSI__ */
NATIVE {wcsftime} PROC
PROC wcsftime(param1:PTR TO WCHAR_T, param2:SIZE_T, param3:PTR TO WCHAR_T, param4:PTR TO tm) IS NATIVE {wcsftime(} param1 {,} param2 {, (const wchar_t*)} param3 {, (const struct tm*)} param4 {)} ENDNATIVE !!SIZE_T
NATIVE {_WTIME_DEFINED} DEF
->#endif /* _WTIME_DEFINED */ 
