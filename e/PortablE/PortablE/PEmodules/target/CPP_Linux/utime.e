OPT NATIVE
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
 MODULE 'target/x86_64-linux-gnu/bits/types/time_t'
{#include <utime.h>}
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
 *	POSIX Standard: 5.6.6 Set File Access and Modification Times  <utime.h>
 */

NATIVE {_UTIME_H}	CONST ->_UTIME_H	= 1


/* Structure describing file times.  */
NATIVE {utimbuf} OBJECT utimbuf
    {actime}	actime	:TIME_T__		/* Access time.  */
    {modtime}	modtime	:TIME_T__		/* Modification time.  */
  ENDOBJECT

/* Set the access and modification times of FILE to those given in
   *FILE_TIMES.  If FILE_TIMES is NULL, set them to the current time.  */
NATIVE {utime} PROC
PROC utime(__file:ARRAY OF CHAR,
		  __file_times:PTR TO utimbuf) IS NATIVE {utime(} __file {,} __file_times {)} ENDNATIVE !!VALUE
