OPT NATIVE
MODULE 'std/pUnsigned'
{#include <x86_64-linux-gnu/bits/struct_rwlock.h>}
/* x86 internal rwlock struct definitions.
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

NATIVE {_RWLOCK_INTERNAL_H} DEF

NATIVE {__pthread_rwlock_arch_t} OBJECT __pthread_rwlock_arch_t
  {__readers}	__readers	:ULONG
  {__writers}	__writers	:ULONG
  {__wrphase_futex}	__wrphase_futex	:ULONG
  {__writers_futex}	__writers_futex	:ULONG
->  {__pad3}	__pad3	:ULONG
->  {__pad4}	__pad4	:ULONG
  {__cur_writer}	__cur_writer	:VALUE
  {__shared}	__shared	:VALUE
  {__rwelision}	__rwelision	:BYTE
->  {__pad1}	__pad1[7]	:ARRAY OF UBYTE
->  {__pad2}	__pad2	:UCLONG
  /* FLAGS must stay at this position in the structure to maintain
     binary compatibility.  */
  {__flags}	__flags	:ULONG
ENDOBJECT
  ->NATIVE {__PTHREAD_RWLOCK_ELISION_EXTRA} CONST __PTHREAD_RWLOCK_ELISION_EXTRA = 0, { 0, 0, 0, 0, 0, 0, 0 }

 ->NATIVE {__PTHREAD_RWLOCK_INITIALIZER} PROC	->define __PTHREAD_RWLOCK_INITIALIZER(__flags) 0, 0, 0, 0, 0, 0, 0, 0, __PTHREAD_RWLOCK_ELISION_EXTRA, 0, __flags
