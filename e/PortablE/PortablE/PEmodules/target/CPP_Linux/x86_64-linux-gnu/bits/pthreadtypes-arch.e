OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
{#include <x86_64-linux-gnu/bits/pthreadtypes-arch.h>}
/* Copyright (C) 2002-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_PTHREADTYPES_ARCH_H}	CONST ->_BITS_PTHREADTYPES_ARCH_H	= 1

  NATIVE {__SIZEOF_PTHREAD_MUTEX_T} CONST SIZEOF_PTHREAD_MUTEX_T__ = 40
  NATIVE {__SIZEOF_PTHREAD_ATTR_T} CONST SIZEOF_PTHREAD_ATTR_T__ = 56
  NATIVE {__SIZEOF_PTHREAD_RWLOCK_T} CONST SIZEOF_PTHREAD_RWLOCK_T__ = 56
  NATIVE {__SIZEOF_PTHREAD_BARRIER_T} CONST SIZEOF_PTHREAD_BARRIER_T__ = 32
NATIVE {__SIZEOF_PTHREAD_MUTEXATTR_T} CONST SIZEOF_PTHREAD_MUTEXATTR_T__ = 4
NATIVE {__SIZEOF_PTHREAD_COND_T} CONST SIZEOF_PTHREAD_COND_T__ = 48
NATIVE {__SIZEOF_PTHREAD_CONDATTR_T} CONST SIZEOF_PTHREAD_CONDATTR_T__ = 4
NATIVE {__SIZEOF_PTHREAD_RWLOCKATTR_T} CONST SIZEOF_PTHREAD_RWLOCKATTR_T__ = 8
NATIVE {__SIZEOF_PTHREAD_BARRIERATTR_T} CONST SIZEOF_PTHREAD_BARRIERATTR_T__ = 4

->NATIVE {__LOCK_ALIGNMENT} DEF
->NATIVE {__ONCE_ALIGNMENT} DEF

/*
#ifndef __x86_64__
/* Extra attributes for the cleanup functions.  */
 ->NATIVE {__cleanup_fct_attribute} CONST __CLEANUP_FCT_ATTRIBUTE = __attribute__ ((__regparm__ (1)))
#endif
*/
