OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types/__locale_t'
{#include <x86_64-linux-gnu/bits/types/locale_t.h>}
/* Definition of locale_t.
   Copyright (C) 2017-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_TYPES_LOCALE_T_H} CONST ->_BITS_TYPES_LOCALE_T_H = 1

NATIVE {locale_t} OBJECT
TYPE LOCALE_T IS NATIVE {locale_t} LOCALE_T__
