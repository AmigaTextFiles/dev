OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/pthreadtypes-arch'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/struct_mutex'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/struct_rwlock'	->guessed
/* For internal mutex and condition variable definitions.  */
MODULE 'target/x86_64-linux-gnu/bits/thread-shared-types'
{#include <x86_64-linux-gnu/bits/pthreadtypes.h>}
/* Declaration of common pthread types for all architectures.
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

 NATIVE {_BITS_PTHREADTYPES_COMMON_H}	CONST ->_BITS_PTHREADTYPES_COMMON_H	= 1

/* Thread identifiers.  The structure of the attribute type is not
   exposed on purpose.  */
NATIVE {pthread_t} OBJECT
TYPE PTHREAD_T IS NATIVE {pthread_t} UCLONG


/* Data structures for mutex handling.  The structure of the attribute
   type is not exposed on purpose.  */
NATIVE {pthread_mutexattr_t} OBJECT pthread_mutexattr_t
  {__size}	__size[SIZEOF_PTHREAD_MUTEXATTR_T__]	:ARRAY OF CHAR
  {__align}	__align	:VALUE
ENDOBJECT 


/* Data structure for condition variable handling.  The structure of
   the attribute type is not exposed on purpose.  */
NATIVE {pthread_condattr_t} OBJECT pthread_condattr_t
  {__size}	__size[SIZEOF_PTHREAD_CONDATTR_T__]	:ARRAY OF CHAR
  {__align}	__align	:VALUE
ENDOBJECT 


/* Keys for thread-specific data */
NATIVE {pthread_key_t} OBJECT
->TYPE pthread_key_t IS NATIVE {pthread_key_t} ULONG


/* Once-only execution */
NATIVE {pthread_once_t} OBJECT
->TYPE pthread_once_t IS NATIVE {pthread_once_t} INT


NATIVE {pthread_attr_t} OBJECT pthread_attr_t
  {__size}	__size[SIZEOF_PTHREAD_ATTR_T__]	:ARRAY OF CHAR
  {__align}	__align	:CLONG
ENDOBJECT
->NATIVE {pthread_attr_t} OBJECT
->TYPE pthread_attr_t IS NATIVE {pthread_attr_t} pthread_attr_t
 ->NATIVE {__have_pthread_attr_t} CONST __HAVE_PTHREAD_ATTR_T = 1


NATIVE {pthread_mutex_t} OBJECT pthread_mutex_t
  {__data}	__data	:__pthread_mutex_s
  {__size}	__size[SIZEOF_PTHREAD_MUTEX_T__]	:ARRAY OF CHAR
  {__align}	__align	:CLONG
ENDOBJECT 


NATIVE {pthread_cond_t} OBJECT pthread_cond_t
  {__data}	__data	:__pthread_cond_s
  {__size}	__size[SIZEOF_PTHREAD_COND_T__]	:ARRAY OF CHAR
  {__align}	__align	:BIGVALUE
ENDOBJECT 


/* Data structure for reader-writer lock variable handling.  The
   structure of the attribute type is deliberately not exposed.  */
NATIVE {pthread_rwlock_t} OBJECT pthread_rwlock_t
  {__data}	__data	:__pthread_rwlock_arch_t
  {__size}	__size[SIZEOF_PTHREAD_RWLOCK_T__]	:ARRAY OF CHAR
  {__align}	__align	:CLONG
ENDOBJECT 

NATIVE {pthread_rwlockattr_t} OBJECT pthread_rwlockattr_t
  {__size}	__size[SIZEOF_PTHREAD_RWLOCKATTR_T__]	:ARRAY OF CHAR
  {__align}	__align	:CLONG
ENDOBJECT 


/* POSIX spinlock data type.  */
NATIVE {pthread_spinlock_t} OBJECT
->TYPE pthread_spinlock_t IS NATIVE {pthread_spinlock_t} INT


/* POSIX barriers data type.  The structure of the type is
   deliberately not exposed.  */
NATIVE {pthread_barrier_t} OBJECT pthread_barrier_t
  {__size}	__size[SIZEOF_PTHREAD_BARRIER_T__]	:ARRAY OF CHAR
  {__align}	__align	:CLONG
ENDOBJECT 

NATIVE {pthread_barrierattr_t} OBJECT pthread_barrierattr_t
  {__size}	__size[SIZEOF_PTHREAD_BARRIERATTR_T__]	:ARRAY OF CHAR
  {__align}	__align	:VALUE
ENDOBJECT 