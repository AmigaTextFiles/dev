OPT NATIVE
MODULE 'target/stddef', 'target/x86_64-linux-gnu/bits/types'	->guessed
->{#include <x86_64-linux-gnu/bits/dirent_ext.h>}
/* System-specific extensions of <dirent.h>.  Linux version.
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
   <https://www.gnu.org/licenses/>.  */

/* Read from the directory descriptor FD into LENGTH bytes at BUFFER.
   Return the number of bytes read on success (0 for end of
   directory), and -1 for failure.  */
NATIVE {getdents64} PROC
PROC getdents64(__fd:VALUE, __buffer:PTR, __length:SIZE_T) IS NATIVE {getdents64( (int) } __fd {,} __buffer {,} __length {)} ENDNATIVE !!SSIZE_T__
