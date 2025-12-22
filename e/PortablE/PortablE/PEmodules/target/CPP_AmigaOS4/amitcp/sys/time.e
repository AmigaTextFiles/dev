/* newlib/include/sys/time.h */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/devices/timer'
{#include <sys/time.h>}

ENUM DST_NONE, DST_USA, DST_AUST, DST_WET, DST_MET, DST_EET, DST_CAN


/* time.h -- An implementation of the standard Unix <sys/time.h> file.
   Written by Geoffrey Noer <noer@cygnus.com>
   Public domain; no rights reserved. */

NATIVE {_SYS_TIME_H_} DEF

NATIVE {timezone} OBJECT timezone
	{tz_minuteswest}	minuteswest:VALUE
	{tz_dsttime}		dsttime:VALUE
ENDOBJECT

NATIVE {ITIMER_REAL}     CONST ITIMER_REAL     = 0
NATIVE {ITIMER_VIRTUAL}  CONST ITIMER_VIRTUAL  = 1
NATIVE {ITIMER_PROF}     CONST ITIMER_PROF     = 2

NATIVE {itimerval} OBJECT itimerval
  {it_interval}	interval	:timeval
  {it_value}	value		:timeval
ENDOBJECT

/* BSD time macros used by RTEMS code */

/* Convenience macros for operations on timevals.
   NOTE: `timercmp' does not work for >= or <=.  */
NATIVE {timerisset} PROC
PROC timerisset(tvp:PTR TO timeval) IS NATIVE {timerisset(} tvp {)} ENDNATIVE !!VALUE
NATIVE {timerclear} PROC
PROC timerclear(tvp:PTR TO timeval) IS NATIVE {timerclear(} tvp {)} ENDNATIVE
NATIVE {timercmp} PROC
#define timercmp(a, b, cmp) (IF (a).secs = (b).secs THEN (a).micro cmp (b).micro ELSE (a).secs cmp (b).secs)
NATIVE {timeradd} PROC
PROC timeradd(a, b, result) IS NATIVE {timeradd(} a {,} b {,} result {)} ENDNATIVE
NATIVE {timersub} PROC
PROC timersub(a, b, result) IS NATIVE {timersub(} a {,} b {,} result {)} ENDNATIVE

NATIVE {gettimeofday} PROC
PROC gettimeofday(p:PTR TO timeval, z:PTR TO timezone) IS NATIVE {gettimeofday(} p {,} z {)} ENDNATIVE !!VALUE
NATIVE {settimeofday} PROC
PROC settimeofday(param1:PTR TO timeval, param2:PTR TO timezone) IS NATIVE {settimeofday(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {utimes} PROC
PROC utimes(path:PTR TO CHAR, tvp:PTR TO timeval) IS NATIVE {utimes(} path {,} tvp {)} ENDNATIVE !!VALUE
NATIVE {getitimer} PROC
PROC getitimer(which:VALUE, value:PTR TO itimerval) IS NATIVE {getitimer( (int) } which {,} value {)} ENDNATIVE !!VALUE
NATIVE {setitimer} PROC
PROC setitimer(which:VALUE, value:PTR TO itimerval, ovalue:PTR TO itimerval) IS NATIVE {setitimer( (int) } which {,} value {,} ovalue {)} ENDNATIVE !!VALUE
