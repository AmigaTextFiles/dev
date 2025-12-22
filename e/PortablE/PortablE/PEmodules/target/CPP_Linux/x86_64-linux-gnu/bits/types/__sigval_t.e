OPT NATIVE
{#include <x86_64-linux-gnu/bits/types/__sigval_t.h>}
/* Define __sigval_t.
   Copyright (C) 1997-2020 Free Software Foundation, Inc.
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

->NATIVE {____sigval_t_defined} DEF

/* Type for data associated with a signal.  */
NATIVE {sigval Union} OBJECT sigval
  {sival_int}	sival_int	:VALUE
  {sival_ptr}	sival_ptr	:PTR
ENDOBJECT


NATIVE {__sigval_t Union} OBJECT __sigval_t OF sigval
ENDOBJECT
