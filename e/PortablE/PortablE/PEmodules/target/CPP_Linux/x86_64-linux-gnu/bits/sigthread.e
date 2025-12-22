OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/pthreadtypes'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/types/__sigval_t'	->guessed
/* Functions for handling signals. */
MODULE 'target/x86_64-linux-gnu/bits/types/__sigset_t'
->{#include <x86_64-linux-gnu/bits/sigthread.h>}
/* Signal handling function for threaded programs.
   Copyright (C) 1998-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If
   not, see <https://www.gnu.org/licenses/>.  */

NATIVE {_BITS_SIGTHREAD_H}	CONST ->_BITS_SIGTHREAD_H	= 1

/* Modify the signal mask for the calling thread.  The arguments have
   the same meaning as for sigprocmask(2). */
NATIVE {pthread_sigmask} PROC
->PROC pthread_sigmask(__how:VALUE, __newmask:PTR TO __sigset_t, __oldmask:PTR TO __sigset_t) IS NATIVE {pthread_sigmask( (int) } __how {,} __newmask {,} __oldmask {)} ENDNATIVE !!VALUE

/* Send signal SIGNO to the given thread. */
NATIVE {pthread_kill} PROC
->PROC pthread_kill(__threadid:PTHREAD_T, __signo:VALUE) IS NATIVE {pthread_kill(} __threadid {, (int) } __signo {)} ENDNATIVE !!VALUE

/* Queue signal and data to a thread.  */
NATIVE {pthread_sigqueue} PROC
->PROC pthread_sigqueue(__threadid:PTHREAD_T, __signo:VALUE, __value:PTR TO sigval) IS NATIVE {pthread_sigqueue(} __threadid {, (int) } __signo {, *} __value {)} ENDNATIVE !!VALUE
