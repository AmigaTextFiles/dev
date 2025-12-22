OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'	->guessed
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/types/time_t'
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/types/struct_timeval'
MODULE 'target/x86_64-linux-gnu/sys/select'
{#include <x86_64-linux-gnu/sys/time.h>}
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

NATIVE {_SYS_TIME_H}	CONST ->_SYS_TIME_H	= 1


->NATIVE {suseconds_t} OBJECT
->TYPE suseconds_t IS NATIVE {suseconds_t} SUSECONDS_T__
 ->NATIVE {__suseconds_t_defined} DEF


/* Macros for converting between `struct timeval' and `struct timespec'.  */
NATIVE {TIMEVAL_TO_TIMESPEC} CONST
PROC _TIMEVAL_TO_TIMESPEC(tv:PTR TO timeval, ts:PTR TO timespec)
	ts.sec  := tv.sec
	ts.nsec := tv.usec * 1000
ENDPROC
->#define TIMEVAL_TO_TIMESPEC(tv, ts) _TIMEVAL_TO_TIMESPEC(tv, ts)

NATIVE {TIMESPEC_TO_TIMEVAL} CONST
PROC _TIMESPEC_TO_TIMEVAL(tv:PTR TO timeval, ts:PTR TO timespec)
	tv.sec  := ts.sec
	tv.usec := ts.nsec / 1000
ENDPROC
->#define TIMESPEC_TO_TIMEVAL(tv, ts) _TIMESPEC_TO_TIMEVAL(tv, ts)


/* Structure crudely representing a timezone.
   This is obsolete and should never be used.  */
NATIVE {timezone} OBJECT timezone
    {tz_minuteswest}	minuteswest	:VALUE		/* Minutes west of GMT.  */
    {tz_dsttime}	dsttime	:VALUE		/* Nonzero if DST is ever in effect.  */
  ENDOBJECT

/* Get the current time of day, putting it into *TV.
   If TZ is not null, *TZ must be a struct timezone, and both fields
   will be set to zero.
   Calling this function with a non-null TZ is obsolete;
   use localtime etc. instead.
   This function itself is semi-obsolete;
   most callers should use time or clock_gettime instead. */
NATIVE {gettimeofday} PROC
PROC gettimeofday(__tv:PTR TO timeval,
			 __tz:PTR) IS NATIVE {gettimeofday(} __tv {,} __tz {)} ENDNATIVE !!VALUE

/* Set the current time of day and timezone information.
   This call is restricted to the super-user.
   Setting the timezone in this way is obsolete, but we don't yet
   warn about it because it still has some uses for which there is
   no alternative.  */
NATIVE {settimeofday} PROC
PROC settimeofday(__tv:PTR TO timeval,
			 __tz:PTR TO timezone) IS NATIVE {settimeofday(} __tv {,} __tz {)} ENDNATIVE !!VALUE

/* Adjust the current time of day by the amount in DELTA.
   If OLDDELTA is not NULL, it is filled in with the amount
   of time adjustment remaining to be done from the last `adjtime' call.
   This call is restricted to the super-user.  */
NATIVE {adjtime} PROC
PROC adjtime(__delta:PTR TO timeval,
		    __olddelta:PTR TO timeval) IS NATIVE {adjtime(} __delta {,} __olddelta {)} ENDNATIVE !!VALUE


/* Values for the first argument to `getitimer' and `setitimer'.  */
->NATIVE {__itimer_which} DEF
NATIVE {ITIMER_REAL} CONST ITIMER_REAL = 0
->#define ITIMER_REAL ITIMER_REAL
    /* Timers run only when the process is executing.  */
    NATIVE {ITIMER_VIRTUAL} CONST ITIMER_VIRTUAL = 1
->#define ITIMER_VIRTUAL ITIMER_VIRTUAL
    /* Timers run when the process is executing and when
       the system is executing on behalf of the process.  */
    NATIVE {ITIMER_PROF} CONST ITIMER_PROF = 2
->#define ITIMER_PROF ITIMER_PROF
  

/* Type of the second argument to `getitimer' and
   the second and third arguments `setitimer'.  */
NATIVE {itimerval} OBJECT itimerval
    /* Value to put into `it_value' when the timer expires.  */
    {it_interval}	interval	:timeval
    /* Time to the next timer expiration.  */
    {it_value}	value	:timeval
  ENDOBJECT

/* Use the nicer parameter type only in GNU mode and not for C++ since the
   strict C++ rules prevent the automatic promotion.  */
TYPE ITIMER_WHICH_T__ IS NATIVE {__itimer_which_t} VALUE

/* Set *VALUE to the current setting of timer WHICH.
   Return 0 on success, -1 on errors.  */
NATIVE {getitimer} PROC
PROC getitimer(__which:ITIMER_WHICH_T__,
		      __value:PTR TO itimerval) IS NATIVE {getitimer(} __which {,} __value {)} ENDNATIVE !!VALUE

/* Set the timer WHICH to *NEW.  If OLD is not NULL,
   set *OLD to the old value of timer WHICH.
   Returns 0 on success, -1 on errors.  */
NATIVE {setitimer} PROC
PROC setitimer(__which:ITIMER_WHICH_T__,
		      __new:PTR TO itimerval,
		      __old:PTR TO itimerval) IS NATIVE {setitimer(} __which {,} __new {,} __old {)} ENDNATIVE !!VALUE

/* Change the access time of FILE to TVP[0] and the modification time of
   FILE to TVP[1].  If TVP is a null pointer, use the current time instead.
   Returns 0 on success, -1 on errors.  */
NATIVE {utimes} PROC
PROC utimes(__file:ARRAY OF CHAR, __tvp:ARRAY OF timeval) IS NATIVE {utimes(} __file {,} __tvp {)} ENDNATIVE !!VALUE

/* Same as `utimes', but does not follow symbolic links.  */
NATIVE {lutimes} PROC
PROC lutimes(__file:ARRAY OF CHAR, __tvp:ARRAY OF timeval) IS NATIVE {lutimes(} __file {,} __tvp {)} ENDNATIVE !!VALUE

/* Same as `utimes', but takes an open file descriptor instead of a name.  */
NATIVE {futimes} PROC
PROC futimes(__fd:VALUE, __tvp:ARRAY OF timeval) IS NATIVE {futimes( (int) } __fd {,} __tvp {)} ENDNATIVE !!VALUE

/* Change the access time of FILE relative to FD to TVP[0] and the
   modification time of FILE to TVP[1].  If TVP is a null pointer, use
   the current time instead.  Returns 0 on success, -1 on errors.  */
NATIVE {futimesat} PROC
PROC futimesat(__fd:VALUE, __file:ARRAY OF CHAR,
		      __tvp:ARRAY OF timeval) IS NATIVE {futimesat( (int) } __fd {,} __file {,} __tvp {)} ENDNATIVE !!VALUE


/* Convenience macros for operations on timevals.
   NOTE: `timercmp' does not work for >= or <=.  */
 NATIVE {timerisset} PROC	->define timerisset(tvp)	((tvp)->tv_sec || (tvp)->tv_usec)
 NATIVE {timerclear} PROC	->define timerclear(tvp)	((tvp)->tv_sec = (tvp)->tv_usec = 0)
 NATIVE {timercmp} PROC	->define timercmp(a, b, CMP) 	( ((a)->tv_sec == (b)->tv_sec) ? ((a)->tv_usec CMP (b)->tv_usec) : ((a)->tv_sec CMP (b)->tv_sec) )

 NATIVE {timeradd} PROC	/*define timeradd(a, b, result) \
  do {									                \
    (result)->tv_sec = (a)->tv_sec + (b)->tv_sec;		\
    (result)->tv_usec = (a)->tv_usec + (b)->tv_usec;	\
    if ((result)->tv_usec >= 1000000)					\
      {									                \
	++(result)->tv_sec;						            \
	(result)->tv_usec -= 1000000;					    \
      }									                \
  } while (0)
  */
NATIVE {timersub} PROC	/*define timersub(a, b, result)	\
  do {									                \
    (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;		\
    (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;	\
    if ((result)->tv_usec < 0) {					    \
      --(result)->tv_sec;						        \
      (result)->tv_usec += 1000000;					    \
    }									                \
  } while (0)
  */
