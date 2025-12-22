OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
->{#include <x86_64-linux-gnu/bits/unistd_ext.h>}
/* System-specific extensions of <unistd.h>, Linux version.
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

/* Return the kernel thread ID (TID) of the current thread.  The
   returned value is not subject to caching.  Most Linux system calls
   accept a TID in place of a PID.  Using the TID to change properties
   of a thread that has been created using pthread_create can lead to
   undefined behavior (comparable to manipulating file descriptors
   directly that have not been created explicitly).  Note that a TID
   uniquely identifies a thread only while this thread is running; a
   TID can be reused once a thread has exited, even if the thread is
   not detached and has not been joined.  */
NATIVE {gettid} PROC
PROC gettid() IS NATIVE {gettid()} ENDNATIVE !!PID_T__
