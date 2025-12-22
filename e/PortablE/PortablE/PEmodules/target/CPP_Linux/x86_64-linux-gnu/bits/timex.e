OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/types/struct_timeval'
{#include <x86_64-linux-gnu/bits/timex.h>}
/* Copyright (C) 1995-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_TIMEX_H}	CONST ->_BITS_TIMEX_H	= 1

/* These definitions from linux/timex.h as of 3.18.  */

NATIVE {timex} OBJECT timex
  {modes}	modes	:ULONG		/* mode selector */
  {offset}	offset	:SYSCALL_SLONG_T__	/* time offset (usec) */
  {freq}	freq	:SYSCALL_SLONG_T__	/* frequency offset (scaled ppm) */
  {maxerror}	maxerror	:SYSCALL_SLONG_T__	/* maximum error (usec) */
  {esterror}	esterror	:SYSCALL_SLONG_T__	/* estimated error (usec) */
  {status}	status	:VALUE			/* clock command/status */
  {constant}	constant	:SYSCALL_SLONG_T__	/* pll time constant */
  {precision}	precision	:SYSCALL_SLONG_T__	/* clock precision (usec) (ro) */
  {tolerance}	tolerance	:SYSCALL_SLONG_T__	/* clock frequency tolerance (ppm) (ro) */
  {time}	time	:timeval		/* (read only, except for ADJ_SETOFFSET) */
  {tick}	tick	:SYSCALL_SLONG_T__	/* (modified) usecs between clock ticks */
  {ppsfreq}	ppsfreq	:SYSCALL_SLONG_T__	/* pps frequency (scaled ppm) (ro) */
  {jitter}	jitter	:SYSCALL_SLONG_T__	/* pps jitter (us) (ro) */
  {shift}	shift	:VALUE			/* interval duration (s) (shift) (ro) */
  {stabil}	stabil	:SYSCALL_SLONG_T__	/* pps stability (scaled ppm) (ro) */
  {jitcnt}	jitcnt	:SYSCALL_SLONG_T__	/* jitter limit exceeded (ro) */
  {calcnt}	calcnt	:SYSCALL_SLONG_T__	/* calibration intervals (ro) */
  {errcnt}	errcnt	:SYSCALL_SLONG_T__	/* calibration errors (ro) */
  {stbcnt}	stbcnt	:SYSCALL_SLONG_T__	/* stability limit exceeded (ro) */

  {tai}	tai	:VALUE			/* TAI offset (ro) */

  /* ??? */
  ->int  :32; int  :32; int  :32; int  :32;
  ->int  :32; int  :32; int  :32; int  :32;
  ->int  :32; int  :32; int  :32;
ENDOBJECT

/* Mode codes (timex.mode) */
NATIVE {ADJ_OFFSET}		CONST ADJ_OFFSET		= $0001	/* time offset */
NATIVE {ADJ_FREQUENCY}		CONST ADJ_FREQUENCY		= $0002	/* frequency offset */
NATIVE {ADJ_MAXERROR}		CONST ADJ_MAXERROR		= $0004	/* maximum time error */
NATIVE {ADJ_ESTERROR}		CONST ADJ_ESTERROR		= $0008	/* estimated time error */
NATIVE {ADJ_STATUS}		CONST ADJ_STATUS		= $0010	/* clock status */
NATIVE {ADJ_TIMECONST}		CONST ADJ_TIMECONST		= $0020	/* pll time constant */
NATIVE {ADJ_TAI}			CONST ADJ_TAI			= $0080	/* set TAI offset */
NATIVE {ADJ_SETOFFSET}		CONST ADJ_SETOFFSET		= $0100	/* add 'time' to current time */
NATIVE {ADJ_MICRO}		CONST ADJ_MICRO		= $1000	/* select microsecond resolution */
NATIVE {ADJ_NANO}		CONST ADJ_NANO		= $2000	/* select nanosecond resolution */
NATIVE {ADJ_TICK}		CONST ADJ_TICK		= $4000	/* tick value */
NATIVE {ADJ_OFFSET_SINGLESHOT}	CONST ADJ_OFFSET_SINGLESHOT	= $8001	/* old-fashioned adjtime */
NATIVE {ADJ_OFFSET_SS_READ}	CONST ADJ_OFFSET_SS_READ	= $a001	/* read-only adjtime */

/* xntp 3.4 compatibility names */
NATIVE {MOD_OFFSET}	CONST MOD_OFFSET	= ADJ_OFFSET
NATIVE {MOD_FREQUENCY}	CONST MOD_FREQUENCY	= ADJ_FREQUENCY
NATIVE {MOD_MAXERROR}	CONST MOD_MAXERROR	= ADJ_MAXERROR
NATIVE {MOD_ESTERROR}	CONST MOD_ESTERROR	= ADJ_ESTERROR
NATIVE {MOD_STATUS}	CONST MOD_STATUS	= ADJ_STATUS
NATIVE {MOD_TIMECONST}	CONST MOD_TIMECONST	= ADJ_TIMECONST
NATIVE {MOD_CLKB}	CONST MOD_CLKB	= ADJ_TICK
NATIVE {MOD_CLKA}	CONST MOD_CLKA	= ADJ_OFFSET_SINGLESHOT /* 0x8000 in original */
NATIVE {MOD_TAI}		CONST MOD_TAI		= ADJ_TAI
NATIVE {MOD_MICRO}	CONST MOD_MICRO	= ADJ_MICRO
NATIVE {MOD_NANO}	CONST MOD_NANO	= ADJ_NANO


/* Status codes (timex.status) */
NATIVE {STA_PLL}		CONST STA_PLL		= $0001	/* enable PLL updates (rw) */
NATIVE {STA_PPSFREQ}	CONST STA_PPSFREQ	= $0002	/* enable PPS freq discipline (rw) */
NATIVE {STA_PPSTIME}	CONST STA_PPSTIME	= $0004	/* enable PPS time discipline (rw) */
NATIVE {STA_FLL}		CONST STA_FLL		= $0008	/* select frequency-lock mode (rw) */

NATIVE {STA_INS}		CONST STA_INS		= $0010	/* insert leap (rw) */
NATIVE {STA_DEL}		CONST STA_DEL		= $0020	/* delete leap (rw) */
NATIVE {STA_UNSYNC}	CONST STA_UNSYNC	= $0040	/* clock unsynchronized (rw) */
NATIVE {STA_FREQHOLD}	CONST STA_FREQHOLD	= $0080	/* hold frequency (rw) */

NATIVE {STA_PPSSIGNAL}	CONST STA_PPSSIGNAL	= $0100	/* PPS signal present (ro) */
NATIVE {STA_PPSJITTER}	CONST STA_PPSJITTER	= $0200	/* PPS signal jitter exceeded (ro) */
NATIVE {STA_PPSWANDER}	CONST STA_PPSWANDER	= $0400	/* PPS signal wander exceeded (ro) */
NATIVE {STA_PPSERROR}	CONST STA_PPSERROR	= $0800	/* PPS signal calibration error (ro) */

NATIVE {STA_CLOCKERR}	CONST STA_CLOCKERR	= $1000	/* clock hardware fault (ro) */
NATIVE {STA_NANO}	CONST STA_NANO	= $2000	/* resolution (0 = us, 1 = ns) (ro) */
NATIVE {STA_MODE}	CONST STA_MODE	= $4000	/* mode (0 = PLL, 1 = FLL) (ro) */
NATIVE {STA_CLK}		CONST STA_CLK		= $8000	/* clock source (0 = A, 1 = B) (ro) */

/* Read-only bits */
NATIVE {STA_RONLY} CONST STA_RONLY = (STA_PPSSIGNAL OR STA_PPSJITTER OR STA_PPSWANDER OR STA_PPSERROR OR STA_CLOCKERR OR STA_NANO OR STA_MODE OR STA_CLK)
