OPT NATIVE
MODULE 'target/features'
/* The system-specific definitions of the E* constants, as macros.  */
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/errno'
MODULE 'target/x86_64-linux-gnu/bits/types/error_t'
{#include <errno.h>}
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
 *	ISO C99 Standard: 7.5 Errors	<errno.h>
 */

NATIVE {_ERRNO_H} CONST ->_ERRNO_H = 1


/* When included from assembly language, this header only provides the
   E* constants.  */

/* The error code set by various library functions.  */
->NATIVE {__errno_location} PROC
PROC __errno_location() IS NATIVE {__errno_location()} ENDNATIVE !!PTR TO LONG
 NATIVE {errno} DEF errno -> = (*__errno_location ())


/* The full and simple forms of the name with which the program was
   invoked.  These variables are set up automatically at startup based on
   the value of argv[0].  */
NATIVE {program_invocation_name} DEF
NATIVE {program_invocation_short_name} DEF
