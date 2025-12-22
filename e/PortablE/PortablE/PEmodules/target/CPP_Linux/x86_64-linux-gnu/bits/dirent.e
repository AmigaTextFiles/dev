OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/types'	->guess
->{#include <x86_64-linux-gnu/bits/dirent.h>}
/* Copyright (C) 1996-2020 Free Software Foundation, Inc.
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

NATIVE {dirent} OBJECT dirent
    {d_ino}	ino	:INO_T__
    {d_off}	off	:OFF_T__
    {d_reclen}	reclen	:UINT
    {d_type}	type	:UBYTE
    {d_name}	name[256]	:ARRAY OF CHAR		/* We must not include limits.h! */
  ENDOBJECT

NATIVE {dirent64} OBJECT dirent64
    {d_ino}	ino	:INO64_T__
    {d_off}	off	:OFF64_T__
    {d_reclen}	reclen	:UINT
    {d_type}	type	:UBYTE
    {d_name}	name[256]	:ARRAY OF CHAR		/* We must not include limits.h! */
  ENDOBJECT

NATIVE {d_fileno}	CONST /* Backwards compatibility.  */

NATIVE {_DIRENT_HAVE_D_RECLEN} DEF
NATIVE {_DIRENT_HAVE_D_OFF} DEF
NATIVE {_DIRENT_HAVE_D_TYPE} DEF

->#if defined __OFF_T_MATCHES_OFF64_T && defined __INO_T_MATCHES_INO64_T
/* Inform libc code that these two types are effectively identical.  */
 NATIVE {_DIRENT_MATCHES_DIRENT64}	CONST ->_DIRENT_MATCHES_DIRENT64	= 1
->#else
-> NATIVE {_DIRENT_MATCHES_DIRENT64}	CONST ->_DIRENT_MATCHES_DIRENT64	= 0
->#endif
