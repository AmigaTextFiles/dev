OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
->{#include <x86_64-linux-gnu/bits/signal_ext.h>}
/* System-specific extensions of <signal.h>, Linux version.
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


/* Send SIGNAL to the thread TID in the thread group (process)
   identified by TGID.  This function behaves like kill, but also
   fails with ESRCH if the specified TID does not belong to the
   specified thread group.  */
NATIVE {tgkill} PROC
PROC tgkill(__tgid:PID_T__, __tid:PID_T__, __signal:VALUE) IS NATIVE {tgkill(} __tgid {,} __tid {, (int) } __signal {)} ENDNATIVE !!VALUE
