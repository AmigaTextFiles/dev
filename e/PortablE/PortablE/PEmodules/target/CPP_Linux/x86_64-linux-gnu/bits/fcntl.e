OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'		->guessed
/* Include generic Linux declarations.  */
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/fcntl-linux'
->{#include <x86_64-linux-gnu/bits/fcntl.h>}
/* O_*, F_*, FD_* bit values for Linux/x86.
   Copyright (C) 2001-2020 Free Software Foundation, Inc.
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

 ->NATIVE {__O_LARGEFILE}	CONST __O_LARGEFILE	= 0

/* Not necessary, we always have 64-bit offsets.  */
 NATIVE {F_GETLK64}	CONST F_GETLK64	= 5	/* Get record locking info.  */
 NATIVE {F_SETLK64}	CONST F_SETLK64	= 6	/* Set record locking info (non-blocking).  */
 NATIVE {F_SETLKW64}	CONST F_SETLKW64	= 7	/* Set record locking info (blocking).	*/


NATIVE {flock} OBJECT flock
    {l_type}	type	:INT	/* Type of lock: F_RDLCK, F_WRLCK, or F_UNLCK.	*/
    {l_whence}	whence	:INT	/* Where `l_start' is relative to (like `lseek').  */
    {l_start}	start	:OFF_T__	/* Offset where the lock begins.  */
    {l_len}	len	:OFF_T__	/* Size of the locked area; zero means until EOF.  */
    {l_pid}	pid	:PID_T__	/* Process holding the lock.  */
  ENDOBJECT

NATIVE {flock64} OBJECT flock64
    {l_type}	type	:INT	/* Type of lock: F_RDLCK, F_WRLCK, or F_UNLCK.	*/
    {l_whence}	whence	:INT	/* Where `l_start' is relative to (like `lseek').  */
    {l_start}	start	:OFF64_T__	/* Offset where the lock begins.  */
    {l_len}	len	:OFF64_T__	/* Size of the locked area; zero means until EOF.  */
    {l_pid}	pid	:PID_T__	/* Process holding the lock.  */
  ENDOBJECT
