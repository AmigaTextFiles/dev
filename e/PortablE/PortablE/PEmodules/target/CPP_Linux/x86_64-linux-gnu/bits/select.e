OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
->{#include <x86_64-linux-gnu/bits/select.h>}
/* Copyright (C) 1997-2020 Free Software Foundation, Inc.
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

  ->NATIVE {__FD_ZERO_STOS} CONST __FD_ZERO_STOS = 'stosq'

 ->NATIVE {__FD_ZERO} PROC	->define __FD_ZERO(set)
/* We don't use `memset' because this would require a prototype and
   the array isn't too big.  */
/*
# define __FD_ZERO(set)  \
  do {									      \
    unsigned int __i;							      \
    fd_set *__arr = (set);						      \
    for (__i = 0; __i < sizeof (fd_set) / sizeof (__fd_mask); ++__i)	      \
      __FDS_BITS (__arr)[__i] = 0;					      \
  } while (0)
*/

->NATIVE {__FD_SET} PROC	->define __FD_SET(d, set) ((void) (__FDS_BITS (set)[__FD_ELT (d)] |= __FD_MASK (d)))
->NATIVE {__FD_CLR} PROC	->define __FD_CLR(d, set) ((void) (__FDS_BITS (set)[__FD_ELT (d)] &= ~__FD_MASK (d)))
->NATIVE {__FD_ISSET} PROC	->define __FD_ISSET(d, set) ((__FDS_BITS (set)[__FD_ELT (d)] & __FD_MASK (d)) != 0
