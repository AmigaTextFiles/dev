OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/thread-shared-types'	->guessed
{#include <x86_64-linux-gnu/bits/struct_mutex.h>}
/* x86 internal mutex struct definitions.
   Copyright (C) 2019-2020 Free Software Foundation, Inc.
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
   <http://www.gnu.org/licenses/>.  */

NATIVE {_THREAD_MUTEX_INTERNAL_H} CONST ->_THREAD_MUTEX_INTERNAL_H = 1

NATIVE {__pthread_mutex_s} OBJECT __pthread_mutex_s
  {__lock}	__lock	:VALUE
  {__count}	__count	:ULONG
  {__owner}	__owner	:VALUE
  {__nusers}	__nusers	:ULONG
  /* KIND must stay at this position in the structure to maintain
     binary compatibility with static initializers.  */
  {__kind}	__kind	:VALUE
  {__spins}	__spins	:INT
  {__elision}	__elision	:INT
  {__list}	__list	:__pthread_list_t
ENDOBJECT
 ->NATIVE {__PTHREAD_MUTEX_HAVE_PREV} CONST       __PTHREAD_MUTEX_HAVE_PREV = 1

 ->NATIVE {__PTHREAD_MUTEX_INITIALIZER} PROC	->define __PTHREAD_MUTEX_INITIALIZER(__kind) 0, 0, 0, 0, __kind, 0, 0, { 0, 0 }
