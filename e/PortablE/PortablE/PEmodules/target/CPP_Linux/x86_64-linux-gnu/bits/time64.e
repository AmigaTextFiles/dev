OPT NATIVE
->{#include <x86_64-linux-gnu/bits/time64.h>}
/* bits/time64.h -- underlying types for __time64_t.  Generic version.
   Copyright (C) 2018-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_TIME64_H}	CONST ->_BITS_TIME64_H	= 1

/* Define __TIME64_T_TYPE so that it is always a 64-bit type.  */

/* If we already have 64-bit time type then use it.  */
 ->NATIVE {__TIME64_T_TYPE}		CONST __TIME64_T_TYPE		= TIME_T_TYPE__
