OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/timex'
{#include <x86_64-linux-gnu/bits/time.h>}
/* System-dependent timing definitions.  Linux version.
   Copyright (C) 1996-2020 Free Software Foundation, Inc.
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
 * Never include this file directly; use <time.h> instead.
 */

NATIVE {_BITS_TIME_H}	CONST ->_BITS_TIME_H	= 1

/* ISO/IEC 9899:1999 7.23.1: Components of time
   The macro `CLOCKS_PER_SEC' is an expression with type `CLOCK_T' that is
   the number per second of the value returned by the `clock' function.  */
/* CAE XSH, Issue 4, Version 2: <time.h>
   The value of CLOCKS_PER_SEC is required to be 1 million on all
   XSI-conformant systems. */
NATIVE {CLOCKS_PER_SEC}  CONST CLOCKS_PER_SEC  = 1000000 !!CLOCK_T__

/*
#if (!defined __STRICT_ANSI__ || defined __USE_POSIX) && !defined __USE_XOPEN2K
/* Even though CLOCKS_PER_SEC has such a strange value CLK_TCK
   presents the real value for clock ticks per second for the system.  */
->NATIVE {__sysconf} PROC
PROC __sysconf(param1:VALUE) IS NATIVE {__sysconf( (int) } param1 {)} ENDNATIVE !!CLONG

NATIVE {CLK_TCK} CONST
#define CLK_TCK __sysconf(2) !!CLOCK_T__	/* 2 is _SC_CLK_TCK */
#endif
*/

/* Identifier for system-wide realtime clock.  */
 NATIVE {CLOCK_REALTIME}			CONST CLOCK_REALTIME			= 0
/* Monotonic system-wide clock.  */
 NATIVE {CLOCK_MONOTONIC}		CONST CLOCK_MONOTONIC		= 1
/* High-resolution timer from the CPU.  */
 NATIVE {CLOCK_PROCESS_CPUTIME_ID}	CONST CLOCK_PROCESS_CPUTIME_ID	= 2
/* Thread-specific CPU-time clock.  */
 NATIVE {CLOCK_THREAD_CPUTIME_ID}	CONST CLOCK_THREAD_CPUTIME_ID	= 3
/* Monotonic system-wide clock, not adjusted for frequency scaling.  */
 NATIVE {CLOCK_MONOTONIC_RAW}		CONST CLOCK_MONOTONIC_RAW		= 4
/* Identifier for system-wide realtime clock, updated only on ticks.  */
 NATIVE {CLOCK_REALTIME_COARSE}		CONST CLOCK_REALTIME_COARSE		= 5
/* Monotonic system-wide clock, updated only on ticks.  */
 NATIVE {CLOCK_MONOTONIC_COARSE}		CONST CLOCK_MONOTONIC_COARSE		= 6
/* Monotonic system-wide clock that includes time spent in suspension.  */
 NATIVE {CLOCK_BOOTTIME}			CONST CLOCK_BOOTTIME			= 7
/* Like CLOCK_REALTIME but also wakes suspended system.  */
 NATIVE {CLOCK_REALTIME_ALARM}		CONST CLOCK_REALTIME_ALARM		= 8
/* Like CLOCK_BOOTTIME but also wakes suspended system.  */
 NATIVE {CLOCK_BOOTTIME_ALARM}		CONST CLOCK_BOOTTIME_ALARM		= 9
/* Like CLOCK_REALTIME but in International Atomic Time.  */
 NATIVE {CLOCK_TAI}			CONST CLOCK_TAI			= 11

/* Flag to indicate time is absolute.  */
 NATIVE {TIMER_ABSTIME}			CONST TIMER_ABSTIME			= 1


/* Tune a POSIX clock.  */
NATIVE {clock_adjtime} PROC
PROC clock_adjtime(__clock_id:CLOCKID_T__, __utx:PTR TO timex) IS NATIVE {clock_adjtime(} __clock_id {,} __utx {)} ENDNATIVE !!VALUE
