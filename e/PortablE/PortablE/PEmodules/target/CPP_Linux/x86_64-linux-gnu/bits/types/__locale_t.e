OPT NATIVE
MODULE 'std/pUnsigned'
{#include <x86_64-linux-gnu/bits/types/__locale_t.h>}
/* Definition of struct __locale_struct and __locale_t.
   Copyright (C) 1997-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1997.

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

NATIVE {_BITS_TYPES___LOCALE_T_H} CONST ->_BITS_TYPES___LOCALE_T_H = 1

/* POSIX.1-2008: the LOCALE_T type, representing a locale context
   (implementation-namespace version).  This type should be treated
   as opaque by applications; some details are exposed for the sake of
   efficiency in e.g. ctype functions.  */

NATIVE {__locale_struct} OBJECT __locale_struct
  /* Note: LC_ALL is not a valid index into this array.  */
  {__locales}	__locales[13]	:ARRAY OF PTR /*TO __locale_data*/ /* 13 = __LC_LAST. */		->"__locale_data" maybe defined in "glibc/locale/localeinfo.h"

  /* To increase the speed of this solution we add some special members.  */
  {__ctype_b}	__ctype_b	:PTR TO UINT
  {__ctype_tolower}	__ctype_tolower	:PTR TO VALUE
  {__ctype_toupper}	__ctype_toupper	:PTR TO VALUE

  /* Note: LC_ALL is not a valid index into this array.  */
  {__names}	__names[13]	:ARRAY OF ARRAY OF CHAR
ENDOBJECT


TYPE LOCALE_T__ IS NATIVE {__locale_t} PTR TO __locale_struct
